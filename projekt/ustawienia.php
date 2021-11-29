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
    <title>RecipeApp [Ustawienia konta]</title>
    <link rel="shortcut icon" href="img/favicon.png">
    <link rel="stylesheet" href="css/bootstrap.min.css">
    <link rel="stylesheet" href="css/ustawienia.css">
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
              <li class="nav-item" data-toggle="collapse" data-target=".navbar-collapse.show">
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
          <section class="content">
            <div class="container">
            <header class="info-panel">
                <div class="container">
                  <div class="row settings-info">
                    <div class="col-12 col-lg-6">
                      <h1>Panel konfiguracyjny</h1>
                      <p>Witaj w panelu konfiguracyjnym! Znajdziesz tu spis wszystkich swoich przepisów a także zmienisz podstawowe informacje o swoim koncie.</p>
                      <a href="dodawanie_przepisu.php"><button class="btn btn-primary">Dodaj nowy przepis</button></a>
                    </div>
                    <div class="col-12 col-lg-6 settings-photo">
                      <img src="img/konfiguracja.png" alt="user-image" class="img-fluid">
                    </div>
                  </div>
                </div>  
            </header>  

            <section class="recipes-panel">
              <div class="container">
                <h1>Twoje przepisy</h1>
                <p>Lista dodanych przez Ciebie przepisów</p>
                <section class="recipes">
                    <?php
                    if(isset($_POST['usuwanie_przepisu']))
                    {
                      $id_usuwania = $_POST['id_usuwania'];
                      $zapytanie = $database -> exec("DELETE FROM `przepisy` WHERE `id` = '$id_usuwania'");
                    }

                    $id = $_SESSION['id'];
                    $zapytanie = $database -> query("SELECT * FROM przepisy WHERE autor = $id");
                    echo '<div class="wrap">';
                    foreach($zapytanie as $wynik)
                    { 
                        echo '<div class="card col-md-4 col-lg-3">
                                <img src="recipePhotos/'; if($wynik['id'] <= 30) echo $wynik['id']; else echo 'test'; echo '.png" class="card-img-top" alt="zdjęcie jedzenia">
                                <div class="card-body">
                                  <h5>'.$wynik['nazwa'].'</h5>
								                  <span style="color: red;">'; if(!$wynik['czy_aktywne']) echo 'Oczekuje na autoryzację'; echo '</span>
                                  <div class="card-buttons">
                                    <form action="przepis_z_autoryzacja.php" method="post">
                                      <input type="hidden" name="id_przepisu" value="'.$wynik['id'].'">
                                      <input type="submit" class="btn btn-primary" name="wyswietl_przepis" value="Sprawdź przepis">
                                    </form>
                                    <form method="post" action="edycja_przepisu.php">
                                      <input type="hidden" name="id_edycji" value="'.$wynik['id'].'">
                                      <input type="submit" class="btn btn-info" value="Edytuj przepis" name="edycja_przepisu">
                                    </form>
                                    <form method="post">
                                        <input type="hidden" name="id_usuwania" value="'.$wynik['id'].'">
                                        <input type="submit" class="btn btn-danger" value="Usuń przepis" name="usuwanie_przepisu">
                                      </form>
                                    </div>
                                </div>
                              </div>';
                    }
                    //$zapytanie->closeCursor();
                    echo '</div>';
                    ?>
                </section>
                </div>
            </section>

            <section class="recipes-panel">
              <div class="container">
                <h1>Twoje opinie</h1>
                <p>Lista dodanych przez Ciebie opinii</p>
                <section class="recipes">
                    <?php
                    if(isset($_POST['usuwanie_opinii']))
                    {
                      $id_usuwania = $_POST['id_usuwania'];
                      $zapytanie = $database -> exec("DELETE FROM `opinie` WHERE `id_opinii` = '$id_usuwania'");
                    }

                    $id = $_SESSION['id'];
                    $zapytanie = $database -> query("SELECT * FROM opinie INNER JOIN przepisy on (opinie.id_przepisu = przepisy.id) WHERE id_autora = $id");
                    
                    foreach($zapytanie as $wynik)
                    { 
                        echo '<div class="card col-12">
                                <div class="card-body opinion-panel">
                                  
                                  <div class="ocena">'; while($wynik['id_oceny']--){ echo '<img src="img/gwiazdka.png" width="20px">';} echo '</div>
                                  <h5>'.$wynik['nazwa'].'</h5>
                                  <p>"'.$wynik['komentarz'].'"</p>
                                  <div class="card-buttons">
                                    <form method="post">
                                      <input type="hidden" name="id_usuwania" value="'.$wynik['id_opinii'].'">
                                      <input type="submit" class="btn btn-danger" value="Usuń opinię" name="usuwanie_opinii">
                                    </form>
                                  </div>
                                </div>
                              </div>';
                    }
                    ?>
                </section>
                </div>
            </section>

            <section class="account-panel">
              <div class="container">
                <h1>Informacje o koncie</h1>
                <p>Podstawowe informacje o Twoim koncie</p>

                <article class="account-settings">
                  <h3>Nick</h3>
                  <span><?php echo $_SESSION['nick'] ?></span>

                  <h3>E-mail</h3>
                  <span><?php echo $_SESSION['email'] ?></span>

                  <h3>Typ konta</h3>
                  <span><?php echo $_SESSION['typ'] ?></span>

                  <h3>Data dodania</h3>
                  <span><?php echo $_SESSION['data_dodania'] ?></span>
                </article>
              </div>
            </section>
        </section>
        </div>
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