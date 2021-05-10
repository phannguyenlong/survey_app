package api.chart;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.SQLSyntaxErrorException;
import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.mysql.cj.jdbc.exceptions.MysqlDataTruncation;

import javax.servlet.annotation.WebServlet;

// Others
import util.DatabaseConnect;
import util.JwtGenerate;

/**
 * Used for check Chart's Validation from database
 */
@WebServlet(urlPatterns = "/chart/validate")
public class checkChartValidate extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        Cookie cookie = req.getCookies()[0];         
        String username = (new JwtGenerate()).parseJWT(cookie.getValue())[0];
        System.out.println(username);

        String query = "CALL controllAccess('" + username + "')";
        try {
            DatabaseConnect DB = new DatabaseConnect();
            Connection conn = DB.getConnection();
            ResultSet resAccessCotrol = DB.doQuery(query);

            List<String> fa_arr = new ArrayList<>();
            List<String> pro_arr = new ArrayList<>();
            List<String> lec_arr = new ArrayList<>();
            while (resAccessCotrol.next()) {
                fa_arr.add(resAccessCotrol.getString("faculty"));
                pro_arr.add(resAccessCotrol.getString("program"));
                lec_arr.add(resAccessCotrol.getString("lecturer"));
            }

            PreparedStatement st = conn.prepareStatement("CALL Validate(?, ?, ?, ?, ?, ?, ?);");
            Map<String, List<String>> map = Map.of("fa_code", fa_arr, "pro_code", pro_arr, "lec_code", lec_arr);

            String[] params = { "aca_code", "sem_code", "fa_code", "pro_code", "mo_code", "lec_code", "class_code" };
            for (int i = 1; i < 8; i++) {
                String param = params[i - 1];
                if (param.equals("fa_code") || param.equals("pro_code") || param.equals("lec_code")) {
                    if (!req.getParameter(param).equals("null") && !map.get(param).contains(req.getParameter(param)))
                        throw new Exception("You dont have the right to access this data");
                    st.setString(i,
                            req.getParameter(param).equals("null")
                                    ? "'" + String.join("','", new ArrayList<>(new HashSet<>(map.get(param)))) + "'"
                                    : req.getParameter(params[i - 1]));
                }
                else
                    st.setString(i, req.getParameter(params[i - 1]).equals("null") ? "null": req.getParameter(params[i - 1]));
            }

            System.out.println(st);

            ResultSet res = st.executeQuery();
            List<Map<String, Object>> json_resp = DB.ResultSetToJSON(res);

            resp.setContentType("application/json");
            resp.setCharacterEncoding("UTF-8");
            resp.addHeader("Access-Control-Allow-Origin", "*"); // remove CORS policy
            ObjectMapper objectMapper = new ObjectMapper();
            objectMapper.writeValue(resp.getOutputStream(), json_resp);

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
        	resp.getWriter().println(ex.getMessage());
            ex.printStackTrace();
        }
    }
}
