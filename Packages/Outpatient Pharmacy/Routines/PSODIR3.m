PSODIR3 ;ISC-BIRM/SAB - rx order entry contd ;4/25/07 8:28am
        ;;7.0;OUTPATIENT PHARMACY;**3,46,184,222,206**;DEC 1997;Build 39
        ;
EXP(PSODIR)     ;
        K DIC,DIR
        I $G(PSODRUG("EXPIRATION DATE"))]"" S Y=PSODRUG("EXPIRATION DATE") X ^DD("DD") S PSORX("EXPIRATION DATE")=Y
        S DIR("A")="EXPIRES",DIR("B")=$S($G(PSORX("EXPIRATION DATE"))]"":PSORX("EXPIRATION DATE"),1:"T+6M")
        S DIR(0)="D^NOW::EX",DIR("?")="Both the month and date are required." D ^DIR
        G:PSODIR("DFLG")!PSODIR("FIELD") EXPX
        S PSODIR("EXPIRATION DATE")=Y
EXPX    K X,Y
        Q
        ;
MW(PSODIR)      ;
        K DIR,DIC
        S DIR(0)="52,11"
        S DIR("B")=$S($G(PSORX("MAIL/WINDOW"))]"":PSORX("MAIL/WINDOW"),1:"WINDOW")
        D DIR G:PSODIR("DFLG")!PSODIR("FIELD") MWX
        I $G(Y(0))']"" S PSODIR("DFLG")=1 G MWX
        S PSODIR("MAIL/WINDOW")=Y,PSORX("MAIL/WINDOW")=Y(0)
        I $G(PSORX("EDIT"))]"",PSODIR("MAIL/WINDOW")'="W" K PSODIR("METHOD OF PICK-UP")
MW1     G:PSODIR("MAIL/WINDOW")'="W"!('$P($G(PSOPAR),"^",12)) MWX
        S DIR(0)="52,35O"
        S:$G(PSORX("METHOD OF PICK-UP"))]"" DIR("B")=PSORX("METHOD OF PICK-UP")
        D DIR G:PSODIR("DFLG") MWX
        I X[U W !,"Cannot jump to another field ..",! G MW1
        S (PSODIR("METHOD OF PICK-UP"),PSORX("METHOD OF PICK-UP"))=Y
MWX     K X,Y
        Q
        ;
FILLDT(PSODIR)  ;
        K DIR,DIC
        S DIR("A")="FILL DATE",DIR("B")=$S($G(PSORX("FILL DATE"))]"":PSORX("FILL DATE"),1:"TODAY")
        S DIR(0)="D^"_$S($G(PSODIR("ISSUE DATE"))]"":PSODIR("ISSUE DATE"),1:DT)_$S($G(DUZ("AG"))="I":":"_DT_":EX",1:"::EX")
        S DIR("?",1)="The earliest fill date allowed is determined by the ISSUE DATE,"
        S DIR("?",2)="the FILL DATE cannot be before the ISSUE DATE."
        S DIR("?")="Both the month and date are required."
        D DIR G:PSODIR("DFLG")!PSODIR("FIELD") FILLDTX
        S PSODIR("FILL DATE")=Y
        X ^DD("DD") S PSORX("FILL DATE")=Y
FILLDTX K X,Y
        Q
        ;
CLERK(PSODIR)   ;
        I $G(DUZ("AG"))'="I",$G(DUZ) S PSODIR("CLERK CODE")=DUZ,PSORX("CLERK CODE")=$P($G(^VA(200,DUZ,0)),"^") G CLERKX
        K DIR,DIC
        S DIR("A")="CLERK",DIR("B")=$S($G(PSORX("CLERK CODE"))]"":PSORX("CLERK CODE"),1:$P($G(^VA(200,DUZ,0)),"^",2)),DIR(0)="52,16"
        D DIR G:PSODIR("DFLG")!PSODIR("FIELD") CLERKX
        S PSODIR("CLERK CODE")=+Y,PSORX("CLERK CODE")=$P(Y,"^")
CLERKX  Q
        ;
