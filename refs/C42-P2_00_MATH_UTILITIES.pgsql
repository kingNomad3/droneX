-- ----------------------------------------------------------------------------
-- Fonctions clamp
-- ----------------------------------------------------------------------------
-- Plusieurs surcharges :
-- - nombre entier
-- - nombre réel
-- - temps ('time')
-- - date
-- - horodatage ('timestamp') avec et sans fuseau horaire
-- ----------------------------------------------------------------------------
-- 
-- 
-- 
-- Fonction utilitaire retournant un nombre entier borné dans un 
-- intervalle [min, max] (surcharge pour les nombre entiers).
--    value : la valeur à évaluer
--    min : la borne inférieure acceptable, la borne est incluse
--    max : la borne supérieure acceptable, la borne est incluse
--    retour : la valeure limitée entre min et max
CREATE OR REPLACE FUNCTION clamp(value INT, min INT, max INT)
    RETURNS INT
LANGUAGE SQL
AS $$
    SELECT greatest(min, least(value, max));
$$;
--
--
--
-- Fonction utilitaire retournant un nombre réel borné dans un 
-- intervalle [min, max] (surcharge pour les nombre réels).
--    value : la valeur à évaluer
--    min : la borne inférieure acceptable, la borne est incluse
--    max : la borne supérieure acceptable, la borne est incluse
--    retour : la valeure limitée entre min et max
CREATE OR REPLACE FUNCTION clamp(value FLOAT, min FLOAT, max FLOAT) 
    RETURNS FLOAT
LANGUAGE SQL
AS $$
    SELECT greatest(min, least(value, max));
$$;
-- 
-- 
-- 
-- Fonction utilitaire retournant un temps (time) borné dans un 
-- intervalle [min, max] (surcharge pour le temps).
--    value : le temps à évaluer
--    min : la borne inférieure acceptable, la borne est incluse
--    max : la borne supérieure acceptable, la borne est incluse
--    retour : le temps limité entre min et max
CREATE OR REPLACE FUNCTION clamp(value TIME, min TIME, max TIME) 
    RETURNS TIME
LANGUAGE SQL
AS $$
    SELECT greatest(min, least(value, max));
$$;
-- 
-- 
-- 
-- Fonction utilitaire retournant une date bornée dans un 
-- intervalle [min, max] (surcharge pour les dates).
--    value : la date à évaluer
--    min : la borne inférieure acceptable, la borne est incluse
--    max : la borne supérieure acceptable, la borne est incluse
--    retour : la date limitée entre min et max
CREATE OR REPLACE FUNCTION clamp(value DATE, min DATE, max DATE) 
    RETURNS DATE
LANGUAGE SQL
AS $$
    SELECT greatest(min, least(value, max));
$$;
-- 
-- 
-- 
-- Fonction utilitaire retournant un 'timestamp' bornée dans un 
-- intervalle [min, max] (surcharge pour l'horodatage sans fuseau 
-- horaire).
--    value : l'horodatag à évaluer
--    min : la borne inférieure acceptable, la borne est incluse
--    max : la borne supérieure acceptable, la borne est incluse
--    retour : l'horodatage limité entre min et max
CREATE OR REPLACE FUNCTION clamp(value TIMESTAMP, min TIMESTAMP, max TIMESTAMP) 
    RETURNS TIMESTAMP
LANGUAGE SQL
AS $$
    SELECT greatest(min, least(value, max));
$$;
-- 
-- 
-- 
-- Fonction utilitaire retournant un 'timestamp' bornée dans un 
-- intervalle [min, max] (surcharge pour l'horodatage avec fuseau 
-- horaire).
--    value : l'horodatag à évaluer
--    min : la borne inférieure acceptable, la borne est incluse
--    max : la borne supérieure acceptable, la borne est incluse
--    retour : l'horodatage limité entre min et max
CREATE OR REPLACE FUNCTION clamp(value TIMESTAMPTZ, min TIMESTAMPTZ, max TIMESTAMPTZ) 
    RETURNS TIMESTAMPTZ
LANGUAGE SQL
AS $$
    SELECT greatest(min, least(value, max));
$$;

