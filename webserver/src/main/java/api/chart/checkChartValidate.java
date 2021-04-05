package api.chart;

import java.io.IOException;
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

            st.setString(1, req.getParameter("aca_code").equals("null") ? null : req.getParameter("aca_code"));
            st.setString(2, req.getParameter("sem_code").equals("null") ? null : req.getParameter("sem_code"));
            st.setString(3, req.getParameter("fa_code").equals("null") ? null : req.getParameter("fa_code"));
            st.setString(4, req.getParameter("pro_code").equals("null") ? null : req.getParameter("pro_code"));
            st.setString(5, req.getParameter("mo_code").equals("null") ? null : req.getParameter("mo_code"));
            st.setString(6, req.getParameter("lec_code").equals("null") ? null : req.getParameter("lec_code"));
            st.setString(7, req.getParameter("class_code").equals("null") ? null : req.getParameter("class_code"));
            System.out.println(st);

            ResultSet res = st.executeQuery();
            List<Map<String, Object>> json_resp = DB.ResultSetToJSON(res);

            resp.setContentType("application/json");
            resp.setCharacterEncoding("UTF-8");
            resp.addHeader("Access-Control-Allow-Origin", "*"); // remove CORS policy
            ObjectMapper objectMapper = new ObjectMapper();
            objectMapper.writeValue(resp.getOutputStream(), json_resp);

            DB.closeConnect();
        } catch (Exception ex) {
            resp.setStatus(500);
            ex.printStackTrace();
        }
    }
}
