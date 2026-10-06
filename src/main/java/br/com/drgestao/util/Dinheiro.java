/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package br.com.drgestao.util;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.text.NumberFormat;
import java.util.Locale;

/**
 *
 * @author rafa_
 */
public class Dinheiro {
    public static final BigDecimal ZERO = BigDecimal.ZERO.setScale(2);
    private static NumberFormat REAL = NumberFormat.getCurrencyInstance(Locale.of("pt", "BR"));
    
    private Dinheiro(){
    }
    
    public static BigDecimal arredondar(BigDecimal valor){
        if(valor == null){
            return ZERO;
        }
        return valor.setScale(2, RoundingMode.HALF_UP);
    }
    
    public static String formatar(BigDecimal valor){
        return REAL.format(arredondar(valor)).replace('\u00A0', ' ');
    }
    
    public static BigDecimal ler(String texto){
        if(texto == null || texto.isBlank()){
            return ZERO;
        }
        String limpo = texto.replace("R$", "").replace("\u00A0", "").replace(" ", "").replace(".", "").replace(",", ".");
        try{
            return arredondar(new BigDecimal(limpo));
        } catch(NumberFormatException e){
            throw new IllegalArgumentException("Valor inválido: " + texto);
        }
    }
    
    public static boolean positivo(BigDecimal v){
        return v != null && v.compareTo(BigDecimal.ZERO) > 0;
    }
    
    public static boolean maiorQue(BigDecimal a, BigDecimal b){
        return a.compareTo(b) > 0;
    }
}
