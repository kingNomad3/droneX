-- ----------------------------------------------------------------------------
-- Fonctions random_...
-- ----------------------------------------------------------------------------
-- random_event
-- random_integer
-- random_real
-- random_char
-- random_string
-- random_time
-- random_date
-- random_timestamp (2 surcharges)
-- ----------------------------------------------------------------------------
-- 
-- 
-- 
-- Fonction utilitaire générant un booléen aléatoire selon la probabilité 
-- donnée.
--    probability : - le pourcentage exprimant la possibilité d'avoir vrai
--                  - doit être exprimé dans l'interval [0.0, 1.0]
--                  - par exemple, 0.75 veut dire qu'il y a 75% de chance 
--                    d'obtenir TRUE
--                  - probability est borné dans l'interval
--    retour : le booléen aléatoirement généré
--
-- Exemple :
-- SELECT random_event(); 
-- SELECT random_event(0.75); 
CREATE OR REPLACE FUNCTION random_event(probability FLOAT DEFAULT 0.5) 
    RETURNS BOOLEAN
LANGUAGE SQL
AS $$
    SELECT random() <= clamp(probability, 0.0, 1.0);
$$;
-- 
-- 
-- 
-- Fonction utilitaire générant un nombre entier aléatoire dans 
-- l'intervalle [min, max].
--    min : la borne inférieure, la borne est incluse
--    max : la borne supérieure, la borne est incluse
--    retour : le nombre entier aléatoire généré
--
-- Exemple :
-- SELECT random_integer(-10, 10); 
-- SELECT AVG(random_integer(-10, 10)) FROM generate_series(0, 1000); 
CREATE OR REPLACE FUNCTION random_integer(min INT, max INT) 
    RETURNS INT
LANGUAGE SQL
AS $$
    SELECT floor(random() * (max - min + 1) + min)::INT;
$$;
--
--
--
-- Fonction utilitaire générant un nombre réel aléatoire dans 
-- l'intervalle [min, max].
--    min : la borne inférieure, la borne est incluse
--    max : la borne supérieure, la borne est incluse
--    retour : le nombre réel aléatoire généré
--
-- Exemple :
-- SELECT random_real(0.0, 100.0);
-- SELECT ROUND(DEGREES(random_real(-2 * PI(), 2 * PI()))::NUMERIC, 2)::TEXT || '°'; 
CREATE OR REPLACE FUNCTION random_real(min FLOAT, max FLOAT) 
    RETURNS FLOAT
LANGUAGE SQL
AS $$
    -- 2.220446049250313e-16 => epsilon float8
    SELECT (random() * (max - min + 2.220446049250313e-16) + min)::FLOAT;
