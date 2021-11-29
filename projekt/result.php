<?php
    if(isset($_GET['result']))
    {
      switch($_GET['result']) {
        case 1:
          echo '<div class="alert alert-danger" role="alert" style="margin:0;">Wprowadzono nieprawidłowe dane logowania!</div>';
          break;
        case 2:
          echo '<div class="alert alert-danger" role="alert" style="margin:0;">Konto z takim pseudonimem lub emailem już istnieje!</div>';
          break;
        case 3:
          echo '<div class="alert alert-danger" role="alert" style="margin:0;">Podano dwa różne hasła!</div>';
          break;
        case 4:
          echo '<div class="alert alert-success" role="alert" style="margin:0;">Udało się utworzyć konto! Sprawdź swoją skrzynkę mailową w celu potwierdzenia ważności konta.</div>';
          break;
        case 5:
          echo '<div class="alert alert-danger" role="alert" style="margin:0;">Podany klucz dostępu jest niepoprawny!</div>';
          break;
        case 6:
          echo '<div class="alert alert-success" role="alert" style="margin:0;">Pomyślnie zatwierdzono email.</div>';
          break;
        case 7:
          echo '<div class="alert alert-danger" role="alert" style="margin:0;">Zanim się zalogujesz, potwierdź swój email w celu aktywacji konta!</div>';
          break;
        case 8:
          echo '<div class="alert alert-success" role="alert" style="margin:0;">Pomyślnie wylogowano!</div>';
          break;
        case 9:
          echo '<div class="alert alert-danger" role="alert" style="margin:0;">Konto o takim e-mailu nie istnieje!</div>';
          break;
        case 10:
          echo '<div class="alert alert-success" role="alert" style="margin:0;">Na Twój e-mail wysłaliśmy link umożliwiający przywrócenie hasła.</div>';
          break;
        case 11:
          echo '<div class="alert alert-success" role="alert" style="margin:0;">Hasło zostało pomyślnie zmienione.</div>';
          break;
        case 12:
          echo '<div class="alert alert-danger" role="alert" style="margin:0;">Podany klucz dostępu jest nieprawidłowy.</div>';
          break;
        case 13:
          echo '<div class="alert alert-danger" role="alert" style="margin:0;">Nie wpisałeś danych do logowania!</div>';
          break;
        case 14:
          echo '<div class="alert alert-danger" role="alert" style="margin:0;">Nie znaleziono takiego przepisu w bazie!</div>';
          break;  
        case 15:
          echo '<div class="alert alert-danger" role="alert" style="margin:0;">Nie udało się dodać przepisu do bazy!</div>';
          break; 
        case 16:
          echo '<div class="alert alert-success" role="alert" style="margin:0;">Pomyślnie dodano przepis do bazy!</div>';
          break; 
        case 17:
          echo '<div class="alert alert-success" role="alert" style="margin:0;">Nie jesteś zalogowany!</div>';
          break;  
        case 18:
          echo '<div class="alert alert-success" role="alert" style="margin:0;">Pomyślnie dodano komentarz!</div>';
          break;   
        case 19:
          echo '<div class="alert alert-success" role="alert" style="margin:0;">Pomyślnie zmodyfikowano przepis!</div>';
          break; 
        case 20:
          echo '<div class="alert alert-danger" role="alert" style="margin:0;">Wystąpił błąd podczas aktualizacji przepisu!</div>';
          break; 
        case 21:
          echo '<div class="alert alert-success" role="alert" style="margin:0;">Przepis został pomyślnie zatwierdzony, wysłano e-mail informacyjny do autora.</div>';
          break; 
        default:
          echo 'Nieznany błąd, spróbuj ponownie!';
          break;
      }
    }
?>
