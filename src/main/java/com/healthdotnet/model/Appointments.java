package com.healthdotnet.model;
import java.time.LocalDateTime;

public class Appointments {
    private int appointmentId;
    private int patientId;
    private Integer doctorId;
    private String specialityRequired;
    private LocalDateTime appointmentDate;
    private String status;
    private String createdAt;

    // Constructor
    public Appointments() {}

    public Appointments(int appointmentId, int patientId, Integer doctorId, String specialityRequired, LocalDateTime appointmentDate, String status, String createdAt) {
        this.appointmentId = appointmentId;
        this.patientId = patientId;
        this.doctorId = doctorId;
        this.specialityRequired = specialityRequired;
        this.appointmentDate = appointmentDate;
        this.status = status;
        this.createdAt = createdAt;
    }

    // Override toString for better readability
    @Override
    public String toString() {
        return "Appointments{" +
                "appintmentId=" + appointmentId +
                ", patientId=" + patientId +
                ", doctorId=" + doctorId +
                ", specialityRequired='" + specialityRequired + '\'' +
                ", appointmentDate=" + appointmentDate +
                ", status='" + status + '\'' +
                ", createdAt='" + createdAt + '\'' +
                '}';
    }

    // Getters
    public int getAppointmentId() {
        return appointmentId;
    }
    public int getPatientId() {
        return patientId;
    }
    public Integer getDoctorId() {
        return doctorId;
    }
    public String getSpecialityRequired() {
        return specialityRequired;
    }
    public LocalDateTime getAppointmentDate() {
        return appointmentDate;
    }
    public String getStatus() {
        return status;
    }
    public String getCreatedAt() {
        return createdAt;
    }

    // Setters
    public void setAppointmentId(int appointmentId) {
        this.appointmentId = appointmentId;
    }
    public void setPatientId(int patientId) {
        this.patientId = patientId;
    }
    public void setDoctorId(Integer doctorId) {
        this.doctorId = doctorId;
    }
    public void setSpecialityRequired(String specialityRequired) {
        this.specialityRequired = specialityRequired;
    }
    public void setAppointmentDate(LocalDateTime appointmentDate) {
        this.appointmentDate = appointmentDate;
    }
    public void setStatus(String status) {
        this.status = status;
    }
    public void setCreatedAt(String createdAt) {
        this.createdAt = createdAt;
    }

}
