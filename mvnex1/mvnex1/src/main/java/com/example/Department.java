package com.example;
public class Department {
    private String dept;
    private Employee manager;
    public Department(String dept, Employee manager) {
        this.dept = dept;
        this.manager = manager;
    }
    public void displayDepartmentInfo() {
        System.out.println("Department : " + dept);
        System.out.println("Manager : ");
        manager.display();
    }
}