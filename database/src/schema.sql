/*
 * Plik zawierający konfigurację tworzenia tabel do bazy danych 
 * zawierającej dane przepisów kulinarnych
 *
 * Autor: Tobiasz Piwowarczyk
 * Grupa: Z610
 * 
 */


DO
$do$
begin
    if not exists(SELECT datname FROM pg_catalog.pg_database where datname = 'recipe_catalog_app')
    then
        create database recipe_catalog_app;
    end if;
end
$do$;

\c recipe_catalog_app;





create table if not exists users_roles
(
      id                  serial not null primary key
    , name                varchar(30) not null unique
);



create table if not exists users
(
      id                  serial not null primary key
    , role_id             int not null references users_roles(id)
    , username            varchar(20) not null unique
    , password            varchar(30) not null
    , first_name          varchar(20) not null
    , last_name           varchar(30) not null
    , email_address       varchar(50) not null
    , created_date        timestamp not null default CURRENT_TIMESTAMP
);



create table if not exists recipe_catalog
(
      id                  serial not null primary key
    , name                varchar(100) not null unique
    , image_name          varchar(100) not null unique
);



create table if not exists recipe
(
      id                  serial not null primary key
    , user_id             int not null references users(id)
    , catalog_id          int not null references recipe_catalog(id)
    , name                varchar(100) not null
    , image_path          varchar(200) not null
    , description         varchar(20000) not null
    , created_date        TIMESTAMP not null default CURRENT_TIMESTAMP
    , level_of_difficulty int not null default 1 check (level_of_difficulty between 1 and 5)
    , creation_time       int not null check(creation_time > 0)
);



create table if not exists recipe_rating
(
      id                  serial not null primary key
    , recipe_id           int not null references recipe(id) ON DELETE CASCADE
    , user_id             int not null references users(id)
    , value               int not null check(value between 1 and 5)
    , created_date        timestamp not null default CURRENT_TIMESTAMP
);



create table if not exists recipe_comment
(
      id                  serial not null primary key
    , recipe_id           int not null references recipe(id) ON DELETE CASCADE
    , user_id             int not null references users(id)
    , content             varchar(1000) not null
    , likes               int not null default 0 check(likes >= 0)
    , dislikes            int not null default 0 check(dislikes >= 0)
    , created_date        timestamp not null default CURRENT_TIMESTAMP
);


create table if not exists recipe_ingredients
(
      id                  serial not null primary key
    , recipe_id           int not null references recipe(id) ON DELETE CASCADE
    , name                varchar(1000) not null
    , unique(recipe_id, name)
);





/*
 * Wstawianie rekordów
 */


insert into users_roles
    (name)
values
    ('Użytkownik'),
    ('Administrator')
;

insert into users
    (role_id, username, password, first_name, last_name, email_address)
values
    (2, 'jkowalski', 'hasl0123', 'Jan', 'Kowalski', 'jkowalski@gmail.com'),
    (1, 'anowak', 'hasl0123', 'Anna', 'Nowak', 'anowak@gmail.com'),
    (1, 'mmchirrie0', 'hasl0123', 'Meredith', 'MacChirrie', 'mmchirrie0@gmail.com'),
    (1, 'jhowden1', 'hasl0123', 'Jock', 'Howden', 'jhowden1@gmail.com'),
    (1, 'alimbert2', 'hasl0123', 'Avrom', 'Limbert', 'alimbert2@gmail.com'),
    (1, 'abarwack3', 'hasl0123', 'Anastasia', 'Barwack', 'abarwack3@gmail.com'),
    (1, 'fmarco4', 'hasl0123', 'Fredra', 'Marco', 'fmarco4@gmail.com'),
    (1, 'rkarpol5', 'hasl0123', 'Rodi', 'Karpol', 'rkarpol5@gmail.com'),
    (1, 'mflanagan6', 'hasl0123', 'Merv', 'Flanagan', 'mflanagan6@gmail.com'),
    (1, 'kstango7', 'hasl0123', 'Kit', 'Stango', 'kstango7@gmail.com'),
    (1, 'abracchi8', 'hasl0123', 'Amelina', 'Bracchi', 'abracchi8@gmail.com'),
    (1, 'lterrill9', 'hasl0123', 'Lothario', 'Terrill', 'lterrill9@gmail.com')
;


insert into recipe_catalog 
    (name, image_name)
values
    ('Makarony', 'https://image.flaticon.com/icons/png/128/2844/2844096.png'),
    ('Placki', 'https://image.flaticon.com/icons/png/128/527/527755.png'),
    ('Potrawy wigilijne', 'https://image.flaticon.com/icons/png/128/4471/4471355.png'),
    ('Dania obiadowe', 'https://image.flaticon.com/icons/png/128/2718/2718150.png'),
    ('Zupy', 'https://image.flaticon.com/icons/png/128/791/791584.png'),
    ('Desery', 'https://image.flaticon.com/icons/png/128/619/619478.png')
;


insert into recipe
    (user_id, catalog_id, name, image_path, description, level_of_difficulty, creation_time, created_date)
