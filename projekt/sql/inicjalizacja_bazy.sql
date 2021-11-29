# noinspection SqlInsertValuesForFile

create database if not exists `recipeapp`;
use recipeapp;

drop table if exists `typ_uzytkownika`;
create table `typ_uzytkownika` (
	nazwa varchar(15) primary key
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE utf8_bin;

drop table if exists `uzytkownicy`;
create table `uzytkownicy` (
	id int UNSIGNED primary key auto_increment,
	nick varchar(30) not null,
	email varchar(35) not null,
	haslo varchar(20) not null,
	typ varchar(15) not null,
	klucz_dostepu varchar(32),
	kod_przywracania varchar(32),
	data_dodania datetime,
	data_modyfikacji datetime
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE utf8_bin;

drop table if exists `kategoria`;
create table `kategoria` (
	nazwa varchar(25) primary key
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE utf8_bin;

drop table if exists `poziom_trudnosci`;
create table poziom_trudnosci (
	poziom varchar(20) primary key
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE utf8_bin;

drop table if exists `opinie`;
create table if not exists `opinie` (
	id_opinii int UNSIGNED primary key auto_increment,
	id_przepisu int UNSIGNED not null,
	id_autora int UNSIGNED not null,
	id_oceny tinyint not null,
	komentarz text,
	data_opinii datetime
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE utf8_bin;

drop table if exists `oceny`;
create table if not exists `oceny` (
	ocena tinyint primary key
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE utf8_bin;

drop table if exists `przepisy`;
create table `przepisy` (
	id int UNSIGNED primary key auto_increment,
	nazwa varchar(40) not null,
	autor int UNSIGNED not null,
	przepis text not null,
	skladniki text not null,
	czas_przygotowania tinyint not null,
	poziom_trudnosci varchar(20) not null,
	ile_porcji tinyint not null,
	ile_kalorii smallint UNSIGNED not null,
	kategoria varchar(25) not null,
	czy_aktywne bit not null DEFAULT 0,
	data_dodania datetime,
	data_modyfikacji datetime
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE utf8_bin;

CREATE INDEX i_naz_prze ON przepisy (nazwa);
CREATE INDEX i_kat_prze ON przepisy (kategoria); 
	
alter table uzytkownicy add constraint typ_fkey foreign key (typ) references typ_uzytkownika (nazwa) on delete cascade on update cascade;
alter table przepisy add constraint kategoria_fkey foreign key (kategoria) references kategoria (nazwa) on delete cascade on update cascade;
alter table przepisy add constraint autor_fkey foreign key (autor) references uzytkownicy (id) on delete cascade on update cascade;
alter table przepisy add constraint poziom_fkey foreign key (poziom_trudnosci) references poziom_trudnosci (poziom) on delete cascade on update cascade;
alter table opinie add constraint id_przepis_fkey foreign key (id_przepisu) references przepisy (id) on delete cascade on update cascade;
alter table opinie add constraint id_autor_fkey foreign key (id_autora) references uzytkownicy (id) on delete cascade on update cascade;
alter table opinie add constraint id_ocena_fkey foreign key (id_oceny) references oceny (ocena) on delete cascade on update cascade;

insert into poziom_trudnosci values 
	("Banalny"),
	("Łatwy"),
	("Średni"),
	("Trudny"),
	("Bardzo trudny");

insert into oceny values 
	(1),
	(2),
	(3),
	(4),
	(5);

insert into kategoria values 
    ("Ciasta"),
    ("Ciastka"),
    ("Dania główne"),
    ("Desery"),
    ("Grill"),
    ("Kanapki"),
    ("Kluski"),
    ("Makarony"),
    ("Naleśniki"),
    ("Alkohole"),
    ("Koktajle"),
    ("Pieczywo"),
    ("Pierogi"),
    ("Pizza"),
    ("Placki"),
    ("Przekąski"),
    ("Przetwory"),
    ("Przystawki"),
    ("Sałatki"),
    ("Sosy"),
    ("Śniadania"),
    ("Wege"),
    ("Zapiekanki"),
    ("Zupy");

insert into typ_uzytkownika values 
	("Standardowy"),
	("Moderator"),
	("Administrator");
	
insert into uzytkownicy (nick, email, haslo, typ, klucz_dostepu, kod_przywracania, data_dodania, data_modyfikacji) values 
	("admin", "admin@admin.pl", "admin1@", "Administrator", "Aktywny", "67df854fsa54f54asf40e70xsad4ds05", now(), now());
	
insert into przepisy (nazwa, autor, przepis, skladniki, czas_przygotowania, poziom_trudnosci, ile_porcji, ile_kalorii, kategoria, czy_aktywne, data_dodania, data_modyfikacji) values
	("Pizza Capricciosa", 2, "Przygotować ciasto wg ulubionej receptury. Wyrośnięte ciasto wyłożyć w blaszce, uformować brzegi. Posmarować sosem pomidorowym. Nagrzać piekarnik do  250C. Pieczarki pokroić w plasterki, szynkę w paseczki. Mozzarellę potrzeć na tarce lub pokroić w plasterki. Ewentualnie można mozzarellę zastąpić żółtym serem. Na pizzy ułożyć kolejno: szynkę, ser i pieczarki. Wstawić pizzę do piekarnika i piec ok. 7-10 minut. Pizzę lekko ostudzić, najlepiej na kratce. Podawać z ulubionymi sosami.", "Mąka pszenna tortowa 3 szklanki (po 250ml), Drożdże 40g, Sól 1 łyżeczka, Bazylia 1-2 łyżeczki, Oregano 1-2 łyżeczki, Woda 1 szklanka (250 ml ; temp 40-50C), Oliwa z oliwek 3 łyżeczki, Pomidory w puszce 1 puszka, Pieczarki kilka sztuk, Szynka kilka plasterków, Mozzarella 300g", 60, "Średni", 4, 450, "Pizza", 1, now(), now()),
	("Szarlotka", 5, "Przygotować ciasto kruche: Z mąki, cukru, cukru waniliowego, masła (pokrojonego na małe kawałki), jajka i proszku do pieczenia zagnieść jednolite ciasto ręką lub robotem kuchennym. Z ciasta uformować kulę, lekko ją spłaszczyć i owinąć w folię spożywczą. Wstawić do lodówki na czas przygotowania musu jabłkowego. Przygotować mus jabłkowy: Jabłka umyć, obrać, usunąć gniazda nasienne i pokroić w niedużą kostkę lub zetrzeć na tarte. Wymieszać z 2 łyżkami cukru i przesmażyć, aż powstanie mus. (Gdyby mus był mocno wodnisty smażyć, aż nadmiar soku wyparuje). Wmieszać cynamon i pozostawić do ostygnięcia. Formę kwadratową o wymiarach ok. 24x 24 cm wyłożyć papierem do pieczenia. (Można najpierw delikatnie posmarować w kilku miejscach formę masłem lub margaryną. Wtedy wyłożenie formy papierem pójdzie sprawniej, bo przyklei się on do tłuszczu). Połowę ciasta wykleić na dnie formy. Wyłożyć mus jabłkowy. Z pozostałego ciasta odrywać kawałki i układać je na musie jabłkowym. (Można również ciasto rozwałkować).", "Ciasto kruche: 2 szklanki mąki pszennej (300 g), 3 łyżki cukru, 2 łyżeczki cukru waniliowego, 250 g masła, zimnego, 2 płaskie łyżeczki proszku do pieczenia, 1 jajko (rozmiar M), Mus jabłkowy: ok. 1,5 kg jabłek (polecam Szarą Renetę), 1 łyżeczka cynamonu, 2 łyżki cukru", 240, "Średni", 12, 1200, "Ciasta", 1, now(), now()),
	("Duszona karkówka w sosie własnym z cebulą", 2, "Mięso opłucz i pokrój na kotlety grubości 2 cm. Każdy rozbij lekko tłuczkiem, posyp pieprzem i oprósz mąką. W następnej kolejności obsmaż je z obu stron na złoty kolor na rozgrzanym oleju. Cebule pokrój w piórka i przesmaż w garnku na rozgrzanym oleju, dodaj majeranek, liść laurowy oraz ziele. Gdy cebula nabierze złotego koloru, wsyp pozostałą mąkę i przesmaż razem. Następnie dodaj 1 l wrzącej wody. Włóż mięso, Esencję do duszonych mięs Knorr i duś na małym ogniu do momentu, gdy karkówka będzie miękka. Podawaj z ziemniakami lub kaszą.", "600g karkówki wieprzowej, Esencja do duszonych mięs Knorr, woda, majeranek, cebula, mąka, ziele angielskie, olej do smażenia", 60, "Łatwy", 4, 1400, "Dania główne", 1, now(), now()),
	("Pieczony kurczak z ziemniakami", 3, "Stwórz błyskawiczną marynatę, mieszając przyprawę Knorr z olejem, papryką i oregano. Natrzyj nią kurczaka z zewnątrz i od środka. Jeśli lubisz potrawy pikantne do marynaty dodaj również trochę ostrej papryki. Ziemniaki obierz i przekrój na cztery części. Kurczaka i ziemniaki umieść w brytfance, piecz 60 minut w 190 °C.", "kurczak (ok. 1,5 kg)1 szt. Przyprawa do złotego kurczaka Knorr (4 łyżki), ziemniaki 800g, Papryka słodka z Hiszpanii Knorr 1 łyżeczka, Oregano z Turcji Knorr 1 łyżeczka, olej2 łyżki", 60, "Łatwy", 4, 1100, "Dania główne", 1, now(), now()),
    ("Kremowa zupa z kurek", 1, "Ugotuj bulion z porcji rosołowej, przypraw oraz warzyw. Następnie odcedź go. Obierz ziemniaki, pokrój je w kostkę i dodaj do odcedzonego bulionu. Umyj kurki, po czym dodaj je do wywaru wraz z kostkami rosołowymi Knorr oraz majerankiem. Gotuj całość do momentu, gdy ziemniaki będą miękkie. Dolej do zupy piwo oraz śmietanę i mocno ją podgrzej. Podawaj porcje zupy, na talerzach, udekorowaną siekanym szczypiorkiem.", "porcja rosołowa 500 g, Rosół z kury Knorr 2 szt, świeże kurki 200 g, średniej wielkości ziemniaki 4 szt, pietruszka 1 szt, cebula 1 szt, ciemne piwo 100 ml, Majeranek z krajów śródziemnomorskich Knorr 1 łyżka, Ziele angielskie z Meksyku Knorr 4 ziarna, Pieprz czarny z Wietnamu ziarnisty Knorr 5 ziaren, śmietana 22% pół szklanki, pęczek szczypioru 1 szt, seler 05 szt.", 60, "Łatwy", 4, 600, "Zupy", 1, now(), now()),
    ("Placki ziemniaczane", 3, "Obierz ziemniaki, zetrzyj na tarce. Odsącz masę przez sito. Zetrzyj cebulę na tarce. Dodaj do ziemniaków cebulę, jajka, gałkę muszkatołową oraz mini kostkę Knorr. Wymieszaj wszystko dobrze, dodaj mąkę, aby nadać masie odpowiednią konsystencję. Rozgrzej na patelni olej, nakładaj masę łyżką. Smaż placki z obu stron na złoty brąz i od razu podawaj.", "ziemniaki 1 kg, cebula 1 szt, jajka 2 szt, Przyprawa w Mini kostkach Czosnek Knorr, Gałka muszkatołowa z Indonezji Knorr 1 szczypta, sól 1 szczypta, mąka", 30, "Średni", 8, 1000, "Placki", 1, now(), now()),
	("Pierogi z jabłkami i cynamonem", 2, "Mąkę wymieszaj z jajkiem, solą oraz oliwę. Następnie dodaj szklankę wody i wyrób aż ciasto będzie gładkie. Jabłka wyczyść, obierz i pokrój w kostkę, a następnie przełóż do garnka i posyp cynamonem, cukrem waniliowym i cukrem oraz dolej odrobinę wody. Gotuj na wolnym ogniu często mieszając przez około 10-15 minut aż jabłka będą miękkie a sok wyparuje. Ciasto wałkuj i wytnij kółka. Nakładaj farsz na każdego pieroga i dobrze sklej. Wrzucaj do wrzącej, lekko osolonej wody i czekaj aż pierogi wypłyną. Pierogi można podać polane roztopionym masłem i posypane cukrem.", "jabłka 1 kg, mąka 500 g, ciepła woda 1 szkalnka, jajko 1 sztk, cynamon 2 łyżeczki, cukier waniliowy 1 opak., cukier 0,5 szkalnaki, sól, oliwa 3 łyżki", 45, "Łatwy", 6, 600, "Pierogi", 1, now(), now()),
	("Grzybowa po męsku", 1,  "Umyj i namocz grzyby, następnie gotuj je przez 40 minut. Drobno pokrój warzywa i podsmaż je na oleju. Zalej 2 szklankami wody i gotuj przez 25 minut. Połącz ze sobą oba wywary, następnie przecedź. Pokrój grzyby i dodaj do wywaru wraz z kostkami Rosołu wołowego Knorr. Dodaj szklankę mleka i dopraw pieprzem. Zupę podawaj z makaronem.", "suszone grzyby 30 gramów, rosół wołowy Knorr 2 szt., cebule 2 szt., marchewki 2 szt., mały seler 1 szt., woda 2 szk., mleko 1 szklanka, pieprz do smaku 1 szczypta, olej 2 łyżki, makaron wstążki 1 opakowanie", 60, "Łatwy", 4, 700, "Zupy", 1, now(), now()),
	("Oponki z cukrem", 2, "Drożdże rozpuść w letnim mleku. W misce wymieszaj mąkę, sól, cukier. Dodaj żółtko, wodę i rozpuszczone w mleku drożdże. Wymieszaj. Kasię schłodź w zamrażarce. Ciasto przełóż na podsypany mąką stół i dobrze zagnieć. Powinno być zwarte i odchodzić od stołu i rąk. Ciasto odstaw w ciepłe miejsce do wyrośnięcia na około 60 minut. Powinno podwoić objętość. Wyrośnięte ciasto jeszcze raz zagnieć i rozwałkuj na placek grubości 1 cm. Na połowie ciasta ułóż cienkie plastry schłodzonej Kasi i przykryj drugą połową ciasta. Brzegi sklej dociskając ciasto palcami. Ciasto rozwałkuj na duży prostokąt, a następnie złóż w kopertę. Czynność składania i rozwałkowywania powtórz kilka razy. Ostatecznie ciasto powinno mieć grubość ok. 1 cm. Z ciasta wytnij metalową obręczą kółka o średnicy około 6 cm, a następnie wytnij w nich mniejszą obręczą dziurki. Odstaw, aby podwoiły objętość. W garnku rozgrzej olej. Wrzucaj pączki i smaż na małym ogniu obracając w czasie pieczenia. Osącz na papierowym ręczniku. Cukier puder utrzyj z sokiem z cytryny na gładki lukier i posmaruj nim wierzch pączków.", "ciasto: mąka pszenna 500 gramów, Kostka do pieczenia Kasia 150 gramów,woda 0.5 szklanek,mleko 0.5 szklanek,żółtko 1 sztuka,drożdże 20 gramów, sól 1 szczypta, cukier 50 gramów, olej do smażenia 1 litr lukier: cukier puder 250 gramów, sok z cytryny 5 łyżek", 40, "Trudny", 2, 1200, "Ciastka", 1, now(), now()),
	("Leczo", 1, "Wszystkie warzywa pokrój w grubą kostkę. Przesmaż je na 4 łyżkach oleju. Na oddzielnej patelni przesmaż pokrojoną w kostkę kiełbasę i boczek. Po zarumienieniu się mięs dodaj warzywa i zalej je niewielką ilością wody. Dopraw do smaku papryką ostrą. Dodaj pokrojone pomidory i Knorr Chłopski garnek, kiedy warzywa zmiękną. Gotuj przez 15 minut do zredukowania pomidorów.", "boczek 400 gramów kiełbasa 400 gramów, papryka czerwona 2 sztuki,seler naciowy 1 pęczek, Naturalnie smaczne Chłopski Garnek Knorr 1 opakowanie, Papryka ostra z Hiszpanii Knorr 1 szczypta, krojone pomidory w puszce 800 gramów bakłażan 1 sztuka, cebula 1 sztuka, woda 200 mililitrów, olej 4 łyżki", 30, "Łatwy", 6, 800, "Dania główne", 1, now(), now()),
	("Placki z ziemników", 3, "Rozgrzej piekarnik do 180°C. Ugotuj ziemniaki (około 20 minut). Odcedź starannie i utłucz. Odstaw do ostygnięcia. Posiekaj drobno cebulę. Roztop masło na niewielkiej patelni i smaż cebulę 10 minut, aż będzie miękka. Dodaj do ziemniaków: cebulę, śmietanę, żółtka, przyprawy w mini kostkach Knorr. Wymieszaj dokładnie. Przesiej mąkę do garnka z ziemniakami i wymieszaj. Przypraw sporą ilością pieprzu i solą, jeśli uznasz, że jest to konieczne. Uformuj z masy ziemniaczanej kulki (około 16). Spłaszcz by powstały niewielkie placuszki o średnicy około 6 centymetrów. Ułóż na lekko natłuszczonej blasze do pieczenia i posmaruj roztrzepanym jajkiem. Posyp bułką tartą. Piecz 30 minut, aż się przyrumienią.", "ziemniaki 450 gramów, żółtka 3 sztuki, cebula 1 sztuka, jajko 1 sztuka, Przyprawa w Mini kostkach Pietruszka Knorr, mąka 25 gramów, bułka tarta 25 gramów, Przyprawa w Mini kostkach Czosnek Knorr, kwaśna śmietana 3 łyżki, świeżo mielony czarny pieprz 1 szczypta, masło 2 łyżki", 60, "Średni", 4, 900, "Placki", 1, now(), now()),
	("Zapiekanka ziemniaczana z kiełbasą", 2, "Fix Knorr wymieszaj z bulionem i zagotuj. Następnie odstaw do ostygnięcia. Kiełbasę pokrój w kostę i usmaż, aż będzie rumiana. Ziemniaki pokrój w cienkie plastry i wymieszaj z sosem oraz roztrzepanym jajkiem. Do masy ziemniaczanej dodaj kiełbasę i wymieszaj. Foremkę do pieczenia wysmaruj margaryną. Wylej do niej przygotowaną masę. Wyrównaj wierzch. Posyp całość startym serem i zapiekaj w piekarniku rozgrzanym do 160 °C przez 40 minut. Pod koniec pieczenia możesz zwiększyć temperaturę do 180 °C, by zapiekanka się przypiekła.", "ziemniaki 5 sztuk, Fix Spaghetti Carbonara Knorr 1 opakowanie, bulion 300 mililitrów, kiełbasa zwyczajna 1 sztuka, jajko 1 sztuka, ser żółty 80 gramów, tłuszcz do wysmarowania formy", 60, "Łatwy", 6, 1400, "Zapiekanki", 1, now(), now()),
	("Tort makowy z budyniem", 2, "Kasię rozpuść w rondelku. Żółtka oddziel od białek. Białka ubij na sztywną pianę z cukrem. Mąkę wymieszaj z proszkiem do pieczenia i makiem. Do ubitych białek dodaj, mieszając mikserem na wolnych obrotach, po jednym żółtku, a następnie po łyżce mąki wymieszanej z proszkiem do pieczenia i makiem. Na koniec wlej rozpuszczoną Kasię i delikatnie wymieszaj łyżką. Dno tortownicy o średnicy 26 cm. wyłóż papierem do pieczenia. Boków nie smaruj. Do formy włóżciasto i piecz w 170 st.C około 30 minut. Upieczone i wystudzone ciasto przekrój na 3 krążki. Z jednej pomarańczy zetrzyj skórkę. Połowę mleka zagotuj razem ze skórką pomarańczową, w reszcie mleka rozprowadź proszek budyniowy. Rozprowadzony proszek wlej do gotującego mleka i gotuj ciągle mieszając, aż powstanie gęsty budyń. Wystudź. Miękką Kasię ubij mikserem. Ciągle ubijając dodawaj po łyżce wystudzony budyń. Jeden krążek ciasta ułóż w tortownicy i posmaruj 1/3 przygotowanego kremu. Przykryj drugim krążkiem ciasta i znów posmaruj częścią kremu. Tak samo postąp z trzecim krążkiem i resztą kremu. Tort odstaw do lodówki. Płatki migdałowe upraż na suchej patelni. Pomarańcze i grejpfruty wyfiletuj. Schłodzony tort posyp płatkami migdałowymi i udekoruj cząstkami cytrusów.", "ciasto: Kostka do pieczenia Kasia 50 gramów, cukier 160 gramów, jajko 5 sztuk, mąka 110 gramów, suchy mak. 150 gramów, proszek do pieczenia 1 łyżeczka krem:Kostka do pieczenia Kasia 1 opakowanie, budyń śmietankowy z cukrem 3 opakowania, mleko 1 litr. wierzch: płatki migdałowe - 75 gramów, pomarańcza 2 sztuki, czerwony grejpfrut 2 sztuki", 45, "Łatwy", 4, 900, "Ciasta", 1, now(), now()),
	("Jogurt naturalny z musem z owoców", 2, "Owoce umyć. Truskawki i borówki zmiksować na gładką masę. Do przeźroczystej szklanki wkroić banana, a następnie wlać połowę opakowania jogurtu. Posypać jogurt płatkami owsianymi. Potem wlać masę owocową. Na wierzch dodać resztę jogurtu. Całość posypać nasionami chia. W ramach dekoracji można ułożyć świeże listki mięty.", "jogurt naturalny 0% 600 g, truskawki 400 g, borówki 300 g, banan 280 g, nasiona chia 4 łyżeczki, płatki owsiane 4 łyżki", 15, "Łatwy", 1, 150, "Desery", 1, now(), now()),
	("Placki dyniowe", 1, "Wszystkie składniki wymieszaj ze sobą w misce. Dopraw Delikatem i wyrób na gładką masę. Na patelni rozgrzej Ramę, nakładaj masę łyżką i smaż powstałe placki na złoty kolor. Smażąc na ramie nadasz specyficznego maślanego aromatu i jednocześnie zachowasz czystość, bo Rama nie pryska podczas smażenia. Usmażone placki odsącz z nadmiaru tłuszczu na papierowym ręczniku. Podawaj z łyżką kwaśnej śmietany lub gęstego jogurtu. Możesz udekorować ulubionymi ziołami.", "upieczona dynia 400 g, Rama Smaż jak szef kuchni, wariant maślany smak 100 ml, Delikat przyprawa uniwersalna Knorr 0,5 łyżeczek, mąka pszenna 100 g, cebula 1 szt, starty imbir 10 g, ząbek czosnku 1 szt., jajko 1 szt., curry madras 1 łyżka", 15, "Łatwy", 4, 500, "Placki", 1, now(), now()),
	("Krupnik domowy", 2, "Kaszę dokładnie wypłucz, następnie zalej wodą, dodaj kostkę Knorr i gotuj powoli, aż lekko zmięknie. Ziemniaki i marchew pokrój w kostkę, a pora w plastry. W drugim garnku gotuj warzywa wraz z liściem laurowym i zielem angielskim. Gdy ziemniaki będą półmiękkie, dodaj do zupy kaszę wraz z płynem, w którym się gotowała. Do całości dodaj drugą kostkę oraz wodę, jeśli uznasz to za konieczne. Gotuj zupę jeszcze około 20 minut. Ziemniaki i kasza powinny być zupełniemiękkie. Gotową zupę podawaj posypaną posiekaną natką pietruszki.", "kasza jęczmienna 0.6 szklanek, Rosół z kury Knorr 2 sztuki, marchewka 1 sztuka, por mały 1 sztuka, ziemniaki 200 gramów, natka pietruszki 0.5 pęczków, Liść laurowy z Turcji Knorr 2 sztuki, Ziele angielskie z Meksyku Knorr 3 sztuki", 60, "Łatwy", 4, 400, "Zupy", 1, now(), now()),
	("Klasyczna zapiekanka ziemniaczana", 1, "Rozgrzej piekarnik do 200 ° C. Zetrzyj ser na tarce. Ziemniaki obierz i pokrój w cienkie plastry, czosnek zetrzyj na tarc. Foremkę wyłóż pergaminem lub natłuść. Knorr Naturalnie smaczne wymieszaj z mlekiem, czosnkiem i ziemniakami. Ziemniaki przełóż do foremki, posyp z wierzchu serem. Całość przykryj folią aluminiową, wstaw n 30 minut do piekarnika , po tym czasie usuń folię. Zapiekankę piecz jeszcze 10-15 minut, aż ziemniaki będą zupełnie miękkie, a wierzchnia warstwa zrobi się rumiana.", "ziemniaki 600 g, Naturalnie smaczne Zapiekanka makaronowa z szynką Knorr 1 opak., mleko 300 ml, twardy ser np. Ementaler 50 g, ząbek czosnku 1 szt.", 15, "Łatwy", 5, 600, "Zapiekanki", 1, now(), now()),
	("Ciasto King Kong", 3, "Foremkę o wymiarach 20x20 cm wyłóż papierem do pieczenia, a następnie warstwą herbatników. Mleko podgrzej i rozpuść w nim cukier i cukier wanilinowy. Wystudź. Orzeszki posiekaj i upraż na suchej patelni. Miękką Kasię utrzyj na puszystą masę. Ciągle ucierając wlewaj cienkim strumieniem mleko z cukrem i wsyp partiami mleko w proszku. Na herbatniki w formie wyłóż krem i przykryj kolejną warstwą herbatników. Na herbatnikach rozsmaruj masę kajmakową i ponownie przykryj herbatnikami. Śmietankę podgrzej w rondelku, dodaj połamaną czekoladę i mieszaj, aż masa będzie gładka. Dodaj orzeszki. Gotową masę rozprowadź na herbatnikach. Całość odstaw na godzinę do lodówki.", "herbatniki typu Petit Beurre 42 szt., gotowa masa krówkowa 1 słoik krem: Kostka do pieczenia Kasia 1 opak, mleko 150 ml, cukier 150 g, cukier wanilinowy 1 łyżeczka, mleko w proszku 300 g, wierzch: mleczna czekolada 100 g, śmietanka 30% 50 ml, orzeszki ziemne niesolone 100 g, draże orzechowe do dekoracji", 40, "Łatwy", 5, 1200, "Ciasta", 1, now(), now()),
	("Ciasto mleczna kanapka", 3, "Białka oddzielić od żółtek i ubić z cukrem na sztywną pianę. Ciągle ubijając, dodać do piany żółtka. Następnie dodać sok z cytryny, olej i dalej ubijać. Mąkę wymieszać z kakao, proszkiem do pieczenia, przesiać i delikatnie połączyć z masą jajeczną. Ciasto wylać na dno wyłożonej papierem do pieczenia formy o wymiarach 20 x 20 cm. Piec w temp. 180 stopni przez około 30 minut. Wyjąć z formy i odwrócić do góry dnem. Mleko zagotować z cukrem i wystudzić. Miękką Kasię utrzeć na krem. Ciągle ucierając, wlewać cienkim strumieniem mleko z cukrem. Następnie dodawać małymi porcjami mleko w proszku i serek. Cały czas ucierać. Upieczone i wystudzone ciasto przeciąć na dwa placki i przełożyć kremem. Lekko docisnąć. Czekoladę, mleko i Kasię roztopić w kąpieli wodnej. Otrzymaną masą polać wierzch ciasta i odstawić do zastygnięcia.", "ciasto: jajka 3 szt., cukier 100 g, sok z cytryny 1 łyżeczka, olej 2 łyżki, mąka pszenna 50 g, kakao 15 g, proszek do pieczenia 0,5 łyżeczek krem: Kostka do pieczenia Kasia 125 g, mleko 0,25 szklanek, cukier 0,25 szklanek, mleko w proszku 120 g, serek śmietankowy (np. Bieluch) 100 g dodatkowo: czekolada mleczna 100 g, mleko 2 łyżki, Kostka do pieczenia Kasia 0,1 opak.", 30, "Łatwy", 5, 1200, "Ciasta", 1, now(), now()),
	("Gulasz z kiełbasek", 2, "Kiełbasę pokrój w plasterki, a boczek w kostkę. Całość usmaż na dużej patelni bez dodatku tłuszczu. Całą włoszczyznę dokładnie umyj, obierz i pokrój w kostkę. Cebulę i czosnek posiekaj. Dodaj wszystkie warzywa do kiełbasy i boczku. Całość smaż około 10 minut, mieszając od czasu do czasu. Zalej gulasz 500 ml wody i dodaj Knorr Naturalnie Smaczne - Gulasz. Dokładnie wymieszaj. Na koniec dodaj koncentrat pomidorowy oraz odcedzoną fasolkę. Duś jeszcze około 15 minut. Udekoruj natką pietruszki. Taki gulasz podawaj z kromką chleba lub bułką.", "cienkie kiełbask i8 szt., naturalnie smaczne Gulasz Knorr 1 opak., woda 500 ml, boczek wędzony 8 plastrów, włoszczyzna 1 pęczek, cebula 1 szt., ząbki czosnku 2 szt., koncentrat pomidorowy 1 opak., fasola biała konserwowa 1 opak., natka pietruszki do dekoracji", 60, "Banalny", 4, 800, "Dania główne", 1, now(), now()),
	("Holiszki", 1, "Zagotuj wodę w dużym garnku, włóż kapustę. Gotuj na małym ogniu 5 minut. Zostaw do ostygnięcia w wodzie. Oddziel liście, skrój twarde włókna. Zamiast blanszować, możesz główkę kapusty włożyć do zamrażarki na 2-3 dni. Po odmrożeniu liście łatwo się rozdzielą i będą miękkie. Wszystkie składniki farszu starannie wymieszaj. Dodaj Esencję do duszonych mięs Knorr. Na każdy liść nałóż łyżkę farszu, następnie go zwiń. Sos pomidorowy Knorr przygotuj według przepisu na opakowaniu, zagotuj i zalej gołąbki. Gołąbki ułóż w żaroodpornym naczyniu. Piecz pod przykryciem w nagrzanym do 150°C piekarniku. Następnie zdejmij pokrywkę i zapiekaj potrawę jeszcze przez pół godziny. Po zapieczeniu potrawy i zdjęciu pokrywki, dodaj do sosu 2 - 3 łyżki miodu i sok z 1 cytryny. Zapiekaj jeszcze przez pół godziny. Gołąbki maja wówczas odmienny, słodko-kwaśny smak.", "duża główka kapusty 1 szt., Esencja do duszonych mięs Knorr 1 szt., Sos pomidorowy Knorr, sok z 1 cytryny, miód 3 łyżki, farsz: mielona wołowina 750 g, ryż 4 łyżki, średnia cebula 1 szt., rozgniecione ząbki czosnku 2 szt., Pieprz czarny z Wietnamu mielony Knorr 1 szczypta, sól 1 szczypta, jajka 2 szt., zimna woda 3 łyżki", 90, "Średni", 6, 1100, "Dania główne", 1, now(), now()),
	("Bigos domowy", 3, "Kapustę białą poszatkuj, a kiszoną przetnij 2 razy, żeby ją rozdrobnić. Cebulę obierz i pokrój w kostkę, podsmaż w garnku i dodaj kapusty. Podlej winem, dodaj liść laurowy i ziele angielskie. Boczek, szynkę i kiełbasę pokrój w kostkę. Podsmaż na patelni, lekko posypując przyprawą Delikat Knorr. Mięso dodaj do kapusty. Duś 60 min. Dopraw do smaku przyprawą Delikat Knorr. Czynność z duszeniem można powtarzać przez 3 dni dla lepszego smaku. Podawaj w misce odgrzane porcje.", "kapusta kiszona 300 g, kapusta biała 300 g, Delikat przyprawa uniwersalna Knorr, kiełbasa zwyczajna 150 g, szynka wieprzowa 200 g, boczek wędzony 200 g, cebula biała 1 szt., Ziele angielskie z Meksyku Knorr 2 szt., Liść laurowy z Turcji Knorr 3 szt., Pieprz czarny z Wietnamu ziarnisty Knorr 3 szt., margaryna do smażenia, woda 100 ml", 90, "Łatwy", 4, 1200, "Dania główne", 1, now(), now()),
	("Krokiety z szynki", 1, "Na głębokiej patelni stop masło, oprósz mąką i zasmaż na złoty kolor. Wlej mleko, wymieszaj, ciągle gotując, aż sos zgęstnieje. Wsyp parmezan i dokładnie wymieszaj, aż sos zgęstnieje i zrobi się gładki. Wstaw na 4 godziny do lodówki. Następnie dodaj pokrojoną w niedużą kostkę szynkę. Z przygotowanej masy formuj 12 krokiecików. Panieruj najpierw w 1 rozmąconym jajku, następnie w Fixie Knorr. W garnku rozgrzej olej, smaż krokieciki na złoty kolor i odsącz z tłuszczu na ręczniku papierowym. Podawaj gorące z sosem meksykańskim Knorr wymieszanym z majonezem i ketchupem.", "suszona szynka serrano5 dag, Fix Nuggetsy z sosem meksykańskim Knorr 1 opak., parmezan tarty 60 g, jajko 1 szt., masło 6 łyżek, mąka 8 łyżek, mleko 1 szklanka, olej do smażenia 0,5 l, Majonez Hellmanns Babuni 2 łyżki, Ketchup Hellmanns Łagodny 2 łyżki", 30, "Łatwy", 8, 700, "Dania główne", 1, now(), now()),
	("Murzynek", 3, "Kasię, mleko, kakao i cukier włóż do rondelka, gotuj aż cukier się rozpuści i masa stanie się gładka i lśniąca. Z powstałej masy odlej 2/3 szklanki, a resztę wlej do miski. Mąkę wymieszaj z proszkiem do pieczenia i wsyp do masy kakaowej. Wymieszaj mieszadłami miksera. Żółtka oddziel od białek. Dodawaj do ciasta po jednym żółtku ciągle mieszając. Białka ubij mikserem na sztywną pianę. Przełóż do ciasta i wymieszaj delikatnie łyżką. Ciasto przełóż do podłużnej formy, wyłożonej papierem do pieczenia o wymiarach ok.10 x 30 cm. Piecz 50 minut w 180 st.C Upieczone ciasto wyjmij z formy. Gdy lekko przestygnie posmaruj pozostałą masą kakaową i odstaw do zastygnięcia.", "Kostka do pieczenia Kasia 1 opak., mleko 0,5 szklanek, cukier 1,5 szklanka, jajka 4 szt., kakao 4 łyżki, mąka pszenna 340 g, proszek do pieczenia 10 g", 60, "Bardzo trudny", 4, 500, "Ciasta", 1, now(), now()),
	("Tradycyjne kotlety de volaille", 4, "Piersi z kurczaka zaczynając od środka rozetnij delikatnie nożem, tak aby mięso można było rozłożyć na zewnątrz – uważaj przy tym aby mięsa odciąć od reszty kotleta. Rozciętą pierś rozbij dokładnie na cienki plasterek. Mięso delikatnie oprósz solą i pieprzem. Masło pomieszaj z posiekanym koperkiem, w ręku uformuj je w podłużny kawałek. Połóż z brzegu kotleta. Mięso zroluj dokładnie przykrywając cały tłuszcz. Zrób to dokładnie inaczej masło wypłynie ze środka. Uformowane kotlety w podłużny walec zwężający się na końcach, oprósz mąką i panieruj w roztrzepanym jajku, a następnie obtocz w tartej bułce. Końcówki kotleta dobrze jest panierować podwójnie zapobiega to wyciekaniu masła ze środka. Na patelni rozgrzej Ramę, poczekaj aż z powierzchni tłuszczu znikną bąbelki, będzie to oznaczać,że osiągnął on odpowiednią temperaturę. Kotlety smaż z każdej strony na złoty kolor. Po usmażeniu trzymaj je jeszcze na patelni pod przykryciem około 5 minut lub dopiecz w piekarniku – tak aby były na pewno upieczone w środku.", "Pierś z kurczaka 4 szt., rama smaż jak szef kuchni 200 ml, masło 200g, koperek 1 pęczek, jajka 2 szt., bułka tarta 100 g, mąka pszenna 100 g,  sól 1 szczypta, pieprz 1 szczypta", 30, "Łatwy", 4, 1100, "Dania główne", 1, now(), now()),
	("Zupa rybna", 5, "Warzywa umyć. Marchewkę, pietruszkę i selera obrać i zetrzeć na tarce o większych oczkach. Pora pokroić wzdłuż na 4 części, następnie w poprzek na plasterki. Cebulę pokroić w kosteczkę. W szerszym garnku na łyżce oliwy i łyżce masła zeszklić cebulę. Następnie dodać pora i smażyć dalej co chwilę mieszając przez ok. 2 minuty. Dodać marchewkę, pietruszkę i selera. Warzywa doprawić solą i pieprzem i smażyć przez około 3 minuty. Dodać przyprawy i wymieszać. Wlać gorący bulion i zagotować. Dodać przecier pomidorowy oraz pomidory (świeżego pomidora należy sparzyć, obrać ze skórki, pokroić w kosteczkę usuwając szypułki). Zupę po zagotowaniu przykryć, zmniejszyć ogień i gotować przez ok. 10 minut do miękkości warzyw. Rybę opłukać, odciąć skórę i wyjąć ości. Pokroić w kostkę, doprawić solą i włożyć w mleko. Następnie obtoczyć w mące i krótko obsmażyć na patelni z łyżką rozgrzanego masła i łyżką oliwy. Podsmażoną rybę włożyć do garnka z zupą i gotować przez ok. 2 - 3 minuty. Dodać posiekaną bazylię lub natkę pietruszki. Podawać z pieczywem.", "500 g świeżych filetów ryby np.sandacz, miruna, dorsz, 1,5 litra bulionu jarzynowego, 1/2 cebuli, 1 marchewka, 1 mała pietruszka, 1/4 korzenia selera, 1 mały por, 1 świeży pomidor, sól i świeżo zmielony pieprz, 2 listki laurowe, 4 ziela angielskie, 1 łyżeczka suszonego oregano, 1 łyżka oliwy, 1 łyżka masła, 2 łyżki mąki pszennej, 1 łyżka posiekanej bazylii", 60, "Średni", 1, 500, "Zupy", 1, now(), now()),
	("Sałatka jarzynowa", 6, "Ziemniaki, marchewkę i pietruszkę umyć (nie obierać), włożyć do garnka, zalać wodą, posolić i gotować pod przykryciem do miękkości, przez ok. 40 minut. Odcedzić, ostudzić, obrać ze skórek i pokroić w kosteczkę, włożyć do dużej miski. Jajka ugotować na twardo (ok. 5 - 6 minut licząc od zagotowania się wody), pokroić w kosteczkę, dodać do miski z jarzynami. Ogórki, cebulę oraz jabłko obrać i pokroić w kosteczkę, dodać do miski. Wsypać dobrze odsączony i osuszony groszek. Całość doprawić solą (około 1/2 łyżeczki) oraz zmielonym czarnym pieprzem (około 1/2 łyżeczki). Wymieszać z majonezem (kilka łyżek zostawić do dekoracji) oraz musztardą. Przełożyć do salaterki i pokryć odłożonym majonezem, udekorować wedle uznania.", "3 ziemniaki, 2 marchewki, 1 pietruszka, 4 jajka, 3 ogórki kiszone, 1/4 cebuli, 1/2 jabłka, 1 mała puszka zielonego groszku, ok. 1 szklanka majonezu, 1 łyżeczka musztardy", 60, "Łatwy", 4, 400, "Sałatki", 1, now(), now()),
	("Ryż z owocami morza", 7, "Ryż ugotuj w wodzie tak, aby był sypki. Następnie odcedź. Na oliwie podsmaż posiekany czosnek i mieszankę owoców morza. Następnie dodaj curry i ryż. Całość smaż jeszcze kilka minut. Fix Knorr wymieszaj ze szklanką wody. Wlej sos na patelnię. Dodaj pomidory pokrojone w kostkę (bez pestek) i sok z cytryny. Całość smaż, aż większość płynu wyparuje. Podawaj ze świeżą kolendrą.", "mieszanka owoców morza 400 g, ryż basmati 300 g, fix Smażony ryż po chińsku Knorr 1 opak., pomidory 2 szt., ząbki czosnku 2 szt., woda 1 szklanka, cytryna 1 szt., curry knorr 1 łyżka, kolendra 0,5 pęczków, oliwa 50 ml", 40, "Trudny", 4, 300, "Wege", 1, now(), now()),
	("Sałatka gyros", 5, "Mięso pokrój w paski i oprósz Fixem Knorr. Usmaż na patelni i odstaw do ostygnięcia. Przygotuj sos, mieszając Ketchup Hellmann’s Pikantny z Majonezem Babuni Hellmann's i sosem czosnkowym z opakowania Fix Knorr. Kapustę pokrój w paski, pomidory, cebulę i ogórki w kostkę, a kukurydzę odcedź. Składniki układaj warstwowo w misce. Zacznij od kapusty, potem dodawaj kolejno pozostałe warzywa i mięso. Warstwy przekładaj co jakiś czas sosem.", "pierś z kurczaka 300 g, Fix Kebab z sosem czosnkowym Knorr 1 opak., kapusta pekińska 300 g, pomidory 2 szt., czerwona cebula 2 szt., kukurydza z puszki 1 opak., ogórki konserwowe 4 szt., Majonez Hellmann's Babuni 100g, Ketchup Hellmann's Extra Hot, olej do smażenia 5 łyżek", 50, "Banalny", 4, 400, "Sałatki", 1, now(), now()),
	("Piernik", 4, "Piekarnik nagrzać do 180 stopni C. Pokrojone masło włożyć do rondelka, dodać kakao, przyprawę piernikową, miód. Mieszając rozpuścić składniki na gładką masę. Odstawić z ognia, dodać mleko i wymieszać, następnie dodać jajka i rozmieszać rózgą. Do czystej miski wsypać mąkę, dodać cukier, sodę i proszek do pieczenia, wymiesza. Wlać masę z rondelka i zmiksować na małych obrotach miksera (dokładnie, ale tylko do połączenia się składników w jednolite ciasto). Masę wlać do formy o wymiarach ok. 20 x 30 cm wyłożonej papierem do pieczenia i wstawić do piekarnika na 25 - 30 minut (do suchego patyczka). Wyjąć ciasto z piekarnika i ostudzić, następnie przekroić poziomo na 2 blaty. Dolny posmarować powidłami, przykryć drugim, wierzch posmarować polewą: w garnuszku roztapiać na małym ogniu ciągle mieszając połamaną na kosteczki czekoladę i pokrojone masło. Udekorować orzechami lub suszonymi śliwkami. Przechowywać w pojemniku na ciasto.", "100 g masła, 2 łyżki kakao, 2 łyżki przyprawy piernikowej, 2 łyżki miodu, 250 ml mleka, 3 jajka, 200 g mąki, 200 g cukru, 1 i 1/3 łyżeczki sody oczyszczonej, 3/4 łyżeczki proszku do pieczenia", 60, "Średni", 10, 1400, "Desery", 1, now(), now());
	
insert into opinie (id_przepisu, id_autora, id_oceny, komentarz, data_opinii) values
	(1, 2, 4, "Bardzo smaczne", now()),
	(2, 3, 3, "moglo by byc lepsze", now()),
	(3, 4, 2, "nie smakowało mi", now()),
	(4, 5, 1, "obrzydliwe", now()),
	(5, 1, 4, "Bardzo dobry przepis ale nie przepis nie jest jasny ;/" , now()),
	(6, 2, 4, "Smaczne ale jadłem lepsze", now()),
	(7, 3, 5, "Najlepsze co w życiu jadłem tak", now()),
	(8, 4, 5, "Bardzo dobre", now()),
	(9, 5, 2, "Szału nie ma, **** nie urywa", now()),
	(10, 6, 5, "Bardzo dobre gorąco wszytstkim polecam! :D", now()),
	(11, 4, 4, "Fajne ale moglo by być lezpsze.", now()),
	(12, 7, 5, "Zrobiłem swojemu wynkowi i bardzo mu smakowało. Gorąco polecam i pozdrawiam.", now()),
	(13, 3, 4, "Mi smakowało ale Mariuszowi już nie", now());
	
DELIMITER $$
CREATE TRIGGER data_dod_uz
BEFORE INSERT ON uzytkownicy
FOR EACH ROW 
SET NEW.data_dodania = now(),
NEW.data_modyfikacji = now();
$$

DELIMITER $$
CREATE TRIGGER data_dod_prze
BEFORE INSERT ON przepisy
FOR EACH ROW 
SET NEW.data_dodania = now(),
NEW.data_modyfikacji = now();
$$

DELIMITER $$
CREATE TRIGGER data_dod_op
BEFORE INSERT ON opinie
FOR EACH ROW 
SET NEW.data_opinii = now();
$$

DELIMITER $$
CREATE TRIGGER mody_uz
BEFORE UPDATE ON uzytkownicy
FOR EACH ROW BEGIN
SET NEW.data_modyfikacji = now();
END;
$$

DELIMITER $$
CREATE TRIGGER mody_przey
BEFORE UPDATE ON przepisy
FOR EACH ROW BEGIN
SET NEW.data_modyfikacji = now();
END;
$$

CREATE VIEW widok_przepis AS SELECT * FROM przepisy;
	


	
	
	
	


	
	
	
	 

	 


 




