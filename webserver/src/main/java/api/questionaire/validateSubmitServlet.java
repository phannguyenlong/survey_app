package api.questionaire;

import java.io.BufferedReader;
import java.io.IOException;

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
 * @author VZ
 */
@WebServlet(urlPatterns = "/questionaire/submit")
public class validateSubmitServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

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
            resp.setStatus(500);
        }
        
        System.out.println(data);

        // Translate from JSON to SQL server
        try {
            DatabaseConnect DB = new DatabaseConnect();
            DB.getConnection();
            JsonNode json = mapper.readTree(data.toString());

            String query = "Call insertIntoQuestionaire('" + json.get("class_code").toString() + "', '" + json.get("lecturer_code").toString() + "', ";
            for (int i = 1; i < 21; i++)
                query += i == 20? json.get("question" +String.valueOf(i)) + "" : json.get("question" + String.valueOf(i)) + ", ";
            query += ");";

            System.out.println(query);
            
            DB.doQuery(query);
            DB.closeConnect();
        } catch (Exception e) {
            resp.setStatus(500);
            e.printStackTrace();
        }
        
    }
}
