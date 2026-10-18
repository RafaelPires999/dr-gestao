/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package br.com.drgestao.service;

import br.com.drgestao.dao.UsuarioDAO;
import br.com.drgestao.model.Usuario;
import br.com.drgestao.util.Senha;
import java.sql.SQLException;
import java.util.List;
/**
 *
 * @author rafa_
 */
public class UsuarioService {
    private final UsuarioDAO dao = new UsuarioDAO();
    
    public void salvar(Usuario u, String senhaPura) throws SQLException{
        if(u.getNome() == null || u.getNome().isBlank()){
            throw new RegraNegocioException("Informe o nome");
        }
        
        if(u.getLogin() == null || u.getLogin().isBlank()){
            throw new RegraNegocioException("Informe o login");
        }
        
        String login = u.getLogin().trim().toLowerCase();
        if(login.contains(" ")){
            throw new RegraNegocioException("O login não pode conter espaços");
        }
        u.setLogin(login);
        
        Usuario outro = dao.buscaLoginUsuario(login);
        if(u.getId() == null){
            if(outro != null){
                throw new RegraNegocioException("Usuário já existente");
            }
            
            if(senhaPura == null || senhaPura.length() < 6){
                throw new RegraNegocioException("Senha deve conter no mínimo 6 caracteres");
            }
            u.setSenhaHash(Senha.gerarHash(senhaPura));
            dao.inserirUsuario(u);
        } else{
            if (outro != null && !outro.getId().equals(u.getId())) {
                throw new RegraNegocioException("Login já está em uso.");
            }
            dao.atualizarUsuario(u);
        }
    }
    
    public List<Usuario> listar() throws SQLException{
        return dao.listarUsuario();
    }
}
