package controller;

import dao.ImportInventoryDAO;
import dao.ImportProductDAO;
import dao.ProductDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.Date;
import java.time.LocalDate;
import java.util.List;
import model.ImportInventory;
import model.ImportProduct;
import model.Product;

@WebServlet(name = "EditImportInventoryServlet", urlPatterns = {"/editimportinventory"})
public class EditImportInventoryServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            int id = Integer.parseInt(request.getParameter("id"));
            ImportInventoryDAO inventoryDAO = new ImportInventoryDAO();
            ImportInventory inventory = inventoryDAO.getImportInventoryById(id);

            if (inventory == null) {
                response.sendRedirect("listimportinventory");
                return;
            }

            if (inventory.isImportStatus()) {
                request.getSession().setAttribute("error", "Cannot edit an import that has already been completed.");
                response.sendRedirect("listimportinventory");
                return;
            }

            ProductDAO productDAO = new ProductDAO();
            ImportProductDAO detailDAO = new ImportProductDAO();

            List<Product> products = productDAO.getAllProductsForImport();
            List<ImportProduct> details = detailDAO.getByInventoryId(id);

            request.setAttribute("inventory", inventory);
            request.setAttribute("details", details);
            request.setAttribute("products", products);
            request.getRequestDispatcher("import_edit.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("listimportinventory");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            int inventoryId = Integer.parseInt(request.getParameter("inventoryId"));
            ImportInventoryDAO inventoryDAO = new ImportInventoryDAO();
            ImportInventory current = inventoryDAO.getImportInventoryById(inventoryId);

            if (current == null) {
                request.getSession().setAttribute("error", "Import not found.");
                response.sendRedirect("listimportinventory");
                return;
            }

            if (current.isImportStatus()) {
                request.getSession().setAttribute("error", "Cannot edit an import that has already been completed.");
                response.sendRedirect("listimportinventory");
                return;
            }

            String[] productIds = request.getParameterValues("productId");
            String[] prices = request.getParameterValues("importPrice");
            String[] quantities = request.getParameterValues("importQuantity");
            String supplier = request.getParameter("supplier");
            String importDateStr = request.getParameter("importDate");

            if (productIds == null || prices == null || quantities == null || supplier == null || importDateStr == null) {
                request.getSession().setAttribute("error", "Invalid form submission.");
                response.sendRedirect("editimportinventory?id=" + inventoryId);
                return;
            }

            LocalDate importDate = LocalDate.parse(importDateStr);
            if (importDate.isBefore(LocalDate.now())) {
                request.getSession().setAttribute("error", "Import date cannot be in the past.");
                response.sendRedirect("editimportinventory?id=" + inventoryId);
                return;
            }

            int totalPrice = 0;
            int totalQuantity = 0;
            for (int i = 0; i < productIds.length; i++) {
                int price = Integer.parseInt(prices[i]);
                int quantity = Integer.parseInt(quantities[i]);
                totalPrice += price * quantity;
                totalQuantity += quantity;
            }

            ImportInventory updated = new ImportInventory();
            updated.setImportInvetoryId(inventoryId);
            updated.setImportDate(Date.valueOf(importDate));
            updated.setSupplier(supplier);
            updated.setTotalImportPrice(totalPrice);
            updated.setTotalImportQuantity(totalQuantity);

            boolean success = inventoryDAO.updateImportInventory(updated);
            if (!success) {
                request.getSession().setAttribute("error", "Unable to update import. It might have been approved already.");
                response.sendRedirect("listimportinventory");
                return;
            }

            ImportProductDAO detailDAO = new ImportProductDAO();
            detailDAO.deleteByInventoryId(inventoryId);

            for (int i = 0; i < productIds.length; i++) {
                ImportProduct detail = new ImportProduct();
                detail.setImportInventoryId(inventoryId);
                detail.setProductId(Integer.parseInt(productIds[i]));
                detail.setImportProductPrice(Integer.parseInt(prices[i]));
                detail.setImportQuantity(Integer.parseInt(quantities[i]));
                detailDAO.insertImportProduct(detail);
            }

            request.getSession().setAttribute("success", "Import updated successfully.");
            response.sendRedirect("listimportinventory");
        } catch (Exception e) {
            e.printStackTrace();
            request.getSession().setAttribute("error", "Unexpected error while updating import.");
            response.sendRedirect("listimportinventory");
        }
    }
}

