package api;

import java.io.IOException;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.Arrays;
import java.util.List;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.fasterxml.jackson.databind.ObjectMapper;

import util.DatabaseConnect;

import javax.servlet.annotation.WebServlet;

import io.jsonwebtoken.Jwts;
import io.jsonwebtoken.SignatureAlgorithm;
import io.jsonwebtoken.security.Keys;
import java.security.Key;
import io.jsonwebtoken.Claims;
import io.jsonwebtoken.security.InvalidKeyException;
import io.jsonwebtoken.security.SignatureException;
import io.jsonwebtoken.security.WeakKeyException;

import javax.crypto.SecretKey;
import java.security.PrivateKey;

//import javax.ws.rs.core.NewCookie;

import org.codehaus.cargo.container.property.User;

/**
 * Authentication for Login
 * 
 * @author Le Hai Yen, Le Nguyen Phan Long
 */
@WebServlet(urlPatterns = "/authentication")
public class Login extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    @SuppressWarnings("deprecation")
	private String issueToken(String username) throws Exception {
     	 // Issue a JWT token	
     	 // Signing key  
    	String key = "mua tren nhung mai ton";
        String authToken = Jwts.builder()
        	.claim("username: ", username)
         	.signWith(SignatureAlgorithm.HS512, key)
         	.compact();
          return authToken;
    }
    
    
//    private String generateCookie(String authToken) {
//    	NewCookie cookie = new NewCookie("logincookie", authToken, "/", "", "auth_token", NewCookie.DEFAULT_MAX_AGE, false);
//    	return Response.ok("OK").cookie(cookie).build();
//    }
    
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
                System.out.println("ResultSet is empty");
                throw new Exception("Invalid Credentials");
            } 
            else {
                do {
                	String username = res.getString("username");
                	issueToken(username);
                	Cookie cookie = new Cookie(username,issueToken(username));
                    resp.addCookie(cookie);
                } 
                while (res.next());
            }
            
            st.executeUpdate();
            DB.closeConnect();
        } catch (Exception e) {
            resp.setStatus(500);
            e.printStackTrace();
        }
    }
}