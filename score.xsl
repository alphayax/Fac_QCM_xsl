<?xml version="1.0" encoding="ISO-8859-1" ?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:output method="html" encoding="UTF-8" />
<xsl:param name="reponses" />



<!-- Template de base -->
<xsl:template match="qcm">
 <html
  xmlns="http://www.w3.org/1999/xhtml"
  xmlns:svg="http://www.w3.org/2000/svg"
  >
  <head>
   <title>..:: QWIZZZ !! ::..</title>
   <link rel="stylesheet" type="text/css" href="qcm.css" />
   <script langage="javascript" src="qcm.js" />
  </head>
  <body>
   <table width="100%">
    <tr>
     <td align="center" bgcolor="#CCCCFF">
      <font size="+2"><xsl:value-of select="@matiere" /> <i> (correction)</i></font>
     </td>
    </tr>
   </table>
   <!-- appel du template Theme -->
   <xsl:call-template name="calcul_score_theme">
    <xsl:with-param name="reponses" select="$reponses" />
    <xsl:with-param name="num_theme" select="1" />
    <xsl:with-param name="score" select="0" />
   </xsl:call-template>
   <center>
    <object data="stats_svg.xhtml" type="image/svg+xml" width="650" height="350" />
   </center>
  </body>
 </html>
</xsl:template>



<!-- Fonction d'affichage des themes -->
<xsl:template name="calcul_score_theme">
 <xsl:param name="reponses" />		<!-- Reponses du theme en cours -->
 <xsl:param name="num_theme" /> 	<!-- Numero du theme en cours -->
 <xsl:param name="score" />			<!-- Score total de tous les themes -->
 
 <xsl:variable name="reponses_theme" select="substring-before($reponses, '|')" />		<!-- Les reponses du theme a traiter -->
 <xsl:variable name="reponses_hors_theme" select="substring-after($reponses, '|')" />	<!-- Les autres reponses -->
 
 <table width="100%">
  <tr>
   <td align="left" bgcolor="#CCCCFF">
    <H3>
     <i>
      <br />
      Th&#232;me <xsl:value-of select="$num_theme" /> : <xsl:value-of select="theme[$num_theme]/@titre" />
     </i>
    </H3>
   </td>
  </tr>
 </table> 

 <!-- Calcul du score du theme en cours -->
 <xsl:variable name="score_theme">
  <xsl:call-template name="calcul_score">
   <xsl:with-param name="reponses" select="$reponses_theme" />
   <xsl:with-param name="num_theme" select="$num_theme" />
   <xsl:with-param name="num_question" select="1" />
   <xsl:with-param name="score" select="0" />
  </xsl:call-template>
 </xsl:variable>
 
 <!-- Affichage des réponses du theme en cours -->
 <xsl:call-template name="affichage_question">
  <xsl:with-param name="reponses" select="$reponses_theme" />
  <xsl:with-param name="num_theme" select="$num_theme" />
  <xsl:with-param name="num_question" select="1" />
 </xsl:call-template>
 
 <br /><br />
 <H3>Score du theme : <xsl:value-of select="$score_theme" /></H3>
 
 <xsl:choose>
  <xsl:when test="string-length($reponses_hors_theme) >= 1">
   <xsl:call-template name="calcul_score_theme">
    <xsl:with-param name="reponses" select="$reponses_hors_theme"/>
    <xsl:with-param name="num_theme" select="$num_theme + 1" />
    <xsl:with-param name="score" select="$score + $score_theme"/>
   </xsl:call-template>
  </xsl:when>
  <xsl:otherwise>
   <table width="100%">
    <tr>
     <td align="center" bgcolor="#AAAAFF">
      <H3><br />Score Total : <xsl:value-of select="$score + $score_theme"/></H3>
     </td>
    </tr>
   </table>
  </xsl:otherwise>
 </xsl:choose>
</xsl:template>



