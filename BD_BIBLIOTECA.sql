create database biblioteca;
use biblioteca;

-- Criação da tabela Autor
CREATE TABLE Autor (
    id_autor INT PRIMARY KEY AUTO_INCREMENT,  -- Chave primária auto-incrementada
    nome VARCHAR(100) NOT NULL,
    data_nascimento DATE
);

-- Inserir dados em Autor
INSERT INTO Autor (nome, data_nascimento) VALUES
('J.K. Rowling', '1965-07-31'),
('George Orwell', '1903-06-25'),
('Agatha Christie', '1890-09-15'),
('J.R.R. Tolkien', '1892-01-03'),
('Stephen King', '1947-09-21'),
('Machado de Assis', '1839-06-21'),
('Clarice Lispector', '1920-12-10'),
('Dan Brown', '1964-06-22'),
('Suzanne Collins', '1962-08-10'),
('Isaac Asimov', '1920-01-02');
-- Criação da tabela Livro

CREATE TABLE Livro (
    isbn VARCHAR(20) PRIMARY KEY,  -- ISBN como string para flexibilidade
    titulo VARCHAR(200) NOT NULL,
    ano_publicacao INT,
    id_autor INT NOT NULL,
    FOREIGN KEY (id_autor) REFERENCES Autor(id_autor) ON DELETE CASCADE  -- FK para Autor, com cascata para exclusão
);

-- Inserir dados em Livro
INSERT INTO Livro (isbn, titulo, ano_publicacao, id_autor) VALUES
('9780439708180', 'Harry Potter e a Pedra Filosofal', 1997, 1),
('9780451524935', '1984', 1949, 2),
('9780062073488', 'Assassinato no Expresso do Oriente', 1934, 3),
('9780439139601', 'Harry Potter e a Câmara Secreta', 1998, 1),
('9780261103573', 'O Senhor dos Anéis: A Sociedade do Anel', 1954, 4),
('9780450411434', 'O Iluminado', 1977, 5),
('9788520915623', 'Dom Casmurro', 1899, 6),
('9788520926315', 'A Hora da Estrela', 1977, 7),
('9780385504201', 'O Código Da Vinci', 2003, 8),
('9780439023528', 'Jogos Vorazes', 2008, 9);

-- Criação da tabela Usuario
CREATE TABLE Usuario (
    id_usuario INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL  -- Email único para evitar duplicatas
);

-- Inserir dados em Usuario
INSERT INTO Usuario (nome, email) VALUES
('João Silva', 'joao@email.com'),
('Maria Santos', 'maria@email.com'),
('Pedro Oliveira', 'pedro@email.com'),
('Ana Costa', 'ana@email.com'),
('Lucas Pereira', 'lucas@email.com'),
('Fernanda Lima', 'fernanda@email.com'),
('Rafael Souza', 'rafael@email.com'),
('Beatriz Almeida', 'beatriz@email.com'),
('Carlos Mendes', 'carlos@email.com'),
('Juliana Rocha', 'juliana@email.com');

-- Criação da tabela Emprestimo
CREATE TABLE Emprestimo (
    id_emprestimo INT PRIMARY KEY AUTO_INCREMENT,
    data_emprestimo DATE NOT NULL,
    data_devolucao DATE,
    id_usuario INT NOT NULL,
    isbn VARCHAR(20) NOT NULL,
    FOREIGN KEY (id_usuario) REFERENCES Usuario(id_usuario) ON DELETE CASCADE,
    FOREIGN KEY (isbn) REFERENCES Livro(isbn) ON DELETE CASCADE
);

-- Inserir dados em Emprestimo
INSERT INTO Emprestimo (data_emprestimo, data_devolucao, id_usuario, isbn) VALUES
('2023-10-01', '2023-10-15', 1, '9780439708180'),
('2023-10-05', NULL, 2, '9780451524935'),
('2023-10-10', '2023-10-20', 3, '9780062073488'),
('2023-10-12', NULL, 1, '9780439139601'),
('2023-10-18', '2023-10-30', 4, '9780261103573'),
('2023-11-01', NULL, 5, '9780450411434'),
('2023-11-05', '2023-11-12', 6, '9788520915623'),
('2023-11-07', NULL, 7, '9788520926315'),
('2023-11-10', '2023-11-20', 8, '9780385504201'),
('2023-11-12', NULL, 9, '9780439023528');

-- QUERIES

-- 1- Listando os empréstimos com nome do usuário e título do livro!
SELECT e.id_emprestimo, u.nome AS usuario, l.titulo AS livro, e.data_emprestimo, e.data_devolucao
FROM Emprestimo e
JOIN Usuario u ON e.id_usuario = u.id_usuario
JOIN Livro l ON e.isbn = l.isbn;

--  2 - Mostrandro todos os livros emprestados que ainda não foram devolvidos!
SELECT u.nome AS usuario, l.titulo AS livro, e.data_emprestimo FROM Emprestimo e
JOIN Usuario u ON e.id_usuario = u.id_usuario
JOIN Livro l ON e.isbn = l.isbn
WHERE e.data_devolucao IS NULL;

-- 3- Mostrando os livros mais emprestados! (ranking)
SELECT l.titulo, COUNT(e.id_emprestimo) AS vezes_emprestado FROM Livro l
JOIN Emprestimo e ON l.isbn = e.isbn
GROUP BY l.titulo ORDER BY vezes_emprestado DESC;

-- 4 - Mostrando os usuários que ainda não devolveram nenhum livro!
SELECT nome, email
FROM Usuario
WHERE id_usuario IN (
    SELECT id_usuario
    FROM Emprestimo
    WHERE data_devolucao IS NULL
);

-- 5 - Mostrando os autores com mais de 1 livro cadastrado
SELECT a.nome AS autor, COUNT(l.isbn) AS total_livros
FROM Autor a
JOIN Livro l ON a.id_autor = l.id_autor
GROUP BY a.nome
HAVING COUNT(l.isbn) > 1;
