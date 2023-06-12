<?php
require_once './conexao.php';
$method = $_SERVER['REQUEST_METHOD'];

switch ($method) {
    case 'PUT':

        break;
    case 'POST':
        if (isset($_POST['changeStatus'])) {
            changeStatus();
        }
        break;
    case 'GET':
        if (isset($_GET['listarResultados'])) {
            listarResultados();
        } else if (isset($_GET['getByUsuario'])) {
            getByUsuario();
        } else if (isset($_GET['getAnaliseById'])) {
            getAnaliseById();
        } else if (isset($_GET['listarGraficos'])) {
            listarGraficos();
        } else if (isset($_GET['getRespostaByCodigo'])) {
            getRespostaByCodigo();
        } else if (isset($_GET['getAnaliseByCodigo'])) {
            getAnaliseByCodigo();
        } else if (isset($_GET['listarAtributos'])) {
            listarAtributos();
        }

        break;
    case 'DELETE':

        break;
    default:
        echo '{"error": "Método inválido"}';
        break;
}

function listarAtributos()
{
    try {
        $sql = "SELECT * FROM atributo_padrao WHERE id_atributo_padrao NOT IN (1, 5)";
        $bdpdo = BDPDO::getInstancia();
        $p_sql = $bdpdo->prepare($sql);
        $p_sql->execute();
        echo json_encode($p_sql->fetchAll(PDO::FETCH_OBJ));
    } catch (Exception $e) {
        print "Erro ao executar a função de listarTodos" . $e->getMessage();
    }
}

function getAnaliseById()
{
    try {
        $sql = "SELECT analise.*, usuario.nome_usuario FROM analise
        JOIN usuario ON usuario.id_usuario = analise.fk_usuario
        WHERE analise.id_analise = :analise LIMIT 1";
        $bdpdo = BDPDO::getInstancia();
        $p_sql = $bdpdo->prepare($sql);
        $p_sql->bindValue(":analise", $_GET['getAnaliseById']);
        $p_sql->execute();
        echo json_encode($p_sql->fetchObject());
    } catch (Exception $e) {
        print "Erro ao executar a função de listarTodos" . $e->getMessage();
    }
}

function getAnaliseByCodigo()
{
    try {
        $sql = "SELECT analise.*, usuario.nome_usuario FROM analise
        JOIN usuario ON usuario.id_usuario = analise.fk_usuario
        WHERE analise.codigo = :codigo LIMIT 1";
        $bdpdo = BDPDO::getInstancia();
        $p_sql = $bdpdo->prepare($sql);
        $p_sql->bindValue(":codigo", $_GET['getAnaliseByCodigo']);
        $p_sql->execute();
        echo json_encode($p_sql->fetchObject());
    } catch (Exception $e) {
        print "Erro ao executar a função de listarTodos" . $e->getMessage();
    }
}

function changeStatus()
{
    try {
        $sql = "UPDATE analise SET status = :novoStatus WHERE id_analise = :id";
        $bdpdo = BDPDO::getInstancia();
        $p_sql = $bdpdo->prepare($sql);
        $p_sql->bindValue(":id", $_POST['id']);
        $p_sql->bindValue(":novoStatus", $_POST['novoStatus']);
        $p_sql->execute();
        echo true;
    } catch (Exception $e) {
        echo false;
    }
}

function getByUsuario()
{
    try {
        $sql = "SELECT analise.*, usuario.nome_usuario FROM analise
        JOIN usuario ON usuario.id_usuario = analise.fk_usuario
        WHERE fk_usuario = :usuario";
        $bdpdo = BDPDO::getInstancia();
        $p_sql = $bdpdo->prepare($sql);
        $p_sql->bindValue(":usuario", $_GET['getByUsuario']);
        $p_sql->execute();
        echo json_encode($p_sql->fetchAll(PDO::FETCH_OBJ));
    } catch (Exception $e) {
        print "Erro ao executar a função de listarTodos" . $e->getMessage();
    }
}

