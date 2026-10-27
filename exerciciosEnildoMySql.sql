-- ex 1 --

CREATE DATABASE dbVeterinaria;
CREATE DATABASE dbOficina;
CREATE DATABASE dbEscolaIdiomas;
CREATE DATABASE dbMateriais;

-- ex 2 --

CREATE DATABASE dbAcademia;
SHOW DATABASES;
USE dbAcademia;

-- ex 3 --

USE dbOficina;

CREATE TABLE tbVeiculo (
    id_veiculo     INT AUTO_INCREMENT PRIMARY KEY,
    placa          VARCHAR(10) NOT NULL UNIQUE,
    modelo         VARCHAR(100) NOT NULL,
    ano            YEAR,
    valor_estimado FLOAT(12, 2),
    ativo          BOOLEAN DEFAULT TRUE
);

DESCRIBE tbVeiculo;

-- ex 4 --

USE dbOficina;

DESCRIBE tbVeiculo;

-- ex 5 --

USE dbOficina;

ALTER TABLE tbVeiculo ADD marca VARCHAR(50) NOT NULL;
ALTER TABLE tbVeiculo ADD cor VARCHAR(30);
ALTER TABLE tbVeiculo MODIFY modelo VARCHAR(150);
ALTER TABLE tbVeiculo RENAME COLUMN valor_estimado TO valor_mercado;

DESCRIBE tbVeiculo;

-- ex 6 --

DROP DATABASE IF EXISTS dbVeterinaria;

SHOW DATABASES;

-- ex 7 --

CREATE DATABASE dbOficinaHomologacao;
CREATE DATABASE dbEscolaHomologacao;

SHOW DATABASES;

USE dbOficinaHomologacao;
USE dbEscolaHomologacao;

DROP DATABASE IF EXISTS dbOficinaHomologacao;
DROP DATABASE IF EXISTS dbEscolaHomologacao;

-- ex 8 --

SHOW DATABASES;

USE dbOficina;

SHOW TABLES;

DESCRIBE tbVeiculo;

USE dbEscolaIdiomas;

USE dbOficina;

-- ex 9 --

USE dbEscolaIdiomas;

CREATE TABLE tbCurso (
    id_curso      INT AUTO_INCREMENT PRIMARY KEY,
    nome          VARCHAR(100) NOT NULL UNIQUE,
    carga_horaria INT NOT NULL,
    valor         DECIMAL(10, 2) CHECK (valor >= 0),
    ativo         BOOL DEFAULT TRUE
);

CREATE TABLE tbProfessor (
    id_professor  INT AUTO_INCREMENT PRIMARY KEY,
    nome          VARCHAR(120) NOT NULL,
    email         VARCHAR(150) NOT NULL UNIQUE,
    data_admissao DATE NOT NULL,
    ativo         BOOL DEFAULT TRUE
);

SHOW TABLES;

DESCRIBE tbCurso;
DESCRIBE tbProfessor;

-- ex 10 --

USE dbEscolaIdiomas;

CREATE TABLE tbTurma (
    id_turma    INT AUTO_INCREMENT PRIMARY KEY,
    nome        VARCHAR(50) NOT NULL,
    data_inicio DATE NOT NULL,
    horario     TIME,
    id_curso    INT NOT NULL,
    FOREIGN KEY (id_curso) REFERENCES tbCurso (id_curso)
);

DESCRIBE tbTurma;

-- ex 11 --

USE dbEscolaIdiomas;

ALTER TABLE tbTurma
    ADD id_professor INT NOT NULL,
    ADD CONSTRAINT FkTurmaProfessor
        FOREIGN KEY (id_professor) REFERENCES tbProfessor (id_professor);

DESCRIBE tbTurma;

-- ex 12 --

USE dbEscolaIdiomas;

CREATE TABLE tbAluno (
    id_aluno        INT AUTO_INCREMENT PRIMARY KEY,
    nome            VARCHAR(150) NOT NULL,
    cpf             CHAR(11) NOT NULL UNIQUE,
    data_nascimento DATE,
    email           VARCHAR(150) UNIQUE,
    data_cadastro   DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    ativo           BOOL NOT NULL DEFAULT TRUE
);

DESCRIBE tbAluno;

-- ex 13 --

USE dbEscolaIdiomas;

CREATE TABLE tbMatricula (
    id_aluno       INT NOT NULL,
    id_turma       INT NOT NULL,
    data_matricula DATE NOT NULL,
    situacao       VARCHAR(20) NOT NULL,
    PRIMARY KEY (id_aluno, id_turma),  -- chave composta: impede matrícula duplicada na mesma turma
    FOREIGN KEY (id_aluno) REFERENCES tbAluno (id_aluno),
    FOREIGN KEY (id_turma) REFERENCES tbTurma (id_turma)
);

