'$INCLUDE: 'ENEMU2.BI'

'Enemu V 2.4
'(C)2003-2004 by Alexander Weld
'2003/9/21      Started Programming
'2003/9/21      Finished V2.0
'2003/9/24      Started Programming for V 2.1
'2003/10/29     Started/Finished Programming for V 2.1.5
'2003/10/31     Started Programming for V 2.2
'Some additions for V 2.3:
' - Sinus Modifier
' - Shoot Position V 4 (2003/12/17)
' - Wormhole (2003/12/30)
' - "Level Completed!" (2003/12/30)
' - Other Level-completing conditions (2003/12/30)
' - Rechanged Level-completing conditions (2003/12/31)
' - Added Difficulty-Levels (2003/12/31)
'Additions for 2.4:
' - Particles (2004/02/29)
' - 5 Heat Seekers (2004/02/29)
'Now I must go to the cinema
' - Detail-Levels (2004/03/09)
' - Ship-Particles are money (2004/03/09)
' - Global Points/Money (2004/03/21)
' - Added Reflection Shield (2004/05/12)
' - Changed Shot Size (2004/05/12)
' - Include File (2004/05/31)
' - Removed enemu2.dat (->Include) (2004/05/31)
' - Laser Mod (2004/05/31)
' - Easter Egg (2004/05/31)
ON KEY(1) GOSUB sht
ON KEY(3) GOSUB cht
ON KEY(5) GOSUB tfr
ON KEY(6) GOSUB sfps
ON KEY(7) GOSUB mte
ON KEY(9) GOSUB pse
ON KEY(10) GOSUB mind
ON KEY(30) GOSUB medd
ON KEY(31) GOSUB maxd
ON TIMER(1) GOSUB tim
KEY(1) ON
KEY(3) ON
KEY(5) ON
KEY(6) ON
KEY(7) ON
KEY(9) ON
KEY(10) ON
KEY(30) ON
KEY(31) ON
TIMER ON

CLS
RANDOMIZE TIMER
SCREEN 7, , 0, 1
OPEN "highsc.dat" FOR RANDOM AS #1
FOR q = 1 TO 10
GET #1, q, hs(q)
NEXT q
CLOSE #1


DEF SEG = VARSEG(blokg(1))
BLOAD "blokg.gra", VARPTR(blokg(1))
DEF SEG
DEF SEG = VARSEG(blokr(1))
BLOAD "blokr.gra", VARPTR(blokr(1))
DEF SEG
DEF SEG = VARSEG(blokt(1))
BLOAD "blokt.gra", VARPTR(blokt(1))
DEF SEG
DEF SEG = VARSEG(bloky(1))
BLOAD "bloky.gra", VARPTR(bloky(1))
DEF SEG
DEF SEG = VARSEG(lrck(1))
BLOAD "lrck.gra", VARPTR(lrck(1))
DEF SEG
DEF SEG = VARSEG(eboss(1))
BLOAD "eboss.gra", VARPTR(eboss(1))
DEF SEG
DEF SEG = VARSEG(ship(1))
BLOAD "ship.gra", VARPTR(ship(1))
DEF SEG


IF COMMAND$ <> "" THEN
 comm$ = LCASE$(COMMAND$)
 IF INSTR(comm$, "--2players") THEN toggle tply
 IF INSTR(comm$, "--help") THEN ShowHelp: END
 IF INSTR(comm$, "--easy") THEN diff = 1
 IF INSTR(comm$, "--medi") THEN diff = 2
 IF INSTR(comm$, "--hard") THEN diff = 3
 IF INSTR(comm$, "--sstars") THEN toggle sstars
 IF INSTR(comm$, "--shsmd") THEN toggle shsmd

 IF INSTR(comm$, "--save") THEN
  a = INSTR(comm$, "--save")
  a = a + 6
  b = INSTR(a, comm$, ".esv")
  b = b - 1
  sv$ = MID$(comm$, a, b)
  IF b = 0 THEN PRINT "Error: No .esv found or no savegame given!": sv$ = ""
  IF sv$ <> "" THEN
   OPEN sv$ FOR RANDOM AS #1
   GET #1, 1, save
   GET #1, 2, e
   FOR q = 0 TO 7
    GET #1, q + 3, modi(q).s
   NEXT q
   GET #1, 10, diff
   CLOSE #1
   money = save.s
   ops = save.sz
   lv = save.lv
   IF lv = 0 THEN lv = 1
  END IF
 END IF
END IF
IF diff = 0 THEN diff = 1
sts = 120 * diff
start:
Text lv
t1 = TIMER
mt = TIMER
spt = TIMER
DO
a$ = RIGHT$(INKEY$, 1)
SELECT CASE a$
CASE "K"
GetOffset s.c, so.lo, xx, yy
IF xx - 5 > srl THEN s.c.x = s.c.x - 5 ELSE s.c.x = 81
CASE "M"
GetOffset s.c, so.ro, xx, yy
IF xx + 5 < srr THEN s.c.x = s.c.x + 5 ELSE s.c.x = 200
CASE CHR$(13)
 IF mb = false AND e.mb > 0 THEN mb = true: e.mb = e.mb - 1
CASE CHR$(27)
GOTO nd
CASE "+"
FOR mq = 0 TO 7
IF modi(mq).s > 0 AND mq > sm THEN sm = mq: EXIT FOR
NEXT mq
CASE "-"
FOR mq = 7 TO 0 STEP -1
IF modi(mq).s > 0 AND mq < sm THEN sm = mq: EXIT FOR
NEXT mq
CASE "c"
lrt = TIMER
DO
htgt = htgt + 1
tkr = 20
IF htgt > 10 THEN htgt = 0
LOOP UNTIL b(htgt).x = true OR TIMER - lrt >= 1
CASE "y"
lrt = TIMER
DO
htgt = htgt - 1
tkr = 20
IF htgt < 0 THEN htgt = 10
LOOP UNTIL b(htgt).x = true OR TIMER - lrt >= 1
CASE "x"
 FOR q = 0 TO 4
  IF has(q).x = false THEN nr = q: EXIT FOR
  nr = -1
 NEXT q
 IF nr > -1 THEN
  has(nr).tgt = htgt
  has(nr).x = true
  IF has(nr).tgt >= 0 THEN
   GetOffset s.c, so.uo, sux, suy
   has(nr).c.x = sux
   has(nr).c.y = suy
   e.ms = e.ms - 1
   has(nr).x = true
  END IF
 END IF
CASE " "
GOSUB shoot
END SELECT

IF shb = false THEN
 SELECT CASE true
 CASE e.uf
 shfq = 0
 CASE e.f
 shfq = .1
 CASE ELSE
 shfq = .2
 END SELECT
 IF TIMER - sht >= shfq THEN shb = true
END IF

IF boss THEN
 IF TIMER - brt >= 1 / lv THEN
  FOR q = 0 TO 10
   IF b(q).x = false THEN nr = q: EXIT FOR
   nr = -1
  NEXT q
  IF nr > -1 THEN
   IF mte = false THEN PLAY "<mbl64ded>"
   b(nr).x = true
   b(nr).c.x = INT(RND * 80 + 100)
   b(nr).c.y = 51
   IF lv >= 10 THEN
    b(nr).lv = INT(RND * 4 + 1)
    IF b(nr).lv = 4 THEN b(nr).gt = INT(RND * 2)
   ELSEIF lv >= 8 THEN
    b(nr).lv = INT(RND * 3 + 1)
   ELSEIF lv >= 4 THEN
    b(nr).lv = INT(RND * 2 + 1)
   ELSE b(nr).lv = 1
   END IF
  END IF
  brt = TIMER
 END IF
