<?php 
    session_start();

    if(!isset($_SESSION['czy_zalogowany'])) {
        header('Location: index.php');
        exit();
    }
?>

<!DOCTYPE HTML>
<html>
<head>
    <meta charset="utf-8">
    <title>RecipeApp [Panel administracyjny]</title>
    <link rel="shortcut icon" href="img/favicon.png">
    <link rel="stylesheet" href="css/bootstrap.min.css">
    <link rel="stylesheet" href="css/panel_administracyjny.css">
    
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
              <a class="nav-link" href="witryna_po_autoryzacji.php">Home</a>
            </li>
            <li class="nav-item" data-toggle="collapse" data-target=".navbar-collapse.show">
                <a class="nav-link" href="witryna_po_autoryzacji.php#recipes-ref">Przepisy</a>
            </li>
            <li class="nav-item" data-toggle="collapse" data-target=".navbar-collapse.show">
                <a class="nav-link" href="ustawienia.php">Konto</a>
            </li>
            <?php
            if($_SESSION['typ'] == "Moderator" || $_SESSION['typ'] == "Administrator")
            {
              echo '
              <li class="nav-item active" data-toggle="collapse" data-target=".navbar-collapse.show">
                  <a class="nav-link" href="panel_administracyjny.php"><span style="color: #D39486;">Panel administracyjny</span></a>
              </li>';
            }
            ?>
            <li class="nav-item" data-toggle="collapse" data-target=".navbar-collapse.show">
                <a class="nav-link" href="wylogowywanie.php"><button class="btn btn-outline-secondary btn-sm">Wyloguj się</button></a>
            </li>
          </ul>
        </div>
    </nav>

    <?php 
      require_once 'result.php';
    ?>
    
    <?php
      try
      {
        require_once 'connection-config.php';
        ?>

        <main>
          <div class="container">
            <section class="recipes-panel">
              <div class="container">
                <h1>Przepisy oczekujące na zatwierdzenie</h1>
                <p>Lista oczekujących przepisów dodanych przez użytkowników</p>
                <section class="recipes">
                  <?php
                    if(isset($_POST['usuwanie_przepisu']))
                    {
                      $id_usuwania = $_POST['id_usuwania'];
                      $zapytanie = $database -> exec("DELETE FROM `przepisy` WHERE `id` = '$id_usuwania'");
                    }

                    $zapytanie = $database -> query("SELECT * FROM przepisy WHERE czy_aktywne = 0");
                    echo '<div class="wrap">';
                    foreach($zapytanie as $wynik)
                    { 
                      echo '<div class="card col-md-4 col-lg-3">
                              <img src="recipePhotos/'; if($wynik['id'] <= 30) echo $wynik['id']; else echo 'test'; echo '.png" class="card-img-top" alt="zdjęcie jedzenia">
                              <div class="card-body">
                                <h5>'.$wynik['nazwa'].'</h5>
                                <div class="card-buttons">
                                  <form action="przepis_z_autoryzacja.php" method="post">
                                    <input type="hidden" name="id_przepisu" value="'.$wynik['id'].'">
                                    <input type="submit" class="btn btn-primary" name="wyswietl_przepis" value="Sprawdź przepis">
                                  </form>
                                  <form method="post" action="zatwierdzanie_przepisu.php">
                                    <input type="hidden" name="id_zatwierdzenia" value="'.$wynik['id'].'">
                                    <input type="submit" class="btn btn-success" value="Zatwierdź przepis" name="zatwierdzanie_przepisu">
                                  </form>
                                  <form method="post">
                                    <input type="hidden" name="id_usuwania" value="'.$wynik['id'].'">
                                    <input type="submit" class="btn btn-danger" value="Odrzuć przepis" name="usuwanie_przepisu">
                                  </form>
                                </div>
                              </div>
                            </div>';
                    }
                    echo '</div>';
                  ?>
                </section>
              </div>
            </section>
          </div>

          <div class="container">
            <section class="recipes-panel">
              <div class="container">
                <h1>Aktywne przepisy użytkowników</h1>
                <p>Lista zatwierdzonych przepisów dodanych przez użytkowników</p>
                <section class="recipes">
                  <?php
                    if(isset($_POST['usuwanie_przepisu']))
                    {
                      $id_usuwania = $_POST['id_usuwania'];
                      $zapytanie = $database -> exec("DELETE FROM `przepisy` WHERE `id` = '$id_usuwania'");
                    }

                    $zapytanie = $database -> query("SELECT * FROM przepisy WHERE czy_aktywne = 1");
                    echo '<div class="wrap">';
                    foreach($zapytanie as $wynik)
                    { 
                      echo '<div class="card col-md-4 col-lg-3">
                              <img src="recipePhotos/'; if($wynik['id'] <= 30) echo $wynik['id']; else echo 'test'; echo '.png" class="card-img-top" alt="zdjęcie jedzenia">
                              <div class="card-body">
                                <h5>'.$wynik['nazwa'].'</h5>
                                <div class="card-buttons">
                                  <form action="przepis_z_autoryzacja.php" method="post">
                                    <input type="hidden" name="id_przepisu" value="'.$wynik['id'].'">
                                    <input type="submit" class="btn btn-primary" name="wyswietl_przepis" value="Sprawdź przepis">
                                  </form>
                                  <form method="post">
                                    <input type="hidden" name="id_usuwania" value="'.$wynik['id'].'">
                                    <input type="submit" class="btn btn-danger" value="Usuń przepis" name="usuwanie_przepisu">
                                  </form>
                                </div>
                              </div>
                            </div>';
                    }
                    echo '</div>';
                  ?>
                </section>
              </div>
            </section>
          </div>

          <div class="container">
            <section class="recipes-panel">
              <div class="container">
                <h1>Lista użytkowników</h1>
                <p>Lista zarejestrowanych użytkowników w serwisie RecipeApp</p>
                <section class="recipes">
                  <?php
                    if(isset($_POST['usuwanie_uzytkownika']))
                    {
                      $id_usuwania = $_POST['id_usuwania'];
                      $zapytanie = $database -> exec("DELETE FROM `uzytkownicy` WHERE `id` = '$id_usuwania'");
                    }

                    $zapytanie = $database -> query("SELECT * FROM uzytkownicy WHERE klucz_dostepu = 'Aktywny' AND typ LIKE 'Standardowy'");
                    echo '<div class="wrap">';
                    foreach($zapytanie as $wynik)
                    { 
                      echo '<div class="card col-md-4 col-lg-3">
                              <img src="img/profile-photo.png" class="card-img-top" alt="jedzenie">
                              <div class="card-body">
                                <h5>'.$wynik['nick'].'</h5>
                                <span>'.$wynik['email'].'</span>
                                <div class="card-buttons">
                                  <form method="post">
                                    <input type="hidden" name="id_usuwania" value="'.$wynik['id'].'">
                                    <input type="submit" class="btn btn-danger" value="Usuń użytkownika" name="usuwanie_uzytkownika">
                                  </form>
                                </div>
                              </div>
                            </div>';
                    }
                    echo '</div>';
                  ?>
                </section>
              </div>
            </section>
          </div>
        </main>
        <?php
      }
      catch(PDOException $e)
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
    <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.14.7/umd/popper.min.js"></script>
    <script src="js/bootstrap.min.js"></script>
</body>
</html>