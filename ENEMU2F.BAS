DECLARE SUB ShowHighscore (hs() AS ANY)
DECLARE SUB helptext ()
'Enemu2.4 Menu
'(C)2003-2004 Alexander Weld
RANDOMIZE TIMER
ON ERROR GOTO nhs
ON TIMER(1) GOSUB fad
DEF fnfnr (r, g, b) = 65536 * b + 256 * g + r
SCREEN 12
TYPE ft
        f AS INTEGER
        t AS INTEGER
        s AS INTEGER
END TYPE
TYPE fade
        c AS INTEGER
        r AS ft
        g AS ft
        b AS ft
        s AS INTEGER
END TYPE
DIM fade(15) AS fade
FOR q = 1 TO 15
fade(q).c = q
fade(q).r.f = INT(RND * 64)
fade(q).r.t = INT(RND * 64)
fade(q).r.s = SGN(fade(q).r.t - fade(q).r.f)
fade(q).g.f = INT(RND * 64)
fade(q).g.t = INT(RND * 64)
fade(q).g.s = SGN(fade(q).g.t - fade(q).g.f)
fade(q).b.f = INT(RND * 64)
fade(q).b.t = INT(RND * 64)
fade(q).b.s = SGN(fade(q).b.t - fade(q).b.f)
NEXT q
'STOP
TYPE highsc
        n AS STRING * 20
        s AS INTEGER
        m AS INTEGER
        sz AS INTEGER
        lv AS INTEGER
END TYPE
DIM hs(10) AS highsc
DIM ax(4) AS STRING
ax(0) = "AAAA   LL     EEEE          XX   XX"
ax(1) = "A  A   LL     EE     x  x     X X  "
ax(2) = "AAAA   LL     EEEE    x        X   "
ax(3) = "A  A   LL     EE       x      X X  "
ax(4) = "A  A   LLLL   EEEE   x  x   XX   XX"
FOR y = 0 TO 4
l = LEN(ax(y))
FOR x = 1 TO l
ca = 35 / 14
c = (x / ca) + 1
COLOR c
bst$ = MID$(ax(y), x, 1)
PRINT bst$;
NEXT x
PRINT
NEXT y
DO
wt = TIMER
FOR q = 1 TO 15
IF fade(q).r.f <> fade(q).r.t THEN fade(q).r.f = fade(q).r.f + fade(q).r.s * 1: oc = oc + 1
IF fade(q).g.f <> fade(q).g.t THEN fade(q).g.f = fade(q).g.f + fade(q).g.s * 1: oc = oc + 1
IF fade(q).b.f <> fade(q).b.t THEN fade(q).b.f = fade(q).b.f + fade(q).b.s * 1: oc = oc + 1
IF oc <> 0 THEN
oc = 0
LOCATE 6
PALETTE fade(q).c, fnfnr(fade(q).r.f, fade(q).g.f, fade(q).b.f)
fc = fc + 1
END IF
NEXT q
IF fc = 0 THEN EXIT DO
fc = 0
DO
LOOP UNTIL TIMER - wt >= .05
LOOP UNTIL INKEY$ <> ""
PALETTE
CLS
DIM ed(4) AS STRING
ed(0) = "EEEE   NN   NN   EEEE   MM   MM   UU UU    2222    4  4"
ed(1) = "EE     NNN  NN   EE     MMM MMM   UU UU      22    4  4"
ed(2) = "EEEE   NN N NN   EEEE   MM M MM   UU UU    2222    4444"
ed(3) = "EE     NN  NNN   EE     MM   MM   UU UU    22   ..    4"
ed(4) = "EEEE   NN   NN   EEEE   MM   MM   UUUUU    2222 ..    4"
COLOR 8
FOR y = 0 TO 4
 l = LEN(ed(y))
 FOR x = 1 TO l
 bst$ = MID$(ed(y), x, 1)
 LOCATE 13, x
 PRINT "^"
 LOCATE y + 1, l + 3
 PRINT "<"
 IF bst$ <> " " THEN
 FOR yy = 11 TO y + 1 STEP -1
  IF yy <> y + 1 THEN COLOR 4 ELSE COLOR 8
  LOCATE yy, x
  PRINT MID$(ed(y), x, 1)
  LOCATE yy + 1, x
  PRINT " "
 NEXT yy
 FOR xx = l TO x STEP -1
  LOCATE y + 1, xx
  IF xx <> x THEN COLOR 2 ELSE COLOR 8
  PRINT MID$(ed(y), x, 1)
  LOCATE y + 1, xx + 1
  PRINT " "
 NEXT xx
 DO
 LOOP UNTIL TIMER - t1 >= .05
 t1 = TIMER
 END IF
 LOCATE 13, x
 PRINT " "
 LOCATE y + 1, l + 3
 PRINT " "
 IF INKEY$ <> "" THEN GOTO goon
 NEXT x
NEXT y
COLOR 7
DO
LOOP UNTIL INKEY$ <> ""
goon:
DIM menu$(4)
menu$(0) = "Spielen!"
menu$(1) = "Spiel laden"
menu$(2) = "Highscores"
menu$(3) = "Hilfetext"
menu$(4) = "Beenden"
DIM dmenu$(2)
dmenu$(0) = "Normal"
dmenu$(1) = "Schwer"
dmenu$(2) = "Sehr Schwer"

