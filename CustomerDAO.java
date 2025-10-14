/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;

import db.DBContext;
import java.sql.*;
import model.Customer;

/**
 *
 * @author Oanh Nguyen
 */
public class CustomerDAO extends DBContext {

    public CustomerDAO() {
        super();
    }

    public boolean existsByEmail(String email) {
        String sql = "SELECT 1 FROM Customer WHERE email = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, email);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }
        } catch (SQLException e) {
            System.err.println("SQLState=" + e.getSQLState() + ", ErrorCode=" + e.getErrorCode());
            throw new RuntimeException("Database error when checking email: " + e.getMessage(), e);
        }
    }

    // Cập nhật password đã băm cho email
    public boolean updatePasswordByEmail(String email, String newHash) {
        final String sql = "UPDATE Customer SET password = ? WHERE email = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, newHash);
            ps.setString(2, email);
            return ps.executeUpdate() == 1;
        } catch (SQLException e) {
            System.err.println("updatePasswordByEmail SQLState=" + e.getSQLState() + ", Code=" + e.getErrorCode());
            throw new RuntimeException("DB error updating password", e);
        }
    }

    public boolean existsByPhone(String phone) {
        String sql = "SELECT 1 FROM Customer WHERE phone = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, phone);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }
        } catch (SQLException e) {
            System.err.println("SQLState=" + e.getSQLState() + ", ErrorCode=" + e.getErrorCode());
            throw new RuntimeException("Database error when checking phone: " + e.getMessage(), e);
        }
    }

    public int insert(Customer c) {
        String sql = "INSERT INTO Customer "
                + "(customer_name, phone, email, address, password, dob, gender, account_status, image) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";

        try (PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            ps.setNString(1, c.getCustomer_name());
            ps.setString(2, c.getPhone());
            ps.setString(3, c.getEmail());
            ps.setNString(4, c.getAddress());
            ps.setString(5, c.getPassword());

            // DOB bắt buộc vì cột NOT NULL
            if (c.getDob() == null) {
                throw new SQLException("Date of Birth is required");
            }
            ps.setDate(6, new java.sql.Date(c.getDob().getTime()));

            // gender = bit NOT NULL
            boolean genderBit = "Male".equalsIgnoreCase(c.getGender());
            ps.setBoolean(7, genderBit);

            ps.setString(8, c.getAccount_status());
            if (c.getImage() == null || c.getImage().isBlank()) {
                ps.setNull(9, Types.VARCHAR);
            } else {
                ps.setString(9, c.getImage());
            }

            int affected = ps.executeUpdate();
            if (affected == 0) {
                return -1;
            }

            try (ResultSet rs = ps.getGeneratedKeys()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
            return -1;

        } catch (SQLException e) {
            System.err.println("SQLState=" + e.getSQLState() + ", ErrorCode=" + e.getErrorCode());
            e.printStackTrace();
            return -1;
        }
    }
}
