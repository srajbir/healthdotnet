package com.healthdotnet.model;

public class Prescriptions {
    private int prescriptionId;
    private int medicineId;
    private int reportId;
    private String dosage;
    private String duration;
    private String instruction;

    // Constructor
    public Prescriptions() {}

    public Prescriptions(int prescriptionId, int medicineId, int reportId, String dosage, String duration, String instruction) {
        this.prescriptionId = prescriptionId;
        this.medicineId = medicineId;
        this.reportId = reportId;
        this.dosage = dosage;
        this.duration = duration;
        this.instruction = instruction;
    }

    // Override toString for better readability
    @Override
    public String toString() {
        return "Prescriptions{" +
                "prescriptionId=" + prescriptionId +
                ", medicineId=" + medicineId +
                ", reportId=" + reportId +
                ", dosage='" + dosage + '\'' +
                ", duration='" + duration + '\'' +
                ", instruction='" + instruction + '\'' +
                '}';
    }

    // Getters
    public int getPrescriptionId() {
        return prescriptionId;
    }
    public int getMedicineId() {
        return medicineId;
    }
    public int getReportId() {
        return reportId;
    }
    public String getDosage() {
        return dosage;
    }
    public String getDuration() {
        return duration;
    }
    public String getInstruction() {
        return instruction;
    }

    // Setters
    public void setPrescriptionId(int prescriptionId) {
        this.prescriptionId = prescriptionId;
    }
    public void setMedicineId(int medicineId) {
        this.medicineId = medicineId;
    }
    public void setReportId(int reportId) {
        this.reportId = reportId;
    }
    public void setDosage(String dosage) {
        this.dosage = dosage;
    }
    public void setDuration(String duration) {
        this.duration = duration;
    }
    public void setInstruction(String instruction) {
        this.instruction = instruction;
    }
}
