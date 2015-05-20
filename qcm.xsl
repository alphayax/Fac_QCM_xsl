<?xml version="1.0" encoding="ISO-8859-1" ?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:output method="html" encoding="UTF-8" />


<xsl:template match="qcm">
 <html>
  <head>
   <title>..:: QWIZZZ !! ::..</title>
   <link rel="stylesheet" type="text/css" href="qcm.css" />
   <script langage="javascript" src="qcm.js" />
  </head>
  <body>
   <table width="100%">
    <tr>
     <td align="center" bgcolor="#CCCCFF">
      <font size="+2"><xsl:value-of select="@matiere" /></font>
     </td>
    </tr>
   </table>
   <br />
    <form action="qcm.php" method="POST">
	 <xsl:apply-templates />
	 <center>
	  <input type="submit" />
	 </center>
	</form>
  </body>
 </html>
</xsl:template>

<xsl:template match="theme">
   <table width="80%" align="center">
    <tr>
     <td align="left" bgcolor="#CCCCFF">
      <font size="+1"><i>Th&#232;me : <xsl:value-of select="@titre" /></i></font>
     </td>
    </tr>
   </table>   
   <xsl:apply-templates />
</xsl:template>

<xsl:template match="question">
   <table width="80%" align="center">
    <tr>
     <td align="left" bgcolor="#E0E0FF">
	  <xsl:choose>
	   <xsl:when test="@type='image'">
		<i>Question :</i><br /><img src="{child::libelle}" />
	   </xsl:when>
	   <xsl:when test="@type='texte'">
		<i>Question : <xsl:value-of select="child::libelle" /></i>
	   </xsl:when>
	  </xsl:choose>	
     </td>
    </tr>
   </table>
   <xsl:apply-templates select="choix"/>
   <table width="80%" align="center">
    <tr>
     <td align="left" bgcolor="#EFEFFF" background="chiwakaranai.jpg">
	  <input 
            type="radio"
            value="0"
            name="{concat('t',count(preceding::theme)+1,'q',count(preceding-sibling::question)+1)}"
            checked="checked"
            onClick="effaceReponses({concat('t',count(preceding::theme)+1,'q',count(preceding-sibling::question)+1)})"
            />
          Chiiiiiiiii !! Wakaranai !! (Chii ne comprends pas)
     </td>
    </tr>
   </table>
</xsl:template>

<xsl:template match="choix">
   <xsl:variable 
     name="NumeroThemeQuestion"
     select="concat('t',count(preceding::theme)+1,'q',count(../preceding-sibling::question)+1)"
     />
   <table width="80%" align="center">
    <tr>
     <td align="left" bgcolor="#EFEFFF">
	  <xsl:choose>
	   <xsl:when test="../@choix='radio'">
		<input type="radio" value="{position()}" name="{$NumeroThemeQuestion}"/>
        <xsl:value-of select="child::text()" />
	   </xsl:when>
	   <xsl:when test="../@choix='cases'">
		<input type="checkbox" value="{position()}" name="{concat($NumeroThemeQuestion,'[]')}" onClick="{concat($NumeroThemeQuestion,'.checked = false;')}" />
        <xsl:value-of select="child::text()" />
	   </xsl:when>
	   <xsl:when test="../@choix='texte'">
		<input type="text" name="{$NumeroThemeQuestion}" onClick="{concat($NumeroThemeQuestion,'[1].checked = false;')}" />
	   </xsl:when>
	  </xsl:choose>
     </td>
    </tr>
   </table>
</xsl:template>

</xsl:stylesheet>