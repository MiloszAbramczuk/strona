<?php 
  session_start();

  if((isset($_SESSION['czy_zalogowany'])) && ($_SESSION['czy_zalogowany']==true)) {
    header('Location: witryna_po_autoryzacji.php');
    exit();
  }
?>

<!DOCTYPE HTML>
<html>
<head>
    <meta charset="utf-8">
    <title>RecipeApp [Reset hasła]</title>

    <link rel="stylesheet" href="css/bootstrap.min.css">
    <link rel="stylesheet" href="css/recovery_styles.css">
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
              <a class="nav-link" href="#recipes-ref">Przepisy</a>
          </li>
          <li class="nav-item" data-toggle="collapse" data-target=".navbar-collapse.show">
              <a class="nav-link" href="rejestracja.php">Rejestracja</a>
          </li>
          <li class="nav-item" data-toggle="collapse" data-target=".navbar-collapse.show">
              <a class="nav-link" href="#login-ref">Logowanie</a>
          </li>
        </ul>
      </div>
    </nav>

    <?php 
        try
        {
            require_once 'connection-config.php';
            require_once 'result.php';
            
            if(isset($_POST['zmien_haslo'])) {
                $email = $_POST['login'];
                $new_password = $_POST['password'];
                $re_password = $_POST['re_password'];

                $poprawna_walidacja = true;

                if ((strlen($new_password)<8) || (strlen($new_password)>20)) {
                    $poprawna_walidacja = false;
                    $_SESSION['password_error'] = "Długość hasła powinna wynosić od 8 do 20 znaków!";
                }

                if($new_password != $re_password) {
                    $poprawna_walidacja = false;
                    $_SESSION['password_error'] = "Podane hasła się różnią!";
                }

                if($poprawna_walidacja) 
                {
                    $zapytanie = $database -> exec("UPDATE uzytkownicy SET haslo='$new_password' WHERE email='$email'");
                    header('Location: index.php?result=11');
                }
            }

            if(isset($_GET['recovery'])) 
            {
              $recovery_key = $_GET['recovery'];
        
              $zapytanie = $database->prepare("SELECT * FROM uzytkownicy WHERE kod_przywracania like :key");
              $zapytanie -> bindValue('key', $recovery_key, PDO::PARAM_STR);
              $zapytanie -> execute();
              $wynik = $zapytanie -> fetch();
              $ile_rekordow = $zapytanie->rowCount();
        
              if($ile_rekordow > 0) { ?>
                <div class="content">
                    <div class="container">
                        <h3>Podaj nowe hasło do konta<br><b> <?php echo $wynik['email']; ?></b></h3>
                        <form method="post">
                          <input type="hidden" name="login" placeholder="Email" value="<?php echo $wynik['email']; ?>">
                          <label for="haslo1">Nowe hasło</label>
                          <input type="password" name="password" placeholder="Podaj nowe hasło" id="haslo1" required>
                          <label for="haslo2">Potwierdź hasło</label>
                          <input type="password" name="re_password" placeholder="Powtórz nowe hasło" id="haslo2" required>
                          <input type="submit" class="btn btn-success" value="Zapisz" name="zmien_haslo">
                        </form>
                    </div> 
                </div>
                <?php 
                    if(isset($_SESSION['password_error'])) { echo $_SESSION['password_error']; unset($_SESSION['password_error']); } 
              } else {
                  header('Location: index.php?result=12');
                  exit();
              }
            }
            if(isset($_SESSION['password_error'])) unset($_SESSION['password_error']);
        }
        catch(PDOException $error)
        {
            echo '
            <div class="alert alert-danger" role="alert">
              Wystąpił błąd! Przepraszamy za utrudnienia.
            </div>';
        }
    ?> 

    <footer class="footer-panel">
      Wszelkie prawa zastrzeżone &copy RecipeApp 2019
    </footer>

    <script src="js/jquery.min.js"></script>
    <script src="js/popper.min.js"></script>
    <script src="js/bootstrap.min.js"></script>
</body>
</html>

