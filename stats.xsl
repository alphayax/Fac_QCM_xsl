<?xml version="1.0" encoding="ISO-8859-1" ?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:output method="html" encoding="UTF-8" />
<xsl:param name="reponses" />



<!-- Template de base -->
<xsl:template match="qcm">
<html xmlns="http://www.w3.org/1999/xhtml" xmlns:svg="http://www.w3.org/2000/svg">
 <body>
  <svg xmlns="http://www.w3.org/2000/svg" version="1.1" width="600" height="300">
  
   <!-- appel du template Theme -->
   <xsl:call-template name="calcul_score_theme">
    <xsl:with-param name="reponses" select="$reponses" />
    <xsl:with-param name="num_theme" select="1" />
    <xsl:with-param name="score" select="0" />
   </xsl:call-template>

  </svg>
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
 
 <!-- Calcul du score du theme en cours -->
 <xsl:variable name="score_theme">
  <xsl:call-template name="calcul_score">
   <xsl:with-param name="reponses" select="$reponses_theme" />
   <xsl:with-param name="num_theme" select="$num_theme" />
   <xsl:with-param name="num_question" select="1" />
   <xsl:with-param name="score" select="0" />
  </xsl:call-template>
 </xsl:variable>
 
 <text 
  xmlns="http://www.w3.org/2000/svg" 
  x="300" y="{30 * $num_theme}" fill="black" font-size="18"
  text-decoration="none" text-rendering="auto" text-anchor="start"
  >
   <xsl:value-of select="$score_theme" />
  </text> 

 <xsl:choose>
  <xsl:when test="$score_theme >= 0">
   <rect 
    xmlns="http://www.w3.org/2000/svg"
    width="{5 * $score_theme}" height="20" x="330" y="{30 * $num_theme - 18}" rx="5" ry="5"
    fill="#00daa3" stroke="black" stroke-opacity="1" stroke-width="2px"
    />
  </xsl:when>
  <xsl:otherwise>
   <rect 
    xmlns="http://www.w3.org/2000/svg"
    width="{-5 * $score_theme}" height="20" x="{290- (-5 * $score_theme)}" y="{30 * $num_theme - 18}" rx="5" ry="5"
    fill="#ee1100" stroke="black" stroke-opacity="1" stroke-width="2px"
    />
  </xsl:otherwise>
 </xsl:choose>
         
 <xsl:choose>
  <xsl:when test="string-length($reponses_hors_theme) >= 1">
   <xsl:call-template name="calcul_score_theme">
    <xsl:with-param name="reponses" select="$reponses_hors_theme"/>
    <xsl:with-param name="num_theme" select="$num_theme + 1" />
    <xsl:with-param name="score" select="$score + $score_theme"/>
   </xsl:call-template>
  </xsl:when>
  <xsl:otherwise>

 <text 
  xmlns="http://www.w3.org/2000/svg" 
  x="300" y="{30 * $num_theme + 50}" fill="black" font-size="18"
  text-decoration="none" text-rendering="auto" text-anchor="start"
  >
   <xsl:value-of select="$score + $score_theme" />
  </text> 
  
 <xsl:choose>
  <xsl:when test="($score + $score_theme) >= 0">
   <rect 
    xmlns="http://www.w3.org/2000/svg"
    width="{5 * ($score + $score_theme)}" height="20" x="330" y="{30 * $num_theme + 50 - 18}" rx="5" ry="5"
    fill="#6060ff" stroke="black" stroke-opacity="1" stroke-width="2px"
    />
  </xsl:when>
  <xsl:otherwise>
   <rect 
    xmlns="http://www.w3.org/2000/svg"
    width="{-5 * ($score + $score_theme)}" height="20" x="{290- (-5 * ($score + $score_theme))}" y="{30 * $num_theme + 50 - 18}" rx="5" ry="5"
    fill="#6060ff" stroke="black" stroke-opacity="1" stroke-width="2px"
    />
  </xsl:otherwise>
 </xsl:choose>
 
 



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



<!-- Fonction d'affichage des questions et de leurs reponses [affichage_question] (obselete) -->
<!-- Fonction d'affichage des choix multiples [affiche_choix_multiples] (obselete) -->


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



<!-- Fonction d'affichage des bonnes reponses [affichage_reponses] (obselete)-->
<!-- Fonction d'affichage des bonnes reponses (choix multiples) [affichage_reponses_choix_multiple] (obselete) -->


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



