/*
	Membres : 
	
	Julien Coulombe-Morency, 
	Remi Chuet, 
	Édouard Blain-Noël, 
	Catherine Lavoie, 
	Benjamin Jouinvil, 
	François Maltais
		
	Date de création : 2023-10-19 
	Dernière modification : 2023-10-19
	C42-P2_02_POPULATE_REFERENCE.pgsql
	V1.0	
*/


PREPARE ins_unit(VARCHAR(16),VARCHAR(64), VARCHAR(1024)) AS 
    INSERT INTO unit(symbol, name , description)VALUES ($1,$2,$3);

BEGIN;
	EXECUTE ins_unit($$kg$$, $$Kilogramme$$, $$Unité de base de la masse dans le Système international$$);
	EXECUTE ins_unit($$m$$, $$Mètre$$, $$Unité de base de la longueur dans le Système international$$);
	EXECUTE ins_unit($$s$$, $$Seconde$$, $$Unité de base du temps dans le Système international$$);
	EXECUTE ins_unit($$A$$, $$Ampère$$, $$Unité de base du courant électrique dans le Système international$$);
	EXECUTE ins_unit($$K$$, $$Kelvin$$, $$Unité de base de la température thermodynamique dans le Système international$$);
	EXECUTE ins_unit($$mol$$, $$Mole$$, $$Unité de base de la quantité de matière dans le Système international$$);
	EXECUTE ins_unit($$cd$$, $$Candela$$, $$Unité de base de l'intensité lumineuse dans le Système international$$);
	EXECUTE ins_unit($$Hz$$, $$Hertz$$, $$Unité de fréquence, équivalent à une oscillation par seconde$$);
	EXECUTE ins_unit($$N$$, $$Newton$$, $$Unité de force dans le Système international, équivalente à un mètre-kilogramme par seconde au carré$$);
	EXECUTE ins_unit($$J$$, $$Joule$$, $$Unité d'énergie dans le Système international, équivalente à un Newton-mètre$$);
	EXECUTE ins_unit($$°C$$, $$Degré Celsius$$, $$Unité de température, couramment utilisée pour mesurer la température ambiante$$);
	EXECUTE ins_unit($$L$$, $$Litre$$, $$Unité de volume, couramment utilisée pour mesurer le volume de liquides$$);
	EXECUTE ins_unit($$min$$, $$Minute$$, $$Unité de temps, équivalente à 60 secondes$$);
	EXECUTE ins_unit($$h$$, $$Heure$$, $$Unité de temps, équivalente à 60 minutes$$);
	EXECUTE ins_unit($$jours$$, $$Jour$$, $$Unité de temps, équivalente à 24 heures$$);
	EXECUTE ins_unit($$sem$$, $$Semaine$$, $$Unité de temps, équivalente à 7 jours$$);
	EXECUTE ins_unit($$mois$$, $$Mois$$, $$Unité de temps, généralement comprise entre 28 et 31 jours$$);
	EXECUTE ins_unit($$année$$, $$Année$$, $$Unité de temps, équivalente à 365 ou 366 jours$$);
	EXECUTE ins_unit($$km$$, $$Kilomètre$$, $$Unité de distance, équivalente à 1000 mètres$$);
	EXECUTE ins_unit($$cm$$, $$Centimètre$$, $$Unité de distance, équivalente à 0.01 mètre$$);
	EXECUTE ins_unit($$mm$$, $$Millimètre$$, $$Unité de distance, équivalente à 0.001 mètre$$);
	EXECUTE ins_unit($$mi$$, $$Mile$$, $$Unité de distance, couramment utilisée dans les pays anglo-saxons, équivalente à environ 1,609 kilomètres$$);
	EXECUTE ins_unit($$gal$$, $$Gallon$$, $$Unité de volume, couramment utilisée aux États-Unis pour mesurer les liquides$$);
	EXECUTE ins_unit($$lb$$, $$Livre$$, $$Unité de poids, couramment utilisée aux États-Unis, équivalente à environ 0,453 kilogrammes$$);
	EXECUTE ins_unit($$oz$$, $$Once$$, $$Unité de poids, équivalente à 1/16 d'une livre$$);
	EXECUTE ins_unit($$in$$, $$Pouce$$, $$Unité de longueur, équivalente à 1/12 d'un pied$$);
	EXECUTE ins_unit($$ft$$, $$Pied$$, $$Unité de longueur, couramment utilisée aux États-Unis, équivalente à 12 pouces$$);
	EXECUTE ins_unit($$Pa$$, $$Pascal$$, $$Unité de pression dans le Système international, équivalente à un Newton par mètre carré$$);
	EXECUTE ins_unit($$V$$, $$Volt$$, $$Unité de tension ou différence de potentiel électrique$$);
	EXECUTE ins_unit($$W$$, $$Watt$$, $$Unité de puissance, équivalente à un Joule par seconde$$);
	EXECUTE ins_unit($$F$$, $$Farad$$, $$Unité de capacité électrique$$);
	EXECUTE ins_unit($$Ω$$, $$Ohm$$, $$Unité de résistance électrique$$);
	EXECUTE ins_unit($$S$$, $$Siemens$$, $$Unité de conductance électrique$$);
	EXECUTE ins_unit($$Bq$$, $$Becquerel$$, $$Unité d'activité radioactive, équivalente à une désintégration par seconde$$);
	EXECUTE ins_unit($$Gy$$, $$Gray$$, $$Unité d'absorption de rayonnement ionisant$$);
	EXECUTE ins_unit($$lm$$, $$Lumen$$, $$Unité de flux lumineux$$);
	EXECUTE ins_unit($$lx$$, $$Lux$$, $$Unité d'éclairement lumineux, équivalente à un lumen par mètre carré$$);
	EXECUTE ins_unit($$dB$$, $$Decibel$$, $$Unité logarithmique pour exprimer le rapport entre deux valeurs, couramment utilisée pour mesurer l'intensité sonore$$);
	EXECUTE ins_unit($$rad$$, $$Radian$$, $$Unité d'angle plan dans le Système international$$);
	EXECUTE ins_unit($$sr$$, $$Steradian$$, $$Unité d'angle solide dans le Système international$$);
	EXECUTE ins_unit($$H$$, $$Henry$$, $$Unité d'inductance électrique$$);
	EXECUTE ins_unit($$rpm$$, $$Révolutions par minute$$, $$Unité utilisée pour mesurer la vitesse de rotation d'un moteur ou d'une hélice$$);
	EXECUTE ins_unit($$deg$$, $$'Degrés par seconde$$, $$Vitesse angulaire, souvent utilisée pour décrire la vitesse de rotation d'un robot ou d'un drone autour d'un axe$$);
	EXECUTE ins_unit($$g$$, $$Gravité terrestre$$, $$Accélération due à la force de gravité, couramment utilisée pour les capteurs inertiels (IMU)$$);
	EXECUTE ins_unit($$mAh$$, $$Milliampère-heure$$, $$Unité de charge électrique, utilisée pour spécifier la capacité des batteries des drones$$);
	EXECUTE ins_unit($$dBm$$, $$dBm$$, $$Unité de puissance utilisée pour mesurer la puissance relative en décibels par rapport à 1 milliwatt, couramment utilisée en communications sans fil$$);
	EXECUTE ins_unit($$PWM$$, $$Pulse Width Modulation$$, $$Technique utilisée pour contrôler la puissance fournie aux moteurs et autres composants électroniques$$);
	EXECUTE ins_unit($$FOV$$, $$Field Of View$$, $$Champ de vision, mesure du champ observé par une caméra ou un capteur, souvent mesuré en degrés$$);
	EXECUTE ins_unit($$RTK$$, $$Real Time Kinematic$$, $$Technologie de précision pour les systèmes GPS utilisés dans les drones pour une localisation précise$$);
	EXECUTE ins_unit($$mm/s$$, $$'Millimètres par seconde$$, $$Vitesse linéaire, parfois utilisée dans les spécifications de robots de précision pour des mouvements lents et contrôlés$$);
	EXECUTE ins_unit($$Wh$$, $$Watt-heure$$, $$Unité d'énergie électrique, couramment utilisée pour mesurer la capacité des batteries$$);
	EXECUTE ins_unit($$kWh$$, $$Kilowatt-heure$$, $$Unité d'énergie utilisée pour de plus grandes batteries ou pour mesurer la consommation d'énergie sur une période prolongée$$);
	EXECUTE ins_unit($$C$$, $$Taux de charge$$, $$Taux de charge d'une batterie : '1C' signifie que la batterie se charge en une heure, '2C' signifie qu'elle se charge en une demi-heure, etc.$$);
	EXECUTE ins_unit($$VOC$$, $$Tension à vide$$, $$Tension d'une batterie lorsqu'aucun courant n'est délivré (à pleine charge)$$);
	EXECUTE ins_unit($$Vmin$$, $$Tension minimale$$, $$Tension minimale avant que la batterie ne doive être rechargée pour éviter d'être endommagée$$);
	EXECUTE ins_unit($$SOC$$, $$État de charge$$, $$Pourcentage de la capacité totale actuellement disponible dans une batterie$$);
	EXECUTE ins_unit($$SOH$$, $$État de santé$$, $$Évaluation de la condition générale d'une batterie par rapport à une nouvelle batterie$$);
	EXECUTE ins_unit($$Amph'$$, $$'Ampère-heure$$, $$Unité de charge électrique, similaire au milliampère-heure mais pour des courants plus importants$$);
	EXECUTE ins_unit($$Wk$$, $$'Watts par kilogramme$$, $$Mesure de la densité de puissance, souvent utilisée pour comparer la performance de différentes batteries$$);
	EXECUTE ins_unit($$CC$$, $$Courant de charge constant$$, $$Phase de charge pendant laquelle un courant constant est fourni à la batterie$$);
	EXECUTE ins_unit($$CV$$, $$Tension de charge constante$$, $$Phase de charge pendant laquelle une tension constante est maintenue sur la batterie$$);
	EXECUTE ins_unit($$kg/m³$$, $$Kilogramme par mètre cube$$, $$Unité de densité représentant la masse par unité de volume$$);
	EXECUTE ins_unit($$N/mm²$$, $$Newton par millimètre carré$$, $$Unité de contrainte ou de pression, communément appelée mégapascal (MPa)$$);
	EXECUTE ins_unit($$%$$, $$Pourcentage$$, $$Représente une proportion sur une échelle de 0 à 100$$);
	EXECUTE ins_unit($$S/m$$, $$Siemens par mètre$$, $$Unité de conductivité électrique représentant la capacité d''un matériau à conduire l''électricité$$);
	EXECUTE ins_unit($$cycle$$, $$Cycle$$, $$Représente une séquence complète d''événements répétée$$);
	EXECUTE ins_unit($$deg/s²$$, $$Degré par seconde carrée$$, $$Unité d''accélération angulaire indiquant la variation de la vitesse angulaire$$);
	EXECUTE ins_unit($$m²$$, $$Mètre carré$$, $$Unité de surface ou d''aire représentant un carré d''un mètre de côté$$);
	EXECUTE ins_unit($$m³$$, $$Mètre cube$$, $$Unité de volume représentant un cube d''un mètre de côté$$);
	EXECUTE ins_unit($$x$$, $$Zoom$$, $$Facteur de multiplication ou d''agrandissement, par exemple, x4 signifie 'quatre fois plus grand'$$);
COMMIT;

DEALLOCATE ins_unit;



PREPARE ins_technical_specification(VARCHAR(64),VARCHAR(512),VARCHAR(16)) AS 
INSERT INTO technical_specification(name, description, unit) VALUES ($1,$2,(SELECT id FROM unit WHERE symbol = $3));

BEGIN;
	EXECUTE ins_technical_specification($$Poids$$, $$Masse totale du produit$$, 'kg');
	EXECUTE ins_technical_specification($$Longueur$$, $$Dimension la plus longue du produit$$, 'm');
	EXECUTE ins_technical_specification($$Largeur$$, $$Dimension la plus large du produit$$, 'm');
	EXECUTE ins_technical_specification($$Hauteur$$, $$Dimension verticale du produit$$, 'm');
	EXECUTE ins_technical_specification($$Volume$$, $$Espace total occupé par le produit$$, 'm³');
	EXECUTE ins_technical_specification($$Densité$$, $$Masse par unité de volume$$, 'kg/m³');
	EXECUTE ins_technical_specification($$Résistance$$, $$Capacité du matériau à résister à une force extérieure$$, 'N/mm²');
	EXECUTE ins_technical_specification($$Température opération maximum$$, $$Température maximale de fonctionnement du produit$$, '°C');
	EXECUTE ins_technical_specification($$Température opération minimum$$, $$Température minimale de fonctionnement du produit$$, '°C');
	EXECUTE ins_technical_specification($$Durée de vie$$, $$Durée estimée du bon fonctionnement du produit$$, 'h');
	EXECUTE ins_technical_specification($$Voltage$$, $$Tension électrique pour le fonctionnement$$, 'V');
	EXECUTE ins_technical_specification($$Courant$$, $$Courant électrique nominal$$, 'A');
	EXECUTE ins_technical_specification($$Puissance$$, $$Énergie consommée ou produite par heure$$, 'W');
	EXECUTE ins_technical_specification($$Fréquence$$, $$Fréquence d'opération pour les produits électroniques$$, 'Hz');
	EXECUTE ins_technical_specification($$Épaisseur$$, $$Mesure de la dimension la plus fine du produit, souvent pour des plaques ou feuilles$$, 'mm');
	EXECUTE ins_technical_specification($$Diamètre$$, $$Distance à travers le cercle, utile pour les objets cylindriques$$, 'mm');
	EXECUTE ins_technical_specification($$Tolérance$$, $$Écart maximum admissible par rapport à une valeur nominale$$, 'mm');
	EXECUTE ins_technical_specification($$RPM$$, $$Vitesse de rotation pour des pièces mécaniques, comme les moteurs$$, 'rpm');
	EXECUTE ins_technical_specification($$Isolation$$, $$Niveau de résistance à la conduction d'électricité ou de chaleur$$, 'Ω');
	EXECUTE ins_technical_specification($$Humidité d'opération$$, $$Plage d'humidité dans laquelle le produit fonctionne de manière optimale$$, '%');
	EXECUTE ins_technical_specification($$Pression d'opération$$, $$Plage de pression pour les produits fonctionnant sous certaines atmosphères$$, 'Pa');
	EXECUTE ins_technical_specification($$Conductivité$$, $$Capacité du matériau à conduire l'électricité$$, 'S/m');
	EXECUTE ins_technical_specification($$Rendement$$, $$Proportion de l'énergie d'entrée convertie en travail utile$$, '%');
	EXECUTE ins_technical_specification($$Cycle$$, $$Cycle de travail pour des machines fonctionnant en cycles intermittents$$, '%');
	EXECUTE ins_technical_specification($$Étanchéité$$, $$Capacité à empêcher la pénétration de liquides ou de gaz$$, NULL);
	EXECUTE ins_technical_specification($$Cycles de vie$$, $$Nombre de cycles d'opération avant une défaillance prévue$$, 'cycle');
	EXECUTE ins_technical_specification($$Bruit$$, $$Niveau sonore produit pendant le fonctionnement$$, 'dB');
	EXECUTE ins_technical_specification($$Charge maximum$$, $$Poids maximum que le produit peut soutenir ou transporter$$, 'kg');
	EXECUTE ins_technical_specification($$Portée$$, $$Distance maximale depuis la base jusqu'à l'extrémité du robot$$, 'mm');
	EXECUTE ins_technical_specification($$Répétabilité$$, $$Précision avec laquelle le robot peut retourner à une position spécifiée$$, 'mm');
	EXECUTE ins_technical_specification($$Vitesse axiale$$, $$Vitesse maximale d'un axe spécifique$$, 'deg/s');
	EXECUTE ins_technical_specification($$Accélération axiale$$, $$Accélération maximale d'un axe spécifique$$, 'deg/s²');
	EXECUTE ins_technical_specification($$Nombre d'axes$$, $$Nombre de degrés de liberté du robot$$, 'axes');
	EXECUTE ins_technical_specification($$Environnement$$, $$Conditions pour lesquelles le robot est conçu (standard, salle blanche, dangereux...)$$, NULL);
	EXECUTE ins_technical_specification($$Système de contrôle$$, $$Type de système de contrôle utilisé pour opérer le robot$$, NULL);
	EXECUTE ins_technical_specification($$Interface usager$$, $$Moyens par lesquels l'opérateur interagit avec le robot$$, NULL);
	EXECUTE ins_technical_specification($$Alimentation électrique$$, $$Énergie nécessaire pour le fonctionnement du robot$$, 'V');
	EXECUTE ins_technical_specification($$Source air comprimé$$, $$Besoin en air comprimé pour certaines fonctions$$, 'bar');
	EXECUTE ins_technical_specification($$Consommation$$, $$Énergie consommée pendant le fonctionnement$$, 'kWh');
	EXECUTE ins_technical_specification($$Espace installation$$, $$Dimension au sol requise pour l'installation$$, 'm²');
	EXECUTE ins_technical_specification($$Protocole de communication$$, $$Protocoles utilisés pour la communication avec d'autres équipements$$, NULL);
	EXECUTE ins_technical_specification($$Autonomie d'opération$$, $$Durée d'opération sur une seule charge de batterie$$, 'min');
	EXECUTE ins_technical_specification($$Vitesse maximum$$, $$Vitesse maximale que le drone peut atteindre$$, 'm/s');
	EXECUTE ins_technical_specification($$Altitude maximum$$, $$Altitude maximale à laquelle le drone peut opérer$$, 'm');
	EXECUTE ins_technical_specification($$Profondeur maximum$$, $$Profondeur Altitude maximale à laquelle le drone peut opérer$$, 'm');
	EXECUTE ins_technical_specification($$Portée de communication$$, $$Distance maximale du contrôleur à laquelle le drone peut fonctionner$$, 'km');
	EXECUTE ins_technical_specification($$Stabilisation image$$, $$Type de stabilisation utilisé pour la caméra (électronique, mécanique...)$$, NULL);
	EXECUTE ins_technical_specification($$Résolution caméra$$, $$Résolution de l'appareil photo du drone$$, 'MP');
	EXECUTE ins_technical_specification($$Résolution vidéo$$, $$Qualité de la vidéo que le drone peut enregistrer$$, 'MP');
	EXECUTE ins_technical_specification($$Capacité stockage$$, $$Espace disponible pour stocker des photos et vidéos$$, 'GB');
	EXECUTE ins_technical_specification($$Mode vol$$, $$Modes de vol automatiques disponibles (suivi, point d'intérêt...)$$, NULL);
	EXECUTE ins_technical_specification($$Nombre de capteurs$$, $$Indique le nombre de capteurs embarqués$$, NULL);
	EXECUTE ins_technical_specification($$Capteurs$$, $$Types de capteurs embarqués (thermique, sonar, LIDAR...)$$, NULL);
	EXECUTE ins_technical_specification($$Résistance au vent$$, $$Capacité à opérer malgré la force des vents$$, 'm/s');
	EXECUTE ins_technical_specification($$Résistance à l'eau$$, $$Capacité à opérer sous l'eau ou dans des conditions humides$$, NULL);
	EXECUTE ins_technical_specification($$Mode communication$$, $$Méthode de communication (Wi-Fi, radiofréquence, 4G...)$$, NULL);
	EXECUTE ins_technical_specification($$Charge utile maximum$$, $$Poids maximum d'équipement supplémentaire que le drone peut transporter$$, 'kg');
	EXECUTE ins_technical_specification($$Système de navigation$$, $$Comment le drone se repère (GPS, vision par ordinateur, sonar...)$$, NULL);
	EXECUTE ins_technical_specification($$Précision de positionnement$$, $$La précision à laquelle le drone se repère.$$, 'cm');
	EXECUTE ins_technical_specification($$Vitesse maximum terrestre$$, $$Vitesse maximale sur le sol$$, 'km/h');
	EXECUTE ins_technical_specification($$Profondeur opérationnelle$$, $$Profondeur maximale à laquelle le drone aquatique peut opérer$$, 'm');
	EXECUTE ins_technical_specification($$Flottabilité$$, $$Capacité du drone aquatique à rester à une profondeur spécifiée$$, NULL);
	EXECUTE ins_technical_specification($$Moteurs$$, $$Nombre et type de moteurs$$, NULL);
	EXECUTE ins_technical_specification($$Temps de charge$$, $$Temps nécessaire pour recharger la batterie$$, 'h');
	EXECUTE ins_technical_specification($$Système anticollision$$, $$Technologie utilisée pour éviter les obstacles en vol ou en mouvement$$, NULL);
	EXECUTE ins_technical_specification($$Mode retour$$, $$Fonctionnalité permettant au drone de revenir automatiquement à un point de départ$$, NULL);
	EXECUTE ins_technical_specification($$Plage de température opérationnelle$$, $$Plage de températures dans laquelle le drone peut fonctionner de manière optimale$$, '°C');
	EXECUTE ins_technical_specification($$Autonomie en veille$$, $$Durée pendant laquelle le drone peut rester allumé sans voler ou bouger$$, 'h');
	EXECUTE ins_technical_specification($$Type de propulsion$$, $$Mécanisme de propulsion (hélices, roues, jets d'eau...)$$, NULL);
	EXECUTE ins_technical_specification($$Connectivité$$, $$Types de connexions prises en charge (Bluetooth, Wi-Fi Direct, LTE...)$$, NULL);
	EXECUTE ins_technical_specification($$Support de carte mémoire$$, $$Type de carte mémoire externe supporté (SD, microSD...)$$, NULL);
	EXECUTE ins_technical_specification($$Champ vision caméra$$, $$Angle de vision de la caméra embarquée$$, 'FOV');
	EXECUTE ins_technical_specification($$Zoom optique$$, $$Capacités de zoom de la caméra, si disponible$$, 'x');
	EXECUTE ins_technical_specification($$Stabilisation gimbal$$, $$Axes de stabilisation pour le gimbal de la caméra$$, 'axes');
	EXECUTE ins_technical_specification($$Système d'exploitation$$, $$Système d'exploitation logicielle embarqué$$, NULL);
	EXECUTE ins_technical_specification($$Logiciel embarqué$$, $$Outil logiciel disponible embarqué sur le drone$$, NULL);
	EXECUTE ins_technical_specification($$Modes pilotage$$, $$Différents modes de contrôle (manuel, automatique, programmé...)$$, NULL);
	EXECUTE ins_technical_specification($$Nombre de passagers$$, $$Nombre de passagers de taille et poids standards$$, NULL);
	EXECUTE ins_technical_specification($$Certification$$, $$Certification autorisée par un organisme gouvernemental ou indépendant$$, NULL);
	EXECUTE ins_technical_specification($$Brouillage$$, $$Résistance aux interférences ou au brouillage électronique$$, NULL);
	EXECUTE ins_technical_specification($$Compatibilité logicielle$$, $$Logiciels ou applications avec lesquels le drone est compatible$$, NULL);
	EXECUTE ins_technical_specification($$Mode décollage-atterrissage$$, $$Modes de décollage et d'atterrissage (manuel, automatique)$$, NULL);
	EXECUTE ins_technical_specification($$Type batterie$$, $$Technologie de la batterie utilisée (LiPo, NiMH, Li-Ion...)$$, NULL);
	EXECUTE ins_technical_specification($$Divers$$, $$Autres caractéristiques notables du drone$$, NULL);
COMMIT;

DEALLOCATE ins_technical_specification;



CREATE OR REPLACE FUNCTION forbid_dml_operations() 
    RETURNS TRIGGER
LANGUAGE PLPGSQL AS $$
BEGIN
    RAISE EXCEPTION 'Opération % interdite dans table %', TG_OP, TG_TABLE_NAME;
END$$;

CREATE TRIGGER forbid_dml_operations_trig_unit
	BEFORE INSERT OR UPDATE OR DELETE ON unit
	FOR EACH ROW
	EXECUTE PROCEDURE forbid_dml_operations();

CREATE TRIGGER forbid_dml_operations_trig_ts
	BEFORE INSERT OR UPDATE OR DELETE ON technical_specification
	FOR EACH ROW
	EXECUTE PROCEDURE forbid_dml_operations();

	






	



	