END IF
IF INT(RND * 10) = 0 AND boss = false THEN
 FOR q = 0 TO 10
  IF b(q).x = false THEN nr = q: EXIT FOR
  nr = -1
 NEXT q
 IF nr > -1 THEN
  b(nr).x = true
  b(nr).c.x = INT(RND * 125 + 81)
  b(nr).c.y = 1
  IF lv >= 10 THEN
   b(nr).lv = INT(RND * 4 + 1)
   IF b(nr).lv = 4 THEN b(nr).gt = INT(RND * 2)
  ELSEIF lv >= 8 THEN
   b(nr).lv = INT(RND * 3 + 1)
  ELSEIF lv >= 4 THEN
   b(nr).lv = INT(RND * 2 + 1)
  ELSE b(nr).lv = 1
  END IF

  IF lv >= 12 THEN
   IF INT(RND * 10) = 0 THEN b(nr).ps = INT(RND * 3 + 1)
  END IF

 END IF
END IF
IF mb THEN
 SCREEN 7, , 1, 1
 GetOffset s.c, so.uo, sux, suy
 FOR q = 0 TO 50
  IF sh(q).x THEN
   LINE (sux, suy)-(sh(q).c.x, sh(q).c.y), 4
   sh(q).x = false
   pause .01
  END IF
 NEXT q
 FOR q = 0 TO 10
   IF b(q).x THEN
    GetOffset b(q).c, bo.mo, bmx, bmy
    LINE (sux, suy)-(bmx, bmy), 4
    b(q).x = false
    money = money + 50
    pause .01
   END IF
 NEXT q
 mb = false
 SCREEN 7, , 0, 1
END IF

IF sm = 1 THEN
 GetOffset s.c, so.uo, smx, smy
 GetOffset s.c, so.lo, slx, sly
 GetOffset s.c, so.ro, srx, sry
 FOR q = 31 TO 50
  IF sh(q).x THEN
   IF sh(q).c.x >= slx AND sh(q).c.x <= smx THEN
    IF srx + 1 >= srr THEN
     s.c.x = s.c.x - 1
    ELSE
     s.c.x = s.c.x + 1
    END IF
   ELSEIF sh(q).c.x >= smx AND sh(q).c.x <= srx THEN
    IF slx - 1 <= srl THEN
     s.c.x = s.c.x + 1
    ELSE
     s.c.x = s.c.x - 1
    END IF
   END IF
  END IF
 NEXT q
END IF
IF sm = 5 THEN
 FOR q = 31 TO 50
  IF sh(q).x THEN
   GetOffset s.c, so.mo, ecx, ecy
   ec.x = ecx
   ec.y = ecy
   d = dst(sh(q).c, ec)
   SELECT CASE modi(sm).s
   CASE 1
    IF d <= 20 AND (1 AND pltime) = 0 THEN CIRCLE (sh(q).c.x, sh(q).c.y + 2), 2, 4
   CASE 2
    IF d <= 50 AND (1 AND pltime) = 0 THEN CIRCLE (sh(q).c.x, sh(q).c.y + 2), 2, 4
   CASE 3
    IF d <= 50 THEN CIRCLE (sh(q).c.x, sh(q).c.y + 2), 2, 4
   END SELECT
  END IF
 NEXT q
END IF

'Grafik:

IF shsmd THEN
 MovePart hsmp(), 200
END IF
IF sdst THEN
 MovePart dstp(), 100
 money = money + CollPart(dstp(), 100, s, so)
END IF
IF sm = 4 THEN
 SELECT CASE modi(sm).s
 CASE 1
  GetOffset s.c, so.uo, sux, suy
  PSET (sux, 1), 4
 CASE 2
  GetOffset s.c, so.lo, slx, sly
  GetOffset s.c, so.ro, srx, sry
  PSET (slx, 1), 4
  PSET (srx, 1), 4
 CASE 3
  GetOffset s.c, so.lo, slx, sly
  GetOffset s.c, so.ro, srx, sry
  GetOffset s.c, so.uo, sux, suy
  PSET (slx, 1), 4
  PSET (srx, 1), 4
  PSET (sux, 1), 4
 CASE 4
  GetOffset s.c, so.lo, slx, sly
  GetOffset s.c, so.ro, srx, sry
  GetOffset s.c, so.uo, sux, suy
  PSET (slx, 1), 4
  PSET (srx, 1), 4
  PSET (sux, 1), 4
 END SELECT
END IF

IF boss THEN
 PUT (eb.c.x, eb.c.y), eboss
END IF
IF sstars THEN
 FOR q = 0 TO 10
  IF stars(q).x = false AND INT(RND * 15) = 0 THEN
   stars(q).x = true
   stars(q).c.x = INT(RND * 135 + 81)
   stars(q).c.y = 0
   stars(q).v = INT(RND * 3 + 2)
  ELSE
   stars(q).c.y = stars(q).c.y + stars(q).v
   IF sm = 6 THEN
    PSET (stars(q).c.x + (SIN(stars(q).c.y / 10)), stars(q).c.y), 7
   ELSE
    PSET (stars(q).c.x, stars(q).c.y), 7
   END IF
   IF stars(q).c.y >= 240 THEN stars(q).x = false
  END IF
 NEXT q
END IF
LINE (srl, 0)-(srl, 240)
LINE (srr, 0)-(srr, 240)

IF e.ms > 0 THEN
 GetOffset b(htgt).c, bo.mo, bmx, bmy
 CIRCLE (bmx, bmy), tkr, 13
END IF

IF tkr > 10 THEN tkr = tkr - 2
FOR qh = 0 TO 4
IF has(qh).x THEN
 tgt = has(qh).tgt
 GetOffset has(qh).c, lo.mo, lmx, lmy
 IF shsmd THEN
  IF 3 AND lmy THEN ReleaseParticles hsmp(), lmx, lmy, 1, 4, 4, 2, 5, 2, 200
  IF 1 AND lmy THEN ReleaseParticles hsmp(), lmx, lmy, 1, 14, 14, 3, 6, 2, 200
 END IF
 FOR q = 0 TO 10
  IF b(q).x THEN
   GetOffset has(qh).c, lo.uo, lux, luy
   ec.x = lux: ec.y = luy
   c = coll(ec, b(q).c, bo)
   IF c THEN
    has(qh).x = false
    hx = has(qh).c.x
    hy = has(qh).c.y
    IF sdst THEN
     ReleaseParticles dstp(), hx, hy, 2, 12, 12, 3, 6, 10, 100
     ReleaseParticles dstp(), hx, hy, 2, 14, 14, 3, 6, 10, 100
     ReleaseParticles dstp(), hx, hy, 2, 3, 3, 3, 6, 10, 100
    END IF
    IF b(q).ps > 0 THEN
     b(q).ps = b(q).ps - 3
     IF mte = false THEN SOUND 1000, .1
    ELSE
     IF b(q).lv = 4 THEN
      b(q).x = false:  money = money + 50
     ELSE
      b(q).lv = b(q).lv - 2: money = money + 10
      IF b(q).lv <= 0 THEN b(q).x = false: money = money + 50
     END IF
     IF mte = false THEN PLAY "mbl64dcd"
    END IF
   END IF
  END IF
 NEXT q
 GetOffset b(tgt).c, bo.mo, bmx, bmy
 gtx = SGN(bmx - lux)
 gty = SGN(bmy - luy)
 has(qh).c.x = has(qh).c.x + gtx
 has(qh).c.y = has(qh).c.y + gty
 PUT (has(qh).c.x, has(qh).c.y), lrck
