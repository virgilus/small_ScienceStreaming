WITH recap AS(
SELECT
vi.idContact
, co.nomCours
, co.idCours
, pr.idProf
, pr.prenom
, pr.nom
, SUM(secondesVues) AS temps_visionne_en_s
FROM visionnages vi
INNER JOIN planning pl ON vi.idPlanning = pl.idPlanning
INNER JOIN cours co ON pl.idCours = co.idCours
INNER JOIN profs pr ON pl.idProf = pr.idProf
GROUP BY
vi.idContact
, co.nomCours
, co.idCours
, pr.idProf
, pr.prenom
, pr.nom
ORDER BY idContact DESC),
classement AS (
SELECT 
idContact,
temps_visionne_en_s,
idCours,
nomCours,
idProf,
nom,
prenom,
ROW_NUMBER() OVER (
    PARTITION BY idContact 
    ORDER BY temps_visionne_en_s DESC) row_num
FROM 
recap),
top_cours_par_client AS
(SELECT * FROM classement WHERE row_num = 1),
r AS (
SELECT idContact,
SUM(prix) AS somme_prix_unitaire
FROM abonnements
GROUP BY idContact),
v AS (
SELECT idContact,
SUM(secondesVues) temps_total_visionne_en_s
FROM visionnages
GROUP BY idcontact)
SELECT
r.idContact
, c.sexe AS genre
, c.codeDept
, c.dateNaissance
, t.idCours AS top_idCours
, t.nomCours AS top_nomCours
, t.idProf AS top_idProf
, t.prenom AS top_prenomProf
, t.nom AS top_nomProf
, TIMESTAMPDIFF(YEAR, dateNaissance, CURDATE()) AS age -- optionnel
-- , v.temps_total_visionne_en_s, -- contient des NULL donc on fait un CASE :
, CASE WHEN v.temps_total_visionne_en_s IS NULL THEN 0
       ELSE v.temps_total_visionne_en_s END
       AS temps_total_visionne_en_s
, CASE WHEN somme_prix_unitaire = 0 THEN 0
       ELSE 1 END
       AS abo_payant
FROM r
INNER JOIN contacts c
ON r.idContact = c.idContact
INNER JOIN v
ON r.idContact = v.idContact
INNER JOIN top_cours_par_client t
ON r.idContact = t.idContact;
