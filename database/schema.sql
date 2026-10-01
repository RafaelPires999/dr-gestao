CREATE DATABASE drgestao
GO

USE drgestao
GO

CREATE TABLE usuario(
	id_usuario INT not null IDENTITY(1,1) PRIMARY KEY,
	nome VARCHAR(100) NOT NULL,
	login VARCHAR(30) NOT NULL UNIQUE,
	senha_hash VARCHAR(100) NOT NULL,
	perfil VARCHAR(20) NOT NULL DEFAULT 'OPERACIONAL',
	ativo BIT NOT NULL DEFAULT 1,
	data_cadastro DATETIME2(0) NOT NULL DEFAULT SYSDATETIME(),
	ultimo_acesso DATETIME2(0) NULL,
	CONSTRAINT CK_usuario_perfil CHECK (perfil in ('PROPRIETARIO', 'OPERACIONAL'))
)
GO

CREATE TABLE log_operacao(
	id_log INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
	id_usuario INT NULL FOREIGN KEY REFERENCES usuario(id_usuario),
	data_hora DATETIME2(0) NOT NULL DEFAULT SYSDATETIME(),
	operacao VARCHAR(50) NOT NULL,
	descricao VARCHAR(500) NULL
)
GO

CREATE INDEX IX_log_operacao_data_hora ON log_operacao(data_hora);
GO

CREATE TABLE configuracao(
	id_configuracao INT NOT NULL PRIMARY KEY,
	razao_social VARCHAR(120) NULL,
	cnpj VARCHAR(18) NULL,
	inscricao_estadual VARCHAR(20) NULL,
	logradouro VARCHAR(120) NULL,
	numero VARCHAR(10) NULL,
	bairro VARCHAR(60) NULL,
	cidade VARCHAR(80) NULL,
	uf CHAR(2) NULL,
	cep VARCHAR(9) null,
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
	CONSTRAINT CK_configuracao_id CHECK (id_configuracao = 1),
	CONSTRAINT CK_configuracao_bobina CHECK (largura_bobina_mm in (58, 80)),
	CONSTRAINT CK_configuracao_ambiente CHECK (ambiente_sefaz in ('HOMOLOGACAO', 'PRODUCAO')),
	CONSTRAINT CK_configuracao_prazo CHECK (prazo_inadimplencia_dias > 0),
	CONSTRAINT CK_configuracao_versao CHECK (versao_banco >= 1)
)
GO

CREATE TABLE backups(
	id_backup INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
	id_usuario INT NULL FOREIGN KEY REFERENCES usuario(id_usuario),
	data_hora DATETIME2(0) NULL DEFAULT SYSDATETIME(),
	origem VARCHAR(10) NOT NULL,
	diretorio_destino VARCHAR(260) NOT NULL,
	nome_arquivo VARCHAR(120) NULL,
	tamanho_bytes BIGINT NULL,
	status VARCHAR(10) NOT NULL,
	mensagem_erro VARCHAR(300) NULL,
	CONSTRAINT CK_backup_origem CHECK (origem in ('AGENDADO', 'AO_FECHAR', 'MANUAL')),
	CONSTRAINT CK_bachup_stauts CHECK (status in ('INTEGRO', 'FALHOU'))
)
GO

CREATE TABLE categoria(
	id_categoria INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
	nome VARCHAR(60) NOT NULL UNIQUE
)
GO

CREATE TABLE produto(
	id_produto INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
	id_categoria INT NOT NULL FOREIGN KEY REFERENCES categoria (id_categoria),
	codigo_barras VARCHAR(20) NULL UNIQUE,
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
	CONSTRAINT CK_produto_preco_custo CHECK (preco_custo >= 0),
	CONSTRAINT CK_produto_preco_venda CHECK (preco_venda > 0),
	CONSTRAINT CK_produto_estoque_minimo CHECK (estoque_minimo >= 0),
)
GO

CREATE UNIQUE INDEX UX_produto_codigo_barras
	ON produto(codigo_barras)
	WHERE codigo_barras IS NOT NULL;
