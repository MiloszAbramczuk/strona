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
	("??atwy"),
	("??redni"),
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
    ("Dania g????wne"),
    ("Desery"),
    ("Grill"),
    ("Kanapki"),
    ("Kluski"),
    ("Makarony"),
    ("Nale??niki"),
    ("Alkohole"),
    ("Koktajle"),
    ("Pieczywo"),
    ("Pierogi"),
    ("Pizza"),
    ("Placki"),
    ("Przek??ski"),
    ("Przetwory"),
    ("Przystawki"),
    ("Sa??atki"),
    ("Sosy"),
    ("??niadania"),
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
	("Pizza Capricciosa", 2, "Przygotowa?? ciasto wg ulubionej receptury. Wyro??ni??te ciasto wy??o??y?? w blaszce, uformowa?? brzegi. Posmarowa?? sosem pomidorowym. Nagrza?? piekarnik do  250C. Pieczarki pokroi?? w plasterki, szynk?? w paseczki. Mozzarell?? potrze?? na tarce lub pokroi?? w plasterki. Ewentualnie mo??na mozzarell?? zast??pi?? ??????tym serem. Na pizzy u??o??y?? kolejno: szynk??, ser i pieczarki. Wstawi?? pizz?? do piekarnika i piec ok. 7-10 minut. Pizz?? lekko ostudzi??, najlepiej na kratce. Podawa?? z ulubionymi sosami.", "M??ka pszenna tortowa 3 szklanki (po 250ml), Dro??d??e 40g, S??l 1 ??y??eczka, Bazylia 1-2 ??y??eczki, Oregano 1-2 ??y??eczki, Woda 1 szklanka (250 ml ; temp 40-50C), Oliwa z oliwek 3 ??y??eczki, Pomidory w puszce 1 puszka, Pieczarki kilka sztuk, Szynka kilka plasterk??w, Mozzarella 300g", 60, "??redni", 4, 450, "Pizza", 1, now(), now()),
	("Szarlotka", 5, "Przygotowa?? ciasto kruche: Z m??ki, cukru, cukru waniliowego, mas??a (pokrojonego na ma??e kawa??ki), jajka i proszku do pieczenia zagnie???? jednolite ciasto r??k?? lub robotem kuchennym. Z ciasta uformowa?? kul??, lekko j?? sp??aszczy?? i owin???? w foli?? spo??ywcz??. Wstawi?? do lod??wki na czas przygotowania musu jab??kowego. Przygotowa?? mus jab??kowy: Jab??ka umy??, obra??, usun???? gniazda nasienne i pokroi?? w niedu???? kostk?? lub zetrze?? na tarte. Wymiesza?? z 2 ??y??kami cukru i przesma??y??, a?? powstanie mus. (Gdyby mus by?? mocno wodnisty sma??y??, a?? nadmiar soku wyparuje). Wmiesza?? cynamon i pozostawi?? do ostygni??cia. Form?? kwadratow?? o wymiarach ok. 24x 24 cm wy??o??y?? papierem do pieczenia. (Mo??na najpierw delikatnie posmarowa?? w kilku miejscach form?? mas??em lub margaryn??. Wtedy wy??o??enie formy papierem p??jdzie sprawniej, bo przyklei si?? on do t??uszczu). Po??ow?? ciasta wyklei?? na dnie formy. Wy??o??y?? mus jab??kowy. Z pozosta??ego ciasta odrywa?? kawa??ki i uk??ada?? je na musie jab??kowym. (Mo??na r??wnie?? ciasto rozwa??kowa??).", "Ciasto kruche: 2 szklanki m??ki pszennej (300 g), 3 ??y??ki cukru, 2 ??y??eczki cukru waniliowego, 250 g mas??a, zimnego, 2 p??askie ??y??eczki proszku do pieczenia, 1 jajko (rozmiar M), Mus jab??kowy: ok. 1,5 kg jab??ek (polecam Szar?? Renet??), 1 ??y??eczka cynamonu, 2 ??y??ki cukru", 240, "??redni", 12, 1200, "Ciasta", 1, now(), now()),
	("Duszona kark??wka w sosie w??asnym z cebul??", 2, "Mi??so op??ucz i pokr??j na kotlety grubo??ci 2 cm. Ka??dy rozbij lekko t??uczkiem, posyp pieprzem i opr??sz m??k??. W nast??pnej kolejno??ci obsma?? je z obu stron na z??oty kolor na rozgrzanym oleju. Cebule pokr??j w pi??rka i przesma?? w garnku na rozgrzanym oleju, dodaj majeranek, li???? laurowy oraz ziele. Gdy cebula nabierze z??otego koloru, wsyp pozosta???? m??k?? i przesma?? razem. Nast??pnie dodaj 1 l wrz??cej wody. W?????? mi??so, Esencj?? do duszonych mi??s Knorr i du?? na ma??ym ogniu do momentu, gdy kark??wka b??dzie mi??kka. Podawaj z ziemniakami lub kasz??.", "600g kark??wki wieprzowej, Esencja do duszonych mi??s Knorr, woda, majeranek, cebula, m??ka, ziele angielskie, olej do sma??enia", 60, "??atwy", 4, 1400, "Dania g????wne", 1, now(), now()),
	("Pieczony kurczak z ziemniakami", 3, "Stw??rz b??yskawiczn?? marynat??, mieszaj??c przypraw?? Knorr z olejem, papryk?? i oregano. Natrzyj ni?? kurczaka z zewn??trz i od ??rodka. Je??li lubisz potrawy pikantne do marynaty dodaj r??wnie?? troch?? ostrej papryki. Ziemniaki obierz i przekr??j na cztery cz????ci. Kurczaka i ziemniaki umie???? w brytfance, piecz 60 minut w 190 ??C.", "kurczak (ok. 1,5 kg)1 szt. Przyprawa do z??otego kurczaka Knorr (4 ??y??ki), ziemniaki 800g, Papryka s??odka z Hiszpanii Knorr 1 ??y??eczka, Oregano z Turcji Knorr 1 ??y??eczka, olej2 ??y??ki", 60, "??atwy", 4, 1100, "Dania g????wne", 1, now(), now()),
    ("Kremowa zupa z kurek", 1, "Ugotuj bulion z porcji roso??owej, przypraw oraz warzyw. Nast??pnie odced?? go. Obierz ziemniaki, pokr??j je w kostk?? i dodaj do odcedzonego bulionu. Umyj kurki, po czym dodaj je do wywaru wraz z kostkami roso??owymi Knorr oraz majerankiem. Gotuj ca??o???? do momentu, gdy ziemniaki b??d?? mi??kkie. Dolej do zupy piwo oraz ??mietan?? i mocno j?? podgrzej. Podawaj porcje zupy, na talerzach, udekorowan?? siekanym szczypiorkiem.", "porcja roso??owa 500 g, Ros???? z kury Knorr 2 szt, ??wie??e kurki 200 g, ??redniej wielko??ci ziemniaki 4 szt, pietruszka 1 szt, cebula 1 szt, ciemne piwo 100 ml, Majeranek z kraj??w ??r??dziemnomorskich Knorr 1 ??y??ka, Ziele angielskie z Meksyku Knorr 4 ziarna, Pieprz czarny z Wietnamu ziarnisty Knorr 5 ziaren, ??mietana 22% p???? szklanki, p??czek szczypioru 1 szt, seler 05 szt.", 60, "??atwy", 4, 600, "Zupy", 1, now(), now()),
    ("Placki ziemniaczane", 3, "Obierz ziemniaki, zetrzyj na tarce. Ods??cz mas?? przez sito. Zetrzyj cebul?? na tarce. Dodaj do ziemniak??w cebul??, jajka, ga??k?? muszkato??ow?? oraz mini kostk?? Knorr. Wymieszaj wszystko dobrze, dodaj m??k??, aby nada?? masie odpowiedni?? konsystencj??. Rozgrzej na patelni olej, nak??adaj mas?? ??y??k??. Sma?? placki z obu stron na z??oty br??z i od razu podawaj.", "ziemniaki 1 kg, cebula 1 szt, jajka 2 szt, Przyprawa w Mini kostkach Czosnek Knorr, Ga??ka muszkato??owa z Indonezji Knorr 1 szczypta, s??l 1 szczypta, m??ka", 30, "??redni", 8, 1000, "Placki", 1, now(), now()),
	("Pierogi z jab??kami i cynamonem", 2, "M??k?? wymieszaj z jajkiem, sol?? oraz oliw??. Nast??pnie dodaj szklank?? wody i wyr??b a?? ciasto b??dzie g??adkie. Jab??ka wyczy????, obierz i pokr??j w kostk??, a nast??pnie prze?????? do garnka i posyp cynamonem, cukrem waniliowym i cukrem oraz dolej odrobin?? wody. Gotuj na wolnym ogniu cz??sto mieszaj??c przez oko??o 10-15 minut a?? jab??ka b??d?? mi??kkie a sok wyparuje. Ciasto wa??kuj i wytnij k????ka. Nak??adaj farsz na ka??dego pieroga i dobrze sklej. Wrzucaj do wrz??cej, lekko osolonej wody i czekaj a?? pierogi wyp??yn??. Pierogi mo??na poda?? polane roztopionym mas??em i posypane cukrem.", "jab??ka 1 kg, m??ka 500 g, ciep??a woda 1 szkalnka, jajko 1 sztk, cynamon 2 ??y??eczki, cukier waniliowy 1 opak., cukier 0,5 szkalnaki, s??l, oliwa 3 ??y??ki", 45, "??atwy", 6, 600, "Pierogi", 1, now(), now()),
	("Grzybowa po m??sku", 1,  "Umyj i namocz grzyby, nast??pnie gotuj je przez 40 minut. Drobno pokr??j warzywa i podsma?? je na oleju. Zalej 2 szklankami wody i gotuj przez 25 minut. Po????cz ze sob?? oba wywary, nast??pnie przeced??. Pokr??j grzyby i dodaj do wywaru wraz z kostkami Roso??u wo??owego Knorr. Dodaj szklank?? mleka i dopraw pieprzem. Zup?? podawaj z makaronem.", "suszone grzyby 30 gram??w, ros???? wo??owy Knorr 2 szt., cebule 2 szt., marchewki 2 szt., ma??y seler 1 szt., woda 2 szk., mleko 1 szklanka, pieprz do smaku 1 szczypta, olej 2 ??y??ki, makaron wst????ki 1 opakowanie", 60, "??atwy", 4, 700, "Zupy", 1, now(), now()),
	("Oponki z cukrem", 2, "Dro??d??e rozpu???? w letnim mleku. W misce wymieszaj m??k??, s??l, cukier. Dodaj ??????tko, wod?? i rozpuszczone w mleku dro??d??e. Wymieszaj. Kasi?? sch??od?? w zamra??arce. Ciasto prze?????? na podsypany m??k?? st???? i dobrze zagnie??. Powinno by?? zwarte i odchodzi?? od sto??u i r??k. Ciasto odstaw w ciep??e miejsce do wyro??ni??cia na oko??o 60 minut. Powinno podwoi?? obj??to????. Wyro??ni??te ciasto jeszcze raz zagnie?? i rozwa??kuj na placek grubo??ci 1 cm. Na po??owie ciasta u?????? cienkie plastry sch??odzonej Kasi i przykryj drug?? po??ow?? ciasta. Brzegi sklej dociskaj??c ciasto palcami. Ciasto rozwa??kuj na du??y prostok??t, a nast??pnie z?????? w kopert??. Czynno???? sk??adania i rozwa??kowywania powt??rz kilka razy. Ostatecznie ciasto powinno mie?? grubo???? ok. 1 cm. Z ciasta wytnij metalow?? obr??cz?? k????ka o ??rednicy oko??o 6 cm, a nast??pnie wytnij w nich mniejsz?? obr??cz?? dziurki. Odstaw, aby podwoi??y obj??to????. W garnku rozgrzej olej. Wrzucaj p??czki i sma?? na ma??ym ogniu obracaj??c w czasie pieczenia. Os??cz na papierowym r??czniku. Cukier puder utrzyj z sokiem z cytryny na g??adki lukier i posmaruj nim wierzch p??czk??w.", "ciasto: m??ka pszenna 500 gram??w, Kostka do pieczenia Kasia 150 gram??w,woda 0.5 szklanek,mleko 0.5 szklanek,??????tko 1 sztuka,dro??d??e 20 gram??w, s??l 1 szczypta, cukier 50 gram??w, olej do sma??enia 1 litr lukier: cukier puder 250 gram??w, sok z cytryny 5 ??y??ek", 40, "Trudny", 2, 1200, "Ciastka", 1, now(), now()),
	("Leczo", 1, "Wszystkie warzywa pokr??j w grub?? kostk??. Przesma?? je na 4 ??y??kach oleju. Na oddzielnej patelni przesma?? pokrojon?? w kostk?? kie??bas?? i boczek. Po zarumienieniu si?? mi??s dodaj warzywa i zalej je niewielk?? ilo??ci?? wody. Dopraw do smaku papryk?? ostr??. Dodaj pokrojone pomidory i Knorr Ch??opski garnek, kiedy warzywa zmi??kn??. Gotuj przez 15 minut do zredukowania pomidor??w.", "boczek 400 gram??w kie??basa 400 gram??w, papryka czerwona 2 sztuki,seler naciowy 1 p??czek, Naturalnie smaczne Ch??opski Garnek Knorr 1 opakowanie, Papryka ostra z Hiszpanii Knorr 1 szczypta, krojone pomidory w puszce 800 gram??w bak??a??an 1 sztuka, cebula 1 sztuka, woda 200 mililitr??w, olej 4 ??y??ki", 30, "??atwy", 6, 800, "Dania g????wne", 1, now(), now()),
	("Placki z ziemnik??w", 3, "Rozgrzej piekarnik do 180??C. Ugotuj ziemniaki (oko??o 20 minut). Odced?? starannie i ut??ucz. Odstaw do ostygni??cia. Posiekaj drobno cebul??. Roztop mas??o na niewielkiej patelni i sma?? cebul?? 10 minut, a?? b??dzie mi??kka. Dodaj do ziemniak??w: cebul??, ??mietan??, ??????tka, przyprawy w mini kostkach Knorr. Wymieszaj dok??adnie. Przesiej m??k?? do garnka z ziemniakami i wymieszaj. Przypraw spor?? ilo??ci?? pieprzu i sol??, je??li uznasz, ??e jest to konieczne. Uformuj z masy ziemniaczanej kulki (oko??o 16). Sp??aszcz by powsta??y niewielkie placuszki o ??rednicy oko??o 6 centymetr??w. U?????? na lekko nat??uszczonej blasze do pieczenia i posmaruj roztrzepanym jajkiem. Posyp bu??k?? tart??. Piecz 30 minut, a?? si?? przyrumieni??.", "ziemniaki 450 gram??w, ??????tka 3 sztuki, cebula 1 sztuka, jajko 1 sztuka, Przyprawa w Mini kostkach Pietruszka Knorr, m??ka 25 gram??w, bu??ka tarta 25 gram??w, Przyprawa w Mini kostkach Czosnek Knorr, kwa??na ??mietana 3 ??y??ki, ??wie??o mielony czarny pieprz 1 szczypta, mas??o 2 ??y??ki", 60, "??redni", 4, 900, "Placki", 1, now(), now()),
	("Zapiekanka ziemniaczana z kie??bas??", 2, "Fix Knorr wymieszaj z bulionem i zagotuj. Nast??pnie odstaw do ostygni??cia. Kie??bas?? pokr??j w kost?? i usma??, a?? b??dzie rumiana. Ziemniaki pokr??j w cienkie plastry i wymieszaj z sosem oraz roztrzepanym jajkiem. Do masy ziemniaczanej dodaj kie??bas?? i wymieszaj. Foremk?? do pieczenia wysmaruj margaryn??. Wylej do niej przygotowan?? mas??. Wyr??wnaj wierzch. Posyp ca??o???? startym serem i zapiekaj w piekarniku rozgrzanym do 160 ??C przez 40 minut. Pod koniec pieczenia mo??esz zwi??kszy?? temperatur?? do 180 ??C, by zapiekanka si?? przypiek??a.", "ziemniaki 5 sztuk, Fix Spaghetti Carbonara Knorr 1 opakowanie, bulion 300 mililitr??w, kie??basa zwyczajna 1 sztuka, jajko 1 sztuka, ser ??????ty 80 gram??w, t??uszcz do wysmarowania formy", 60, "??atwy", 6, 1400, "Zapiekanki", 1, now(), now()),
	("Tort makowy z budyniem", 2, "Kasi?? rozpu???? w rondelku. ??????tka oddziel od bia??ek. Bia??ka ubij na sztywn?? pian?? z cukrem. M??k?? wymieszaj z proszkiem do pieczenia i makiem. Do ubitych bia??ek dodaj, mieszaj??c mikserem na wolnych obrotach, po jednym ??????tku, a nast??pnie po ??y??ce m??ki wymieszanej z proszkiem do pieczenia i makiem. Na koniec wlej rozpuszczon?? Kasi?? i delikatnie wymieszaj ??y??k??. Dno tortownicy o ??rednicy 26 cm. wy?????? papierem do pieczenia. Bok??w nie smaruj. Do formy w??????ciasto i piecz w 170 st.C oko??o 30 minut. Upieczone i wystudzone ciasto przekr??j na 3 kr????ki. Z jednej pomara??czy zetrzyj sk??rk??. Po??ow?? mleka zagotuj razem ze sk??rk?? pomara??czow??, w reszcie mleka rozprowad?? proszek budyniowy. Rozprowadzony proszek wlej do gotuj??cego mleka i gotuj ci??gle mieszaj??c, a?? powstanie g??sty budy??. Wystud??. Mi??kk?? Kasi?? ubij mikserem. Ci??gle ubijaj??c dodawaj po ??y??ce wystudzony budy??. Jeden kr????ek ciasta u?????? w tortownicy i posmaruj 1/3 przygotowanego kremu. Przykryj drugim kr????kiem ciasta i zn??w posmaruj cz????ci?? kremu. Tak samo post??p z trzecim kr????kiem i reszt?? kremu. Tort odstaw do lod??wki. P??atki migda??owe upra?? na suchej patelni. Pomara??cze i grejpfruty wyfiletuj. Sch??odzony tort posyp p??atkami migda??owymi i udekoruj cz??stkami cytrus??w.", "ciasto: Kostka do pieczenia Kasia 50 gram??w, cukier 160 gram??w, jajko 5 sztuk, m??ka 110 gram??w, suchy mak. 150 gram??w, proszek do pieczenia 1 ??y??eczka krem:Kostka do pieczenia Kasia 1 opakowanie, budy?? ??mietankowy z cukrem 3 opakowania, mleko 1 litr. wierzch: p??atki migda??owe - 75 gram??w, pomara??cza 2 sztuki, czerwony grejpfrut 2 sztuki", 45, "??atwy", 4, 900, "Ciasta", 1, now(), now()),
	("Jogurt naturalny z musem z owoc??w", 2, "Owoce umy??. Truskawki i bor??wki zmiksowa?? na g??adk?? mas??. Do prze??roczystej szklanki wkroi?? banana, a nast??pnie wla?? po??ow?? opakowania jogurtu. Posypa?? jogurt p??atkami owsianymi. Potem wla?? mas?? owocow??. Na wierzch doda?? reszt?? jogurtu. Ca??o???? posypa?? nasionami chia. W ramach dekoracji mo??na u??o??y?? ??wie??e listki mi??ty.", "jogurt naturalny 0% 600 g, truskawki 400 g, bor??wki 300 g, banan 280 g, nasiona chia 4 ??y??eczki, p??atki owsiane 4 ??y??ki", 15, "??atwy", 1, 150, "Desery", 1, now(), now()),
	("Placki dyniowe", 1, "Wszystkie sk??adniki wymieszaj ze sob?? w misce. Dopraw Delikatem i wyr??b na g??adk?? mas??. Na patelni rozgrzej Ram??, nak??adaj mas?? ??y??k?? i sma?? powsta??e placki na z??oty kolor. Sma????c na ramie nadasz specyficznego ma??lanego aromatu i jednocze??nie zachowasz czysto????, bo Rama nie pryska podczas sma??enia. Usma??one placki ods??cz z nadmiaru t??uszczu na papierowym r??czniku. Podawaj z ??y??k?? kwa??nej ??mietany lub g??stego jogurtu. Mo??esz udekorowa?? ulubionymi zio??ami.", "upieczona dynia 400 g, Rama Sma?? jak szef kuchni, wariant ma??lany smak 100 ml, Delikat przyprawa uniwersalna Knorr 0,5 ??y??eczek, m??ka pszenna 100 g, cebula 1 szt, starty imbir 10 g, z??bek czosnku 1 szt., jajko 1 szt., curry madras 1 ??y??ka", 15, "??atwy", 4, 500, "Placki", 1, now(), now()),
	("Krupnik domowy", 2, "Kasz?? dok??adnie wyp??ucz, nast??pnie zalej wod??, dodaj kostk?? Knorr i gotuj powoli, a?? lekko zmi??knie. Ziemniaki i marchew pokr??j w kostk??, a pora w plastry. W drugim garnku gotuj warzywa wraz z li??ciem laurowym i zielem angielskim. Gdy ziemniaki b??d?? p????mi??kkie, dodaj do zupy kasz?? wraz z p??ynem, w kt??rym si?? gotowa??a. Do ca??o??ci dodaj drug?? kostk?? oraz wod??, je??li uznasz to za konieczne. Gotuj zup?? jeszcze oko??o 20 minut. Ziemniaki i kasza powinny by?? zupe??niemi??kkie. Gotow?? zup?? podawaj posypan?? posiekan?? natk?? pietruszki.", "kasza j??czmienna 0.6 szklanek, Ros???? z kury Knorr 2 sztuki, marchewka 1 sztuka, por ma??y 1 sztuka, ziemniaki 200 gram??w, natka pietruszki 0.5 p??czk??w, Li???? laurowy z Turcji Knorr 2 sztuki, Ziele angielskie z Meksyku Knorr 3 sztuki", 60, "??atwy", 4, 400, "Zupy", 1, now(), now()),
	("Klasyczna zapiekanka ziemniaczana", 1, "Rozgrzej piekarnik do 200 ?? C. Zetrzyj ser na tarce. Ziemniaki obierz i pokr??j w cienkie plastry, czosnek zetrzyj na tarc. Foremk?? wy?????? pergaminem lub nat??u????. Knorr Naturalnie smaczne wymieszaj z mlekiem, czosnkiem i ziemniakami. Ziemniaki prze?????? do foremki, posyp z wierzchu serem. Ca??o???? przykryj foli?? aluminiow??, wstaw n 30 minut do piekarnika , po tym czasie usu?? foli??. Zapiekank?? piecz jeszcze 10-15 minut, a?? ziemniaki b??d?? zupe??nie mi??kkie, a wierzchnia warstwa zrobi si?? rumiana.", "ziemniaki 600 g, Naturalnie smaczne Zapiekanka makaronowa z szynk?? Knorr 1 opak., mleko 300 ml, twardy ser np. Ementaler 50 g, z??bek czosnku 1 szt.", 15, "??atwy", 5, 600, "Zapiekanki", 1, now(), now()),
	("Ciasto King Kong", 3, "Foremk?? o wymiarach 20x20 cm wy?????? papierem do pieczenia, a nast??pnie warstw?? herbatnik??w. Mleko podgrzej i rozpu???? w nim cukier i cukier wanilinowy. Wystud??. Orzeszki posiekaj i upra?? na suchej patelni. Mi??kk?? Kasi?? utrzyj na puszyst?? mas??. Ci??gle ucieraj??c wlewaj cienkim strumieniem mleko z cukrem i wsyp partiami mleko w proszku. Na herbatniki w formie wy?????? krem i przykryj kolejn?? warstw?? herbatnik??w. Na herbatnikach rozsmaruj mas?? kajmakow?? i ponownie przykryj herbatnikami. ??mietank?? podgrzej w rondelku, dodaj po??aman?? czekolad?? i mieszaj, a?? masa b??dzie g??adka. Dodaj orzeszki. Gotow?? mas?? rozprowad?? na herbatnikach. Ca??o???? odstaw na godzin?? do lod??wki.", "herbatniki typu Petit Beurre 42 szt., gotowa masa kr??wkowa 1 s??oik krem: Kostka do pieczenia Kasia 1 opak, mleko 150 ml, cukier 150 g, cukier wanilinowy 1 ??y??eczka, mleko w proszku 300 g, wierzch: mleczna czekolada 100 g, ??mietanka 30% 50 ml, orzeszki ziemne niesolone 100 g, dra??e orzechowe do dekoracji", 40, "??atwy", 5, 1200, "Ciasta", 1, now(), now()),
	("Ciasto mleczna kanapka", 3, "Bia??ka oddzieli?? od ??????tek i ubi?? z cukrem na sztywn?? pian??. Ci??gle ubijaj??c, doda?? do piany ??????tka. Nast??pnie doda?? sok z cytryny, olej i dalej ubija??. M??k?? wymiesza?? z kakao, proszkiem do pieczenia, przesia?? i delikatnie po????czy?? z mas?? jajeczn??. Ciasto wyla?? na dno wy??o??onej papierem do pieczenia formy o wymiarach 20 x 20 cm. Piec w temp. 180 stopni przez oko??o 30 minut. Wyj???? z formy i odwr??ci?? do g??ry dnem. Mleko zagotowa?? z cukrem i wystudzi??. Mi??kk?? Kasi?? utrze?? na krem. Ci??gle ucieraj??c, wlewa?? cienkim strumieniem mleko z cukrem. Nast??pnie dodawa?? ma??ymi porcjami mleko w proszku i serek. Ca??y czas uciera??. Upieczone i wystudzone ciasto przeci???? na dwa placki i prze??o??y?? kremem. Lekko docisn????. Czekolad??, mleko i Kasi?? roztopi?? w k??pieli wodnej. Otrzyman?? mas?? pola?? wierzch ciasta i odstawi?? do zastygni??cia.", "ciasto: jajka 3 szt., cukier 100 g, sok z cytryny 1 ??y??eczka, olej 2 ??y??ki, m??ka pszenna 50 g, kakao 15 g, proszek do pieczenia 0,5 ??y??eczek krem: Kostka do pieczenia Kasia 125 g, mleko 0,25 szklanek, cukier 0,25 szklanek, mleko w proszku 120 g, serek ??mietankowy (np. Bieluch) 100 g dodatkowo: czekolada mleczna 100 g, mleko 2 ??y??ki, Kostka do pieczenia Kasia 0,1 opak.", 30, "??atwy", 5, 1200, "Ciasta", 1, now(), now()),
	("Gulasz z kie??basek", 2, "Kie??bas?? pokr??j w plasterki, a boczek w kostk??. Ca??o???? usma?? na du??ej patelni bez dodatku t??uszczu. Ca???? w??oszczyzn?? dok??adnie umyj, obierz i pokr??j w kostk??. Cebul?? i czosnek posiekaj. Dodaj wszystkie warzywa do kie??basy i boczku. Ca??o???? sma?? oko??o 10 minut, mieszaj??c od czasu do czasu. Zalej gulasz 500 ml wody i dodaj Knorr Naturalnie Smaczne - Gulasz. Dok??adnie wymieszaj. Na koniec dodaj koncentrat pomidorowy oraz odcedzon?? fasolk??. Du?? jeszcze oko??o 15 minut. Udekoruj natk?? pietruszki. Taki gulasz podawaj z kromk?? chleba lub bu??k??.", "cienkie kie??bask i8 szt., naturalnie smaczne Gulasz Knorr 1 opak., woda 500 ml, boczek w??dzony 8 plastr??w, w??oszczyzna 1 p??czek, cebula 1 szt., z??bki czosnku 2 szt., koncentrat pomidorowy 1 opak., fasola bia??a konserwowa 1 opak., natka pietruszki do dekoracji", 60, "Banalny", 4, 800, "Dania g????wne", 1, now(), now()),
	("Holiszki", 1, "Zagotuj wod?? w du??ym garnku, w?????? kapust??. Gotuj na ma??ym ogniu 5 minut. Zostaw do ostygni??cia w wodzie. Oddziel li??cie, skr??j twarde w????kna. Zamiast blanszowa??, mo??esz g????wk?? kapusty w??o??y?? do zamra??arki na 2-3 dni. Po odmro??eniu li??cie ??atwo si?? rozdziel?? i b??d?? mi??kkie. Wszystkie sk??adniki farszu starannie wymieszaj. Dodaj Esencj?? do duszonych mi??s Knorr. Na ka??dy li???? na?????? ??y??k?? farszu, nast??pnie go zwi??. Sos pomidorowy Knorr przygotuj wed??ug przepisu na opakowaniu, zagotuj i zalej go????bki. Go????bki u?????? w ??aroodpornym naczyniu. Piecz pod przykryciem w nagrzanym do 150??C piekarniku. Nast??pnie zdejmij pokrywk?? i zapiekaj potraw?? jeszcze przez p???? godziny. Po zapieczeniu potrawy i zdj??ciu pokrywki, dodaj do sosu 2 - 3 ??y??ki miodu i sok z 1 cytryny. Zapiekaj jeszcze przez p???? godziny. Go????bki maja w??wczas odmienny, s??odko-kwa??ny smak.", "du??a g????wka kapusty 1 szt., Esencja do duszonych mi??s Knorr 1 szt., Sos pomidorowy Knorr, sok z 1 cytryny, mi??d 3 ??y??ki, farsz: mielona wo??owina 750 g, ry?? 4 ??y??ki, ??rednia cebula 1 szt., rozgniecione z??bki czosnku 2 szt., Pieprz czarny z Wietnamu mielony Knorr 1 szczypta, s??l 1 szczypta, jajka 2 szt., zimna woda 3 ??y??ki", 90, "??redni", 6, 1100, "Dania g????wne", 1, now(), now()),
	("Bigos domowy", 3, "Kapust?? bia???? poszatkuj, a kiszon?? przetnij 2 razy, ??eby j?? rozdrobni??. Cebul?? obierz i pokr??j w kostk??, podsma?? w garnku i dodaj kapusty. Podlej winem, dodaj li???? laurowy i ziele angielskie. Boczek, szynk?? i kie??bas?? pokr??j w kostk??. Podsma?? na patelni, lekko posypuj??c przypraw?? Delikat Knorr. Mi??so dodaj do kapusty. Du?? 60 min. Dopraw do smaku przypraw?? Delikat Knorr. Czynno???? z duszeniem mo??na powtarza?? przez 3 dni dla lepszego smaku. Podawaj w misce odgrzane porcje.", "kapusta kiszona 300 g, kapusta bia??a 300 g, Delikat przyprawa uniwersalna Knorr, kie??basa zwyczajna 150 g, szynka wieprzowa 200 g, boczek w??dzony 200 g, cebula bia??a 1 szt., Ziele angielskie z Meksyku Knorr 2 szt., Li???? laurowy z Turcji Knorr 3 szt., Pieprz czarny z Wietnamu ziarnisty Knorr 3 szt., margaryna do sma??enia, woda 100 ml", 90, "??atwy", 4, 1200, "Dania g????wne", 1, now(), now()),
	("Krokiety z szynki", 1, "Na g????bokiej patelni stop mas??o, opr??sz m??k?? i zasma?? na z??oty kolor. Wlej mleko, wymieszaj, ci??gle gotuj??c, a?? sos zg??stnieje. Wsyp parmezan i dok??adnie wymieszaj, a?? sos zg??stnieje i zrobi si?? g??adki. Wstaw na 4 godziny do lod??wki. Nast??pnie dodaj pokrojon?? w niedu???? kostk?? szynk??. Z przygotowanej masy formuj 12 krokiecik??w. Panieruj najpierw w 1 rozm??conym jajku, nast??pnie w Fixie Knorr. W garnku rozgrzej olej, sma?? krokieciki na z??oty kolor i ods??cz z t??uszczu na r??czniku papierowym. Podawaj gor??ce z sosem meksyka??skim Knorr wymieszanym z majonezem i ketchupem.", "suszona szynka serrano5 dag, Fix Nuggetsy z sosem meksyka??skim Knorr 1 opak., parmezan tarty 60 g, jajko 1 szt., mas??o 6 ??y??ek, m??ka 8 ??y??ek, mleko 1 szklanka, olej do sma??enia 0,5 l, Majonez Hellmanns Babuni 2 ??y??ki, Ketchup Hellmanns ??agodny 2 ??y??ki", 30, "??atwy", 8, 700, "Dania g????wne", 1, now(), now()),
	("Murzynek", 3, "Kasi??, mleko, kakao i cukier w?????? do rondelka, gotuj a?? cukier si?? rozpu??ci i masa stanie si?? g??adka i l??ni??ca. Z powsta??ej masy odlej 2/3 szklanki, a reszt?? wlej do miski. M??k?? wymieszaj z proszkiem do pieczenia i wsyp do masy kakaowej. Wymieszaj mieszad??ami miksera. ??????tka oddziel od bia??ek. Dodawaj do ciasta po jednym ??????tku ci??gle mieszaj??c. Bia??ka ubij mikserem na sztywn?? pian??. Prze?????? do ciasta i wymieszaj delikatnie ??y??k??. Ciasto prze?????? do pod??u??nej formy, wy??o??onej papierem do pieczenia o wymiarach ok.10 x 30 cm. Piecz 50 minut w 180 st.C Upieczone ciasto wyjmij z formy. Gdy lekko przestygnie posmaruj pozosta???? mas?? kakaow?? i odstaw do zastygni??cia.", "Kostka do pieczenia Kasia 1 opak., mleko 0,5 szklanek, cukier 1,5 szklanka, jajka 4 szt., kakao 4 ??y??ki, m??ka pszenna 340 g, proszek do pieczenia 10 g", 60, "Bardzo trudny", 4, 500, "Ciasta", 1, now(), now()),
	("Tradycyjne kotlety de volaille", 4, "Piersi z kurczaka zaczynaj??c od ??rodka rozetnij delikatnie no??em, tak aby mi??so mo??na by??o roz??o??y?? na zewn??trz ??? uwa??aj przy tym aby mi??sa odci???? od reszty kotleta. Rozci??t?? pier?? rozbij dok??adnie na cienki plasterek. Mi??so delikatnie opr??sz sol?? i pieprzem. Mas??o pomieszaj z posiekanym koperkiem, w r??ku uformuj je w pod??u??ny kawa??ek. Po?????? z brzegu kotleta. Mi??so zroluj dok??adnie przykrywaj??c ca??y t??uszcz. Zr??b to dok??adnie inaczej mas??o wyp??ynie ze ??rodka. Uformowane kotlety w pod??u??ny walec zw????aj??cy si?? na ko??cach, opr??sz m??k?? i panieruj w roztrzepanym jajku, a nast??pnie obtocz w tartej bu??ce. Ko??c??wki kotleta dobrze jest panierowa?? podw??jnie zapobiega to wyciekaniu mas??a ze ??rodka. Na patelni rozgrzej Ram??, poczekaj a?? z powierzchni t??uszczu znikn?? b??belki, b??dzie to oznacza??,??e osi??gn???? on odpowiedni?? temperatur??. Kotlety sma?? z ka??dej strony na z??oty kolor. Po usma??eniu trzymaj je jeszcze na patelni pod przykryciem oko??o 5 minut lub dopiecz w piekarniku ??? tak aby by??y na pewno upieczone w ??rodku.", "Pier?? z kurczaka 4 szt., rama sma?? jak szef kuchni 200 ml, mas??o 200g, koperek 1 p??czek, jajka 2 szt., bu??ka tarta 100 g, m??ka pszenna 100 g,  s??l 1 szczypta, pieprz 1 szczypta", 30, "??atwy", 4, 1100, "Dania g????wne", 1, now(), now()),
	("Zupa rybna", 5, "Warzywa umy??. Marchewk??, pietruszk?? i selera obra?? i zetrze?? na tarce o wi??kszych oczkach. Pora pokroi?? wzd??u?? na 4 cz????ci, nast??pnie w poprzek na plasterki. Cebul?? pokroi?? w kosteczk??. W szerszym garnku na ??y??ce oliwy i ??y??ce mas??a zeszkli?? cebul??. Nast??pnie doda?? pora i sma??y?? dalej co chwil?? mieszaj??c przez ok. 2 minuty. Doda?? marchewk??, pietruszk?? i selera. Warzywa doprawi?? sol?? i pieprzem i sma??y?? przez oko??o 3 minuty. Doda?? przyprawy i wymiesza??. Wla?? gor??cy bulion i zagotowa??. Doda?? przecier pomidorowy oraz pomidory (??wie??ego pomidora nale??y sparzy??, obra?? ze sk??rki, pokroi?? w kosteczk?? usuwaj??c szypu??ki). Zup?? po zagotowaniu przykry??, zmniejszy?? ogie?? i gotowa?? przez ok. 10 minut do mi??kko??ci warzyw. Ryb?? op??uka??, odci???? sk??r?? i wyj???? o??ci. Pokroi?? w kostk??, doprawi?? sol?? i w??o??y?? w mleko. Nast??pnie obtoczy?? w m??ce i kr??tko obsma??y?? na patelni z ??y??k?? rozgrzanego mas??a i ??y??k?? oliwy. Podsma??on?? ryb?? w??o??y?? do garnka z zup?? i gotowa?? przez ok. 2 - 3 minuty. Doda?? posiekan?? bazyli?? lub natk?? pietruszki. Podawa?? z pieczywem.", "500 g ??wie??ych filet??w ryby np.sandacz, miruna, dorsz, 1,5 litra bulionu jarzynowego, 1/2 cebuli, 1 marchewka, 1 ma??a pietruszka, 1/4 korzenia selera, 1 ma??y por, 1 ??wie??y pomidor, s??l i ??wie??o zmielony pieprz, 2 listki laurowe, 4 ziela angielskie, 1 ??y??eczka suszonego oregano, 1 ??y??ka oliwy, 1 ??y??ka mas??a, 2 ??y??ki m??ki pszennej, 1 ??y??ka posiekanej bazylii", 60, "??redni", 1, 500, "Zupy", 1, now(), now()),
	("Sa??atka jarzynowa", 6, "Ziemniaki, marchewk?? i pietruszk?? umy?? (nie obiera??), w??o??y?? do garnka, zala?? wod??, posoli?? i gotowa?? pod przykryciem do mi??kko??ci, przez ok. 40 minut. Odcedzi??, ostudzi??, obra?? ze sk??rek i pokroi?? w kosteczk??, w??o??y?? do du??ej miski. Jajka ugotowa?? na twardo (ok. 5 - 6 minut licz??c od zagotowania si?? wody), pokroi?? w kosteczk??, doda?? do miski z jarzynami. Og??rki, cebul?? oraz jab??ko obra?? i pokroi?? w kosteczk??, doda?? do miski. Wsypa?? dobrze ods??czony i osuszony groszek. Ca??o???? doprawi?? sol?? (oko??o 1/2 ??y??eczki) oraz zmielonym czarnym pieprzem (oko??o 1/2 ??y??eczki). Wymiesza?? z majonezem (kilka ??y??ek zostawi?? do dekoracji) oraz musztard??. Prze??o??y?? do salaterki i pokry?? od??o??onym majonezem, udekorowa?? wedle uznania.", "3 ziemniaki, 2 marchewki, 1 pietruszka, 4 jajka, 3 og??rki kiszone, 1/4 cebuli, 1/2 jab??ka, 1 ma??a puszka zielonego groszku, ok. 1 szklanka majonezu, 1 ??y??eczka musztardy", 60, "??atwy", 4, 400, "Sa??atki", 1, now(), now()),
	("Ry?? z owocami morza", 7, "Ry?? ugotuj w wodzie tak, aby by?? sypki. Nast??pnie odced??. Na oliwie podsma?? posiekany czosnek i mieszank?? owoc??w morza. Nast??pnie dodaj curry i ry??. Ca??o???? sma?? jeszcze kilka minut. Fix Knorr wymieszaj ze szklank?? wody. Wlej sos na patelni??. Dodaj pomidory pokrojone w kostk?? (bez pestek) i sok z cytryny. Ca??o???? sma??, a?? wi??kszo???? p??ynu wyparuje. Podawaj ze ??wie???? kolendr??.", "mieszanka owoc??w morza 400 g, ry?? basmati 300 g, fix Sma??ony ry?? po chi??sku Knorr 1 opak., pomidory 2 szt., z??bki czosnku 2 szt., woda 1 szklanka, cytryna 1 szt., curry knorr 1 ??y??ka, kolendra 0,5 p??czk??w, oliwa 50 ml", 40, "Trudny", 4, 300, "Wege", 1, now(), now()),
	("Sa??atka gyros", 5, "Mi??so pokr??j w paski i opr??sz Fixem Knorr. Usma?? na patelni i odstaw do ostygni??cia. Przygotuj sos, mieszaj??c Ketchup Hellmann???s Pikantny z Majonezem Babuni Hellmann's i sosem czosnkowym z opakowania Fix Knorr. Kapust?? pokr??j w paski, pomidory, cebul?? i og??rki w kostk??, a kukurydz?? odced??. Sk??adniki uk??adaj warstwowo w misce. Zacznij od kapusty, potem dodawaj kolejno pozosta??e warzywa i mi??so. Warstwy przek??adaj co jaki?? czas sosem.", "pier?? z kurczaka 300 g, Fix Kebab z sosem czosnkowym Knorr 1 opak., kapusta peki??ska 300 g, pomidory 2 szt., czerwona cebula 2 szt., kukurydza z puszki 1 opak., og??rki konserwowe 4 szt., Majonez Hellmann's Babuni 100g, Ketchup Hellmann's Extra Hot, olej do sma??enia 5 ??y??ek", 50, "Banalny", 4, 400, "Sa??atki", 1, now(), now()),
	("Piernik", 4, "Piekarnik nagrza?? do 180 stopni C. Pokrojone mas??o w??o??y?? do rondelka, doda?? kakao, przypraw?? piernikow??, mi??d. Mieszaj??c rozpu??ci?? sk??adniki na g??adk?? mas??. Odstawi?? z ognia, doda?? mleko i wymiesza??, nast??pnie doda?? jajka i rozmiesza?? r??zg??. Do czystej miski wsypa?? m??k??, doda?? cukier, sod?? i proszek do pieczenia, wymiesza. Wla?? mas?? z rondelka i zmiksowa?? na ma??ych obrotach miksera (dok??adnie, ale tylko do po????czenia si?? sk??adnik??w w jednolite ciasto). Mas?? wla?? do formy o wymiarach ok. 20 x 30 cm wy??o??onej papierem do pieczenia i wstawi?? do piekarnika na 25 - 30 minut (do suchego patyczka). Wyj???? ciasto z piekarnika i ostudzi??, nast??pnie przekroi?? poziomo na 2 blaty. Dolny posmarowa?? powid??ami, przykry?? drugim, wierzch posmarowa?? polew??: w garnuszku roztapia?? na ma??ym ogniu ci??gle mieszaj??c po??aman?? na kosteczki czekolad?? i pokrojone mas??o. Udekorowa?? orzechami lub suszonymi ??liwkami. Przechowywa?? w pojemniku na ciasto.", "100 g mas??a, 2 ??y??ki kakao, 2 ??y??ki przyprawy piernikowej, 2 ??y??ki miodu, 250 ml mleka, 3 jajka, 200 g m??ki, 200 g cukru, 1 i 1/3 ??y??eczki sody oczyszczonej, 3/4 ??y??eczki proszku do pieczenia", 60, "??redni", 10, 1400, "Desery", 1, now(), now());
	
insert into opinie (id_przepisu, id_autora, id_oceny, komentarz, data_opinii) values
	(1, 2, 4, "Bardzo smaczne", now()),
	(2, 3, 3, "moglo by byc lepsze", now()),
	(3, 4, 2, "nie smakowa??o mi", now()),
	(4, 5, 1, "obrzydliwe", now()),
	(5, 1, 4, "Bardzo dobry przepis ale nie przepis nie jest jasny ;/" , now()),
	(6, 2, 4, "Smaczne ale jad??em lepsze", now()),
	(7, 3, 5, "Najlepsze co w ??yciu jad??em tak", now()),
	(8, 4, 5, "Bardzo dobre", now()),
	(9, 5, 2, "Sza??u nie ma, **** nie urywa", now()),
	(10, 6, 5, "Bardzo dobre gor??co wszytstkim polecam! :D", now()),
	(11, 4, 4, "Fajne ale moglo by by?? lezpsze.", now()),
	(12, 7, 5, "Zrobi??em swojemu wynkowi i bardzo mu smakowa??o. Gor??co polecam i pozdrawiam.", now()),
	(13, 3, 4, "Mi smakowa??o ale Mariuszowi ju?? nie", now());
	
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
	


	
	
	
	


	
	
	
	 

	 


 




