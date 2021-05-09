package api.database;

import java.io.IOException;
import java.sql.*;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
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

import javax.servlet.annotation.WebServlet;

import util.DatabaseConnect;
import util.JwtGenerate;

/**
 * Use for dropdown list when select linking table in database page
 * @author Phan Nguyen Long
 */
@WebServlet("/database/idDropdown")
public class idDropdownServlet extends HttpServlet{
    private static final long serialVersionUID = 1L;
    
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        Cookie cookie = req.getCookies()[0];         
        String username = (new JwtGenerate()).parseJWT(cookie.getValue())[0];
        System.out.println(username);

        String query = "CALL controllAccess('" + username + "')";
        
        try {
            DatabaseConnect DB = new DatabaseConnect();
            Connection conn = DB.getConnection();
            ResultSet resAccessCotrol = DB.doQuery(query);

            List<String> arr = new ArrayList<>();
            Map<String, String> map = Map.of("id_1", "year_faculty", "id_2", "year_fac_pro", "id_3", "year_fac_pro_mo");
            while (resAccessCotrol.next()) 
                arr.add(resAccessCotrol.getString(map.get(req.getParameter("id_type"))));
            String listOfPermission = "'" + String.join("','", new ArrayList<>(new HashSet<>(arr))) + "'"; // remove duplicate add joining
            

            PreparedStatement st = conn.prepareStatement("CALL idDropdown(?, ?);");
            
            st.setString(1, req.getParameter("id_type"));
            st.setString(2, listOfPermission);
            
            System.out.println(st);
            
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
        } catch (SQLException ex) {
        	resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
        	resp.getWriter().println("The ID Type or Semester Code is invalid");
            ex.printStackTrace();
        } catch (Exception ex) {
        	resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
        	resp.getWriter().println("The Request is invalid");
            ex.printStackTrace();
        }
    }
}

