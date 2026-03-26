package ejb;

import jakarta.annotation.Resource;
import jakarta.ejb.Stateless;
import javax.sql.DataSource;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import model.User;

@Stateless
public class UserBean {

    // Grabs the connection Amina set up in the server
    @Resource(name = "mysql")
    private DataSource ds;

    // F1: Login Logic
    public User authenticateUser(String username, String password) {
        try (Connection conn = ds.getConnection()) {
            String sql = "SELECT * FROM user WHERE username = ? AND password = ? AND active = 1";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, username);
            ps.setString(2, password);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return mapUser(rs);
        } catch (SQLException e) { e.printStackTrace(); }
        return null;
    }

    // F1: Reset by ID (Matches UserListServlet)
    public boolean resetPassword(Long id, String pass) {
        return executeUpdate("UPDATE user SET password = ? WHERE id = ?", pass, id);
    }

    // F1: Reset by Email (Matches ResetPasswordServlet - THE RED LINE FIX)
    public boolean resetPasswordByEmail(String email, String pass) {
        return executeUpdate("UPDATE user SET password = ? WHERE email = ?", pass, email);
    }

    // F1: Toggle Status
    public boolean updateUserStatus(Long id, boolean active) {
        return executeUpdate("UPDATE user SET active = ? WHERE id = ?", active, id);
    }

    public List<User> getAllUsers() {
        List<User> users = new ArrayList<>();
        try (Connection conn = ds.getConnection()) {
            ResultSet rs = conn.createStatement().executeQuery("SELECT * FROM user");
            while (rs.next()) users.add(mapUser(rs));
        } catch (SQLException e) { e.printStackTrace(); }
        return users;
    }

    public User getUserById(Long id) {
        try (Connection conn = ds.getConnection()) {
            PreparedStatement ps = conn.prepareStatement("SELECT * FROM user WHERE id = ?");
            ps.setLong(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return mapUser(rs);
        } catch (SQLException e) { e.printStackTrace(); }
        return null;
    }

    public boolean isStudentValid(String email) {
       try (Connection conn = ds.getConnection()) {
            PreparedStatement ps = conn.prepareStatement("SELECT COUNT(*) FROM student WHERE email = ?");
            ps.setString(1, email);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getInt(1) > 0;
        } catch (SQLException e) { e.printStackTrace(); }
        return false;
    }

    private User mapUser(ResultSet rs) throws SQLException {
        User u = new User();
        u.setId(rs.getLong("id"));
        u.setUsername(rs.getString("username"));
        u.setEmail(rs.getString("email"));
        u.setRole(rs.getString("role"));
        u.setActive(rs.getBoolean("active"));
        return u;
    }

    private boolean executeUpdate(String sql, Object... params) {
        try (Connection conn = ds.getConnection()) {
            PreparedStatement ps = conn.prepareStatement(sql);
            for (int i = 0; i < params.length; i++) ps.setObject(i + 1, params[i]);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); return false; }
    }
    
    public boolean updateUser(Long id, String username, String email, String role) {
        String sql = "UPDATE user SET username = ?, email = ?, role = ? WHERE id = ?";
        try (Connection conn = ds.getConnection()) {
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, username);
            ps.setString(2, email);
            ps.setString(3, role);
            ps.setLong(4, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    public User authenticateByEmail(String email, String password) {
        try (Connection conn = ds.getConnection()) {
            String sql = "SELECT * FROM user WHERE email = ? AND password = ? AND active = 1";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, email);
            ps.setString(2, password);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return mapUser(rs);
        } catch (SQLException e) { 
            e.printStackTrace(); 
        }
        return null;
    }
    
    public boolean registerUser(String username, String email, String password, String role) {
        // We set 'active' to 1 (true) by default for new staff
        String sql = "INSERT INTO user (username, email, password, role, active) VALUES (?, ?, ?, ?, 1)";
        
        try (Connection conn = ds.getConnection()) {
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, username);
            ps.setString(2, email);
            ps.setString(3, password);
            ps.setString(4, role);
            
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
}