values
    (
        10, 1, 
        'Spaghetti Alla Carbonara',
        'https://ocdn.eu/pulscms-transforms/1/N6gk9kpTURBXy8xYTk4NGNlODc4OTlmOWFjNWVjNjgwZDYzYjI2MmJhYy5qcGeWlQLNAxQAwsOVAgDNAvjCw5QGzP_M_8z_lAbM_8z_zP-UBsz_zP_M_5QGzP_M_8z_gaEwBQ',
        '1. Makaron ugotuj al dente w osolonej wodzie\n2. Boczek pokrój w drobną kostkę i podsmaż na patelni bez dodatku tłuszczu, powstanie on z wytopionego boczku. Następnie zdejmij patelnię z ognia, aby zdążyła nieco ostygnąć, zanim wlejesz na nią sos\n3. Jajka wymieszaj w misce, dodaj połowę startego sera oraz pieprz\n4. Makaron przełóż na patelnię, na koniec powoli wlewaj sos, energicznie mieszając\n5. Danie przełóż na talerze i posyp resztą sera',
        1, 12, '2019-02-01 13:38:51'
    ),
    (
        10, 1, 
        'Makaron Ze Szpinakiem',
        'https://ocdn.eu/pulscms-transforms/1/4_2k9kpTURBXy8yZTkzZGU1YzA5MzhhNDAxOTBmYWJjODJlY2Q4MmIyNS5qcGeWlQLNAxQAwsOVAgDNAvjCw5QGzP_M_8z_lAbM_8z_zP-UBsz_zP_M_5QGzP_M_8z_gaEwBQ',
        'Zagotowujemy lekko osoloną wodę do ugotowania makaronu. Wrzucamy makaron do gotującej się wody na czas określony na opakowaniu i zależnie od naszych preferencji, potrzebny do ugotowania makaronu al dente lub miękkiego\nObieramy cebulę i szatkujemy na drobno. Na patelni rozpuszczamy masło i szklimy na niej cebulkę. Dodajemy na patelnię szpinak, doprawiamy, gdy puści sok dodajemy śmietanę i ser\nUgotowany makaron odcedzamy, mieszamy ze szpinakiem i dodatkami na patelni. Całość nakładamy na talerze i posypujemy parmezanem\nPrzepis można wzbogacić o jajko, rozbijane na patelni z makaronem, serem i szpinakiem pod koniec smażenia. Makaron z serem i szpinakiem pysznie smakuje też z suszonymi pomidorami ze słoika, świeżą bazylią lub ziołami, prażonymi ziarnami słonecznika, dyni i płatkami migdałowymi, albo orzeszkami piniowymi.',
        2, 40, '2019-02-07 19:55:37'
    ),
    (
        3, 1, 
        'Zapiekanka Makaronowa Z Warzywami',
        'https://ocdn.eu/pulscms-transforms/1/ME1k9kqTURBXy80NDRlYTRjZWE3YjZjNDYyZjVlZTA1OTVjODZiZGM1YS5qcGVnlpUCzQMUAMLDlQIAzQL4wsOUBsz_zP_M_5QGzP_M_8z_lAbM_8z_zP-UBsz_zP_M_4GhMAU',
        'Makaron gotujemy we wrzącej i osolonej wodzie, tak aby był al dente\nRozgrzewamy oliwę na patelni i smażymy na niej mielone mięso z dodatkiem posiekanego czosnku\nPaprykę oraz cukinię kroimy na drobne kawałki\nSer żółty ścieramy na tarce\nDo podsmażonego mięsa wrzucamy warzywa i dusimy razem przez około 15 minut, pod koniec dodając koncentrat pomidorowy\nPrzekładamy makaron do naczynia żaroodpornego i zalewamy mieszanką śmietany i tartego sera\nUkładamy warzywa i kolejną serową warstwę\nPieczemy przez 25 minut w 180 stopniach Celsjusza.',
        4, 60, '2019-02-13 00:34:34'
    ),
    (
        6, 1, 
        'Makaron Z Tuńczykiem W Sosie Śmietanowym',
        'https://ocdn.eu/pulscms-transforms/1/TJ3k9kpTURBXy85NmFhMDA2ODc2MjhiOTRjOWU5YTdhNjJlZTc4MWFiOS5qcGeWlQLNAxQAwsOVAgDNAvjCw5QGzP_M_8z_lAbM_8z_zP-UBsz_zP_M_5QGzP_M_8z_gaEwBQ',
        'Cebulę obieramy i kroimy w piórka. Podsmażamy na odrobinie oleju, aby się zeszkliła. Dodajemy kawałki tuńczyka i śmietanę – ale partiami, ponieważ może się zważyć, gdy damy jej naraz za dużo. Doprawiamy solą i pieprzem. Dodajemy posiekaną natkę pietruszki\nMakaron gotujemy według przepisu na opakowaniu. Można go wrzucić na patelnię, w której robiliśmy sos i na niej wymieszać składniki lub, gdy jest zbyt płytka, zrobić to w osobnej misce. Podajemy od razu.',
        1, 40, '2019-02-19 16:56:56'
    ),
    (
        11, 1, 
        'Makaron Z Serem',
        'https://ocdn.eu/pulscms-transforms/1/XbSk9kpTURBXy9hZjgzMmI1YzI4MmJiZjgyY2MyZjNlNDY5YzhkNTYyNS5qcGeWlQLNAxQAwsOVAgDNAvjCw5QGzP_M_8z_lAbM_8z_zP-UBsz_zP_M_5QGzP_M_8z_gaEwBQ',
        'Makaron gotujemy zgodnie z instrukcją na opakowaniu.\nW czasie gdy makaron będzie się gotował, przygotowujemy ser. Twaróg półtłusty wrzucamy do miseczki i drobimy go widelcem.\nDo sera wlewamy śmietanę i wsypujemy cukier. Teraz dokładnie mieszamy całość, aż wszystko ładnie się połączy.\nKiedy makaron już się ugotuje odcedzamy go.\nMakaron przekładamy do innego suchego garnka. Wrzucamy do niego ser i przez chwilę mieszamy do momentu aż nie połączy się z makaronem.\nNa wierzch możemy wysypać odrobinę cukru pudru lub cynamonu.',
        2, 30, '2019-02-26 09:06:43'
    ),
    (
        6, 1, 
        'Makaron W Sosie Dyniowym Z Mieloną Wieprzowiną',
        'https://ocdn.eu/pulscms-transforms/1/GAPk9kqTURBXy81ZWY4MzBhNTQ3NzhiNDhjNmRmZTFlNTMxYzcwNDUwNC5qcGVnlpUCzQMUAMLDlQIAzQL4wsOUBsz_zP_M_5QGzP_M_8z_lAbM_8z_zP-UBsz_zP_M_4GhMAU',
        'Rozgrzewamy na patelni olej kokosowy. Smażymy pokrojoną w kostkę cebulę, imbir, czosnek, mięso wieprzowe. Dodajemy pieprz i sól. Bulion mieszamy z puree dyniowy. Następnie przyprawiamy według smaku.\nGotujemy makaron w wodzie. Mięso wieprzowe łączymy z przygotowanym bulionem dyniowym. Dodajemy odsączona fasolę z puszki i ugotowany makaron. Wszystko razem dokładnie mieszamy szpatułką. Zdejmujemy patelnię z ognia. Całość posypujemy startym parmezanem. Nagrzewamy piekarnik do 200 stopni i wstawiamy danie na około 20 minut. Gotowe! Smacznego!',
        2, 35, '2019-03-10 03:05:37'
    ),
    (
        10, 1, 
        'Makaron Z Cukinią',
        'https://ocdn.eu/pulscms-transforms/1/GHYk9kpTURBXy82MmI3OWZiZGZkNzYzMzUwZmY0YTkxYmJhZmQ5MDljNi5qcGeWlQLNAxQAwsOVAgDNAvjCw5QGzP_M_8z_lAbM_8z_zP-UBsz_zP_M_5QGzP_M_8z_gaEwBQ',
        '1. Ugotuj makaron według przepisu na opakowaniu. Cukinie pokrój w kostkę i lekko podsmaż na oliwie\n2. Do cukinii dodaj drobno pokrojone papryczkę i czosnek\n3. Śmietanę wymieszaj z pokrojoną natką pietruszki, solą, pieprzem i parmezanem. Gotowy sos wlej na patelnie, dodaj ugotowany makaron, duś około 5 minut\nPo wyłożeniu porcji na talerz warto posypać jeszcze odrobiną parmezanu i udekorować świeżą natką pietruszki. Smacznego!',
        2, 25, '2019-03-18 22:30:25'
    ),
    (
        4, 1, 
        'Makaron Z Kurkami',
        'https://ocdn.eu/pulscms-transforms/1/F9jk9kpTURBXy9kYjViNTAwZmU4NjgxMzRjNzQ0OTVmMzIxZjBmY2VkYS5qcGeWlQLNAxQAwsOVAgDNAvjCw5QGzP_M_8z_lAbM_8z_zP-UBsz_zP_M_5QGzP_M_8z_gaEwBQ',
        '1.Ugotuj makaron\n2. Kurki umyj, opcjonalnie pokrój na połówki\n3. Na patelni podsmaż kurki z czosnkiem, wlej śmietankę, dopraw solą i pieprzem, zagotuj\n4. Makaron wymieszaj z sosem kurkowym orzechami i pietruszką. Całość posyp parmezanem lub płatkami drożdżowymi w opcji dla wegan.',
        1, 35, '2019-03-25 08:47:44'
    ),
    (
        11, 1, 
        'Lasagne Z Czterema Serami',
        'https://ocdn.eu/pulscms-transforms/1/0FCk9kpTURBXy82MGE0MDlhZTA3MmZlNTgxZTg1MWI3OWJlMmU5Yjg3ZC5qcGeWlQLNAxQAwsOVAgDNAvjCw5QGzP_M_8z_lAbM_8z_zP-UBsz_zP_M_5QGzP_M_8z_gaEwBQ',
        'Wszystkie sery rozpuszczamy na wolnym ogniu, pamiętając o mieszaniu. Pod sam koniec dolewamy mleko. W innym naczyniu podgrzewamy pomidorki koktajlowe z zalewą. Następnie miksujemy je i dodajemy rozdrobnione listki bazylii.\nPodsmażamy chorizo na suchej patelni. Łączymy je z szalotkami i smażymy 5 minut. Następnie dodajemy łyżkę masła i pieczarki. Po około 5 minutach przyprawiamy pieprzem. Na koniec wrzucamy seler naciowy i smażymy 3 minuty.\nŁyżkę passaty z pomidorków koktajlowych rozsmarowujemy w naczyniu do zapiekania. Kładziemy jeden płat lasagne, a na niego porcję sosu serowego (warstwa nie może być zbyt gruba). Następnie kładziemy porcję farszu z patelni, a na nią następny płat. Powtarzamy te porcje do końca. Wierzch polewamy szczelnie sosem serowym i kładziemy porcję passaty.\nPrzykrywamy danie folią aluminiową i wstawiamy je do piekarnika o temperaturze 190 stopni. Pieczemy je przez 20 minut. Następnie zdejmujemy folię i pieczemy jeszcze przez 5-10 minut. Polecamy podawać na gorąco. Smacznego!',
        2, 60, '2019-03-30 02:51:16'
    ),
    (
        8, 1, 
        'Cannelloni Z Mięsem I Mozzarellą',
        'https://ocdn.eu/pulscms-transforms/1/E6jk9kpTURBXy9jZDk1MDNlNzhlYjRhMzM0ODVjYzNmM2IwMGIyMjZjYS5qcGeWlQLNAxQAwsOVAgDNAvjCw5QGzP_M_8z_lAbM_8z_zP-UBsz_zP_M_5QGzP_M_8z_gaEwBQ',
        'Mięso mielone wymieszaj z jajkiem i szczyptą pieprzu.Cebulę i dwa ząbki czosnku obierz, a następnie pokrój w drobną kostkę i zeszklij na patelni pokrytej masłem\nDodaj mięso, ugnieć je na patelni za pomocą widelca i smaż przez około 5 minut. Po tym czasie całość dopraw solą i zdejmij z ognia\nW garnku z odrobiną oliwy zeszklij drobno pokrojoną cebulę z ząbkiem czosnku, po kilku minutach dodaj pokrojony w kostkę seler naciowy\nDodaj pomidory z puszki, szczyptę cukru i porwane w dłoniach listki bazylii. Całość gotuj przez kilka minut, dokładnie mieszając, a następnie zdejmij z ognia i zmiksuj za pomocą blendera na gładki sos\nPołowę sosu pomidorowego wymieszaj z wcześniej przygotowanym mięsem\nW czystym garnku rozpuść 60 g masła, dodaj mąkę i smaż przez 2 minuty, po czym dodaj mleko i całość gotuj, dokładnie mieszając, przez kolejne 5 minut. Dodaj szczyptę pieprzu, soli oraz gałki muszkatołowej i zdejmij garnek z ognia\nNastaw piekarnik na 200 stopni.Cannelloni nafaszeruj mięsem. Pozostałą częścią sosu pomidorowego zalej naczynie żaroodporne, a następnie poukładaj w nim makaron z farszem\nCałość polej sosem beszamelowym, tak aby zakrywał całe cannelloni i posyp startym serem mozzarella.Piecz przez 30 minut pod przykryciem z folii aluminiowej i kolejne 15 minut bez przykrycia',
        4, 90, '2019-04-02 09:04:56'
    ),
    (
        2, 2, 
        'Placki Z Cukinii',
        'https://ocdn.eu/pulscms-transforms/1/U-Lk9kpTURBXy9lNjE0YjNmNTU3NmIxYjZlNGRiNWIyMWVhYWQ1MTIzOS5qcGeWlQLNAxQAwsOVAgDNAvjCw5QGzP_M_8z_lAbM_8z_zP-UBsz_zP_M_5QGzP_M_8z_gaEwBQ',
        '1.Cukinię obierz i zatrzyj na tarce o dużych oczkach, posól i odstaw na 10 min\n2. Cebulę pokrój w kostkę\n3. Odciśnij cukinię z soku, dodaj resztę składników, dopraw\n4. Placuszki smaż na złoty kolor około 1,5 minuty na każdej ze stron',
         2, 25, '2019-04-08 09:01:00'
    ),
    (
        4, 2, 
        'Racuchy Z Jabłkiem',
        'https://ocdn.eu/pulscms-transforms/1/YUjk9kpTURBXy80OWVmZmMzMmQwMTJlMTNiMDM5YjY3NmQ0OWM3MGExMC5qcGeWlQLNAxQAwsOVAgDNAvjCw5QGzP_M_8z_lAbM_8z_zP-UBsz_zP_M_5QGzP_M_8z_gaEwBQ',
        'Obieramy jabłka, usuwamy gniazda nasienne. Przesiewamy mąkę pszenną. Jabłka kroimy w kostkę lub ścieramy na tarce o grubszych oczkach.\nJajka wbijamy do miski, ubijamy z cukrem. Dodajemy stopniowo do jajek z cukrem kefir i przesianą wcześniej mąkę, cały czas miksując lub intensywnie mieszając. Dodajemy starte lub pokrojone jabłka, rozgrzewamy na patelni olej.\nCiasto na naleśniki nakładamy powoli na patelnię, najlepiej łyżką, małymi porcjami, by uformować niewielkie racuchy. Smażymy racuchy, aż staną się zarumienione, złociste i chrupiące.\nGotowe racuchy odsączamy z tłuszczu ręcznikiem papierowym przeznaczonym do żywności.',
        2, 15, '2019-04-19 04:10:14'
    ),
    (
        10, 2, 
        'Cebularz',
        'https://ocdn.eu/pulscms-transforms/1/UCwk9kqTURBXy80MzU0MzM2MzQzYmY1OTYyYWFiNjIxNTJlZjYwMTkwMS5qcGVnlpUCzQMUAMLDlQIAzQL4wsOUBsz_zP_M_5QGzP_M_8z_lAbM_8z_zP-UBsz_zP_M_4GhMAU',
        'Mąkę mieszamy z suchymi drożdżami. Jeśli mamy świeże, najpierw robimy rozczyn. Dodajemy resztę składników i wyrabiamy. Pod koniec dodajemy roztopiony tłuszcz. Ciasto wyrabiamy do momentu, aż będzie miękkie i elastyczne.\nZ ciasta formujemy kulę i wkładamy do oprószonej mąką miski, przykrywamy ściereczką i odstawiamy w ciepłe miejsce do czasu, aż podwoi swoją objętość, czyli około 1,5 godziny.\nWyrośnięte ciasto jeszcze raz chwilę wyrabiamy, dzielimy na 12 równych części (około 70 g każda) i formujemy z niego kulki. Następnie wałkiem rozwałkowujemy na płaskie placuszki o średnicy około 10–12 cm.\nBułeczki układamy na 2 blaszkach wyłożonych wcześniej papierem do pieczenia. Na środek wykładamy nadzienie cebulowo-makowe. Ponownie przykrywamy kuchenną ściereczką i odstawiamy na 45–60 minut do ponownego wyrośnięcia (jeśli potrzeba – nawet dłużej, tak by podwoiły swoją objętość).\nPrzed samym pieczeniem brzegi bułeczek smarujemy jajkiem roztrzepanym z wodą. Pieczemy przez 20–25 minut w temperaturze 180 stopni C. Po tym czasie wyjmujemy i studzimy.\nNadzienie najlepiej przygotować dzień wcześniej. Pokrojoną w grubą kostkę cebulę wrzucamy na wrzątek i gotujemy przez 1–2 minuty, a następnie odcedzamy.\nJeszcze gorącą mieszamy z makiem, olejem i solą. Studzimy, przekładamy do słoiczka i chowamy na całą noc do lodówki.',
        1, 210, '2019-04-26 06:24:25'
    ),
    (
        1, 2, 
        'Placki Ziemniaczane Z Serem',
        'https://ocdn.eu/pulscms-transforms/1/exrk9kpTURBXy8zMTNiZGU3OGEzYTA2N2Y0OWI5MzQ3ODg3OTM1NTY5Yy5qcGeWlQLNAxQAwsOVAgDNAvjCw5QGzP_M_8z_lAbM_8z_zP-UBsz_zP_M_5QGzP_M_8z_gaEwBQ',
        'Ziemniaki obrać i zetrzeć na tarce.\nDo ziemniaków dodać cebulę, ser, mąkę, jajka, pieprz i sól. Wszystko wymieszać.\nSmażyć na na patelni.',
        1, 30, '2019-05-01 03:32:33'
    ),
    (
        11, 2, 
        'Naleśniki Owsiane Z Serem, Wędzonymi Śliwkami I Gorzką Czekoladą',
        'https://ocdn.eu/pulscms-transforms/1/RI0k9kqTURBXy9kY2NkMTViYjgzNGVhZmRmZDM0YjBkNmRjYzU2OWExYS5qcGVnlpUCzQMUAMLDlQIAzQL4wsOUBsz_zP_M_5QGzP_M_8z_lAbM_8z_zP-UBsz_zP_M_4GhMAU',
        'Przygotuj ciasto na naleśniki. Roztrzep jajka, dodaj mąkę owsianą (możesz ją wcześniej przesiać) i tyle wody, by uzyskać gładkie, naleśnikowe ciasto. Mąkę dodawaj stopniowo i mieszaj ciasto, wtedy unikniesz ewentualnych grudek.\nRozgrzej piekarnik do temperatury 200 stopni.\nNa natłuszczonej olejem kokosowym patelni usmaż naleśniki.\nBlisko jednej z krawędzi naleśnika ułóż ser, 2 pokrojone wędzone śliwki oraz porcję posiekanej gorzkiej czekolady. Zwiń naleśnik w rulon. To samo powtórz z kolejnymi naleśnikami.\nNa blasze rozłóż arkusz papieru do pieczenia i ułóż na nim naleśniki. Każdy naleśnik posmaruj miodem.\nWstaw blachę do piekarnika pod górny grill na ok. 5-8 minut.\nGotowe naleśniki posyp grubo posiekanymi orzechami oraz listkami świeżego tymianku.',
        4, 45, '2019-05-01 15:18:07'
    ),
    (
        5, 3, 
        'Barszcz Czerwony',
        'https://ocdn.eu/pulscms-transforms/1/h-Rk9kqTURBXy81OTUwMzIzMGY1NDFmNzY0YTdjOWNkMTUxY2ExNDY3Yi5qcGVnlpUCzQMUAMLDlQIAzQL4wsOUBsz_zP_M_5QGzP_M_8z_lAbM_8z_zP-UBsz_zP_M_4GhMAU',
        'Włoszczyznę myjemy i kroimy. Cebule opiekamy lub podsmażamy na patelni. Buraki myjemy i kroimy w plasterki\nPrzygotowane warzywa gotujemy z pieprzem, liśćmi laurowymi, zielem angielskim i grzybami przez około 1,5 godziny, aż do momentu, gdy będą miękkie\nPo ugotowaniu wyławiamy włoszczyznę i dodajemy zakwas. Najlepiej stopniowo, sprawdzając poziom kwaśności zupy według własnych preferencji. Dodajemy przeciśnięty przez praskę czosnek, majeranek i odrobinę cukry. W razie czego – doprawiamy do swojego smaku.\nZupę grzejemy, ale nie doprowadzamy do wrzenia. Dajemy jej nabrać przez chwilę smaku.\nGdy nie mamy przygotowanego zakwasu i nie chcemy sięgać po gotowe produkty ze sklepu, możemy przyrządzić pyszny barszczyk z czerwonych buraków. Bazę do niego stanowi prosta zupa warzywna, tyle że z burakami pokrojonymi np. w słupki lub startymi. W miejsce zakwasu dodaje się większą ilość buraków i ewentualnie kilka kropel soku z cytryny. Całość można wzbogacić smakowo, gotując na mięsie, np. żeberkach, i oczywiście dodając suszone grzyby.',
        1, 87, '2019-05-02 22:25:52'
    ),
    (
        3, 3, 
        'Uszka Z Grzybami',
        'https://ocdn.eu/pulscms-transforms/1/r0wk9kpTURBXy8wYTEyMGYwMDk4NTNiNTUxZTJlOWM3MjgwYmUyNjNiNS5qcGeWlQLNAxQAwsOVAgDNAvjCw5QGzP_M_8z_lAbM_8z_zP-UBsz_zP_M_5QGzP_M_8z_gaEwBQ',
        'Mąkę przesiewamy na stolnicę, dodajemy szczyptę soli i wlewamy porcjami wrzątek oraz olej w temperaturze pokojowej, wyrabiamy stopniowo na gładką masę. Można na początku mieszania użyć łyżki albo tępej strony nożna, żeby się nie oparzyć. Wyrabiamy ciasto rękami, kiedy ostygnie\nOdstawiamy ciasto na 15 minut pod przykryciem, np. ścierką. Dzielimy na pół i wałkujemy na płaskie i cienkie placki. Kroimy kształty na uszka i dodajemy farsz. Zalepiamy i można uszka gotować\nPrzygotowanie farszu zaczynamy od moczenia przez godzinę suszonych grzybów lub też gotowania surowych grzybów do miękkości (grzyby suszone gotujemy około godziny)\nCebulę kroimy w piórka i przesmażamy na złoto na oleju.Dodajemy na patelnię ugotowane i pokrojone w mniejsze kawałki grzyby, następnie śmietanę i dusimy. Dosypujemy bułkę tartą, doprawiamy solą i pieprzem.',
        2, 93, '2019-05-09 13:51:11'
    ),
    (
        3, 3, 
        'Karp W Galarecie',
        'https://ocdn.eu/pulscms-transforms/1/zKNk9kpTURBXy9hZDQzODcwMDk1NzlmNTYzYjQyMDdmMDAzNThlMzYxZS5qcGeWlQLNAxQAwsOVAgDNAvjCw5QGzP_M_8z_lAbM_8z_zP-UBsz_zP_M_5QGzP_M_8z_gaEwBQ',
        'Jeśli ktoś chce przyszykować karpia w galarecie, przepis wskazuje, żeby najpierw naszykować samą rybę. Trzeba ją sprawić i pokroić na porcje. Można również użyć gotowych filetów, jeśli ktoś tak woli - z pewnością będzie o wiele szybciej. W takim wypadku od razu skrapiamy rybę sokiem z cytryny i odstawiamy do lodówki lub w chłodne miejsce na około godzinę. Przez ten czas szykujemy resztę produktów. Ryba przejdzie zaś sokiem i będzie o wiele smaczniejsza.\nWarzywa do galarety należy pokroić. Marchewka, pietruszka, cebula, seler - nie mogą się one oczywiście pojawić w daniu w całości. Kawałki jednak nie mogą być też zbyt małe. Kiedy już wszystko będzie pokrojone, umieszczamy warzywa w garnku wraz z kawałkami ryby i zalewamy litrem wody. Dodajemy przyprawy.\nCałość gotujemy na małym ogniu przez około 20-30 minut. Później wyjmujemy delikatnie rybę, a wywar przecedzamy przez sito i najlepiej później jeszcze przez gazę, żeby pozbyć się także takich elementów, jak na przykład ziele angielskie.\nPrzepis na karpia w galarecie nakazuje jego wystudzenie i obłożenie ładnie pokrojoną marchewką oraz pietruszką. Wywaru zaś używamy do wykonania galarety - mieszamy go z żelatyną i podgrzewamy.\nDoprawiamy wywar solą, pieprzem oraz sokiem z cytryny. Kiedy zacznie stygnąć i tężeć, obkładamy nim rybę i warzywa. Później zostawiamy je do całkowitego wystygnięcia i związania.',
        2, 55, '2019-05-24 02:28:13'
    ),
    (
        2, 3, 
        'Kutia(Ani Starmach)',
        'https://ocdn.eu/pulscms-transforms/1/T09k9kpTURBXy9mNjRiMWJhZmUzMTMwM2NjNWVkYTQ3Njk1M2MwNzQxZS5qcGeWlQLNAxQAwsOVAgDNAvjCw5QGzP_M_8z_lAbM_8z_zP-UBsz_zP_M_5QGzP_M_8z_gaEwBQ',
        'Dzień przed planowanym przygotowaniem dania pszenicę zalej gorącą wodą i odstaw na noc, aby napęczniała.\nNastępnego dnia przecedź ją, zalej świeżą wodą i gotuj do miękkości przez mniej więcej 3 godziny.\nMak zalej mlekiem i gotuj około 40 minut, po tym czasie przecedź go i zmiel w maszynce do mięsa.\nPszenicę połącz z makiem, miodem, cukrem, płatkami róży i pokrojonymi bakaliami. Podawaj na zimno.\nPRZEPIS ANNY STARMACH Z KSIĄŻKI "PYSZNE NA KAŻDĄ OKAZJĘ"',
        4, 44, '2019-05-26 16:52:05'
    ),
    (
        4, 3, 
        'Kapusta Z Grzybami',
        'https://ocdn.eu/pulscms-transforms/1/QFAk9kqTURBXy9mMTZkZDkzN2JlYTg3MTJiMjdlODg2MGIxZTRjNmEwMS5qcGVnlpUCzQMUAMLDlQIAzQL4wsOUBsz_zP_M_5QGzP_M_8z_lAbM_8z_zP-UBsz_zP_M_4GhMAU',
        'Kapustę gotujemy w wodzie po gotowanych ziemniakach\nDodajemy namoczone wcześniej i posiekane grzyby oraz przyprawy. Gotujemy pod przykryciem, aż kapusta będzie miękka. Odcedzamy.\nNa maśle smażymy cebulę. Dodajemy do ugotowanej kapusty. Doprawiamy danie solą i pieprzem.',
        4, 59, '2019-06-07 11:54:58'
    ),
    (
        5, 3, 
        'Kompot Z Suszu',
        'https://ocdn.eu/pulscms-transforms/1/KBVk9kpTURBXy9hNGNkY2E4MTBjODdhM2I3YWNlODNkYzNjOWQ2OGRjNy5qcGeWlQLNAxQAwsOVAgDNAvjCw5QGzP_M_8z_lAbM_8z_zP-UBsz_zP_M_5QGzP_M_8z_gaEwBQ',
        'Suszone owoce sparz wrzącą wodą, odcedź i ponownie zalej dwoma litrami wody, tym razem zimnej. Odstaw do namoczenia na przynajmniej 2-3 godziny, a najlepiej na całą noc\nNastępnego dnia garnek owoców, wraz z wodą, w której się moczyły, postaw na ogniu, dodaj goździki i cukier, zagotuj i gotuj przez kolejne 10 minut\nNa koniec dodaj plasterki pomarańczy\nPamiętaj, żeby kompotu z suszu nie przygotowywać na ostatnią chwilę, gdyż przed podaniem musi on jeszcze odstać, aby smaki się przegryzły - wtedy smakuje najlepiej.',
        2, 89, '2019-06-19 05:00:31'
    ),
    (
        3, 3, 
        'Karp Smażony(Dietetycznie)',
        'https://ocdn.eu/pulscms-transforms/1/NgVk9kpTURBXy84OTBhNmZiYzFmODFmMzZjZTQyOWI4MjcxN2U1MWM2Yy5qcGeWlQLNAxQAwsOVAgDNAvjCw5QGzP_M_8z_lAbM_8z_zP-UBsz_zP_M_5QGzP_M_8z_gaEwBQ',
        'Umyte i osuszone filety karpia skrop sokiem z cytryny i przypraw. Wstaw na godzinę do lodówki.\nSmaż filety na rozgrzanym tłuszczu, na średnim ogniu skórką do dołu ok 10 - 12 minut pod przykryciem.\nPodawaj w towarzystwie aromatycznych ziół i cytryny.',
        2, 91, '2019-06-19 07:12:26'
    ),
    (
        6, 3, 
        'Piernik Błyskawiczny',
        'https://ocdn.eu/pulscms-transforms/1/RWdk9kqTURBXy8wMmQ2ZWZhNjk3YjJjZjg0MTUyNmJjYzg1NmUwYjdjMC5qcGVnlpUCzQMUAMLDlQIAzQL4wsOUBsz_zP_M_5QGzP_M_8z_lAbM_8z_zP-UBsz_zP_M_4GhMAU',
        'Piernik: Piekarnik rozgrzej do temperatury 170 stopni C. Miękkie masło utrzyj z cukrem. Mąkę połącz z proszkiem do pieczenia, kakao i przyprawą do piernika. Orzechy i śliwki drobno pokrój. Żółtka oddziel od białek. Żółtka dodawaj pojedynczo do masła. Do masy powoli wlewaj miód i stopniowo dodawaj przesianą mąkę. Gdy wszystkie składniki się połączą, dodaj orzechy i śliwki. Osobno ubij białka, delikatnie wymieszaj je z masą piernikową. Foremkę (keksówkę) wyłóż papierem do pieczenia lub wysmaruj masłem i oprósz mąką. Wlej do niej masę i piecz przez mniej więcej 50–60 minut. Przed wyciągnięciem sprawdź patyczkiem lub nożykiem czy masa na pewno jest już gotowa. Piernik ostudź.\nPolewa: W rondelku zagrzej mleko z masłem i czekoladą. Całość wymieszaj. Ostudzone ciasto polej czekoladą i zjedz od razu lub poczekaj – kilkudniowy piernik jest smaczniejszy.',
        4, 92, '2019-07-02 11:28:31'
    ),
    (
        1, 3, 
        'Makówki Siostry Anastazji',
        'https://ocdn.eu/pulscms-transforms/1/og7k9kpTURBXy8wNzA2NjYwMWRjZDc1ZjE5YWM2ZWNmZjUwYTYyNjY3Yi5qcGeWlQLNAxQAwsOVAgDNAvjCw5QGzP_M_8z_lAbM_8z_zP-UBsz_zP_M_5QGzP_M_8z_gaEwBQ',
        'Mak przepłukać, odcedzić, zalać wrzątkiem, podgrzewać na wolnym ogniu przez ok. 30 min, od­cedzić i dwukrotnie zemleć. Do 1/2 l mleka dodać 3/4 szklanki cukru, dobrze wymieszać. Do zmielonego maku dodać mleko z rozpuszczonym cukrem, bakalie, miód i szczyptę soli. Całość dokładnie wymieszać. \nPrzygotować syrop z 1/2 l mleka i 1/4 szklanki cukru. Dokładnie wymieszać i delikatnie maczać w nim chałkę pokrojoną w kromki. Dno salaterek wypełnić przygotowanym makiem, na nim ułożyć kromki chałki i ponownie przykryć warstwą maku. Przełożyć kilka warstw tak, by ostatnie przełożenie stanowiło warstwę maku. Wierzch dekoracyj­nie przyozdobić: np. ćwiartkami mandarynki, połówkami migdałów lub owocami kandyzowanymi. ',
        4, 69, '2019-07-06 11:57:34'
    ),
    (
        8, 3, 
        'Pierogi Z Kapustą',
        'https://ocdn.eu/pulscms-transforms/1/7gSk9kpTURBXy8zYTg1NGQ5YTUwNmQ3MGUzNWVmM2E2N2FmOGJiNWM2Yy5qcGeWlQLNAxQAwsOVAgDNAvjCw5QGzP_M_8z_lAbM_8z_zP-UBsz_zP_M_5QGzP_M_8z_gaEwBQ',
        '1. Zaczynamy od wyrobienia ciasta. W tym celu wyrabiamy mąkę z wodą, olejem i solą. Ciasto ma być elastyczne\n2. Następnie rozwałkowujemy ciasto na stolnicy\n3. Ciasto powinno być rozwałkowane na bardzo cienko. Gdy uzyskaliśmy ten efekt, możemy przystąpić do wycinania pierogów. W tym celu używamy szklanki. Robimy nią kółka w cieście (krążki)\n4. Kroimy cebulę na drobną kostkę i szatkujemy kapustę kiszoną na mniejsze porcje, odciskając z niej najpierw sok (który nadaje się do wypicia, jako cenne źródło witaminy C). Cebulę i kapustę mieszamy ze sobą, dodając pieprz\n4. W środek każdego krążka nakładamy łyżeczkę kapusty z cebulą i przystępujemy do zlepiania krańców ciasta, by powstał pieróg. Ważne, by robić to dokładnie, w przeciwnym razie nasz farsz wypłynie na wierzch, a pieróg zostanie pusty\n5. Gdy pierogi są gotowe, nastawiamy głęboki garnek z osoloną wodą i doprowadzamy ją do wrzenia\n6. Gdy woda bulgocze, możemy łyżką durszlakową wrzucać nasze pierogi. Pamiętajmy, by nie wrzucić ich do garnka na raz, a robić to partiami, ponieważ w przeciwnym wypadku się ze sobą zlepią\n7. Pieróg jest gotowy do wyjęcia, gdy wypływa na wierzch\n8. Ugotowane pierogi rozkładamy na talerzach lub lnianej ściereczce, starając się nie kłaść ich warstwowo, żeby się nie pozlepiały',
        1, 60, '2019-07-19 07:10:48'
    ),
    (
        1, 3, 
        'Groch Z Kapustą',
        'https://ocdn.eu/pulscms-transforms/1/yZSk9kqTURBXy9hN2JjYTI0YTMzZGQzOWQ5MGUyZWRhMWI1MmZkNTM1Ny5qcGVnlpUCzQMUAMLDlQIAzQL4wsOUBsz_zP_M_5QGzP_M_8z_lAbM_8z_zP-UBsz_zP_M_4GhMAU',
        'Kapustę siekamy, zalewamy wodą i gotujemy. Gdy zrobi się prawie miękka, dodajemy sól, liście laurowe i pęczak. Gotujemy pod przykryciem, aż kapusta i pęczak będą miękkie. Jeśli kapusta zacznie przywierać do dna, należy dolać wodę.\nNa oleju smażymy pokrojoną w piórka cebulę i dodajemy ją do ugotowanej kapusty. Wraz z ugotowanym grochem. Doprawiamy jeszcze solą i pieprzem, jeśli potrzeba. Można też dodatkowo dodać olej, o ile kapusta nie jest dość „gładka” w smaku.',
        2, 48, '2019-07-30 17:27:50'
    ),
    (
        5, 3, 
        'Makowiec',
        'https://ocdn.eu/pulscms-transforms/1/Zshk9kqTURBXy80YmFiOWE3MjVjZDEyMTQ0ODBjNzgxNGE5MzhmZjM3ZC5qcGVnlpUCzQMUAMLDlQIAzQL4wsOUBsz_zP_M_5QGzP_M_8z_lAbM_8z_zP-UBsz_zP_M_4GhMAU',
        'Rozpuścić drożdże wraz z cukrem w mleku i odstawić na 15 minut. Następnie przesiać mąkę i wymieszać z solą, cukrem waniliowym, margaryną i żółtkami. Dodać rozczyn drożdżowy i zagnieść ciasto do uzyskania jednolitej konsystencji. Uformować kulę, zakryć bawełnianą, wilgotną ściereczką i odstawić w ciepłe miejsce na godzinę.\nW międzyczasie przygotować masę makową. Zagotować 0,5l wody z makiem i odstawić do ostygnięcia. Następnie zemleć mak dwukrotnie i wymieszać z cukrem, rodzynkami, miodem, cynamonem i margaryną. Ubić białka na sztywno i dodać do masy makowej.\nRozgrzać piekarnik do 180C i wyłożyć blachę papierem do pieczenia. Rozwałkować ciasto cienko na kształt prostokąta i nałożyć masę makową, pozostawiając ok. 3cm odstępu od krawędzi.\nZawinąć ciasto w rulon wkładając końce pod spód. Wstawić makowiec do piekarnika na ok. 40 minut.',
        4, 79, '2019-08-09 15:59:26'
    ),
    (
        7, 3, 
        'Karp Po Żydowsku',
        'https://ocdn.eu/pulscms-transforms/1/PBwk9kpTURBXy9mZjk3OTI5ZGZlZDU4NzQwN2MyODY0YjIwNWY5NmE1Yi5qcGeWlQLNAxQAwsOVAgDNAvjCw5QGzP_M_8z_lAbM_8z_zP-UBsz_zP_M_5QGzP_M_8z_gaEwBQ',
        'Zaczynamy od sprawienia ryby. Odcięta głowa i ogon posłuży do przygotowania wywaru. Jeżeli dysponujemy pozostałościami z tylko jednego karpia, w późniejszym etapie konieczne będzie dodanie żelatyny;\nDo garnka wlewamy 1 litr wody. Wkładamy rybi ogon, głowę, marchew oraz dwie cebule, uprzednio pokrojone w plastry. Doprawiamy solą i pieprzem. Całość gotujemy na wolnym ogniu, przez 90 minut;\nPo ugotowaniu, wywar odcedzamy i dzielimy na dwie półlitrowe porcje. Do pierwszej dodajemy dwie pokrojone w kostkę cebule, wcześniej lekko podsmażone na patelni, na maśle, wraz z goździkami. Gotujemy do momentu, aż cebula stanie się miękka. Do drugiej połowy wywaru, wkładamy rybę. Gotujemy na wolnym ogniu, przez około 20 minut;\nPo ugotowaniu karpia, miksujemy ze sobą wywar, w którym gotowała się cebula, i w którym gotowała się ryba. Po sparzeniu, dodajemy migdały, a także rodzynki. Przyprawiamy solą i pieprzem. Dodajemy żelatynę. Rybę zalewamy wywarem. Całość odstawiamy, do momentu ścięcia się galarety.',
        1, 71, '2019-08-21 00:14:44'
    ),
    (
        4, 3, 
        'Wigilijna Zupa Grzybowa',
        'https://ocdn.eu/pulscms-transforms/1/aO2k9kqTURBXy9jMDE1Mzc3ZmY4ZDNhZWI0ZjhmMjQ3NmI3YjNhYmI2My5qcGVnlpUCzQMUAMLDlQIAzQL4wsOUBsz_zP_M_5QGzP_M_8z_lAbM_8z_zP-UBsz_zP_M_4GhMAU',
        '1. Grzyby moczymy na noc w niewielkiej ilości wody, potem wyjmujemy z wody, ale jej nie wylewamy. Kroimy je w paseczki. Warzywa obieramy, ścieramy na tarce – tylko por kroimy w paseczki. Cebulę siekamy drobno i szklimy na maśle w garnku do gotowania zupy. Gdy będzie miękka i przejrzysta, wkładamy grzyby oraz starte warzywa. Dwa razy mieszamy, a potem zalewamy całość gorącym wywarem i dodajemy wodę z moczenia grzybów.\n2. Gotujemy razem, aż wszystkie składniki będą miękkie, a smaki się połączą (około 45 minut na małym ogniu). Dosmaczamy hojnie pieprzem. Dwie minuty przed końcem gotowania do zupy wkładamy ser koryciński pokrojony w kostkę. Posypujemy koperkiem.\n3. Podajemy z grzankami lub b',
        4, 15, '2019-09-04 11:46:29'
    ),
    (
        7, 4, 
        'Kotlety Z Kalafiora',
        'https://ocdn.eu/pulscms-transforms/1/TXwk9kpTURBXy80OWVjNTg1MGRlZmMxZTJmYTUyZDY0Y2VjNjQzMTg3Mi5qcGeWlQLNAxQAwsOVAgDNAvjCw5QGzP_M_8z_lAbM_8z_zP-UBsz_zP_M_5QGzP_M_8z_gaEwBQ',
        '1. Kalafiora gotujemy w osolonej wodzie, odcedzamy i odstawiamy do wystygnięcia.\n2. Cebulę obieramy, kroimy w małą kostkę i podsmażamy.\n3. Natkę pietruszki myjemy, osuszamy i siekamy drobno.\n4. Czosnek przeciskamy przez praskę.\n5. Chłodnego kalafiora wkładamy do dużej miski i rozgniatamy widelcem.\n6. Do miski z kalafiorem wkładamy uprzednio namoczoną czerstwą kajzerkę lub wsypujemy ok. pół szklanki bułki tartej. Wbijamy też 2 jajka, dodajemy cebulę, czosnek, natkę pietruszki i przyprawy.\n7. Wszystkie składniki wyrabiamy dłonią na jednolitą masę. Jeśli okaże się, że masa jest zbyt rzadka, dosypujemy trochę bułki tartej i wyrabiamy dalej.\n8. Z masy formujemy niezbyt duże okrągłe albo owalne kotlety. Każdy kotlet obtaczamy w bułce tartej.\n9. Na patelni rozgrzewamy olej. Smażymy kotleciki do zarumienienia po jednej i po drugiej stronie.\n10. Podawaj jak lubisz - z ziemniakami, kaszą, frytkami i ulubioną surówką.',
        2, 16, '2019-09-13 15:31:00'
    ),
    (
        3, 4, 
        'Ryż Z Kurczakiem',
        'https://ocdn.eu/pulscms-transforms/1/ydEk9kpTURBXy81MDk3YjkwMDRhOGJkNzg3YWJhZTc4NmMyMTAzYzNjYy5qcGeWlQLNAxQAwsOVAgDNAvjCw5QGzP_M_8z_lAbM_8z_zP-UBsz_zP_M_5QGzP_M_8z_gaEwBQ',
        '1. Zaczynamy od ugotowania ryżu zgodnie z instrukcją podaną na opakowaniu.\n2. Mięso dokładnie myjemy i osuszamy na ręczniku papierowym. Kroimy w drobną kosteczkę.\n3. Mięso przekładamy do miski i posypujemy wybranymi przez siebie przyprawami. My doprawiliśmy je papryką w proszku i solą.\n4. Smażymy mięso na oleju. Raz na jakiś czas mieszamy.\n5. W tym czasie, myjemy i kroimy warzywa. Paprykę i cebulę kroimy w kostkę, a kukurydzę odsączamy (jeżeli była w puszcze).\n6. Na patelnię wylewamy kilka kropel oliwy z oliwek. Wrzucamy tam cebulę i smażymy chwilę, aż lekko się nie zeszkli. Po tym czasie wrzucamy pozostałe warzywa. Możemy doprawić je solą i pieprzem.\n7. Kiedy ryż już się ugotuje przesypujemy go do miski. Wrzucamy tam ugotowane warzywa i mięso i całość mieszamy.\n8. Inną propozycją podania jest wyłożenie na talerz ryżu i nasypania na wierzch warzyw i mięsa.',
        4, 89, '2019-09-23 19:35:10'
    ),
    (
        2, 4, 
        'Zapiekanka Z Ziemniaków I Porów Pod Beszamelem',
        'https://ocdn.eu/pulscms-transforms/1/CJkk9kqTURBXy9iYmVlYmU4M2U1NzBlY2E2YTcwOTc1ZmFhZTJiZjQ3Yi5qcGVnlpUCzQMUAMLDlQIAzQL4wsOUBsz_zP_M_5QGzP_M_8z_lAbM_8z_zP-UBsz_zP_M_4GhMAU',
        '1. Obrane i umyte ziemniaki kroimy na cienkie plastry(jeśli lubicie grubsze plastry, ważne, aby wydłużyć czas pieczenia).\n2. Wyczyszczonego, umytego pora kroimy na krążki, podsmażamy go na oliwie do lekkiego zmiękczenia i zarumienienia ok. 5 min.\n3. Sos beszamelowy, wersja bardziej płynna niż klasyczna: na patelni roztapiamy masło dodajemy łyżkę mąki i zasmażamy ok. 1 - 2 minut(patelnie ustawiamy na minimalnym ogniu).\n4. Powoli dodajemy mleko mieszając i rozbijając powstałe grudki.Po dodaniu całości mleka ścieramy trochę gałki muszkatołowej, dodajemy sól i pieprz do smaku.Po zdjęciu z ognia, do sosu dodajemy przygotowanego pora.Naczynie do zapiekania smarujemy masłem.Układamy w rzędach krążki ziemniaków zalewamy sosem. (U mnie zazwyczaj wychodzą 4 warstwy ziemniaków i 4 warstwy sosu, więc składniki już na początku dzielę na 4 części.).Ostatnią warstwę ziemniaków zalewamy sosem.\n5. Zapiekankę wstawiamy do piekarnika rozgrzanego do temperatury 180 stopni, grzałki góra - dół na 25 min.i na 10 min.grzałki góra - dół - termoobieg.Smacznego:)',
        2, 79, '2019-10-02 07:52:32'
    ),
    (
        10, 4, 
        'Pstrąg Tęczowy Na Parze',
        'https://ocdn.eu/pulscms-transforms/1/ZFmk9kpTURBXy9iZTNmMTQ0ZGUxMzMyMWU0MjkwM2Y0N2E3ZGFkMTQ0ZC5qcGeWlQLNAxQAwsOVAgDNAvjCw5QGzP_M_8z_lAbM_8z_zP-UBsz_zP_M_5QGzP_M_8z_gaEwBQ',
        '1. Ryby umyj pod bieżącą wodą, osusz ręcznikiem papierowym. Wytnij ostrym nożem płetwy, odetnij ogon i głowę. Możesz zdrapać i usunąć łuski ze skóry, jeżeli ją później jesz. Jeżeli nie, pozostaw skórę nienaruszoną.\n2. Wykonaj poziome cięcie wewnątrz ryby, tak aby pogłębić miejsce, do którego mogą wniknąć przyprawy.\n3. Wstaw ryby do miski i dodaj przypraw z każdej strony pstrąga. Czosnek można pokroić w kostkę, a obraną cebulę w plastry. Ryby obłóż czosnkiem i cebulą. Pozostaw w lodówce na kilka godzin, aby przeszły przyprawami (opcjonalnie, można pominąć etap czekania).\n4. Usuń cebulę i czosnek.\n5. Gotuj ryby na parze przez około 15 minut.\n6. Podawaj wraz z cytryną, którą skrapia się pstrąga. Dodatkiem do pstrąga tęczowego przygotowanego na parze, mogą sprawdzić się frytki i surówka z sałaty, kapusty, pomidora oraz papryki.',
        4, 97, '2019-10-10 03:12:08'
    ),
    (
        10, 4, 
        'Pierożki Z Serem',
        'https://ocdn.eu/pulscms-transforms/1/JSrk9kpTURBXy9iNmQxYzE3MGM0MDEzMTZjYTQwZDdlMjU5YTAwOTVjNS5qcGeWlQLNAxQAwsOVAgDNAvjCw5QGzP_M_8z_lAbM_8z_zP-UBsz_zP_M_5QGzP_M_8z_gaEwBQ',
        '1. Kładziemy ser do miski. Następnie rozgniatamy go za pomocą widelca. W dalszej kolejności dodajemy do tego żółtko, cukier waniliowy oraz cukier.\n2. Teraz dodajemy do miski przesianą mąkę, a do tego dokładamy sól, jajko oraz masło. Stopniowo dokładamy także odpowiednią ilość wody w taki sposób, by doszło do połączenia składników. Wszystko ugniatamy aż do uzyskania ciasta - gładkiego oraz miękkiego.\n3. Następnie dzielimy ciasto na dwie części. Każdą z tych części wałkujemy w taki sposób, aby powstał z niej cienki placek. Kółka wykrajamy z ciasta za pomocą szklanki.\n4. Na środku każdego z utworzonych kółek umieszczamy niewielką ilość farszu. Pierożki składamy na pół, ich brzegi dokładnie zlepiamy, a końcówki dociskamy przy użyciu widelca.\n5. Teraz zagotowujemy osoloną wodę w dużym garnku. Partiami wkładamy nasze pierożki. Gotujemy je na niewielkim ogniu do momentu, aż wypłyną, a po wypłynięciu jeszcze przez trzy minuty.\n6. Ugotowane pierożki wyjmujemy przy użyciu łyżki cedzakowej i odkładamy na talerz. Danie gotowe! Życzymy smacznego.\nPierogi można podawać bez dodatków lub np. polać odrobiną masła. Niektórzy osypują je niewielką ilością cynamonu. Wszystko zależy od naszych indywidualnych upodobań i gustów smakowych.',
        2, 34, '2019-10-23 16:41:43'
    ),
    (
        1, 4, 
        'Zupa Tajska',
        'https://ocdn.eu/pulscms-transforms/1/3PYk9kpTURBXy9jNDAxZTg0MDliYzc0OGIzNWE5NzI4MmMzYWU0MmEyOC5qcGeWlQLNAxQAwsOVAgDNAvjCw5QGzP_M_8z_lAbM_8z_zP-UBsz_zP_M_5QGzP_M_8z_gaEwBQ',
        '1. Pokrój pierś z kurczaka na mniejsze fragmenty. Gotuj w wodzie około 45 minut na małym ogniu i po tym czasie zdejmij z powierzchni utworzoną szumowinę.\n2. Podziel na kawałki imbir, borowiki oraz trawę cytrynową. Pokrój w kosteczki cebulę oraz czosnek. Następnie wszystkie te składniki podsmaż krótko na patelni z dodatkiem oliwy z oliwek.\n3. Do otrzymanego wcześniej wywaru z piersią kurczaka przełóż zawartość patelni. Dodaj do garnka wszystkie przyprawy, które obejmuje przepis na zupę tajską, a także pokrojoną paprykę, marchewkę, pietruszkę i ryż. Gotuj zupę przez około 45 minut.\n4. Około 10 minut przed końcem gotowania dodaj do zupy jogurt naturalny, mleczko kokosowe, a także suszone owoce z przepisy. Jeżeli chcesz, aby zupa tajska była bardziej słodka, dołącz do niej łyżeczkę miodu. Smacznego!',
        3, 22, '2019-10-30 01:15:27'
    ),
    (
        3, 4, 
        'Zrazy Wołowe Zawijane',
        'https://ocdn.eu/pulscms-transforms/1/eJ3k9kpTURBXy9lZmFkMmU5M2RiZTEwYTg3MDhiN2Q3M2YzY2JlNTQ0Yi5qcGeWlQLNAxQAwsOVAgDNAvjCw5QGzP_M_8z_lAbM_8z_zP-UBsz_zP_M_5QGzP_M_8z_gaEwBQ',
        '1. Jeśli chodzi o zrazy wołowe, przepis jest bardzo prosty - chodzi po prostu o to, żeby w zawijanym mięsie umieścić pyszny farsz. Zaczynamy od rozbicia plastrów wołowiny (jeśli kupiliśmy cały kawałek, musimy najpierw pokroić mięso). Kiedy już uzyskamy cienkie plastry, smarujemy je z jednej strony musztardą i odstawiamy na chwilę, żeby przeszły jej smakiem.\n2. W tym czasie zajmujemy się krojeniem ogórków kiszonych w słupki. Nie jest to konieczne - można też użyć całych ogórków. Jednakże jeśli chcemy, żeby każdy kęs smakował ogórkami, lepiej jest je umieścić w mięsie w wersji posiekanej. Inaczej najprawdopodobniej ogórek wyleci przy pierwszym przekrojeniu i wszystko straci efekt.\n3. Na plastrach wołowiny zrazowej posmarowanej musztardą układamy plasterek boczku i posypujemy go solą oraz pieprzem. Na jednym brzegu układamy słupki ogórka, a następnie zawijamy mięso - zaczynając od tej strony. Kiedy uzyskamy już zawiniątko, nakłuwamy je wykałaczką, żeby wszystko się trzymało.\n4. Rozgrzewamy olej na patelni i układamy na nim zrazy. Przykrywamy je, żeby zaczęły się dusić. Co jakiś czas dodajemy trochę oleju, żeby wszystko ładnie się podsmażyło. Przewracamy je również co jakiś czas w miarę możliwości. Możemy je także umieścić w sosie, jeśli chcemy przyspieszyć cały proces.',
        3, 72, '2019-10-31 05:00:10'
    ),
    (
        9, 5, 
        'Zupa Z Zielonych Szparagów I Młodych Ziemniaków',
        'https://ocdn.eu/pulscms-transforms/1/3ilk9kqTURBXy85NDVmODdjMmJlYTQ0ZGEzNThjOWU0ZmQ1ZmNiMWZhOS5qcGVnlpUCzQMUAMLDlQIAzQL4wsOUBsz_zP_M_5QGzP_M_8z_lAbM_8z_zP-UBsz_zP_M_4GhMAU',
        'Usuwamy zdrewniałe końcówki i skórkę ze szparagów.\nZiemniaki gotujemy razem ze skórką do miękkości w niewielkiej ilości wody. Pięć minut przed końcem gotowania dodajemy szparagi.\nGdy warzywa są miękkie (nie rozgotowane!), pozwalamy im ostygnąć.\nWyciągamy ziemniaki i usuwamy z nich skórkę.\nZiemniaki wkładamy z powrotem do garnka ze szparagami, dodajemy koper, sok z cytryny, przyprawy oraz jogurt.\nCałość miksujemy na gładką masę, a jeśli zupa jest zbyt gęsta, dodajemy przegotowaną wodę aż do uzyskania pożądanej konsystencji.\nCałość zagotowujemy chwilkę, przekładamy na talerze i ozdabiamy szparagami.\n',
        4, 86, '2019-11-11 01:22:27'
    ),
    (
        8, 5, 
        'Botwinka Z Jajkiem',
        'https://ocdn.eu/pulscms-transforms/1/8zlk9kpTURBXy85M2FiNWZhYWYyMzBjZTI4NmY3YTRjZTNkMDc1NmZlMy5qcGeWlQLNAxQAwsOVAgDNAvjCw5QGzP_M_8z_lAbM_8z_zP-UBsz_zP_M_5QGzP_M_8z_gaEwBQ',
        'Botwinkę, buraki, ziemniaki i seler umyj, obierz i pokrój w kostkę. Jajka ugotuj na twardo. W dużym garnku rozpuść masło i zeszklij cebulę. Dodaj buraki, seler i ziemniaki i podsmażaj kilka minut. Dodaj przyprawy i zalej gorącym bulionem.\nGotuj na średnim ogniu przez około 15 minut. Następnie dodaj botwinę i gotuj jeszcze przez 10 minut.\nJajka obierz i pokrój na połówki. Zdejmij zupę z ognia dodaj sok z cytryny, śmietanę i dopraw do smaku. Podawaj z połówką jajka.\n',
        1, 47, '2019-11-21 17:47:47'
    ),
    (
        4, 5, 
        'Zupa Koperkowa',
        'https://ocdn.eu/pulscms-transforms/1/qUzk9kpTURBXy84YmU5Y2Q5YjE4YzZhNGUyYTNmNGQxZDczYmM4M2FiMC5qcGeWlQLNAxQAwsOVAgDNAvjCw5QGzP_M_8z_lAbM_8z_zP-UBsz_zP_M_5QGzP_M_8z_gaEwBQ',
        'Mięso dokładnie myjemy, wkładamy do garnka z wodą i gotujemy na wolnym ogniu.\nBy zrobić naprawdę zdrową zupę koperkową, będziemy potrzebować dobrej jakościowo włoszczyzny. Marchew, pietruszkę, selera i pora myjemy, obieramy i dodajemy do garnka z mięsem (lub z samą wodą, jeśli wybraliśmy przepis na zupę koperkową w wersji wegetariańskiej). Wkładamy tam także liście laurowe i ziele angielskie.\nCzęść koperku myjemy, osuszamy, drobno siekamy i dodajemy do wywaru. Podgrzewamy pod przykryciem do momentu, aż wszystkie warzywa zmiękną.\nWyjmujemy warzywa i mięso z bulionu. Marchew kroimy lub ucieramy, pietruszkę i selera miksujemy, a ze skrzydełek wycinamy najbardziej atrakcyjne kawałki mięsa i dodajemy do naszej zupy.\nZupa koperkowa może być podawana z ziemniakami, makaronem lub ryżem. Jeżeli decydujemy się na przepis na zupę koperkową z ziemniakami, powinniśmy je umyć, obrać, pokroić w drobną kostkę i wrzucić do gorącego bulionu, by się w nim ugotowały. Jeżeli wolimy wersję z ryżem lub makaronem, gotujemy go według przepisu na opakowaniu. Ryż po ugotowaniu można dodać bezpośrednio do garnka, jednak makaron lepiej nakładać na talerze i zalewać zupą.\nKiedy ziemniaki będą już ugotowane, dodajemy odrobinę zupy koperkowej do śmietany, mieszamy i wlewamy do garnka. Doprawiamy solą i pieprzem do smaku. Myjemy i siekamy pozostałą część koperku (możemy go nawet lekko podsmażyć), wkładamy do garnka i podgrzewamy jeszcze przez kilka minut.\nZupa koperkowa może być podawana ze śmietaną lub bez. Przepis można także zmienić, zastępując ją jogurtem naturalnym. Jeżeli lubimy, możemy zrobić zupę koperkową z drobno pokrojonym szczypiorkiem, którym posypiemy ją obficie po podaniu. Smacznego!\n',
        4, 66, '2019-11-28 13:57:58'
    ),
    (
        6, 5, 
        'Chłodnik Z Botwinki I Rzodkiewki',
        'https://ocdn.eu/pulscms-transforms/1/khik9kpTURBXy82NzFjYjVhMTRhZTU3ZTkyODViY2E5MGY5ODYzM2Y0ZS5qcGeWlQLNAxQAwsOVAgDNAvjCw5QGzP_M_8z_lAbM_8z_zP-UBsz_zP_M_5QGzP_M_8z_gaEwBQ',
        'Botwinkę w całości dokładnie myjemy. Małe listki możemy odłożyć do dekoracji, a pozostałe listki oraz łodyżki siekamy. Buraczki obieramy najcieniej jak się da i kroimy je w drobną kostkę.\nRozdrobnioną botwinkę przekładamy do garnka i zalewamy niewielką ilością wody (niecałą szklanką). Następnie dodajemy po szczypcie cukru i soli i gotujemy przez 10 minut. Pod koniec gotowania dodajemy sok z połówki cytryny i odstawiamy do ostygnięcia.\nW tym czasie siekamy drobno koperek i szczypiorek i łączymy go z kefirem lub jogurtem naturalnym.\nGdy botwinka ostygnie, dodajemy do niej kefir/jogurt, a także startą na tarce o dużych oczkach lub drobno pokrojoną rzodkiewkę. Wszystko razem mieszamy i odstawiamy do schłodzenia na około 2 godziny do lodówki.\n',
        1, 49, '2019-12-01 15:35:46'
    ),
    (
        5, 5, 
        'Zupa Szczawiowa',
        'https://ocdn.eu/pulscms-transforms/1/PyOk9kpTURBXy8xYzBjYjkxZjllMWY1Yzg3NDExMTJjZjI2Y2Q1YTNhMi5qcGeWlQLNAxQAwsOVAgDNAvjCw5QGzP_M_8z_lAbM_8z_zP-UBsz_zP_M_5QGzP_M_8z_gaEwBQ',
        'Przygotowanie zupy szczawiowej zaczynamy od pokrojenia żeberek i wrzucenia ich razem z kurczakiem (lub indykiem) do garnka zalanego wodą. Dodajemy 1,5 łyżki soli i czekamy do zagotowania, po czym zmniejszamy ogień i wciąż gotujemy około godziny. Do garnka wrzucamy marchewki, por, seler i cebulę wraz z przyprawami z listy składników. Warzywa gotujemy około pół godziny, aż zrobią się miękkie. Wyjmujemy z zupy cebulę oraz marchewkę i pietruszkę, którą ścieramy na tarce na dużych oczkach i wrzucamy na nowo do garnka. W międzyczasie myjemy szczaw i drobno siekamy, po czym dodajemy do wywaru na kilka minut do zagotowania. Następnie w osobnym naczyniu mieszamy mąkę z 2 łyżkami wody. Gdy uzyskamy jednolitą konsystencję, dodajemy śmietanę. W kolejnym kroku stopniowo dodajemy kilka łyżek samej śmietany bezpośrednio do zupy, a następnie wymieszaną całość. Wszystko delikatnie mieszamy i gotujemy na małym ogniu. Gdy wywar już jest gotowy, czas gotowania to około 20 minut. Podany przepis przewiduje 4 porcje posiłku. W innej wersji możemy przygotować zupę szczawiową na bulionie jarzynowym z dodatkiem łyżki masła.\nNa koniec dorzucamy gotowane jajko na twardo pokrojone w kostkę. Możemy też połówki jajek ułożyć na talerzu przed nalaniem zupy szczawiowej. Do posiłku podajmy również gotowane ziemniaki na osobnym talerzu. Innym rozwiązaniem jest podanie zupy z pieczywem. Na koniec możemy dodać także posiekany szczypiorek. \nW innej wersji ziemniaki mogą być pokrojone w kostkę i dodane do zupy podczas gotowania. Ważne, by dorzucić je do wywaru przed wrzuceniem szczawiu. Wynika to z zakwaszenia wywaru, w którym ziemniaki gotowałyby się dłużej. Dotyczy to także innych zup, jak ogórkowa czy żurek. \nAlternatywnie można także posiekać drobno cebulę razem z czosnkiem i zeszklić całość na oliwie, a następnie dorzucić do wywaru, zamiast gotować całą cebulę, którą po czasie wyjmuje się z zupy. W tej wersji smażymy cebulę w garnku, do którego wlewany wywar, wrzucamy ziemniaki pokrojone w kostkę wraz ze szczyptą soli i gotujemy, aż zrobią się miękkie. Później wrzucamy szczaw (w dowolnej formie). Całość zagęszczamy śmietaną wymieszaną z mąką jak w pierwszej wersji. Całość gotujemy, mieszając co jakiś czas. Dla przełamania smaku dodaje się szczyptę cukru i mielony pieprz.',
        3, 41, '2019-12-11 17:31:41'
    ),
    (
        6, 6, 
        'Łatwa Szarlotka Iśki',
        'https://ocdn.eu/pulscms-transforms/1/-jGk9kpTURBXy9jMzk4MzAxZTdjMDRjYjNmZTg0MTExNDEzMjM3OTBkMC5qcGeWlQLNAxQAwsOVAgDNAvjCw5QGzP_M_8z_lAbM_8z_zP-UBsz_zP_M_5QGzP_M_8z_gaEwBQ',
        'Jabłka po umyciu i obraniu przekrawamy na ćwiartki i usuwamy gniazda nasienne.Następnie ścieramy jabłka na plasterki na tarce.Zasypujemy je w misce cukrem i odstawiamy na przynajmniej godzinkę, by puściły sok.\nNastępnie dodajemy do jabłek jajka, skórkę pomarańczową, rodzynki, olej, kakao, przyprawę korzenną, mąkę połączoną z proszkiem do pieczenia i wszystko dokładnie mieszamy.\nCiasto wylewamy na blachę wysmarowaną tłuszczem i wysypaną bułką tartą.Pieczemy je w nagrzanym do temperatury 180 stopni piekarniku, przez ok. 50 minutek.Placek ten możemy piec również w prodiżu.\nSkórkę pomarańczową możemy zastąpić np.orzechami włoskimi, lub użyć jednego i drugiego, wedle smaku :)',
        3, 36, '2019-12-23 08:54:31'
    ),
    (
        6, 6, 
        'Sernik Babci Uli',
        'https://ocdn.eu/pulscms-transforms/1/ZHWk9kpTURBXy9iNjlmODlkOWRjYzhiZmJlMzExZjRmYmM4NTA5ZDIwYS5qcGeWlQLNAxQAwsOVAgDNAvjCw5QGzP_M_8z_lAbM_8z_zP-UBsz_zP_M_5QGzP_M_8z_gaEwBQ',
        'Do dużej miski należy wrzucić przemielony ser biały. Dodać cukier, żółtka, budyń i wymieszać.\nZ białek należy ubić pianę i dodać do reszty. Następnie należy dodać masło i rodzynki. Wszystko dokładnie wymieszać i w razie potrzeby dodać mleka.\nFormę do ciasta wysmarować margaryną i wysypać bułką tartą. Piec około 1 godziny w temperaturze 180 stopni. Wierzch ciasta powinien nabrać złocistego koloru.',
        2, 21, '2020-01-04 16:18:16'
    ),
    (
        6, 6, 
        'Skubaniec Cioci Krysi',
        'https://ocdn.eu/pulscms-transforms/1/G-Tk9kqTURBXy8wZmQxM2NjNDA0MzQ3MjdkNDY2ZGI3YTY2MWI2NGYwZS5qcGVnlpUCzQMUAMLDlQIAzQL4wsOUBsz_zP_M_5QGzP_M_8z_lAbM_8z_zP-UBsz_zP_M_4GhMAU',
        'Na stolnicy mąkę posiekać z margaryną, dodać żółtka, 3 łyżki cukru, cukier waniliowy, proszek do pieczenia i zagnieść ciasto. Podzielić na trzy części. Do jednej części dodać kakao i dobrze połączyć.\nBiałka ubić z 1,5 szklanki cukru na gęstą pianę. Przygotować ulubione owoce, najlepsze są wydrylowane wiśnie lub starte grubo jabłka.\nNa natłuszczoną blachę "skubać" małymi kawałkami najpierw jedną część białego ciasta, a następnie ciemne ciasto. Ułożyć grubą warstwę owoców. No owoce wyłożyć pianę z białek. Na to "skubać" drugą część białego ciasta.\nRada: aby lepiej się ciasto "skubało", można je schłodzić, ale nie jest to konieczne, jeśli się nie ma dużo czasu. Tak przygotowane ciasto piec w temp. 180 stopni ok 40-50 minut. Smacznego!',
        4, 96, '2020-01-06 06:10:38'
    ),
    (
        7, 6, 
        'Pleśniak Stryjenki Halinki',
        'https://ocdn.eu/pulscms-transforms/1/UnOk9kpTURBXy85M2ZjODAyZDUzNTUxNWFiYzUxMjM1ZWUxN2E2OWM3MS5qcGeWlQLNAxQAwsOVAgDNAvjCw5QGzP_M_8z_lAbM_8z_zP-UBsz_zP_M_5QGzP_M_8z_gaEwBQ',
        '1. Mieszamy ze sobą mąkę, proszek do pieczenia, cukier i sól\n2. Do dokładnie wymieszanych składników dodajemy rozdrobnione masło. Ważne jest, by masło było zimne. Wówczas można je pokroić nożem na mniejsze partie. Mieszamy masło z resztą składników\n3. Oddzielamy białka od żółtek. Żółtka dodajemy do ciasta, dzięki czemu stanie się ono elastyczne i gotowe do zagniecenia. Ugniatamy do momentu, aż masa stanie się zbita, a składniki złączą się w całość.\n4. Gotowe ciasto dzielimy na trzy części. Do jednej z części dodajemy kakao i ponownie zagniatamy. Wszystkie trzy części ciasta wkładamy do lodówki na 60 minut\n5. Po tym czasie wyjmujemy je z lodówki. Pierwszą część (tę bez dodatku kakao) rozkładamy na blasze o wymiarach 24 x 26 cm. Zapiekamy przez 10 minut w temperaturze 140 stopni Celsjusza\n6. Blachę wyjmujemy z piekarnika. Smarujemy ją dżemem porzeczkowym\n7. Na warstwę dżemu ścieramy kakaową masę ciastową, używając tarki o grubych oczkach\n10. Białka ubijamy w mikserze, dodając na koniec mąkę ziemniaczaną\n11. Masę białkową wykładamy na starte kakaowe ciasto\n12. Następnie na wierzch ścieramy trzecią kulę ciasta, także używając tarki o grubych oczkach\n13. Całość wkładamy do piekarnika rozgrzanego do 180 stopni Celsjusza i pieczemy około 50 minut',
        2, 82, '2020-01-11 07:35:19'
    ),
    (
        9, 6, 
        'Keks Babci Oli',
        'https://ocdn.eu/pulscms-transforms/1/GPtk9kpTURBXy85MjY0ZTA2OGY0ZWMzMmFlNmFkMTQ2NjQxZDQ3OTY2Zi5qcGeWlQLNAxQAwsOVAgDNAvjCw5QGzP_M_8z_lAbM_8z_zP-UBsz_zP_M_5QGzP_M_8z_gaEwBQ',
        'Rodzynki zalać whisky, odstawić na 2 godz., aby nasiąkły. Formę o długości 25 cm wyłożyć papierem do pieczenia, natłuścić.\nMąkę przesiać z proszkiem do pieczenia. Owoce kandyzowane pokroić na kawałki. Miękkie masło rozetrzeć z cukrem, dodawać po jednym jajku, mąkę, sól, skórkę cytrynową i mielone migdały, dobrze wymieszać.\nDodać rodzynki z whisky i kandyzowane owoce. Ciasto przełożyć do formy, wierzch wyrównać.\nPiec na dole piekarnika rozgrzanego do temp. 175°C przez 1 godz. Po 40 min. pieczenia na cieście ułożyć dekoracyjnie wiśnie i migdały (nie wyjmując formy z ciastem z piekarnika).\nSmacznego!',
        1, 51, '2020-01-25 07:04:34'
    ),
    (
        6, 6, 
        'Murzynek Cioci Ireny',
        'https://ocdn.eu/pulscms-transforms/1/iBzk9kqTURBXy81M2NlN2ZmOGQ4YzJkMDFmY2MwZDhkMDQ3MTYxYjlhZi5qcGVnlpUCzQMUAMLDlQIAzQL4wsOUBsz_zP_M_5QGzP_M_8z_lAbM_8z_zP-UBsz_zP_M_4GhMAU',
        'Ubić pianę z białek dodać 0,5 szklanki cukru, ubić do sztywności. Dodać żółtka.\nMargarynę zagotować z pozostała ilością cukru, mlekiem i kakao oraz cukrem wanilinowym.\nWymieszać mąkę z wystudzoną masą, dodać pianę. Piec w 180 st. C około godziny. Można posypać cukrem pudrem albo polać polewą czekoladową.',
        4, 19, '2020-02-01 04:18:28'
    ),
    (
        4, 6, 
        'Ciasto Ucierane Mamy Eli',
        'https://ocdn.eu/pulscms-transforms/1/C8pk9kpTURBXy8wOWRjZTA2NWE0NzExY2ZjYWI0NjMxNWU3ZjVlNzE5OS5qcGeWlQLNAxQAwsOVAgDNAvjCw5QGzP_M_8z_lAbM_8z_zP-UBsz_zP_M_5QGzP_M_8z_gaEwBQ',
        '1. Masło roztopić.\n2. Suche składniki(mąki i proszek do pieczenia) wymieszać.\n3. Jajka rozbić mikserem(można dodać 2 łyżki gazowanej wody mineralnej) po czym ubić ze szklanką cukru i cukrem waniliowym.\n4. Do ubitych jajek dodawać na przemian trochę sypkich składników i ostudzone masło.Miksować na wolnych obrotach aż składniki dobrze się połączą.\n5. Do masy wmieszać część owoców lub bakalie.Wylać na blachę, na wierzchu ułożyć pozostałe owoce.\n6. Piec ok. 50 min.w temperaturze 180 stopni.\nCiasto zawsze się udaje.Jest idealne do kawy czy herbaty.Długo pozostaje świeże.',
        1, 73, '2020-02-09 18:42:25'
    )
