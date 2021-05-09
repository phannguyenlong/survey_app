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
import com.mysql.cj.jdbc.exceptions.MysqlDataTruncation;

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
    private String[][] permissionTableForRole = {
            {"class"},                                                                                   // for lecturer
            {"year_fac_pro_mo", "class", "teaching", "lecturer", "module"},                              // for program coor
            {"year_fac_pro", "year_fac_pro_mo", "class", "teaching", "lecturer", "module", "program"}    // for deans
    };

    private PreparedStatement createStatement(HttpServletRequest req, String action, Connection conn,
            String permissionList) throws Exception {
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
            // if (action.equals("create")) {
            //     if (tableName.equals("program")) query
            // }
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
    
    private void checkAccessControl(HttpServletRequest req, DatabaseConnect DB, String action) throws Exception {
        Cookie cookie = req.getCookies()[0];         
        String username = (new JwtGenerate()).parseJWT(cookie.getValue())[0];
        String role = (new JwtGenerate()).parseJWT(cookie.getValue())[1];
        String query = "CALL controllAccess('" + username + "')";
        String permissionTable[] = null;
        String table_name = req.getParameter("table_name");
        Map<String, String> map = Map.of("class", "year_fac_pro_mo", "year_fac_pro", "year_faculty",
                                          "year_fac_pro_mo", "year_fac_pro", "teaching", "class");
        
        if (role.equals("Lecturer"))
            permissionTable = permissionTableForRole[0];
        else if (role.equals("Proco"))
            permissionTable = permissionTableForRole[1];
        else if (role.equals("Deans"))
            permissionTable = permissionTableForRole[2];
        
        if (!Arrays.asList(permissionTable).contains(req.getParameter("table_name")) && permissionTable != null)
            throw new Exception("You dont have right to interact with this table");

        ResultSet resAccessCotrol = DB.doQuery(query);
        boolean isAllow = false, isAllowModify = false;
        while (resAccessCotrol.next()) {
            if ((Arrays.asList("class", "year_fac_pro", "year_fac_pro_mo")).contains(table_name)) {
                String compareData = resAccessCotrol.getString(map.get(table_name)) == null ? "null": resAccessCotrol.getString(map.get(table_name));
                if (compareData.equals(req.getParameter("id")))
                    isAllowModify = true;
            } 
            else if (table_name.equals("teaching")) {
                String compareData = resAccessCotrol.getString(map.get(table_name)) == null ? "null": resAccessCotrol.getString(map.get(table_name));
                if (compareData.equals(req.getParameter("c_code")))
                    isAllowModify = true;
            } else {
                isAllowModify = true;
            }
            String compareData = resAccessCotrol.getString(table_name) == null ? "null": resAccessCotrol.getString(table_name);
            if (compareData.equals(req.getParameter("old_key")))
                isAllow = true;
        }
        // System.out.println(isAllowModify);
        if (action.equals("create"))
            isAllow = true;
        if (!(isAllow && isAllowModify))
            throw new Exception("You dont have right to interact with this data");
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        Cookie cookie = req.getCookies()[0];         
        String username = (new JwtGenerate()).parseJWT(cookie.getValue())[0];
        System.out.println(username);

        String query = "CALL controllAccess('" + username + "')";
        try {
            // Get list of permission from cookie
            DatabaseConnect DB = new DatabaseConnect();
            Connection conn = DB.getConnection();
            ResultSet resAccessCotrol = DB.doQuery(query);

            List<String> arr = new ArrayList<>();
            while (resAccessCotrol.next()) 
                arr.add(resAccessCotrol.getString(req.getParameter("table_name")));
            String listOfPermission = "'" + String.join("','", new ArrayList<>(new HashSet<>(arr))) + "'"; // remove duplicate add joining

            // Get return data
            PreparedStatement st = createStatement(req, "dump", conn, listOfPermission); // add listOfPermission when turn on access control
            ResultSet res = st.executeQuery();
            List<Map<String, Object>> json_resp = DB.ResultSetToJSON(res);

            resp.setContentType("application/json");
            resp.setCharacterEncoding("UTF-8");
            resp.addHeader("Access-Control-Allow-Origin", "*"); // remove CORS policy
            ObjectMapper objectMapper = new ObjectMapper();
            objectMapper.writeValue(resp.getOutputStream(), json_resp);

            DB.closeConnect();
        } catch (MysqlDataTruncation ex) {
        	resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
        	resp.getWriter().println("Data is too long");
        } catch (Exception e) {
        	resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
        	resp.getWriter().println(e.getMessage());
            e.printStackTrace();
        }

    }

    @Override
    protected void doPut(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        try {
            DatabaseConnect DB = new DatabaseConnect();
            Connection conn = DB.getConnection();
            checkAccessControl(req, DB, "update");

            PreparedStatement st = createStatement(req, "update", conn, "");

            st.executeUpdate();
            DB.closeConnect();

        } catch (MysqlDataTruncation ex) {
        	resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            resp.getWriter().println("Data is too long");
        } catch (SQLIntegrityConstraintViolationException e) {
        	resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
        	resp.getWriter().println("The Key and Input data must be unique or there is no refference data");
            e.printStackTrace();
        } catch (Exception e) {
        	resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
        	resp.getWriter().println(e.getMessage());
            e.printStackTrace();
        }
    }

    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        try {
        	System.out.println("doPost");
            DatabaseConnect DB = new DatabaseConnect();
            Connection conn = DB.getConnection();
            checkAccessControl(req, DB, "create");

            PreparedStatement st = createStatement(req, "create", conn, "");
            System.out.println(st);

            st.executeUpdate();
            DB.closeConnect();
        } catch (MysqlDataTruncation ex) {
        	resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
        	resp.getWriter().println("Data is too long");
        } catch (SQLIntegrityConstraintViolationException e) {
        	resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
        	resp.getWriter().println("The Key and Input data must be unique or there is no refference data");
            e.printStackTrace();
        } catch (SQLException e) {
        	resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
        	resp.getWriter().println("The Key is unexisting");
            e.printStackTrace();
        } catch (Exception e) {
        	resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
        	resp.getWriter().println(e.getMessage());
            e.printStackTrace();
        }
    }

    @Override
    protected void doDelete(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        try {
            DatabaseConnect DB = new DatabaseConnect();
            Connection conn = DB.getConnection();
            checkAccessControl(req, DB, "delete");

            PreparedStatement st = createStatement(req, "delete", conn, "");
            System.out.println(st);

            st.executeUpdate();
            DB.closeConnect();
        }
        catch (MysqlDataTruncation ex) {
        	resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
        	resp.getWriter().println("Data is too long");
        }
        catch (SQLIntegrityConstraintViolationException ex) {
        	resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
        	resp.getWriter().println("Can't delete foreign key of another data");
            ex.printStackTrace();
        }
        catch(SQLException ex)
        {
        	resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
        	resp.getWriter().println("Can't leave blank");
        	ex.printStackTrace();
        }
        catch (Exception ex) {
        	resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
        	resp.getWriter().println(ex.getMessage());
            ex.printStackTrace();
        }
    }
}