# Moro Plus: Preis und Funktionsumfang

Konzept für eine App-Store-Version von Moro. Alle Zahlen sind Annahmen, es gibt noch keine echten Verkaufsdaten.

## Preis und Modell

- **Modell:** Kostenlos laden, einmalige Freischaltung **Moro Plus für 3,99 bis 4,99 EUR**.
- **Abo erst später:** Erst wenn Apple Health, Widget und Push-Erinnerungen fertig sind, etwa 1,99 EUR pro Monat oder 12,99 bis 14,99 EUR pro Jahr.
- **Warum kein reiner Kaufpreis:** Für eine neue, unbekannte App ist jeder Preis vor dem Download die größte Hürde. Zwischen 0,99, 1,99 und 2,99 EUR ist der Unterschied meist klein, der große Sprung liegt zwischen kostenlos und kostenpflichtig.
- **Falls doch Kaufpreis:** 2,99 EUR, mit 1,99 EUR als Startaktion. Der Preis lässt sich im App Store jederzeit ändern.
- **Erlös pro Verkauf bei 1,99 EUR:** 1,99 / 1,19 (MwSt.) = 1,67 EUR, davon 85 % (Apple Small Business Program) = **rund 1,42 EUR**.

## Kostenlos

| Funktion | Bezug in `moro.html` |
|---|---|
| Training, Wasser, Schlaf und Schritte erfassen, nur für heute | `TYPES`, Karte „Heute für dich“ |
| Wachstum vom Ei bis Erwachsen | `STAGES` |
| Tierlinie automatisch nach Training | `LINES`, Auswahl „Nach Training“ |
| Blaue Trinkflasche | `BOTTLES.blau` |
| Push-Erinnerungen (sobald gebaut) | Backlog |

Keine Bühnen-Hintergründe, keine weiteren Fundstücke, Flaschenfarben oder sonstigen Icons in der kostenlosen Version.

## Moro Plus

### Vorhandene Funktionen

| Funktion | Bezug in `moro.html` |
|---|---|
| Nachtragen für gestern | Auswahl „Heute / Gestern“ |
| Wochenziele | `WEEK_GOALS` |
| Tagesquests | `QUESTS` |
| Serie und Rekorde | `streak`, `streakBest`, `REC_LABELS` |
| Aktueller Wochenbrief und Archiv aller Wochenbriefe | Wochenbrief |
| Freie Tierwahl: Hase, Bär, Katze, Tiger | `PICKS` |
| Meisterstufen nach Erwachsen: Sterne, Scheinwerfer, Stadion, goldene Kontur | `MASTER_XP`, `MASTER_TEXT` |
| Fundstücke | `ITEMS` |
| Saisonale Fundstücke: Bommelmütze, Blumenkranz, Sonnenhut, Herbstblatt | `SEASON_ITEMS` |
| Alle weiteren Flaschenfarben | `BOTTLES` |
| Turnschuh-Modelle | `SHOES` |
| Bühnen-Hintergründe | `SCENES` |

### Aus dem Backlog

| Funktion | Hinweis |
|---|---|
| Apple Health oder Strava | Greifbarster Mehrwert, rechtfertigt höheren Preis oder Abo |
| Homescreen-Widget | Moro mit aktueller Stimmung |
| Moro-Wohnung mit freier Anordnung | Fundstücke per Ziehen platzieren |
| Gemeinsame Wochenziele mit Freunden | Besuchen und High Five bleiben kostenlos, sie bringen neue Nutzer |
| iCloud-Sicherung und Export | |

## Stufen über Kind

Zeitpunkte bei zwei fordernden Trainings pro Woche (etwa 133 XP):

| Stufe | XP | Ungefähr erreicht |
|---|---|---|
| Kind | 400 | Woche 3 |
| Teen (Tierlinie wird sichtbar) | 950 | Woche 7 |
| Erwachsen | 1700 | Woche 13 |

Empfehlung: Wachstum bis Erwachsen kostenlos lassen. Eine Sperre ab Kind bringt früh einen Kaufanreiz, aber Nutzer ohne Plus sehen nie ihr Tier, die App wirkt bestrafend und schlechte Bewertungen sind wahrscheinlich. Falls Stufen gesperrt werden, dann erst den Übergang Teen zu Erwachsen und offen als Probezeit kommunizieren.

## Risiken und offene Punkte

- **Schmale Gratisversion:** Ohne Wochenziele, Tagesquests, Serie und Wochenbrief bleibt kostenlos fast nur das Erfassen und das Wachstum. Risiko: Nutzer springen ab, bevor sie Plus kennenlernen. Empfehlung: 14 Tage Plus gratis zum Start.
- **Belohnungen hängen an Wochenzielen:** Flaschenfarben, Turnschuhe und Hintergründe werden heute über Wochenziele freigeschaltet. Da Wochenziele in Plus liegen, gibt es ohne Plus keine Belohnungen. Das passt zur Vorgabe, sollte aber bewusst so gewollt sein.
- **Nicht zugeordnet:** Fitness-Tests (`TESTS`) und Trainingsfakten (`FACTS`). Vorschlag: kostenlos, da es keine Icons sind und sie die Motivation stützen.
- **Preis testen:** Ob 3,99 oder 4,99 EUR besser funktioniert, ist unbekannt und sollte nach dem Start geprüft werden.
