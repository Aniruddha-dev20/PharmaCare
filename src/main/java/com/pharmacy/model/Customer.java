package com.pharmacy.model;

import java.sql.Date;
import java.sql.Timestamp;

public class Customer {
    private int customerId;
    private String customerName;
    private String phone;
    private String email;
    private String address;
    private String city;
    private Date dateOfBirth;
    private Timestamp createdAt;
    private Timestamp updatedAt;

    public Customer() {}

    public Customer(String customerName, String phone, String email, String address, String city) {
        this.customerName = customerName;
        this.phone = phone;
        this.email = email;
        this.address = address;
        this.city = city;
    }

    // Getters and Setters
    public int getCustomerId() { return customerId; }
    public void setCustomerId(int customerId) { this.customerId = customerId; }

    public String getCustomerName() { return customerName; }
    public void setCustomerName(String customerName) { this.customerName = customerName; }

    public String getPhone() { return phone; }
    public void setPhone(String phone) { this.phone = phone; }

    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }

    public String getAddress() { return address; }
    public void setAddress(String address) { this.address = address; }

    public String getCity() { return city; }
    public void setCity(String city) { this.city = city; }

    public Date getDateOfBirth() { return dateOfBirth; }
    public void setDateOfBirth(Date dateOfBirth) { this.dateOfBirth = dateOfBirth; }

    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }

    public Timestamp getUpdatedAt() { return updatedAt; }
    public void setUpdatedAt(Timestamp updatedAt) { this.updatedAt = updatedAt; }

    @Override
    public String toString() {
        return "Customer{customerId=" + customerId + ", customerName='" + customerName + "'}";
    }
}