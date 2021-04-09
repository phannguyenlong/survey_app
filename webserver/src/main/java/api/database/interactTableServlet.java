package api.database;

import java.io.BufferedReader;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.Arrays;
import java.util.List;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;

import util.DatabaseConnect;

import javax.servlet.annotation.WebServlet;

/**
 * GET, PUT, POST, DELETE Database
 * @author Le Hai Yen, Le Nguyen Phan Long, Nguyen Ba Le
 */
@WebServlet(urlPatterns = "/database/interactTable")
public class interactTableServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    private PreparedStatement createStatement(HttpServletRequest req, String action) throws Exception {
    	String query = "";
    	DatabaseConnect DB = new DatabaseConnect();
        Connection conn = DB.getConnection();
        String[] params = null;
        String tableName = req.getParameter("table_name");
    	if (tableName.equals("year_faculty")){
    		query = "{CALL "+tableName+"Interact(\"" + action + "\", ?, ?, ?, ?)}";
            params = new String[]{ "old_key", "new_key", "a_code", "f_code" };
    	}
    	else if (tableName.equals("year_fac_pro")) {
    		query = "CALL "+tableName+"Interact(\"" + action + "\", ?, ?, ?);";
            params = new String[]{ "old_key", "id", "code"};
    	}
    	else if (tableName.equals("year_fac_pro_mo")) {
    		query = "CALL "+tableName+"Interact(\"" + action + "\", ?, ?, ?);";
            params = new String[]{ "old_key", "id", "code"};
    	}
    	else if (tableName.equals("class")) {
    		query = "CALL "+tableName+"Interact(\"" + action + "\", ?, ?, ?, ?);";
            params = new String[]{ "old_key", "size", "code", "id" };
    	}
    	else if (tableName.equals("teaching")) {
    		query = "CALL "+tableName+"Interact(\"" + action + "\", ?, ?, ?);";
            params = new String[]{ "old_key", "c_code", "lec_code" };
    	}
    	else if (tableName.equals("semester")) {
    		query = "CALL "+tableName+"Interact(\"" + action + "\", ?, ?, ?);";
            params = new String[]{ "old_key", "new_key", "code" };
    	}
    	else if (tableName.equals("aca_year")) {
    		query = "CALL "+tableName+"Interact(\"" + action + "\", ?, ?);";
            params = new String[]{ "old_key", "new_key" };
    	}
    	else if (tableName.equals("lecturer")) {
    		query = "CALL "+tableName+"Interact(\"" + action + "\", ?, ?);";
            params = new String[]{ "old_key", "name"};
    	}
    	else if (tableName.equals("module") || tableName.equals("program") || tableName.equals("faculty")) {
    		query = "CALL "+tableName+"Interact(\"" + action + "\", ?, ?, ?);";
            params = new String[]{ "old_key", "new_key", "name" };
    	}

    	
    	PreparedStatement st = conn.prepareStatement(query);
    	
