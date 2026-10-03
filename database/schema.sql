IF NOT EXISTS (SELECT * FROM sys.databases WHERE name = 'drgestao')
BEGIN
    CREATE DATABASE drgestao COLLATE Latin1_General_CI_AI;
END
GO
 
USE drgestao
GO
 
-- 1. usuario
CREATE TABLE usuario(
	id_usuario INT NOT NULL IDENTITY(1,1),
	nome VARCHAR(100) NOT NULL,
	login VARCHAR(30) NOT NULL,
	senha_hash VARCHAR(100) NOT NULL,
	perfil VARCHAR(20) NOT NULL DEFAULT 'OPERACIONAL',
	ativo BIT NOT NULL DEFAULT 1,
	data_cadastro DATETIME2(0) NOT NULL DEFAULT SYSDATETIME(),
	ultimo_acesso DATETIME2(0) NULL,
	CONSTRAINT PK_usuario PRIMARY KEY (id_usuario),
	CONSTRAINT UQ_usuario_login UNIQUE (login),
	CONSTRAINT CK_usuario_perfil CHECK (perfil IN ('PROPRIETARIO', 'OPERACIONAL'))
)
GO
 
-- 2. log_operacao
CREATE TABLE log_operacao(
	id_log INT NOT NULL IDENTITY(1,1),
	id_usuario INT NULL,
	data_hora DATETIME2(0) NOT NULL DEFAULT SYSDATETIME(),
	operacao VARCHAR(50) NOT NULL,
	descricao VARCHAR(500) NULL,
	CONSTRAINT PK_log_operacao PRIMARY KEY (id_log),
	CONSTRAINT FK_log_operacao_usuario FOREIGN KEY (id_usuario) REFERENCES usuario(id_usuario)
)
GO
 
CREATE INDEX IX_log_operacao_data_hora ON log_operacao(data_hora);
GO
 
-- 3. configuracao
CREATE TABLE configuracao(
	id_configuracao INT NOT NULL,
	razao_social VARCHAR(120) NULL,
	cnpj VARCHAR(18) NULL,
	inscricao_estadual VARCHAR(20) NULL,
	logradouro VARCHAR(120) NULL,
	numero VARCHAR(10) NULL,
	bairro VARCHAR(60) NULL,
	cidade VARCHAR(80) NULL,
	uf CHAR(2) NULL,
	cep VARCHAR(9) NULL,
	regime_tributario VARCHAR(30) NULL,
	emissao_fiscal_ativa BIT NOT NULL DEFAULT 0,
	certificado_caminho VARCHAR(260) NULL,
	certificado_senha VARCHAR(256) NULL,
	csc VARCHAR(256) NULL,
	ambiente_sefaz VARCHAR(12) NOT NULL DEFAULT 'HOMOLOGACAO',
	impressora_nome VARCHAR(120) NULL,
	largura_bobina_mm TINYINT NOT NULL DEFAULT 80,
	logotipo_caminho VARCHAR(260) NULL,
	pasta_backup VARCHAR(260) NULL,
	horario_backup TIME(0) NULL,
	backup_ao_fechar BIT NOT NULL DEFAULT 1,
	prazo_inadimplencia_dias INT NOT NULL DEFAULT 30,
	versao_banco INT NOT NULL DEFAULT 1,
	CONSTRAINT PK_configuracao PRIMARY KEY (id_configuracao),
	CONSTRAINT CK_configuracao_id CHECK (id_configuracao = 1),
	CONSTRAINT CK_configuracao_bobina CHECK (largura_bobina_mm IN (58, 80)),
	CONSTRAINT CK_configuracao_ambiente CHECK (ambiente_sefaz IN ('HOMOLOGACAO', 'PRODUCAO')),
	CONSTRAINT CK_configuracao_prazo CHECK (prazo_inadimplencia_dias > 0),
	CONSTRAINT CK_configuracao_versao CHECK (versao_banco >= 1)
)
GO
 