END IF
NEXT qh

'Shots

FOR q = 0 TO 50
IF sh(q).x THEN
 IF sh(q).e THEN
  sh(q).c.y = sh(q).c.y + sh(q).v
  c = coll(sh(q).c, s.c, so)
  IF c THEN
   sh(q).x = false
   IF mte = false THEN PLAY "mbl64ede"
   IF e.ps > 0 THEN
    e.ps = e.ps - sh(q).az
    IF mte = false THEN SOUND 1000, .1
    IF e.rs THEN
     sh(q).x = true
     sh(q).e = 0
    END IF
   ELSE
    GOSUB lost
   END IF
  END IF
  IF sh(q).c.y >= ur THEN sh(q).x = false
 ELSE
  sh(q).c.y = sh(q).c.y - sh(q).v
  IF sm = 6 THEN
   sh(q).c.x = sh(q).c.x + SIN(sh(q).c.y / 10) * modi(sm).s
   IF sh(q).c.x <= srl THEN sh(q).c.x = srl + 1
   IF sh(q).c.x >= srr THEN sh(q).c.x = srr - 1
  END IF
  FOR qq = 0 TO 10
   IF b(qq).x THEN
    c = coll(sh(q).c, b(qq).c, bo)
    IF c THEN
     sh(q).x = false
     sx = sh(q).c.x
     sy = sh(q).c.y
     IF b(qq).ps > 0 THEN
      b(qq).ps = b(qq).ps - sh(q).az
      IF mte = false THEN SOUND 1000, .1
     ELSE
      IF b(qq).lv = 4 THEN
       b(qq).x = false
       money = money + 50
      ELSE
       b(qq).lv = b(qq).lv - sh(q).az
       money = money + 10
       IF b(qq).lv <= 0 THEN b(qq).x = false: money = money + 50
      END IF
      IF sdst THEN
       ReleaseParticles dstp(), sx, sy, 2, 12, 12, 3, 6, 10, 100
       ReleaseParticles dstp(), sx, sy, 2, 14, 14, 3, 6, 10, 100
       ReleaseParticles dstp(), sx, sy, 2, 3, 3, 3, 6, 10, 100
      END IF

     END IF
     IF mte = false THEN PLAY "mbl64dcd"
     EXIT FOR
    END IF
   END IF
  NEXT qq
  IF boss = true THEN
   c = coll(sh(q).c, eb.c, eo)
   IF c THEN
    sh(q).x = false
    eb.l = eb.l - sh(q).az
    IF eb.l <= 0 THEN
     boss = false
     IF mte = false THEN PLAY "l16 >c<c>c<c>c<c>c<c"
     money = money + 500
     s.c.x = 150
     FOR y = s.c.y TO 1 STEP -4
      LOCATE 12, 10
      PRINT (LEFT$("Level Completed!  ", ((s.c.y - y) / 4) / ((s.c.y / 4) / 18)))
      PUT (s.c.x, y), ship
      pause .05
      PCOPY 0, 1
      CLS
     NEXT y
     GOTO shop
    END IF
   END IF
  END IF
 END IF
 clr = sh(q).cl
 CIRCLE (sh(q).c.x, sh(q).c.y), 1, clr
 IF sh(q).c.y <= 0 THEN sh(q).x = false
END IF
NEXT q

