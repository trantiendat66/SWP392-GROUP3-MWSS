/*

 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license

 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template

 */
package dao;

import db.DBContext;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import model.Staff;

/**
 *
 *
 *
 * @author Cola
 *
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

    public Staff getStaffById(int account_id) {
        Staff staff = null;
        // Tên bảng Staff
        String sql = "SELECT * FROM Staff WHERE account_id = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, account_id);
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
                        System.out.println("Staff account is not active: " + account_id);
                        return null;
                    }
                }
            }
        } catch (SQLException e) {
            System.err.println("getStaffById error: SQLState=" + e.getSQLState() + ", Code=" + e.getErrorCode());
            e.printStackTrace();
        }
        return staff;
    }

    public boolean updatePasswordById(int accountId, String newHash) {
        final String sql = "UPDATE Staff SET password = ? WHERE account_id = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, newHash);
            ps.setInt(2, accountId);
            return ps.executeUpdate() == 1;
        } catch (SQLException e) {
            System.err.println("updatePasswordById SQLState=" + e.getSQLState() + ", Code=" + e.getErrorCode());
            throw new RuntimeException("DB error updating password", e);
        }
    }

    public Staff getStaff(int accountId) {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }

    public List<Staff> getAllStaff() {
        List<Staff> list = new ArrayList<>();
        String sql = "SELECT * FROM Staff ORDER BY account_id DESC";
        try (PreparedStatement ps = conn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Staff staff = new Staff();
                staff.setAccountId(rs.getInt("account_id"));
                staff.setUserName(rs.getString("user_name"));
                staff.setEmail(rs.getString("email"));
                staff.setPhone(rs.getString("phone"));
                staff.setPassword(rs.getString("password"));
                staff.setRole(rs.getString("role"));
                staff.setPosition(rs.getString("position"));
                staff.setAddress(rs.getString("address"));
                staff.setStatus(rs.getString("status"));
                // nếu chỉ lấy Active: if (!"Active".equalsIgnoreCase(staff.getStatus())) continue;
                list.add(staff);
            }
        } catch (SQLException e) {
            System.err.println("getAllStaff error: SQLState=" + e.getSQLState() + ", Code=" + e.getErrorCode());
            e.printStackTrace();
        }
        return list;
    }

    public boolean addStaff(Staff s) {
        String sql = "INSERT INTO Staff (user_name, password, email, phone, role, position, address, status) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?, ?)";

        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, s.getUserName());
            ps.setString(2, s.getPassword());
            ps.setString(3, s.getEmail());
            ps.setString(4, s.getPhone());
            ps.setString(5, s.getRole());
            ps.setString(6, s.getPosition());
            ps.setString(7, s.getAddress());
            ps.setString(8, s.getStatus());

            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("addStaff error: SQLState=" + e.getSQLState() + ", Code=" + e.getErrorCode());
            e.printStackTrace();
        }
        return false;
    }

    public boolean updateStaff(Staff s) {
        String sql = "UPDATE Staff SET email=?, phone=?, role=?, position=?, address=?, status=? WHERE account_id=?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, s.getEmail());
            ps.setString(2, s.getPhone());
            ps.setString(3, s.getRole());
            ps.setString(4, s.getPosition());
            ps.setString(5, s.getAddress());
            ps.setString(6, s.getStatus());
            ps.setInt(7, s.getAccountId());

            int row = ps.executeUpdate();
            System.out.println("Rows updated: " + row);
            return row > 0;
        } catch (Exception e) {
            System.out.println("updateStaff error: " + e.getMessage());
        }
        return false;
    }

    public boolean deleteStaff(int id) {
        String sql = "DELETE FROM Staff WHERE account_id=?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            System.out.println("deleteStaff error: " + e.getMessage());
        }
        return false;
    }

}
