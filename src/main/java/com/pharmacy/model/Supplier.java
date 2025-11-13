package com.pharmacy.model;

import java.sql.Timestamp;

public class Supplier {
    private int supplierId;
    private String supplierName;
    private String contactPerson;
    private String phone;
    private String email;
    private String address;
    private String city;
    private String state;
    private String pincode;
    private String status;
    private Timestamp createdAt;
    private Timestamp updatedAt;

    public Supplier() {}

    public Supplier(String supplierName, String contactPerson, String phone,
                    String email, String address, String city, String state, String pincode) {
        this.supplierName = supplierName;
        this.contactPerson = contactPerson;
        this.phone = phone;
        this.email = email;
        this.address = address;
        this.city = city;
        this.state = state;
        this.pincode = pincode;
    }

    // Getters and Setters
    public int getSupplierId() { return supplierId; }
    public void setSupplierId(int supplierId) { this.supplierId = supplierId; }

    public String getSupplierName() { return supplierName; }
    public void setSupplierName(String supplierName) { this.supplierName = supplierName; }

    public String getContactPerson() { return contactPerson; }
    public void setContactPerson(String contactPerson) { this.contactPerson = contactPerson; }

    public String getPhone() { return phone; }
    public void setPhone(String phone) { this.phone = phone; }

    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }

    public String getAddress() { return address; }
    public void setAddress(String address) { this.address = address; }

    public String getCity() { return city; }
    public void setCity(String city) { this.city = city; }

    public String getState() { return state; }
    public void setState(String state) { this.state = state; }

    public String getPincode() { return pincode; }
    public void setPincode(String pincode) { this.pincode = pincode; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }

    public Timestamp getUpdatedAt() { return updatedAt; }
    public void setUpdatedAt(Timestamp updatedAt) { this.updatedAt = updatedAt; }

    public boolean isActive() {
        return "active".equalsIgnoreCase(this.status);
    }

    @Override
    public String toString() {
        return "Supplier{supplierId=" + supplierId + ", supplierName='" + supplierName + "'}";
    }
}