DIR     ;
        S PSODIR("FIELD")=0
        G:$G(DIR(0))']"" DIRX
        D ^DIR K DIR,DIE,DIC,DA
        I $D(DUOUT)!($D(DTOUT))!($D(DIROUT)),$L($G(X))'>1!(Y="") S PSODIR("DFLG")=1 G DIRX
        I X[U,$L(X)>1 D JUMP
DIRX    K DIRUT,DTOUT,DUOUT,DIROUT,PSOX
        Q
        ;
JUMP    ;
        I $G(PSOEDIT)!($G(OR0)) S PSODIR("DFLG")=1 Q
        S X=$P(X,"^",2),DIC="^DD(52,",DIC(0)="QM" D ^DIC K DIC
        I Y=-1 S PSODIR("FIELD")=PSODIR("FLD") G JUMPX
        I $G(PSONEW1)=0 D JUMP^PSONEW1 G JUMPX
        I $G(PSONEW3)=0 D JUMP^PSONEW3 G JUMPX
        I $G(PSORENW3)=0 D JUMP^PSORENW3 G JUMPX
JUMPX   S X="^"_X
        Q
        ;Continued from PSODIR1, Tag REFOR, Added PSOCS set and changed G REFILLX references to a QUIT
REFOR   ;
        F DEA=1:1 Q:$E($G(PSODRUG("DEA")),DEA)=""  I $E(+PSODRUG("DEA"),DEA)>1,$E(+PSODRUG("DEA"),DEA)<6 S $P(PSOCS,"^")=1 S:$E(+PSODRUG("DEA"),DEA)=2 $P(PSOCS,"^",2)=1
        I $G(PSOCS) D
        .S (PSOX,PSOMAX)=$S($G(CLOZPAT)=2&(PSODIR("DAYS SUPPLY")=14):1,$G(CLOZPAT)=2&(PSODIR("DAYS SUPPLY")=7):3,$G(CLOZPAT)=1&(PSODIR("DAYS SUPPLY")=7):1,$D(CLOZPAT):0,1:5)
        .S PSOX=$S('PSOX:0,PSODIR("DAYS SUPPLY")=90:1,1:PSOX),PSDY=PSODIR("DAYS SUPPLY"),PSDY1=$S(PSDY<60:5,PSDY'<60&(PSDY'>89):2,PSDY=90:1,1:0) S PSOX=$S(PSOX'>PSDY1:PSOX,1:PSDY1)
        E  D
        .S (PSOX,PSOMAX)=$S($G(CLOZPAT)=2&(PSODIR("DAYS SUPPLY")=14):1,$G(CLOZPAT)=2&(PSODIR("DAYS SUPPLY")=7):3,$G(CLOZPAT)=1&(PSODIR("DAYS SUPPLY")=7):1,$D(CLOZPAT):0,1:11)
        .S PSDY=PSODIR("DAYS SUPPLY"),PSDY1=$S(PSDY<60:11,PSDY'<60&(PSDY'>89):5,PSDY=90:3,1:0) S PSOX=$S(PSOX'>PSDY1:PSOX,1:PSDY1)
        K PSOELSE I '$D(CLOZPAT) I $G(PSODRUG("DEA"))["A"&($G(PSODRUG("DEA"))'["B")!($G(PSODRUG("DEA"))["F")!($G(PSODRUG("DEA"))[1)!($G(PSODRUG("DEA"))[2) D  Q
        .S VALMSG="No refills allowed on "_$S($G(PSODRUG("DEA"))["A":"this narcotic drug.",1:"this drug.")
        .W !,VALMSG,!
        .S:$D(PSODIR("FIELD")) PSODIR("FIELD")=0 S PSODIR("# OF REFILLS")=0
        I $D(CLOZPAT) D
        .S PSOX=$S($G(CLOZPAT)=2&(PSODIR("DAYS SUPPLY")=14):1,$G(CLOZPAT)=2&(PSODIR("DAYS SUPPLY")=7):3,$G(CLOZPAT)=1&(PSODIR("DAYS SUPPLY")=7):1,1:0)
        .S (PSODIR("# OF REFILLS"),PSODIR("N# REF"))=PSOX
        S DIR(0)="N^0:"_PSOX,DIR("A")="# OF REFILLS"
        S DIR("B")=$S($G(POERR)&($G(PSODIR("# OF REFILLS"))):PSODIR("# OF REFILLS"),$G(PSODIR("N# REF"))]"":PSODIR("N# REF"),$G(PSODIR("# OF REFILLS"))]"":PSODIR("# OF REFILLS"),$G(PSOX1)]""&(PSOX>PSOX1):PSOX1,1:PSOX)
        S DIR("?")="Enter a whole number.  The maximum is set by the DAYS SUPPLY field."
        D DIR Q:PSODIR("DFLG")!PSODIR("FIELD")
        S (PSODIR("N# REF"),PSODIR("# OF REFILLS"))=Y
        Q