DESCRIBE tbMatricula;

-- ex 14 --

/*
 * Por que NÃO criamos curso1, curso2, curso3 dentro de ALUNO
 * ------------------------------------------------------------
 * A estrutura rejeitada (id_aluno, nome, curso1, curso2, curso3) tinha
 * um problema estrutural: o número de cursos que um aluno pode fazer
 * ficaria limitado ao número de colunas criadas. Se um aluno se
 * matriculasse em um quarto curso, não haveria onde guardar essa
 * informação sem alterar a tabela (ALTER TABLE) — e se um aluno
 * fizesse só um curso, as colunas curso2 e curso3 ficariam vazias
 * (espaço desperdiçado e sujeito a inconsistência).
 *
 * Esse é exatamente o problema que a NORMALIZAÇÃO resolve: em vez de
 * repetir a informação "curso" em várias colunas da MESMA linha,
 * criamos uma tabela separada (MATRICULA) onde cada curso do aluno
 * vira uma LINHA nova, não uma COLUNA nova.
 *
 * Com ALUNO, CURSO, TURMA e MATRICULA:
 *   - Um aluno pode se matricular em 1, 5 ou 50 turmas sem qualquer
 *     alteração na estrutura das tabelas — basta inserir mais linhas
 *     em MATRICULA.
 *   - Não existe coluna vazia: se o aluno tem 2 matrículas, existem
 *     exatamente 2 linhas para ele em MATRICULA (nenhuma sobra).
 *   - Cada matrícula carrega seus próprios dados (data_matricula,
 *     situacao) sem precisar duplicá-los feio em "curso1_data",
 *     "curso2_data" etc.
 *   - Buscar "todos os alunos de um curso" ou "todos os cursos de um
 *     aluno" vira uma consulta simples com JOIN, em vez de verificar
 *     manualmente curso1, curso2 e curso3 um por um.
 *
 * Resumindo: colunas fixas (curso1, curso2, curso3) representam uma
 * quantidade VARIÁVEL de informação como se fosse FIXA. A tabela
 * associativa representa essa mesma informação variável como LINHAS,
 * que podem crescer ou diminuir livremente — é essa flexibilidade que
 * a normalização entrega.
 */
 
USE dbEscolaIdiomas; 
DESCRIBE tbAluno;
DESCRIBE tbMatricula;

-- ex 15 --


/*
 * Regras do projeto que NÃO foram representadas no banco físico:
 *   - id_cliente: não é chave primária nem é gerado automaticamente
 *     (aceita repetição e valor nulo, então não identifica o cliente);
 *   - nome: obrigatório no projeto, mas a coluna aceita NULL;
 *   - cpf: obrigatório e único no projeto, mas aceita NULL e repetição;
 *   - ativo: "inicialmente ativo" exige DEFAULT TRUE (e NOT NULL),
 *     mas a coluna não tem valor padrão.
 * Os tamanhos (VARCHAR(100) e CHAR(11)) estão corretos.
 */

DROP DATABASE IF EXISTS dbTreinamento;  -- permite executar o exercício novamente do zero
CREATE DATABASE dbTreinamento;
USE dbTreinamento;

-- estrutura como o desenvolvedor implementou
CREATE TABLE cliente (
    id_cliente INT,
    nome       VARCHAR(100),
    cpf        CHAR(11),
    ativo      BOOLEAN
);

DESCRIBE cliente;

-- correções alterando a estrutura existente
ALTER TABLE cliente MODIFY id_cliente INT AUTO_INCREMENT PRIMARY KEY;
ALTER TABLE cliente MODIFY nome VARCHAR(100) NOT NULL;
ALTER TABLE cliente MODIFY cpf CHAR(11) NOT NULL;
ALTER TABLE cliente ADD CONSTRAINT UqClienteCpf UNIQUE (cpf);
ALTER TABLE cliente MODIFY ativo BOOLEAN NOT NULL DEFAULT TRUE;

DESCRIBE cliente;

-- ex 16 --

DROP DATABASE IF EXISTS dbLocadoraTeste;  -- permite executar os exercícios 16 a 19 novamente do zero
CREATE DATABASE dbLocadoraTeste;
USE dbLocadoraTeste;

CREATE TABLE cliente (
    id_cliente INT AUTO_INCREMENT PRIMARY KEY,
    nome       VARCHAR(150) NOT NULL,
    documento  VARCHAR(14) NOT NULL UNIQUE,  -- comporta CPF (11) ou CNPJ (14)
    telefone   VARCHAR(20),
    ativo      BOOL NOT NULL DEFAULT TRUE
);