;



insert into recipe_ingredients
    (recipe_id, name)
values
    (1, 'opakowanie makaronu spaghetti'),
    (1, '80 g wędzonego boczku w kostce'),
    (1, '50 g parmezanu'),
    (1, 'pół łyżeczki czarnego pieprzu'),
    (1, 'sól do ugotowania makaronu'),
    (2, '500 g świeżego lub mrożonego szpinaku'),
    (2, '200 g sera feta lub tartego sera żółtego'),
    (2, 'tarty parmezan'),
    (2, '150 ml tłustej śmietany'),
    (2, '2 cebule'),
    (2, '4 ząbki czosnku'),
    (2, '500 g makaronu pszennego'),
    (2, '40 g masła'),
    (2, 'sól'),
    (2, 'pieprz'),
    (2, 'gałka muszkatołowa'),
    (3, 'opakowanie makaronu, np. typu świderki'),
    (3, '1 cukinia'),
    (3, '1 opakowanie śmietany'),
    (3, '300 g sera Gouda'),
    (3, '400 g mielonego mięsa'),
    (3, '1 papryka czerwona'),
    (3, '1 papryka zielona'),
    (3, 'koncentrat pomidorowy'),
    (3, 'sól'),
    (3, 'pieprz'),
    (4, '1 duża cebula'),
    (4, 'olej'),
    (4, '1 puszka tuńczyka'),
    (4, '200 ml śmietany kremówki'),
    (4, '1 duży pęczek pietruszki'),
    (4, 'sól'),
    (4, 'pieprz'),
    (4, '200 g makaronu'),
    (5, '250 g makaronu (najlepiej świderki lub inny grubszy makaron)'),
    (5, '200 g twarogu półtłustego'),
    (5, '1/3 szklanki śmietany'),
    (5, '5 łyżeczek cukru'),
    (6, '300 g makaronu penne'),
    (6, '280 g dyniowego puree'),
    (6, '500 g mielonej wieprzowiny'),
    (6, '1 puszka czerwonej fasoli'),
    (6, '250 ml bulionu'),
    (6, 'cebula'),
    (6, '2 ząbki czosnku'),
    (6, '2 cm imbiru'),
    (6, '0,5 łyżeczki wędzonej ostrej papryki'),
    (6, '0,25 łyżeczki kuminu'),
    (6, '0,25 łyżeczki mielonej kolendry'),
    (6, '1 łyżeczka suszonego czosnku niedźwiedziego'),
    (6, '1 łyżeczka suszonego oregano'),
    (6, '0,25 szklanki parmezanu'),
    (6, '1 łyżka oleju kokosowego'),
    (6, 'sól'),
    (6, 'pieprz'),
    (7, '3 niewielkie cukinie'),
    (7, 'pół opakowania dowolnego makaronu'),
    (7, '3 łyżki oliwy'),
    (7, '1 szklanka gęstej śmietany'),
    (7, 'natka pietruszki'),
    (7, 'pół szklanki startego parmezanu'),
    (7, '2 ząbki czosnku'),
    (7, 'sól'),
    (7, 'pieprz'),
    (8, '400 g kurek (mogą być mrożone)'),
    (8, '200 g dowolnego makaronu'),
    (8, '50 g tartego parmezanu albo nieaktywnych płatków drożdżowych'),
    (8, '200 ml śmietanki kremówki albo śmietanki sojowej'),
    (8, 'garść orzechów włoskich'),
    (8, '1 ząbek czosnku'),
    (8, 'natka pietruszki'),
    (8, 'sól'),
    (8, 'pieprz'),
    (9, 'kilka płatów makaronu lasagne'),
    (9, '10 dkg sera Lazur niebieskiego'),
    (9, '15 dkg sera Gorgonzola zielonego'),
    (9, '15 dkg sera pleśniowego koziego (roladka)'),
    (9, '10 dkg sera pleśniowego z orzechami włoskimi'),
    (9, '50 ml mleka 2%'),
    (9, '20 dkg kiełbasy chorizo z pieprzem pokrojonej w kostkę'),
    (9, '15 dkg pieczarek pokrojonych w kostkę'),
    (9, '4 łodygi selera pokrojone w kostkę'),
    (9, '4 szalotki pokrojone w kostkę'),
    (9, '200 ml pomidorków koktajlowych z puszki z zalewą'),
    (9, '4 posiekane ząbki czosnku'),
    (9, '12 listków bazylii'),
    (9, '1 łyżka masła'),
    (10, '500 g wołowego mięsa mielonego'),
    (10, '250 g makaronu cannelloni'),
    (10, '80 g masła'),
    (10, '80 g mąki'),
    (10, '200 g sera mozzarella'),
    (10, '50 g świeżej bazylii'),
    (10, '800 g pomidorów krojonych z puszki'),
    (10, '2 cebule'),
    (10, '1 jajko'),
    (10, '3 ząbki czosnku'),
    (10, '1 gałązka selera naciowego'),
    (10, '1 l mleka'),
    (10, '1 łyżeczka startej gałki muszkatołowej'),
    (10, 'oliwa z oliwek'),
    (10, 'cukier'),
    (10, 'sól'),
    (10, 'pieprz'),
    (11, '3 cukinie'),
    (11, '1 jajko'),
    (11, '1 cebula'),
    (11, 'pół szklanki mąki pszennej'),
    (11, 'olej do smażenia'),
    (11, 'sól'),
    (11, 'pieprz'),
    (12, '500 ml kefiru'),
    (12, '2 jajka'),
    (12, '2 jabłka'),
    (12, '3 szklanki mąki pszennej'),
    (12, '3 łyżki cukru'),
    (12, '2 łyżeczki sody oczyszczonej'),
    (12, 'olej do smażenia'),
    (13, '500 g mąki pszennej'),
    (13, '250 ml mleka'),
    (13, '1 jajko'),
    (13, '1 łyżeczka cukru'),
    (13, '60 g roztopionego i ostudzonego masła'),
    (13, '30 g świeżych drożdży lub 15 g suchych'),
    (13, '1 jajko roztrzepane z 1 łyżką wody'),
    (13, '500 g cebuli'),
    (13, '3 łyżki maku'),
    (13, '2 łyżki oleju'),
    (13, '1 łyżeczka soli'),
    (14, '4 szt duże ziemniaki'),
    (14, '1/2 szklanki cebuli drobno pokrojonej'),
    (14, '1/2 szklanki startego sera żółtego'),
    (14, '2 jajka'),
    (14, '2 łyżki mąki, pieprz ziołowy, sól do smaku'),
    (14, 'olej do smażenia'),
    (15, '2 jajka'),
    (15, '8 łyżek bezglutenowej mąki owsianej'),
    (15, 'sól'),
    (15, 'gazowana woda mineralna'),
    (15, 'dobrej jakości ser pleśniowy albo inny twardszy ser dojrzewający (po 1-2 plasterki na naleśnik)'),
    (15, 'ok. 10 wędzonych śliwek'),
    (15, 'kilka kostek czekolady (ok. 15-20 g)'),
    (15, '3 łyżeczki miodu'),
    (15, 'nierafinowany organiczny olej kokosowy do smażenia'),
    (15, 'garść orzechów włoskich lub nerkowców'),
    (15, 'kilka gałązek świeżego tymianku'),
    (16, '2 buraki'),
    (16, 'sól'),
    (16, 'pieprz'),
    (17, '3kg mąki'),
    (17, '5 jajek'),
    (17, 'sól'),
    (17, 'pieprz'),
    (17, '5kg grzybów'),
    (18, '2 karpie'),
    (18, 'sól'),
    (18, 'pieprz'),
    (18, 'cytryna'),
    (18, 'pietruszka'),
    (18, 'seler'),
    (18, 'cebula'),
    (19, 'przenica'),
    (19, 'mak'),
    (19, 'miód'),
    (19, 'cukier'),
    (19, 'płatki róży'),
    (19, 'bakalie'),
    (20, 'kapusta'),
    (20, 'grzyby'),
    (20, 'ziemniaki'),
    (20, 'cebula'),
    (21, 'suszone owoce'),
    (21, 'goździki'),
    (21, 'cukier'),
    (21, 'pomarańcza'),
    (22, 'karp'),
    (22, 'sok z cytryny'),
    (22, 'sól'),
    (22, 'pieprz'),
    (22, 'cytryna'),
    (23, 'kakao'),
    (23, 'mąka'),
    (23, 'cukier'),
    (23, 'masło'),
    (23, 'proszek do pieczenia'),
    (23, 'masa piernikowa'),
    (23, 'orzechy'),
    (23, 'śliwki'),
    (24, 'mak'),
    (24, 'mleko'),
    (24, 'cukier'),
    (24, 'bakalie'),
    (24, 'miód'),
    (24, 'sól'),
    (25, 'mąka'),
    (25, 'jajka'),
    (25, 'kapusta kiszona'),
    (25, 'sól'),
    (25, 'olej'),
    (25, 'cebula'),
    (26, 'groch'),
    (26, 'kapusta'),
    (26, 'sól'),
    (26, 'liście laurowe'),
    (26, 'pęczak'),
    (26, 'olej'),
    (26, 'cebula'),
    (27, '40g drożdży'),
    (27, '6 łyżek cukru'),
    (27, '180ml mleka'),
    (27, '600g mąki pszennej'),
    (27, 'Szczypta soli'),
    (27, '1 opakowanie cukru waniliowego'),
    (27, '150g margaryny do pieczenia'),
    (27, '6 żółtek'),
    (27, '500g maku'),
    (27, '250g cukru'),
    (27, '100g rodzynek'),
    (27, '1 łyżka miodu'),
    (27, '1 łyżka cynamonu'),
    (27, '1 łyżka margaryny do pieczenia'),
    (27, '6 białek'),
    (27, '3 łyżki gorącej wody'),
    (27, '150g cukru pudru'),
    (27, 'Garść posiekanych orzechów włoskich'),
    (27, 'Garść migdałów'),
    (27, 'Garść kandyzowanej skórki cytrynowej'),
    (28, '1 karp'),
    (28, 'głowa i ogon karpia'),
    (28, '1 łyżeczka żelatyny'),
    (28, '4 cebule'),
    (28, '50 g rodzynek'),
    (28, '50 g migdałów'),
    (28, '5 sztuk goździków'),
    (28, '1 marchew'),
    (28, 'sól'),
    (28, 'pieprz'),
    (28, 'masło'),
    (29, '20 dag nadbużańskich grzybów suszonych'),
    (29, '1 rosołowa porcja warzyw (1 seler, 2 pory, 3 marchewki, 1/4 kapusty, 1 pietruszka)'),
    (29, '1 duża cebula'),
    (29, '2 łyżki masła'),
    (29, '1,5 l wywaru mięsnego (najlepszy na kościach wołowych)'),
    (29, 'pieprz'),
    (29, '20 dag sera korycińskiego z czarnuszką'),
    (29, '1/2 pęczka świeżego koperku do posypania'),
    (29, 'grzanki (opcjonalnie)'),
    (30, '1 kalafior'),
    (30, 'pół pęczka natki pietruszki'),
    (30, '1 czerstwa kajzerka lub pół szklanki bułki tartej'),
    (30, '1 duży lub 2 małe ząbki czosnku'),
    (30, '1 cebula'),
    (30, '2 jajka'),
    (30, 'olej do smażenia'),
    (30, 'przyprawy: 1 łyżeczka majeranku, 1 łyżeczka tymianku, 1 łyżeczka curry, 1 łyżeczka pieprzu ziołowego, pół łyżeczki mielonej gorczycy, pół łyżeczki gałki muszkatołowej, pół łyżeczki papryki chili, sól do smaku'),
    (31, '200 g ryżu'),
    (31, 'oliwa z oliwek'),
    (31, 'olej'),
    (31, 'papryka w proszku'),
    (31, '200 g piersi z kurczaka'),
    (31, 'przyprawy (sól, pieprz)'),
    (31, '2 papryki'),
    (31, '1 cebula'),
    (31, '200 g kukurydzy'),
    (32, '70 dkg ziemniaków, najlepiej podobnej wielkości'),
    (32, '1 por'),
    (32, '1 łyżka oliwy'),
    (32, '1 łyżka masła'),
    (32, '1 łyżka mąki pszennej'),
    (32, '400 ml mleka'),
    (32, 'świeżo starta gałka muszkatołowa'),
    (32, 'sól do smaku'),
    (32, 'pieprz do smaku'),
    (33, '2 wypatroszone pstrągi (po 300 g)'),
    (33, '1 łyżeczka soli'),
    (33, '1/2 łyżeczki pieprzu czarnego'),
    (33, '1 łyżeczka pieprzu ziołowego'),
    (33, '2 łyżeczki przyprawy do ryb'),
    (33, '2 łyżeczki oregano'),
    (33, '1 łyżeczka tymianku'),
    (33, '1 łyżeczka bazylii'),
    (33, '2 łyżeczki wysuszonego czosnku niedźwiedziego'),
    (33, '2 ząbki czosnku'),
    (33, '1 duża cebula'),
    (33, '1 cytryna'),
    (34, '2 szklanki mąki pszennej (a także później do dosypywania)'),
    (34, '1 łyżka masła'),
    (34, '1 jajko'),
    (34, '3/4 szklanki wody'),
    (34, '1 łyżeczka soli'),
    (34, '3 łyżki cukru'),
    (34, '500 g zmielonego twarogu (półtłustego bądź tłustego)'),
    (34, '1 laska wanilii (albo zamiast tego jedno opakowanie cukru waniliowego)'),
    (34, '1 żółtko'),
    (35, '700 gramów piersi z kurczaka'),
    (35, 'kawałek korzenia imbiru'),
    (35, '1 łyżeczka kolendry'),
    (35, '3 liście kaffiru'),
    (35, '1 łyżka oliwy z oliwek'),
    (35, '2 litry wody'),
    (35, '3 łodygi trawy cytrynowej'),
    (35, '300 mililitrów mleczka kokosowego'),
    (35, '2 łyżki cytryny'),
    (35, '1 łyżeczka miodu (opcjonalnie)'),
    (35, '1 mały jogurt naturalny'),
    (35, '1 papryczka chilli'),
    (35, '1 ząbek czosnku'),
    (35, '1 cebula'),
    (35, '50 gramów suszonych borowików'),
    (35, '0,5 szklanki ryżu'),
    (35, '1 marchewka'),
    (35, '1 pietruszka'),
    (35, '1 łyżeczka bazylii'),
    (35, '1 łyżeczka oregano'),
    (35, '1 łyżeczka pieprzu roślinnego'),
    (35, '1 łyżeczka pieprzu cytrynowego'),
    (35, '1 łyżeczka papryki wędzonej'),
    (35, '2 suszone śliwki'),
    (35, '1 garść suszonej żurawiny'),
    (36, '4 plastry wołowiny zrazowej'),
    (36, '4 plastry wędzonego boczku'),
    (36, '4 małe ogórki kiszone'),
    (36, 'musztarda'),
    (36, 'sól'),
    (36, 'pieprz'),
    (36, 'olej'),
    (37, 'pęczek zielonych szparagów'),
    (37, '4 małe, młode ziemniaki'),
    (37, '150 g jogurtu naturalnego (najlepiej greckiego)'),
    (37, '1-2 łyżki soku z cytryny'),
    (37, '1/2 pęczka koperku'),
    (37, 'szczypta świeżo startej gałki muszkatołowej'),
    (37, 'sól, pieprz'),
    (38, '500 g botwinki z burakami'),
    (38, '300 g ziemniaków'),
    (38, '100 g selera'),
    (38, '1 cebula drobno posiekana'),
    (38, '30 g masła'),
    (38, '1 l bulionu z warzyw'),
    (38, 'listek laurowy'),
    (38, 'sól morska'),
    (38, 'pieprz świeżo mielony'),
    (38, '2 jajka'),
    (38, '2 łyżki soku z cytryny'),
    (38, '250 ml śmietany 18%'),
    (39, 'Skrzydełka z kurczaka (lub inne mięso na bulion)'),
    (39, 'Duży pęczek koperku'),
    (39, 'Marchew'),
    (39, 'Pietruszka'),
    (39, 'Seler'),
    (39, 'Por'),
    (39, '1/2 szklanki śmietany'),
    (39, 'Ziemniaki, ryż lub makaron'),
    (39, '2 liście laurowe'),
    (39, '3 kulki ziela angielskiego'),
    (39, 'Sól, pieprz'),
    (40, '1 pęczek botwiny'),
    (40, 'pół pęczka rzodkiewek'),
    (40, 'pół pęczka szczypiorku'),
    (40, '0,5 l kefiru lub jogurtu naturalnego'),
    (40, 'sok z połówki cytryny'),
    (40, 'szczypta cukru'),
    (40, 'szczypta soli'),
    (40, 'pół świeżego ogórka'),
    (41, '2 litry wody,'),
    (41, '2 marchewki, pietruszkę, por oraz seler (może to być gotowy zestaw włoszczyzny),'),
    (41, '1 cebulę,'),
    (41, 'pół kilo żeberek wieprzowych,'),
    (41, 'porcję rosołową z kurczaka lub indyczą szyję,'),
    (41, '2 listki laurowe,'),
    (41, '2 ziela angielskie,'),
    (41, '300 g szczawiu,'),
    (41, '250 g śmietany 18%,'),
    (41, '1 łyżka mąki'),
    (42, '1,2 kg jabłek (najlepsze antonówki)'),
    (42, '4-6 łyżek kandyzowanej skórki pomarańczowej'),
    (42, '10 dag rodzynek'),
    (42, '4 jajka'),
    (42, '1,5 szklanki cukru'),
    (42, '12 łyżek oleju'),
    (42, '4 szklanki mąki'),
    (42, '2 pełne łyżeczki proszku do pieczenia'),
    (42, '4 łyżki kakao'),
    (43, '1/2 kg sera'),
    (43, '1 szklanka cukru'),
    (43, '3 jajka'),
    (43, '6 łyżeczek roztopionego masła'),
    (43, '1 budyń waniliowy'),
    (43, 'rodzynki'),
    (43, 'gdyby był za gęsty - dodać mleko'),
    (44, '0,5 kg mąki'),
    (44, '6 jajek'),
    (44, 'kostka margaryny + 1 łyżka oleju'),
    (44, '3 łyżki cukru do ciasta + 1,5 szklanki do piany'),
    (44, 'cukier waniliowy'),
    (44, '3 łyżeczki proszku do pieczenia'),
    (44, '3 łyżki kakao'),
    (44, '1 kg ulubionych owoców'),
    (45, '250 g masła 82%'),
    (45, '2,5 szklanki mąki tortowej'),
    (45, '1,5 łyżeczki proszku do pieczenia'),
    (45, 'szczypta soli'),
    (45, '4 jajka'),
    (45, '4 łyżki cukru'),
    (45, '2 łyżki mąki ziemniaczanej'),
    (45, '2 łyżki kakao'),
    (45, '500 ml dżemu z czarnej porzeczki'),
    (46, '200 g rodzynek'),
    (46, 'kieliszek whisky lub rumu'),
    (46, '1/2 kostki masła'),
    (46, '125 g cukru'),
    (46, '3 jajka'),
    (46, 'szczypta soli'),
    (46, '1 łyżeczka skórki startej z cytryny'),
    (46, '1 czubata szklanki mąki'),
    (46, '50 g mielonych migdałów'),
    (46, '1 czubata łyżeczka proszku do pieczenia'),
    (46, 'po 50 g smażonej skórki z pomarańczy i cytryny'),
    (46, '100 g różnych owoców kandyzowanych'),
    (46, '50 g obranych migdałów'),
    (46, '10 kandyzowanych wiśni'),
    (47, '1 kostka margaryny'),
    (47, '1 szklanka cukru'),
    (47, '0,5 szklanki mleka lub wody'),
    (47, '2 łyżki kakao'),
    (47, 'cukier wanilinowy'),
    (47, '2 szklanki mąki'),
    (47, '4-5 jaj'),
    (48, '5 jajek'),
    (48, 'szklanka cukru'),
    (48, 'opakowanie (lub dwa) cukru waniliowego'),
    (48, '2 czubate łyżeczki proszku do pieczenia'),
    (48, '2 szklanki mąki pszennej'),
    (48, '2 czubate łyżki mąki ziemniaczanej'),
    (48, 'kostka masła/ ew. margaryny'),
    (48, 'Owoce (np. śliwki, rabarbar, truskawki)'),
    (48, 'lub bakalie (orzechy, rodzynki, żurawina itp.) - jak na zdjęciu')
