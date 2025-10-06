package com.healthdotnet.model;
import java.time.LocalDateTime;

public class Logs {
    private int logId;
    private int userId;
    private String action;
    private LocalDateTime timestamp;

    // Constructor
    public Logs() {}

    public Logs(int logId, int userId, String action, LocalDateTime timestamp) {
        this.logId = logId;
        this.userId = userId;
        this.action = action;
        this.timestamp = timestamp;
    }

    // Override toString for better readability
    @Override
    public String toString() {
        return "Logs{" +
                "logId=" + logId +
                ", userId=" + userId +
                ", action='" + action + "\'" +
                ", timestamp=" + timestamp +
                '}';
    }

    // Getters
    public int getLogId() {
        return logId;
    }
    public int getUserId() {
        return userId;
    }
    public String getAction() {
        return action;
    }
    public LocalDateTime getTimestamp() {
        return timestamp;
    }

    // Setters
    public void setLogId(int logId) {
        this.logId = logId;
    }
    public void setUserId(int userId) {
        this.userId = userId;
    }
    public void setAction(String action) {
        this.action = action;
    }
    public void setTimestamp(LocalDateTime timestamp) {
        this.timestamp = timestamp;
    }

}
