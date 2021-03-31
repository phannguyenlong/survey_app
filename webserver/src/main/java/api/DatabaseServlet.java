package api;

import java.io.BufferedReader;
import java.io.IOException;
import java.sql.ResultSet;
import java.util.List;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;

import javax.servlet.annotation.WebServlet;

// Others
import util.DatabaseConnect;

/**
 * Class for testing purpose only
 * @author Long Phan
 */
@WebServlet(urlPatterns = "/database")
public class DatabaseServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        // String requestUrl = req.getRequestURI();
        // String name = requestUrl.substring("/database/".length());

        System.out.println(req.getParameter("name"));
        System.out.println(req.getParameter("age"));

        String query = "SELECT * FROM module";
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

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        ObjectMapper mapper = new ObjectMapper();

        StringBuffer data = new StringBuffer();
        String line = null;

        try {
            BufferedReader reader = req.getReader();
            while ((line = reader.readLine()) != null) {
                System.out.println(line);
                data.append(line);
            }
        } catch (Exception e) {
        }
        
        System.out.println(data);

        // Translate from JSON to SQL server
        try {
            // DatabaseConnect DB = new DatabaseConnect();
            JsonNode json = mapper.readTree(data.toString());
            System.out.println(json.get("lecturer_code"));
            // execute query like normal
        } catch (Exception e) {
            resp.setStatus(500);
            e.printStackTrace();
        }
    }
}
