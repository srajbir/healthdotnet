package com.healthdotnet.model;

public class Doctors {
    private int doctorId;
    private String speciality;
    private Double consultationFee;

    // Constructor
    public Doctors() {}

    public Doctors(int doctorId, String speciality, Double consultationFee) {
        this.doctorId = doctorId;
        this.speciality = speciality;
        this.consultationFee = consultationFee;
    }

    // Override toString for better readability
    @Override
    public String toString() {
        return "Doctors{" +
                "doctorId=" + doctorId +
                ", speciality='" + speciality + "\'" +
                ", consultationFee=" + consultationFee +
                '}';
    }

    // Getters
    public int getDoctorId() {
        return doctorId;
    }
    public String getSpeciality() {
        return speciality;
    }
    public Double getConsultationFee() {
        return consultationFee;
    }

    // Setters
    public void setDoctorId(int doctorId) {
        this.doctorId = doctorId;
    }
    public void setSpeciality(String speciality) {
        this.speciality = speciality;
    }
    public void setConsultationFee(Double consultationFee) {
        this.consultationFee = consultationFee;
    }
}