-- 4. backups
CREATE TABLE backups(
	id_backup INT NOT NULL IDENTITY(1,1),
	id_usuario INT NULL,
	data_hora DATETIME2(0) NOT NULL DEFAULT SYSDATETIME(),
	origem VARCHAR(10) NOT NULL,
	diretorio_destino VARCHAR(260) NOT NULL,
	nome_arquivo VARCHAR(120) NULL,
	tamanho_bytes BIGINT NULL,
	status VARCHAR(10) NOT NULL,
	mensagem_erro VARCHAR(300) NULL,
	CONSTRAINT PK_backups PRIMARY KEY (id_backup),
	CONSTRAINT FK_backups_usuario FOREIGN KEY (id_usuario) REFERENCES usuario(id_usuario),
	CONSTRAINT CK_backups_origem CHECK (origem IN ('AGENDADO', 'AO_FECHAR', 'MANUAL')),
	CONSTRAINT CK_backups_status CHECK (status IN ('INTEGRO', 'FALHOU'))
)
GO
 
-- 5. categoria
CREATE TABLE categoria(
	id_categoria INT NOT NULL IDENTITY(1,1),
	nome VARCHAR(60) NOT NULL,
	CONSTRAINT PK_categoria PRIMARY KEY (id_categoria),
	CONSTRAINT UQ_categoria_nome UNIQUE (nome)
)
GO
 
-- 6. produto
CREATE TABLE produto(
	id_produto INT NOT NULL IDENTITY(1,1),
	id_categoria INT NOT NULL,
	codigo_barras VARCHAR(20) NULL,
	nome VARCHAR(120) NOT NULL,
	unidade VARCHAR(6) NOT NULL DEFAULT 'UN',
	preco_custo DECIMAL(10,2) NOT NULL DEFAULT 0,
	preco_venda DECIMAL(10,2) NOT NULL,
	margem_lucro DECIMAL(6,2) NULL,
	quantidade_estoque INT NOT NULL DEFAULT 0,
	estoque_minimo INT NOT NULL DEFAULT 0,
	ncm VARCHAR(8) NULL,
	cfop VARCHAR(4) NULL,
	cst VARCHAR(3) NULL,
	csosn VARCHAR(4) NULL,
	origem CHAR(1) NULL,
	descricao_nota VARCHAR(120) NULL,
	ativo BIT NOT NULL DEFAULT 1,
	CONSTRAINT PK_produto PRIMARY KEY (id_produto),
	CONSTRAINT FK_produto_categoria FOREIGN KEY (id_categoria) REFERENCES categoria(id_categoria),
	CONSTRAINT CK_produto_preco_custo CHECK (preco_custo >= 0),
	CONSTRAINT CK_produto_preco_venda CHECK (preco_venda > 0),
	CONSTRAINT CK_produto_estoque_minimo CHECK (estoque_minimo >= 0)
)
GO
 
CREATE UNIQUE INDEX UX_produto_codigo_barras ON produto(codigo_barras)
	WHERE codigo_barras IS NOT NULL;
GO
 
CREATE INDEX IX_produto_nome ON produto(nome);
GO
 
-- 7. fornecedor
CREATE TABLE fornecedor(
	id_fornecedor INT NOT NULL IDENTITY(1,1),
	cnpj VARCHAR(18) NOT NULL,
	razao_social VARCHAR(120) NOT NULL,
	telefone VARCHAR(20) NULL,
	email VARCHAR(120) NULL,
	endereco VARCHAR(200) NULL,
	CONSTRAINT PK_fornecedor PRIMARY KEY (id_fornecedor),
	CONSTRAINT UQ_fornecedor_cnpj UNIQUE (cnpj)
)
GO
 
