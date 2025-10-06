package com.healthdotnet.model;
import java.time.LocalDateTime;

public class Medicines {
    private int medicineId;
    private String medicineName;
    private String medicineDescription;
    private double medicinePrice;
    private LocalDateTime createdAt;

    // Constructor
    public Medicines() {}

    public Medicines(int medicineId, String medicineName, String medicineDescription, double medicinePrice, LocalDateTime createdAt) {
        this.medicineId = medicineId;
        this.medicineName = medicineName;
        this.medicineDescription = medicineDescription;
        this.medicinePrice = medicinePrice;
        this.createdAt = createdAt;
    }

    // Override toString for better readability
    @Override
    public String toString() {
        return "Medicines{" +
                "medicineId=" + medicineId +
                ", medicineName='" + medicineName + '\'' +
                ", medicineDescription='" + medicineDescription + '\'' +
                ", medicinePrice=" + medicinePrice +
                ", createdAt=" + createdAt +
                '}';
    }

    //Getters
    public int getMedicineId() {
        return medicineId;
    }
    public String getMedicineName() {
        return medicineName;
    }
    public String getMedicineDescription() {
        return medicineDescription;
    }
    public double getMedicinePrice() {
        return medicinePrice;
    }
    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    //Setters
    public void setMedicineId(int medicineId) {
        this.medicineId = medicineId;
    }
    public void setMedicineName(String medicineName) {
        this.medicineName = medicineName;
    }
    public void setMedicineDescription(String medicineDescription) {
        this.medicineDescription = medicineDescription;
    }
    public void setMedicinePrice(double medicinePrice) {
        this.medicinePrice = medicinePrice;
    }
    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }
}