package api.chart;

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

import javax.servlet.annotation.WebServlet;

import util.DatabaseConnect;

/**
 * Get answer of question 20
 * @author Hai Yen Le
 */
@WebServlet(urlPatterns = "/chart/getAnswer20")
public class getAnswer20Servlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

        String query = "CALL getAnswer20(?);";

        try {
            DatabaseConnect DB = new DatabaseConnect();
            Connection conn = DB.getConnection();
            PreparedStatement st = conn.prepareStatement(query);

            st.setString(1, req.getParameter("teaching_id"));
            
            System.out.println(st);

            ResultSet res = st.executeQuery();
            
            List<Map<String, Object>> json_resp = DB.ResultSetToJSON(res);
            resp.setContentType("application/json");
            resp.setCharacterEncoding("UTF-8");
            resp.addHeader("Access-Control-Allow-Origin", "*");
            ObjectMapper objectMapper = new ObjectMapper();
            objectMapper.writeValue(resp.getOutputStream(), json_resp);

            DB.closeConnect();
        } catch (SQLSyntaxErrorException ex) {
        	resp.sendError(HttpServletResponse.SC_BAD_REQUEST, "The Teaching ID is invalid");
            ex.printStackTrace();
        } catch (SQLException ex) {
        	resp.sendError(HttpServletResponse.SC_BAD_REQUEST, "The Teaching ID cannot be NULL or contain letters");
            ex.printStackTrace();
        } catch (Exception ex) {
        	resp.sendError(HttpServletResponse.SC_BAD_REQUEST, "The Request is invalid");
            ex.printStackTrace();
        }
    }
}
