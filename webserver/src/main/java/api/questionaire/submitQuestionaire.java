package api;

import java.io.BufferedReader;
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

/**
 * Questionaire Submit Servlet
 * @author Long Le & Nguyen Ba Le  
 *
 */

@WebServlet(urlPatterns = "/questionaire/submit")
public class questionaireSubmit extends HttpServlet{
    private static final long serialVersionUID = 1L;
    
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException 
    {
    	ObjectMapper objMapper = new ObjectMapper();
    	
    	StringBuffer data = new StringBuffer();
    	BufferedReader BuffReader;
    	String line;
    	
    	try 
    	{
    		BuffReader = req.getReader();
    		while((line = BuffReader.readLine()) != null)
    		{
    			System.out.println(line);
    			data.append(line);
    		}
    	}
    	catch (Exception e)
    	{
    		System.out.println("Error");
    	}
    	
        try {
            DatabaseConnect DB = new DatabaseConnect();
            JsonNode Jnode = objMapper.readTree(data.toString());
            
            String class_code = Jnode.get("class_code").toString();
            String lecturer = Jnode.get("lecturer").toString();
            
            int numofQuestion = 19;
            String questions[] = null;
            
            for(int i = 1; i < numofQuestion; i++)
            {
		questions[i] = Jnode.get("question" + String.valueOf(i)).toString();
                if (class_code == null || lecturer == null || questions[i] == null)
                {
                	throw new Exception("Missing Information");
                }
            }
 
            String query = "Call insertIntoQuestionaire('" + class_code + "', '" 
            + lecturer + "','" + questions[1] + "','" + questions[2] + "','" + questions[3] + "','" 
            		+ questions[4] + "','" + questions[5] + "','" + questions[6] + "','" + questions[7] + "','" 
            + questions[8] + "','" + questions[9] + "','" + questions[10] + "','" + questions[11] + "','" 
            		+ questions[12] + "','" + questions[13] + "','" + questions[14] + "','" + questions[15] + "','" 
            + questions[16] + "','" + questions[17] + "','" + questions[18] + ");";
            
            
        } catch (Exception e) {
            resp.setStatus(500);
            e.printStackTrace();
        }
    	
    }
}