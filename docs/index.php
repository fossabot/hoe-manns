<?php
// dauerhafte PHP-Weiterleitung (Statuscode 301)
header("HTTP/1.1 301 Moved Permanently");
// Weiterleitungsziel. Wohin soll eine permanente Weiterleitung erfolgen?
header("Location:http://saigkill.github.io/hoe-manns/build/hoe-manns/");
// zur Sicherheit ein exit-Aufruf, falls Probleme aufgetreten sind
exit;
?>
