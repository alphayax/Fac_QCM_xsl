Ponzoni Yann
IUP GMI 2

Projet : 
Questionnaire a Choix Multiples XML-XSL-SVG avec utilisation de XSLTproc via PHP ^^

Mirroirs:
82.228.150.24/QCM/
www.eretnia.hd.free.fr/QCM/

Notes Imoprtantes :
	- Certains caract�res japonais n�c�cittent l'installation d'une police sp�ciale sur l'ordinateur
	executant la page web. Il faut donc pour que l'affichage soit OK a 100% que votre ordinateur prenne
	en charge les polices d'extreme orient (Japonais, chinois simplifi�, etc...)
	- Le programme devrait th�oriquement fonctionner sous tous syst�mes et sous tous les navigateurs
	vu que le code utilis� est conforme aux recommendations du W3C. 
	- Environnement de d�veloppement : WinXP & Firefox 1.5


Points forts :

-XML
	On d�nombrera plusieurs types de questions et de r�ponses:
	Questions:
		- Texte
		- Image
	R�ponses:
		- Choix unique
		- Choix Multiple
		- Texte a rentrer
		- Je ne sais pas (Chiiiiiiiii !! Wakaranai !!)
	
	Il est a noter la hioerarchie de couleur pour la pr�sentation du QCM, affichant un d�grad� 
	du bleu fonc� (pout les themes) allant au bleu clai pour les r�ponses en passant par un bleu leger 
	pour les questions.
	La r�ponse "Je ne sais pas" se d�marque �galement par un fond sp�cifique (g�n�r� a partir d'une image)


-XSL
	La page de donn�es XML est interpr�t� par une feuille XSL.
	Dans un premier temps, c'est qcm.xsl qui est appell� pour pr�senter les questions.
	Par la suite, une fois que les questions ont �t� correctement saisies, c'est score.xsl qui est invoqu�.
	Enfin, via cette derniere et par l'intermediaire d'une balise <iframe> une 'animation' (hum hum) SVG est 
	pr�sent�e suivant la feuille de style stats.xsl


-SVG
	Comme cit� plus haut, le SVG s'affiche via une balise <iframe> contenue dans score.xsl
	Le code du fichier SVG en question est g�n�r� via XSLTproc dans le PHP. Il redirige alors le flux
	vers le fichier stats_svg.xhtml. Ce dernier fichier est g�n�r� a partir de stats.xsl et qcm.xml
	Il pr�sente les scores aux differants themes sous forme d'histogrammes horizontaux, avec pour terminer
	le score total atteint (visible dans une couleur diff�rante).

-PHP
	Le fichier qcm.php est pr�sent pour parser la chaine a renvoyer a XSLTproc et pour transmetre les
	parametres a la feuille XSL.
	XSLTproc est utilis� quand a lui par 2 fois : 
		- Generation de la page de correction du questionnaire
		- Generation du SVG

-Mise en forme
	Les fichiers qcm.js et qcm.css servent juste � mettre en page les pages web.


Concernant les questions du QCM:

	Mon choix de th�me s'est port� sur les "animes".
	C'est un choix qui d�signais a l'origine le monde de la Japanimation (Annimation nipponne) mais j'ai
	pr�f�r� l'�tendre sur les themes "G�n�riques", "S�ries", "Japonnais" et "JPOP" l'univers en question �tant 
	assez large en informations :P
	
	
	
	
	