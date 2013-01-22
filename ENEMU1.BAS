'ENEMU (c)2003 by Alexander Weld
DEF fndst (x1, y1, x2, y2) = SQR((ABS(x1 - x2) ^ 2) + (ABS(y1 - y2) ^ 2))
DEF fnfnr (r, g, b) = 65536 * b + 256 * g + r
CLS
SCREEN 12
RANDOMIZE TIMER
'ON ERROR GOTO eabf
TYPE high
        score AS INTEGER
        nam AS STRING * 20
END TYPE
DIM daten AS high
DIM hs(10)
DIM nam$(10)
OPEN "enemu.ini" FOR INPUT AS #1
INPUT #1, tt
CLOSE #1
agn:
OPEN "highsc.enu" FOR RANDOM AS #1
IF LOF(1) < 10 THEN ERROR 210
FOR q = 1 TO 10
GET 1, q, daten
hs(q) = daten.score
nam$(q) = daten.nam
NEXT q
CLOSE #1
TYPE ausr
        ls AS INTEGER
        rs AS INTEGER
        rw AS INTEGER
        lw AS INTEGER
END TYPE
TYPE giift
        nr AS INTEGER
        x AS INTEGER
        y AS INTEGER
END TYPE
TYPE shoot
        nr AS INTEGER
        x AS INTEGER
        y AS INTEGER
END TYPE
TYPE enem
        nr AS INTEGER
        x AS INTEGER
        y AS INTEGER
END TYPE
ggc = 0
se = 10
a = 10
lt = 10
DIM shots(20) AS shoot
DIM enemy(10) AS enem
DIM gifty(10) AS giift
DIM ship AS ausr
DIM shuttle(8, 15)
DIM shot(12, 12)
DIM enemyy(19, 3)
DIM gift(20, 20)
CONST false = 0
CONST true = 1
ship.ls = false
ship.lw = false
ship.rw = false
ship.rs = false
'gift
PSET (100, 100), 10
DRAW "c10r10l20r10u10d20u10"
CIRCLE (100, 100), 10, 10
GET (90, 90)-(110, 110), gift
CLS
'shuttle
PSET (100, 100)
DRAW "u10e4f4d10l8"
PAINT (101, 99)
GET (100, 85)-(108, 100), shuttle
CLS
'shot
CIRCLE (100, 100), 6, 9, , , 3
CIRCLE (100, 100), 6, 9, , , 3 / 10
CIRCLE (100, 100), 6, 9, , , 1
CIRCLE (100, 100), 6, 9, , , 1 / 10
GET (94, 94)-(106, 106), shot
CLS
'enemy
PSET (100, 100), 12
DRAW "c12e5r4u10l20d10r5f5"
PAINT (100, 99), 12
GET (90, 87)-(109, 100), enemyy
CLS
lx = 160
rx = 430
x = 300
px = x
y = 400
lsx = x - 20
rsx = x + 20
mc = 100
LINE (150, 400)-(150, 0)
LINE (450, 400)-(450, 0)
PUT (x, y), shuttle
IF ship.ls THEN PUT (lsx, y), shuttle
IF ship.rs THEN PUT (rsx, y), shuttle
DO
in$ = INKEY$
rin$ = RIGHT$(in$, 1)
SELECT CASE rin$
CASE CHR$(27)
GOTO crashed
CASE "a", "K"
IF x = lx THEN GOTO nm
x = x - 10
lsx = lsx - 10
rsx = rsx - 10
CASE "d", "M"
IF x = rx THEN GOTO nm
x = x + 10
lsx = lsx + 10
rsx = rsx + 10
CASE "p"
DO
IF INKEY$ = "c" THEN
        cheats = true
        se = 100
        lt = 100
END IF
LOOP UNTIL INKEY$ <> ""
CASE " "
IF NOT shooot THEN shooot = true
FOR ww = 1 TO 3
FOR q = 1 TO 20
IF shots(q).nr = 0 THEN an = q: EXIT FOR
c = c + 1
NEXT q
IF c = 20 THEN GOTO nm
IF lt - 5 < 0 THEN GOTO nm
SELECT CASE ww
CASE 1
        shots(an).nr = true
        shots(an).x = x - 2
        shots(an).y = y - 25
        PUT (shots(an).x, shots(an).y), shot
        lt = lt - 5
CASE 2 AND ship.lw = true AND ship.ls = true
        shots(an).nr = true
        shots(an).x = x - 22
        shots(an).y = y - 25
        PUT (shots(an).x, shots(an).y), shot
        lt = lt - 5
CASE 3 AND ship.rw = true AND ship.rs = true
        shots(an).nr = true
        shots(an).x = x + 22
        shots(an).y = y - 25
        PUT (shots(an).x, shots(an).y), shot
        lt = lt - 5
