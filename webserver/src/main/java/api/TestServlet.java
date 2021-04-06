package api;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;

import javax.servlet.annotation.WebServlet;

@WebServlet(urlPatterns = "/test/*")
public class TestServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        PrintWriter printWriter = resp.getWriter();
        printWriter.print("This is testing page");
        printWriter.close();
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        System.out.println("Do post running");

        String data = req.getParameter("data");

        PrintWriter printWriter = resp.getWriter();

        printWriter.println("Welcome " + data);

        String[] jsons = new String(data.substring(1, data.length() - 1)).split("},");
        for (int i = 0; i < jsons.length - 1; i++)
            jsons[i] = jsons[i] + "}";

        System.out.println(jsons[0]);

        ObjectMapper mapper = new ObjectMapper();
        JsonNode rootNode = mapper.readTree(jsons[0]);
        JsonNode iNode = rootNode.path("id");

        System.out.println(iNode.asInt());
    }

}