FOR q = 0 TO 10
IF b(q).x THEN
 b(q).c.y = b(q).c.y + 1
 SELECT CASE b(q).lv
 CASE 1
  PUT (b(q).c.x, b(q).c.y), blokg
 CASE 2
  PUT (b(q).c.x, b(q).c.y), bloky
 CASE 3
  PUT (b(q).c.x, b(q).c.y), blokr
 CASE 4
  PUT (b(q).c.x, b(q).c.y), blokt
 END SELECT
 IF sm = 4 AND modi(sm).s = 4 THEN
  GetOffset b(q).c, bo.lo, blx, bly
  GetOffset b(q).c, bo.ro, brx, bry
  GetOffset b(q).c, bo.mo, bmx, bmy
  GetOffset s.c, so.lo, slx, sly
  GetOffset s.c, so.ro, srx, sry
  GetOffset s.c, so.uo, sux, suy
  SELECT CASE true
  CASE e.ts
   IF slx >= blx AND slx <= brx THEN
    CIRCLE (bmx, bmy), 6, 3
    LINE (slx, sly)-(slx, bmy), 3
   ELSEIF sux >= blx AND sux <= brx THEN
    CIRCLE (bmx, bmy), 6, 3
    LINE (sux, suy)-(sux, bmy), 3
   ELSEIF srx >= blx AND srx <= brx THEN
    CIRCLE (bmx, bmy), 6, 3
    LINE (srx, sry)-(srx, bmy), 3
   END IF
  CASE e.ds
   IF slx >= blx AND slx <= brx THEN
    CIRCLE (bmx, bmy), 6, 3
    LINE (slx, sly)-(slx, bmy), 3
   ELSEIF srx >= blx AND srx <= brx THEN
    CIRCLE (bmx, bmy), 6, 3
    LINE (srx, sry)-(srx, bmy), 3
   END IF
  CASE ELSE
   IF sux >= blx AND sux <= brx THEN CIRCLE (bmx, bmy), 6, 3: LINE (sux, suy)-(sux, bmy), 3
  END SELECT
 END IF
 IF b(q).lv = 4 THEN
  GetOffset b(q).c, bo.uo, bux, buy
  GetOffset b(q).c, bo.lo, blx, bly
  GetOffset b(q).c, bo.ro, brx, bry
  FOR ap = 0 TO 30
   IF sh(ap).x THEN
    IF sh(ap).c.x >= blx AND sh(ap).c.x <= bux THEN
     IF brx + 1 >= srr THEN
      b(q).c.x = b(q).c.x - 1
     ELSE
      b(q).c.x = b(q).c.x + 1
     END IF
    ELSEIF sh(ap).c.x >= bux AND sh(ap).c.x <= brx THEN
     IF blx - 1 <= srl THEN
      b(q).c.x = b(q).c.x + 1
     ELSE
      b(q).c.x = b(q).c.x - 1
     END IF
    END IF
   END IF
  NEXT ap
 END IF
 IF b(q).ps > 0 THEN
  GetOffset b(q).c, bo.mo, bmx, bmy
  IF b(q).ps > 0 THEN CIRCLE (bmx, bmy), 8, 4
  IF b(q).ps > 1 THEN CIRCLE (bmx, bmy), 9, 4
  IF b(q).ps > 2 THEN CIRCLE (bmx, bmy), 10, 4
 END IF
 IF INT(RND * 25) = 0 THEN
  SELECT CASE b(q).lv
  CASE 1
  FOR qq = 31 TO 40
   IF sh(qq).x = false THEN nr = qq: EXIT FOR
   nr = -1
  NEXT qq
  IF nr > -1 THEN
  sh(nr).x = true
  sh(nr).e = true
  sh(nr).cl = 10
  sh(nr).v = 2
  GetOffset b(q).c, bo.uo, bx, by
  sh(nr).az = b(q).lv
  sh(nr).c.x = bx
  sh(nr).c.y = by + 1
  END IF
  CASE 2
  FOR qq = 31 TO 50
   IF sh(qq).x = false THEN nr = qq: EXIT FOR
   nr = -1
  NEXT qq
  IF nr > -1 THEN
  sh(nr).x = true
  sh(nr).e = true
  sh(nr).cl = 14
  sh(nr).v = 2
  GetOffset b(q).c, bo.lo, bx, by
  sh(nr).c.x = bx
  sh(nr).c.y = by + 1
  END IF
  FOR qq = 31 TO 50
   IF sh(qq).x = false THEN nr = qq: EXIT FOR
   nr = -1
  NEXT qq
  IF nr > -1 THEN
  sh(nr).x = true
  sh(nr).e = true
  sh(nr).cl = 14
  sh(nr).v = 2
  GetOffset b(q).c, bo.ro, bx, by
  sh(nr).c.x = bx
  sh(nr).c.y = by + 1
  END IF
  CASE 3
  FOR qq = 31 TO 50
   IF sh(qq).x = false THEN nr = qq: EXIT FOR
   nr = -1
  NEXT qq
  IF nr > -1 THEN
  sh(nr).x = true
  sh(nr).e = true
  sh(nr).cl = 12
  sh(nr).v = 3
  GetOffset b(q).c, bo.lo, bx, by
  sh(nr).c.x = bx
  sh(nr).c.y = by + 1
  END IF
  FOR qq = 31 TO 50
   IF sh(qq).x = false THEN nr = qq: EXIT FOR
   nr = -1
  NEXT qq
  IF nr > -1 THEN
  sh(nr).x = true
  sh(nr).e = true
  sh(nr).cl = 12
  sh(nr).v = 3
  GetOffset b(q).c, bo.ro, bx, by
  sh(nr).c.x = bx
  sh(nr).c.y = by + 1
  END IF
  CASE 4
  FOR qq = 31 TO 40
   IF sh(qq).x = false THEN nr = qq: EXIT FOR
   nr = -1
  NEXT qq
  IF nr > -1 THEN
  sh(nr).x = true
  sh(nr).e = true
  sh(nr).cl = 11
  sh(nr).v = 2
  GetOffset b(q).c, bo.uo, bx, by
  sh(nr).az = b(q).lv
  sh(nr).c.x = bx
  sh(nr).c.y = by + 1
  END IF
  END SELECT
   IF mte = false AND nr > -1 THEN PLAY "mbl64ded"
 END IF
 IF b(q).c.y + bo.lo.y >= ur - 3 THEN
  IF b(q).c.y + bo.lo.y >= ur THEN b(q).x = false
  GetOffset b(q).c, bo.mo, bmx, bmy
  GetOffset s.c, so.lo, slx, sly
  GetOffset s.c, so.ro, srx, sry
  IF bmx >= slx AND bmx <= srx THEN
   GOSUB lost
  END IF
 END IF
END IF
NEXT q
DrawShip s
IF e.ps > 0 THEN
 GetOffset s.c, so.mo, smx, smy
 IF e.ps >= 2 THEN CIRCLE (smx, smy), 10, 1 ELSE CIRCLE (smx, smy), 10, 1 AND pltime
 IF e.ps > 2 THEN CIRCLE (smx, smy), 11, 1
 IF e.ps > 5 THEN CIRCLE (smx, smy), 12, 1
 IF e.ps > 7 THEN CIRCLE (smx, smy), 13, 1
END IF

'status

LOCATE 1
PRINT "Lives:"
PRINT e.l
IF money >= hs(10).s AND money <= hs(1).s THEN
 COLOR 2
 PRINT "Score:"
 PRINT money
 COLOR 15
ELSEIF money >= hs(1).s THEN
 COLOR 1
 PRINT "Score:"
 PRINT money
 COLOR 15
ELSE
 PRINT "Score:"
 PRINT money
END IF
PRINT "Level:"
PRINT lv
PRINT "Playtime:"
PRINT pltime
PRINT "Next L.:"
PRINT sts
IF boss THEN
 PRINT "Boss:"
 PRINT eb.l
 ShowBossEnergy lv * 5 * diff, eb.l
END IF
IF sfps THEN
 PRINT "FPS:"; shfps
 fps = fps + 1
 IF TIMER - mt >= 1 THEN shfps = fps: mt = TIMER: fps = 0
END IF
IF mte THEN PRINT "Mute"
psx = INT((srr + 100) * xpts)
LOCATE 1, psx
PRINT "Extras:"
FOR q = 0 TO 7
 LOCATE q + 2, psx
 IF sm = q THEN PRINT ">";  ELSE PRINT " ";
 PRINT modi(q).n; modi(q).s;
NEXT q
zle = CSRLIN
IF e.mb > 0 THEN
 LOCATE zle + 1, psx
 PRINT "Bombs:"; e.mb
END IF

IF e.ps > 0 THEN
 LOCATE zle + 2, psx
 IF e.rs THEN COLOR 2 ELSE COLOR 1
 PRINT "Shield:"; e.ps
 COLOR 15
END IF

IF e.ms > 0 THEN
 LOCATE zle + 3, psx
 PRINT "Missile:"; e.ms
END IF
IF sm = 7 THEN
 LOCATE zle + 4, psx
 PRINT "Laser:"; lrl
END IF
IF TIMER - spt >= 1 AND boss = false THEN
 sts = sts - 1
 IF sts <= 0 THEN
  FOR q = 0 TO 10
  b(q).x = false
  NEXT q
  FOR q = 0 TO 50
  sh(q).x = false
  NEXT q
  brt = TIMER
  boss = true
  eb.c.x = 100
  eb.c.y = 1
  eb.l = lv * 5 * diff
  IF mte = false THEN PLAY "l16 <c>c<c>c<c>c<c>c"
 END IF
 spt = TIMER
END IF
IF money / 2500 = INT(money / 2500) AND money <> 0 THEN
 IF mte = false THEN PLAY "mbl32ceg>c<"
 money = money + 1: e.l = e.l + 1
END IF

IF lrl > 0 THEN lrl = lrl - 1
DO
LOOP UNTIL TIMER - t1 >= .02 OR tf = false
t1 = TIMER
PCOPY 0, 1
CLS
LOOP
'subroutines

tfr:
toggle tf
RETURN
           
sfps:
toggle sfps
RETURN

mte:
toggle mte
RETURN

sht:
helptext
RETURN

mind:
 toggle sstars
 RETURN

medd:
 toggle shsmd
 RETURN

maxd:
 'toggle sdst
 RETURN

