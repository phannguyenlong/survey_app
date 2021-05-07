package api.chart;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.SQLSyntaxErrorException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.mysql.cj.jdbc.exceptions.MysqlDataTruncation;

import javax.servlet.annotation.WebServlet;

// Others
import util.DatabaseConnect;

/**
 * Used for check Chart's Validation from database
 */
@WebServlet(urlPatterns = "/chart/validate")
public class checkChartValidate extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String query = "CALL Validate(?, ?, ?, ?, ?, ?, ?);";
        try {
            DatabaseConnect DB = new DatabaseConnect();
            Connection conn = DB.getConnection();
            PreparedStatement st = conn.prepareStatement(query);

            String[] params = { "aca_code", "sem_code", "fa_code", "pro_code", "mo_code", "lec_code", "class_code" };
            for (int i = 1; i < 8; i++) {
                    st.setString(i, req.getParameter(params[i - 1]).equals("null") ? "null": req.getParameter(params[i - 1]));
            }

            System.out.println(st);
            ResultSet res = st.executeQuery();
            DB.sendData(resp, res);

            DB.closeConnect();
        } catch (SQLSyntaxErrorException ex) {
        	resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
        	resp.getWriter().println("Syntax is incorrect");
            ex.printStackTrace();
        }
        catch (MysqlDataTruncation ex) {
        	resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
        	resp.getWriter().println("Data is too long");
        }
        catch (SQLException ex) {
        	resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
        	resp.getWriter().println("No blank allowed");
            ex.printStackTrace();
        }
        catch (Exception ex) {
        	resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
        	resp.getWriter().println("The Request is invalid");
            ex.printStackTrace();
        }
    }
}
