<!DOCTYPE HTML>
<html>
<head>
    <meta charset="utf-8">
    <title>RecipeApp [Przywracanie hasła]</title>
    <link rel="stylesheet" href="css/bootstrap.min.css">
    <link rel="stylesheet" href="css/recovery_styles.css">
</head>
<body>
    <nav class="navbar navbar-expand-md navbar-light bg-light">
        <a class="navbar-brand" href="index.php"><img src="img/favicon.png" alt="logo" width="65"></a>  
        <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarSupportedContent" aria-controls="navbarSupportedContent" aria-expanded="falsaria-label="Toggle navigation">
          <span class="navbar-toggler-icon"></span>
        </button>
        <div class="collapse navbar-collapse" id="navbarSupportedContent">
          <ul class="navbar-nav ml-auto navbar-items">
            <li class="nav-item" data-toggle="collapse" data-target=".navbar-collapse.show">
              <a class="nav-link" href="index.php">Home</a>
            </li>
            <li class="nav-item" data-toggle="collapse" data-target=".navbar-collapse.show">
                <a class="nav-link" href="index.php#recipes-ref">Przepisy</a>
            </li>
            <li class="nav-item" data-toggle="collapse" data-target=".navbar-collapse.show">
              <a class="nav-link" href="rejestracja.php">Rejestracja</a>
            </li>
            <li class="nav-item" data-toggle="collapse" data-target=".navbar-collapse.show">
                <a class="nav-link" href="index.php#login-ref">Logowanie</a>
            </li>
          </ul>
        </div>
    </nav>
    <?php 
        try
        {
            session_start();

            require_once 'connection-config.php';
            require_once 'result.php';

            if(isset($_POST['wyslij_mail'])) 
            {
                $email = $_POST['login'];

                $zapytanie = $database -> prepare('SELECT * FROM `uzytkownicy` WHERE `email` = :email');
                $zapytanie -> bindValue('email', $email, PDO::PARAM_STR);
                $zapytanie -> execute();
                $wynik = $zapytanie -> fetch();
                $ile_rekordow = $zapytanie->rowCount();

                if($ile_rekordow > 0) {
                    $kod_przywracania = $wynik['kod_przywracania'];

                    $szablon_email = "email_recovery_template.html";
                    $wiadomosc = file_get_contents($szablon_email);
                    $wiadomosc = str_replace("[email]", $email, $wiadomosc);
                    $wiadomosc = str_replace("[key]", $kod_przywracania, $wiadomosc);

                    $naglowki = 'From: aktywacja@recipeapp.cba.pl'."\r\n".
                                'Reply-To: aktywacja@recipeapp.cba.pl'."\r\n".
                                'Content-type: text/html; charset=utf-8'."\r\n";
                    mail($email, "RecipeApp - Przywracanie hasła ".$email, $wiadomosc, $naglowki);

                    header('Location: index.php?result=10');
                    exit();
                }
                else {
                    header('Location: przywracanie_hasla.php?result=9');
                    exit();
                }
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
    <section class="recovery-panel">
        <div class="recovery-card">
            <h3>Przywracanie hasła</h3>
            <span>Aby zresetować hasło wymagane jest podanie e-maila, na które zostało zarejestrowane konto. <br>Na podany e-mail zostanie wysłana wiadomość z dalszymi instrukcjami.</span>
            <form method="post">
              <input type="email" name="login" placeholder="Podaj e-mail">
              <input type="submit" value="Wyślij" name="wyslij_mail">
            </form>
        </div>
    </section>

    <footer class="footer-panel">
        Wszelkie prawa zastrzeżone &copy RecipeApp 2019
    </footer>

    <script src="js/jquery.min.js"></script>
    <script src="js/popper.min.js"></script>
    <script src="js/bootstrap.min.js"></script>
</body>
</html>

