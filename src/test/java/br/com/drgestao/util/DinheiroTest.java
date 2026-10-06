/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package br.com.drgestao.util;

import java.math.BigDecimal;
import org.junit.jupiter.api.Test;
import static org.junit.jupiter.api.Assertions.*;

/**
 *
 * @author rafa_
 */
public class DinheiroTest {
    @Test
    void arredondaMeioParaCima(){
        assertEquals(new BigDecimal("2.35"), Dinheiro.arredondar(new BigDecimal("2.345")));
    }
    
    @Test
    void leValorBrasileiro() {
        assertEquals(new BigDecimal("1234.56"), Dinheiro.ler("1.234,56"));
    }
    
    @Test
    void recusaTextoInvalido() {
        assertThrows(IllegalArgumentException.class, () -> Dinheiro.ler("abc"));
    }
        
    @Test
    void arredondaParaBaixo() {
        assertEquals(new BigDecimal("2.34"), Dinheiro.arredondar(new BigDecimal("2.344")));
    }

    @Test
    void leTextoVazioComoZero() {
        assertEquals(new BigDecimal("0.00"), Dinheiro.ler(""));
    }

    @Test
    void formataEmReais() {
        assertEquals("R$ 1.234,50", Dinheiro.formatar(new BigDecimal("1234.5")));
    }
}
