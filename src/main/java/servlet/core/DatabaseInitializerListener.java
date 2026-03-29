package servlet.core;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

import javax.sql.DataSource;

import jakarta.annotation.Resource;
import jakarta.servlet.ServletContextEvent;
import jakarta.servlet.ServletContextListener;
import jakarta.servlet.annotation.WebListener;


@WebListener
public class DatabaseInitializerListener implements ServletContextListener {

	@Resource(name = "mysql")
    private DataSource dataSource;
    
    private static final String CHECK_TABLE_QUERY = "SELECT COUNT(*) FROM users";
    private static final String INIT_SCRIPT_PATH = "database/create_tables.sql";
    
    @Override
    public void contextInitialized(ServletContextEvent sce) {
        try {
            if (!isDatabaseInitialized()) {
                sce.getServletContext().log("Database not initialized. Running initialization script...");
                runInitScript();
                sce.getServletContext().log("Database initialization completed successfully.");
            } else {
                sce.getServletContext().log("Database already initialized. Skipping script.");
            }
        } catch (Exception e) {
            sce.getServletContext().log("Database initialization failed: " + e.getMessage(), e);
        }
    }
    
    private boolean isDatabaseInitialized() {
        try (Connection conn = dataSource.getConnection();
             Statement stmt = conn.createStatement()) {
            
            ResultSet rs = stmt.executeQuery(CHECK_TABLE_QUERY);
            rs.close();
            return true;
            
        } catch (SQLException e) {
            return false;
        }
    }
    
    private void runInitScript() {
        try (Connection conn = dataSource.getConnection();
             Statement stmt = conn.createStatement()) {
            
            InputStream inputStream = getClass().getClassLoader().getResourceAsStream(INIT_SCRIPT_PATH);
            if (inputStream == null) {
                throw new RuntimeException("Init script not found: " + INIT_SCRIPT_PATH);
            }
            
            BufferedReader reader = new BufferedReader(new InputStreamReader(inputStream));
            StringBuilder sql = new StringBuilder();
            String line;
            
            while ((line = reader.readLine()) != null) {
                line = line.trim();
                if (line.isEmpty() || line.startsWith("--") || line.startsWith("//")) {
                    continue;
                }
                sql.append(line).append(" ");
                
                if (line.endsWith(";")) {
                    String command = sql.toString();
                    command = command.substring(0, command.length() - 1);
                    stmt.execute(command);
                    sql.setLength(0);
                }
            }
            
            reader.close();
            
        } catch (IOException | SQLException e) {
            throw new RuntimeException("Failed to run init script", e);
        }
    }
}
