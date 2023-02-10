
--les besoin de mise a jour exercice

--Appliquer une augmentation de tarif de 4% pour le prix 1, et de 2% pour le prix2, pour le fournisseur 9180. 
UPDATE "vente" SET prix1 = prix *0.04 AND prix2 = prix2 * 0.02 
WHERE numfou = 9180;

--Dans la table vente, mettre à jour le prix2 des articles dont le prix2 est nul, en affectant la valeur du prix1.
UPDATE "vente" SET prix2 = prix1 
WHERE prix2 IS NULL;

--Mettre à jour le champ obscom, en renseignant ***** pour toutes les commandes dont le fournisseur a un indice de satisfaction inférieur à 5.
UPDATE "entcom" 
JOIN "fournis" ON entcom.numfou = fournis.numfou SET obscom = "****" 
WHERE satisf < 5;

--Supprimer le produit "I110".
DELETE FROM "produit" WHERE codart = "I110";
DELETE FROM "vente" WHERE codart = "I110";
DELETE FROM "ligcom" WHERE codart = "I110";
