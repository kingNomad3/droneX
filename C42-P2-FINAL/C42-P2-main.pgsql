\echo ------------------------------------------------------------------------------
\echo ------------------------------------------------------------------------------
\echo ------------------------------------------------------------------------------
\echo ------------------------------------------------------------------------------
\echo ------------------------------------------------------------------------------
\echo -- START C42 SCRIPTS
\echo ------------------------------------------------------------------------------
\echo ------------------------------------------------------------------------------
\echo ------------------------------------------------------------------------------
\echo ------------------------------------------------------------------------------
\echo ------------------------------------------------------------------------------
\! cls
\! chcp
SHOW client_encoding;
\echo
\echo
\echo
\echo
\echo
\echo PHASE 0 - Insertion des scripts utilitaires
\echo ------------------------------------------------------------------------------
\i 'C42-P2_00 MATH_UTILITIES.pgsql'
\i 'C42-P2_00 RANDOM_UTILITIES.pgsql'
\echo
\echo
\! cls
\echo PHASE 1 - Crée l''infrastructure nominale
\echo ------------------------------------------------------------------------------
\i 'C42-P2_01_CREATE_INFRA.pgsql'
\echo
\echo
\! cls
\echo PHASE 2 - Popule les tables de référence mutable
\echo ------------------------------------------------------------------------------
\i 'C42-P2_02_POPULATE_REFERENCE.pgsql'
\echo
\echo
\! cls
\echo PHASE 3 - Popule les tables de référence immutable
\echo ------------------------------------------------------------------------------
\i 'C42-P2_03_POPULATE_REF_IMMUTABLE.pgsql'
\echo
\echo
\! cls
\echo PHASE 4 - Popule les tables en relation avec les modèles de drones
\echo ------------------------------------------------------------------------------
\i 'C42-P2_04_POPULATE_DRONE_MODELS.pgsql'
\echo
\echo
\! cls
\echo PHASE 5 - Simulation de l''embauche d''employé ainsi que la génération des tags de localisation.
\echo ------------------------------------------------------------------------------
\i 'C42-P2_05_HIRING.pgsql'
\echo
\echo
\! cls
\echo PHASE 6 - Simulation de l''aquisition de drones ainsi que la génération des tags de numéro de série.
\echo ------------------------------------------------------------------------------
\i 'C42-P2_06_DRONE_ACQUISITION.pgsql'
\echo
\echo
\! cls
\echo PHASE 7 - Simule les activités de l''entreprise, gestion des états
\echo ------------------------------------------------------------------------------
\i 'C42-P2_07_POPULATE_DRONE_MODELS.pgsql'
\echo
\echo
\! cls
\echo PHASE 8 - Requêtes DQL
\echo ------------------------------------------------------------------------------
\i 'C42-P2_08_DQL.pgsql'
\echo
\echo