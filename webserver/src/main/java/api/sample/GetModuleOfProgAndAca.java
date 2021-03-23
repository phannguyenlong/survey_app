package api.sample;

import java.io.IOException;
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

@WebServlet(urlPatterns = "/getModuleOfProgAndAca")
public class GetModuleOfProgAndAca extends HttpServlet{
    private static final long serialVersionUID = 1L;
    
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        // String requestUrl = req.getRequestURI();
        // String name = requestUrl.substring("/database/".length());

        String acode = req.getParameter("acode").isBlank() ? "null" : "'" + req.getParameter("acode") + "'";
        String pcode = req.getParameter("pcode").isBlank() ? "null" : "'" + req.getParameter("pcode") + "'";

        String query = "CALL GetModuleOfProgAndAca(" + acode + ", " + pcode + ") ";
        System.out.println(query);

        try {
            DatabaseConnect DB = new DatabaseConnect();
            DB.getConnection();
            ResultSet res = DB.doQuery(query);
            List<Map<String, Object>> json_resp = DB.ResultSetToJSON(res);

            resp.setContentType("application/json");
            resp.setCharacterEncoding("UTF-8");
            resp.addHeader("Access-Control-Allow-Origin", "*"); // remove CORS policy
            ObjectMapper objectMapper = new ObjectMapper();
            objectMapper.writeValue(resp.getOutputStream(), json_resp);

            DB.closeConnect();
        } catch (Exception ex) {
            ex.printStackTrace();
        }
    }
}
    