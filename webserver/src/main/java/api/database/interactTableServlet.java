package api.database;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.SQLIntegrityConstraintViolationException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashSet;
import java.util.List;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.fasterxml.jackson.databind.ObjectMapper;

import util.DatabaseConnect;
import util.JwtGenerate;

import javax.servlet.annotation.WebServlet;

/**
 * GET, PUT, POST, DELETE Database
 * @author Le Hai Yen, Le Nguyen Phan Long, Nguyen Ba Le
 */
@WebServlet(urlPatterns = "/database/interactTable")
public class interactTableServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private PreparedStatement createStatement(HttpServletRequest req, String action, Connection conn, String permissionList) throws Exception {
        String[] params = null;
        String query = "";
        int i;
        List<String> tableNameList = Arrays.asList("year_faculty", "year_fac_pro", "year_fac_pro_mo", "class",
                "teaching", "semester", "aca_year", "lecturer", "module", "program", "faculty");

        String tableName = req.getParameter("table_name");
        if (!tableNameList.contains(tableName)) 
            throw new Exception("Invalid Table Name");

        if (tableName.equals("year_faculty")) {
            query = "{CALL " + tableName + "Interact(\"" + action + "\", ?, ?, ?, ?)}";
            params = new String[] { "old_key", "a_code", "f_code" };
        } else if (tableName.equals("year_fac_pro")) {
            query = "CALL " + tableName + "Interact(\"" + action + "\", ?, ?, ?, ?);";
            params = new String[] { "old_key", "id", "code" };
        } else if (tableName.equals("year_fac_pro_mo")) {
            query = "CALL " + tableName + "Interact(\"" + action + "\", ?, ?, ?, ?);";
            params = new String[] { "old_key", "id", "code" };
        } else if (tableName.equals("class")) {
            query = "CALL " + tableName + "Interact(\"" + action + "\", ?, ?, ?, ?, ?);";
            params = new String[] { "old_key", "size", "code", "id" };
        } else if (tableName.equals("teaching")) {
            query = "CALL " + tableName + "Interact(\"" + action + "\", ?, ?, ?, ?);";
            params = new String[] { "old_key", "c_code", "lec_code" };
        } else if (tableName.equals("semester")) {
            query = "CALL " + tableName + "Interact(\"" + action + "\", ?, ?);";
            params = new String[] { "old_key", "code" };
        } else if (tableName.equals("aca_year")) {
            query = "CALL " + tableName + "Interact(\"" + action + "\", ?, ?);";
            params = new String[] { "old_key", "name" };
        } else if (tableName.equals("lecturer")) {
            query = "CALL " + tableName + "Interact(\"" + action + "\", ?, ?, ?);";
            params = new String[] { "old_key", "name" };
        } else if (tableName.equals("module") || tableName.equals("program") || tableName.equals("faculty")) {
            query = "CALL " + tableName + "Interact(\"" + action + "\", ?, ?, ?);";
            params = new String[] { "old_key", "name" };
        }

        PreparedStatement st = conn.prepareStatement(query);

        for (i = 1; i <= params.length; i++)
            st.setString(i,
                    !req.getParameterMap().containsKey(params[i - 1]) || req.getParameter(params[i - 1]).equals("null")
                            ? null
                            : req.getParameter(params[i - 1]));
        if (!(tableName.equals("aca_year") || tableName.equals("semester")))
            st.setString(i, permissionList);
        System.out.println(st);
        return st;
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        // Cookie cookie = req.getCookies()[0];         
        // String username = (new JwtGenerate()).parseJWT(cookie.getValue());
        // System.out.println(username);

        // String query = "CALL controllAccess('" + username + "')";
        try {
            // Get list of permission from cookie
            DatabaseConnect DB = new DatabaseConnect();
            Connection conn = DB.getConnection();
            // ResultSet resAccessCotrol = DB.doQuery(query);

            // List<String> arr = new ArrayList<>();
            // while (resAccessCotrol.next()) 
            //     arr.add(resAccessCotrol.getString(req.getParameter("table_name")));
            // String listOfPermission = "'" + String.join("','", new ArrayList<>(new HashSet<>(arr))) + "'"; // remove duplicate add joining

            // Get return data
            PreparedStatement st = createStatement(req, "dump", conn, ""); // add listOfPermission when turn on access control
            ResultSet res = st.executeQuery();
            List<Map<String, Object>> json_resp = DB.ResultSetToJSON(res);

            resp.setContentType("application/json");
            resp.setCharacterEncoding("UTF-8");
            resp.addHeader("Access-Control-Allow-Origin", "*"); // remove CORS policy
            ObjectMapper objectMapper = new ObjectMapper();
            objectMapper.writeValue(resp.getOutputStream(), json_resp);

            DB.closeConnect();
        } catch (Exception e) {
        	resp.sendError(HttpServletResponse.SC_BAD_REQUEST, "The Table Name is invalid");
            e.printStackTrace();
        }

    }

    @Override
    protected void doPut(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        try {
            DatabaseConnect DB = new DatabaseConnect();
            Connection conn = DB.getConnection();
            PreparedStatement st = createStatement(req, "update", conn, "");

            st.executeUpdate();
            DB.closeConnect();

        } catch (Exception e) {
        	resp.sendError(HttpServletResponse.SC_BAD_REQUEST, "The Table Name is invalid");
            e.printStackTrace();
        }
    }

    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        try {
        	System.out.println("doPost");
            DatabaseConnect DB = new DatabaseConnect();
            Connection conn = DB.getConnection();
            PreparedStatement st = createStatement(req, "create", conn, "");
            System.out.println(st);

            st.executeUpdate();
            DB.closeConnect();
        } catch (SQLIntegrityConstraintViolationException e) {
        	resp.sendError(HttpServletResponse.SC_BAD_REQUEST, "The Key must be unique");
            e.printStackTrace();
        } catch (SQLException e) {
        	resp.sendError(HttpServletResponse.SC_BAD_REQUEST, "The Key is unexisting");
            e.printStackTrace();
        } catch (Exception e) {
        	resp.sendError(HttpServletResponse.SC_BAD_REQUEST, "The Table Name is invalid or The Input cannot be NULL");
            e.printStackTrace();
        }

    }

    @Override
    protected void doDelete(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        try {
            DatabaseConnect DB = new DatabaseConnect();
            Connection conn = DB.getConnection();
            PreparedStatement st = createStatement(req, "delete", conn, "");
            System.out.println(st);

            st.executeUpdate();
            DB.closeConnect();
        }
        catch (SQLIntegrityConstraintViolationException ex) {
        	resp.sendError(500, "Can't delete foreign key of another data");
            ex.printStackTrace();
        }
        catch (Exception ex) {
        	resp.sendError(500, "Error");
            ex.printStackTrace();
        }
    }

}