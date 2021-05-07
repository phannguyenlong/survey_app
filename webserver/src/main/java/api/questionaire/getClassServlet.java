package api.questionaire;

import java.io.IOException;
import java.sql.*;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.mysql.cj.jdbc.exceptions.MysqlDataTruncation;

import javax.servlet.annotation.WebServlet;

import util.DatabaseConnect;

/**
 * get all Class
 * @author Hai Yen Le
 */
@WebServlet(urlPatterns = "/class")
public class getClassServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String classCode = req.getParameter("class_code");
        
        String query = classCode.equals("all") || classCode.equals(null) ? "CALL getAllClass;" : "CALL getClassByCode(?)";
        try {
            DatabaseConnect DB = new DatabaseConnect();
            Connection conn = DB.getConnection();
            PreparedStatement st = conn.prepareStatement(query);
            
            if (!classCode.equals("all"))
                st.setString(1, classCode);
            
            System.out.println(st);

            ResultSet res = st.executeQuery();
            DB.sendData(resp, res);

            DB.closeConnect();
        	}
	        catch (MysqlDataTruncation ex) {
	        	resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
	        	resp.getWriter().println("Data is too long");
	        }
            catch (SQLSyntaxErrorException ex) {
            	resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            	resp.getWriter().println("The Class Code is invalid");
                ex.printStackTrace();
            }
            catch (Exception ex) {
            	resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            	resp.getWriter().println("The Request is invalid");
            	ex.printStackTrace();
        }
    }
}
