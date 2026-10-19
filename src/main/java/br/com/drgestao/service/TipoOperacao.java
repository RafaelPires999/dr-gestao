/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Enum.java to edit this template
 */
package br.com.drgestao.service;

/**
 *
 * @author rafa_
 */
public enum TipoOperacao {
    ACESSO("Acesso"),
    CADASTRO("Cadastro"),
    COMANDA("Comanda"),
    CANCELAMENTO("Cancelamento"),
    SANGRIA("Sangria"),
    SUPRIMENTO("Suprimento"),
    CONFIGURACAO("Configuração"),
    BACKUP("backup"),
    IMPLANTACAO("Implantação");
    
    private final String texto;
    
    TipoOperacao(String texto){
        this.texto = texto;
    }
    
    public String getTexto(){
        return texto;
    }
}
