package api.questionaire;

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
        }
        
        System.out.println(data);

        // Translate from JSON to SQL server
        try {
            DatabaseConnect DB = new DatabaseConnect();
            DB.getConnection();
            JsonNode json = mapper.readTree(data.toString());
            JsonNode class_code = json.get("class_code");
            JsonNode lecturer_code = json.get("lecturer_code");
            JsonNode q1 = json.get("question1");
            JsonNode q2 = json.get("question2");
            JsonNode q3 = json.get("question3");
            JsonNode q4 = json.get("question4"); 
            JsonNode q5 = json.get("question5");
            JsonNode q6 = json.get("question6");
            JsonNode q7 = json.get("question7"); 
            JsonNode q8 = json.get("question8");
            JsonNode q9 = json.get("question9");
            JsonNode q10 = json.get("question10");
            JsonNode q11 = json.get("question11");
            JsonNode q12 = json.get("question12");
            JsonNode q13 = json.get("question13");
            JsonNode q14 = json.get("question14");
            JsonNode q15 = json.get("question15");
            JsonNode q16 = json.get("question16");
            JsonNode q17 = json.get("question17");
            JsonNode q18 = json.get("question18"); 
            JsonNode q19 = json.get("question19");
            JsonNode q20 = json.get("question20"); 
            String query = "CALL insertIntoQuestionaire(" +class_code+ ", " +lecturer_code+ ", " +q1+ ", " +q2+ ", " +q3+ ", " +q4+ ", "+q5+" , "+q6+", "+q7+"," +q8+ ", " +q9+ ", " +q10+ ", " +q11+ ", "+q12+" , "+q13+", "+q14+", " +q15+ ", " +q16+ ", " +q17+ ", " +q18+ "," +q19+ "," +q20+ ")";
            
            DB.doQuery(query);
            DB.closeConnect();
        } catch (Exception e) {
            resp.setStatus(500);
            e.printStackTrace();
        }
        
    }
}
