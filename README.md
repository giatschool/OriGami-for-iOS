# Ori-Gami

Ori-Gami ist ein Spiel für Kinder im Alter von 8 - 12 Jahren, welche mit Hilfe moderner Technologien lernen sich auf einer Karte zurechtzufinden. Zum einen kann Ori-Gami als web-basierte version in einem Browser am PC gespielt werden, zum anderen gibt es eine App für Apple iOS-Geräte (iPhone, iPod Touch, iPad). Dies ermöglicht eine mobile Nutzung von digitalen Karten, GPS und Online-Anbindung.

## Spielprinzip und Zielgruppe
Das Prinzip des Spiels ist simpel: Die Spieler versuchen anhand von Hinweisen auf einem iPad den Weg zu einem bestimmten Ort zu finden. Ist dieser erreicht, erscheinen neue Hinweise die zum nächsten Ort führen. Nach einer gewissen Anzahl an Orten ist das Ziel erreicht. Das Spiel ist für Kinder im Alter von 8 bis 12 Jahren gestaltet, die Verwendung von modernen Technologien wie dem iPad soll zusätzliches Interesse am Erlernen der Orientierung mit Karten wecken.

Die Inhalte des Spiels, die einzelnen Routen und Wegpunkte, sind dynamisch gehalten. Bevor man anfangen kann zu spielen, muss zunächst eine Route angelegt werden, welche die Spieler anschließend ablaufen können. Dies ist im Moment nur über einen [Online Editor](giv-learn2.uni-muenster.de/origami/editor) möglich. Beim Anlegen einer neuen Route wird eine Routen-ID generiert, durch diese kann man anschließend im Spiel die Route aufrufen.

## Aufbau der Webseite


## Editor


## Aufbau der App
Wird die App gestartet erscheint zunächst ein Auswahlmenü mit den Optionen "Neues Spiel starten", "Editor" und "Anleitung". Wählt man ein neues Spiel, so wird der Spieler zunächst aufgefordert, eine Route auszuwählen. Dies geschieht über die direkte Eingabe einer Routen-ID, oder durch Suchen nach dem Namen einer vorhandenen Route. Hat man eine korrekte Routen-ID eingegeben, wird die eigentliche Spielansicht geladen.

![Ori-Gami Spielansicht][ori-gami_game]

Hier sieht man den eigenen Standort als kleinen Smiley in der Bildschirmmitte. Am unteren Bildschirmrand wird die aktuelle Aufgabe angezeigt und oben rechts befindet sich ein weiterer, großer Smiley, welcher als Entfernungsanzeige zur nächsten Aufgabe dient. Umso näher man dem Ziel kommt, desto mehr lächelt der Smiley und die Farbe verändert sich zu einem freundlichen Grün.

Hat der Spieler die Aufgabe erfüllt und ist am angegebenen Wegpunkt angekommen, so erscheint direkt die nächste Aufgabe und ein akustisches Signal ertönt um die Aufmerksamkeit auf den Bildschirm und das Spiel zu lenken. Der Smiley wird zurück auf eine neutrale Position gesetzt um die neue Entfernung zum nächsten Wegpunkt zu reflektieren. 

Die Spielansicht ist absichtlich möglichst simpel gehalten, um die Spieler (Kinder) nicht durch unnötige User-Interface-Elemente zu verwirren und den Lerneffekt zu maximieren. In diesem Fall gilt das Sprichwort *"Weniger ist manchmal mehr"*. So wird sichergestellt, dass die Kinder sich auf das Spiel konzentrieren und nicht "aus Versehen" einen Knopf drücken und nicht wissen, wie sie zum Spiel zurückkehren können.


## Entwicklungsverlauf

**1. Vorgeschichte**  
Im Wintersemester 2011/2012 wurde im Rahmen des Kurses Educational Map-Apps unter der Leitung von Thomas Bartoschek der Prototyp einer Webseite erstellt, welche Kindern den Umgang mit Karten erleichtern soll. Das Prinzip und die Technologien sind die gleichen, aus denen später die Ori-Gami-Versionen hervorgegangen sind. Aufgrund von Zeitmangel ist aus dieser Webseite nicht mehr als ein rudimentärer Prototyp entstanden, welcher mehr den Zweck hatte, die verwendeten ESRI-Technologien zu demonstrieren.