cht:
SCREEN 7, , 4, 4
CLS
DO
INPUT ">", cht$
SELECT CASE cht$
CASE "boss"
cht$ = ""
brt = TIMER
boss = true
eb.c.x = 100
eb.c.y = 1
eb.l = lv * 5 * diff
IF mte = false THEN PLAY "l16 <c>c<c>c<c>c<c>c"
PRINT "Warning boss is near!"
CASE "money"
cht$ = ""
money = money + 10000
PRINT "Money cheat +10000"
CASE "equip"
cht$ = ""
e.ms = 10
e.mb = 5
e.uf = true
e.ts = true
e.ps = 10
e.rs = true
FOR mc = 0 TO 7
 modi(mc).s = 3
NEXT mc
modi(4).s = 4
PRINT "Equipment cheat!"
CASE "live"
cht$ = ""
e.l = e.l + 1
PRINT "Added 1 life"
CASE "level"
cht$ = ""
INPUT "Level number"; lvnr
lv = lvnr
sts = 60 * diff
PRINT "Level cheat ("; lvnr; ")"
CASE "shop"
cht$ = ""
RETURN shop
CASE "exit"
cht$ = ""
EXIT DO
END SELECT
LOOP
SCREEN 7, , 0, 1
RETURN

'.........::::::::SHOOT:::::::::........

shoot:
 IF shb THEN
  IF sm = 7 THEN
  IF lrl = 0 THEN
   SELECT CASE modi(sm).s
   CASE 1
    GetOffset s.c, so.uo, sux, suy
    LINE (sux, suy)-(sux, 0), 1
    LINE (sux - 1, suy)-(sux - 1, 0), 9
    LINE (sux + 1, suy)-(sux + 1, 0), 9
    FOR q = 0 TO 10
     IF lcoll(sux, b(q).c, bo) THEN
      IF b(q).x THEN
       IF b(q).ps > 0 THEN
        b(q).ps = b(q).ps - 1
        IF mte = false THEN SOUND 1000, .1
       ELSE
        IF b(q).lv = 4 THEN
         b(q).x = false
         money = money + 50
        ELSE
         b(q).lv = b(q).lv - 1
         money = money + 10
         IF b(q).lv <= 0 THEN b(q).x = false: money = money + 50
        END IF
        GetOffset b(q).c, bo.mo, sx, sy
        IF sdst THEN
         ReleaseParticles dstp(), sx, sy, 2, 12, 12, 3, 6, 10, 100
         ReleaseParticles dstp(), sx, sy, 2, 14, 14, 3, 6, 10, 100
         ReleaseParticles dstp(), sx, sy, 2, 3, 3, 3, 6, 10, 100
        END IF
       END IF
       IF mte = false THEN PLAY "mbl64dcd"
      END IF
     END IF
    NEXT q
   CASE 2
    GetOffset s.c, so.ro, srx, sry
    GetOffset s.c, so.lo, slx, sly
    LINE (srx, sry)-(srx, 0), 1
    LINE (srx - 1, sry)-(srx - 1, 0), 9
    LINE (srx + 1, sry)-(srx + 1, 0), 9
    LINE (slx, sly)-(slx, 0), 1
    LINE (slx - 1, sly)-(slx - 1, 0), 9
    LINE (slx + 1, sly)-(slx + 1, 0), 9
    FOR q = 0 TO 10
     IF lcoll(srx, b(q).c, bo) OR lcoll(slx, b(q).c, bo) THEN
      IF b(q).x THEN
       IF b(q).ps > 0 THEN
        b(q).ps = b(q).ps - 1
        IF mte = false THEN SOUND 1000, .1
       ELSE
        IF b(q).lv = 4 THEN
         b(q).x = false
         money = money + 50
        ELSE
         b(q).lv = b(q).lv - 1
         money = money + 10
         IF b(q).lv <= 0 THEN b(q).x = false: money = money + 50
        END IF
        GetOffset b(q).c, bo.mo, sx, sy
        IF sdst THEN
         ReleaseParticles dstp(), sx, sy, 2, 12, 12, 3, 6, 10, 100
         ReleaseParticles dstp(), sx, sy, 2, 14, 14, 3, 6, 10, 100
         ReleaseParticles dstp(), sx, sy, 2, 3, 3, 3, 6, 10, 100
        END IF
       END IF
       IF mte = false THEN PLAY "mbl64dcd"
      END IF
     END IF
    NEXT q
   CASE 3
    GetOffset s.c, so.uo, sux, suy
    GetOffset s.c, so.lo, slx, sly
    GetOffset s.c, so.ro, srx, sry
    LINE (sux, suy)-(sux, 0), 1
    LINE (sux - 1, suy)-(sux - 1, 0), 9
    LINE (sux + 1, suy)-(sux + 1, 0), 9
    LINE (slx, sly)-(slx, 0), 1
    LINE (slx - 1, sly)-(slx - 1, 0), 9
    LINE (slx + 1, sly)-(slx + 1, 0), 9
    LINE (srx, sry)-(srx, 0), 1
    LINE (srx - 1, sry)-(srx - 1, 0), 9
    LINE (srx + 1, sry)-(srx + 1, 0), 9
    FOR q = 0 TO 10
     IF lcoll(sux, b(q).c, bo) OR lcoll(slx, b(q).c, bo) OR lcoll(srx, b(q).c, bo) THEN
      IF b(q).x THEN
       IF b(q).ps > 0 THEN
        b(q).ps = b(q).ps - 1
        IF mte = false THEN SOUND 1000, .1
       ELSE
        IF b(q).lv = 4 THEN
         b(q).x = false
         money = money + 50
        ELSE
         b(q).lv = b(q).lv - 1
         money = money + 10
         IF b(q).lv <= 0 THEN b(q).x = false: money = money + 50
        END IF
        GetOffset b(q).c, bo.mo, sx, sy
        IF sdst THEN
         ReleaseParticles dstp(), sx, sy, 2, 12, 12, 3, 6, 10, 100
         ReleaseParticles dstp(), sx, sy, 2, 14, 14, 3, 6, 10, 100
         ReleaseParticles dstp(), sx, sy, 2, 3, 3, 3, 6, 10, 100
        END IF
       END IF
       IF mte = false THEN PLAY "mbl64dcd"
      END IF
     END IF
    NEXT q
   END SELECT
  lrl = 10
  END IF
  ELSE
  SELECT CASE true
  CASE e.ds
   FOR q = 0 TO 20
    IF sh(q).x = false THEN nr = q: EXIT FOR
    nr = -1
   NEXT q
   IF nr >= 0 THEN
    sh(nr).x = NOT sh(nr).x
    GetOffset s.c, so.lo, ssx, ssy
    sh(nr).c.x = ssx
    sh(nr).c.y = ssy - 1
    sh(nr).e = false
    IF sm = 3 THEN
     SELECT CASE modi(sm).s
     CASE 1, 2
      sh(nr).cl = 14
      sh(nr).az = 2
     CASE 3
      sh(nr).cl = 12
      sh(nr).az = 3
     END SELECT
    ELSE
     sh(nr).cl = 9
     sh(nr).az = 1
    END IF
    IF sm = 2 THEN sh(nr).v = 3 ELSE sh(nr).v = 2
    ssx = 0
    ssy = 0
   END IF
   FOR q = 0 TO 20
    IF sh(q).x = false THEN nr = q: EXIT FOR
    nr = -1
   NEXT q
   IF nr >= 0 THEN
    sh(nr).x = NOT sh(nr).x
    GetOffset s.c, so.ro, ssx, ssy
    sh(nr).c.x = ssx
    sh(nr).c.y = ssy - 1
    sh(nr).e = false
    IF sm = 3 THEN
     SELECT CASE modi(sm).s
     CASE 1
      sh(nr).cl = 10
      sh(nr).az = 1
     CASE 2, 3
      sh(nr).cl = 14
      sh(nr).az = 2
     END SELECT
    ELSE
     sh(nr).cl = 9
     sh(nr).az = 1
    END IF
    IF sm = 2 AND modi(sm).s >= 2 THEN sh(nr).v = 3 ELSE sh(nr).v = 2
    ssx = 0
    ssy = 0
   END IF
  CASE e.ts
   FOR q = 0 TO 30
    IF sh(q).x = false THEN nr = q: EXIT FOR
    nr = -1
   NEXT q
   IF nr >= 0 THEN
    sh(nr).x = NOT sh(nr).x
    GetOffset s.c, so.lo, ssx, ssy
    sh(nr).c.x = ssx
    sh(nr).c.y = ssy - 1
    sh(nr).e = false
    IF sm = 3 THEN
     SELECT CASE modi(sm).s
     CASE 1
      sh(nr).cl = 10
      sh(nr).az = 1
     CASE 2, 3
      sh(nr).cl = 14
      sh(nr).az = 2
     END SELECT
    ELSE
     sh(nr).cl = 9
     sh(nr).az = 1
    END IF
    IF sm = 2 AND modi(sm).s >= 2 THEN sh(nr).v = 3 ELSE sh(nr).v = 2
    ssx = 0
    ssy = 0
   END IF
   FOR q = 0 TO 30
    IF sh(q).x = false THEN nr = q: EXIT FOR
    nr = -1
   NEXT q
   IF nr >= 0 THEN
    sh(nr).x = NOT sh(nr).x
    GetOffset s.c, so.ro, ssx, ssy
    sh(nr).c.x = ssx
    sh(nr).c.y = ssy - 1
    sh(nr).e = false
    IF sm = 3 THEN
     sh(nr).cl = 10
     sh(nr).az = 1
    ELSE
     sh(nr).cl = 9
     sh(nr).az = 1
    END IF
    IF sm = 2 AND modi(sm).s = 3 THEN sh(nr).v = 3 ELSE sh(nr).v = 2
    ssx = 0
    ssy = 0
   END IF
   FOR q = 0 TO 30
    IF sh(q).x = false THEN nr = q: EXIT FOR
    nr = -1
   NEXT q
   IF nr >= 0 THEN
    sh(nr).x = NOT sh(nr).x
    GetOffset s.c, so.uo, ssx, ssy
    sh(nr).c.x = ssx
    sh(nr).c.y = ssy - 1
    sh(nr).e = false
    sh(nr).cl = 9
    IF sm = 3 THEN
     SELECT CASE modi(sm).s
     CASE 1, 2
      sh(nr).cl = 14
      sh(nr).az = 2
     CASE 3
      sh(nr).cl = 12
      sh(nr).az = 3
     END SELECT
    ELSE
     sh(nr).cl = 9
     sh(nr).az = 1
    END IF
    IF sm = 2 THEN sh(nr).v = 3 ELSE sh(nr).v = 2
    ssx = 0
    ssy = 0
   END IF
  CASE ELSE
   FOR q = 0 TO 10
    IF sh(q).x = false THEN nr = q: EXIT FOR
    nr = -1
   NEXT q
   IF nr >= 0 THEN
    sh(nr).x = NOT sh(nr).x
    GetOffset s.c, so.uo, ssx, ssy
    sh(nr).c.x = ssx
    sh(nr).c.y = ssy - 1
    sh(nr).e = false
    IF sm = 3 THEN
     SELECT CASE modi(sm).s
     CASE 1
      sh(nr).cl = 14
      sh(nr).az = 2
     CASE 2, 3
      sh(nr).cl = 12
      sh(nr).az = 3
     END SELECT
    ELSE
     sh(nr).cl = 9
     sh(nr).az = 1
    END IF
    IF sm = 2 THEN
     SELECT CASE modi(sm).s
     CASE 1
      sh(nr).v = 3
     CASE 2, 3
      sh(nr).v = 4
     END SELECT
    ELSE
     sh(nr).v = 2
    END IF
    ssx = 0
    ssy = 0
   END IF
  END SELECT
 END IF
 IF nr > -1 AND mte = false THEN
  PLAY "mbl64cdc"
  shb = false
  sht = TIMER
 ELSEIF nr > -1 THEN
  shb = false
  sht = TIMER
 END IF
