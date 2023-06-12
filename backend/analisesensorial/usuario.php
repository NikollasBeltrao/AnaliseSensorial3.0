<?php
require_once './conexao.php';
$method = $_SERVER['REQUEST_METHOD'];

switch ($method) {
    case 'PUT':

        break;
    case 'POST':

        break;
    case 'GET':
        if (isset($_GET['login'])) {
            login();
        }
        if (isset($_GET['getById'])) {
            getById();
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
        $sql = "SELECT * FROM usuario WHERE id_usuario = :id";
        $bdpdo = BDPDO::getInstancia();
        $p_sql = $bdpdo->prepare($sql);
        $p_sql->bindValue(":id", $_GET["getById"]);
        $p_sql->execute();
        echo json_encode($p_sql->fetchObject());
    } catch (Exception $e) {
        echo json_encode('{"err": "' . $e . '"}');
    }
}
