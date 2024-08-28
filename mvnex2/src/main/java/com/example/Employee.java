package com.example;
public class Employee extends Person {
    private String empID;
    public Employee(String name, int age, String empID) {
        super(name, age);
        this.empID = empID;
    }
    @Override
    public void display() {
        super.display();
        System.out.println("Employee ID : " + empID);
    }
}