function getRespostaByCodigo()
{
    try {
        $sql = "SELECT amostra.* FROM amostra
        JOIN analise ON analise.id_analise = amostra.fk_analise
        WHERE analise.codigo = :codigo";
        $bdpdo = BDPDO::getInstancia();
        $p_sql = $bdpdo->prepare($sql);
        $p_sql->bindValue(":codigo", $_GET['getRespostaByCodigo']);
        $p_sql->execute();
        $amostras = array();
        $linha_amostra = $p_sql->fetch(PDO::FETCH_ASSOC);
        $i = 0;
        while ($linha_amostra) {
            $analise_testes = array();
            $sql = "SELECT * FROM analise_teste AS at
                JOIN teste_padrao AS tp ON tp.id_teste_padrao = at.fk_teste_padrao
                WHERE at.fk_analise = :analise
                ORDER BY tp.ordem";
            $p_sql1 = $bdpdo->prepare($sql);
            $p_sql1->bindValue(":analise", $linha_amostra["fk_analise"]);
            $p_sql1->execute();

            $linha_testes = $p_sql1->fetch(PDO::FETCH_ASSOC);
            $j = 0;
            while ($linha_testes) {
                $sql = "SELECT ap.*, at.*, (0) AS valor FROM atributo_teste AS at
                JOIN atributo_padrao AS ap ON ap.id_atributo_padrao = at.fk_atributo_padrao 
                WHERE at.fk_analise_teste = " . $linha_testes["id_analise_teste"] .
                    " ORDER BY ap.ordem_atributo";
                $p_sql2 = $bdpdo->prepare($sql);
                $p_sql2->execute();

                $analise_testes[] = $linha_testes;
                $analise_testes[$j]["atributos"] = $p_sql2->fetchAll(PDO::FETCH_OBJ);
                $linha_testes = $p_sql1->fetch(PDO::FETCH_ASSOC);
                $j++;
            }

            $amostras[] = $linha_amostra;
            $amostras[$i]["analise_teste"] = $analise_testes;
            $linha_amostra = $p_sql->fetch(PDO::FETCH_ASSOC);
            $i++;
        }
        echo json_encode($amostras);
    } catch (Exception $e) {
        print "Erro ao executar a função de listarTodos" . $e->getMessage();
    }
}


function listarResultados()
{
    try {
        $sql = "SELECT * FROM amostra
        WHERE fk_analise = :analise";
        $bdpdo = BDPDO::getInstancia();
        $p_sql = $bdpdo->prepare($sql);
        $p_sql->bindValue(":analise", $_GET['listarResultados']);
        $p_sql->execute();
        $amostras = array();
        $linha_amostra = $p_sql->fetch(PDO::FETCH_ASSOC);
        $i = 0;
        while ($linha_amostra) {
            $analise_testes = array();
            $sql = "SELECT * FROM analise_teste AS at
                JOIN teste_padrao AS tp ON tp.id_teste_padrao = at.fk_teste_padrao
                WHERE at.fk_analise = :analise
                ORDER BY tp.ordem";
            $p_sql1 = $bdpdo->prepare($sql);
            $p_sql1->bindValue(":analise", $_GET['listarResultados']);
            $p_sql1->execute();

            $linha_testes = $p_sql1->fetch(PDO::FETCH_ASSOC);
            $j = 0;
            while ($linha_testes) {
                $fichas = array();
                $sql = "SELECT * FROM ficha AS f
                WHERE f.fk_analise = :analise";
                $p_sql2 = $bdpdo->prepare($sql);
                $p_sql2->bindValue(":analise", $_GET['listarResultados']);
                $p_sql2->execute();

                $linha_fichas = $p_sql2->fetch(PDO::FETCH_ASSOC);
                $k = 0;
                while ($linha_fichas) {
                    $ficha_respostas = array();
                    $sql = "SELECT ap.nome_atributo, fr.resposta, ap.ordem_atributo FROM ficha_resposta AS fr
                        JOIN atributo_teste at ON at.id_atributo_teste = fr.fk_atributo_teste
                        JOIN atributo_padrao AS ap ON ap.id_atributo_padrao = at.fk_atributo_padrao
                        JOIN analise_teste AS ant ON ant.id_analise_teste = at.fk_analise_teste
                        WHERE fr.fk_ficha = " . $linha_fichas["id_ficha"] .
                        " AND fr.fk_amostra = " . $linha_amostra["id_amostra"] .
                        " AND ant.fk_teste_padrao = " . $linha_testes["id_teste_padrao"];
                    $p_sql3 = $bdpdo->prepare($sql);
                    $p_sql3->execute();
                    $linha_respostas = $p_sql3->fetch(PDO::FETCH_ASSOC);
                    while ($linha_respostas) {
                        $ficha_respostas[] = $linha_respostas;
                        $linha_respostas = $p_sql3->fetch(PDO::FETCH_ASSOC);
                    }

                    $fichas[] = $linha_fichas;
                    $fichas[$k]["respostas"] = $ficha_respostas;
                    $linha_fichas = $p_sql2->fetch(PDO::FETCH_ASSOC);
                    $k++;
                }

                $analise_testes[] = $linha_testes;
                $analise_testes[$j]["fichas"] = $fichas;
                $linha_testes = $p_sql1->fetch(PDO::FETCH_ASSOC);
                $j++;
            }

            $amostras[] = $linha_amostra;
            $amostras[$i]["analise_teste"] = $analise_testes;
            $linha_amostra = $p_sql->fetch(PDO::FETCH_ASSOC);
            $i++;
        }
        echo json_encode($amostras);
    } catch (Exception $e) {
        print "Erro ao executar a função de listarTodos" . $e->getMessage();
    }
}