GO

CREATE INDEX IX_produto_nome ON produto(nome);
GO

CREATE TABLE fornecedor(
	id_fornecedor INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
	cnpj VARCHAR(18) NOT NULL UNIQUE,
	razao_social VARCHAR(120) NOT NULL,
	telefone VARCHAR(20) NULL,
	email VARCHAR(120) NULL,
	endereco VARCHAR(200) NULL
)
GO

CREATE TABLE entrada_mercadoria(
	id_entrada INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
	id_fornecedor INT NOT NULL FOREIGN KEY REFERENCES fornecedor(id_fornecedor),
	id_usuario INT NOT NULL FOREIGN KEY REFERENCES usuario(id_usuario),
	data_entrada DATETIME2(0) NOT NULL DEFAULT SYSDATETIME(),
	valor_total DECIMAL(10,2) NOT NULL DEFAULT 0,
	observacao VARCHAR(300) NULL
)
GO

CREATE TABLE item_entrada(
	id_item_entrada INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
	id_entrada INT NOT NULL FOREIGN KEY REFERENCES entrada_mercadoria(id_entrada),
	id_produto INT NOT NULL FOREIGN KEY REFERENCES produto(id_produto),
	quantidade INT NOT NULL,
	preco_custo_unitario DECIMAL(10,2) NOT NULL,
	CONSTRAINT CK_item_entrada_quantidade CHECK (quantidade > 0),
	CONSTRAINT CK_item_entrada_custo CHECK (preco_custo_unitario >= 0)
)
GO

CREATE TABLE cliente(
	id_cliente INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
	nome VARCHAR(120) NOT NULL,
	cpf VARCHAR(14) NOT NULL UNIQUE,
	telefone VARCHAR(20) NULL,
	endereco VARCHAR(200) NULL,
	cidade VARCHAR(80) NULL,
	estado CHAR(2) NULL,
	data_cadastro DATETIME2(0) NOT NULL DEFAULT SYSDATETIME(),
	ativo BIT NOT NULL DEFAULT 1,
)
GO

CREATE TABLE conta_digital(
	id_conta INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
	id_cliente INT NOT NULL FOREIGN KEY REFERENCES cliente(id_cliente) UNIQUE,
	saldo_devedor DECIMAL(10,2) NOT NULL DEFAULT 0,
	limite_credito DECIMAL(10,2) NOT NULL DEFAULT 0,
	credito_ativo BIT NOT NULL DEFAULT 1,
	status_inadimplente BIT NOT NULL DEFAULT 0,
	data_ultima_movimentacao DATETIME2(0) NULL,
	CONSTRAINT CK_conta_digital_saldo CHECK (saldo_devedor >= 0),
	CONSTRAINT CK_conta_digital_limite CHECK (limite_credito >= 0)
)
GO

CREATE TABLE mesa(
	id_mesa INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
	numero INT NOT NULL UNIQUE,
	status VARCHAR(10) NOT NULL DEFAULT 'LIVRE',
	ativa BIT NOT NULL DEFAULT 1,
	CONSTRAINT CK_mesa_status CHECK (status in ('LIVRE', 'OCUPADO'))
)
GO

CREATE TABLE comanda(
	id_comanda INT NOT NULL IDENTITY(1,1) PRIMARY KEY,
	id_mesa INT NOT NULL FOREIGN KEY REFERENCES mesa(id_mesa),
	id_usuario INT NOT NULL FOREIGN KEY REFERENCES usuario(id_usuario),
	data_hora_abertura DATETIME2(0) NOT NULL DEFAULT SYSDATETIME(),
	data_hora_fechamento DATETIME2(0) NULL,
	status VARCHAR(10) NOT NULL DEFAULT 'ABERTA',
	valor_total DECIMAL(10,2) NOT NULL DEFAULT 0,
	CONSTRAINT CK_comanda_status CHECK (status in ('ABERTA', 'FECHADA'))
)
GO