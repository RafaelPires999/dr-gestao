/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 */

package br.com.drgestao;

import javax.swing.JFrame;
import javax.swing.SwingUtilities;

/**
 *
 * @author rafa_
 */
public class DrGestao {

    public static void main(String[] args) {
        SwingUtilities.invokeLater(() -> {
            JFrame janela = new JFrame("DR Gestão");
            janela.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
            janela.setSize(1366, 768);
            janela.setLocationRelativeTo(null);
            janela.setVisible(true);
        });
    }
}
