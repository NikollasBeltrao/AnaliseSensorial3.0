-- phpMyAdmin SQL Dump
-- version 5.0.2
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Tempo de geração: 14-Jun-2023 às 06:14
-- Versão do servidor: 10.4.11-MariaDB
-- versão do PHP: 7.4.4

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Banco de dados: `analisesensorial`
--

-- --------------------------------------------------------

--
-- Estrutura da tabela `amostra`
--

CREATE TABLE `amostra` (
  `id_amostra` int(11) NOT NULL,
  `ingredientes` varchar(255) NOT NULL,
  `fk_analise` int(11) NOT NULL,
  `numero_amostra` int(11) NOT NULL,
  `img_amostra` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Extraindo dados da tabela `amostra`
--

INSERT INTO `amostra` (`id_amostra`, `ingredientes`, `fk_analise`, `numero_amostra`, `img_amostra`) VALUES
(30, 'Chocolate amargo', 56, 257, ''),
(31, 'Chocolate ao leite', 56, 395, ''),
(46, 'teste amostra 435', 77, 435, ''),
(47, 'teste amostra 783', 77, 783, '');

-- --------------------------------------------------------

--
-- Estrutura da tabela `analise`
--

CREATE TABLE `analise` (
  `id_analise` int(11) NOT NULL,
  `nome_alimento` varchar(100) NOT NULL,
  `fk_usuario` int(11) NOT NULL,
  `data` date NOT NULL DEFAULT current_timestamp(),
  `instrucoes` varchar(255) NOT NULL,
  `status` int(11) NOT NULL DEFAULT 0,
  `codigo` varchar(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Extraindo dados da tabela `analise`
--

INSERT INTO `analise` (`id_analise`, `nome_alimento`, `fk_usuario`, `data`, `instrucoes`, `status`, `codigo`) VALUES
(56, 'Chocolate', 1, '2022-08-13', 'Teste de análise de chocolate', 1, '26ee49'),
(77, 'TESTE', 1, '2023-06-12', 'FDDG EFGFDA F ', 1, 'a9d7f7');

-- --------------------------------------------------------

--
-- Estrutura da tabela `analise_teste`
--

CREATE TABLE `analise_teste` (
  `id_analise_teste` int(11) NOT NULL,
  `fk_analise` int(11) NOT NULL,
  `fk_teste_padrao` int(11) NOT NULL,
  `descricao_analise_teste` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Extraindo dados da tabela `analise_teste`
--

INSERT INTO `analise_teste` (`id_analise_teste`, `fk_analise`, `fk_teste_padrao`, `descricao_analise_teste`) VALUES
(1, 56, 2, 'uyhyfhf uyhgfyfhj'),
(2, 56, 1, 'bkkvcmnokhj'),
(3, 77, 1, 'Você está recebendo ---- amostras de -----. Avalie cada amostra e utilize a escala abaixo para identificar o quanto você gostou/desgostou de cada amostra quanto à ----, ----, ----, ---- e ----. Prove as amostras da esquerda para direita.'),
(4, 77, 2, 'Agora avalie quanto à sua atitude de compra'),
(5, 77, 3, 'Qual foi sua amostra proferida ?'),
(6, 77, 4, 'Compare os atributos');

-- --------------------------------------------------------

--
-- Estrutura da tabela `atributo_padrao`
--

CREATE TABLE `atributo_padrao` (
  `id_atributo_padrao` int(11) NOT NULL,
  `nome_atributo` varchar(50) NOT NULL,
  `ordem_atributo` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Extraindo dados da tabela `atributo_padrao`
--

INSERT INTO `atributo_padrao` (`id_atributo_padrao`, `nome_atributo`, `ordem_atributo`) VALUES
(1, 'Atitude de Compra', 1),
(2, 'Cor', 1),
(3, 'Sabor', 2),
(4, 'Textura', 2),
(5, 'Amostra Preferida', 1),
(6, 'Aparência', 1),
(7, 'Impressão Global', 2),
(8, 'Doçura', 2);

-- --------------------------------------------------------

--
-- Estrutura da tabela `atributo_teste`
--

CREATE TABLE `atributo_teste` (
  `id_atributo_teste` int(11) NOT NULL,
  `fk_analise_teste` int(11) NOT NULL,
  `fk_atributo_padrao` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Extraindo dados da tabela `atributo_teste`
--

INSERT INTO `atributo_teste` (`id_atributo_teste`, `fk_analise_teste`, `fk_atributo_padrao`) VALUES
(1, 2, 4),
(2, 1, 1),
(3, 2, 2),
(4, 2, 3),
(5, 3, 3),
(6, 3, 2),
(7, 4, 1),
(8, 5, 5),
(9, 6, 8),
(10, 6, 4);

-- --------------------------------------------------------

--
-- Estrutura da tabela `ficha`
--

CREATE TABLE `ficha` (
  `id_ficha` int(11) NOT NULL,
  `nome_aluno` varchar(50) NOT NULL,
  `genero` varchar(50) NOT NULL,
  `faixa_etaria` varchar(20) NOT NULL,
  `frequencia_consumo` int(11) NOT NULL,
  `fk_analise` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Extraindo dados da tabela `ficha`
--

INSERT INTO `ficha` (`id_ficha`, `nome_aluno`, `genero`, `faixa_etaria`, `frequencia_consumo`, `fk_analise`) VALUES
(108, '', 'Feminino', '18 a 21 anos', 1, 56),
(109, 'Usuário Teste', 'Feminino', '18 a 21 anos', 1, 56),
(203, 'Nome teste', 'Masculino', '27 a 35 anos', 1, 77),
(204, 'nikollas', 'Masculino', '18 a 21 anos', 2, 77),
(205, '', 'Prefiro não responder', 'menos de 18 anos', 4, 77),
(206, 'teste2', 'Prefiro não responder', 'mais de 35 anos', 4, 77),
(207, 'nikollas', 'Masculino', 'menos de 18 anos', 1, 56);

-- --------------------------------------------------------

--
-- Estrutura da tabela `ficha_resposta`
--

CREATE TABLE `ficha_resposta` (
  `fk_atributo_teste` int(11) NOT NULL,
  `fk_ficha` int(11) NOT NULL,
  `fk_amostra` int(11) DEFAULT NULL,
  `resposta` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Extraindo dados da tabela `ficha_resposta`
--

INSERT INTO `ficha_resposta` (`fk_atributo_teste`, `fk_ficha`, `fk_amostra`, `resposta`) VALUES
(1, 108, 30, 1),
(1, 109, 30, 1),
(2, 108, 31, 5),
(3, 108, 30, 5),
(4, 108, 30, 6),
(4, 109, 30, 5),
(3, 109, 30, 3),
(2, 109, 31, 3),
(2, 108, 30, 5),
(1, 108, 31, 2),
(3, 108, 31, 5),
(4, 108, 31, 6),
(2, 109, 30, 3),
(1, 109, 31, 1),
(3, 109, 31, 7),
(4, 109, 31, 4),
(6, 203, 46, 9),
(5, 203, 46, 8),
(7, 203, 46, 5),
(6, 203, 47, 5),
(5, 203, 47, 8),
(7, 203, 47, 5),
(10, 203, NULL, 435),
(9, 203, NULL, 783),
(8, 203, NULL, 435),
(6, 204, 46, 4),
(5, 204, 46, 7),
(7, 204, 46, 3),
(6, 204, 47, 1),
(5, 204, 47, 3),
(7, 204, 47, 1),
(10, 204, NULL, 435),
(9, 204, NULL, 783),
(8, 204, NULL, 435),
(6, 205, 46, 7),
(5, 205, 46, 4),
(7, 205, 46, 4),
(6, 205, 47, 6),
(5, 205, 47, 7),
(7, 205, 47, 3),
(10, 205, NULL, 435),
(9, 205, NULL, 783),
(8, 205, NULL, 783),
(6, 206, 46, 1),
(5, 206, 46, 2),
(7, 206, 46, 3),
(6, 206, 47, 4),
(5, 206, 47, 5),
(7, 206, 47, 5),
(10, 206, NULL, 783),
(9, 206, NULL, 435),
(8, 206, NULL, 783),
(3, 207, 30, 1),
(4, 207, 30, 2),
(1, 207, 30, 3),
(2, 207, 30, 4),
(3, 207, 31, 5),
(4, 207, 31, 6),
(1, 207, 31, 7),
(2, 207, 31, 5);

-- --------------------------------------------------------

--
-- Estrutura da tabela `teste_padrao`
--

CREATE TABLE `teste_padrao` (
  `id_teste_padrao` int(11) NOT NULL,
  `nome_teste` varchar(255) NOT NULL,
  `descricao_teste` varchar(255) NOT NULL,
  `ordem` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Extraindo dados da tabela `teste_padrao`
--

INSERT INTO `teste_padrao` (`id_teste_padrao`, `nome_teste`, `descricao_teste`, `ordem`) VALUES
(1, 'Escala Hedônica', 'A escala hedônica estruturada é um método que analisa a preferência dos consumidores por determinados produtos por meio de uma avaliação que contém uma escala de respostas previamente estabelecida.', 1),
(2, 'Atitude de Compra', '....', 3),
(3, 'Preferência', '...', 4),
(4, 'Comparação', '...', 2);

-- --------------------------------------------------------

--
-- Estrutura da tabela `usuario`
--

CREATE TABLE `usuario` (
  `id_usuario` int(11) NOT NULL,
  `login` varchar(20) NOT NULL,
  `senha` varchar(50) NOT NULL,
  `permissoes` int(11) NOT NULL,
  `nome_usuario` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Extraindo dados da tabela `usuario`
--

INSERT INTO `usuario` (`id_usuario`, `login`, `senha`, `permissoes`, `nome_usuario`) VALUES
(1, '2020ADM', 'admin', 2, 'Admin'),
(2, '20201AF0318', '1234', 1, 'Nikollas Victor'),
(3, '20201AF0543', '1234', 1, 'Aluno Teste'),
(14, '2020Aluno', '1234', 1, 'Usuário Teste'),
(15, '2021', '1224', 1, 'Vitória'),
(16, 'al', '1234', 1, 'Fulano'),
(17, '1234', '1234', 1, 'Diego'),
(18, '20191lcaf0319', 'Senha', 1, 'Vitória '),
(19, '20191lcaf0408', 'lhans123', 1, 'Luís Henrique de Araújo Nunes Silva '),
(20, '20191lcaf0408', 'luis2000', 1, 'Luís Henrique de Araújo Nunes Silva '),
(21, '20191lcaf0092', 'Careca', 1, 'Vitório David '),
(22, '20191lcaf0408', 'luis2000', 1, 'Luís Henrique de Araújo Nunes Silva '),
(23, '20191LCAF0351', '#96153254', 1, 'Severino Neto'),
(24, '20211lcaf0280', '2019', 1, 'Maria Isabela '),
(25, '20211lcaf0280', '2019', 1, 'Maria Isabela '),
(26, '20211LCAF0221', 'Amor12345', 1, 'Thiago veras da silva'),
(27, '20211LCAF0221', 'Amor12345', 1, 'Thiago veras da silva'),
(28, '20191lcaf0483', '123654789', 1, 'Rennan Messias Alves de Queiroz Lopes '),
(29, '54321', '1234', 1, 'Teste'),
(30, '54321', '1234', 1, 'Teste'),
(31, 'Vitória ', 'senha', 1, 'Vitoria'),
(32, 'adm', 'admin', 1, 'Ritley Manoel');

--
-- Índices para tabelas despejadas
--

--
-- Índices para tabela `amostra`
--
ALTER TABLE `amostra`
  ADD PRIMARY KEY (`id_amostra`),
  ADD KEY `fk_analise` (`fk_analise`);

--
-- Índices para tabela `analise`
--
ALTER TABLE `analise`
  ADD PRIMARY KEY (`id_analise`),
  ADD KEY `fk_user` (`fk_usuario`);

--
-- Índices para tabela `analise_teste`
--
ALTER TABLE `analise_teste`
  ADD PRIMARY KEY (`id_analise_teste`),
  ADD KEY `fk_analise` (`fk_analise`),
  ADD KEY `fk_teste_padrao` (`fk_teste_padrao`);

--
-- Índices para tabela `atributo_padrao`
--
ALTER TABLE `atributo_padrao`
  ADD PRIMARY KEY (`id_atributo_padrao`);

--
-- Índices para tabela `atributo_teste`
--
ALTER TABLE `atributo_teste`
  ADD PRIMARY KEY (`id_atributo_teste`),
  ADD KEY `fk_analise_teste` (`fk_analise_teste`),
  ADD KEY `fk_atributo_padrao` (`fk_atributo_padrao`);

--
-- Índices para tabela `ficha`
--
ALTER TABLE `ficha`
  ADD PRIMARY KEY (`id_ficha`),
  ADD KEY `fk_analise` (`fk_analise`);

--
-- Índices para tabela `ficha_resposta`
--
ALTER TABLE `ficha_resposta`
  ADD KEY `fk_amostra` (`fk_amostra`),
  ADD KEY `fk_ficha` (`fk_ficha`),
  ADD KEY `fk_atributo_teste` (`fk_atributo_teste`);

--
-- Índices para tabela `teste_padrao`
--
ALTER TABLE `teste_padrao`
  ADD PRIMARY KEY (`id_teste_padrao`);

--
-- Índices para tabela `usuario`
--
ALTER TABLE `usuario`
  ADD PRIMARY KEY (`id_usuario`);

--
-- AUTO_INCREMENT de tabelas despejadas
--

--
-- AUTO_INCREMENT de tabela `amostra`
--
ALTER TABLE `amostra`
  MODIFY `id_amostra` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=48;

--
-- AUTO_INCREMENT de tabela `analise`
--
ALTER TABLE `analise`
  MODIFY `id_analise` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=78;

--
-- AUTO_INCREMENT de tabela `analise_teste`
--
ALTER TABLE `analise_teste`
  MODIFY `id_analise_teste` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT de tabela `atributo_padrao`
--
ALTER TABLE `atributo_padrao`
  MODIFY `id_atributo_padrao` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT de tabela `atributo_teste`
--
ALTER TABLE `atributo_teste`
  MODIFY `id_atributo_teste` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT de tabela `ficha`
--
ALTER TABLE `ficha`
  MODIFY `id_ficha` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=208;

--
-- AUTO_INCREMENT de tabela `teste_padrao`
--
ALTER TABLE `teste_padrao`
  MODIFY `id_teste_padrao` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT de tabela `usuario`
--
ALTER TABLE `usuario`
  MODIFY `id_usuario` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=33;

--
-- Restrições para despejos de tabelas
--

--
-- Limitadores para a tabela `amostra`
--
ALTER TABLE `amostra`
  ADD CONSTRAINT `amostra_ibfk_1` FOREIGN KEY (`fk_analise`) REFERENCES `analise` (`id_analise`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Limitadores para a tabela `analise`
--
ALTER TABLE `analise`
  ADD CONSTRAINT `analise_ibfk_1` FOREIGN KEY (`fk_usuario`) REFERENCES `usuario` (`id_usuario`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Limitadores para a tabela `analise_teste`
--
ALTER TABLE `analise_teste`
  ADD CONSTRAINT `analise_teste_ibfk_1` FOREIGN KEY (`fk_analise`) REFERENCES `analise` (`id_analise`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `analise_teste_ibfk_2` FOREIGN KEY (`fk_teste_padrao`) REFERENCES `teste_padrao` (`id_teste_padrao`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Limitadores para a tabela `atributo_teste`
--
ALTER TABLE `atributo_teste`
  ADD CONSTRAINT `atributo_teste_ibfk_1` FOREIGN KEY (`fk_analise_teste`) REFERENCES `analise_teste` (`id_analise_teste`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `atributo_teste_ibfk_2` FOREIGN KEY (`fk_atributo_padrao`) REFERENCES `atributo_padrao` (`id_atributo_padrao`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Limitadores para a tabela `ficha`
--
ALTER TABLE `ficha`
  ADD CONSTRAINT `ficha_ibfk_1` FOREIGN KEY (`fk_analise`) REFERENCES `analise` (`id_analise`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Limitadores para a tabela `ficha_resposta`
--
ALTER TABLE `ficha_resposta`
  ADD CONSTRAINT `ficha_resposta_ibfk_1` FOREIGN KEY (`fk_amostra`) REFERENCES `amostra` (`id_amostra`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `ficha_resposta_ibfk_2` FOREIGN KEY (`fk_ficha`) REFERENCES `ficha` (`id_ficha`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `ficha_resposta_ibfk_3` FOREIGN KEY (`fk_atributo_teste`) REFERENCES `atributo_teste` (`id_atributo_teste`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
