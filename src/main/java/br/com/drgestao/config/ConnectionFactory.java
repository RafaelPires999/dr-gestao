/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package br.com.drgestao.config;

import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.Path;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.Properties;

/**
 *
 * @author rafa_
 */
public class ConnectionFactory {
    private static String url;
    private static String usuario;
    private static String senha;
    
    private static boolean carregado = false;
    
    private ConnectionFactory(){
    }
    
    private static void carregar(){
        if(carregado) return;
        Path dados = pastaDados().resolve("db.properties");
        Path local = Path.of(System.getProperty("user.dir"), "db.properties");
        Path arquivo = Files.exists(dados) ? dados : local;
        if(!Files.exists(arquivo)){
            throw new IllegalStateException("Arquivo db.properties não encontrado em " + dados + " nem em " + local);
        }
        Properties props = new Properties();
        try(InputStream in = Files.newInputStream(arquivo)){
            props.load(in);
        } catch(IOException e){
            throw new IllegalStateException("Não foi possível ler " + arquivo, e);
        }
        url = obrigatoria(props, "db.url");
        usuario = obrigatoria(props, "db.usuario");
        senha = obrigatoria(props, "db.senha");
        carregado = true;
    }
    
    private static String obrigatoria(Properties props, String chave) {
        String valor = props.getProperty(chave);
        if (valor == null || valor.isBlank()) {
            throw new IllegalStateException("Falta a linha " + chave + " no db.properties");
        }
        return valor.trim();
    }
    
    public static Path pastaDados() {
        Path pasta = Path.of(System.getenv("ProgramData"), "DRGestao");
        try {
            Files.createDirectories(pasta);
        } catch (IOException e) {
            throw new IllegalStateException("Não foi possível criar " + pasta, e);
        }
        return pasta;
    }
    
    public static Connection getConnection() throws SQLException {
        carregar();
        return DriverManager.getConnection(url, usuario, senha);
    }
}