-- 8. entrada_mercadoria
CREATE TABLE entrada_mercadoria(
	id_entrada INT NOT NULL IDENTITY(1,1),
	id_fornecedor INT NOT NULL,
	id_usuario INT NOT NULL,
	data_entrada DATETIME2(0) NOT NULL DEFAULT SYSDATETIME(),
	valor_total DECIMAL(10,2) NOT NULL DEFAULT 0,
	observacao VARCHAR(300) NULL,
	CONSTRAINT PK_entrada_mercadoria PRIMARY KEY (id_entrada),
	CONSTRAINT FK_entrada_mercadoria_fornecedor FOREIGN KEY (id_fornecedor) REFERENCES fornecedor(id_fornecedor),
	CONSTRAINT FK_entrada_mercadoria_usuario FOREIGN KEY (id_usuario) REFERENCES usuario(id_usuario)
)
GO
 
-- 9. item_entrada
CREATE TABLE item_entrada(
	id_item_entrada INT NOT NULL IDENTITY(1,1),
	id_entrada INT NOT NULL,
	id_produto INT NOT NULL,
	quantidade INT NOT NULL,
	preco_custo_unitario DECIMAL(10,2) NOT NULL,
	CONSTRAINT PK_item_entrada PRIMARY KEY (id_item_entrada),
	CONSTRAINT FK_item_entrada_entrada FOREIGN KEY (id_entrada) REFERENCES entrada_mercadoria(id_entrada),
	CONSTRAINT FK_item_entrada_produto FOREIGN KEY (id_produto) REFERENCES produto(id_produto),
	CONSTRAINT CK_item_entrada_quantidade CHECK (quantidade > 0),
	CONSTRAINT CK_item_entrada_custo CHECK (preco_custo_unitario >= 0)
)
GO
 
-- 10. cliente
CREATE TABLE cliente(
	id_cliente INT NOT NULL IDENTITY(1,1),
	nome VARCHAR(120) NOT NULL,
	cpf VARCHAR(14) NOT NULL,
	telefone VARCHAR(20) NULL,
	endereco VARCHAR(200) NULL,
	cidade VARCHAR(80) NULL,
	estado CHAR(2) NULL,
	data_cadastro DATETIME2(0) NOT NULL DEFAULT SYSDATETIME(),
	ativo BIT NOT NULL DEFAULT 1,
	CONSTRAINT PK_cliente PRIMARY KEY (id_cliente),
	CONSTRAINT UQ_cliente_cpf UNIQUE (cpf)
)
GO
 
-- 11. conta_digital
CREATE TABLE conta_digital(
	id_conta INT NOT NULL IDENTITY(1,1),
	id_cliente INT NOT NULL,
	saldo_devedor DECIMAL(10,2) NOT NULL DEFAULT 0,
	limite_credito DECIMAL(10,2) NOT NULL DEFAULT 0,
	credito_ativo BIT NOT NULL DEFAULT 1,
	status_inadimplente BIT NOT NULL DEFAULT 0,
	data_ultima_movimentacao DATETIME2(0) NULL,
	CONSTRAINT PK_conta_digital PRIMARY KEY (id_conta),
	CONSTRAINT UQ_conta_digital_cliente UNIQUE (id_cliente),
	CONSTRAINT FK_conta_digital_cliente FOREIGN KEY (id_cliente) REFERENCES cliente(id_cliente),
	CONSTRAINT CK_conta_digital_saldo CHECK (saldo_devedor >= 0),
	CONSTRAINT CK_conta_digital_limite CHECK (limite_credito >= 0)
)
GO
 
-- 12. mesa
CREATE TABLE mesa(
	id_mesa INT NOT NULL IDENTITY(1,1),
	numero INT NOT NULL,
	status VARCHAR(10) NOT NULL DEFAULT 'LIVRE',
	ativa BIT NOT NULL DEFAULT 1,
	CONSTRAINT PK_mesa PRIMARY KEY (id_mesa),
	CONSTRAINT UQ_mesa_numero UNIQUE (numero),
	CONSTRAINT CK_mesa_status CHECK (status IN ('LIVRE', 'OCUPADA'))
)
GO
 
