package api.database;

import java.io.IOException;
import java.sql.*;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.List;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.mysql.cj.jdbc.exceptions.MysqlDataTruncation;

import javax.servlet.annotation.WebServlet;

import util.DatabaseConnect;

/**
 * Use for dropdown list when select linking table in database page
 * @author Phan Nguyen Long
 */
@WebServlet("/database/idDropdown")
public class idDropdownServlet extends HttpServlet{
    private static final long serialVersionUID = 1L;
    
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
    	
        String query = "CALL idDropdown(?, ?);";
        
        try {
            DatabaseConnect DB = new DatabaseConnect();
            Connection conn = DB.getConnection();
            PreparedStatement st = conn.prepareStatement(query);
            
            st.setString(1, req.getParameter("id_type"));
            st.setString(2, req.getParameter("sem_code").equals("null") ? null : req.getParameter("sem_code"));
            
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

