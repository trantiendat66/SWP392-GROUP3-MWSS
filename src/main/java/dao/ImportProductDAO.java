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
import model.ImportProduct;

/**
 *
 * @author hau
 */
public class ImportProductDAO extends DBContext {

    public boolean insertImportProduct(ImportProduct p) {
        String sql = "INSERT INTO ImportProduct "
                + "(import_invetory_id, product_id, import_product_quantity, import_product_price) "
                + "VALUES (?, ?, ?, ?)";

        try (PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, p.getImportInventoryId());
            ps.setInt(2, p.getProductId());
            ps.setInt(3, p.getImportQuantity());
            ps.setInt(4, p.getImportProductPrice());

            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public List<ImportProduct> getByInventoryId(int importInventoryId) {
        List<ImportProduct> list = new ArrayList<>();
        String sql = "SELECT ip.import_product_id, ip.import_invetory_id, ip.product_id, "
                + "ip.import_product_price, ip.import_product_quantity, p.product_name "
                + "FROM ImportProduct ip "
                + "JOIN Product p ON ip.product_id = p.product_id "
                + "WHERE ip.import_invetory_id = ?";

        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, importInventoryId);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    ImportProduct p = new ImportProduct();
                    p.setImportProductId(rs.getInt("import_product_id"));
                    p.setImportInventoryId(rs.getInt("import_invetory_id"));
                    p.setProductId(rs.getInt("product_id"));
                    p.setImportProductPrice(rs.getInt("import_product_price"));
                    p.setImportQuantity(rs.getInt("import_product_quantity"));
                    p.setProductName(rs.getString("product_name"));
                    list.add(p);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public void deleteByInventoryId(int importInventoryId) {
        String sql = "DELETE FROM ImportProduct WHERE import_invetory_id = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, importInventoryId);
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}