END IF
RETURN


pse:
SCREEN 7, , 5, 5
DO
COLOR INT(RND * 15 + 1)
PRINT "Enemu";
LOOP UNTIL INKEY$ <> ""
SCREEN 7, , 0, 1
RETURN

tim:
pltime = pltime + 1
RETURN

lost:
e.l = e.l - 1
IF mte = false THEN PLAY "mbl32>c<gec"
IF e.l = -1 THEN GOTO nd
boss = false
sts = sts + INT(sts / (4 - diff))
IF sts > (120 * diff) THEN sts = (120 * diff)
money = money - 500
IF money < 0 THEN money = 0
FOR q = 0 TO 10
b(q).x = false
NEXT q
FOR q = 0 TO 50
sh(q).x = false
NEXT q
ClearParticles hsmp(), 200
ClearParticles dstp(), 100
RETURN start


shop:
SCREEN 7, , 2, 2
DO
CLS
PRINT "Welcome to the Shop!"
PRINT "Money:"; money; "$"
PRINT "Buy:"
PRINT " 1 : MG Updates"
PRINT " 2 : Shoot count update"
PRINT " 3 : Extra systems"
PRINT " 4 : Other things"
PRINT " 5 : Exit"
COLOR msgc
PRINT msg$
COLOR 15
aw$ = INPUT$(1)
SELECT CASE aw$
CASE "1"
PRINT " 1 : Fast MG / 1000"
PRINT " 2 : Ultra Fast MG / 4000"
PRINT " 3 : Exit"
uaw$ = INPUT$(1)
SELECT CASE uaw$
CASE "1"
IF e.f THEN
 msgc = 4
 msg$ = "You already have this one!"
ELSEIF money < 1000 THEN
 msgc = 4
 msg$ = "Not enough money!"
ELSE e.f = true
 money = money - 1000
 msgc = 1
 msg$ = "Bought Fast MG"
END IF
CASE "2"
IF e.uf THEN
 msgc = 4
 msg$ = "You already have this one!"
ELSEIF money < 4000 THEN
 msgc = 4
 msg$ = "Not enough money!"
ELSE e.uf = true
 money = money - 4000
 msgc = 1
 msg$ = "Bought Ultra Fast MG"
END IF
END SELECT
CASE "2"
PRINT " 1 : Double Shoot / 2000"
PRINT " 2 : Triple Shoot / 6000"
PRINT " 3 : Back"
uaw$ = INPUT$(1)
SELECT CASE uaw$
CASE "1"
IF e.ds THEN
 msgc = 4
 msg$ = "You already have this one!"
ELSEIF money < 2000 THEN
 msgc = 4
 msg$ = "Not enough Money!"
