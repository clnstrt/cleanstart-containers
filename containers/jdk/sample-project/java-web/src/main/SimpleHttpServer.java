import com.sun.net.httpserver.HttpExchange;
import com.sun.net.httpserver.HttpHandler;
import com.sun.net.httpserver.HttpServer;

import java.io.IOException;
import java.io.OutputStream;
import java.net.InetSocketAddress;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

public class SimpleHttpServer {

    public static void main(String[] args) throws IOException {
        HttpServer server = HttpServer.create(new InetSocketAddress(8080), 0);
        
        // Root endpoint
        server.createContext("/", new RootHandler());
        
        // Health check endpoint
        server.createContext("/health", new HealthHandler());
        
        // API endpoint
        server.createContext("/api/time", new TimeHandler());
        
        // Start the server
        server.setExecutor(null);
        server.start();
        
        System.out.println("CleanStart Java JDK Image");  
        System.out.println("There are available endpoints:");
        System.out.println("  GET / - Welcome message");
        System.out.println("  GET /health - Health check");
        System.out.println("  GET /api/time - Current time");
    }

    static class RootHandler implements HttpHandler {
        @Override
        public void handle(HttpExchange exchange) throws IOException {
            String response = """
                <html>
                <head><title>Simple Java HTTP Server</title></head>
                <body>
                    <h1>Welcome to Simple Java HTTP Server!</h1>
                    <p>This server is running on Java.</p>
                    <ul>
                        <li><a href="/health">Health Check</a></li>
                        <li><a href="/api/time">Get Current Time</a></li>
                    </ul>
                </body>
                </html>
                """;
            
            sendResponse(exchange, 200, response, "text/html");
        }
    }

    static class HealthHandler implements HttpHandler {
        @Override
        public void handle(HttpExchange exchange) throws IOException {
            String response = "{\"status\": \"OK\", \"service\": \"SimpleHttpServer\"}";
            sendResponse(exchange, 200, response, "application/json");
        }
    }

    static class TimeHandler implements HttpHandler {
        @Override
        public void handle(HttpExchange exchange) throws IOException {
            LocalDateTime now = LocalDateTime.now();
            String timestamp = now.format(DateTimeFormatter.ISO_LOCAL_DATE_TIME);
            
            String response = String.format(
                "{\"current_time\": \"%s\", \"timezone\": \"System Default\"}", 
                timestamp
            );
            
            sendResponse(exchange, 200, response, "application/json");
        }
    }

    private static void sendResponse(HttpExchange exchange, int statusCode, 
                                   String response, String contentType) throws IOException {
        exchange.getResponseHeaders().set("Content-Type", contentType);
        exchange.sendResponseHeaders(statusCode, response.getBytes().length);
        
        try (OutputStream os = exchange.getResponseBody()) {
            os.write(response.getBytes());
        }
    }
}