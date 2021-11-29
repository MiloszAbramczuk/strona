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
    <title>RecipeApp [Strona główna]</title>
    <link rel="shortcut icon" href="img/favicon.png">
    <link rel="stylesheet" href="css/bootstrap.min.css">
    <link rel="stylesheet" href="css/glowna_styles.css">
    
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

    <header class="account-panel">
      <div class="container">
        <div class="row account-info">
          <div class="col-12 col-lg-6">
            <h1>Witaj <?php echo $_SESSION['nick']; ?>!</h1>
            <p>Jesteś zalogowany/zalogowana, możesz dodawać nowe przepisy, edytować już utworzone i oceniać przepisy innych użytkowników!</p>
            <a href="dodawanie_przepisu.php"><button class="btn btn-primary">Dodaj nowy przepis</button></a>
          </div>
          <div class="col-12 col-lg-6 account-photo">
            <img src="img/profile-photo.png" alt="user-image" class="img-fluid">
          </div>
        </div>
      </div>  
    </header>     
    
    <?php
      try
      {
        require_once 'connection-config.php';
        ?>

        <section class="recipes-cards"> 
          <article>
            <div class="container">
              <h3 id="recipes-ref">Przepisy</h3>
              <h5>Sprawdź najlepsze przepisy na obiady, przekąski i inne dania</h5>
              <form method="post">
                <select name="selected-category">
                  <option value="all" <?php if((isset($_POST['selected-category']))&&($_POST['selected-category']=='all')) echo 'selected'; ?>>Wszystkie kategorie</option>
                  <?php
                    $zapytanie = $database->query('SELECT * FROM kategoria');
                    foreach($zapytanie as $wynik)
                    { 
                      ?>
                        <option value="<?php echo $wynik['nazwa']; ?>"<?php if((isset($_POST['selected-category']))&&($_POST['selected-category']==$wynik['nazwa'])) echo 'selected'; ?>><?php echo $wynik['nazwa']; ?></option>
                      <?php
                    }
                    $zapytanie->closeCursor(); 
                  ?>
                </select>
                <select name="num-results">
                  <option value="999999" <?php if((isset($_POST['num-results']))&&($_POST['num-results']=='999999')) echo 'selected'; ?>>Wszystkie</option>
                  <option value="1" <?php if((isset($_POST['num-results']))&&($_POST['num-results']=='1')) echo 'selected'; ?>>1 przepisów</option>
                  <option value="2" <?php if((isset($_POST['num-results']))&&($_POST['num-results']=='2')) echo 'selected'; ?>>2 przepisów</option>
                  <option value="3" <?php if((isset($_POST['num-results']))&&($_POST['num-results']=='3')) echo 'selected'; ?>>3 przepisów</option>
                  <option value="4" <?php if((isset($_POST['num-results']))&&($_POST['num-results']=='4')) echo 'selected'; ?>>4 przepisów</option>
                  <option value="5" <?php if((isset($_POST['num-results']))&&($_POST['num-results']=='5')) echo 'selected'; ?>>5 przepisów</option>
                </select>
                <input type="submit" value="Pokaż przepisy">
              </form>
            </div>

            <?php 
              if(isset($_POST['selected-category']))
              {
                $category = $_POST['selected-category'];
                $numOfResults = $_POST['num-results'];

                if($category == 'all')
                  $zapytanie = $database->query("SELECT * FROM przepisy WHERE `czy_aktywne`=1 limit $numOfResults");
                else
                  $zapytanie = $database->query("SELECT * FROM przepisy where kategoria like '$category' AND `czy_aktywne`=1 limit $numOfResults");

                echo '<ul>';
                foreach($zapytanie as $wynik)
                { 
                    echo '<div class="card recipe-card col-xl-3">
                            <img src="recipePhotos/'; if($wynik['id'] <= 30) echo $wynik['id']; else echo 'test'; echo '.png" class="card-img-top" alt="zdjęcie jedzenia">
                            <div class="card-body">
                              <h5 class="card-title">'.$wynik['nazwa'].'</h5>
                              <p class="card-text">'.$wynik['kategoria'].'</p>
                              <form action="przepis_z_autoryzacja.php" method="post">
                                <input type="hidden" name="id_przepisu" value="'.$wynik['id'].'">
                                <input type="submit" class="btn btn-primary" name="wyswietl_przepis" value="Sprawdź przepis">
                              </form>
                            </div>
                          </div>';
                }
                echo '</ul>';
              } 
              else
              {
                $zapytanie = $database->query("SELECT * FROM przepisy WHERE `czy_aktywne`=1");

                echo '<ul>';
                foreach($zapytanie as $wynik)
                { 
                    echo '<div class="card recipe-card col-xl-3">
                            <img src="recipePhotos/'; if($wynik['id'] <= 30) echo $wynik['id']; else echo 'test'; echo '.png" class="card-img-top" alt="zdjęcie jedzenia">
                            <div class="card-body">
                              <h5 class="card-title">'.$wynik['nazwa'].'</h5>
                              <p class="card-text">'.$wynik['kategoria'].'</p>
                              <form action="przepis_z_autoryzacja.php" method="post">
                                <input type="hidden" name="id_przepisu" value="'.$wynik['id'].'">
                                <input type="submit" class="btn btn-primary" name="wyswietl_przepis" value="Sprawdź przepis">
                              </form>
                            </div>
                          </div>';
                }
                $zapytanie->closeCursor();
                echo '</ul>';
              }
            ?>

          </article>
        </section>
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