    	for (int i = 1; i <= params.length; i++)
            st.setString(i, req.getParameter(params[i-1]).equals("null") ? null : req.getParameter(params[i-1]));
    	System.out.println(st);
    	return st;
    }
    
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

    	try {
        	DatabaseConnect DB = new DatabaseConnect();
            Connection conn = DB.getConnection();
        	List<String> tableNameList = Arrays.asList("year_faculty", "year_fac_pro", "year_fac_pro_mo", "class", "teaching", "semester", "aca_year", "lecturer", "module", "program", "faculty");
        	String tableName = req.getParameter("table_name");
        	System.out.println(tableName);
        	if (!tableNameList.contains(tableName)) {
        		throw new Exception("Invalid Table Name");
        	}
        	PreparedStatement st = createStatement(req, "dump");
        	
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
    
    @Override
    protected void doPut(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        try {
        	DatabaseConnect DB = new DatabaseConnect();
            Connection conn = DB.getConnection();
        	List<String> tableNameList = Arrays.asList("year_faculty", "year_fac_pro", "year_fac_pro_mo", "class", "teaching", "semester", "aca_year", "lecturer", "module", "program", "faculty");
        	String tableName = req.getParameter("table_name");
        	System.out.println(tableName);
        	if (!tableNameList.contains(tableName)) {
        		throw new Exception("Invalid Table Name");
        	}
        	PreparedStatement st = createStatement(req, "update");
            ResultSet res = st.executeQuery();
            /*
            List<Map<String, Object>> json_resp = null;
            json_resp = DB.ResultSetToJSON(res);

            resp.setContentType("application/json");
            resp.setCharacterEncoding("UTF-8");
            resp.addHeader("Access-Control-Allow-Origin", "*"); // remove CORS policy
            ObjectMapper objectMapper = new ObjectMapper();
            objectMapper.writeValue(resp.getOutputStream(), json_resp);*/

            DB.closeConnect();
            
        } catch (Exception ex) {
            resp.setStatus(500);
            ex.printStackTrace();
        }
    }
    
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

        try {
        	DatabaseConnect DB = new DatabaseConnect();
            Connection conn = DB.getConnection();
        	List<String> tableNameList = Arrays.asList("year_faculty", "year_fac_pro", "year_fac_pro_mo", "class", "teaching", "semester", "aca_year", "lecturer", "module", "program", "faculty");
        	String tableName = req.getParameter("table_name");
        	System.out.println(tableName);
        	if (!tableNameList.contains(tableName)) {
        		throw new Exception("Invalid Table Name");
        	}
        	PreparedStatement st = createStatement(req, "create");
            ResultSet res = st.executeQuery();
            /*
            List<Map<String, Object>> json_resp = DB.ResultSetToJSON(res);
            JsonNode json = mapper.readTree(data.toString());

            resp.setContentType("application/json");
            resp.setCharacterEncoding("UTF-8");
            resp.addHeader("Access-Control-Allow-Origin", "*"); // remove CORS policy
            ObjectMapper objectMapper = new ObjectMapper();
            objectMapper.writeValue(resp.getOutputStream(), json_resp);*/

            DB.closeConnect();
            System.out.println(st);
            
            st.executeUpdate();
            // DB.doQuery(query);
            DB.closeConnect();
        } catch (Exception e) {
            resp.setStatus(500);
            e.printStackTrace();
        }
        
    }
    
    @Override
	protected void doDelete(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException
	{	
		try 
		{ 
			List<String> Table_Names = Arrays.asList("year_faculty", "year_fac_pro", "year_fac_pro_mo", "class", "teaching", "semester", "aca_year", "lecturer", "module", "program", "faculty");
        	
			String table_name = req.getParameter("table_name");
			
			String query = "";
			PreparedStatement st = null;
			
			DatabaseConnect DB = new DatabaseConnect();
            Connection conn = DB.getConnection();
			
			if(!Table_Names.contains(table_name))
			{
				System.out.println(table_name + " doesnt exist");
				return;
			}

			if(table_name.equals("year_faculty"))
			{
		    	query = "CALL " + table_name + "Interact" + "(\"delete\", ?, ?, ?, ?)";
	            st = conn.prepareStatement(query);	        	
	            
	            st.setString(1, req.getParameter("old_key"));
	            
	            st.setString(2, "null");
	            st.setString(3, "null");
	            st.setString(4, "null");
			} 
			else if (table_name.equals("year_fac_pro"))
			{
	    		query = "CALL " + table_name + "Interact" + "(\"delete\", ?, ?, ?)";
	        	
	            st = conn.prepareStatement(query);	        	
	            
	            st.setString(1, req.getParameter("old_key"));
	            st.setString(2, "null");
	            st.setString(3, "null");
			}
			else if (table_name.equals("year_fac_pro_mo"))
			{
	    		query = "CALL " + table_name + "Interact" + "(\"delete\", ?, ?, ?)";
	        	
	            st = conn.prepareStatement(query);	        	
	            
	            st.setString(1, req.getParameter("old_key"));
	            st.setString(2, "null");
	            st.setString(3, "null");
			}
			else if (table_name.equals("class"))
			{
	    		query = "CALL " + table_name + "Interact" + "(\"delete\", ?, ?, ?, ?)";
	        	
	            st = conn.prepareStatement(query);	        	
	            
	            st.setString(1, req.getParameter("old_key"));
	            st.setString(2, "null");
	            st.setString(3, "null");
	            st.setString(4, "null");
			}
			else if (table_name.equals("teaching"))
			{
	    		query = "CALL " + table_name + "Interact" + "(\"delete\", ?, ?, ?)";
	        	
	            st = conn.prepareStatement(query);	        	
	            
	            st.setString(1, req.getParameter("old_key"));
	            st.setString(2, "null");
	            st.setString(3, "null");
			}
			else if (table_name.equals("semester"))
			{
	    		query = "CALL " + table_name + "Interact" + "(\"delete\", ?, ?, ?)";
	        	
	            st = conn.prepareStatement(query);	        	
	            
	            st.setString(1, req.getParameter("old_key"));
	            st.setString(2, "null");
	            st.setString(3, "null");
			}
			else if (table_name.equals("lecturer"))
			{
	    		query = "CALL " + table_name + "Interact" + "(\"delete\", ?, ?)";
	        	
	            st = conn.prepareStatement(query);	        	
	            
	            st.setString(1, req.getParameter("old_key"));
	            st.setString(2, "null");
			}
			else if (table_name.equals("aca_year"))
			{
	    		query = "CALL " + table_name + "Interact" + "(\"delete\", ?, ?, ?)";
	        	
	            st = conn.prepareStatement(query);	        	
	            
	            st.setString(1, req.getParameter("old_key"));
	            st.setString(2, "null");
			}
			else if (table_name.equals("module") || table_name.equals("program") || table_name.equals("faculty"))
			{
	    		query = "CALL " + table_name + "Interact" + "(\"delete\", ?, ?, ?)";
	        	
	            st = conn.prepareStatement(query);	        	
	            
	            st.setString(1, req.getParameter("old_key"));
	            st.setString(2, "null");
	            st.setString(3, "null");
			}
            System.out.println(st);
            ResultSet res = st.executeQuery();
            /*
            List<Map<String, Object>> json_resp = DB.ResultSetToJSON(res);

            resp.setContentType("application/json");
            resp.setCharacterEncoding("UTF-8");
            resp.addHeader("Access-Control-Allow-Origin", "*"); // remove CORS policy
            ObjectMapper objectMapper = new ObjectMapper();
            objectMapper.writeValue(resp.getOutputStream(), json_resp);*/

            DB.closeConnect();
        } catch (Exception ex) {
            resp.setStatus(500);
            ex.printStackTrace();
        }
	}
    
}