;

insert into recipe_rating
    (recipe_id, user_id, value, created_date)
values
    (7, 5, 2, '2019-02-01 12:46:01'),
    (36, 12, 2, '2019-02-03 15:45:32'),
    (24, 9, 4, '2019-02-04 22:21:35'),
    (9, 4, 1, '2019-02-06 10:41:43'),
    (24, 10, 4, '2019-02-08 11:58:29'),
    (15, 9, 2, '2019-02-15 15:32:46'),
    (21, 1, 5, '2019-02-22 13:00:02'),
    (25, 11, 2, '2019-02-25 13:45:57'),
    (30, 2, 2, '2019-03-01 14:42:54'),
    (35, 10, 1, '2019-03-03 08:21:49'),
    (42, 12, 5, '2019-03-03 12:07:50'),
    (17, 9, 5, '2019-03-07 21:40:27'),
    (19, 4, 4, '2019-03-13 00:40:56'),
    (5, 1, 3, '2019-03-15 14:15:46'),
    (43, 5, 1, '2019-03-22 11:32:55'),
    (15, 5, 5, '2019-03-28 13:57:09'),
    (28, 7, 5, '2019-03-31 14:23:14'),
    (32, 11, 3, '2019-04-07 14:12:22'),
    (2, 1, 1, '2019-04-10 13:56:18'),
    (43, 7, 2, '2019-04-17 14:31:00'),
    (32, 3, 1, '2019-04-19 11:36:18'),
    (8, 3, 4, '2019-04-21 15:54:26'),
    (22, 8, 4, '2019-04-23 22:16:38'),
    (47, 10, 3, '2019-04-30 00:20:57'),
    (13, 3, 1, '2019-05-03 05:06:04'),
    (27, 5, 2, '2019-05-06 10:14:56'),
    (5, 11, 5, '2019-05-13 00:01:42'),
    (42, 1, 1, '2019-05-15 18:17:39'),
    (38, 3, 5, '2019-05-17 03:53:40'),
    (44, 10, 4, '2019-05-22 14:32:48'),
    (6, 6, 4, '2019-05-23 01:47:34'),
    (44, 2, 3, '2019-05-29 12:03:16'),
    (17, 1, 3, '2019-06-01 10:26:01'),
    (40, 8, 4, '2019-06-04 06:55:04'),
    (46, 3, 4, '2019-06-09 04:37:30'),
    (31, 6, 3, '2019-06-09 19:00:55'),
    (28, 8, 3, '2019-06-12 22:51:47'),
    (18, 3, 1, '2019-06-16 13:03:10'),
    (36, 8, 3, '2019-06-19 02:31:29'),
    (47, 12, 2, '2019-06-21 18:09:18'),
    (20, 7, 3, '2019-06-25 08:43:52'),
    (44, 7, 3, '2019-06-25 11:12:17'),
    (34, 3, 3, '2019-06-28 23:49:10'),
    (40, 10, 5, '2019-07-01 18:36:09'),
    (45, 7, 5, '2019-07-02 02:01:02'),
    (15, 3, 2, '2019-07-05 10:50:23'),
    (8, 11, 3, '2019-07-08 22:37:06'),
    (21, 10, 2, '2019-07-12 08:17:31'),
    (13, 12, 2, '2019-07-12 11:30:09'),
    (38, 4, 3, '2019-07-17 15:34:05'),
    (32, 12, 5, '2019-07-17 21:35:28'),
    (18, 4, 3, '2019-07-20 12:41:59'),
    (11, 7, 4, '2019-07-27 01:56:21'),
    (5, 2, 1, '2019-07-27 14:31:12'),
    (44, 4, 4, '2019-07-27 19:31:57'),
    (24, 9, 3, '2019-07-28 07:17:01'),
    (3, 11, 4, '2019-07-30 08:06:30'),
    (9, 4, 1, '2019-08-01 17:23:00'),
    (16, 6, 1, '2019-08-06 02:04:10'),
    (28, 5, 2, '2019-08-07 22:21:04'),
    (27, 11, 5, '2019-08-14 03:00:36'),
    (22, 4, 3, '2019-08-17 09:58:42'),
    (5, 1, 5, '2019-08-21 16:55:20'),
    (11, 4, 5, '2019-08-23 16:20:19'),
    (25, 12, 4, '2019-08-24 04:22:58'),
    (35, 10, 1, '2019-08-28 19:12:26'),
    (11, 10, 4, '2019-08-29 21:58:05'),
    (5, 6, 1, '2019-09-04 01:47:01'),
    (44, 10, 5, '2019-09-11 03:43:51'),
    (6, 11, 2, '2019-09-17 08:18:36'),
    (28, 1, 5, '2019-09-24 02:23:23'),
    (2, 4, 5, '2019-09-26 19:12:16'),
    (22, 3, 3, '2019-10-02 00:53:02'),
    (8, 11, 3, '2019-10-05 14:52:41'),
    (40, 5, 4, '2019-10-06 15:28:59'),
    (3, 3, 2, '2019-10-07 07:11:55'),
    (36, 8, 4, '2019-10-09 02:12:24'),
    (5, 4, 2, '2019-10-11 08:27:41'),
    (34, 6, 1, '2019-10-12 15:40:53'),
    (36, 5, 2, '2019-10-19 18:26:59'),
    (20, 4, 1, '2019-10-26 16:30:02'),
    (26, 5, 5, '2019-10-31 09:40:21'),
    (25, 10, 4, '2019-11-02 07:28:04'),
    (21, 11, 4, '2019-11-03 20:45:47'),
    (7, 11, 3, '2019-11-09 10:10:23'),
    (35, 6, 2, '2019-11-13 00:30:00'),
    (17, 6, 4, '2019-11-14 16:38:11'),
    (29, 5, 4, '2019-11-15 09:42:12'),
    (45, 1, 4, '2019-11-20 23:27:48'),
    (20, 10, 3, '2019-11-23 20:01:15'),
    (28, 11, 1, '2019-11-30 10:29:33'),
    (4, 10, 2, '2019-12-06 14:15:06'),
    (37, 9, 3, '2019-12-13 14:08:20'),
    (25, 1, 3, '2019-12-13 18:49:16'),
    (33, 11, 4, '2019-12-20 12:11:16'),
    (45, 5, 3, '2019-12-21 13:56:48'),
    (10, 2, 4, '2019-12-26 20:21:57'),
    (9, 8, 5, '2020-01-03 00:08:31'),
    (25, 10, 2, '2020-01-08 00:06:47'),
    (35, 5, 5, '2020-01-09 20:16:38')
