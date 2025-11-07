/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;

import db.DBContext;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import model.Customer;

/**
 *
 * @author Oanh Nguyen
 */
public class CustomerDAO extends DBContext {

    public CustomerDAO() {
        super();
    }

    public List<Customer> getAllCustomers() {
        List<Customer> list = new ArrayList<>();
        String sql = "SELECT customer_id, customer_name, phone, email, address, dob, gender, account_status, image, password "
                + "FROM Customer ORDER BY customer_id";

        try (PreparedStatement ps = conn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Customer c = new Customer();
                c.setCustomer_id(rs.getInt("customer_id"));
                c.setCustomer_name(rs.getString("customer_name"));
                c.setPhone(rs.getString("phone"));
                c.setEmail(rs.getString("email"));
                c.setAddress(rs.getString("address"));

                // LẤY VÀ SET MẬT KHẨU ĐÃ HASH
                c.setPassword(rs.getString("password"));

                c.setDob(rs.getDate("dob"));
                boolean genderBit = rs.getBoolean("gender");
                c.setGender(genderBit ? "Female" : "Male");

                c.setAccount_status(rs.getString("account_status"));
                c.setImage(rs.getString("image"));

                list.add(c);
            }
        } catch (SQLException e) {
            System.err.println("getAllCustomers SQLState=" + e.getSQLState() + ", Code=" + e.getErrorCode());
            e.printStackTrace();
        }
        return list;
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

    // Cập nhật password đã băm cho id
    public boolean updatePasswordById(int customer_id, String newHash) {
        final String sql = "UPDATE Customer SET password = ? WHERE customer_id = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, newHash);
            ps.setInt(2, customer_id);
            return ps.executeUpdate() == 1;
        } catch (SQLException e) {
            System.err.println("updatePasswordById SQLState=" + e.getSQLState() + ", Code=" + e.getErrorCode());
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
            if (c.getDob() == null) {
                throw new SQLException("Date of Birth is required");
            }
            ps.setDate(6, new java.sql.Date(c.getDob().getTime()));
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

    public Customer getCustomerById(int id) {
        String sql = "SELECT Customer_id, Customer_name, Phone, Email, Address, Password, Dob, Gender, Account_status, Image FROM Customer WHERE Customer_id = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Customer c = new Customer();
                    c.setCustomer_id(rs.getInt("Customer_id"));
                    c.setCustomer_name(rs.getString("Customer_name"));
                    c.setPhone(rs.getString("Phone"));
                    c.setEmail(rs.getString("Email"));
                    c.setAddress(rs.getString("Address"));
                    c.setPassword(rs.getString("Password"));
                    c.setDob(rs.getDate("Dob"));
                    int genderValue = rs.getInt("Gender");
                    String genderText;
                    if (genderValue == 0) {
                        genderText = "Male";
                    } else {
                        genderText = "Female";
                    }
                    c.setGender(genderText);
                    c.setAccount_status(rs.getString("Account_status"));
                    c.setImage(rs.getString("Image"));
                    return c;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public boolean updateCustomer(Customer c) {
        String sql = "UPDATE Customer SET Customer_name = ?, Phone = ?, Email = ?, Address = ?, Password = ?, Dob = ?, Gender = ?, Image = ? WHERE Customer_id = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, c.getCustomer_name());
            ps.setString(2, c.getPhone());
            ps.setString(3, c.getEmail());
            ps.setString(4, c.getAddress());
            ps.setString(5, c.getPassword());
            ps.setDate(6, c.getDob());
            int genderValue;
            if ("Male".equals(c.getGender())) {
                genderValue = 0;
            } else {
                genderValue = 1;
            }
            ps.setInt(7, genderValue);
            ps.setString(7, c.getGender());
            ps.setString(8, c.getImage());
            ps.setInt(9, c.getCustomer_id());
            int rows = ps.executeUpdate();
            return rows > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public Customer getCustomerByEmail(String email) {
        String sql = "SELECT * FROM Customer WHERE email = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, email);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                Customer c = new Customer();
                c.setCustomer_id(rs.getInt("customer_id"));
                c.setCustomer_name(rs.getString("customer_name"));
                c.setEmail(rs.getString("email"));
                c.setPhone(rs.getString("phone"));
                c.setPassword(rs.getString("password"));
                boolean genderBit = rs.getBoolean("gender");
                c.setGender(genderBit ? "Female" : "Male");
                c.setDob(rs.getDate("dob"));
                c.setAddress(rs.getString("address"));
                c.setAccount_status(rs.getString("account_status"));
                c.setImage(rs.getString("image"));
                return c;
            }
        } catch (SQLException e) {
            System.err.println("getCustomerByEmail SQLState=" + e.getSQLState() + ", Code=" + e.getErrorCode());
            e.printStackTrace();
        }
        return null;
    }

}
