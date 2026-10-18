/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package br.com.drgestao.util;

import org.mindrot.jbcrypt.BCrypt;

/**
 *
 * @author rafa_
 */
public class Senha {
    private Senha(){
    }
    
    public static String gerarHash(String senha){
        return BCrypt.hashpw(senha, BCrypt.gensalt());
    }
    
    public static boolean confere(String senhaDigitada, String hash){
        return BCrypt.checkpw(senhaDigitada, hash);
    }
}
