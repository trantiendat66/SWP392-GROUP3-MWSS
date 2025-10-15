/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;

import db.DBContext;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import model.Staff;

/**
 *
 * @author Cola
 */
public class StaffDAO extends DBContext {

    public StaffDAO() {
        super();
    }

    public Staff getStaffByEmail(String email) {
        Staff staff = null;
        // Tên bảng Staff
        String sql = "SELECT * FROM Staff WHERE email = ?";

        try (PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, email);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    staff = new Staff();

                    staff.setAccountId(rs.getInt("account_id"));
                    staff.setUserName(rs.getString("user_name"));
                    staff.setEmail(rs.getString("email"));
                    staff.setPhone(rs.getString("phone"));
                    staff.setPassword(rs.getString("password"));
                    staff.setRole(rs.getString("role"));
                    staff.setPosition(rs.getString("position"));
                    staff.setAddress(rs.getString("address"));
                    staff.setStatus(rs.getString("status"));

                    if (!"Active".equalsIgnoreCase(staff.getStatus())) {
                        System.out.println("Staff account is not active: " + email);
                        return null;
                    }
                }
            }

        } catch (SQLException e) {
            System.err.println("getStaffByEmail error: SQLState=" + e.getSQLState() + ", Code=" + e.getErrorCode());
            e.printStackTrace();
        }
        return staff;
    }
}