ELSE e.ds = true
 money = money - 2000
 msgc = 1
 msg$ = "Bought Double Shoot"
END IF
CASE "2"
IF e.ts THEN
  msgc = 4
  msg$ = "You already have this one!"
 ELSEIF money < 6000 THEN
  msgc = 4
  msg$ = "Not enough Money!"
 ELSE e.ts = true
  money = money - 6000
  msgc = 1
  msg$ = "Bought Triple Shoot"
END IF
END SELECT
CASE "3"
PRINT " 1 : Shoot Position V"; modi(4).s + 1; "/ 1000"
PRINT " 2 : Shoot warn system V"; modi(5).s + 1; "/ 1000"
PRINT " 3 : Sinus Shoot V"; modi(6).s + 1; "/2000"
PRINT " 4 : Autopilot / 3000"
PRINT " 5 : Shoot Velocity V"; modi(2).s + 1; "/ 5000"
PRINT " 6 : Shoot Power V"; modi(3).s + 1; "/ 10000"
PRINT " 7 : Laser V"; modi(7).s + 1; "/ 20000"
PRINT " 8 : Back"
uaw$ = INPUT$(1)
SELECT CASE uaw$
CASE "1"
 IF modi(4).s = 4 THEN
  msgc = 4
  msg$ = "Highest Version!"
 ELSEIF money < 1000 THEN
  msgc = 4
  msg$ = "Not Enough Money!"
 ELSE
  money = money - 1000
  modi(4).s = modi(4).s + 1
  msgc = 1
  msg$ = "Bought Extra V" + STR$(modi(4).s) + ": Shoot Position"
 END IF
CASE "2"
 IF modi(5).s = 3 THEN
  msgc = 4
  msg$ = "Highest Version!"
 ELSEIF money < 1000 THEN
  msgc = 4
  msg$ = "Not Enough Money!"
 ELSE
  money = money - 1000
  modi(5).s = modi(5).s + 1
  msgc = 1
  msg$ = "Bought Extra V" + STR$(modi(5).s) + ": Shoot Warn System"
 END IF
CASE "3"
 IF modi(6).s = 3 THEN
  msgc = 4
  msg$ = "Highest Version!"
 ELSEIF money < 2000 THEN
  msgc = 4
  msg$ = "Not Enough Money!"
 ELSE
  money = money - 2000
  modi(6).s = modi(6).s + 1
  msgc = 1
  msg$ = "Bought Extra V" + STR$(modi(6).s) + ": Sinus Shoot"
 END IF
CASE "4"
 IF modi(1).s = 1 THEN
  msgc = 4
  msg$ = "You already have this one!"
 ELSEIF money < 3000 THEN
  msgc = 4
  msg$ = "Not Enough Money!"
 ELSE
  money = money - 3000
  modi(1).s = 1
  msgc = 1
  msg$ = "Bought Extra: Autopilot"
 END IF
CASE "5"
 IF modi(2).s = 3 THEN
  msgc = 4
  msg$ = "Highest Version!"
 ELSEIF money < 5000 THEN
  msgc = 4
  msg$ = "Not enough Money!"
 ELSE
  money = money - 5000
  modi(2).s = modi(2).s + 1
  msgc = 1
  msg$ = "Bought Extra V" + STR$(modi(2).s) + ": Shoot Velocity"
 END IF
CASE "6"
 IF modi(3).s = 3 THEN
  msgc = 4
  msg$ = "Highest Version!"
 ELSEIF money < 10000 THEN
  msgc = 4
  msg$ = "Not enough Money!"
 ELSE
  money = money - 10000
  modi(3).s = modi(3).s + 1
  msgc = 1
  msg$ = "Bought Extra V" + STR$(modi(3).s) + ": Shoot Power"
 END IF
CASE "7"
 IF modi(7).s = 3 THEN
  msgc = 4
  msg$ = "Highest Version!"
 ELSEIF money < 20000 THEN
  msgc = 4
  msg$ = "Not enough Money!"
 ELSE
  money = money - 20000
  modi(7).s = modi(7).s + 1
  msgc = 1
  msg$ = "Bought Extra V" + STR$(modi(7).s) + ": Laser"
 END IF
END SELECT
CASE "4"
PRINT " 1 : Save Game / 1000"
PRINT " 2 : Live / 2500"
PRINT " 3 : Protection Shield / 5000"
PRINT " 4 : Reflection Shield Upgrade / 7500"
PRINT " 5 : Heat Seeking Missiles / 1000"
PRINT " 6 : Mega Bomb / 8000"
PRINT " 7 : Back"
uaw$ = INPUT$(1)
SELECT CASE uaw$
CASE "1"
IF money < 1000 THEN
 msgc = 4
 msg$ = "Not enough Money!"
ELSE
 money = money - 1000
 INPUT "Name:", nn$
 save.n = nn$
 save.s = money
 save.sz = ops
 save.lv = lv + 1
 OPEN nn$ + ".esv" FOR RANDOM AS #1
  PUT #1, 1, save
  PUT #1, 2, e
  FOR q = 0 TO 6
   PUT #1, q + 3, modi(q).s
  NEXT q
  PUT #1, 10, diff
 CLOSE #1
 msgc = 1
 msg$ = "Saved Game!"
END IF
CASE "2"
IF money < 2500 THEN
 msgc = 4
 msg$ = "Not enough Money!"
ELSE e.l = e.l + 1
 money = money - 2500
 msgc = 1
 msg$ = "Bought 1 Live"
END IF
CASE "3"
IF money < 5000 THEN
 msgc = 4
 msg$ = "Not enough Money!"
ELSEIF e.ps = 10 THEN
 msgc = 4
 msg$ = "You already have this one!"
ELSE
 money = money - 5000
 e.ps = 10
 msgc = 1
 msg$ = "Bought Protection Shield"
END IF
CASE "4"
IF money < 7500 THEN
 msgc = 4
 msg$ = "Not enough Money!"
ELSEIF e.rs THEN
 msgc = 4
 msg$ = "You already have this one!"
ELSE
 money = money - 7500
 e.rs = true
 msgc = 1
 msg$ = "Bought Reflection Shield Upgrade"
END IF
CASE "5"
IF money < 1000 THEN
 msgc = 4
 msg$ = "Not enough Money!"
ELSEIF e.ms = 10 THEN
 msgc = 4
 msg$ = "You can't carry so much!"
ELSE
 money = money - 1000
 e.ms = e.ms + 1
 msgc = 1
 msg$ = "Bought 1 Heat Seeker"
END IF
CASE "6"
 IF money < 8000 THEN
  msgc = 4
  msg$ = "Not enough Money!"
 ELSEIF e.mb = 5 THEN
  msgc = 4
  msg$ = "You can't carry so much!"
 ELSE
  money = money - 8000
  e.mb = e.mb + 1
  msgc = 1
  msg$ = "Bought 1 Mega Bomb"
 END IF
END SELECT
CASE "5"
msg$ = ""
msgc = 0
EXIT DO
END SELECT
LOOP
sts = 120 * diff
lv = lv + 1
FOR q = 0 TO 10
b(q).x = false
NEXT q
FOR q = 0 TO 50
sh(q).x = false
NEXT q
SCREEN 7, , 0, 1
GOTO start

