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
			st.setString(i,
					!req.getParameterMap().containsKey(params[i - 1]) || req.getParameter(params[i - 1]).equals("null") 
							? null
							: req.getParameter(params[i - 1]));
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
        	PreparedStatement st = createStatement(req, "update");
        	
        	st.executeUpdate();
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
            System.out.println(st);
            
            st.executeUpdate();
            DB.closeConnect();
        } catch (Exception e) {
            resp.setStatus(500);
            e.printStackTrace();
        }
        
    }
    
    @Override
	protected void doDelete(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException
	{	
    	try {
        	DatabaseConnect DB = new DatabaseConnect();
            Connection conn = DB.getConnection();
        	List<String> tableNameList = Arrays.asList("year_faculty", "year_fac_pro", "year_fac_pro_mo", "class", "teaching", "semester", "aca_year", "lecturer", "module", "program", "faculty");
        	String tableName = req.getParameter("table_name");
        	System.out.println(tableName);
        	if (!tableNameList.contains(tableName)) {
        		throw new Exception("Invalid Table Name");
        	}
        	PreparedStatement st = createStatement(req, "delete");
            System.out.println(st);
            
            st.executeUpdate();
            DB.closeConnect();
        } catch (Exception ex) {
            resp.setStatus(500);
            ex.printStackTrace();
        }
	}
    
}