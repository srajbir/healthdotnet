package com.healthdotnet.model;
import java.time.LocalDateTime;

public class Reports {
    private int reportId;
    private int appointmentId;
    private int doctorId;
    private int patientId;
    private String diagnosis;
    private String prescription;
    private LocalDateTime createdAt;

    // Constructor
    public Reports() {}

    public Reports(int reportId, int appointmentId, int doctorId, int patientId, String diagnosis, String prescription, LocalDateTime createdAt) {
        this.reportId = reportId;
        this.appointmentId = appointmentId;
        this.doctorId = doctorId;
        this.patientId = patientId;
        this.diagnosis = diagnosis;
        this.prescription = prescription;
        this.createdAt = createdAt;
    }

    // Override toString for better readability
    @Override
    public String toString() {
        return "Reports{" +
                "reportId=" + reportId +
                ", appointmentId=" + appointmentId +
                ", doctorId=" + doctorId +
                ", patientId=" + patientId +
                ", diagnosis='" + diagnosis + '\'' +
                ", prescription='" + prescription + '\'' +
                ", createdAt=" + createdAt +
                '}';
    }

    // Getters
    public int getReportId() {
        return reportId;
    }
    public int getAppointmentId() {
        return appointmentId;
    }
    public int getDoctorId() {
        return doctorId;
    }
    public int getPatientId() {
        return patientId;
    }
    public String getDiagnosis() {
        return diagnosis;
    }
    public String getPrescription() {
        return prescription;
    }
    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    // Setters
    public void setReportId(int reportId) {
        this.reportId = reportId;
    }
    public void setAppointmentId(int appointmentId) {
        this.appointmentId = appointmentId;
    }
    public void setDoctorId(int doctorId) {
        this.doctorId = doctorId;
    }
    public void setPatientId(int patientId) {
        this.patientId = patientId;
    }
    public void setDiagnosis(String diagnosis) {
        this.diagnosis = diagnosis;
    }
    public void setPrescription(String prescription) {
        this.prescription = prescription;
    }
    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }
}
