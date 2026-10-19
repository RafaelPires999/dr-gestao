/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package br.com.drgestao.util;

import br.com.drgestao.model.Usuario;
/**
 *
 * @author rafa_
 */
public class Sessao {
    private static Usuario usuario;
    
    public static void iniciar(Usuario u){
        usuario = u;
    }
    
    public static Usuario getUsuario(){
        return usuario;
    }
    
    public static void encerrar(){
        usuario = null;
    }
    
    public static Integer getIdUsuario(){
        if(usuario == null){
            return null;
        }
        return usuario.getId();
    }
}