function listarGraficos()
{
    try {
        $sql = "SELECT at.id_analise_teste, tp.nome_teste FROM analise_teste AS at
        JOIN teste_padrao AS tp ON tp.id_teste_padrao = at.fk_teste_padrao        
        WHERE at.fk_analise = :analise
        ORDER BY tp.ordem";
        $bdpdo = BDPDO::getInstancia();
        $p_sql = $bdpdo->prepare($sql);
        $p_sql->bindValue(":analise", $_GET['listarGraficos']);
        $p_sql->execute();
        $analise_testes = array();
        $linha_analise_teste = $p_sql->fetch(PDO::FETCH_ASSOC);
        $i = 0;
        while ($linha_analise_teste) {
            $sql = "SELECT at.id_atributo_teste, ap.nome_atributo FROM atributo_teste AS at
            JOIN atributo_padrao AS ap ON ap.id_atributo_padrao = at.fk_atributo_padrao       
            WHERE at.fk_analise_teste = " . $linha_analise_teste["id_analise_teste"] .
                " ORDER BY ap.ordem_atributo";
            $bdpdo = BDPDO::getInstancia();
            $p_sql1 = $bdpdo->prepare($sql);
            $p_sql1->execute();
            $linha_atributo_teste = $p_sql1->fetch(PDO::FETCH_ASSOC);
            $atributo_testes = array();
            $j = 0;
            while ($linha_atributo_teste) {
                $sql = "SELECT * FROM amostra WHERE fk_analise = :analise";
                $bdpdo = BDPDO::getInstancia();
                $p_sql3 = $bdpdo->prepare($sql);
                $p_sql3->bindValue(":analise", $_GET['listarGraficos']);
                $p_sql3->execute();
                $linha_amostra = $p_sql3->fetch(PDO::FETCH_ASSOC);
                $amostras = array();
                $k = 0;
                while ($linha_amostra) {
                    $sql = "SELECT ficha_resposta.*, COUNT(resposta) AS count FROM ficha_resposta 
                    WHERE fk_atributo_teste = " . $linha_atributo_teste["id_atributo_teste"] .
                        " AND FK_amostra = " . $linha_amostra["id_amostra"] .
                        " GROUP BY resposta";
                    $bdpdo = BDPDO::getInstancia();
                    $p_sql2 = $bdpdo->prepare($sql);
                    $p_sql2->execute();

                    $amostras[] = $linha_amostra;
                    $amostras[$k]["respostas"] = $p_sql2->fetchAll(PDO::FETCH_OBJ);
                    $linha_amostra = $p_sql3->fetch(PDO::FETCH_ASSOC);
                    $k++;
                }



                $atributo_testes[] = $linha_atributo_teste;
                $atributo_testes[$j]["amostras"] = $amostras;
                $linha_atributo_teste = $p_sql1->fetch(PDO::FETCH_ASSOC);
                $j++;
            }

            $analise_testes[] = $linha_analise_teste;
            $analise_testes[$i]["atributos"] = $atributo_testes;
            $linha_analise_teste = $p_sql->fetch(PDO::FETCH_ASSOC);
            $i++;
        }
        echo json_encode($analise_testes);
    } catch (Exception $e) {
        print "Erro ao executar a função de listarTodos" . $e->getMessage();
    }
}