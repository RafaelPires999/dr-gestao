# DR Gestão

Sistema desktop de gestão para a **DR Conveniência** (Iacri – SP), desenvolvido como projeto acadêmico do curso de Análise e Desenvolvimento de Sistemas da FAI – Centro Universitário de Adamantina.

> 🚧 Projeto em desenvolvimento. Acompanhe pelo [quadro Kanban](https://github.com/users/RafaelPires999/projects/4) e pelas [issues](https://github.com/RafaelPires999/dr-gestao/issues).

## Objetivo

Substituir os controles feitos em papel na conveniência — cadernos de fiado, comandas de mesa e anotações de estoque — por um sistema único, instalado no computador do caixa e usado pelos operadores Danilo e Rodrigo. O sistema funciona para **controle de vendas**, emitindo comprovante não fiscal, e está preparado para receber a emissão de NFC-e como módulo opcional.

## Módulos do sistema

| Módulo | O que faz |
|---|---|
| **Acesso e segurança** | Login com senha criptografada, log de operações e tela de configuração |
| **Cadastros** | Produtos (com código de barras e cálculo automático da margem de lucro), categorias, fornecedores (CNPJ validado) e clientes (CPF validado) |
| **Estoque** | Entrada de mercadorias por fornecedor, baixa automática nas vendas e comandas, alerta de estoque mínimo |
| **Fiado** | Conta digital por cliente, limite de crédito, extrato, pagamentos e alerta de inadimplência (30 dias), com bloqueio de novas vendas a prazo |
| **PDV (venda direta)** | Venda rápida com leitor de código de barras, pagamento em dinheiro, cartão, PIX e fiado (inclusive combinados), troco e comprovante não fiscal, cancelamento com estorno |
| **Caixa** | Sangria, suprimento e fechamento diário por operador |
| **Comandas de mesa** | Tela visual das mesas (livre/ocupada), abertura, lançamento de itens, fechamento com pagamento ou transferência para o fiado |
| **Relatórios** | Vendas (diárias, semanais e mensais), produtos mais vendidos, clientes devedores, margem de lucro, estoque e reposição, fechamento de caixa e ocupação de comandas |
| **Backup** | Backup automático agendado do banco de dados, com verificação e restauração |
| **Fiscal (opcional)** | Emissão de NFC-e com transmissão à SEFAZ-SP, DANFE na impressora térmica, CPF na nota, contingência offline e cancelamento |

### Regras de negócio principais

- **Margem de lucro:** `(preço de venda − custo) ÷ preço de venda × 100`
- **Fiado:** a venda a prazo é bloqueada quando o saldo mais o novo débito ultrapassa o limite de crédito ou quando o cliente tem alerta de inadimplência
- **Inadimplência:** o alerta liga quando há débito sem pagamento há mais de 30 dias (prazo configurável) e desliga quando esse débito é quitado
- **Estoque das comandas:** a baixa acontece no fechamento da comanda
- **Valores em dinheiro:** `BigDecimal` no Java e `DECIMAL(10,2)` no banco

## Tecnologias (stack)

| Item | Tecnologia |
|---|---|
| Linguagem | Java 21 |
| Interface | Swing |
| Build e dependências | Maven |
| IDE | Apache NetBeans |
| Banco de dados | Microsoft SQL Server (JDBC) |
| Testes | JUnit |
| Periféricos | Leitor de código de barras e impressora térmica 80 mm |
| Sistema operacional | Windows |

### Estrutura do código

```
src/main/java/br/com/drgestao/
├── DrGestao.java   # classe principal
├── model/          # entidades (Produto, Cliente, Venda, Comanda...)
├── dao/            # acesso ao banco de dados
├── service/        # regras de negócio (estoque, fiado, margem...)
├── view/           # telas Swing
├── util/           # validação de CPF/CNPJ, formatação...
└── config/         # configuração e conexão com o banco
```

## Como rodar

### Pré-requisitos

- [JDK 21](https://adoptium.net/)
- [Apache NetBeans](https://netbeans.apache.org/) 20 ou mais recente
- Microsoft SQL Server (a edição Express é suficiente)

### Passos

1. Clone o repositório:
   ```
   git clone https://github.com/RafaelPires999/dr-gestao.git
   ```
2. No SQL Server, crie o banco executando o script da pasta `database/`.
3. Copie o arquivo `db.properties.example` para `db.properties` e preencha a URL, o usuário e a senha do banco. Esse arquivo não é enviado ao GitHub.
4. No NetBeans, abra a pasta do projeto em **File → Open Project**.
5. Execute com **F6** (Run).

Na versão final, o sistema será distribuído como instalador para Windows, sem precisar do NetBeans.

## Padrão de commits

Formato: **`tipo: descrição curta (closes #N)`**, em português e no imperativo.

| Tipo | Uso | Exemplo |
|---|---|---|
| `feat` | nova funcionalidade | `feat: cria tela de login (closes #7)` |
| `fix` | correção de erro | `fix: corrige cálculo do troco (closes #25)` |
| `docs` | documentação | `docs: completa o README (closes #2)` |
| `refactor` | melhoria de código sem mudar o comportamento | `refactor: separa validação de CPF` |
| `test` | testes | `test: testa o limite do fiado` |
| `chore` | configuração e manutenção | `chore: atualiza o .gitignore` |

O `closes #N` fecha a issue automaticamente quando o commit chega ao GitHub.

## Autor

**Rafael Aguiar Pires** — Análise e Desenvolvimento de Sistemas, FAI, 2026
[github.com/RafaelPires999](https://github.com/RafaelPires999)