<!-- Fonction de calcul du score des questions -->
<xsl:template name="calcul_score">
 <xsl:param name="reponses" />
 <xsl:param name="num_theme" />
 <xsl:param name="num_question" />
 <xsl:param name="score" />
 
 <xsl:variable name="reponses_question" select="substring-before($reponses, ':')" />
 <xsl:variable name="reponses_hors_question" select="substring-after($reponses, ':')" />
 
 <!-- Cette Variable recupere le score de la question en cours. -->
 <xsl:variable name="score_question">
  <xsl:choose>
   <xsl:when test="$reponses_question = 0">0</xsl:when>
   <xsl:otherwise>
    <xsl:choose>
	 <xsl:when test="theme[$num_theme]/question[$num_question]/@choix='radio'">
	  <xsl:value-of select="theme[$num_theme]/question[$num_question]/choix[position()=$reponses_question]/@score" />
	 </xsl:when>
	 <xsl:when test="theme[$num_theme]/question[$num_question]/@choix='cases'">
	  <xsl:call-template name="calcul_choix_multiples">
	   <xsl:with-param name="reponses" select="$reponses_question"/>
	   <xsl:with-param name="num_theme" select="$num_theme" />
	   <xsl:with-param name="num_question" select="$num_question" />
	   <xsl:with-param name="score_actuel" select="0" />
	  </xsl:call-template>
	  <br />
	 </xsl:when>
	 <xsl:when test="theme[$num_theme]/question[$num_question]/@choix='texte'">
	  <xsl:choose>
	   <xsl:when test="$reponses_question = theme[$num_theme]/question[$num_question]/choix">
	    <xsl:value-of select="theme[$num_theme]/question[$num_question]/choix/@score" />
	   </xsl:when>
	   <xsl:otherwise>
	    <xsl:value-of select="0 - theme[$num_theme]/question[$num_question]/choix/@score" />
	   </xsl:otherwise>
	  </xsl:choose>
	 </xsl:when>
    </xsl:choose>
   </xsl:otherwise>
  </xsl:choose>
 </xsl:variable>

 <!-- 
  Appel recursif de calcul du score pour ce theme 
  tant qu'il reste des questions a traiter.
  Si il n'y a plus de question, on affiche le total pour ce theme;
  cette donnée sera récuperee dans le template 'calcul_score_theme'.
 -->
 <xsl:choose>
  <xsl:when test="string-length($reponses_hors_question) &gt; 1">
   <xsl:call-template name="calcul_score">
    <xsl:with-param name="reponses" select="$reponses_hors_question"/>
    <xsl:with-param name="num_theme" select="$num_theme"/>
    <xsl:with-param name="num_question" select="$num_question + 1"/>
    <xsl:with-param name="score" select="$score + $score_question"/>
   </xsl:call-template>
  </xsl:when>
  <xsl:otherwise>
   <xsl:value-of select="$score + $score_question"/>
  </xsl:otherwise>
 </xsl:choose>
</xsl:template>



