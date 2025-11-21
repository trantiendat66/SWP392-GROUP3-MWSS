package controller;

import dao.ImportInventoryDAO;
import dao.ImportProductDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import model.ImportInventory;

@WebServlet(name = "DeleteImportInventoryServlet", urlPatterns = {"/deleteimportinventory"})
public class DeleteImportInventoryServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            int id = Integer.parseInt(request.getParameter("id"));
            ImportInventoryDAO inventoryDAO = new ImportInventoryDAO();
            ImportInventory inventory = inventoryDAO.getImportInventoryById(id);

            if (inventory == null) {
                request.getSession().setAttribute("error", "Import not found.");
                response.sendRedirect("listimportinventory");
                return;
            }

            if (inventory.isImportStatus()) {
                request.getSession().setAttribute("error", "Cannot delete an import that has already been completed.");
                response.sendRedirect("listimportinventory");
                return;
            }

            ImportProductDAO productDAO = new ImportProductDAO();
            productDAO.deleteByInventoryId(id);
            inventoryDAO.deleteImportInventory(id);

            request.getSession().setAttribute("success", "Import deleted successfully.");
            response.sendRedirect("listimportinventory");
        } catch (Exception e) {
            e.printStackTrace();
            request.getSession().setAttribute("error", "Unexpected error while deleting import.");
            response.sendRedirect("listimportinventory");
        }
    }
}

