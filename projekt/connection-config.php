<?php
    $host = "localhost";
    $database_name = "recipeapp";
    $username = "root";
    $password = "";

    $database = new PDO("mysql:host=$host;dbname=$database_name;charset=utf8", $username, $password);
?>