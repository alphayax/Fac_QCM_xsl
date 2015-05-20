<?php
	//header("Content-Type: application/xhtml+xml; charset= UTF-8");
	
	$chaineRenvoyee = "";
	$themeCourant = 1;
	foreach ($_POST as $nomQuestion => $reponse)
	{
		//echo $nomQuestion . ":" . $reponse . "<br />";
		if (preg_match ("/^t([0-9]*)q[0-9]*/", $nomQuestion, $TabQuestion)) 
		{
			// Changement de theme. Le séparateur est |
			if ($TabQuestion[1] != $themeCourant)
			{
				$chaineRenvoyee .= "|";
				$themeCourant++;
			}
			
			// Dans le cas de cases a cocher, la variable retournée est un tableau.
			if (is_array($reponse))
			{
				foreach ($_POST[$nomQuestion] as $indiceTab => $casecochee)
				{
					//echo $nomQuestion . "[$indiceTab] : " . $casecochee . "<br />";
					$chaineRenvoyee .= "$casecochee,";
				}
				$chaineRenvoyee .= ":";
			}
			else
			{
				$chaineRenvoyee .= "$reponse:";
			}
		}
	}
	$chaineRenvoyee .= "|";
	
	//echo "<br /><font size=\"+2\" color=\"red\">Chaine renvoyée : <i>$chaineRenvoyee</i></font>";
	
	
	
	// En fonction de l'OS du *serveur* on désigne le PATH jusqu'a XSLTproc
//	if (ereg("Linux", $_SERVER["HTTP_USER_AGENT"])) <-- ne marche pas, car identifie le client et non le serveur
//	{ $xsltproc = '/usr/bin/xsltproc'; }
//	else if (ereg("WinNT", $_SERVER["HTTP_USER_AGENT"])||ereg("Windows NT", $_SERVER["HTTP_USER_AGENT"])) 
//	{ $xsltproc = 'C:\Windows\system32\xsltproc'; }

	$xsltproc = '/usr/bin/xsltproc';				//sous linux
	//$xsltproc = 'C:\Windows\system32\xsltproc';		//sous windows
	
	// Affichage de  la correction
	$cmd = $xsltproc . ' --param reponses \'"' . $chaineRenvoyee . '"\'  score.xsl qcm.xml 2>&1';
//	echo $cmd;
	exec($cmd,$array_res);
	echo implode("\n",$array_res);
	
	// Affichage des graphes
	$cmd2 = $xsltproc . ' --param reponses \'"' . $chaineRenvoyee . '"\'  stats.xsl qcm.xml 1>stats_svg.xhtml'; // redirection vers un fichier XML-SVG
//	echo $cmd2;
	exec($cmd2,$array_res2);
?>
