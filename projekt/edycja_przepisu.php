<?php 
    session_start();

    if(!isset($_SESSION['czy_zalogowany'])) {
        header('Location: index.php');
        exit();
    }

    require_once 'connection-config.php';
?>

<!DOCTYPE HTML>
<html lang="pl">
    <head>
        <meta charset="utf-8">
        <title>RecipeApp [Dodawanie przepisu]</title> 
        <link rel="shortcut icon" href="img/favicon.png">
        <link rel="stylesheet" href="css/bootstrap.min.css">
        <link rel="stylesheet" href="css/dodawanie_styles.css">
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
                  <a class="nav-link" href="witryna_po_autoryzacji.php">Anuluj</a>
              </li>
            </ul>
          </div>
        </nav>

        <?php 
          require_once 'result.php';
        ?>

        <?php
        try { 
          if(isset($_POST['edycja_przepisu'])) 
          
           $id_przepisu = $_POST['id_edycji'];

            if(isset($_POST['change-recipe'])) 
            {
              $id_uzytkownika = $_SESSION['id'];
              $id_przepisu = $_POST['id_przepisu'];
              $nazwa = $_POST['nazwa'];
              $przepis = $_POST['przepis'];
              $skladniki = $_POST['skladniki'];
              $czas_przygotowania = $_POST['czas_przygotowania'];
              $poziom_trudnosci = $_POST['poziom_trudnosci'];
              $ile_porcji = $_POST['ile_porcji'];
              $ile_kalorii = $_POST['ile_kalorii']; 

              $zapytanie = $database -> exec("UPDATE `przepisy` SET `nazwa`='$nazwa',`przepis`='$przepis',`skladniki`= '$skladniki',`czas_przygotowania`= $czas_przygotowania,`poziom_trudnosci`='$poziom_trudnosci',`ile_porcji`=$ile_porcji,`ile_kalorii`= $ile_kalorii WHERE `id`=$id_przepisu");  

              // $zapytanie = $database->prepare("UPDATE `przepisy` SET `nazwa`=:nazwa, `przepis`=:przepis, `skladniki`=:skladniki, `czas_przygotowania`=:czas_przygotowania, `poziom_trudnosci`=:poziom_trudnosci, `ile_porcji`=:ile_porcji, `ile_kalorii`= :ile_kalorii, `data_modyfikacji`= now() WHERE `id`=$id_przepisu");
              // $zapytanie->bindValue('nazwa', $nickname, PDO::PARAM_STR);
              // $zapytanie->bindValue('przepis', $przepis, PDO::PARAM_STR);
              // $zapytanie->bindValue('skladniki', $skladniki, PDO::PARAM_STR);
              // $zapytanie->bindValue('czas_przygotowania', $czas_przygotowania, PDO::PARAM_INT);
              // $zapytanie->bindValue('poziom_trudnosci', $poziom_trudnosci, PDO::PARAM_STR);
              // $zapytanie->bindValue('ile_porcji', $ile_porcji, PDO::PARAM_INT);
              // $zapytanie->bindValue('ile_kalorii', $ile_kalorii, PDO::PARAM_INT);
              // $zapytanie->execute();

              if($zapytanie)
                header('Location: witryna_po_autoryzacji.php?result=19');
              else
                header('Location: witryna_po_autoryzacji.php?result=20');
            }

           $zapytanie = $database -> query("SELECT * FROM przepisy WHERE id = $id_przepisu");
           $wynik = $zapytanie -> fetch();
           ?>
           <section class="background">
             <section class="panel">
               <h1>Formularz edycji przepisu</h1>
               <div class="container">
               <form method="post" class="needs-validation" novalidate>
                 <div class="form-row">
                   <div class="form-group">
                        <input type="hidden" value="<?php echo $id_przepisu; ?>" name="id_przepisu" required>
                   </div>
                   <div class="form-group col-12 col-lg-6">
                       <label for="nazwa">Nazwa</label>
                       <input type="text" class="form-control " id="nazwa" placeholder="Na co przygotowujesz przepis?" value="<?php echo $wynik['nazwa']; ?>" name="nazwa" required>
                       <div class="valid-feedback">W porządku!</div>
                       <div class="invalid-feedback">Niepoprawne dane!</div>
                   </div>
                   <div class="form-group col-12 col-lg-6">
                       <label for="kategoria">Kategoria</label>
                       <select name="kategoria" id="kategoria" class="form-control" disabled>
                         <option selected><?php echo $wynik['kategoria'] ?></option>
                       </select>
                       <div class="valid-feedback">W porządku!</div>
                       <div class="invalid-feedback">Niepoprawne dane!</div>
                   </div>
                 </div>
                   <div class="form-group">
                       <label for="nazwa">Przepis</label>
                       <input type="text" class="form-control" id="przepis" placeholder="Opisz sposób przygotowania przepisu" value="<?php echo $wynik['przepis']; ?>" name="przepis" required>
                       <div class="valid-feedback">W porządku!</div>
                       <div class="invalid-feedback">Niepoprawne dane!</div>
                   </div>
                   <div class="form-group">
                       <label for="skladniki">Składniki</label>
                       <input type="text" class="form-control" id="skladniki" placeholder="Czego potrzeba do wykonania przepisu?" value="<?php echo $wynik['skladniki']; ?>" name="skladniki" required>
                       <div class="valid-feedback">W porządku!</div>
                       <div class="invalid-feedback">Niepoprawne dane!</div>
                   </div>
                   <div class="form-row">
                     <div class="form-group col-12 col-lg-6">
                         <label for="czas_przygotowania">Czas przygotowania</label>
                         <input type="number" class="form-control" id="czas_przygotowania" placeholder="Ile czasu wymaga przygotowanie posiłku?" value="<?php echo $wynik['czas_przygotowania']; ?>" name="czas_przygotowania" required>
                         <div class="valid-feedback">W porządku!</div>
                         <div class="invalid-feedback">Niepoprawne dane!</div>
                     </div>
                     <div class="form-group col-12 col-lg-6">
                         <label for="poziom_trudnosci">Poziom trudności</label>
                         <select name="poziom_trudnosci" id="poziom_trudnosci" class="form-control">
                           <option selected><?php echo $wynik['poziom_trudnosci'] ?></option>
                           <?php 
                             $temp = $wynik['poziom_trudnosci'];
                             $podzapytanie = $database -> query("SELECT * from poziom_trudnosci WHERE poziom NOT LIKE '$temp'");

                             foreach($podzapytanie as $wynik_pod)
                             {
                                 echo '<option value="'.$wynik_pod['poziom'].'">'.$wynik_pod['poziom'].'</option>';
                             }
                             $zapytanie->closeCursor();
                           ?>
                         </select>
                         <div class="valid-feedback">W porządku!</div>
                         <div class="invalid-feedback">Niepoprawne dane!</div>
                     </div>
                   </div>
                   <div class="form-row">
                     <div class="form-group col-12 col-lg-6">
                         <label for="ile_porcji">Ile porcji?</label>
                         <input type="number" class="form-control" id="ile_porcji" placeholder="Ile porcji przygotujesz wykonując przepis?" value="<?php echo $wynik['ile_porcji']; ?>" name="ile_porcji" required>
                         <div class="valid-feedback">W porządku!</div>
                         <div class="invalid-feedback">Niepoprawne dane!</div>
                     </div>
                     <div class="form-group col-12 col-lg-6">
                         <label for="ile_kalorii">Ile kalorii?</label>
                         <input type="number" class="form-control" id="ile_kalorii" placeholder="Ile kalorii zawiera przygotowany posiłek?" value="<?php echo $wynik['ile_kalorii']; ?>" name="ile_kalorii" required>
                         <div class="valid-feedback">W porządku!</div>
                         <div class="invalid-feedback">Niepoprawne dane!</div>
                     </div>
                   </div>
                   <div class="form-buttons">
                     <div class="col-12"><button type="submit" class="btn btn-success btn-block" name="change-recipe">Zapisz zmiany</button></div>
                   </div>
               </form>
               </div>
             </section>
           </section> <?php
        }   
        catch(PDOException $error)
        {
            echo '
            <div class="alert alert-danger" role="alert">
              Wystąpił błąd! Przepraszamy za utrudnienia.
            </div>';
        } ?>

        <footer class="footer-panel">
          Wszelkie prawa zastrzeżone &copy RecipeApp 2019
        </footer>

        <script src="js/jquery.min.js"></script>
        <script src="js/popper.min.js"></script>
        <script src="js/bootstrap.min.js"></script>
    </body>
</html>