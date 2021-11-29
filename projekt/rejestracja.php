<?php 
    session_start();

    if(isset($_SESSION['czy_zalogowany'])) {
        header('Location: witryna_po_autoryzacji.php');
        exit();
    }
?>

<!DOCTYPE HTML>
<html>
  <head>
      <meta charset="utf-8">
      <title>RecipeApp [Rejestracja]</title>
      <link rel="shortcut icon" href="img/favicon.png">
      <link rel="stylesheet" href="css/bootstrap.min.css">
      <link rel="stylesheet" href="css/register_styles.css">
      <link href="https://fonts.googleapis.com/css?family=McLaren|Patrick+Hand|Ubuntu+Mono&display=swap" rel="stylesheet">
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
            <li class="nav-item active" data-toggle="collapse" data-target=".navbar-collapse.show">
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
        require_once 'result.php';
        require_once 'connection-config.php';

        if(isset($_GET['activate'])) {
            $email_key = $_GET['activate'];

            $zapytanie = $database->prepare("SELECT * FROM uzytkownicy WHERE klucz_dostepu like '$email_key'");
            $zapytanie -> execute();
            $wynik = $zapytanie -> fetch();
            $ile_rekordow = $zapytanie->rowCount();

            if($ile_rekordow > 0) {
                $zapytanie = $database -> exec("UPDATE uzytkownicy SET klucz_dostepu='Aktywny' WHERE klucz_dostepu='$email_key'");
                header('Location: index.php?result=6');
                exit();
            } else {
                header('Location: index.php?result=5');
                exit();
            }
        }

        if(isset($_POST['reg_nick'])) 
        {
            $nickname = $_POST['reg_nick'];
            $email = $_POST['reg_email'];
            $password = $_POST['reg_password'];
            $con_password = $_POST['con_reg_password'];
            $account_type = "Standardowy";
            $access_key = md5(mt_rand()); //klucz autoryzacji email
            $recovery_key = md5(mt_rand()); //klucz przywracania hasla

            $poprawna_walidacja = true;

            $zapytanie = $database->prepare("SELECT * FROM uzytkownicy WHERE nick like '$nickname'");
            $zapytanie -> execute();
            $wynik = $zapytanie -> fetch();
            $ile_rekordow = $zapytanie->rowCount();

            if($ile_rekordow > 0)
            {
                $poprawna_walidacja = false;
                $_SESSION['nick_error'] = "Konto o podanym nicku już istnieje!";
            }

            if((strlen($nickname)<3) || (strlen($nickname)>20)) {
                $poprawna_walidacja = false;
                $_SESSION['nick_error'] = "Długość nicku powinna wynosić od 3 do 20 znaków!";
                //header('Location: rejestracja.php?result=14');
            }

            if (!ctype_alnum($nickname)) {
                $poprawna_walidacja = false;
                $_SESSION['nick_error'] = "Nick powinien składać się wyłącznie z liter oraz liczb!";
            }

            $email_after = filter_var($email, FILTER_SANITIZE_EMAIL);
            if ((filter_var($email_after, FILTER_VALIDATE_EMAIL)==false) || ($email_after != $email)) {
                $poprawna_walidacja = false;
                $_SESSION['email_error'] = "Podano nieprawidłowy e-mail!";
            }

            if ((strlen($password)<8) || (strlen($password)>20)) {
                $poprawna_walidacja = false;
                $_SESSION['password_error'] = "Długość hasła powinna wynosić od 8 do 20 znaków!";
            }

            if($password != $con_password) {
                $poprawna_walidacja = false;
                $_SESSION['password_error'] = "Podane hasła się różnią!";
            }

            $_SESSION['nick_temp'] = $nickname;
            $_SESSION['email_temp'] = $email;
            $_SESSION['pass1_temp'] = $password;
            $_SESSION['pass2_temp'] = $con_password;

            if($poprawna_walidacja) 
            {
                $zapytanie = $database->prepare('SELECT * FROM uzytkownicy order by id desc limit 1');
                $zapytanie -> execute();
                $nowe_id = $zapytanie -> fetch();
                $id = $nowe_id['id']+1;
                
                $zapytanie = $database->prepare("SELECT * FROM uzytkownicy WHERE nick like '$nickname' or email like '$email'");
                $zapytanie -> execute();
                $wynik = $zapytanie -> fetch();
                $ile_rekordow = $zapytanie->rowCount();

                if(($ile_rekordow) == 0) {
                    $zapytanie = $database->prepare('INSERT INTO `uzytkownicy` (`id`,`nick`,`email`,`haslo`, `typ`, `klucz_dostepu`, `kod_przywracania`) VALUES (:id, :nickname, :email, :password, :typ, :klucz, :kod)');
                    $zapytanie->bindValue('id', $id, PDO::PARAM_INT);
                    $zapytanie->bindValue('nickname', $nickname, PDO::PARAM_STR);
                    $zapytanie->bindValue('email', $email_after, PDO::PARAM_STR);
                    $zapytanie->bindValue('password', $password, PDO::PARAM_STR);
                    $zapytanie->bindValue('typ', $account_type, PDO::PARAM_STR);
                    $zapytanie->bindValue('klucz', $access_key, PDO::PARAM_STR);
                    $zapytanie->bindValue('kod', $recovery_key, PDO::PARAM_STR);
                    $zapytanie->execute();

                    $email_template = "email_activation_template.html";
                    $wiadomosc = file_get_contents($email_template);
                    $wiadomosc = str_replace("[email]", $email, $wiadomosc);
                    $wiadomosc = str_replace("[key]", $access_key, $wiadomosc);
                    $wiadomosc = str_replace("[url]", "http://".$_SERVER['HTTP_HOST'].$_SERVER['PHP_SELF'], $wiadomosc);

                    $naglowki = 'From: aktywacja@recipeapp.cba.pl'."\r\n".
                                'Reply-To: aktywacja@recipeapp.cba.pl'."\r\n".
                                'Content-type: text/html; charset=utf-8'."\r\n";

                    mail($email, "RecipeApp - Aktywacja konta ".$email, $wiadomosc, $naglowki);

                    header('Location: index.php?result=4');
                } else {
                    header('Location: rejestracja.php?result=2');
                }
            } 
        }
        ?>
            <section class="register-panel">
                <div class="register-card">
                    <h2>Rejestracja</h2>
                    <form method="post" novalidate>
                        <div class="form-group">
                            <label for="pseudonim">Nick</label>
                            <input type="text" class="form-control <?php if(isset($_SESSION['nick_error'])) { echo 'is-invalid'; } else if (isset($_SESSION['nick_temp'])) { echo 'is-valid'; } ?>" id="pseudonim" placeholder="Podaj pseudonim" name="reg_nick" required value="<?php if(isset($_SESSION['nick_temp'])) {echo $_SESSION['nick_temp']; unset($_SESSION['nick_temp']);} ?>">
                            <small id="emailHelp" class="form-text text-muted nick-info">Będzie on widoczny dla innych użytkowników.</small>
                            <div class="valid-feedback">W porządku!</div>
                            <div class="invalid-feedback"><?php if(isset($_SESSION['nick_error'])) { echo $_SESSION['nick_error']; unset($_SESSION['nick_error']); } ?></div>
                        </div>
                        <div class="form-group">
                            <label for="email">E-mail</label>
                            <input type="email" class="form-control <?php if(isset($_SESSION['email_error'])) { echo 'is-invalid'; } else if (isset($_SESSION['email_temp'])) { echo 'is-valid'; } ?>" id="email" placeholder="Podaj swój e-mail" name="reg_email" required value="<?php if(isset($_SESSION['email_temp'])) {echo $_SESSION['email_temp']; unset($_SESSION['email_temp']);} ?>">
                            <div class="valid-feedback">W porządku!</div>
                            <div class="invalid-feedback"><?php if(isset($_SESSION['email_error'])) { echo $_SESSION['email_error']; unset($_SESSION['email_error']); } ?></div>
                        </div>
                        <div class="form-group">
                            <label for="haslo">Hasło</label>
                            <input type="password" class="form-control <?php if(isset($_SESSION['password_error'])) { echo 'is-invalid'; } else if (isset($_SESSION['password_temp'])) { echo 'is-valid'; } ?>" id="haslo" placeholder="Podaj nowe hasło" name="reg_password" required value="<?php if(isset($_SESSION['pass1_temp'])) {echo $_SESSION['pass1_temp']; unset($_SESSION['pass1_temp']);} ?>">
                            <div class="valid-feedback">W porządku!</div>
                            <div class="invalid-feedback"><?php if(isset($_SESSION['password_error'])) { echo $_SESSION['password_error']; } ?></div>
                        </div>
                        <div class="form-group">
                            <label for="haslo">Potwierdź hasło</label>
                            <input type="password" class="form-control <?php if(isset($_SESSION['password_error'])) { echo 'is-invalid'; } else if (isset($_SESSION['password_temp'])) { echo 'is-valid'; } ?>" id="haslo" placeholder="Powtórz swoje hasło" name="con_reg_password" required value="<?php if(isset($_SESSION['pass2_temp'])) {echo $_SESSION['pass2_temp']; unset($_SESSION['pass2_temp']);} ?>">
                            <div class="valid-feedback">W porządku!</div>
                            <div class="invalid-feedback"><?php if(isset($_SESSION['password_error'])) { echo $_SESSION['password_error']; unset($_SESSION['password_error']); } ?></div>
                        </div>
                        <div class="form-buttons">
                            <div class="col-6" style="float: left; padding: 0 1px 0 0;"><a href="index.php"><button type="button" class="btn btn-secondary" data-dismiss="modal">Anuluj</button></a></div>
                            <div class="col-6" style="float: left; padding: 0 0 0 1px;"><button type="submit" class="btn btn-primary">Zarejestruj się</button></div>
                        </div>
                    </form>
                </div>
            </section>

            <footer class="footer-panel">
                Wszelkie prawa zastrzeżone &copy RecipeApp 2019
            </footer>
        <?php
            if(isset($_SESSION['nick_error'])) unset($_SESSION['nick_error']);
            if(isset($_SESSION['email_error'])) unset($_SESSION['email_error']);
            if(isset($_SESSION['password_error'])) unset($_SESSION['password_error']);

            if (isset($_SESSION['nick_temp'])) unset($_SESSION['nick_temp']);
            if (isset($_SESSION['email_temp'])) unset($_SESSION['email_temp']);
            if (isset($_SESSION['pass1_temp'])) unset($_SESSION['pass1_temp']);
            if (isset($_SESSION['pass2_temp'])) unset($_SESSION['pass2_temp']);
    }
    catch(PDOException $error)
    {
        echo '
        <div class="alert alert-danger" role="alert">
          Wystąpił błąd! Przepraszamy za utrudnienia.
        </div>';
    }
?>

    <script src="js/jquery.min.js"></script>
    <script src="js/popper.min.js"></script>
    <script src="js/bootstrap.min.js"></script>
    
    <script>
        (function() {
          'use strict';
          window.addEventListener('load', function() {
            // Fetch all the forms we want to apply custom Bootstrap validation styles to
            var forms = document.getElementsByClassName('needs-validation');
            // Loop over them and prevent submission
            var validation = Array.prototype.filter.call(forms, function(form) {
              form.addEventListener('submit', function(event) {
                if (form.checkValidity() === false) {
                  event.preventDefault();
                  event.stopPropagation();
                }
                form.classList.add('was-validated');
              }, false);
            });
          }, false);
        })();
    </script>

</body>
</html>

