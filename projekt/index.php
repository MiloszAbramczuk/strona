<?php 
  session_start();

  if((isset($_SESSION['czy_zalogowany'])) && ($_SESSION['czy_zalogowany']==true)) {
    header('Location: witryna_po_autoryzacji.php');
    exit();
  }
  
  try
      {
        require_once 'connection-config.php';
?>

<!DOCTYPE HTML>
<html lang="pl">
  <head>
      <meta charset="utf-8">
      <title>RecipeApp [Strona główna]</title> 
      <meta name="description" content="Baza najlepszych przepisów kulinarnych w sieci. Sprawdź niespotykane pomysły na obiady, przekąski i desery.">
      <meta keywords="przepis, obiad, jedzenie, deser, kuchnia">
      <link rel="shortcut icon" href="img/favicon.png">

      <link rel="stylesheet" href="css/bootstrap.min.css">
      <link rel="stylesheet" href="css/index_styles.css">
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
      require_once 'result.php';
    ?>
    
    <header class="login-panel" id="login-ref">
      <article>
        <h1>RecipeApp</h1>
        <p>Witaj na stronie poświęconej przepisom kulinarnym. Znajdziesz tu domowe przepisy na dania główne, desery, zupy oraz wszelkiego rodzaju napoje. Możesz dodawać swoje własne przepisy, dzieląc się nimi z innymi ludźmi. Co więcej możesz oceniać publikacje innych użytkowników, dzielić się swoimi spostrzeżeniami i wskazówkami.</p>
      </article>
      <section>
        <form action="logowanie.php" method="post">
          <div class="form-group">
            <label for="exampleInputEmail1">Adres e-mail</label>
            <input type="email" class="form-control" id="exampleInputEmail1" aria-describedby="emailHelp" placeholder="Wprowadź e-mail" name="login">
          </div>
          <div class="form-group">
            <label for="exampleInputPassword1">Hasło</label>
            <input type="password" class="form-control" id="exampleInputPassword1" placeholder="Wprowadź hasło" name="password">
          </div>
          <button type="submit" class="btn btn-primary">Zaloguj się</button>
        </form>
        <div style="flex: none;">
          <div class="col-6" style="float: left; padding: 0 1px 0 0;"><a href="przywracanie_hasla.php"><button class="btn btn-secondary btn-sm">Przywróć hasło</button></a></div>
          <div class="col-6" style="float: left; padding: 0 0 0 1px;"><a href="rejestracja.php"><button class="btn btn-secondary btn-sm">Zarejestruj się</button></a></div>
        </div>
      </section>
    </header>
        
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
                $zapytanie = $database->query("SELECT * FROM przepisy WHERE `czy_aktywne`=1 AND kategoria like '$category' limit $numOfResults");

              echo '<ul>';
              foreach($zapytanie as $wynik)
              { 
                  echo '<div class="card recipe-card col-xl-3">
                          <img src="recipePhotos/'; if($wynik['id'] <= 30) echo $wynik['id']; else echo 'test'; echo '.png" class="card-img-top" alt="zdjęcie jedzenia">
                          <div class="card-body">
                            <h5 class="card-title">'.$wynik['nazwa'].'</h5>
                            <p class="card-text">'.$wynik['kategoria'].'</p>
                            <form action="przepis_bez_autoryzacji.php" method="post">
                              <input type="hidden" name="id_przepisu" value="'.$wynik['id'].'">
                              <input type="submit" class="btn btn-primary" name="wyswietl_przepis" value="Sprawdź przepis">
                            </form>
                          </div>
                        </div>';
              }
              //$zapytanie->closeCursor();
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
                            <form action="przepis_bez_autoryzacji.php" method="post">
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
    
    <footer class="footer-panel">
      Wszelkie prawa zastrzeżone &copy RecipeApp 2019
    </footer>

    <?php
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
</body>
</html>