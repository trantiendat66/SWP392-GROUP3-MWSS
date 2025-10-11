/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;

import db.DBContext;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import model.Customer;

/**
 *
 * @author hau
 */
public class CustomerDAO extends DBContext {

    public CustomerDAO() {
        super();
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

    public Customer getCustomerByEmailAndPassword(String email, String password) {
        String sql = "SELECT * FROM Customer WHERE email = ? AND password = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, email);
            ps.setString(2, password);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                Customer c = new Customer();
                c.setCustomer_id(rs.getInt("customer_id"));
                c.setCustomer_name(rs.getString("customer_name"));
                c.setEmail(rs.getString("email"));
                c.setPhone(rs.getString("phone"));
                c.setPassword(rs.getString("password"));
                c.setGender(rs.getBoolean("gender") ? "Male" : "Female");
                c.setDob(rs.getDate("dob"));
                c.setAddress(rs.getString("address"));
                c.setAccount_status(rs.getString("account_status"));
                c.setImage(rs.getString("image"));
                return c;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
}
