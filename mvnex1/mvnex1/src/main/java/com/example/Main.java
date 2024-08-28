package com.example;
public class Main {
    public static void main(String[] args) {
        Employee manager = new Employee("Alice", 35, "E123");
        Department dept = new Department("Engineering", manager);
        dept.displayDepartmentInfo();
    }
}