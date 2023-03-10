-- Réponses SQL

-- Exo 1: afficher des lignes
select * from contacts c  
limit 20;
-- Exo 2 : compter les lignes
select COUNT(*) nbr_de_lignes
from contacts c;
select COUNT(*) nbr_de_lignes
from visionnages v;
select COUNT(*) nbr_de_lignes
from profs p;
select COUNT(*) nbr_de_lignes
from abonnements a;
select COUNT(*) nbr_de_lignes
from planning p;
select COUNT(*) nbr_de_lignes
from cours c;
-- Exo 3
SELECT "cours" nom,
COUNT(*) nbr_de_lignes
FROM cours
UNION
SELECT "visionnages", COUNT(*)
FROM visionnages
UNION
SELECT "contacts", COUNT(*)
FROM contacts;
-- exo 4
SELECT pl.dateDebut, c.nomCours,
pr.nom FROM planning pl
LEFT JOIN cours c
ON pl.idCours = c.idCours
LEFT JOIN profs pr
ON pr.idProf = pl.idProf;
-- exo 5
SELECT c.idContact, a.dateDebut,
a.dateFin, a.prix FROM contacts c
LEFT JOIN abonnements a ON
c.idContact = a.idContact;
-- 10 179 lignes
SELECT count(*) FROM contacts c;
-- 5 917 lignes