s = 0
sp = 1
GOSUB fad
TIMER ON
start:
CLS
GOSUB readhs
COLOR 7
PRINT "Enemu V2.4"
DO
s = s + sp
IF s >= l THEN sp = -1
IF s <= 1 THEN sp = 1
LOCATE 2
FOR q = 0 TO 4
IF a = q THEN
 COLOR ac1
 PRINT ">";
 COLOR ac2
 PRINT menu$(q);
 COLOR ac1
 PRINT "<"
 COLOR 7
ELSE
 PRINT " ";
 PRINT menu$(q); " "
END IF
NEXT q
aw$ = RIGHT$(INKEY$, 1)
SELECT CASE aw$
CASE "H", "K"
s = 0
a = a - 1
ac1 = a + 1
ac2 = a + 3
IF a < 0 THEN a = 4
CASE "P", "M"
s = 0
a = a + 1
ac1 = a + 1
ac2 = a + 3
IF a > 4 THEN a = 0
CASE CHR$(13)
EXIT DO
END SELECT
LOOP
SELECT CASE a
CASE 0
GOTO dmenu
CASE 1
INPUT "Gespeichertes Spiel:", gs$
IF RIGHT$(gs$, 4) <> ".esv" THEN gs$ = gs$ + ".esv"
af$ = "enemu2.exe --save" + gs$
SHELL af$
CASE 2
ShowHighscore hs()
CASE 3
helptext
CASE 4
END
END SELECT
GOTO start

readhs:
OPEN "highsc.dat" FOR RANDOM AS #1
IF LOF(1) < 10 THEN ERROR 210
FOR q = 1 TO 10
GET #1, q, hs(q)
IF hs(q).sz = 0 THEN hssz = hssz + 1
IF hs(q).lv = 0 THEN hslv = hslv + 1
NEXT q
IF hssz = 10 OR hslv = 10 THEN ERROR 211 ELSE hssz = 0: hslv = 0
CLOSE #1
RETURN

abr:
RETURN goon

fad:
ac1 = INT(RND * 15 + 1)
ac2 = INT(RND * 15 + 1)

RETURN

nhs:
er = ERR
SELECT CASE er
CASE 210
CLS
PRINT "Erzeuge neue Highscore Datei"
FOR q = 1 TO 10
hs(0).n = "Enemu"
hs(0).s = 11 - q
hs(0).m = (11 - q) * 50
hs(0).sz = 11 - q
hs(0).lv = 11 - q
PUT #1, q, hs(0)
NEXT q
CLOSE #1
CASE 211
hssz = 0
hslv = 0
CLOSE #1
KILL "highsc.dat"
CASE ELSE
PRINT "Unknown error Nr."; er
END
END SELECT
RESUME goon

dmenu:
 ad = 0
 DO
 FOR q = 0 TO 2
  LOCATE q + 2, 14
  IF ad = q THEN COLOR ad + 1: PRINT CHR$(175);  ELSE PRINT " ";
  PRINT dmenu$(q)
  COLOR 7
 NEXT q
 kd$ = RIGHT$(INKEY$, 1)
 SELECT CASE kd$
  CASE "H", "K"
  ad = ad - 1
  IF ad = -1 THEN ad = 2
  CASE "P", "M"
  ad = ad + 1
  IF ad = 3 THEN ad = 0
  CASE CHR$(13)
   EXIT DO
  CASE CHR$(27)
   ad = -1
   EXIT DO
 END SELECT
 LOOP
 SELECT CASE ad
 CASE 0
  d$ = "--easy"
 CASE 1
  d$ = "--medi"
 CASE 2
  d$ = "--hard"
 CASE -1
  GOTO start
 END SELECT
 asf$ = "enemu2.exe " + d$
 SHELL asf$
 GOTO start

SUB helptext
CLS
PRINT "Wilkommen zu Enemu V2.4"
PRINT "Du bist das Raumschiff unten und musst versuchen, die Raumschiffe"
PRINT "die von oben kommen, abzuschie·en, ohne selber getroffen zu werden."
PRINT "Alle 2 Minuten kommt ein Endgegnerm, den du besiegen musst."
PRINT "Danach îffnet sich ein Einkaufsladen, bei dem du fÅr Geld"
PRINT "nÅtzliche Dinge kaufen kannst."
PRINT "Alle 100 Punkte bekommst du ein Leben mehr."
PRINT "Wenn 'Score' GrÅn ist, hast du den untersten Highscore erreicht!"
PRINT "Wenn 'Score' Blau ist, hast du den Highscore!"
DO
LOOP UNTIL INKEY$ <> ""
PRINT "Steuerung:"
PRINT "Cursortasten: Bewegung"
PRINT "Leertaste: Schie·en"
PRINT "Eingabetaste: Megabombe"
PRINT "+: Extra weiter"
PRINT "-: Extra zurÅck"
PRINT "c: nÑchstes Ziel"
PRINT "y: vorheriges Ziel"
PRINT "x: wÑrmesuchende Rakete abfeuern"
PRINT "F1: Online Hilfe"
PRINT "F5: Spielbremse aus/an"
PRINT "F6: FPS anzeigen"
PRINT "F7: Still"
PRINT "F9: Spielpause"
PRINT "ESC: Abbrechen(Highscores werden gespeichert!)"
PRINT "(c)2003 by Alexander Weld"
DO
LOOP UNTIL INKEY$ <> ""
END SUB

SUB ShowHighscore (hs() AS highsc)
CLS
PRINT "Name"; SPACE$(16); "Punkte ", "Geld", "Spielzeit", "Level"
FOR q = 1 TO 10
COLOR q
PRINT hs(q).n; hs(q).s, hs(q).m, hs(q).sz, hs(q).lv
NEXT q
DO
LOOP UNTIL INKEY$ <> ""
COLOR 7
END SUB