END SELECT
NEXT ww
nm:
c = 0
END SELECT
IF px <> x THEN
IF ship.ls THEN PUT (px - 20, y), shuttle
IF ship.rs THEN PUT (px + 20, y), shuttle
PUT (px, y), shuttle
PUT (x, y), shuttle
IF ship.ls THEN PUT (lsx, y), shuttle
IF ship.rs THEN PUT (rsx, y), shuttle
px = x
END IF
IF shooot THEN
        FOR q = 1 TO 20
        IF shots(q).nr = 0 THEN ccc = ccc + 1: GOTO nf
        FOR cct = 1 TO 20
        IF shots(cct).nr = 0 THEN GOTO ccww
        c = c + 1
ccww:
        NEXT cct
        IF shots(q).y - c < 1 THEN shots(q).nr = false: PUT (shots(q).x, shots(q).y), shot: GOTO nf
        PUT (shots(q).x, shots(q).y), shot
        shots(q).y = shots(q).y - c
        c = 0
        PUT (shots(q).x, shots(q).y), shot
nf:
        NEXT q
END IF
IF lt < se THEN
        IF a = 0 THEN
                lt = lt + 1
                IF lt / 5 = INT(lt / 5) THEN SOUND 100, 1
                a = 10
        ELSE
        a = a - 1
        END IF
END IF
aa = INT(RND(1) * 100 / (www + 1))
IF aa = 0 THEN
FOR q = 1 TO 10
IF enemy(q).nr = 0 THEN an = q: EXIT FOR
c = c + 1
NEXT q
IF c = 10 THEN GOTO noop
enemy(an).nr = true
enemy(an).x = INT(RND(1) * 260 + 170)
enemy(an).y = 1
PUT (enemy(an).x, enemy(an).y), enemyy
enemyyy = true
noop:
c = 0
END IF
IF enemyyy THEN
FOR q = 1 TO 10
IF enemy(q).nr = 0 THEN cc = cc + 1: GOTO ne
IF enemy(q).y > 400 THEN
        ec = ec + 1
        enemy(q).nr = false
        PUT (enemy(q).x, enemy(q).y), enemyy
        le = le - 1
        IF score - 2 < 0 THEN score = score ELSE score = score - 2
        SOUND 100, 3
        SELECT CASE ec
        CASE 1
         PUT (10, 150), enemyy, PSET
        CASE 2
         PUT (50, 150), enemyy, PSET
        CASE 3
         PUT (90, 150), enemyy, PSET
        CASE ELSE
         GOTO crashed
        END SELECT
       
        GOTO ne
END IF
PUT (enemy(q).x, enemy(q).y), enemyy
FOR ccc = 1 TO 10
IF enemy(ccc).nr = 0 THEN GOTO cccw
c = c + 1
cccw:
NEXT ccc
enemy(q).y = enemy(q).y + c
c = 0
PUT (enemy(q).x, enemy(q).y), enemyy
IF fndst(x, y, enemy(q).x, enemy(q).y) < 15 THEN GOTO crashed
FOR qq = 1 TO 10
IF shots(qq).nr = 0 THEN GOTO nnop
IF enemy(q).nr = 0 THEN GOTO nnop
IF fndst(shots(qq).x, shots(qq).y, enemy(q).x, enemy(q).y) < 15 THEN
        esc = esc + 1
        shots(qq).nr = 0: enemy(q).nr = 0
        enemy(q).nr = false
        PUT (enemy(q).x, enemy(q).y), enemyy
        PUT (shots(qq).x, shots(qq).y), shot
        le = le - 1
        shots(qq).nr = false
        ls = ls - 1
        score = score + 1
        FOR ff = 1 TO 10
        fr = INT(RND(1) * 500 + 700)
        SOUND fr, .1
        NEXT ff
        IF INT(RND(1) * 5) = 0 THEN
        'IF 1 = 1 THEN
         IF NOT giifty THEN giifty = true
         FOR qqq = 1 TO 10
         IF gifty(qqq).nr = 0 THEN an = qqq: EXIT FOR
         c = c + 1
         NEXT qqq
         IF c = 10 THEN GOTO nmm
         gifty(an).nr = true
         gifty(an).x = enemy(q).x
         gifty(an).y = enemy(q).y
         PUT (gifty(an).x, gifty(an).y), gift
nmm:
         c = 0
        END IF
END IF
nnop:
NEXT qq
ne:
NEXT q
IF cc = 0 THEN enemyyy = false:  cc = 0
END IF
IF giifty THEN
FOR q = 1 TO 10
IF gifty(q).nr = 0 THEN ccc = ccc + 1: GOTO nff
FOR cct = 1 TO 10
IF gifty(cct).nr = 0 THEN GOTO cccww
c = c + 1
cccww:
NEXT cct
IF gifty(q).y + c > 400 THEN
        gifty(q).nr = false
        PUT (gifty(q).x, gifty(q).y), gift
        PLAY "mbl32c<c<c<c>>>"
        LOCATE 10, 35
        PALETTE: fader = 0
        COLOR 4
        PRINT "LOST IT :("
        COLOR 7
        message = true
        msg$ = "LOST IT :("
        msgc = 4
        mc = 100
        GOTO nff
