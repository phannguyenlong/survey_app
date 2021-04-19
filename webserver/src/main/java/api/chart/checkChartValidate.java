package api.chart;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.SQLSyntaxErrorException;
import java.util.List;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.mysql.cj.jdbc.exceptions.SQLExceptionsMapping;

import javax.servlet.annotation.WebServlet;

// Others
import util.DatabaseConnect;

/**
 * Used for check Chart's Validation from database
 */
@WebServlet(urlPatterns = "/chart/validate")
public class checkChartValidate extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String query = "CALL Validate(?, ?, ?, ?, ?, ?, ?);";
        try {
            DatabaseConnect DB = new DatabaseConnect();
            Connection conn = DB.getConnection();
            PreparedStatement st = conn.prepareStatement(query);

            String[] params = { "aca_code", "sem_code", "fa_code", "pro_code", "mo_code", "lec_code", "class_code" };
            for (int i = 1; i < 8; i++) {
                    st.setString(i, req.getParameter(params[i - 1]).equals("null") ? "null": req.getParameter(params[i - 1]));
            }

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
        	resp.sendError(HttpServletResponse.SC_BAD_REQUEST, "Syntax is incorrect");
//            resp.setStatus(500);
            ex.printStackTrace();
        }
//        catch (SQLExceptionsMapping ex) {
//        	resp.sendError(HttpServletResponse.SC_BAD_REQUEST, "Data too long");
//            resp.setStatus(500);
//        }
        catch (SQLException ex) {
        	resp.sendError(HttpServletResponse.SC_BAD_REQUEST, "No blank allowed");
            ex.printStackTrace();
        }
        catch (Exception ex) {
        	resp.sendError(HttpServletResponse.SC_BAD_REQUEST, "The Request is invalid");
//            resp.setStatus(500);
            ex.printStackTrace();
        }
    }
}
