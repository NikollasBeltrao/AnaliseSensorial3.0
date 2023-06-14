<?php
require_once './conexao.php';
$method = $_SERVER['REQUEST_METHOD'];

switch ($method) {
    case 'PUT':

        break;
    case 'POST':
        if (isset($_POST['changeStatus'])) {
            changeStatus();
        } else if (isset($_POST['cadastrarAnalise'])) {
            cadastrarAnalise();
        } else if (isset($_POST['criarAmostra'])) {
            criarAmostra();
        } else if (isset($_POST['salvarRespostas'])) {
            salvarRespostas();
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

function salvarRespostas()
{
    try {
        $ficha = json_decode($_POST['ficha']);
        $bdpdo = BDPDO::getInstancia();
        $query = $bdpdo->prepare("INSERT INTO ficha (nome_aluno, genero, faixa_etaria, frequencia_consumo, fk_analise) 
        VALUES (?, ?, ?, ?, ?)");
        $query->bindValue(1, $ficha->nome_aluno);
        $query->bindValue(2, $ficha->genero);
        $query->bindValue(3, $ficha->faixa_etaria);
        $query->bindValue(4, $ficha->frequencia_consumo);
        $query->bindValue(5, $ficha->fk_analise);
        $query->execute();
        $id_ficha = $bdpdo->lastInsertId();
        foreach (json_decode($_POST['amostras']) as $amostra) {
            foreach ($amostra->analise_teste as $teste) {
                if ($teste->id_teste_padrao != 4 && $teste->id_teste_padrao != 3) {
                    foreach ($teste->atributos as $atributo) {
                        $bdpdo = BDPDO::getInstancia();
                        $query = $bdpdo->prepare("INSERT INTO ficha_resposta (fk_atributo_teste, fk_ficha, fk_amostra, resposta)
                        VALUES (?, ?, ?, ?)");
                        $query->bindValue(1, $atributo->id_atributo_teste);
                        $query->bindValue(2, $id_ficha);
                        $query->bindValue(3, $amostra->id_amostra);
                        $query->bindValue(4, $atributo->valor);
                        $query->execute();
                    }
                }
            }
        }
        foreach (json_decode($_POST['testeIsolado']) as $teste) {
            if ($teste->id_teste_padrao == 4 || $teste->id_teste_padrao == 3) {
                foreach ($teste->atributos as $atributo) {
                    $bdpdo = BDPDO::getInstancia();
                    $query = $bdpdo->prepare("INSERT INTO ficha_resposta (fk_atributo_teste, fk_ficha, resposta)
                        VALUES (?, ?, ?)");
                    $query->bindValue(1, $atributo->id_atributo_teste);
                    $query->bindValue(2, $id_ficha);
                    $query->bindValue(3, $atributo->valor);
                    $query->execute();
                }
            }
        }
    } catch (Exception $e) {
        echo ('{"err": "' . $e . '"}');
    }
}

function criarAmostra()
{
    $criado = '';
    if ($_POST['img'] != '') {
        $criado = uploadImg($_POST['img']);
    }
    try {
        if ($criado != false) {
            $bdpdo = BDPDO::getInstancia();
            $query = $bdpdo->prepare("INSERT INTO amostra (fk_analise, numero_amostra, ingredientes, img_amostra) 
        VALUES (:analise, :numero, :desc, :img)");
            $query->bindValue(":analise", $_POST['analise']);
            $query->bindValue(":numero", $_POST['numero']);
            $query->bindValue(":desc", $_POST['desc']);
            $query->bindValue(":img", $criado);
            $query->execute();
        } else {
            echo ('{"err": "Não foi possivel salvar a imagem"}');
        }
    } catch (Exception $e) {
        echo ('{"err": "' . $e . '"}');
    }
}

function uploadImg($img)
{
    define('UPLOAD_DIR', 'imagens/');
    $img = str_replace('data:image/jpeg;base64,', '', $img);
    $img = str_replace(' ', '+', $img);
    $data = base64_decode($img);
    $file = UPLOAD_DIR . uniqid() . '.png';
    $sucess = file_put_contents($file, $data);
    if ($sucess == false) {
        return $sucess;
    } else {
        return $file;
    }
}

function cadastrarAnalise()
{
    try {
        $Rand = '';
        do {
            $Rand = str_pad(dechex(Rand(0x000000, 0xFFFFFF)), 6, 0, STR_PAD_LEFT);
            $sql = "SELECT COUNT(*) as total FROM analise WHERE codigo = '" . $Rand . "'";
            $bdpdo = BDPDO::getInstancia();
            $p_sql = $bdpdo->query($sql);
        } while ($p_sql->fetchObject()->total != 0);

        $sql = "INSERT INTO analise (nome_alimento, fk_usuario, instrucoes, codigo) 
                VALUES (?, ?, ?, ?)";
        $bdpdo = BDPDO::getInstancia();
        $p_sql = $bdpdo->prepare($sql);
        $p_sql->bindValue(1, $_POST['nome_alimento']);
        $p_sql->bindValue(2, $_POST['fk_usuario']);
        $p_sql->bindValue(3, $_POST['instrucoes']);
        $p_sql->bindValue(4, $Rand);
        $p_sql->execute();

        $id_analise = $bdpdo->lastInsertId();

        foreach (json_decode($_POST['analise_testes']) as $teste) {
            $sql = "INSERT INTO analise_teste(fk_analise, fk_teste_padrao, descricao_analise_teste) 
            VALUES (?, ?, ?)";
            $bdpdo = BDPDO::getInstancia();
            $p_sql = $bdpdo->prepare($sql);
            $p_sql->bindValue(1, $id_analise);
            $p_sql->bindValue(2, $teste->fk_teste_padrao);
            $p_sql->bindValue(3, $teste->descricao);
            $p_sql->execute();

            $id_analise_teste = $bdpdo->lastInsertId();

            foreach ($teste->atributos as $atributo) {
                $sql = "INSERT INTO atributo_teste (fk_analise_teste, fk_atributo_padrao) VALUES (?, ?)";
                $bdpdo = BDPDO::getInstancia();
                $p_sql = $bdpdo->prepare($sql);
                $p_sql->bindValue(1, $id_analise_teste);
                $p_sql->bindValue(2, $atributo->value);
                $p_sql->execute();
            }
        }
        echo '{"id_analise": ' . $id_analise . '}';
    } catch (Exception $e) {
        print "Erro ao executar a função de listarTodos" . $e->getMessage();
    }
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
                WHERE at.fk_analise = :analise AND tp.id_teste_padrao NOT IN (3, 4)
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
                        " AND ant.fk_teste_padrao = " . $linha_testes["id_teste_padrao"] .
                        " ORDER BY ap.ordem_atributo";
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
        /////////
        $testesIsolados = array();
        $sql = "SELECT * FROM analise_teste AS at
                JOIN teste_padrao AS tp ON tp.id_teste_padrao = at.fk_teste_padrao
                WHERE at.fk_analise = :analise AND tp.id_teste_padrao IN (3, 4)
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
                    " AND ant.fk_teste_padrao = " . $linha_testes["id_teste_padrao"] .
                    " ORDER BY ap.ordem_atributo";
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

            $testesIsolados[] = $linha_testes;
            $testesIsolados[$j]["fichas"] = $fichas;
            $linha_testes = $p_sql1->fetch(PDO::FETCH_ASSOC);
            $j++;
        }
        ///
        echo json_encode([$amostras, $testesIsolados]);
    } catch (Exception $e) {
        print "Erro ao executar a função de listarTodos" . $e->getMessage();
    }
}


function listarGraficos()
{
    try {
        $sql = "SELECT tp.id_teste_padrao, at.id_analise_teste, tp.nome_teste FROM analise_teste AS at
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
            $sql = "SELECT at.id_atributo_teste, ap.nome_atributo, ap.id_atributo_padrao FROM atributo_teste AS at
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
                if ($linha_analise_teste["id_teste_padrao"] != 3 && $linha_analise_teste["id_teste_padrao"] != 4) {

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
                            " GROUP BY resposta
                            ORDER BY fk_amostra";
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

                } else {
                    $sql = "SELECT ficha_resposta.*, COUNT(resposta) AS count FROM ficha_resposta 
                            WHERE fk_atributo_teste = " . $linha_atributo_teste["id_atributo_teste"] .
                        " GROUP BY resposta";
                    $bdpdo = BDPDO::getInstancia();
                    $p_sql3 = $bdpdo->prepare($sql);
                    $p_sql3->execute();

                    $atributo_testes[] = $linha_atributo_teste;
                    $atributo_testes[$j]["respostas"] = $p_sql3->fetchAll(PDO::FETCH_OBJ);
                    $linha_atributo_teste = $p_sql1->fetch(PDO::FETCH_ASSOC);
                    $j++;
                }

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