<!-- Fonction d'affichage des questions et de leurs reponses -->
<xsl:template name="affichage_question">
 <xsl:param name="reponses" />
 <xsl:param name="num_theme" />
 <xsl:param name="num_question" />
 
 <xsl:variable name="reponses_question" select="substring-before($reponses, ':')" />
 <xsl:variable name="reponses_hors_question" select="substring-after($reponses, ':')" />

 <H3>
  Question <xsl:value-of select="$num_question" /> : 
  <xsl:value-of select="theme[$num_theme]/question[$num_question]/libelle" />
 </H3>
 
 <!-- Cette Variable recupere le score de la question en cours. -->
 <xsl:variable name="score_question">
  <xsl:choose>
   <xsl:when test="$reponses_question = 0">0</xsl:when>
   <xsl:otherwise>
    <xsl:choose>
	 <xsl:when test="theme[$num_theme]/question[$num_question]/@choix='radio'">
	  <xsl:value-of select="theme[$num_theme]/question[$num_question]/choix[position()=$reponses_question]/@score" />
	 </xsl:when>
	 <xsl:when test="theme[$num_theme]/question[$num_question]/@choix='cases'">
	  <xsl:call-template name="calcul_choix_multiples">
	   <xsl:with-param name="reponses" select="$reponses_question"/>
	   <xsl:with-param name="num_theme" select="$num_theme" />
	   <xsl:with-param name="num_question" select="$num_question" />
	   <xsl:with-param name="score_actuel" select="0" />
	  </xsl:call-template>
	  <br />
	 </xsl:when>
	 <xsl:when test="theme[$num_theme]/question[$num_question]/@choix='texte'">
	  <xsl:choose>
	   <xsl:when test="$reponses_question = theme[$num_theme]/question[$num_question]/choix">
	    <xsl:value-of select="theme[$num_theme]/question[$num_question]/choix/@score" />
	   </xsl:when>
	   <xsl:otherwise>
	    <xsl:value-of select="0 - theme[$num_theme]/question[$num_question]/choix/@score" />
	   </xsl:otherwise>
	  </xsl:choose>
	 </xsl:when>
    </xsl:choose>
   </xsl:otherwise>
  </xsl:choose>
 </xsl:variable>
 
 <!-- Affichage des reponses saisies et correction -->
 <xsl:choose>
  <xsl:when test="$reponses_question = 0">
   <i>Vous avez choisi de ne pas répondre a cette question.</i><br />
  </xsl:when>
  <xsl:otherwise>
   <!-- Suivant le type des questions on aura des reponses sous d'autre formes -->
   <xsl:choose>
	<xsl:when test="theme[$num_theme]/question[$num_question]/@choix='radio'">
	 Réponse choisie (<xsl:value-of select="$reponses_question" />) : 
	 <xsl:value-of select="theme[$num_theme]/question[$num_question]/choix[position()=$reponses_question]" /><br />
	 Réponse exacte : 
	 <xsl:call-template name="affichage_reponses">
      <xsl:with-param name="num_theme" select="$num_theme" />
      <xsl:with-param name="num_question" select="$num_question" />
     </xsl:call-template>
     <br />
	</xsl:when>
	<xsl:when test="theme[$num_theme]/question[$num_question]/@choix='cases'">
	 Réponses choisies (<xsl:value-of select="$reponses_question" />) : <br />
	 <!-- Appel recursif pour le decorticage de la chaine de choix multiple -->
	 <xsl:call-template name="affiche_choix_multiples">
      <xsl:with-param name="reponses" select="$reponses_question"/>
      <xsl:with-param name="num_theme" select="$num_theme" />
      <xsl:with-param name="num_question" select="$num_question" />
     </xsl:call-template>
	 Réponses exactes : <br />
	 <xsl:call-template name="affichage_reponses_choix_multiple">
      <xsl:with-param name="num_theme" select="$num_theme" />
      <xsl:with-param name="num_question" select="$num_question" />
     </xsl:call-template>     
	</xsl:when>
	<xsl:when test="theme[$num_theme]/question[$num_question]/@choix='texte'">
	 Réponse saisie : <xsl:value-of select="$reponses_question" /><br />
	 Réponse exacte : <xsl:value-of select="theme[$num_theme]/question[$num_question]/choix" /><br />
	</xsl:when>
   </xsl:choose>
  </xsl:otherwise>
 </xsl:choose>
 
 <!-- Cette variable recupere la note maximum pour la question courante -->
 <xsl:variable name="Note_Max">
  <xsl:call-template name="calcul_note_max">
   <xsl:with-param name="num_theme" select="$num_theme" />
   <xsl:with-param name="num_question" select="$num_question" />
  </xsl:call-template>
 </xsl:variable>
 
 <xsl:choose>
  <xsl:when test="$score_question &gt; 0">
   <font color="green">Votre reponse est correcte ^^ (<xsl:value-of select="$score_question" />/<xsl:value-of select="$Note_Max" /> pts)</font>
  </xsl:when>
  <xsl:otherwise>
   <font color="red">Votre reponse est erronée. (<xsl:value-of select="$score_question" />/<xsl:value-of select="$Note_Max" /> pts)</font>
  </xsl:otherwise>
 </xsl:choose>
 <xsl:choose>
  <xsl:when test="string-length($reponses_hors_question) &gt; 1">
   <xsl:call-template name="affichage_question">
    <xsl:with-param name="reponses" select="$reponses_hors_question" />
    <xsl:with-param name="num_question" select="$num_question + 1" />
    <xsl:with-param name="num_theme" select="$num_theme" />
   </xsl:call-template>
  </xsl:when>
  <xsl:otherwise>
   <!-- fin du theme en cours -->
  </xsl:otherwise>
 </xsl:choose>
