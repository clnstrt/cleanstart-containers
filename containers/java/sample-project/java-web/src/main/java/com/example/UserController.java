package com.example;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.util.List;

@Controller
public class UserController {

    @Autowired
    private DatabaseService databaseService;

    @GetMapping("/")
    public String index(Model model) {
        List<User> users = databaseService.getAllUsers();
        model.addAttribute("users", users);
        return "index";
    }

    @GetMapping("/add")
    public String addUserForm(Model model) {
        model.addAttribute("user", new User());
        return "add-user";
    }

    @PostMapping("/add")
    public String addUser(@ModelAttribute User user, RedirectAttributes redirectAttributes) {
        if (user.getName() == null || user.getName().trim().isEmpty() ||
            user.getEmail() == null || user.getEmail().trim().isEmpty()) {
            redirectAttributes.addFlashAttribute("error", "Name and email are required!");
            return "redirect:/add";
        }

        boolean success = databaseService.addUser(user.getName(), user.getEmail());
        if (success) {
            redirectAttributes.addFlashAttribute("success", "User added successfully!");
        } else {
            redirectAttributes.addFlashAttribute("error", "Failed to add user. Email might already exist.");
        }
        return "redirect:/";
    }

    @PostMapping("/delete/{id}")
    public String deleteUser(@PathVariable int id, RedirectAttributes redirectAttributes) {
        boolean success = databaseService.deleteUser(id);
        if (success) {
            redirectAttributes.addFlashAttribute("success", "User deleted successfully!");
        } else {
            redirectAttributes.addFlashAttribute("error", "Failed to delete user.");
        }
        return "redirect:/";
    }

    @PostMapping("/reset")
    public String resetDatabase(RedirectAttributes redirectAttributes) {
        boolean success = databaseService.resetDatabase();
        if (success) {
            redirectAttributes.addFlashAttribute("success", "Database reset successfully!");
        } else {
            redirectAttributes.addFlashAttribute("error", "Failed to reset database.");
        }
        return "redirect:/";
    }

    // REST API endpoints
    @GetMapping("/api/users")
    @ResponseBody
    public List<User> getUsersApi() {
        return databaseService.getAllUsers();
    }

    @PostMapping("/api/users")
    @ResponseBody
    public ApiResponse addUserApi(@RequestBody User user) {
        if (user.getName() == null || user.getName().trim().isEmpty() ||
            user.getEmail() == null || user.getEmail().trim().isEmpty()) {
            return new ApiResponse(false, "Name and email are required!");
        }

        boolean success = databaseService.addUser(user.getName(), user.getEmail());
        if (success) {
            return new ApiResponse(true, "User added successfully!");
        } else {
            return new ApiResponse(false, "Failed to add user. Email might already exist.");
        }
    }

    @DeleteMapping("/api/users/{id}")
    @ResponseBody
    public ApiResponse deleteUserApi(@PathVariable int id) {
        boolean success = databaseService.deleteUser(id);
        if (success) {
            return new ApiResponse(true, "User deleted successfully!");
        } else {
            return new ApiResponse(false, "Failed to delete user.");
        }
    }

    // Helper class for API responses
    public static class ApiResponse {
        private boolean success;
        private String message;

        public ApiResponse(boolean success, String message) {
            this.success = success;
            this.message = message;
        }

        public boolean isSuccess() {
            return success;
        }

        public void setSuccess(boolean success) {
            this.success = success;
        }

        public String getMessage() {
            return message;
        }

        public void setMessage(String message) {
            this.message = message;
        }
    }
}
