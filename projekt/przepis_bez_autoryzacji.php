<?php 
  session_start();
 
  if((isset($_SESSION['czy_zalogowany'])) && ($_SESSION['czy_zalogowany']==true)) {
    header('Location: witryna_po_autoryzacji.php');
    exit();
  }
?>

<!DOCTYPE HTML>
<html lang="pl">
<head>
    <meta charset="utf-8">
    <title>RecipeApp [Przepis]</title>
    <link rel="stylesheet" href="css/bootstrap.min.css">
    <link rel="stylesheet" href="css/przepis_styles.css">
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
            require_once 'connection-config.php';

            if(isset($_POST['wyswietl_przepis'])) {
                $id = $_POST['id_przepisu'];

                $zapytanie = $database -> prepare("SELECT * FROM przepisy WHERE id like '$id'");
                $zapytanie -> execute();
                $wynik = $zapytanie -> fetch();
                $ile_rekordow = $zapytanie->rowCount();

                if($ile_rekordow > 0) {
                   ?>
                    <div class="container">
                        <article class="recipe-panel">

                            <header class="recipe-header">
                                <section class="recipe-title col-12 col-lg-6">
                                    <h3><?php echo $wynik['nazwa']; ?></h3>
                                    <h5><?php echo $wynik['kategoria']; ?></h5>
                                </section>

                                <section class="recipe-image col-12 col-lg-6">
                                    <?php
                                        echo '<img src="recipePhotos/'; if($wynik['id'] <= 30) echo $wynik['id']; else echo 'test'; echo '.png" class="card-img-top" alt="zdjęcie jedzenia">';
                                    ?>
                                </section>
                            </header>

                            <section class="recipe-info col-12">
                                <div class="col-6 col-lg-3">
                                    <img src="img/czas_przygotowania.png">
                                    <h5>Czas przygotowania</h5>
                                    <span><?php echo $wynik['czas_przygotowania']; ?> min.</span>
                                </div>
                                <div class="col-6 col-lg-3">
                                    <img src="img/poziom_trudnosci.png">
                                    <h5>Poziom trudności</h5>
                                    <span><?php echo $wynik['poziom_trudnosci']; ?> </span>
                                </div>
                                
                                <div class="col-6 col-lg-3">
                                    <img src="img/ile_kalorii.png">
                                    <h5>Liczba kalorii</h5>
                                    <span><?php echo $wynik['ile_kalorii']; ?> kcal</span>
                                </div>
                                <div class="col-6 col-lg-3">
                                    <img src="img/ile_porcji.png">
                                    <h5>Liczba porcji</h5>
                                    <span><?php echo $wynik['ile_porcji']; ?> </span>
                                </div>
                            </section>

                            <section class="recipe">
                                <section class="recipe-components col-12 col-lg-6">
                                    <h5>Składniki</h5>
                                    <?php echo $wynik['skladniki']; ?>
                                </section>
                                <section class="recipe-formula col-12 col-lg-6">
                                    <h5>Sposób przygotowania</h5>
                                    <?php echo $wynik['przepis']; ?>
                                </section>
                            </section>
                            
                            <section class="recipe-extra-info col-12">   

                                <div class="data-utworzenia col-4 col-lg-4">
                                    <img src="img/data_utworzenia.png">
                                    <h5>Data dodania</h5>
                                    <span><?php echo $wynik['data_dodania']; ?></span>
                                </div>
                                
                                <div class="data-modyfikacji col-4 col-lg-4">
                                    <img src="img/data_modyfikacji.png">
                                    <h5>Data modyfikacji</h5>
                                    <span><?php echo $wynik['data_dodania']; ?></span>
                                </div>

                                <div class="autor col-4 col-lg-4">
                                    <img src="img/autor.png">
                                    <h5>Autor przepisu</h5>
                                    <?php 
                                        $id_uzytkownika = $wynik['autor'];
                                        $zapytanie = $database->prepare("SELECT * FROM uzytkownicy WHERE id like '$id_uzytkownika'");
                                        $zapytanie -> execute();
                                        $wynik = $zapytanie -> fetch();
                                        $ile_rekordow = $zapytanie->rowCount();
                                        if($ile_rekordow > 0) {
                                            echo '<span>'.$wynik['nick'].'</span>';
                                        }
                                    ?>
                                </div>

                            </section>

                            <section class="recipe-buttons">
                                <input type="button" class="btn btn-info" onclick="window.print()" value="Wydrukuj przepis">
                            </section>
                        </article>

                        <section class="comments-box">
                            <header>
                                <h2>Komentarze</h2>
                                <h4>Aby dodać komentarz musisz być zalogowany!</h4>
                            </header>

                            <?php 
                                $zapytanie = $database->prepare("SELECT * FROM opinie inner join uzytkownicy on (opinie.id_autora = uzytkownicy.id) WHERE id_przepisu like '$id'");
                                $zapytanie -> execute();
                                                    
                                while($wynik = $zapytanie -> fetch())
                                {
                                    echo '
                                    <article class="comment">
                                        <div class="header">
                                            <img src="img/profile-photo.png" alt="profile-photo" width="50px;">
                                            <div class="author">'.$wynik['nick'].'</div>
                                            <div class="ocena">'; while($wynik['id_oceny']--){ echo '<img src="img/gwiazdka.png" width="20px">';} echo '
                                            </div>
                                            <div class="date">'.$wynik['data_dodania'].'</div>
                                        </div>
                                        <span><b>Napisał/Napisała:</b></span>
                                        <div class="comment-content"><i>'.$wynik['komentarz'].'</i></div>
                                    </article>'; 
                                }

                                
                            ?>  
                        </section>
                    </div>
                   <?php
                }
                else
                {
                    header('Location: index.php?result=14');
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
    <footer class="footer-panel">
        Wszelkie prawa zastrzeżone &copy RecipeApp 2019
    </footer>
 
    <script src="js/jquery.min.js"></script>
    <script src="js/popper.min.js"></script>
    <script src="js/bootstrap.min.js"></script>
</body>
</html>

