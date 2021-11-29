<?php 
    if(isset($_POST['zatwierdzanie_przepisu']))
    {
        require_once 'connection-config.php';
        $id = $_POST['id_zatwierdzenia'];
        
        $zapytanie = $database -> exec("UPDATE przepisy SET `czy_aktywne`=1 WHERE `id` = '$id'");

        $zapytanie = $database->prepare('SELECT * FROM przepisy WHERE id=:id');
        $zapytanie->bindValue('id', $id, PDO::PARAM_INT);
        $zapytanie->execute();
        $user = $zapytanie -> fetch();

        $id_uzytkownika = $user['autor'];

        $zapytanie2 = $database->prepare('SELECT * FROM uzytkownicy WHERE id=:id_uzytkownika');
        $zapytanie2->bindValue('id_uzytkownika', $id_uzytkownika, PDO::PARAM_INT);
        $zapytanie2->execute();
        $user2 = $zapytanie2->fetch();
        
        $email = $user2['email'];

        $szablon_email = "email_recipe_template.html";
        $wiadomosc = file_get_contents($szablon_email);
        $wiadomosc = str_replace("[email]", $email, $wiadomosc);
        $naglowki = 'From: aktywacja@recipeapp.cba.pl'."\r\n".
                    'Reply-To: aktywacja@recipeapp.cba.pl'."\r\n".
                    'Content-type: text/html; charset=utf-8'."\r\n";
        mail($email, "RecipeApp - Zatwierdzenie przepisu ".$email, $wiadomosc, $naglowki);
        header('Location: witryna_po_autoryzacji.php?result=21');
        exit();
    }
?>