</xsl:template>



<!-- Fonction d'affichage des choix multiples -->
<xsl:template name="affiche_choix_multiples">
 <xsl:param name="reponses" />		<!-- Reponses de la question en cours -->
 <xsl:param name="num_theme" /> 	<!-- Numero du theme en cours -->
 <xsl:param name="num_question" /> 	<!-- Numero de la question en cours -->
 
 <xsl:variable name="choix_actuel" select="substring-before($reponses, ',')" />		<!-- Le choix en cours -->
 <xsl:variable name="choix_autres" select="substring-after($reponses, ',')" />		<!-- Les autres choix -->
 
  - <xsl:value-of select="theme[$num_theme]/question[$num_question]/choix[position()=$choix_actuel]" /><br />
 
 <xsl:if test="string-length($choix_autres) &gt; 1">
  <xsl:call-template name="affiche_choix_multiples">
   <xsl:with-param name="reponses" select="$choix_autres"/>
   <xsl:with-param name="num_theme" select="$num_theme" />
   <xsl:with-param name="num_question" select="$num_question" />
  </xsl:call-template>
 </xsl:if>
</xsl:template>



<!-- Fonction de calcul des choix multiples -->
<xsl:template name="calcul_choix_multiples">
 <xsl:param name="reponses" />		<!-- Reponses de la question en cours -->
 <xsl:param name="num_theme" /> 	<!-- Numero du theme en cours -->
 <xsl:param name="num_question" /> 	<!-- Numero de la question en cours -->
 <xsl:param name="score_actuel" /> 	<!-- Score de la question a choix multiple -->
 
 <xsl:variable name="choix_actuel" select="substring-before($reponses, ',')" />		<!-- Le choix en cours -->
 <xsl:variable name="choix_autres" select="substring-after($reponses, ',')" />		<!-- Les autres choix -->
 
 <xsl:choose>
  <xsl:when test="string-length($choix_autres) &gt; 1">
   <xsl:call-template name="calcul_choix_multiples">
    <xsl:with-param name="reponses" select="$choix_autres"/>
    <xsl:with-param name="num_theme" select="$num_theme" />
    <xsl:with-param name="num_question" select="$num_question" />
    <xsl:with-param name="score_actuel" select="$score_actuel + theme[$num_theme]/question[$num_question]/choix[position()=$choix_actuel]/@score" />
   </xsl:call-template>
  </xsl:when>
  <xsl:otherwise>
   <xsl:value-of select="$score_actuel + theme[$num_theme]/question[$num_question]/choix[position()=$choix_actuel]/@score" /><br />
  </xsl:otherwise>
 </xsl:choose>
</xsl:template>



<!-- Fonction d'affichage des bonnes reponses -->
<xsl:template name="affichage_reponses">
 <xsl:param name="num_theme" /> 	<!-- Numero du theme en cours -->
 <xsl:param name="num_question" /> 	<!-- Numero de la question en cours -->

 <xsl:for-each select="theme[$num_theme]/question[$num_question]/choix">
  <xsl:if test="@score &gt; 0">
   <xsl:value-of select="text()"/> 
  </xsl:if>
 </xsl:for-each>