**2. Prototyp iPad-Version**  
Im Sommer 2012 ist, inspiriert von der Webseite des EMA-Kurses eine erste Version einer iPad-Version des damals noch namenlosen Spiels entstanden. Dabei ging es zunächst darum, das Spielprinzip auf das Tablet zu portieren und eine lauffähige Version zu erstellen. Diese erste Version verfügte noch nicht über ein ansprechendes Design und sah noch nicht wirklich nach interessantem Spiel aus. Der Grundstein war jedoch gelegt und die damals verfügbaren Schnittstellen wurden auf intelligente Art und Weise benutzt und in der App verwendet.

Technisch gesehen wurde in dieser Phase der benötigte ArcGIS-Server und die Datenbank installiert, und einfache Testdaten angelegt. Die iPad-App ist in Objective-C programmiert und verwendete das zu dem Zeitpunkt aktuellste ArcGIS-iOS-SDK in der Version 2.2.1. Die einzelnen Routen waren als einzelne FeatureLayers hinterlegt, wobei ein Feature einen Wegpunkt dargestellt hat.

**3. User-Test am Hittorf-Gymnasium**  
Am 5. September 2012 wurde ein User-Test am Wilhelm-Hittorf-Gymnasium in Münster durchgeführt. Dabei wurde insgesamt 12 Schülern jeweils einzeln die App vorgestellt, das Spielprinzip erklärt und anschließend mit ihnen eine Runde gespielt. Dafür wurde eigens eine Testroute rund um das Hittorf-Gymnasium angelegt, welche die Schüler unter Aufsicht abgelaufen haben. Um den Test möglichst gut auszuwerten, wurde eine spezielle Verison der iPad-App verwendet, welche in der Lage ist, die Berührungspunkte auf dem Bildschirm sowie die tatsächlich zurückgelegte Wegstrecke aufzuzeichnen. Zusätzlich wurde von den Schülern ein Fragebogen ausgefüllt und ihr Verhalten während des Spiels festgehalten. So waren wir in der Lage, uns ein detailliertes Bild der tatsächlichen Benutzung des Spiels durch Kinder zu machen und festzustellen, an welchen Stellen wir die App noch verbessern können.

**4. Verbesserungen**  
 Ein Kritikpunkt des User-Tests war unter anderem, dass der Smiley, welcher die Entfernung symbolisiert, zunächst ein unfreundliches rotes Gesicht anzeigt. Dies wurde in späteren Versionen zu einem neutralen, gelben Gesicht geändert, welches nur rot und unfreundlich wird, wenn sich der Spieler in die falsche Richtung begibt. Außerdem gab es zu diesem Zeitpunkt noch keine deutlichere Anzeige des Spielers auf der Karte, die eigene Position wurde lediglich als blauer Punkt dargestellt. Generell wünschten sich die Kinder ein etwas bunteres und "hübscheres" Design, diesem Wunsch wurde in einer späteren Version nachgegangen. Die Kinder haben jedoch alle die Funktion des Entfernungs-Smileys erkannt und dies auch positiv angemerkt.
 
 Zu diesem Zeitpunkt haben wir uns auch auf den Namen Ori-Gami geeignet, da er das Spielkonzept "Orientation Gaming" auf spielerische Art und Weise darstellt.

**5. Developer-Summit**  
Im November 2012 fand in Berlin der *ESRI-Developer-Summit* statt, eine eintägige Konferenz, welche sich ausschließlich mit der Entwicklung von Software mit Hilfe von ESRI-Technologien befasste. Wir waren als Entwickler von Ori-Gami angereist und erhofften uns interessante Vorträge, welche uns in der Entwicklung voranbrachten. 
Insbesondere durch die vorgestellten Themen rund um die JavaScript APIs konnten wir die web-basierte Version und den Editor bedeutend vorantreiben.

**6. Webseite + Editor**  
Mit den Erfahrungen vom Developer Summit haben wir das zugrundeliegende Datenmodell überarbeitet. Die einzelnen Route werden nun nicht mehr als einzelne FeatureLayer gespeichert, sondern werden, mit der Routen-ID versehen, in einem einzigen FeatureLayer gespeichert, welcher mit der Datenbank verbunden ist. 

