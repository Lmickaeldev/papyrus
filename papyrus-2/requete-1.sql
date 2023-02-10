--Quelles sont les commandes du fournisseur n°9120 ?
SELECT * 
FROM `entcom` 
WHERE numfou = 9120;

--Afficher le code des fournisseurs pour lesquels des commandes ont été passées.
SELECT COUNT(numcom), numfou 
FROM `entcom` 
GROUP BY numfou;

--Afficher le nombre de commandes fournisseurs passées, et le nombre de fournisseur concernés.
SELECT COUNT(numcom), COUNT(numfou) 
FROM `entcom`;

--Extraire les produits ayant un stock inférieur ou égal au stock d'alerte, et dont la quantité annuelle est inférieure à 1000.
SELECT codart, libart, stkphy, stkale, qteann 
FROM `produit` 
WHERE stkphy <= stkale 
AND qteann <= 1000;

--Quels sont les fournisseurs situés dans les départements 75, 78, 92, 77 ?
SELECT SUBSTR(posfou,1,2) , nomfou 
FROM `fournis` 
WHERE posfou 
LIKE'75%' or posfou 
LIKE '78%' or posfou 
LIKE'92%' or posfou 
LIKE '77%' 
ORDER BY posfou DESC, nomfou;

--Quelles sont les commandes passées en mars et en avril ?
SELECT numcom, datcom 
FROM `entcom` 
WHERE month(datcom) = 3 or month(datcom) = 4;

-- Quelles sont les commandes du jour qui ont des observations particulières ?
SELECT numcom, datcom 
FROM `entcom` 
WHERE obscom IS NOT null 
AND year(datcom)= year(CURRENT_TIMESTAMP ());

--Lister le total de chaque commande par total décroissant.
SELECT numcom, (qtecde * priuni) as 'TOTAL' 
FROM `ligcom`
ORDER BY TOTAL DESC; 

--Lister les commandes dont le total est supérieur à 10000€ ; on exclura dans le calcul du total les articles commandés en quantité supérieure ou égale à 1000.
SELECT numcom, (qtecde * priuni) as 'TOTAL' 
FROM `ligcom` 
WHERE qtecde 
BETWEEN 1000 AND 100000;

--Lister les commandes par nom de fournisseur.
SELECT nomfou, datcom, numcom 
FROM `fournis`,`entcom` 
WHERE entcom.numfou = fournis.numfou;

--Sortir les produits des commandes ayant le mot "urgent' en observation.
SELECT `entcom`.`numcom` AS Commande, 
`fournis`.`nomfou` AS Fournisseur, 
`produit`.`libart` AS Article, 
`ligcom`.`priuni` * `ligcom`.`qtecde` AS Prix
FROM entcom 
JOIN fournis ON entcom.`numfou` = `fournis`.`numfou`
JOIN `ligcom` ON `ligcom`.`numcom`= entcom.`numcom`
JOIN produit ON `produit`.`codart` = ligcom.`codart`
WHERE entcom.`obscom` = 'Commande urgente';

--Coder de 2 manières différentes la requête suivante : Lister le nom des fournisseurs susceptibles de livrer au moins un article.
SELECT nomfou 
FROM `entcom`,`fournis`,`ligcom`
WHERE entcom.numfou = fournis.numfou and entcom.numcom = ligcom.numcom  AND qteliv >= 1 
GROUP BY nomfou;

--Coder de 2 manières différentes la requête suivante : Lister les commandes dont le fournisseur est celui de la commande n°70210.
SELECT numcom, datcom FROM `entcom` 
WHERE numfou = (SELECT numfou FROM `entcom` 
WHERE numcom = 70210);

--Dans les articles susceptibles d’être vendus, lister les articles moins chers (basés sur Prix1) que le moins cher des rubans (article dont le premier caractère commence par R).
SELECT libart,prix1 FROM `vente`,`produit`
WHERE produit.codart = vente.codart AND stkphy > 0 AND 'prix' < (select min(prix1) 
FROM `vente`,`produit` 
WHERE produit.codart = vente.codart AND libart  LIKE 'R%' )GROUP BY libart,prix1;

--Sortir la liste des fournisseurs susceptibles de livrer les produits dont le stock est inférieur ou égal à 150 % du stock d'alerte.
SELECT libart, numfou, nomfou, stkale, stkphy 
FROM `produit`, `fournis` 
WHERE stkphy <= (stkale * 1.5);

--Sortir la liste des fournisseurs susceptibles de livrer les produits dont le stock est inférieur ou égal à 150 % du stock d'alerte, et un délai de livraison d'au maximum 30 jours.
SELECT libart, fournis.numfou, nomfou, stkale, stkphy, delliv 
FROM `produit`, `fournis`, `vente` 
WHERE stkphy <= (stkale * 1.5) AND delliv < 30;

--Avec le même type de sélection que ci-dessus, sortir un total des stocks par fournisseur, triés par total décroissant.
SELECT numfou, stkphy FROM `vente`, `produit` 
WHERE produit.codart = produit.codart 
GROUP BY numfou 
ORDER BY 'stock' DESC;

--En fin d'année, sortir la liste des produits dont la quantité réellement commandée dépasse 90% de la quantité annuelle prévue.
SELECT produit.`libart` AS produits
FROM produit 
JOIN ligcom ON produit.`codart` = ligcom.`codart`
WHERE (produit.`qteann` * 0.9) < ligcom.`qtecde`
GROUP BY ligcom.`codart`;
--Calculer le chiffre d'affaire par fournisseur pour l'année 2018, sachant que les prix indiqués sont hors taxes et que le taux de TVA est 20%.
SELECT fournis.`nomfou` AS Fournisseurs, sum(ligcom.`qteliv` * ligcom.`priuni`) * 1.2 AS CA FROM fournis JOIN vente ON vente.`numfou` = fournis.`numfou` JOIN ligcom ON ligcom.`codart` = vente.`codart` GROUP BY fournis.`nomfou`; 


