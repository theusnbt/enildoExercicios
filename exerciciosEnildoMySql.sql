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

