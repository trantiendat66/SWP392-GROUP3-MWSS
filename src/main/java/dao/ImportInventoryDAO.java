/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;

import db.DBContext;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;
import model.ImportInventory;

/**
 *
 * @author hau
 */
public class ImportInventoryDAO extends DBContext {

    public int insertImportInventory(ImportInventory item) {
        int newId = -1;
        String sql = "INSERT INTO ImportInvetory (total_import_price, import_at, import_date, total_import_quantity, supplier, import_status) "
                + "VALUES (?, ?, ?, ?, ?, ?)";
        try (PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, item.getTotalImportPrice());
            ps.setDate(2, item.getImportAt());
            ps.setDate(3, item.getImportDate());
            ps.setInt(4, item.getTotalImportQuantity());
            ps.setString(5, item.getSupplier());
            ps.setBoolean(6, item.isImportStatus());

            ps.executeUpdate();

            try (ResultSet rs = ps.getGeneratedKeys()) {
                if (rs.next()) {
                    newId = rs.getInt(1);
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return newId;
    }

    public List<ImportInventory> getAllImportInventory() {
        List<ImportInventory> list = new ArrayList<>();
        String sql = "SELECT * FROM ImportInvetory ORDER BY import_at DESC";
        try (PreparedStatement ps = conn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                ImportInventory item = new ImportInventory();
                item.setImportInvetoryId(rs.getInt("import_invetory_id"));
                item.setTotalImportPrice(rs.getInt("total_import_price"));
                item.setImportAt(rs.getDate("import_at"));
                item.setImportDate(rs.getDate("import_date"));
                item.setTotalImportQuantity(rs.getInt("total_import_quantity"));
                item.setSupplier(rs.getString("supplier"));
                item.setImportStatus(rs.getBoolean("import_status"));
                list.add(item);
            }
        } catch (SQLException e) {
            e.printStackTrace();
            System.out.println("Error loading import list: " + e.getMessage());
        }
        return list;
    }

    public ImportInventory getImportInventoryById(int id) {
        String sql = "SELECT * FROM ImportInvetory WHERE import_invetory_id = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    ImportInventory item = new ImportInventory();
                    item.setImportInvetoryId(rs.getInt("import_invetory_id"));
                    item.setTotalImportPrice(rs.getInt("total_import_price"));
                    item.setImportAt(rs.getDate("import_at"));
                    item.setImportDate(rs.getDate("import_date"));
                    item.setTotalImportQuantity(rs.getInt("total_import_quantity"));
                    item.setSupplier(rs.getString("supplier"));
                    item.setImportStatus(rs.getBoolean("import_status"));
                    return item;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
            System.out.println("Error get import inventory by id: " + e.getMessage());
        }
        return null;
    }

    public void updateStatus(int id, boolean status) {
        String sql = "UPDATE ImportInvetory SET import_status = ? WHERE import_invetory_id = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setBoolean(1, status);
            ps.setInt(2, id);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public void deleteImportInventory(int inventoryId) {
        String sql = "DELETE FROM ImportInvetory WHERE import_invetory_id = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, inventoryId);
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}
