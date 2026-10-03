USE drgestao
GO

INSERT INTO configuracao (id_configuracao, razao_social, logradouro, numero, bairro, cidade, uf,
                          largura_bobina_mm, prazo_inadimplencia_dias, pasta_backup, horario_backup)
VALUES (1, 'DR Conveniência', 'Av. Jurema', '909', 'Centro', 'Iacri', 'SP', 58, 30, 'C:\DRGestao\Backup', '23:00');
GO

INSERT INTO forma_pagamento (descricao, codigo_sefaz) VALUES ('Dinheiro', 01),
                                                             ('Cartão de crédito', 03),
                                                             ('Cartão de débito', 04),
                                                             ('PIX', 17),
                                                             ('Fiado', 05);
GO