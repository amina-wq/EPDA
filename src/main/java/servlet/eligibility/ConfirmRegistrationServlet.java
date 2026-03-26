package servlet.eligibility;

import java.io.IOException;

import ejb.EligibilityCheckBean;
import jakarta.ejb.EJB;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/confirm_registration")
public class ConfirmRegistrationServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @EJB
    private EligibilityCheckBean eligibilityBean;

    @Override
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        String studentId = request.getParameter("studentId");

        if (studentId != null && !studentId.isEmpty()) {
            try {
                eligibilityBean.confirmEligibility(studentId);

                request.getSession().setAttribute("message", "Registration successfully confirmed for student ID: " + studentId);
                request.getSession().setAttribute("messageType", "success");

            } catch (Exception e) {
                e.printStackTrace();
                request.getSession().setAttribute("message", "Error confirming registration: " + e.getMessage());
                request.getSession().setAttribute("messageType", "error");
            }
        } else {
            request.getSession().setAttribute("message", "Error: Student ID is required");
            request.getSession().setAttribute("messageType", "error");
        }

        response.sendRedirect(request.getContextPath() + "/check_eligibility");
    }
}