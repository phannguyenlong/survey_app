package api;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.ResultSet;
import java.util.ArrayList;
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

@WebServlet(urlPatterns = "/database")
public class DatabaseServlet extends HttpServlet{
    private static final long serialVersionUID = 1L;
    
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        System.out.println("Run database");

        // String requestUrl = req.getRequestURI();
        // String name = requestUrl.substring("/database/".length());

        System.out.println(req.getParameter("name"));
        System.out.println(req.getParameter("age"));

        try {
            DatabaseConnect DB = new DatabaseConnect();
            DB.getConnection();
            ResultSet res = DB.doQuery("select * from module");
            // Display data
            // while (res.next()) {
            //     resp.getOutputStream().println(res.getInt(1) + "  " + res.getString(2) + "  " + res.getString(3));
            // }
            List<Map<String, Object>> json_resp = DB.ResultSetToJSON(res);

            resp.setContentType("application/json");
            resp.setCharacterEncoding("UTF-8");
            ObjectMapper objectMapper = new ObjectMapper();
            objectMapper.writeValue(resp.getOutputStream(), json_resp);

            DB.closeConnect();
        } catch (Exception ex) {
            ex.printStackTrace();
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {        
        System.out.println("Do post running on server");

        String data = req.getParameter("data");

        PrintWriter printWriter = resp.getWriter();
        printWriter.println("Welcome " + data);

        // Translate from JSON to SQL server
        try {
            DatabaseConnect DB = new DatabaseConnect();
            ArrayList<JsonNode> list = DB.JsonToJsonNode(data);
            for (JsonNode node : list) {
                JsonNode id = node.path("id");
                JsonNode name = node.path("name");
                JsonNode address = node.path("address");
                System.out.println(id + "\t" + name + "\t" + address);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