$$;
--
--
--
-- Fonction utilitaire générant un caractère aléatoire à partir 
-- d'une liste de caractères donnés.
--    input_chars : sous forme de chaîne de caractères,
--                  la liste des caractères où piger les 
--                  caractères aléatoires
--    retour : un caractère parmis ceux donnés
-- 
-- Exemple :
-- SELECT random_char();
-- SELECT random_char('wasd');
-- SELECT random_char(U&'\+01F600\+01F601\+01F602\+01F603\+01F604\+01F605\+01F606\+01F607\+01F608\+01F609\+01F60A\+01F60B\+01F60C\+01F60D\+01F60E\+01F60F\+01F610\+01F611\+01F612\+01F613\+01F614\+01F615\+01F616\+01F617\+01F618\+01F619\+01F61A\+01F61B\+01F61C\+01F61D\+01F61E\+01F61F\+01F620\+01F621\+01F622\+01F623\+01F624\+01F625\+01F626\+01F627\+01F628\+01F629\+01F62A\+01F62B\+01F62C\+01F62D\+01F62E\+01F62F');
CREATE OR REPLACE FUNCTION random_char(input_chars text DEFAULT 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789') 
    RETURNS TEXT 
LANGUAGE SQL
AS $$
    SELECT substring(input_chars FROM random_integer(1, length(input_chars)) FOR 1);
$$;
--
--
--
-- Fonction utilitaire générant un chaîne de caractères aléatoire 
-- d'une taille spécifique à partir d'une liste de caractères donnés.
--    n : la taille de la chaîne de caractères à retourner (n > 0)
--    input_chars : sous forme de chaîne de caractères,
--                  la liste des caractères où piger les 
--                  caractères aléatoires
--    retour : la chaîne de caractères générée
--    exception : si n <= 0 ou si input_chars est vide 
--
-- Exemple :
-- SELECT random_string(10);
-- SELECT random_char('0123456789') || random_string(7, '0123456789.,_-/\|') || random_char('0123456789');
-- SELECT random_string(5, U&'\+01F600\+01F601\+01F602\+01F603\+01F604\+01F605\+01F606\+01F607\+01F608\+01F609\+01F60A\+01F60B\+01F60C\+01F60D\+01F60E\+01F60F\+01F610\+01F611\+01F612\+01F613\+01F614\+01F615\+01F616\+01F617\+01F618\+01F619\+01F61A\+01F61B\+01F61C\+01F61D\+01F61E\+01F61F\+01F620\+01F621\+01F622\+01F623\+01F624\+01F625\+01F626\+01F627\+01F628\+01F629\+01F62A\+01F62B\+01F62C\+01F62D\+01F62E\+01F62F');
CREATE OR REPLACE FUNCTION random_string(
        n INTEGER, 
        input_chars text DEFAULT 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789') 
    RETURNS TEXT 
LANGUAGE PLPGSQL
AS $$
DECLARE
    output_chars text := '';
BEGIN
    IF n <= 0 THEN
        RAISE EXCEPTION 'random_string error : n must be strictly positive (n = %).', n;
    END IF;
    IF length(input_chars) < 1 THEN
        RAISE EXCEPTION 'random_string error : input_chars cannot be an empty string.';
    END IF;
    FOR i IN 1..n LOOP
        output_chars := output_chars || random_char(input_chars);
    END LOOP;
    RETURN output_chars;
END;
$$;
-- NOTE INTÉRESSANTE pour random_string ^
-- 
-- La fonction random_string est un exemple académique de l'utilisation d'une 
-- fonction PL/pgSQL. Ce genre de requête se fait facilement avec une requête 
-- SQL standard. Malgré tout, la fonction PL/pgSQL a l'avantage de faire une 
-- gestion personnalisée des intrants avec des messages d'erreurs adaptés et 
-- pertinents.
--
-- Voici comment :
-- 
-- CREATE OR REPLACE FUNCTION rand_str(
--          n INTEGER, 
--          input_chars text DEFAULT 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789') 
--      RETURNS TEXT 
-- LANGUAGE SQL -- <<< ici SQL et non pas P
-- AS $$
--      SELECT STRING_AGG(random_char(input_chars), '') 
-- 	      FROM GENERATE_SERIES(1, n) AS val;
-- $$;
-- 
-- SELECT rand_str(6, 'XYZ');
-- 
-- 
-- 
-- 
-- 
-- Fonction utilitaire générant une valeur aléatoire parmi plusieurs 
-- données. Il faut que l'offre de valeur possible soit formaté en 
-- texte, une valeur après l'autre avec un séparateur au choix.
-- 
--    string_values : - la chaîne de caractères où se trouvent la source 
--                      des choix possibles
--                    - une liste de mots sépararés par le caractère separator
--    separator : une chaîne de caractères, généralement un seul caractère, 
--                séparant chacune des valeurs possibles.
--    retour : la valeur sélectionnée
--
-- Exemple :
-- SELECT random_value('lundi;mardi;mercredi;jeudi;vendredi');
-- SELECT random_value('rouge-vert-bleu', '-');
-- SELECT random_value('', '-'); -- retourne null
-- SELECT random_value('US;CA;MX', ''); -- retourne US;CA;MX
-- SELECT random_value('US;CA;MX', ','); -- retourne US;CA;MX
CREATE OR REPLACE FUNCTION random_value(string_values VARCHAR, separator VARCHAR DEFAULT ';') 
    RETURNS VARCHAR
LANGUAGE SQL
AS $$
    SELECT value 
      FROM (SELECT unnest(string_to_array(string_values, separator)) AS value) AS data 
      --   alias nécessaire pour le SELECT de la ligne précédente ----^         ^
      --                                                                        |
      --           alias nécessaire pour nommer la table qui est utilisé -+     |
      --           temporairement dans la requête externe (non corrélée) -+-----+
     ORDER BY random()
     LIMIT 1;
$$;
-- 
-- 
-- 
-- 
-- 
-- Fonction utilitaire générant une date aléatoire dans 
-- l'intervalle [starting_date, ending_date].
--    starting_date : la date de la borne inférieure, la borne est incluse
--    ending_date : la date de la borne supérieure, la borne est incluse
--    retour : la date aléatoire générée
--    exception : si ending_date est plus grand que starting_date
--
-- Exemple :
-- SELECT random_time();
-- SELECT random_time(to_timestamp('08:00:00', 'HH24:MI:SS')::TIME, to_timestamp('18:00:00', 'HH24:MI:SS')::TIME);
CREATE OR REPLACE FUNCTION random_time(starting_time TIME DEFAULT to_timestamp('00:00:00', 'HH24:MI:SS')::TIME, ending_time TIME DEFAULT CURRENT_TIME) 
    RETURNS TIME
LANGUAGE PLPGSQL
AS $$
DECLARE
    span_time FLOAT;
    random_time INTERVAL;
BEGIN
    IF starting_time >= ending_time THEN
        RAISE EXCEPTION 'random_time error : the starting_time must be earlier than the ending_time.';
    END IF;
    span_time := EXTRACT(EPOCH FROM (ending_time - starting_time))::FLOAT;
    random_time := random_real(0.0, span_time) * INTERVAL '1 SECOND';
    RETURN (starting_time + random_time)::TIME;
END;
$$;
-- 
-- 
-- 
-- 
-- 
-- Fonction utilitaire générant une date aléatoire dans 
-- l'intervalle [starting_date, ending_date].
--    starting_date : la date de la borne inférieure, la borne est incluse
--    ending_date : la date de la borne supérieure, la borne est incluse
--    retour : la date aléatoire générée
--    exception : si ending_date est plus grand que starting_date
--
-- Exemple :
-- SELECT random_date(CURRENT_DATE - 14);
-- SELECT random_date(to_date('2000-01-01', 'YYYY-MM-DD'), to_date('25/12/10', 'DD/MM/YY'));
CREATE OR REPLACE FUNCTION random_date(starting_date DATE, ending_date DATE DEFAULT CURRENT_DATE) 
    RETURNS DATE 
LANGUAGE PLPGSQL
AS $$
DECLARE
    span_days integer;
    random_day integer;
BEGIN
    IF starting_date >= ending_date THEN
        RAISE EXCEPTION 'random_date error : the starting_date must be earlier than the ending_date.';
    END IF;
    span_days := ending_date - starting_date;
    random_day := random_integer(0, span_days);
    RETURN starting_date + random_day;
END;
$$;
--
--
--
-- Fonction utilitaire générant un 'timestamp' sans fuseau horaire aléatoire dans 
-- l'intervalle [starting_timestamp, ending_timestamp].
-- 'timestamp' en français : horodatage
--    starting_timestamp : la date de la borne inférieure, la borne est incluse
--    ending_timestamp : la date de la borne supérieure, la borne est incluse
--    retour : le 'timestamp' aléatoire générée
--    exception : si ending_timestamp est plus grand que starting_timestamp
--
-- Exemple :
-- -- ATTENTION : TO_TIMESTAMP retourne un timestamp AVEC TIME ZONE
--                il faut faire la conversion explicite pour ne pas avoir de TIME ZONE
-- SELECT random_timestamp(to_timestamp('2000-01-01', 'YYYY-MM-DD')::TIMESTAMP);
-- SELECT random_timestamp(to_timestamp('2000-01-01 12:00:00.000000', 'YYYY-MM-DD HH24::MI::SS.us')::TIMESTAMP, to_timestamp('2000-01-01 17:59:59.999999', 'YYYY-MM-DD HH24::MI::SS.us')::TIMESTAMP);
CREATE OR REPLACE FUNCTION random_timestamp(starting_timestamp TIMESTAMP, ending_timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP) 
    RETURNS TIMESTAMP 
LANGUAGE PLPGSQL
AS $$
DECLARE
    span_ts FLOAT;
    random_ts INTERVAL;
BEGIN
    IF starting_timestamp >= ending_timestamp THEN
        RAISE EXCEPTION 'random_timestamp error : the starting_timestamp must be earlier than the ending_timestamp.';
    END IF;
    span_ts := EXTRACT(EPOCH FROM (ending_timestamp - starting_timestamp))::FLOAT; -- la soustraction retourne un interval
    random_ts := random_real(0.0::FLOAT, span_ts) * INTERVAL '1 SECOND'; -- on reconstruit un interval valide
    RETURN (starting_timestamp + random_ts)::TIMESTAMP;
END;
$$;
-- 
-- 
-- 
-- Fonction utilitaire générant un 'timestamptz' avec fuseau horaire aléatoire 
-- dans l'intervalle [starting_timestamp, ending_timestamp].
-- 
-- 'timestamp' en français : horodatage
-- 
-- NOTE IMPORTANTE : cette fonction peut retourner un fuseau différent dans 
-- le sens qu'elle perd les variantes de type heure d'été/heure d'hiver
-- 
--    starting_timestamp : la date de la borne inférieure, la borne est incluse
--    ending_timestamp : la date de la borne supérieure, la borne est incluse
--    retour : le 'timestamp' aléatoire générée
--    exception : si ending_timestamp est plus grand que starting_timestamp
--                si les deux fuseaux horaires sont différents
-- Exemple :
-- -- ATTENTION : TO_TIMESTAMP retourne un timestamp AVEC TIME ZONE
-- SELECT random_timestamp(to_timestamp('2000-01-01 12:00:00.000000', 'YYYY-MM-DD HH24::MI::SS.us'), to_timestamp('2000-01-01 17:59:59.999999', 'YYYY-MM-DD HH24::MI::SS.us'));
CREATE OR REPLACE FUNCTION random_timestamp(starting_timestamp TIMESTAMPTZ, ending_timestamp TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP) 
    RETURNS TIMESTAMPTZ
LANGUAGE PLPGSQL
AS $$
DECLARE
    span_ts FLOAT;
    random_ts INTERVAL;
BEGIN
    IF starting_timestamp >= ending_timestamp THEN
        RAISE EXCEPTION 'random_timestamp error : the starting_timestamp must be earlier than the ending_timestamp.';
    END IF;
    IF  EXTRACT(TIMEZONE_HOUR FROM starting_timestamp) <>  EXTRACT(TIMEZONE_HOUR FROM ending_timestamp) OR 
        EXTRACT(TIMEZONE_MINUTE FROM starting_timestamp) <>  EXTRACT(TIMEZONE_MINUTE FROM ending_timestamp) THEN
        RAISE EXCEPTION 'random_timestamp error : the starting_timestamp and ending_timestamp must have the same time zone. % and % was given', 
            EXTRACT(TIMEZONE_HOUR FROM starting_timestamp)::TEXT || ':' || LPAD(EXTRACT(TIMEZONE_MINUTE FROM starting_timestamp)::TEXT, 2, '0'), 
            EXTRACT(TIMEZONE_HOUR FROM ending_timestamp)::TEXT || ':' || LPAD(EXTRACT(TIMEZONE_MINUTE FROM ending_timestamp)::TEXT, 2, '0');
    END IF;
    span_ts := EXTRACT(EPOCH FROM (ending_timestamp - starting_timestamp))::FLOAT; -- la soustraction retourne un interval
    random_ts := random_real(0.0::FLOAT, span_ts) * INTERVAL '1 SECOND'; -- on reconstruit un interval valide
    RETURN (starting_timestamp + random_ts)::TIMESTAMPTZ;
END;
$$;
--
--
--
--
--
--
-- ----------------------------------------------------------------------------
-- Fonctions d'affichages quelconques. Exemples académiques.
-- ----------------------------------------------------------------------------
--
--
--
-- Les fonctions et procédures suivantes ne sont pas utiles en soit.
-- Elles ne servent que d'exemples académiques.
--
--
--
-- Fonction utilitaire générant n nombres entiers aléatoires 
-- et les retourne sous forme de NOTICE.
--    n : le nombre de valeur à générer
--        cette valeur est limité dans l'intervalle [1, 100]
--
-- Exemple :
-- CALL display_random_integers(5);
CREATE OR REPLACE PROCEDURE display_random_integers(n INT) 
LANGUAGE plpgsql 
AS $$
DECLARE 
    random_val INT;
BEGIN 
    n := clamp(n, 1, 100);
    FOR i IN 1..n LOOP
        random_val := random_integer(0, 100);
        RAISE NOTICE 'Nombre entier aléatoire (% de %) : %', i, n, random_val;
    END LOOP;
END; 
$$;
--
--
--
-- Fonction utilitaire générant n nombres réels aléatoires 
-- et les retourne sous forme de NOTICE.
--    n : le nombre de valeur à générer
--        cette valeur est limité dans l'intervalle [-pi, pi]
--
-- Exemple :
-- CALL display_random_reals(5);
CREATE OR REPLACE PROCEDURE display_random_reals(n INT) 
LANGUAGE plpgsql 
AS $$
DECLARE 
    random_val FLOAT;
BEGIN 
    n := clamp(n, 1, 100);
    FOR i IN 1..n LOOP
        random_val := random_real(-pi(), pi());
        RAISE NOTICE 'Nombre réel aléatoire (% de %) : %', i, n, random_val;
    END LOOP;
END; 
$$;









