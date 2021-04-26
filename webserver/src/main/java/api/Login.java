package api;

import java.io.IOException;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import javax.servlet.ServletException;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import util.DatabaseConnect;
import util.JwtGenerate;

import javax.servlet.annotation.WebServlet;

/**
 * Authentication for Login
 * 
 * @author Le Hai Yen, Le Nguyen Phan Long
 */
@WebServlet(urlPatterns = "/authentication")
public class Login extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

    	String query = "{CALL authentication(?, ?)}";
    	
    	try {
            DatabaseConnect DB = new DatabaseConnect();
            Connection conn = DB.getConnection();
            PreparedStatement st = conn.prepareStatement(query);
            
            st.setString(1, req.getParameter("username"));
            st.setString(2, req.getParameter("password"));
            
            System.out.println(st);
            
            ResultSet res = st.executeQuery();
            
            if (!res.next()) {
//                System.out.println("ResultSet is empty!");
                throw new Exception("Invalid Credentials or Blank!");
            } 
            else {
                do {
                	String username = res.getString("username");
                    String role = res.getString("isAdmin");
                	Cookie cookie = new Cookie("session_key", (new JwtGenerate()).issueToken(username, role));
                    resp.addCookie(cookie);
                } 
                while (res.next());
            }
            
            DB.closeConnect();
        } catch (Exception e) {
            if (e.getMessage().equals("Invalid Credentials or Blank!"))
            {
            	resp.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            	resp.getWriter().println("Invalid Account");
            }   	
            else 
            {
            	resp.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            	resp.getWriter().println("Please reload page and do it again");
            }
            e.printStackTrace();
        }
    }
}