</xsl:template>



<!-- Fonction d'affichage des bonnes reponses (choix multiples) -->
<xsl:template name="affichage_reponses_choix_multiple">
 <xsl:param name="num_theme" /> 	<!-- Numero du theme en cours -->
 <xsl:param name="num_question" /> 	<!-- Numero de la question en cours -->

 <xsl:for-each select="theme[$num_theme]/question[$num_question]/choix">
  <xsl:if test="@score &gt; 0">
   - <xsl:value-of select="text()"/><br />
  </xsl:if>
 </xsl:for-each>
</xsl:template>



<!-- Fonction de calcul de la note maximale possible -->
<xsl:template name="calcul_note_max">
 <xsl:param name="num_theme" /> 	<!-- Numero du theme en cours -->
 <xsl:param name="num_question" /> 	<!-- Numero de la question en cours -->

 <xsl:choose>
  <xsl:when test="theme[$num_theme]/question[$num_question]/@choix='radio'">
  <!-- ATTENTION !! Ne gere pas le cas de bonnes reponses multiples -->
   <xsl:for-each select="theme[$num_theme]/question[$num_question]/choix">
    <xsl:if test="@score &gt; 0">
     <xsl:value-of select="@score"/> 
    </xsl:if>
   </xsl:for-each>
  </xsl:when>
  <xsl:when test="theme[$num_theme]/question[$num_question]/@choix='cases'">
  <!-- fff -->
   <xsl:call-template name="calul_note_max_choix_multiples">
    <xsl:with-param name="num_theme" select="$num_theme" />
    <xsl:with-param name="num_question" select="$num_question" />
    <xsl:with-param name="num_reponse" select="1"/>
    <xsl:with-param name="score_atteint" select="0" />
   </xsl:call-template>
  <!-- fff -->
   
  </xsl:when>
  <xsl:when test="theme[$num_theme]/question[$num_question]/@choix='texte'">
   <xsl:value-of select="theme[$num_theme]/question[$num_question]/choix/@score" />
  </xsl:when>
 </xsl:choose>
 
</xsl:template>


<!-- Fonction de calcul de la note maximale pour les choix multiples -->
<xsl:template name="calul_note_max_choix_multiples">
 <xsl:param name="num_theme" /> 	<!-- Numéro du theme -->
 <xsl:param name="num_question" /> 	<!-- Numéro de la question -->
 <xsl:param name="num_reponse" /> 	<!-- Numéro de la réponse -->
 <xsl:param name="score_atteint" /> <!-- Score  du theme en cours -->

 <xsl:variable name="Score_reponse">
  <xsl:choose>
   <xsl:when test="theme[$num_theme]/question[$num_question]/choix[position()=$num_reponse]/@score &gt; 0">
    <xsl:value-of select="$score_atteint + theme[$num_theme]/question[$num_question]/choix[position()=$num_reponse]/@score" />
   </xsl:when>
   <xsl:otherwise>
    <xsl:value-of select="$score_atteint" />
   </xsl:otherwise>
  </xsl:choose>
 </xsl:variable>
 
 <xsl:choose>
  <xsl:when test="theme[$num_theme]/question[$num_question]/choix[position()=$num_reponse] != theme[$num_theme]/question[$num_question]/choix[position()=last()]">
   <xsl:call-template name="calul_note_max_choix_multiples">
    <xsl:with-param name="num_theme" select="$num_theme" />
    <xsl:with-param name="num_question" select="$num_question" />
    <xsl:with-param name="num_reponse" select="$num_reponse + 1"/>
    <xsl:with-param name="score_atteint" select="$Score_reponse" />
   </xsl:call-template>
  </xsl:when>
  <xsl:otherwise>
   <xsl:value-of select="$Score_reponse" />
  </xsl:otherwise>
 </xsl:choose>
</xsl:template>


</xsl:stylesheet>



