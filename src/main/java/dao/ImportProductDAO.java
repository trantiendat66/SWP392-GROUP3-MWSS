/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;

import db.DBContext;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import model.ImportProduct;

/**
 *
 * @author hau
 */
public class ImportProductDAO extends DBContext {
    public boolean insertImportProduct(ImportProduct p) {
        String sql = "INSERT INTO ImportProduct (import_inventory_id, product_id, import_product_quantity, import_product_price) "
                   + "VALUES (?, ?, ?, ?)";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, p.getImportInventoryId());
            ps.setInt(2, p.getProductId());
            ps.setInt(3, p.getImportQuantity());
            ps.setInt(4, p.getImportProductPrice());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            System.out.println("Error inserting import product: " + e.getMessage());
        }
        return false;
    }
}