END IF
PUT (gifty(q).x, gifty(q).y), gift
gifty(q).y = gifty(q).y + c
c = 0
PUT (gifty(q).x, gifty(q).y), gift
IF fndst(gifty(q).x, gifty(q).y, x, y) < 15 THEN
        PUT (gifty(q).x, gifty(q).y), gift
        gifty(q).nr = false
        PLAY "mbl32c>c>c>c<<<"
        IF se < 100 THEN se = se + 5
        LOCATE 10, 35
        PALETTE: fadeg = 0
        COLOR 2
        PRINT "GOT IT :) "
        COLOR 7
        message = true
        msg$ = "GOT IT :) "
        msgc = 2
        mc = 100
        lt = se
        ggc = ggc + 1
        IF se = 60 AND NOT ship.lw THEN
                ship.lw = true
                ship.ls = true
                PUT (lsx, y), shuttle
                www = www + 1
        END IF
        IF se = 90 AND NOT ship.rw THEN
                ship.rw = true
                ship.rs = true
                PUT (rsx, y), shuttle
                www = www + 1
        END IF
        IF ec THEN
                gc = gc + 1
                IF gc = 2 THEN
                        ec = ec - 1
                        SELECT CASE ec
                        CASE 0
                         PUT (10, 150), enemyy
                        CASE 1
                         PUT (50, 150), enemyy
                        CASE 2
                         PUT (90, 150), enemyy
                        END SELECT
                        gc = 0
                END IF
        END IF
        score = score + 5
END IF
nff:
NEXT q
IF ccc = 0 THEN giifty = false:  ccc = 0

END IF
IF message = true THEN
        IF mc = 50 THEN
                IF msgc = 2 THEN gf = 64: fadeg = 1 ELSE rf = 64: fader = 1
        END IF
        IF mc = false THEN
                LOCATE 10, 35
                PRINT "          "
                mc = 100
                message = false
        END IF
        mc = mc - 1
END IF
LOCATE 1, 1
PRINT "Load Time:"; lt
IF lt >= 5 THEN COLOR 12: PRINT "Fire!": COLOR 7 ELSE PRINT "     "
PRINT "Score:"; score
IF score > hs(1) THEN
        hsc = 1
ELSEIF score > hs(10) THEN hsc = 10
ELSE hsc = 7
END IF
COLOR hsc
PRINT "Highscore:";
SELECT CASE hsc
CASE 2
PRINT hs(1)
CASE 1
PRINT score
CASE 7
PRINT hs(1)
CASE ELSE
PRINT
END SELECT
COLOR 7
IF cheats = true THEN COLOR 12: PRINT "CHEATER!": COLOR 7:  ELSE PRINT
FOR q = 1 TO tt
NEXT q
IF fader = 1 THEN
        IF rf = 2 THEN fader = 0: PALETTE
        rf = rf - 2
        PALETTE 4, fnfnr(rf, 0, 0)
END IF
IF fadeg = 1 THEN
        IF gf = 2 THEN fadeg = 0: PALETTE
        gf = gf - 2
        PALETTE 2, fnfnr(0, gf, 0)
END IF
LOOP
crashed:
COLOR 4
LOCATE 10, 35
PRINT "BOOM!"
FOR q = 1 TO 50
sx = INT(RND * 50) + x - 20
sy = INT(RND * 50) + y - 20
CIRCLE (sx, sy), 5, 12
PAINT (sx, sy), 12
SOUND 1000, .1
FOR p = 1 TO 1000
NEXT p
NEXT q
COLOR 7
IF score > hs(10) AND cheats = false THEN
        INPUT "Name?", n$
        hs(10) = score
        nam$(10) = n$
        DO
        FOR q = 1 TO 9
        IF hs(q) < hs(q + 1) THEN SWAP hs(q), hs(q + 1): SWAP nam$(q), nam$(q + 1): op = op + 1
        NEXT q
        IF op = 0 THEN EXIT DO
        op = 0
        LOOP
        OPEN "highsc.enu" FOR RANDOM AS #1
        FOR q = 1 TO 10
        daten.score = hs(q)
        daten.nam = nam$(q)
        PUT 1, q, daten
        NEXT q
        CLOSE #1
END IF
FOR q = 1 TO 10
LOCATE q, 21
PRINT nam$(q) + SPACE$(20 - LEN(nam$(q))), hs(q)
NEXT q
DO
LOOP WHILE INKEY$ = ""
END
eabf:
IF ERR = 210 THEN
        PRINT "Generiere neue Highscore Datei..."
        FOR q = 1 TO 10
        daten.score = 11 - q
        daten.nam = "ENEMU"
        PUT 1, q, daten
        NEXT q
        CLOSE #1
        RESUME agn
END IF
LOCATE 1, 1
PRINT ERR, ERL, exterr(2)
STOP
RESUME