-- 13. comanda
CREATE TABLE comanda(
	id_comanda INT NOT NULL IDENTITY(1,1),
	id_mesa INT NOT NULL,
	id_usuario INT NOT NULL,
	data_hora_abertura DATETIME2(0) NOT NULL DEFAULT SYSDATETIME(),
	data_hora_fechamento DATETIME2(0) NULL,
	status VARCHAR(10) NOT NULL DEFAULT 'ABERTA',
	valor_total DECIMAL(10,2) NOT NULL DEFAULT 0,
	CONSTRAINT PK_comanda PRIMARY KEY (id_comanda),
	CONSTRAINT FK_comanda_mesa FOREIGN KEY (id_mesa) REFERENCES mesa(id_mesa),
	CONSTRAINT FK_comanda_usuario FOREIGN KEY (id_usuario) REFERENCES usuario(id_usuario),
	CONSTRAINT CK_comanda_status CHECK (status IN ('ABERTA', 'FECHADA'))
)
GO
 
-- 14. item_comanda
CREATE TABLE item_comanda(
	id_item_comanda INT NOT NULL IDENTITY(1,1),
	id_comanda INT NOT NULL,
	id_produto INT NOT NULL,
	id_usuario INT NOT NULL,
	quantidade INT NOT NULL,
	valor_unitario DECIMAL(10,2) NOT NULL,
	data_hora_lancamento DATETIME2(0) NOT NULL DEFAULT SYSDATETIME(),
	CONSTRAINT PK_item_comanda PRIMARY KEY (id_item_comanda),
	CONSTRAINT FK_item_comanda_comanda FOREIGN KEY (id_comanda) REFERENCES comanda(id_comanda),
	CONSTRAINT FK_item_comanda_produto FOREIGN KEY (id_produto) REFERENCES produto(id_produto),
	CONSTRAINT FK_item_comanda_usuario FOREIGN KEY (id_usuario) REFERENCES usuario(id_usuario),
	CONSTRAINT CK_item_comanda_quantidade CHECK (quantidade > 0)
)
GO
 
-- 15. forma_pagamento
CREATE TABLE forma_pagamento(
	id_forma_pagamento INT NOT NULL IDENTITY(1,1),
	descricao VARCHAR(30) NOT NULL,
	codigo_sefaz CHAR(2) NULL,
	CONSTRAINT PK_forma_pagamento PRIMARY KEY (id_forma_pagamento),
	CONSTRAINT UQ_forma_pagamento_descricao UNIQUE (descricao)
)
GO
 
-- 16. movimentacao_caixa
CREATE TABLE movimentacao_caixa(
	id_movimentacao_caixa INT NOT NULL IDENTITY(1,1),
	id_usuario INT NOT NULL,
	tipo VARCHAR(10) NOT NULL,
	valor DECIMAL(10,2) NOT NULL,
	data_hora DATETIME2(0) NOT NULL DEFAULT SYSDATETIME(),
	observacao VARCHAR(200) NULL,
	CONSTRAINT PK_movimentacao_caixa PRIMARY KEY (id_movimentacao_caixa),
	CONSTRAINT FK_movimentacao_caixa_usuario FOREIGN KEY (id_usuario) REFERENCES usuario(id_usuario),
	CONSTRAINT CK_movimentacao_caixa_tipo CHECK (tipo IN ('SANGRIA', 'SUPRIMENTO')),
	CONSTRAINT CK_movimentacao_caixa_valor CHECK (valor > 0)
)
GO
 
