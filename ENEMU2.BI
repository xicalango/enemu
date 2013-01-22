'Enemu2-Include V2.4 (C) 2004 by Alexander Weld
DECLARE FUNCTION lcoll! (x!, b AS ANY, bo AS ANY)
DECLARE FUNCTION CollPart! (part() AS ANY, n!, s AS ANY, so AS ANY)
DECLARE SUB ShowBossEnergy (wa!, wt AS INTEGER)
DECLARE SUB ReleaseParticles (p() AS ANY, x!, y!, q!, cf!, ct!, vf!, vt!, r!, pqt!)
DECLARE FUNCTION CountPart! (p() AS ANY, qt!)
DECLARE SUB MovePart (part() AS ANY, qt!)
DECLARE SUB ClearParticles (p() AS ANY, qt!)
DECLARE SUB ShowHelp ()
DECLARE FUNCTION dst! (c1 AS ANY, c2 AS ANY)
DECLARE SUB toggle (t!)
DECLARE SUB Text (lv!)
DECLARE SUB helptext ()
DECLARE SUB pause (wtm!)
DECLARE SUB GetOffset (ac AS ANY, ost AS ANY, x!, y!)
DECLARE SUB DrawShip (s AS ANY)
DECLARE FUNCTION coll! (s AS ANY, b AS ANY, bo AS ANY)
CONST false = 0
CONST true = NOT false
CONST xstp = 640 / 60
CONST ystp = 480 / 25
CONST xpts = 1 / xstp
CONST ypts = 1 / ystp
TYPE highsc
        n AS STRING * 20
        s AS INTEGER
        m AS INTEGER
        sz AS INTEGER
        lv AS INTEGER
END TYPE
TYPE equip
        ms AS INTEGER
        l AS INTEGER
        mb AS INTEGER
        f AS INTEGER
        uf AS INTEGER
        ds AS INTEGER
        ts AS INTEGER
        ps AS INTEGER
        rs AS INTEGER
END TYPE
TYPE modification
        n AS STRING * 5
        s AS INTEGER
END TYPE
TYPE coor
        x AS INTEGER
        y AS INTEGER
END TYPE
TYPE shot
        v AS INTEGER
        c AS coor
        x AS INTEGER
        e AS INTEGER
        cl AS INTEGER
        az AS INTEGER
END TYPE
TYPE ship
        c AS coor
END TYPE
TYPE block
        c AS coor
        x AS INTEGER
        e AS INTEGER
        lv AS INTEGER
        ps AS INTEGER
        gt AS INTEGER
END TYPE
TYPE offsets
        mo AS coor
        lo AS coor
        ro AS coor
        uo AS coor
END TYPE
TYPE star
        c AS coor
        x AS INTEGER
        v AS INTEGER
END TYPE
TYPE endboss
        c AS coor
        l AS INTEGER
END TYPE
TYPE heats
        x AS INTEGER
        c AS coor
        tgt AS INTEGER
END TYPE
TYPE particles
        c AS coor
        x AS INTEGER
        cl AS INTEGER
        v AS INTEGER
END TYPE
tkr = 10
DIM save AS highsc
DIM hs(10) AS highsc
DIM SHARED mte
DIM e AS equip
DIM ec AS coor
DIM stars(10) AS star
DIM s AS ship
DIM so AS offsets
DIM sh(50) AS shot
DIM b(10) AS block
DIM bo AS offsets
DIM has(4) AS heats
DIM lo AS offsets
DIM eb AS endboss
DIM eo AS offsets
DIM hsmp(200) AS particles
DIM dstp(100) AS particles
DIM SHARED blokg(1 TO 40)
DIM SHARED blokt(1 TO 40)
DIM SHARED blokr(1 TO 40)
DIM SHARED bloky(1 TO 40)
DIM SHARED lrck(1 TO 100)
DIM SHARED eboss(1 TO 4000)
DIM SHARED ship(1 TO 78)
DIM modi(7) AS modification
modi(0).n = "None"
modi(0).s = 1
modi(1).n = "Autop"
modi(1).s = 0
modi(2).n = "Veloc"
modi(2).s = 0
modi(3).n = "Power"
modi(3).s = 0
modi(4).n = "Pos"
modi(4).s = 0
modi(5).n = "Shotw"
modi(5).s = 0
modi(6).n = "Sinus"
modi(6).s = 0
modi(7).n = "Laser"
modi(7).s = 0
sm = 0
shfq = .2
e.l = 3
mte = false
tf = true
sfps = false
lv = 1
d1 = 30
r1 = 20
l1 = 80
ax = 100
ac = 4
ur = 190
srl = 80
srr = 215
st = TIMER
apf = 1
sstars = true
shsmd = true
sdst = true
eo.lo.x = 0
eo.lo.y = 30
eo.ro.x = 80
eo.ro.y = 30
eo.uo.x = 40
eo.uo.y = 50
eo.mo.x = 40
eo.mo.y = 20
bo.mo.x = 4
bo.mo.y = 2
bo.lo.x = 0
bo.lo.y = 3
bo.ro.x = 8
bo.ro.y = 3
bo.uo.x = 4
bo.uo.y = 5
s.c.x = 140
s.c.y = 190
so.uo.x = 7
so.uo.y = 0
so.lo.x = 0
so.lo.y = 5
so.ro.x = 14
so.ro.y = 5
so.mo.x = 7
so.mo.y = 4
lo.uo.x = 3
lo.uo.y = 0
lo.mo.x = 3
lo.mo.y = 5

