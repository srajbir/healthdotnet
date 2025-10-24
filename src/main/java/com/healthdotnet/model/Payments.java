package com.healthdotnet.model;
import java.time.LocalDateTime;

public class Payments {
    private enum Status { PENDING, PAID;}

    private int paymentId;
    private int appointmentId;
    private int patientId;
    private double totalFee;
    private String transactionId;
    private Status paymentStatus;
    private LocalDateTime paymentTime;

    // Constructor
    public Payments() {}

    public Payments(int paymentId, int patientId, int appointmentId, double totalFee, String transactionId, Status paymentStatus, LocalDateTime paymentTime) {
        this.paymentId = paymentId;
        this.patientId = patientId;
        this.appointmentId = appointmentId;
        this.totalFee = totalFee;
        this.transactionId = transactionId;
        this.paymentStatus = paymentStatus;
        this.paymentTime = paymentTime;
    }

    // Override toString for better readability
    @Override
    public String toString() {
        return "Payments{" +
                "paymentId=" + paymentId +
                ", patientId=" + patientId +
                ", appointmentId=" + appointmentId +
                ", totalFee=" + totalFee +
                ", transactionId='" + transactionId + '\'' +
                ", paymentStatus=" + paymentStatus +
                ", paymentTime=" + paymentTime +
                '}';
    }

    // Getters
    public int getPaymentId() {
        return paymentId;
    }
    public int getPatientId() {
        return patientId;
    }
    public int getAppointmentId() {
        return appointmentId;
    }
    public double getTotalFee() {
        return totalFee;
    }
    public String getTransactionId() {
        return transactionId;
    }
    public Status getPaymentStatus() {
        return paymentStatus;
    }
    public LocalDateTime getPaymentTime() {
        return paymentTime;
    }

    // Setters
    public void setPaymentId(int paymentId) {
        this.paymentId = paymentId;
    }
    public void setPatientId(int patientId) {
        this.patientId = patientId;
    }
    public void setAppointmentId(int appointmentId) {
        this.appointmentId = appointmentId;
    }
    public void setTotalFee(double totalFee) {
        this.totalFee = totalFee;
    }
    public void setTransactionId(String transactionId) {
        this.transactionId = transactionId;
    }
    public void setPaymentStatus(Status paymentStatus) {
        this.paymentStatus = paymentStatus;
    }
    public void setPaymentTime(LocalDateTime paymentTime) {
        this.paymentTime = paymentTime;
    }
}
