/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package br.com.drgestao.config;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

/**
 *
 * @author rafa_
 */
public class TesteConexao {
    public static void main(String[] args) throws Exception{
        String sql = "SELECT COUNT(*) FROM forma_pagamento";
        try(Connection con = ConnectionFactory.getConnection();
        PreparedStatement ps = con.prepareStatement(sql);
        ResultSet rs = ps.executeQuery()){
            rs.next();
            System.out.println("Formas de pagamento: " + rs.getInt(1));
        }
    }
}
