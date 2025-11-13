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
import model.Brand;

/**
 *
 * @author Nguyen Thien Dat - CE190879 - 06/05/2005
 */
public class BrandDAO extends DBContext {

    public BrandDAO() {
        super();
    }

    public List<Brand> getAllBrand() {
        String sql = "SELECT * FROM Brand";
        List<Brand> list = new ArrayList<>();
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Brand b = new Brand();
                    b.setBrandId(rs.getInt("brand_id"));
                    b.setBrandName(rs.getString("brand_name"));
                    list.add(b);
                }
            }
        } catch (Exception e) {
            System.out.println(e.getMessage());
        }
        return list;
    }
}
