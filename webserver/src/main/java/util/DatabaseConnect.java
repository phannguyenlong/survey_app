package util;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.servlet.http.HttpServletResponse;
import javax.sql.DataSource;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;

import java.io.IOException;
import java.sql.Connection;
import java.sql.Statement;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.SQLException;

/**
 * Use from make connection to database
 * Also handling manipulating data from SQL server to JSON and reverse
 * @author Long Phan
 */
public class DatabaseConnect {
    String dbURL, Db_Name, userName, password;
    Connection conn;
    DataSource ds;

    public DatabaseConnect() throws Exception{
        Context initContext = new InitialContext();
		Context envContext = (Context) initContext.lookup("java:comp/env"); 
		this.ds = (DataSource) envContext.lookup("jdbc/java_app");
    }

    /**
     * Establish connection to SQL server
     * @return Connection class
     */
    public Connection getConnection() throws Exception{
        this.conn = ds.getConnection();
        return conn;
    }

    /**
     * Excute query
     * @param query SQL query
     * @return Result Set of SQL data
     * @throws Exception
     */
    public ResultSet doQuery(String query) throws Exception {
        Statement stmt = conn.createStatement();
        // execute query
        ResultSet rs = stmt.executeQuery(query);

        return rs;
    }

    /**
     * Close connection to SQL server
     * @throws Exception
     */
    public void closeConnect() throws Exception {
        conn.close();
    }

    /**
     * Translate Result Set return from SQL to List<Map<String,Object>>
     * The return type can use ObjectMapper from Jackson to send over HTTP with type JSON
     * . Ex: objectMapper.writeValue(resp.getOutputStream(), json_resp);
     * @param rs Result set return from SQL query
     * @return List<Map<String,Object>> can use ObjectMapper from Jackson to send over HTTP with type JSON
     * @throws SQLException
     */
    public List<Map<String, Object>> ResultSetToJSON(ResultSet rs) throws SQLException {
        List<Map<String, Object>> rows = new ArrayList<>();
        ResultSetMetaData rsmd = rs.getMetaData();
        int columnCount = rsmd.getColumnCount();

        while (rs.next()) {
            // Represent a row in DB. Key: Column name, Value: Column value
            Map<String, Object> row = new HashMap<>();
            for (int i = 1; i <= columnCount; i++) {
                String colName = rsmd.getColumnLabel(i); // change to fix error of alias in mysql
                Object colVal = rs.getObject(i);
                row.put(colName, colVal);
            }
            rows.add(row);
        }

        return rows;
    }

    /**
     * Translate JSON recieve from HTTP into JsonNode
     * The return type can .path(field_name) to get value of JSON
     * . Ex: JsonNode id = node.path("id");
     * @param data Json string recieve from HTTP
     * @return JsonNode type can .path(field_name) to get value of JSON
     * @throws IOException
     */
    public ArrayList<JsonNode> JsonToJsonNode(String data) throws IOException {
        ObjectMapper mapper = new ObjectMapper();
        ArrayList<JsonNode> list = new ArrayList<>();

        String[] jsons = new String(data.substring(1, data.length() - 1)).split("},");
        for (int i = 0; i < jsons.length - 1; i++)
            jsons[i] = jsons[i] + "}";

        for (String json : jsons)
            list.add(mapper.readTree(json));

        return list;
    }
    
    public void sendData(HttpServletResponse resp, ResultSet res) throws Exception{
        List<Map<String, Object>> json_resp = ResultSetToJSON(res);
        
        resp.setContentType("application/json");
        resp.setCharacterEncoding("UTF-8");
        resp.addHeader("Access-Control-Allow-Origin", "*");
        ObjectMapper objectMapper = new ObjectMapper();
        objectMapper.writeValue(resp.getOutputStream(), json_resp);
    }
}