-- 17. venda
CREATE TABLE venda(
	id_venda INT NOT NULL IDENTITY(1,1),
	id_usuario INT NOT NULL,
	id_cliente INT NULL,
	id_comanda INT NULL,
	data_hora DATETIME2(0) NOT NULL DEFAULT SYSDATETIME(),
	tipo VARCHAR(10) NOT NULL,
	valor_total DECIMAL(10,2) NOT NULL,
	troco DECIMAL(10,2) NOT NULL DEFAULT 0,
	cpf_nota VARCHAR(14) NULL,
	status VARCHAR(12) NOT NULL DEFAULT 'FINALIZADA',
	data_hora_cancelamento DATETIME2(0) NULL,
	id_usuario_cancelamento INT NULL,
	motivo_cancelamento VARCHAR(200) NULL,
	CONSTRAINT PK_venda PRIMARY KEY (id_venda),
	CONSTRAINT FK_venda_usuario FOREIGN KEY (id_usuario) REFERENCES usuario(id_usuario),
	CONSTRAINT FK_venda_cliente FOREIGN KEY (id_cliente) REFERENCES cliente(id_cliente),
	CONSTRAINT FK_venda_comanda FOREIGN KEY (id_comanda) REFERENCES comanda(id_comanda),
	CONSTRAINT FK_venda_usuario_cancelamento FOREIGN KEY (id_usuario_cancelamento) REFERENCES usuario(id_usuario),
	CONSTRAINT CK_venda_tipo CHECK (tipo IN ('BALCAO', 'COMANDA')),
	CONSTRAINT CK_venda_status CHECK (status IN ('FINALIZADA', 'CANCELADA')),
	CONSTRAINT CK_venda_valor_total CHECK (valor_total >= 0)
)
GO
 
CREATE INDEX IX_venda_data_hora ON venda(data_hora);
GO
 
-- 18. item_venda
CREATE TABLE item_venda(
	id_item_venda INT NOT NULL IDENTITY(1,1),
	id_venda INT NOT NULL,
	id_produto INT NOT NULL,
	quantidade INT NOT NULL,
	valor_unitario DECIMAL(10,2) NOT NULL,
	custo_unitario DECIMAL(10,2) NOT NULL,
	valor_total DECIMAL(10,2) NOT NULL,
	CONSTRAINT PK_item_venda PRIMARY KEY (id_item_venda),
	CONSTRAINT FK_item_venda_venda FOREIGN KEY (id_venda) REFERENCES venda(id_venda),
	CONSTRAINT FK_item_venda_produto FOREIGN KEY (id_produto) REFERENCES produto(id_produto),
	CONSTRAINT CK_item_venda_quantidade CHECK (quantidade > 0)
)
GO
 
-- 19. pagamento_venda
CREATE TABLE pagamento_venda(
	id_pagamento INT NOT NULL IDENTITY(1,1),
	id_venda INT NOT NULL,
	id_forma_pagamento INT NOT NULL,
	valor DECIMAL(10,2) NOT NULL,
	CONSTRAINT PK_pagamento_venda PRIMARY KEY (id_pagamento),
	CONSTRAINT FK_pagamento_venda_venda FOREIGN KEY (id_venda) REFERENCES venda(id_venda),
	CONSTRAINT FK_pagamento_venda_forma FOREIGN KEY (id_forma_pagamento) REFERENCES forma_pagamento(id_forma_pagamento),
	CONSTRAINT CK_pagamento_venda_valor CHECK (valor > 0)
)
GO
 
-- 20. movimentacao_fiado
CREATE TABLE movimentacao_fiado(
	id_movimentacao_fiado INT NOT NULL IDENTITY(1,1),
	id_conta INT NOT NULL,
	id_usuario INT NOT NULL,
	id_venda INT NULL,
	id_forma_pagamento INT NULL,
	tipo VARCHAR(10) NOT NULL,
	valor DECIMAL(10,2) NOT NULL,
	valor_pendente DECIMAL(10,2) NULL,
	data_hora DATETIME2(0) NOT NULL DEFAULT SYSDATETIME(),
	observacao VARCHAR(200) NULL,
	CONSTRAINT PK_movimentacao_fiado PRIMARY KEY (id_movimentacao_fiado),
	CONSTRAINT FK_movimentacao_fiado_conta FOREIGN KEY (id_conta) REFERENCES conta_digital(id_conta),
	CONSTRAINT FK_movimentacao_fiado_usuario FOREIGN KEY (id_usuario) REFERENCES usuario(id_usuario),
	CONSTRAINT FK_movimentacao_fiado_venda FOREIGN KEY (id_venda) REFERENCES venda(id_venda),
	CONSTRAINT FK_movimentacao_fiado_forma FOREIGN KEY (id_forma_pagamento) REFERENCES forma_pagamento(id_forma_pagamento),
	CONSTRAINT CK_movimentacao_fiado_tipo CHECK (tipo IN ('DEBITO', 'PAGAMENTO', 'ESTORNO')),
	CONSTRAINT CK_movimentacao_fiado_valor CHECK (valor > 0),
	CONSTRAINT CK_movimentacao_fiado_pendente CHECK (valor_pendente >= 0)
)
GO
 
