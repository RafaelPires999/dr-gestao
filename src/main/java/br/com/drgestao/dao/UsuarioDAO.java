/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package br.com.drgestao.dao;

import br.com.drgestao.config.ConnectionFactory;
import br.com.drgestao.model.Usuario;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

/**
 *
 * @author rafa_
 */

public class UsuarioDAO {
    
    // INSERIR USUÁRIO
    public void inserirUsuario(Usuario u) throws SQLException {
        String sql = "INSERT INTO usuario (nome, login, senha_hash, perfil, ativo) VALUES (?, ?, ?, ?, ?)";
        try (Connection con = ConnectionFactory.getConnection();
        PreparedStatement ps = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)){
            ps.setString(1, u.getNome());
            ps.setString(2, u.getLogin());
            ps.setString(3, u.getSenhaHash());
            ps.setString(4, u.getPerfil());
            ps.setBoolean(5, u.getAtivo());
            ps.executeUpdate();
            
            ResultSet rs = ps.getGeneratedKeys();
            if(rs.next()){
                u.setId(rs.getInt(1));
            }
        }
    }
    
    // ATUALIZAR USUÁRIO
    public void atualizarUsuario(Usuario u) throws SQLException{
        String sql = "UPDATE usuario SET nome = ?, login = ?, perfil = ?, ativo = ? WHERE id_usuario = ?";
        try(Connection con = ConnectionFactory.getConnection();
        PreparedStatement ps = con.prepareStatement(sql)){
            ps.setString(1, u.getNome());
            ps.setString(2, u.getLogin());
            ps.setString(3, u.getPerfil());
            ps.setBoolean(4, u.getAtivo());
            ps.setInt(5, u.getId());
            ps.executeUpdate();
        }
    }
    
    // ATUALIZAR SENHA DO USUÁRIO
    public void atualizarSenhaUsuario(int id, String hash) throws SQLException{
        String sql = "UPDATE usuario SET senha_hash = ? WHERE id_usuario = ?";
        try(Connection con = ConnectionFactory.getConnection();
        PreparedStatement ps = con.prepareStatement(sql)){
            ps.setString(1, hash);
            ps.setInt(2, id);
            ps.executeUpdate();
        }
    }
    
    // REGISTRAR ULTIMO ACESSO DO USUÁRIO
    public void registrarAcessoUsuario(int id) throws SQLException{
        String sql = "UPDATE usuario SET ultimo_acesso = SYSDATETIME() WHERE id_usuario = ?";
        try(Connection con = ConnectionFactory.getConnection();
        PreparedStatement ps = con.prepareStatement(sql)){
            ps.setInt(1, id);
            ps.executeUpdate();
        }
    }
    
    // BUSCA POR LOGIN
    public Usuario buscaLoginUsuario(String login) throws SQLException{
        String sql = "SELECT id_usuario, nome, login, senha_hash, perfil, ativo, data_cadastro, ultimo_acesso "
                + "FROM usuario WHERE login = ?";
        try(Connection con = ConnectionFactory.getConnection();
        PreparedStatement ps = con.prepareStatement(sql)){
            ps.setString(1, login);
            
            ResultSet rs = ps.executeQuery();
            if(rs.next()){
                return montar(rs);
            }
            return null;
        }
    }
    
    // BUSCA POR ID
    public Usuario buscaPorIdUsuario(int id) throws SQLException{
        String sql = "SELECT id_usuario, nome, login, senha_hash, perfil, ativo, data_cadastro, ultimo_acesso "
                + "FROM usuario WHERE id_usuario = ?";
        try(Connection con = ConnectionFactory.getConnection();
        PreparedStatement ps = con.prepareStatement(sql)){
            ps.setInt(1, id);
            
            ResultSet rs = ps.executeQuery();
            if(rs.next()){
                return montar(rs);
            }
            return null;
        }
    }
    
    // LISTAR TODOS USUÁRIOS
    public List<Usuario> listarUsuario() throws SQLException{
        String sql = "SELECT id_usuario, nome, login, senha_hash, perfil, ativo, data_cadastro, ultimo_acesso "
                + "FROM usuario ORDER BY nome";
        List<Usuario> lista = new ArrayList<>();
        try(Connection con = ConnectionFactory.getConnection();
        PreparedStatement ps = con.prepareStatement(sql)){
            ResultSet rs = ps.executeQuery();
            while(rs.next()){
                lista.add(montar(rs));
            }
        }
        return lista;
    }
    
    // TRANSFORMAR UMA LISTA DO BANCO DE DADOS EM OBJETO
    private Usuario montar(ResultSet rs) throws SQLException{
        Usuario u = new Usuario();
        u.setId(rs.getInt("id_usuario"));
        u.setNome(rs.getString("nome"));
        u.setLogin(rs.getString("login"));
        u.setSenhaHash(rs.getString("senha_hash"));
        u.setPerfil(rs.getString("perfil"));
        u.setAtivo(rs.getBoolean("ativo"));
        u.setDataCadastro(rs.getObject("data_cadastro", LocalDateTime.class));
        u.setUltimoAcesso(rs.getObject("ultimo_acesso", LocalDateTime.class));
        return u;
    }
}
