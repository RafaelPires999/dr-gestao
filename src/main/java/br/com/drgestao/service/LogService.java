/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package br.com.drgestao.service;

import br.com.drgestao.config.ConnectionFactory;
import br.com.drgestao.dao.LogOperacaoDAO;
import br.com.drgestao.model.LogOperacao;
import br.com.drgestao.util.Sessao;
import java.sql.Connection;
import java.sql.SQLException;
import java.time.LocalDateTime;
/**
 *
 * @author rafa_
 */
public class LogService {
    private LogOperacaoDAO dao = new LogOperacaoDAO();
    
    public void registrar(TipoOperacao tipo, String descricao){
        try(Connection con = ConnectionFactory.getConnection()){
            registrar(con, tipo, descricao);
        } catch(SQLException e){
            System.out.println("Falha ao gravar log: " + e.getMessage());
        }
    }
    
    public void registrar(Connection con, TipoOperacao tipo, String descricao) throws SQLException{
        LogOperacao log = new LogOperacao();
        log.setIdUsuario(Sessao.getIdUsuario());
        log.setDataHora(LocalDateTime.now());
        log.setOperacao(tipo.getTexto());
        log.setDescricao(descricao);
        dao.inserirLog(con, log);
    }
    
    public void resgistrarTentativaLogin(String loginDigitado){
        try(Connection con = ConnectionFactory.getConnection()){
            LogOperacao log = new LogOperacao();
            log.setIdUsuario(null);
            log.setDataHora(LocalDateTime.now());
            log.setOperacao(TipoOperacao.ACESSO.getTexto());
            log.setDescricao("Tentativa de login com senha inválida (Usuário: " + loginDigitado + ")");
            dao.inserirLog(con, log);
        } catch(SQLException e){
            System.out.println("Falha ao gravar log: " + e.getMessage());
        }
    }
}