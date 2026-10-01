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
	endereco VARCHAR(200) NULL,
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