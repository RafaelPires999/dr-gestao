/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package br.com.drgestao.dao;

import br.com.drgestao.model.LogOperacao;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.sql.Types;
/**
 *
 * @author rafa_
 */
public class LogOperacaoDAO {
    public void inserirLog(Connection con, LogOperacao log) throws SQLException {
        String sql = "INSERT INTO log_operacao(id_usuario, data_hora, operacao, descricao) VALUES (?, ?, ?, ?)";
        try (PreparedStatement ps = con.prepareStatement(sql)){
            if(log.getIdUsuario() == null){
                ps.setNull(1, Types.INTEGER);
            } else {
                ps.setInt(1, log.getIdUsuario());
            }
            ps.setObject(2, log.getDataHora());
            ps.setString(3, log.getOperacao());
            ps.setString(4, log.getDescricao());
            ps.executeUpdate();
        }
    }
}
