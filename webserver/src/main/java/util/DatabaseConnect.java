package util;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Properties;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;

import java.io.IOException;
import java.io.InputStream;
import java.sql.Connection;
import java.sql.Statement;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.SQLException;
import java.sql.DriverManager;

/**
 * Use from make connection to database
 * Also handling manipulating data from SQL server to JSON and reverse
 * @author Long Phan
 */
public class DatabaseConnect {
    String dbURL = "jdbc:mysql://localhost:3306;";
    String Db_Name = "SQLCalendar";
    String userName = "guest";
    String password = "password";
    Connection conn;

    public DatabaseConnect() {
        Properties props = new Properties();
        System.out.println(getClass().getResource("../config.properties"));
        InputStream input = getClass().getResourceAsStream("../config.properties");
        
        try {
            props.load(input);
            // this.default_path = props.getProperty("server");
            this.dbURL = props.getProperty("dbURL");
            this.Db_Name = props.getProperty("Db_name");
            this.userName = props.getProperty("username");
            this.password = props.getProperty("password");
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    /**
     * Establish connection to SQL server
     * @return Connection class
     */
    public Connection getConnection() {
        conn = null;
        dbURL = dbURL + "/" + Db_Name;
        try {
            Class.forName("com.mysql.jdbc.Driver");
            conn = DriverManager.getConnection(dbURL, userName, password);
            System.out.println("connect successfully!");
        } catch (Exception ex) {
            System.out.println("connect failure!");
            ex.printStackTrace();
        }
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
                String colName = rsmd.getColumnName(i);
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
}
