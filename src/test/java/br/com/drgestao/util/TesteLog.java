/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package br.com.drgestao.util;

import br.com.drgestao.dao.UsuarioDAO;
import br.com.drgestao.model.Usuario;
import br.com.drgestao.service.LogService;
import br.com.drgestao.service.TipoOperacao;

/**
 *
 * @author rafa_
 */
public class TesteLog {
    public static void main(String[] args) throws Exception{
        Usuario danilo = new UsuarioDAO().buscaLoginUsuario("danilo");
        Sessao.iniciar(danilo);
        
        LogService log = new LogService();
        log.registrar(TipoOperacao.CADASTRO, "teste de log");
        log.resgistrarTentativaLogin("fulano");
        
        System.out.println("Pronto. Confira a tabela log_operacao no SSMS");
    }
}