;


insert into recipe_comment
    (recipe_id, user_id, content, likes, dislikes, created_date)
values
    (11,10,'Ut tellus. Nulla ut erat id mauris vulputate elementum. Nullam varius. Nulla facilisi. Cras non velit nec nisi vulputate nonummy. Maecenas tincidunt lacus at velit. Vivamus vel nulla eget eros elementum pellentesque. Quisque porta volutpat erat.',2,4,'2020-01-23 13:34:17'),
    (30,8,'In hac habitasse platea dictumst. Maecenas ut massa quis augue luctus tincidunt. Nulla mollis molestie lorem. Quisque ut erat. Curabitur gravida nisi at nibh. In hac habitasse platea dictumst. Aliquam augue quam, sollicitudin vitae, consectetuer eget, rutrum at, lorem. Integer tincidunt ante vel ipsum. Praesent blandit lacinia erat.',2,8,'2020-10-31 10:10:01'),
    (8,8,'Quisque id justo sit amet sapien dignissim vestibulum. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Nulla dapibus dolor vel est. Donec odio justo, sollicitudin ut, suscipit a, feugiat et, eros. Vestibulum ac est lacinia nisi venenatis tristique. Fusce congue, diam id ornare imperdiet, sapien urna pretium nisl, ut volutpat sapien arcu sed augue. Aliquam erat volutpat.',6,5,'2020-06-25 09:29:20'),
    (29,3,'Nulla nisl. Nunc nisl. Duis bibendum, felis sed interdum venenatis, turpis enim blandit mi, in porttitor pede justo eu massa.',5,3,'2019-11-22 03:42:55'),
    (34,4,'Ut at dolor quis odio consequat varius. Integer ac leo. Pellentesque ultrices mattis odio. Donec vitae nisi. Nam ultrices, libero non mattis pulvinar, nulla pede ullamcorper augue, a suscipit nulla elit ac nulla. Sed vel enim sit amet nunc viverra dapibus. Nulla suscipit ligula in lacus. Curabitur at ipsum ac tellus semper interdum. Mauris ullamcorper purus sit amet nulla. Quisque arcu libero, rutrum ac, lobortis vel, dapibus at, diam.',6,4,'2019-05-05 18:08:17'),
    (48,6,'Etiam vel augue.',1,10,'2020-11-04 06:36:12'),
    (21,1,'Nulla tellus. In sagittis dui vel nisl.',8,3,'2019-01-04 09:13:56'),
    (41,1,'Nam dui. Proin leo odio, porttitor id, consequat in, consequat ut, nulla. Sed accumsan felis. Ut at dolor quis odio consequat varius. Integer ac leo. Pellentesque ultrices mattis odio. Donec vitae nisi.',8,2,'2020-02-10 09:57:27'),
    (3,9,'Phasellus in felis. Donec semper sapien a libero. Nam dui. Proin leo odio, porttitor id, consequat in, consequat ut, nulla. Sed accumsan felis. Ut at dolor quis odio consequat varius. Integer ac leo. Pellentesque ultrices mattis odio. Donec vitae nisi.',8,10,'2019-04-18 08:25:51'),
    (15,10,'Fusce congue, diam id ornare imperdiet, sapien urna pretium nisl, ut volutpat sapien arcu sed augue. Aliquam erat volutpat. In congue. Etiam justo. Etiam pretium iaculis justo.',8,8,'2020-11-21 23:47:25'),
    (16,9,'Phasellus sit amet erat. Nulla tempus. Vivamus in felis eu sapien cursus vestibulum. Proin eu mi. Nulla ac enim. In tempor, turpis nec euismod scelerisque, quam turpis adipiscing lorem, vitae mattis nibh ligula nec sem. Duis aliquam convallis nunc. Proin at turpis a pede posuere nonummy.',6,10,'2019-03-08 06:08:16'),
    (29,2,'Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Mauris viverra diam vitae quam. Suspendisse potenti. Nullam porttitor lacus at turpis. Donec posuere metus vitae ipsum. Aliquam non mauris.',3,8,'2020-02-11 04:45:31'),
    (41,9,'Nulla facilisi. Cras non velit nec nisi vulputate nonummy. Maecenas tincidunt lacus at velit. Vivamus vel nulla eget eros elementum pellentesque. Quisque porta volutpat erat.',7,2,'2020-06-07 21:34:51'),
    (26,5,'Mauris sit amet eros. Suspendisse accumsan tortor quis turpis. Sed ante. Vivamus tortor. Duis mattis egestas metus. Aenean fermentum.',5,4,'2019-10-21 23:24:18'),
    (30,4,'Vestibulum quam sapien, varius ut, blandit non, interdum in, ante. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Duis faucibus accumsan odio. Curabitur convallis.',1,2,'2019-01-06 21:54:26'),
    (2,3,'Pellentesque ultrices mattis odio. Donec vitae nisi. Nam ultrices, libero non mattis pulvinar, nulla pede ullamcorper augue, a suscipit nulla elit ac nulla.',9,1,'2019-09-12 11:52:44'),
    (12,4,'Donec semper sapien a libero. Nam dui. Proin leo odio, porttitor id, consequat in, consequat ut, nulla. Sed accumsan felis. Ut at dolor quis odio consequat varius. Integer ac leo. Pellentesque ultrices mattis odio.',6,8,'2020-02-07 06:53:27'),
    (27,1,'Nam ultrices, libero non mattis pulvinar, nulla pede ullamcorper augue, a suscipit nulla elit ac nulla. Sed vel enim sit amet nunc viverra dapibus. Nulla suscipit ligula in lacus. Curabitur at ipsum ac tellus semper interdum. Mauris ullamcorper purus sit amet nulla. Quisque arcu libero, rutrum ac, lobortis vel, dapibus at, diam.',1,3,'2020-06-04 22:47:24'),
    (4,11,'Fusce lacus purus, aliquet at, feugiat non, pretium quis, lectus. Suspendisse potenti.',5,2,'2020-12-23 22:05:44'),
    (6,5,'In hac habitasse platea dictumst. Aliquam augue quam, sollicitudin vitae, consectetuer eget, rutrum at, lorem. Integer tincidunt ante vel ipsum. Praesent blandit lacinia erat. Vestibulum sed magna at nunc commodo placerat. Praesent blandit. Nam nulla. Integer pede justo, lacinia eget, tincidunt eget, tempus vel, pede.',6,10,'2020-05-23 21:17:31'),
    (47,2,'Nulla ac enim. In tempor, turpis nec euismod scelerisque, quam turpis adipiscing lorem, vitae mattis nibh ligula nec sem.',9,8,'2020-07-24 11:59:34'),
    (43,7,'Vestibulum ac est lacinia nisi venenatis tristique. Fusce congue, diam id ornare imperdiet, sapien urna pretium nisl, ut volutpat sapien arcu sed augue. Aliquam erat volutpat. In congue. Etiam justo. Etiam pretium iaculis justo.',5,2,'2020-12-04 04:33:31'),
    (44,3,'Aenean sit amet justo. Morbi ut odio. Cras mi pede, malesuada in, imperdiet et, commodo vulputate, justo. In blandit ultrices enim.',10,3,'2019-02-18 22:11:57'),
    (6,5,'Vestibulum quam sapien, varius ut, blandit non, interdum in, ante. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Duis faucibus accumsan odio.',5,3,'2019-05-28 08:43:09'),
    (28,3,'Integer non velit. Donec diam neque, vestibulum eget, vulputate ut, ultrices vel, augue.',8,9,'2019-11-11 21:47:43'),
    (18,11,'Nulla facilisi. Cras non velit nec nisi vulputate nonummy. Maecenas tincidunt lacus at velit. Vivamus vel nulla eget eros elementum pellentesque. Quisque porta volutpat erat.',2,7,'2019-11-27 13:18:38'),
    (21,2,'Nulla mollis molestie lorem. Quisque ut erat.',6,9,'2019-01-31 09:31:08'),
    (47,3,'Donec quis orci eget orci vehicula condimentum. Curabitur in libero ut massa volutpat convallis. Morbi odio odio, elementum eu, interdum eu, tincidunt in, leo. Maecenas pulvinar lobortis est. Phasellus sit amet erat. Nulla tempus. Vivamus in felis eu sapien cursus vestibulum. Proin eu mi. Nulla ac enim. In tempor, turpis nec euismod scelerisque, quam turpis adipiscing lorem, vitae mattis nibh ligula nec sem.',3,2,'2020-12-22 19:28:41'),
    (30,4,'Nunc purus. Phasellus in felis. Donec semper sapien a libero. Nam dui. Proin leo odio, porttitor id, consequat in, consequat ut, nulla. Sed accumsan felis. Ut at dolor quis odio consequat varius.',10,5,'2020-05-10 08:25:26'),
    (39,7,'Fusce congue, diam id ornare imperdiet, sapien urna pretium nisl, ut volutpat sapien arcu sed augue. Aliquam erat volutpat.',1,3,'2020-11-25 09:43:13'),
    (46,9,'In blandit ultrices enim. Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Proin interdum mauris non ligula pellentesque ultrices. Phasellus id sapien in sapien iaculis congue. Vivamus metus arcu, adipiscing molestie, hendrerit at, vulputate vitae, nisl. Aenean lectus. Pellentesque eget nunc. Donec quis orci eget orci vehicula condimentum. Curabitur in libero ut massa volutpat convallis.',4,2,'2019-05-02 05:21:31'),
    (23,12,'Vestibulum ac est lacinia nisi venenatis tristique. Fusce congue, diam id ornare imperdiet, sapien urna pretium nisl, ut volutpat sapien arcu sed augue. Aliquam erat volutpat. In congue. Etiam justo. Etiam pretium iaculis justo.',1,6,'2019-03-12 13:19:26'),
    (46,5,'Vivamus in felis eu sapien cursus vestibulum. Proin eu mi. Nulla ac enim.',1,3,'2019-01-31 09:18:02'),
    (16,12,'Vestibulum ac est lacinia nisi venenatis tristique. Fusce congue, diam id ornare imperdiet, sapien urna pretium nisl, ut volutpat sapien arcu sed augue. Aliquam erat volutpat. In congue. Etiam justo. Etiam pretium iaculis justo. In hac habitasse platea dictumst. Etiam faucibus cursus urna. Ut tellus. Nulla ut erat id mauris vulputate elementum.',5,3,'2019-02-13 21:12:45'),
    (16,4,'Pellentesque ultrices mattis odio. Donec vitae nisi.',7,3,'2020-03-27 04:19:13'),
    (6,3,'Etiam justo. Etiam pretium iaculis justo.',6,1,'2020-09-18 09:20:53'),
    (25,8,'Etiam pretium iaculis justo. In hac habitasse platea dictumst. Etiam faucibus cursus urna. Ut tellus.',5,4,'2019-04-11 09:31:38'),
    (41,10,'In hac habitasse platea dictumst. Etiam faucibus cursus urna. Ut tellus. Nulla ut erat id mauris vulputate elementum. Nullam varius.',8,10,'2019-07-06 16:16:28'),
    (19,7,'Duis bibendum. Morbi non quam nec dui luctus rutrum. Nulla tellus. In sagittis dui vel nisl. Duis ac nibh. Fusce lacus purus, aliquet at, feugiat non, pretium quis, lectus. Suspendisse potenti. In eleifend quam a odio. In hac habitasse platea dictumst. Maecenas ut massa quis augue luctus tincidunt.',8,7,'2019-09-12 12:06:49'),
    (3,12,'Duis at velit eu est congue elementum. In hac habitasse platea dictumst. Morbi vestibulum, velit id pretium iaculis, diam erat fermentum justo, nec condimentum neque sapien placerat ante. Nulla justo. Aliquam quis turpis eget elit sodales scelerisque. Mauris sit amet eros. Suspendisse accumsan tortor quis turpis.',5,2,'2019-12-07 19:26:22'),
    (7,9,'Pellentesque viverra pede ac diam. Cras pellentesque volutpat dui. Maecenas tristique, est et tempus semper, est quam pharetra magna, ac consequat metus sapien ut nunc. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Mauris viverra diam vitae quam. Suspendisse potenti. Nullam porttitor lacus at turpis. Donec posuere metus vitae ipsum. Aliquam non mauris. Morbi non lectus. Aliquam sit amet diam in magna bibendum imperdiet.',10,3,'2019-11-05 12:35:54'),
    (35,4,'Nulla tempus. Vivamus in felis eu sapien cursus vestibulum. Proin eu mi. Nulla ac enim.',1,5,'2019-11-26 16:58:41'),
    (45,2,'Maecenas leo odio, condimentum id, luctus nec, molestie sed, justo. Pellentesque viverra pede ac diam. Cras pellentesque volutpat dui. Maecenas tristique, est et tempus semper, est quam pharetra magna, ac consequat metus sapien ut nunc. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Mauris viverra diam vitae quam. Suspendisse potenti. Nullam porttitor lacus at turpis.',9,3,'2020-03-31 02:27:04'),
    (39,12,'Vivamus vel nulla eget eros elementum pellentesque. Quisque porta volutpat erat. Quisque erat eros, viverra eget, congue eget, semper rutrum, nulla. Nunc purus. Phasellus in felis. Donec semper sapien a libero.',1,6,'2020-10-08 18:32:53'),
    (26,3,'Maecenas pulvinar lobortis est. Phasellus sit amet erat. Nulla tempus. Vivamus in felis eu sapien cursus vestibulum. Proin eu mi. Nulla ac enim.',7,7,'2019-07-21 15:43:02'),
    (30,3,'Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Nulla dapibus dolor vel est.',3,1,'2019-03-29 01:18:01'),
    (33,6,'Proin at turpis a pede posuere nonummy. Integer non velit. Donec diam neque, vestibulum eget, vulputate ut, ultrices vel, augue.',3,7,'2020-05-22 01:15:28'),
    (3,8,'Morbi porttitor lorem id ligula. Suspendisse ornare consequat lectus. In est risus, auctor sed, tristique in, tempus sit amet, sem. Fusce consequat. Nulla nisl. Nunc nisl. Duis bibendum, felis sed interdum venenatis, turpis enim blandit mi, in porttitor pede justo eu massa. Donec dapibus. Duis at velit eu est congue elementum. In hac habitasse platea dictumst.',7,2,'2019-06-03 20:42:40'),
    (22,8,'In hac habitasse platea dictumst. Aliquam augue quam, sollicitudin vitae, consectetuer eget, rutrum at, lorem. Integer tincidunt ante vel ipsum.',5,3,'2020-07-31 20:15:47'),
    (33,2,'Nulla justo. Aliquam quis turpis eget elit sodales scelerisque. Mauris sit amet eros. Suspendisse accumsan tortor quis turpis.',9,7,'2020-05-31 04:35:54'),
    (48,2,'Maecenas rhoncus aliquam lacus. Morbi quis tortor id nulla ultrices aliquet. Maecenas leo odio, condimentum id, luctus nec, molestie sed, justo. Pellentesque viverra pede ac diam.',5,5,'2019-02-12 10:05:51'),
    (35,3,'Suspendisse potenti. In eleifend quam a odio. In hac habitasse platea dictumst. Maecenas ut massa quis augue luctus tincidunt. Nulla mollis molestie lorem.',4,4,'2020-10-18 09:02:35'),
    (12,2,'Proin at turpis a pede posuere nonummy. Integer non velit.',4,7,'2020-07-12 16:56:04'),
    (35,6,'Donec posuere metus vitae ipsum. Aliquam non mauris. Morbi non lectus. Aliquam sit amet diam in magna bibendum imperdiet. Nullam orci pede, venenatis non, sodales sed, tincidunt eu, felis. Fusce posuere felis sed lacus. Morbi sem mauris, laoreet ut, rhoncus aliquet, pulvinar sed, nisl. Nunc rhoncus dui vel sem.',5,1,'2019-04-08 19:31:39'),
    (24,7,'Cras non velit nec nisi vulputate nonummy. Maecenas tincidunt lacus at velit. Vivamus vel nulla eget eros elementum pellentesque. Quisque porta volutpat erat. Quisque erat eros, viverra eget, congue eget, semper rutrum, nulla. Nunc purus. Phasellus in felis. Donec semper sapien a libero. Nam dui.',1,8,'2020-08-25 09:12:54'),
    (16,11,'Maecenas rhoncus aliquam lacus.',3,10,'2019-11-13 16:52:25'),
    (31,5,'Sed sagittis.',1,4,'2019-02-19 15:41:34'),
    (39,2,'Sed accumsan felis. Ut at dolor quis odio consequat varius. Integer ac leo.',8,3,'2019-10-27 05:35:37'),
    (13,9,'Nulla justo. Aliquam quis turpis eget elit sodales scelerisque. Mauris sit amet eros. Suspendisse accumsan tortor quis turpis. Sed ante. Vivamus tortor. Duis mattis egestas metus.',9,1,'2020-02-07 13:10:58'),
    (43,6,'Integer non velit. Donec diam neque, vestibulum eget, vulputate ut, ultrices vel, augue. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Donec pharetra, magna vestibulum aliquet ultrices, erat tortor sollicitudin mi, sit amet lobortis sapien sapien non mi. Integer ac neque. Duis bibendum. Morbi non quam nec dui luctus rutrum. Nulla tellus. In sagittis dui vel nisl.',10,8,'2019-10-08 07:00:05'),
    (22,7,'Morbi non quam nec dui luctus rutrum. Nulla tellus. In sagittis dui vel nisl. Duis ac nibh. Fusce lacus purus, aliquet at, feugiat non, pretium quis, lectus.',4,8,'2020-03-27 04:52:31'),
    (18,1,'Duis bibendum. Morbi non quam nec dui luctus rutrum. Nulla tellus. In sagittis dui vel nisl. Duis ac nibh. Fusce lacus purus, aliquet at, feugiat non, pretium quis, lectus.',4,9,'2019-10-21 10:54:58'),
    (32,9,'Nunc rhoncus dui vel sem. Sed sagittis. Nam congue, risus semper porta volutpat, quam pede lobortis ligula, sit amet eleifend pede libero quis orci. Nullam molestie nibh in lectus. Pellentesque at nulla. Suspendisse potenti. Cras in purus eu magna vulputate luctus. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Vivamus vestibulum sagittis sapien. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus.',5,10,'2019-06-01 05:32:52'),
    (41,5,'Morbi ut odio. Cras mi pede, malesuada in, imperdiet et, commodo vulputate, justo.',6,6,'2019-02-14 10:48:31'),
    (28,1,'Maecenas leo odio, condimentum id, luctus nec, molestie sed, justo.',6,7,'2019-11-05 00:48:05'),
    (25,9,'Suspendisse accumsan tortor quis turpis. Sed ante. Vivamus tortor. Duis mattis egestas metus. Aenean fermentum.',1,8,'2020-08-17 21:40:45'),
    (34,6,'Aenean fermentum.',3,3,'2019-07-23 22:14:08'),
    (9,3,'Duis bibendum. Morbi non quam nec dui luctus rutrum.',7,7,'2020-04-05 05:25:39'),
    (22,6,'Cras mi pede, malesuada in, imperdiet et, commodo vulputate, justo. In blandit ultrices enim. Lorem ipsum dolor sit amet, consectetuer adipiscing elit.',6,3,'2020-06-02 07:02:13'),
    (46,8,'Quisque ut erat. Curabitur gravida nisi at nibh. In hac habitasse platea dictumst. Aliquam augue quam, sollicitudin vitae, consectetuer eget, rutrum at, lorem. Integer tincidunt ante vel ipsum. Praesent blandit lacinia erat. Vestibulum sed magna at nunc commodo placerat. Praesent blandit. Nam nulla.',4,10,'2019-03-05 10:54:12'),
    (30,8,'Mauris lacinia sapien quis libero.',6,7,'2019-03-01 02:12:46'),
    (27,9,'Maecenas tristique, est et tempus semper, est quam pharetra magna, ac consequat metus sapien ut nunc. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Mauris viverra diam vitae quam. Suspendisse potenti. Nullam porttitor lacus at turpis. Donec posuere metus vitae ipsum.',5,1,'2020-01-23 09:39:56'),
    (11,9,'Sed vel enim sit amet nunc viverra dapibus. Nulla suscipit ligula in lacus. Curabitur at ipsum ac tellus semper interdum. Mauris ullamcorper purus sit amet nulla. Quisque arcu libero, rutrum ac, lobortis vel, dapibus at, diam. Nam tristique tortor eu pede.',6,9,'2020-04-03 09:30:57'),
    (42,7,'Nulla nisl. Nunc nisl. Duis bibendum, felis sed interdum venenatis, turpis enim blandit mi, in porttitor pede justo eu massa. Donec dapibus. Duis at velit eu est congue elementum. In hac habitasse platea dictumst. Morbi vestibulum, velit id pretium iaculis, diam erat fermentum justo, nec condimentum neque sapien placerat ante. Nulla justo. Aliquam quis turpis eget elit sodales scelerisque. Mauris sit amet eros.',8,5,'2019-01-05 12:04:54'),
    (4,5,'Cras in purus eu magna vulputate luctus. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Vivamus vestibulum sagittis sapien.',10,9,'2019-01-23 18:44:59'),
    (31,9,'Aliquam sit amet diam in magna bibendum imperdiet. Nullam orci pede, venenatis non, sodales sed, tincidunt eu, felis. Fusce posuere felis sed lacus. Morbi sem mauris, laoreet ut, rhoncus aliquet, pulvinar sed, nisl. Nunc rhoncus dui vel sem. Sed sagittis. Nam congue, risus semper porta volutpat, quam pede lobortis ligula, sit amet eleifend pede libero quis orci. Nullam molestie nibh in lectus. Pellentesque at nulla. Suspendisse potenti.',8,6,'2020-10-25 06:49:41'),
    (11,12,'Vivamus metus arcu, adipiscing molestie, hendrerit at, vulputate vitae, nisl. Aenean lectus. Pellentesque eget nunc. Donec quis orci eget orci vehicula condimentum. Curabitur in libero ut massa volutpat convallis. Morbi odio odio, elementum eu, interdum eu, tincidunt in, leo. Maecenas pulvinar lobortis est. Phasellus sit amet erat. Nulla tempus.',3,6,'2019-01-12 09:17:13'),
    (27,7,'Maecenas ut massa quis augue luctus tincidunt. Nulla mollis molestie lorem. Quisque ut erat. Curabitur gravida nisi at nibh. In hac habitasse platea dictumst.',10,10,'2020-05-04 08:21:32'),
    (41,10,'Donec quis orci eget orci vehicula condimentum. Curabitur in libero ut massa volutpat convallis. Morbi odio odio, elementum eu, interdum eu, tincidunt in, leo. Maecenas pulvinar lobortis est. Phasellus sit amet erat.',7,9,'2020-09-14 15:43:23'),
    (46,5,'Pellentesque at nulla. Suspendisse potenti. Cras in purus eu magna vulputate luctus. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Vivamus vestibulum sagittis sapien. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Etiam vel augue. Vestibulum rutrum rutrum neque. Aenean auctor gravida sem.',9,4,'2019-12-13 14:37:01'),
    (31,5,'Maecenas pulvinar lobortis est. Phasellus sit amet erat. Nulla tempus. Vivamus in felis eu sapien cursus vestibulum. Proin eu mi. Nulla ac enim. In tempor, turpis nec euismod scelerisque, quam turpis adipiscing lorem, vitae mattis nibh ligula nec sem. Duis aliquam convallis nunc. Proin at turpis a pede posuere nonummy.',5,3,'2020-03-28 15:29:29'),
    (4,8,'Morbi vel lectus in quam fringilla rhoncus. Mauris enim leo, rhoncus sed, vestibulum sit amet, cursus id, turpis. Integer aliquet, massa id lobortis convallis, tortor risus dapibus augue, vel accumsan tellus nisi eu orci.',10,9,'2019-07-03 10:55:39'),
    (36,12,'Fusce lacus purus, aliquet at, feugiat non, pretium quis, lectus. Suspendisse potenti. In eleifend quam a odio. In hac habitasse platea dictumst. Maecenas ut massa quis augue luctus tincidunt.',10,7,'2020-11-14 14:34:54'),
    (48,5,'Donec quis orci eget orci vehicula condimentum. Curabitur in libero ut massa volutpat convallis. Morbi odio odio, elementum eu, interdum eu, tincidunt in, leo. Maecenas pulvinar lobortis est.',1,5,'2020-11-19 15:03:09'),
    (11,1,'Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Etiam vel augue. Vestibulum rutrum rutrum neque. Aenean auctor gravida sem. Praesent id massa id nisl venenatis lacinia. Aenean sit amet justo. Morbi ut odio.',10,9,'2020-07-06 05:16:32'),
    (34,11,'Vestibulum rutrum rutrum neque. Aenean auctor gravida sem. Praesent id massa id nisl venenatis lacinia. Aenean sit amet justo. Morbi ut odio. Cras mi pede, malesuada in, imperdiet et, commodo vulputate, justo. In blandit ultrices enim.',4,10,'2020-02-09 07:24:10'),
    (20,5,'Ut tellus. Nulla ut erat id mauris vulputate elementum. Nullam varius. Nulla facilisi. Cras non velit nec nisi vulputate nonummy. Maecenas tincidunt lacus at velit. Vivamus vel nulla eget eros elementum pellentesque.',7,1,'2020-05-16 16:43:13'),
    (19,2,'Pellentesque viverra pede ac diam. Cras pellentesque volutpat dui. Maecenas tristique, est et tempus semper, est quam pharetra magna, ac consequat metus sapien ut nunc. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Mauris viverra diam vitae quam. Suspendisse potenti. Nullam porttitor lacus at turpis.',8,7,'2019-04-26 23:09:04'),
    (28,12,'Duis bibendum. Morbi non quam nec dui luctus rutrum.',10,8,'2020-09-03 11:20:07'),
    (40,8,'Vestibulum quam sapien, varius ut, blandit non, interdum in, ante. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Duis faucibus accumsan odio. Curabitur convallis. Duis consequat dui nec nisi volutpat eleifend. Donec ut dolor. Morbi vel lectus in quam fringilla rhoncus. Mauris enim leo, rhoncus sed, vestibulum sit amet, cursus id, turpis. Integer aliquet, massa id lobortis convallis, tortor risus dapibus augue, vel accumsan tellus nisi eu orci.',7,9,'2019-09-16 03:50:30'),
    (36,4,'Suspendisse ornare consequat lectus. In est risus, auctor sed, tristique in, tempus sit amet, sem. Fusce consequat. Nulla nisl. Nunc nisl. Duis bibendum, felis sed interdum venenatis, turpis enim blandit mi, in porttitor pede justo eu massa. Donec dapibus.',1,2,'2019-10-11 00:16:45'),
    (45,2,'Vivamus in felis eu sapien cursus vestibulum. Proin eu mi. Nulla ac enim. In tempor, turpis nec euismod scelerisque, quam turpis adipiscing lorem, vitae mattis nibh ligula nec sem. Duis aliquam convallis nunc. Proin at turpis a pede posuere nonummy. Integer non velit. Donec diam neque, vestibulum eget, vulputate ut, ultrices vel, augue.',5,5,'2020-07-13 09:37:23'),
    (23,12,'Vestibulum quam sapien, varius ut, blandit non, interdum in, ante. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Duis faucibus accumsan odio. Curabitur convallis. Duis consequat dui nec nisi volutpat eleifend. Donec ut dolor.',1,7,'2020-04-05 03:28:34'),
    (16,10,'Suspendisse potenti. Nullam porttitor lacus at turpis. Donec posuere metus vitae ipsum. Aliquam non mauris. Morbi non lectus. Aliquam sit amet diam in magna bibendum imperdiet. Nullam orci pede, venenatis non, sodales sed, tincidunt eu, felis. Fusce posuere felis sed lacus. Morbi sem mauris, laoreet ut, rhoncus aliquet, pulvinar sed, nisl. Nunc rhoncus dui vel sem.',1,4,'2019-08-18 23:25:07'),
    (29,9,'Integer a nibh. In quis justo. Maecenas rhoncus aliquam lacus. Morbi quis tortor id nulla ultrices aliquet. Maecenas leo odio, condimentum id, luctus nec, molestie sed, justo. Pellentesque viverra pede ac diam. Cras pellentesque volutpat dui. Maecenas tristique, est et tempus semper, est quam pharetra magna, ac consequat metus sapien ut nunc. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Mauris viverra diam vitae quam. Suspendisse potenti.',2,9,'2020-06-16 17:40:59'),
    (22,5,'Ut tellus. Nulla ut erat id mauris vulputate elementum. Nullam varius. Nulla facilisi. Cras non velit nec nisi vulputate nonummy. Maecenas tincidunt lacus at velit. Vivamus vel nulla eget eros elementum pellentesque. Quisque porta volutpat erat. Quisque erat eros, viverra eget, congue eget, semper rutrum, nulla. Nunc purus.',6,5,'2020-01-06 11:18:40'),
    (45,5,'Cras non velit nec nisi vulputate nonummy. Maecenas tincidunt lacus at velit. Vivamus vel nulla eget eros elementum pellentesque. Quisque porta volutpat erat.',2,6,'2019-02-03 01:34:41'),
    (36,2,'Vivamus vestibulum sagittis sapien. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Etiam vel augue. Vestibulum rutrum rutrum neque. Aenean auctor gravida sem. Praesent id massa id nisl venenatis lacinia. Aenean sit amet justo. Morbi ut odio. Cras mi pede, malesuada in, imperdiet et, commodo vulputate, justo. In blandit ultrices enim.',6,9,'2019-09-26 15:26:51'),
    (42,11,'Sed ante. Vivamus tortor. Duis mattis egestas metus. Aenean fermentum. Donec ut mauris eget massa tempor convallis. Nulla neque libero, convallis eget, eleifend luctus, ultricies eu, nibh. Quisque id justo sit amet sapien dignissim vestibulum. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Nulla dapibus dolor vel est. Donec odio justo, sollicitudin ut, suscipit a, feugiat et, eros.',6,8,'2020-04-17 13:54:03'),
    (37,1,'Phasellus in felis.',6,6,'2020-03-08 06:52:07')
;