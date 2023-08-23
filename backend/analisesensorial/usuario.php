<?php
require_once './conexao.php';
$method = $_SERVER['REQUEST_METHOD'];

switch ($method) {
    case 'PUT':

        break;
    case 'POST':
        if (isset($_POST['searchUser'])) {
            searchUser();
        } else if (isset($_POST['createUser'])) {
            createUser();
        } else if (isset($_POST['alterUser'])) {
            alterUser();
        }
        break;
    case 'GET':
        if (isset($_GET['login'])) {
            login();
        } elseif (isset($_GET['getById'])) {
            getById();
        } elseif (isset($_GET['getAll'])) {
            getAll();
        }

        break;

    case 'DELETE':

        break;
    default:
        echo '{"error": "Método inválido"}';
        break;
}


function login()
{
    try {
        $sql = "SELECT * FROM usuario WHERE login = :login";
        $bdpdo = BDPDO::getInstancia();
        $p_sql = $bdpdo->prepare($sql);
        $p_sql->bindValue(":login", $_GET["login"]);
        $p_sql->execute();
        echo json_encode($p_sql->fetchObject());
    } catch (Exception $e) {
        echo json_encode('{"err": "' . $e . '"}');
    }
}

function getById()
{
    try {
        $Conexao = BDPDO::getInstancia();
        $query = $Conexao->prepare("SELECT * FROM usuario WHERE id_usuario = :id");
        $query->bindValue(":id", $_GET["getById"]);
        $query->execute();
        echo json_encode($query->fetchObject());
    } catch (Exception $e) {
        echo json_encode('{"err": "erro"}');
    }
}
function getAll()
{
    try {
        $Conexao = BDPDO::getInstancia();
        $query = $Conexao->prepare("SELECT * FROM usuario");
        $query->execute();
        echo json_encode($query->fetchAll(PDO::FETCH_OBJ));
    } catch (Exception $e) {
        echo json_encode('{"err": "erro"}');
    }
}

function searchUser()
{
    try {
        $Conexao = BDPDO::getInstancia();
        $query = $Conexao->prepare("SELECT * FROM usuario WHERE nome_usuario LIKE '%:nome%' OR login LIKE '%:login%'");
        $query->bindValue(":nome", $_POST['searchUser']);
        $query->bindValue(":login", $_POST['matricula']);
        $query->execute();
        echo json_encode($query->fetchAll(PDO::FETCH_OBJ));
    } catch (Exception $e) {
        echo json_encode('{"err": "erro"}');

    }
}
function createUser()
{
    try {
        $Conexao = BDPDO::getInstancia();
        $query = $Conexao->prepare("INSERT INTO usuario (nome_usuario, login, senha, permissoes) VALUES(:nome, :login, :senha, :permissoes)");
        $query->bindValue(":nome", $_POST['nome']);
        $query->bindValue(":login", $_POST['matricula']);
        $query->bindValue(":senha", $_POST['senha']);
        $query->bindValue(":permissoes", $_POST['permissoes']);
        $query->execute();
        echo json_encode('{"response": "ok"}');
    } catch (Exception $e) {
        echo json_encode('{"err": "erro"}');

    }
}
function alterUser()
{
    try {
        $Conexao = BDPDO::getInstancia();
        $query = $Conexao->prepare("UPDATE usuario SET nome_usuario=:nome, login=:login,
              senha=:senha WHERE id_user=:id");
        $query->bindValue(":nome", $_POST['nome']);
        $query->bindValue(":login", $_POST['matricula']);
        $query->bindValue(":senha", $_POST['senha']);
        $query->bindValue(":id", $_POST['id']);
        $query->execute();
        echo json_encode('{"response": "ok"}');
    } catch (Exception $e) {
        echo json_encode('{"err": "erro"}');

    }
}