<?php
    session_start();

    if((!isset($_POST['login'])) || (!isset($_POST['password']))) {
        header('Location: index.php?result=13');
        exit();
    }

    try
    {
        require_once 'connection-config.php';

        $login = $_POST['login'];
        $password = $_POST['password'];

        $wynik = $database->prepare('SELECT * FROM uzytkownicy WHERE email like :login AND haslo like :haslo');
        $wynik->bindValue('login', $login, PDO::PARAM_STR);
        $wynik->bindValue('haslo', $password, PDO::PARAM_STR);
        $wynik->execute();

        $ile_wynikow = $wynik->rowCount();
        if($ile_wynikow > 0) 
        {
            $user = $wynik->fetch();
            $_SESSION['id'] = $user['id'];
            $_SESSION['nick'] = $user['nick'];
            $_SESSION['email'] = $user['email'];
            $_SESSION['typ'] = $user['typ'];
            $_SESSION['klucz_dostepu'] = $user['klucz_dostepu'];
            $_SESSION['kod_przywracania'] = $user['kod_przywracania'];
            $_SESSION['data_dodania'] = $user['data_dodania'];

            if($_SESSION['klucz_dostepu']=='Aktywny') {
                $_SESSION['czy_zalogowany'] = true;
                header('Location: witryna_po_autoryzacji.php');
                exit();
            }
            else {
                header('Location: index.php?result=7');
                exit();
            }
        }
        else 
        {
            header('Location: index.php?result=1');
        }
    }
    catch(PDOException $error)
    {
        echo '
        <div class="alert alert-danger" role="alert">
          Wystąpił błąd! Przepraszamy za utrudnienia.
        </div>';
    }
?>