-- 21. movimentacao_estoque
CREATE TABLE movimentacao_estoque(
	id_movimentacao_estoque INT NOT NULL IDENTITY(1,1),
	id_produto INT NOT NULL,
	id_usuario INT NULL,
	tipo VARCHAR(12) NOT NULL,
	quantidade INT NOT NULL,
	data_hora DATETIME2(0) NOT NULL DEFAULT SYSDATETIME(),
	id_venda INT NULL,
	id_item_entrada INT NULL,
	observacao VARCHAR(200) NULL,
	CONSTRAINT PK_movimentacao_estoque PRIMARY KEY (id_movimentacao_estoque),
	CONSTRAINT FK_movimentacao_estoque_produto FOREIGN KEY (id_produto) REFERENCES produto(id_produto),
	CONSTRAINT FK_movimentacao_estoque_usuario FOREIGN KEY (id_usuario) REFERENCES usuario(id_usuario),
	CONSTRAINT FK_movimentacao_estoque_venda FOREIGN KEY (id_venda) REFERENCES venda(id_venda),
	CONSTRAINT FK_movimentacao_estoque_item_entrada FOREIGN KEY (id_item_entrada) REFERENCES item_entrada(id_item_entrada),
	CONSTRAINT CK_movimentacao_estoque_tipo CHECK (tipo IN ('ENTRADA', 'VENDA', 'COMANDA', 'AJUSTE', 'IMPLANTACAO', 'ESTORNO')),
	CONSTRAINT CK_movimentacao_estoque_quantidade CHECK (quantidade <> 0)
)
GO
 
-- 22. nfce
CREATE TABLE nfce(
	id_nfce INT NOT NULL IDENTITY(1,1),
	id_venda INT NOT NULL,
	numero INT NOT NULL,
	serie SMALLINT NOT NULL DEFAULT 1,
	chave_acesso CHAR(44) NULL,
	data_hora_emissao DATETIME2(0) NOT NULL DEFAULT SYSDATETIME(),
	data_hora_transmissao DATETIME2(0) NULL,
	status VARCHAR(12) NOT NULL DEFAULT 'PENDENTE',
	contingencia BIT NOT NULL DEFAULT 0,
	protocolo_autorizacao VARCHAR(20) NULL,
	motivo_rejeicao VARCHAR(300) NULL,
	valor_total_tributos DECIMAL(10,2) NOT NULL DEFAULT 0,
	cpf_cliente VARCHAR(14) NULL,
	arquivo_xml VARCHAR(260) NULL,
	data_hora_cancelamento DATETIME2(0) NULL,
	protocolo_cancelamento VARCHAR(20) NULL,
	justificativa_cancelamento VARCHAR(255) NULL,
	CONSTRAINT PK_nfce PRIMARY KEY (id_nfce),
	CONSTRAINT UQ_nfce_venda UNIQUE (id_venda),
	CONSTRAINT UQ_nfce_serie_numero UNIQUE (serie, numero),
	CONSTRAINT FK_nfce_venda FOREIGN KEY (id_venda) REFERENCES venda(id_venda),
	CONSTRAINT CK_nfce_status CHECK (status IN ('PENDENTE', 'AUTORIZADA', 'REJEITADA', 'CANCELADA'))
)
GO