CREATE TABLE categoria (
    id_categoria INT AUTO_INCREMENT PRIMARY KEY,
    nome         VARCHAR(80) NOT NULL UNIQUE
);

CREATE TABLE equipamento (
    id_equipamento INT AUTO_INCREMENT PRIMARY KEY,
    nome           VARCHAR(120) NOT NULL,
    id_categoria   INT NOT NULL,
    valor_diario   DECIMAL(10, 2) NOT NULL,
    situacao       VARCHAR(20) NOT NULL DEFAULT 'DISPONIVEL',
    CONSTRAINT ChkEquipamentoValor CHECK (valor_diario >= 0),
    CONSTRAINT FkEquipamentoCategoria
        FOREIGN KEY (id_categoria) REFERENCES categoria (id_categoria)
);

CREATE TABLE locacao (
    id_locacao              INT AUTO_INCREMENT PRIMARY KEY,
    id_cliente              INT NOT NULL,
    data_retirada           DATETIME NOT NULL,
    data_prevista_devolucao DATE NOT NULL,
    situacao                VARCHAR(20) NOT NULL,
    CONSTRAINT FkLocacaoCliente
        FOREIGN KEY (id_cliente) REFERENCES cliente (id_cliente)
);

CREATE TABLE item_locacao (
    id_locacao             INT NOT NULL,
    id_equipamento         INT NOT NULL,
    valor_diario_utilizado DECIMAL(10, 2) NOT NULL,
    PRIMARY KEY (id_locacao, id_equipamento),  -- chave composta: o mesmo equipamento não aparece duas vezes na mesma locação
    CONSTRAINT ChkItemLocacaoValor CHECK (valor_diario_utilizado >= 0),
    CONSTRAINT FkItemLocacaoLocacao
        FOREIGN KEY (id_locacao) REFERENCES locacao (id_locacao),
    CONSTRAINT FkItemLocacaoEquipamento
        FOREIGN KEY (id_equipamento) REFERENCES equipamento (id_equipamento)
);

SHOW DATABASES;
SHOW TABLES;

DESCRIBE cliente;
DESCRIBE categoria;
DESCRIBE equipamento;
DESCRIBE locacao;
DESCRIBE item_locacao;

-- chaves e relacionamentos
SELECT TABLE_NAME, CONSTRAINT_NAME, COLUMN_NAME,
       REFERENCED_TABLE_NAME, REFERENCED_COLUMN_NAME
FROM information_schema.KEY_COLUMN_USAGE
WHERE TABLE_SCHEMA = 'dbLocadoraTeste'
ORDER BY TABLE_NAME, CONSTRAINT_NAME;

-- ex 17 --

USE dbLocadoraTeste;

ALTER TABLE equipamento MODIFY nome VARCHAR(180) NOT NULL;
ALTER TABLE equipamento ADD marca VARCHAR(80) NOT NULL;
ALTER TABLE cliente DROP COLUMN telefone;

-- o CHECK usa a coluna, então é retirado antes da renomeação e recriado depois
-- (só funciona uma vez: para repetir, execute de novo a partir do ex 16)
ALTER TABLE equipamento DROP CHECK ChkEquipamentoValor;
ALTER TABLE equipamento RENAME COLUMN valor_diario TO valor_locacao;
ALTER TABLE equipamento ADD CONSTRAINT ChkEquipamentoValor CHECK (valor_locacao >= 0);

RENAME TABLE categoria TO tipo_equipamento;

SHOW TABLES;
DESCRIBE cliente;
DESCRIBE equipamento;
DESCRIBE tipo_equipamento;
SHOW CREATE TABLE equipamento;  -- a FK passa a apontar para tipo_equipamento

-- ex 18 --

USE dbLocadoraTeste;

CREATE TABLE equipamento_importacao (
    codigo     VARCHAR(30),
    descricao  VARCHAR(180),
    quantidade INT
);

DESCRIBE equipamento_importacao;

-- Situação A: apagar os dados e manter a estrutura para reutilização -> TRUNCATE
TRUNCATE TABLE equipamento_importacao;

-- Situação B: a estrutura não terá mais utilidade -> DROP
DROP TABLE IF EXISTS equipamento_importacao;

SHOW TABLES;

-- ex 19 --

SHOW DATABASES;

-- bancos usados nesta sequência apenas para treinamento (dbHorizonte não é criado)
DROP DATABASE IF EXISTS dbTreinamento;
DROP DATABASE IF EXISTS dbLocadoraTeste;

SHOW DATABASES;
