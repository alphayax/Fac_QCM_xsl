Ponzoni Yann
IUP GMI 2

Projet : 
Questionnaire a Choix Multiples XML-XSL-SVG avec utilisation de XSLTproc via PHP ^^

Mirroirs:
82.228.150.24/QCM/
www.eretnia.hd.free.fr/QCM/

## Notes Importantes
- Certains caractères japonais nécécittent l'installation d'une police spéciale sur l'ordinateur executant la page web. Il faut donc pour que l'affichage soit OK a 100% que votre ordinateur prenne en charge les polices d'extreme orient (Japonais, chinois simplifié, etc...)
- Le programme devrait théoriquement fonctionner sous tous systèmes et sous tous les navigateurs vu que le code utilisé est conforme aux recommendations du W3C. 
- Environnement de développement : WinXP & Firefox 1.5


## Points forts

### XML
 On dénombrera plusieurs types de questions et de réponses :
 
#### Questions
 - Texte
 - Image

#### Réponses
- Choix unique
- Choix Multiple
- Texte a rentrer
- Je ne sais pas (Chiiiiiiiii !! Wakaranai !!)

Il est a noter la hierarchie de couleur pour la présentation du QCM, affichant un dégradé du bleu foncé (pout les themes) allant au bleu clai pour les réponses en passant par un bleu leger pour les questions.
La réponse "Je ne sais pas" se démarque également par un fond spécifique (généré à partir d'une image)


### XSL

La page de données XML est interprété par une feuille XSL.

Dans un premier temps, c'est qcm.xsl qui est appellé pour présenter les questions.

Par la suite, une fois que les questions ont été correctement saisies, c'est score.xsl qui est invoqué.

Enfin, via cette derniere et par l'intermediaire d'une balise `<iframe>` une 'animation' SVG est présentée suivant la feuille de style stats.xsl


### SVG

Comme cité plus haut, le SVG s'affiche via une balise `<iframe>` contenue dans score.xsl
Le code du fichier SVG en question est généré via XSLTproc dans le PHP. Il redirige alors le flux vers le fichier stats_svg.xhtml. Ce dernier fichier est généré a partir de stats.xsl et qcm.xml
Il présente les scores aux differants themes sous forme d'histogrammes horizontaux, avec pour terminer le score total atteint (visible dans une couleur différente).

### PHP

Le fichier qcm.php est présent pour parser la chaine a renvoyer a XSLTproc et pour transmetre les parametres a la feuille XSL.
XSLTproc est utilisé quand a lui par 2 fois : 
- Generation de la page de correction du questionnaire
- Generation du SVG

## Mise en forme

Les fichiers qcm.js et qcm.css servent juste à mettre en page les pages web.


Concernant les questions du QCM:

Mon choix de thème s'est porté sur les "animes".
C'est un choix qui désignais a l'origine le monde de la Japanimation (Annimation nipponne) mais j'ai préféré l'étendre sur les themes "Génériques", "Séries", "Japonnais" et "JPOP" l'univers en question étant assez large en informations :P