**7. Neue iPad-Version mit Redesign**  
Anfang 2013 hat ESRI eine neue Version des ArcGIS-iOS-SDKs veröffentlicht, in der einige gute Neuerungen vorhanden waren. Viele Arbeitsschritte wurden vereinfacht und so entschlossen wir uns, die iPad-Version von Grund auf neu zu gestalten und mit dem vorhandenen Wissen über die Funktionsweise der API die App noch besser zu machen. Das Ergebnis ist eine hübsche App im Holz-Papier-Look, welche schon bedeutend mehr nach "Spiel" aussieht.

![Ori-Gami Hauptmenü][ori-gami_main]

Auch technisch gesehen hat sich einiges verändert. Die App ist immer noch in Objective-C programmiert und verwendet auch weiterhin das ArcGIS-iOS-SDK, allerdings wurde "unter der Haube" viel optimiert und verbessert. Zunächst einmal musste das Datenmodell (die Repräsentation der Routen im Programm) überarbeitet und an die neue Struktur auf dem Server angepasst werden. Auch in der iPad-App wird nun ein einziger FeatureLayer verwendet, welcher allerdings immer nur die Wegpunkte der Route anzeigt, für die eine Routen-ID ausgewählt wurde.

In der alten Version der App wurde zur Bestimmung der aktuellen Position die offizielle API von Apple verwendet (*"CoreLocation"*). Dies ist mit der neuen Version überflüssig geworden da die Position nun durch die ArcGIS API bestimmt wird. Somit wurde die alte Methode nicht übernommen um Fehler durch Redundanz zu vermeiden. Außerdem wird nun die Route als ganzes bei Spielstart geladen. Bislang war es so, dass die App bei jedem erreichten Wegpunkt beim Server nachfragen musste, wo es denn als nächstes hingeht. Dies entfällt nun, was in einer der nächsten Versionen auch die Möglichkeit eines Offline-Spiels ermöglichen könnte.

Die Reihenfolge in der die einzelnen Daten geladen werden ist nun klarer strukturiert und sinnvoll aufeinander aufgebaut. Als erstes wird die Grundkarte von OpenStreetMap geladen. Ist diese fertig geladen, wird der FeatureLayer zur Karte hinzugefügt und wenn dies erfolgreich war, eine Anfrage an denselben gestellt, nur die Wegpunkte anzuzeigen, deren Routen-ID im Vorfeld ausgewählt wurde. Erst wenn auch diese Anfrage erfolgreich war, wird die eigentliche Route aus den angezeigten Wegpunkten erstellt und das Spiel gestartet. "Angezeigt" ist in diesem Fall rein technisch zu verstehen, da diese zwar unsichtbar sind (vollständig transparentes Symbol), für das System allerdings sehr wohl sichtbar sind, sonst könnten wir keine Route erstellen.

Weiterhin wurde eine Suchfunktion für bereits erfasste Routen implementiert. Dabei werden sämtliche vorhandene Routen-IDs im FeatureLayer gesammelt und doppelte Einträge entfernt. Es gibt doppelte Einträge, da im FeatureLayer jeder Wegpunkt aus jeder Route gespeichert ist, das sieht in etwa so aus wie in der unten stehenden Tabelle.

| Wegpunkt | Koordinaten | Routen-ID |
| ------ | ------ | ------ |
|  1  |  47N 35O  |   hjs34 |
|  2  |  46N 35O  |   hjs34  |
|  3  |  46N 34O  |   hjs34  |
|  1  |  52N 7O  |   b0815 |
|  2  |  51N 7O  |   b0815  |

In diesem Fall würde zunächst fünf Routen-IDs gesammelt und anschließend die doppelten Einträge entfernt werden um die beiden relevanten Einträge *hjs34* und *b0815* zu erhalten. Alle diese Routen-IDs werden dann in einer Liste angezeigt und der Spiele kann seine gewünschte Route auswählen. Damit dieses System allerdings richtig gut funktioniert, muss zu der Routen-ID auch der entsprechende Name der Route angezeigt werden, ansonsten sieht man immer nur die kryptischen Buchstaben-Zahlen-Kombinationen. Dafür müssen erst noch einige Änderungen an der Datenbank vorgenommen werden, dies ist für eine der nächsten Versionen geplant.

