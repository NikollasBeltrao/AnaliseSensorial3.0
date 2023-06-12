<?php
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: GET, POST, PUT, DELETE, FILES");
header("Access-Control-Allow-Headers: Content-Type, Access-Control-Allow-Headers, X-Requested-With");
date_default_timezone_set('America/Sao_Paulo');
class BDPDO
{
    public static $instancia;
    private function __construct()
    {
    }
    public static function getInstancia()
    {
        if (!isset(self::$instancia)) {
            self::$instancia = new PDO('mysql:host=localhost;
            dbname=analisesensorial', 'root', '', array(PDO::MYSQL_ATTR_INIT_COMMAND => "SET NAMES utf8"));
            self::$instancia->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
            self::$instancia->setAttribute(PDO::ATTR_ORACLE_NULLS, PDO::NULL_EMPTY_STRING);
        }
        return self::$instancia;
    }

}