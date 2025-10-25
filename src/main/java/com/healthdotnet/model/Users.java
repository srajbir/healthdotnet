package com.healthdotnet.model;
import java.time.LocalDate;

public class Users {
    public static enum Role {
        ADMIN,
        DOCTOR,
        PATIENT,
        RECEPTIONIST
    }

    private int userId;
    private Role role;
    private String fullName;
    private String username;
    private String password;
    private String email;
    private String contactNumber;
    private LocalDate dob;
    private Boolean isActive;
    private LocalDate createdAt;

    // Constructors
    public Users() {}

    public Users(int userId, Role role, String fullName, String username, String password, String email, String contactNumber, LocalDate dob, Boolean isActive, LocalDate createdAt) {
        this.userId = userId;
        this.role = role;
        this.fullName = fullName;
        this.username = username;
        this.password = password;
        this.email = email;
        this.contactNumber = contactNumber;
        this.dob = dob;
        this.isActive = isActive;
        this.createdAt = createdAt;
    }

    // Override toString for better readability
    @Override
    public String toString() {
        return "Users{" +
                "userId=" + userId +
                ", role=" + role +
                ", fullName='" + fullName + '\'' +
                ", username='" + username + '\'' +
                ", password='" + password + '\'' +
                ", email='" + email + '\'' +
                ", contactNumber='" + contactNumber + '\'' +
                ", dob=" + dob +
                ", isActive=" + isActive +
                ", createdAt=" + createdAt +
                '}';
    }

    // Getters
    public int getUserId() {
        return userId;
    }
    public Role getRole() {
        return role;
    }
    public String getFullName() {
        return fullName;
    }
    public String getUsername() {
        return username;
    }
    public String getPassword() {
        return password;
    }
    public String getEmail() {
        return email;
    }
    public String getContactNumber() {
        return contactNumber;
    }
    public LocalDate getDob() {
        return dob;
    }
    public Boolean getIsActive() {
        return isActive;
    }
    public LocalDate getCreatedAt() {
        return createdAt;
    }

    // Setters
    public void setUserId(int userId) {
        this.userId = userId;
    }
    public void setRole(Role role) {
        this.role = role;
    }
    public void setFullName(String fullName) {
        this.fullName = fullName;
    }
    public void setUsername(String username) {
        this.username = username;
    }
    public void setPassword(String password) {
        this.password = password;
    }
    public void setEmail(String email) {
        this.email = email;
    }
    public void setContactNumber(String contactNumber) {
        this.contactNumber = contactNumber;
    }
    public void setDob(LocalDate dob) {
        this.dob = dob;
    }
    public void setIsActive(Boolean isActive) {
        this.isActive = isActive;
    }
    public void setCreatedAt(LocalDate createdAt) {
        this.createdAt = createdAt;
    }
}