Das sind die wichtigsten technischen Änderungen, das die iPad-App ist dadurch wesentlich robuster und verlässlicher geworden. Auch wenn sich am grundsätzlichen Spielprinzip nichts geändert hat, funktioniert Ori-Gami nun deutlich besser.

## Ausblick

Für die kommenden Verisonen sind folgende Verbesserungen geplant:

1. Beim Anlegen einer Route im webbasierten Editor soll man die Möglichkeit haben, sich selbst oder den Kindern eine Mail mit der Routen-ID zu schicken. Weiterhin besteht die Möglichkeit direkt eine "Routen-Datei" anzuhängen, welche in der iPad-App geladen und die Route direkt geöffnet werden kann.
2. Generell muss die Routen-ID auch beim Bearbeiten einer Route permanent angezeigt und beim Setzen des Zielpunkts noch einmal besonders darauf hingewiesen werden.
3. Im Moment gibt es noch kein einheitliches Sprachkonzept innerhalb der iPad-App. Viele Texte sind auf deutsch oder englisch oder beidem gemischt. Dies muss noch vereinheitlicht und in mehrere Sprachen übersetzt werden, zunächst auf deutsch und englisch.
4. Die Auswahl einer Route muss noch stark verbessert werden. Eine kryptische Routen-ID ist praktisch für den Computer aber nicht für zehnjährige Kinder. Eine Auswahl anhand des Names der Route - oder noch besser: direkt mit graphischer Visualisierung auf einer Mini-Karte - wäre optimal.
5. Optimal wäre auch die Möglichkeit Ori-Gami offline ohne Internetverbindung zu spielen. Der Grundstein dazu ist bereits gelegt, es muss allerdings noch das benötigte Kartenmaterial im Vorfeld gespeichert werden.

## Glossar   

Hier sind einige Begriffe erklärt, welche für einen technischen Laien unter Umständen nicht direkt verständlich sein könnten.

**iOS**  
iOS ist das Betriebssystem für iPhones und iPads, ähnlich wie Windows das Betriebssystem für PCs ist. Mit Hilfe eines SDKs kann man für iOS Software entwickeln.

**SDK**   
Ein SDK - das steht für *Software Development Kit* - ist eine Sammlung an Programmen, Tools und Frameworks, welche es dem Programmierer ermöglichen, zu einem bestimmten Gerät oder "Thema" Software zu entwickeln. Das ArcGIS-iOS-SDK ermöglicht es, ESRI-Technologien wie den ArcGIS-Server in einer iPhone- oder iPad-App anzusprechen und zu benutzen.

**API**  
API steht für *Application Programming Interface* und beizeichnet die softwareseitige Möglichkeit, von einem Programm aus eine andere Plattform, Technologie oder auch ein anderes Programm anzusprechen. Dazu werden bestimmte Befehle bereitgestellt um beispielsweise Daten in einer für beide Programme kompatiblen Form zu übermitteln. Das ArcGIS-iOS-SDK stellt beispielsweise eine API bereit um mit einem Server zu kommunizieren und Geodaten anzuzeigen.

**Objective-C**  
Programmiersprache in der die iPad-App von Ori-Gami geschrieben ist. Es handelt sich um eine so genannte *objektorientierte* Programmiersprache.

**JavaScript**  
Programmiersprache in der die Web-App von Ori-Gami geschrieben ist. Es handelt sich um eine so genannte *Skriptsprache*.

**FeatureLayer**  
Ein Begriff aus der ArcGIS-Welt. Ein FeatureLayer ist wie eine Folie, die man über eine Karte legt, und auf der sämtliche Routen und Wegpunkte aufgemalt wurden. Der Vorteil ist, dass man mit Hilfe eines FeatureLayers nur bestimmte Punkte anzeigen kann und die restlichen ganz einfach ausblendet. So sieht man immer nur die Route, die man gerade ausgewählt hat.

[ori-gami_main]: file://localhost/Users/Benni/Dropbox/Geospatial%20Learning/Blog/Hauptmenu.png "Ori-Gami Hauptmenü" width="200px" height="384px"

[ori-gami_game]: file://localhost/Users/Benni/Dropbox/Geospatial%20Learning/Blog/Spielansicht.png "Ori-Gami Spielansicht" width="200px" height="316px"