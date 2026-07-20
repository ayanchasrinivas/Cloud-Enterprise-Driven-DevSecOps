package com.devsecops.lab.vulnerable_app.controller;

import org.springframework.web.bind.annotation.*;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.Statement;

@RestController
@RequestMapping("/sql")
public class SQLInjectionController {

    @GetMapping("/user")
    public String findUser(@RequestParam String username) throws Exception {

        Connection connection = DriverManager.getConnection(
                "jdbc:mysql://localhost:3306/devsecops",
                "root",
                "password"
        );

        Statement statement = connection.createStatement();

        String query =
                "SELECT * FROM users WHERE username = '" + username + "'";

        ResultSet resultSet = statement.executeQuery(query);

        return query;
    }
}