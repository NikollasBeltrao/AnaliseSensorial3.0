-- phpMyAdmin SQL Dump
-- version 5.0.2
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Tempo de geração: 12-Jun-2023 às 05:46
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
(32, 'Ingredientes..........', 57, 614, ''),
(33, 'Ingredientes..........', 57, 177, ''),
(34, 'Ingredientes..........', 57, 267, ''),
(35, '', 59, 265, ''),
(36, 'Ingredientes...', 60, 715, ''),
(37, 'Ingredientes....', 60, 384, ''),
(38, '', 61, 735, ''),
(39, '', 61, 360, ''),
(40, '', 62, 653, ''),
(41, '', 63, 302, ''),
(42, 'Leite, açúcar, essência de morango', 64, 171, 'https://backend-analise.000webhostapp.com/backend-analise/analise/imgsamostras/637febc1cb5b2.png'),
(43, '', 67, 683, ''),
(44, 'varias coisas ', 68, 163, ''),
(45, '', 71, 195, 'https://backend-analise.000webhostapp.com/backend-analise/analise/imgsamostras/643ef644014c2.png');

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
(57, 'Analise de comparação', 1, '2022-08-13', 'Teste de comparação', 0, '32d64e'),
(58, 'Coxinha Errado', 1, '2022-08-17', '', 0, '064c1e'),
(59, 'Coxinha Errado', 1, '2022-08-17', '', 0, '296657'),
(60, 'Teste', 1, '2022-08-18', 'testando.....', 1, '379368'),
(61, 'Macarrão ', 18, '2022-08-18', '', 1, 'b9859c'),
(62, 'Coxinha', 1, '2022-08-18', '', 0, 'e48c9f'),
(63, 'Pastel', 29, '2022-09-04', '', 0, '976cb6'),
(64, 'Sorvete ', 31, '2022-11-24', 'teste', 1, '29f7d2'),
(65, 'Hdjsaj', 1, '2022-12-01', 'jsjsj', 1, '4b575e'),
(66, 'Hfh', 1, '2022-12-14', 'jcc', 0, 'e96e7c'),
(67, 'Teste', 1, '2022-12-20', '', 0, 'd67f3c'),
(68, 'sanduiche de buceta', 32, '2023-03-03', 'feito de forma duvidosa', 1, '08de90'),
(69, 'Sorvete', 1, '2023-03-09', '', 0, 'f58d4a'),
(70, 'Suco tropical de cajá-umbu', 1, '2023-04-18', '', 0, '337723'),
(71, 'Suco tropical de cajá-umbu', 1, '2023-04-18', 'Você está recebendo uma amostra de suco tropical de cajá-umbu. Favor não realizar o teste caso tenha alergia a este produto.', 1, 'b5cf40'),
(72, 'asdf', 1, '2023-05-28', 'asfas', 0, '8521af'),
(73, 'teste 8', 1, '2023-05-28', 'sdfsf', 0, '3b8195');

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
(2, 56, 1, 'bkkvcmnokhj');

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
(4, 2, 3);

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
(107, '', 'Masculino', 'menos de 18 anos', 1, 57),
(108, '', 'Feminino', '18 a 21 anos', 1, 56),
(109, 'Usuário Teste', 'Feminino', '18 a 21 anos', 1, 56),
(110, 'Fulano', 'Prefiro não responder', 'mais de 35 anos', 1, 57),
(111, 'Nikollas ', 'Masculino', '18 a 21 anos', 2, 60),
(112, 'Laura Jorge Nogueira Cavalcanti', 'Feminino', 'mais de 35 anos', 3, 62),
(113, 'Cosmo Rufino de Lima ', 'Masculino', 'mais de 35 anos', 3, 62),
(114, 'Raquel Silva de Castro ', 'Feminino', '22 a 26 anos', 4, 62),
(115, 'Flávia ', 'Feminino', '27 a 35 anos', 2, 62),
(116, 'Rayssa Isabelle da Silva Marques ', 'Feminino', '18 a 21 anos', 2, 62),
(117, 'Leonardo Vandré dos Santos Siqueira', 'Masculino', '22 a 26 anos', 3, 62),
(118, 'Thauanni vitória ', 'Feminino', '18 a 21 anos', 3, 62),
(119, 'Vitório David ', 'Masculino', '18 a 21 anos', 3, 62),
(120, 'Severino Neto ', 'Masculino', '22 a 26 anos', 3, 62),
(121, 'Pablo', 'Masculino', 'mais de 35 anos', 3, 62),
(122, 'Luís Henrique de Araújo Nunes ', 'Masculino', '18 a 21 anos', 3, 62),
(123, 'Denys Victor Guedes da Silva ', 'Masculino', '22 a 26 anos', 3, 62),
(124, 'Pedro Vinicius Alcantara', 'Masculino', '22 a 26 anos', 3, 62),
(125, 'Lucas Lopes', 'Masculino', '27 a 35 anos', 2, 62),
(126, 'Maria Clara dos Santos Vasconcelos ', 'Feminino', '18 a 21 anos', 3, 62),
(127, 'Rennan', 'Masculino', '22 a 26 anos', 3, 62),
(128, 'Maria Isabela ', 'Feminino', '22 a 26 anos', 4, 62),
(129, 'Jéssica Maria', 'Feminino', '27 a 35 anos', 3, 62),
(130, 'Denise ', 'Feminino', '27 a 35 anos', 2, 62),
(131, 'Thiago veras da silva', 'Masculino', '18 a 21 anos', 3, 62),
(132, 'Marcia Cristina Rafael de lima', 'Feminino', '27 a 35 anos', 3, 62),
(133, 'José Adrian Santos LEITE ', 'Masculino', '18 a 21 anos', 2, 62),
(134, 'Henrique Alisson', 'Masculino', '27 a 35 anos', 3, 62),
(135, 'Lucas Silva Batista ', 'Masculino', '18 a 21 anos', 2, 62),
(136, 'Pedro Felipe Claudino messias rocha', 'Masculino', '18 a 21 anos', 2, 62),
(137, 'Francisco Lindermberg Monteiro Martins', 'Masculino', '27 a 35 anos', 2, 62),
(138, 'Luan Carlos da Costa anjos ', 'Masculino', '22 a 26 anos', 2, 62),
(139, 'Kennedy Francês Rodrigues Damascena', 'Masculino', '27 a 35 anos', 3, 62),
(140, 'Juscelino Alves Henriques', 'Masculino', '27 a 35 anos', 3, 62),
(141, 'Edclecia Barbosa de Araujo', 'Feminino', '27 a 35 anos', 3, 62),
(142, 'Maria Daniela Pereira Barbosa ', 'Feminino', '18 a 21 anos', 3, 62),
(143, 'José Emerson ', 'Masculino', '18 a 21 anos', 2, 62),
(144, 'Mateus bezerra da silva', 'Masculino', '22 a 26 anos', 2, 62),
(145, 'Maria vitoria', 'Feminino', '18 a 21 anos', 1, 62),
(146, 'Fabio Renato Marques severo ', 'Masculino', '22 a 26 anos', 3, 62),
(147, 'Marcus ', 'Masculino', '27 a 35 anos', 2, 62),
(148, 'Daniel Nunes', 'Masculino', '27 a 35 anos', 2, 62),
(149, 'Manoely oliveira ', 'Feminino', '27 a 35 anos', 3, 62),
(150, 'Michelly ', 'Feminino', '18 a 21 anos', 2, 62),
(151, 'Carlos', 'Masculino', '18 a 21 anos', 3, 62),
(152, 'Gabrielly oliveira', 'Feminino', '18 a 21 anos', 2, 62),
(153, 'Fabíola Gomes de morais', 'Feminino', '18 a 21 anos', 2, 62),
(154, 'Thaiany Emilly Burgo ver Lima ', 'Feminino', '22 a 26 anos', 3, 62),
(155, 'V', 'Feminino', '22 a 26 anos', 2, 64),
(156, 'Teste2', 'Masculino', 'menos de 18 anos', 3, 64),
(157, 'Teste 2', 'Feminino', '27 a 35 anos', 3, 64),
(158, 'Ritley Manoel', 'Masculino', '22 a 26 anos', 3, 68),
(159, 'Michelly', 'Feminino', '18 a 21 anos', 4, 71),
(160, 'Gislene', 'Feminino', '18 a 21 anos', 4, 71),
(161, 'Laísa', 'Feminino', '18 a 21 anos', 4, 71),
(162, 'Elisandra ', 'Feminino', 'mais de 35 anos', 4, 71),
(163, 'Adriana ', 'Feminino', '27 a 35 anos', 4, 71),
(164, 'Marinez', 'Feminino', 'mais de 35 anos', 2, 71),
(165, 'Cleide Nunes da Silva ', 'Feminino', 'mais de 35 anos', 2, 71),
(166, 'Pedro Felipe claudino Messias Rocha ', 'Masculino', '18 a 21 anos', 4, 71),
(167, 'José Pedro Rick Alves  Cavalcante', 'Masculino', 'menos de 18 anos', 2, 71),
(168, 'Luan Carlos da Costa Anjos', 'Masculino', '22 a 26 anos', 2, 71),
(169, 'José de Sousa filho', 'Masculino', 'menos de 18 anos', 4, 71),
(170, 'Lucas Siqueira Lopes', 'Masculino', '27 a 35 anos', 4, 71),
(171, 'Carlos Alexsandro', 'Masculino', '18 a 21 anos', 4, 71),
(172, 'Jacineide', 'Feminino', 'mais de 35 anos', 4, 71),
(173, 'Lucas Silva ', 'Masculino', '22 a 26 anos', 4, 71),
(174, 'Thomas Inácio Siqueira da Silva Filho', 'Masculino', '18 a 21 anos', 4, 71),
(175, 'Magnum Vinícius ', 'Masculino', '18 a 21 anos', 4, 71),
(176, 'Geraldo ', 'Masculino', 'mais de 35 anos', 3, 71),
(177, 'José Danilo Oliveira do Nascimento', 'Masculino', '27 a 35 anos', 4, 71),
(178, 'José deivid', 'Masculino', '18 a 21 anos', 4, 71),
(179, 'Luiz carlos', 'Masculino', 'mais de 35 anos', 3, 71),
(180, 'André Barbosa ', 'Masculino', '27 a 35 anos', 1, 71),
(181, 'Fábio levi', 'Masculino', 'menos de 18 anos', 4, 71),
(182, 'Renato cordeiro ', 'Masculino', '27 a 35 anos', 4, 71),
(183, 'Ana', 'Feminino', '18 a 21 anos', 4, 71),
(184, 'Kaique nunes', 'Masculino', '22 a 26 anos', 4, 71),
(185, 'Alexandre Lima Ferreira Sabino', 'Masculino', '18 a 21 anos', 3, 71),
(186, 'Elves felix', 'Masculino', '27 a 35 anos', 3, 71),
(187, 'Eliton', 'Masculino', '18 a 21 anos', 4, 71),
(188, 'Eliton', 'Masculino', '18 a 21 anos', 4, 71),
(189, 'Tomé cordeiro da Silva ', 'Masculino', '18 a 21 anos', 2, 71),
(190, 'Fernanda', 'Feminino', '18 a 21 anos', 4, 71),
(191, 'Thauanni Vitória da Silva Moura Santos ', 'Feminino', '18 a 21 anos', 4, 71),
(192, 'Maria Vitoria Amaral da Silva', 'Feminino', '18 a 21 anos', 4, 71),
(193, 'Vitória Nayara ', 'Feminino', '22 a 26 anos', 4, 71),
(194, 'Luciana cordeiro ', 'Feminino', '22 a 26 anos', 4, 71),
(195, 'Ageu', 'Masculino', '18 a 21 anos', 4, 71),
(196, 'Joergerson vladislon gouveia', 'Masculino', '22 a 26 anos', 2, 71),
(197, 'Louie Marques Soares', 'Masculino', '18 a 21 anos', 4, 71),
(198, 'Carlos Henrique de Queiroz Carvalho', 'Masculino', '18 a 21 anos', 4, 71),
(199, 'Jallisson Silva Vieira', 'Masculino', '22 a 26 anos', 4, 71),
(200, 'Iasmin', 'Feminino', '18 a 21 anos', 3, 71),
(201, 'Marcelo de Sousa Nunes', 'Masculino', 'mais de 35 anos', 4, 71),
(202, 'José Fabrício de Oliveira Braz ', 'Masculino', '18 a 21 anos', 4, 71);

-- --------------------------------------------------------

--
-- Estrutura da tabela `ficha_resposta`
--

CREATE TABLE `ficha_resposta` (
  `fk_atributo_teste` int(11) NOT NULL,
  `fk_ficha` int(11) NOT NULL,
  `fk_amostra` int(11) NOT NULL,
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
(4, 109, 31, 4);

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
  MODIFY `id_amostra` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=46;

--
-- AUTO_INCREMENT de tabela `analise`
--
ALTER TABLE `analise`
  MODIFY `id_analise` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=74;

--
-- AUTO_INCREMENT de tabela `analise_teste`
--
ALTER TABLE `analise_teste`
  MODIFY `id_analise_teste` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT de tabela `atributo_padrao`
--
ALTER TABLE `atributo_padrao`
  MODIFY `id_atributo_padrao` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT de tabela `atributo_teste`
--
ALTER TABLE `atributo_teste`
  MODIFY `id_atributo_teste` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT de tabela `ficha`
--
ALTER TABLE `ficha`
  MODIFY `id_ficha` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=203;

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
