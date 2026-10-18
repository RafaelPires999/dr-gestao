/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package br.com.drgestao.util;

import br.com.drgestao.model.Usuario;
import br.com.drgestao.service.RegraNegocioException;
import br.com.drgestao.service.UsuarioService;
import java.sql.SQLException;
import javax.swing.JOptionPane;
/**
 *
 * @author rafa_
 */
public class CriarUsuariosIniciais {
     public static void main(String[] args){
        cadastrar("PROPRIETARIO");
        cadastrar("OPERACIONAL");
        System.exit(0);
    }
    
    public static void cadastrar(String perfil){
        String nome = JOptionPane.showInputDialog("Nome do Usuario (" + perfil + "):");
        String login = JOptionPane.showInputDialog("Login:");
        String senha = JOptionPane.showInputDialog("Senha:");
        
        Usuario u = new Usuario();
        u.setNome(nome);
        u.setLogin(login);
        u.setPerfil(perfil);
        
        try {
            new UsuarioService().salvar(u, senha);
            JOptionPane.showMessageDialog(null, nome + " cadastrado com id " + u.getId());
        } catch (RegraNegocioException e) {
            JOptionPane.showMessageDialog(null, e.getMessage());
        } catch (SQLException e) {
            JOptionPane.showMessageDialog(null, "Erro no banco: " + e.getMessage());
        }
    }
}