nd:
SCREEN 7, , 1, 1
IF money > hs(10).s THEN
hs(10).s = money
 CLS
 INPUT "Name:", nn$
 hs(10).n = nn$
 hs(10).m = money
 hs(10).sz = pltime
 hs(10).lv = lv
END IF
DO
 FOR q = 1 TO 9
  IF hs(q).s < hs(q + 1).s THEN SWAP hs(q), hs(q + 1): op = op + 1
 NEXT q
 IF op = 0 THEN EXIT DO
 op = 0
LOOP
OPEN "highsc.dat" FOR RANDOM AS #1
CLS
FOR q = 1 TO 10
COLOR q
PRINT hs(q).n; hs(q).s; hs(q).m; hs(q).sz; hs(q).lv
PUT #1, q, hs(q)
NEXT q
CLOSE #1
DO
LOOP UNTIL INKEY$ <> ""
END

SUB ClearParticles (p() AS particles, qt)
FOR q = 0 TO qt
 p(q).x = false
NEXT q
END SUB

FUNCTION coll (c AS coor, b AS coor, bo AS offsets)
GetOffset b, bo.lo, xl, yl
GetOffset b, bo.ro, xr, yr
GetOffset b, bo.uo, xu, yu
IF c.x >= xl AND c.x <= xr AND c.y <= yu AND c.y >= yu - 6 THEN coll = -1 ELSE coll = 0
END FUNCTION

FUNCTION CollPart (part() AS particles, n, s AS ship, so AS offsets)
mn = 0
FOR q = 0 TO n
 IF part(q).x THEN
  IF coll(part(q).c, s.c, so) THEN
   mn = mn + part(q).cl
   part(q).x = false
   IF mte = false THEN PLAY "c"
  END IF
  END IF
NEXT q
CollPart = mn
END FUNCTION

FUNCTION CountPart (p() AS particles, qt)
pc = 0
FOR q = 0 TO qt
IF p(q).x = true THEN pc = pc + 1
NEXT q
CountPart = pc
END FUNCTION

SUB DrawShip (s AS ship)

PUT (s.c.x, s.c.y), ship, PSET
END SUB

FUNCTION dst (c1 AS coor, c2 AS coor)
x1 = c1.x
x2 = c2.x
y1 = c1.y
y2 = c2.y
dst = SQR((ABS(x1 - x2) ^ 2) + (ABS(y1 - y2) ^ 2))
END FUNCTION

SUB GetOffset (ac AS coor, ost AS coor, x, y)
x = 0
y = 0
x = ac.x + ost.x
y = ac.y + ost.y
END SUB

SUB helptext
SCREEN 7, , 3, 3
CLS
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
PRINT "F5: Bremse aus/an"
PRINT "F6: FPS anzeigen"
PRINT "F7: Still"
PRINT "F9: Pause"
PRINT "ESC: Abbrechen(Highscores werden gespeichert!)"
DO
LOOP UNTIL INKEY$ <> ""
SCREEN 7, , 0, 1
END SUB

FUNCTION lcoll (x, b AS coor, bo AS offsets)
GetOffset b, bo.lo, xl, yl
GetOffset b, bo.ro, xr, yr
GetOffset b, bo.uo, xu, yu
IF x >= xl AND x <= xr THEN lcoll = -1 ELSE lcoll = 0
END FUNCTION

SUB MovePart (part() AS particles, qt)
FOR q = 0 TO qt
 IF part(q).x THEN
  part(q).c.y = part(q).c.y + part(q).v
  IF part(q).c.y >= 199 THEN part(q).x = false
  PSET (part(q).c.x, part(q).c.y), part(q).cl
 END IF
NEXT q
END SUB

SUB pause (wtm)
wt = TIMER
DO
LOOP UNTIL TIMER - wt >= wtm
END SUB

SUB ReleaseParticles (p() AS particles, x, y, q, cf, ct, vf, vt, r, pqt)
FOR qq = 1 TO q
 FOR cp = 0 TO pqt
  IF p(cp).x = 0 THEN nr = cp: EXIT FOR
  nr = -1
 NEXT cp
 IF nr > -1 THEN
  p(nr).x = true
  p(nr).v = INT(RND * (vt - vf) + vf)
  p(nr).cl = INT(RND * (ct - cf) + cf)
  p(nr).c.x = INT(RND * r - (r / 2)) + x
  p(nr).c.y = INT(RND * r - (r / 2)) + y
 END IF
NEXT qq
END SUB

SUB ShowBossEnergy (wa, wt AS INTEGER)
 pt = (100 - (((wa - wt) / wa) * 100)) * .8
 IF pt <= 100 / 3 THEN c = 4
 IF pt > 100 / 3 AND pt <= 2 * (100 / 3) THEN c = 6 + 8
 IF pt > 2 * (100 / 3) THEN c = 2
 LINE (0, 90)-(pt, 90), c
END SUB

SUB ShowHelp
SCREEN 0
PRINT "Enemu V2.4"
PRINT "enemu2 [Options]"
PRINT "While [Options] are:"
PRINT "--2players", "Toggles 2 Player Mode (NOT implemented!)"
PRINT "--save[Saved Game] "; "Loads saved Game"
PRINT "--help", "Shows this help"
PRINT "--easy", "Easy game"
PRINT "--medi", "Medium game"
PRINT "--hard", "Hard game"
PRINT "--sstars", "Show no stars"
PRINT "--shsmd", "Show no Heat seeking missiles dust"
SLEEP
END SUB

SUB Text (lv)
SCREEN 7, , 0, 0
CLS
px = (13 * xstp) - 3
py = 1 * ystp
SELECT CASE lv
CASE 4
 PUT (px, py), bloky
 LOCATE 5, 5
 COLOR 4
 PRINT "Warning new enemy ships types!"
 COLOR 15
CASE 8
 PUT (px, py), blokr
 LOCATE 5, 5
 COLOR 4
 PRINT "Warning new enemy ships types!"
 COLOR 15
CASE 10
 PUT (px, py), blokt
 LOCATE 5, 5
 COLOR 4
 PRINT "Warning new enemy ships types!"
 COLOR 15
CASE 12
 LOCATE 5, 5
 COLOR 4
 PRINT "Warning enemys with powershield!"
 COLOR 15
END SELECT
LOCATE 6, 13
PRINT "GET READY FOR"
LOCATE 7, 15
PRINT "LEVEL"; lv; "!"
FOR q = 3 TO 1 STEP -1
LOCATE 8, 17
PRINT q
pause .5
NEXT q
CLS
c = lv
FOR s = 30 TO 400 STEP 1
FOR x = 160 TO 320 STEP s
FOR y = 100 TO 200 STEP s
PSET (x, y), c
PSET (x, 200 - y), c
PSET (320 - x, y), c
PSET (320 - x, 200 - y), c
NEXT
NEXT
NEXT
c = 0
FOR s = 30 TO 400 STEP 1
FOR x = 160 TO 320 STEP s
FOR y = 100 TO 200 STEP s
PSET (x, y), c
PSET (x, 200 - y), c
PSET (320 - x, y), c
PSET (320 - x, 200 - y), c
NEXT
NEXT
NEXT

SCREEN 7, , 0, 1
END SUB

SUB toggle (t)
t = NOT t
END SUB

