package api.chart;

import java.io.IOException;
import java.sql.*;
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
 * Get number of answers filled
 * @author Hai Yen Le
 */
@WebServlet(urlPatterns = "/chart/numberOfAnswer")
public class getNumberOfAnswerServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

        String query = "CALL getNumberOfAnswer(?, ?);";

        try {
            DatabaseConnect DB = new DatabaseConnect();
            Connection conn = DB.getConnection();
            PreparedStatement st = conn.prepareStatement(query);

            st.setString(1, req.getParameter("teaching_id_arr"));
            st.setString(2, req.getParameter("answer_id"));
            
            System.out.println(st);

            ResultSet res = st.executeQuery();
            
            List<Map<String, Object>> json_resp = DB.ResultSetToJSON(res);
            resp.setContentType("application/json");
            resp.setCharacterEncoding("UTF-8");
            resp.addHeader("Access-Control-Allow-Origin", "*"); // remove CORS policy
            ObjectMapper objectMapper = new ObjectMapper();
            objectMapper.writeValue(resp.getOutputStream(), json_resp);

            DB.closeConnect();
        } catch (SQLSyntaxErrorException ex) {
        	resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
        	resp.getWriter().println("The Teaching ID is invalid");
        	ex.printStackTrace();
        } catch (MysqlDataTruncation ex) {
        	resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
        	resp.getWriter().println("Data is too long");
        } catch (SQLException ex) {
        	resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
        	resp.getWriter().println("The Teaching ID cannot be NULL or contain letters");
        	ex.printStackTrace();
        } catch (Exception ex) {
        	resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
        	resp.getWriter().println("The Request is invalid");
            ex.printStackTrace();
        }
    }
}
