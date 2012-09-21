ENLBL3  ;(WASH ISC)/DH-Print Bar Coded Equipment Labels ;10.10.97
        ;;7.0;ENGINEERING;**12,35,45,90**;Aug 17, 1993;Build 25
        ;
SD      ;Single device
        S ENERR=0 D STA G:ENEQSTA="^" QUIT
        N DIC,DIE,DR,DA,FR,TO,X,X1,X2,I,J,K,I1
        N TAG D EN1^ENLBL9 I '$D(ENEQIO),%<0 G EXIT1^ENLBL8
SD1     D GETEQ^ENUTL
        I Y'>0 S TAG=$S('$D(ENEQIO):"EXIT1",$D(IO(1,ENEQIO)):"EXIT",1:"EXIT1")_"^ENLBL8" G @TAG
        S DA=+Y
        S %ZIS("A")="Select BAR CODE PRINTER: ",%ZIS("B")=$S($D(ENBCIO):ENBCION,1:""),%ZIS="Q" I $D(ENEQIO),ENEQIO=IO S %ZIS=""
        K IO("Q") D ^%ZIS K %ZIS I POP S TAG=$S('$D(ENEQIO):"EXIT1",$D(IO(1,ENEQIO)):"EXIT",1:"EXIT1")_"^ENLBL8" G @TAG
        I $D(ENBCIO),ENBCIO'=IO D
        . N IO,IOSL,IOF,ION,IOST S IO=ENBCIO D ^%ZISC Q
        S ENBCIO=IO,ENBCIOSL=IOSL,ENBCIOF=IOF,ENBCION=ION,ENBCIOST=IOST,ENBCIOST(0)=IOST(0),ENBCIOS=IOS S:$D(IO("S")) ENBCIO("S")=IO("S")
        I $D(IO("Q")) D  G SD1
        . S:$D(ENEQIO) ENEQY(0)=ENEQY,ENEQPG(0)=ENEQPG,(ENEQY,ENEQPG)=0
        . S ZTIO=ION,ZTRTN="SD2^ENLBL3",ZTSAVE("DA")="",ZTSAVE("EN*")="",ZTDESC="Single Equipment Bar Code Label" D ^%ZTLOAD K ZTSK,IO("Q") D ^%ZISC
        . S:$D(ENEQIO) ENEQY=ENEQY(0),ENEQPG=ENEQPG(0)
        ;HD308658
SD2     S ENEQBY="Single Label(s)",ENBCIO=IO
        I $D(ENEQIO) D OPEN^ENLBL9 I POP G:$D(ZTQUEUED) REQ^ENLBL8 W !,*7,"Companion Printer UNAVAILABLE." D HOLD G EXIT1^ENLBL8
        U ENBCIO D FORMAT^ENLBL7
        D NXPRT^ENLBL7,BCDT^ENLBL7 D:$D(ENEQIO) CPRNT^ENLBL9
        G:$D(ZTQUEUED) EXIT^ENLBL8
        D HOME^%ZIS U IO G SD1
        ;
CAT     ;Complete Equip Category
        S ENERR=0 D STA G:ENEQSTA="^" QUIT
        N DIC,DIE,DA,DR,FR,TO,X,X1,X2,I,J,K,I1
        D EN^ENLBL9 G:$D(DIRUT) EXIT1^ENLBL8
        I '$D(ENEQIO),%<0 G EXIT1^ENLBL8
        K ENEQDA
CAT1    S DIC="^ENG(6911,",DIC(0)="AEMQ" D ^DIC
        I Y'>0 G EXIT1^ENLBL8
        S ENEQDA=+Y
        S ENLOCSRT=1
CAT11   W !,"Sort labels by LOCATION" S %=1 D YN^DICN G:%<0 EXIT1^ENLBL8 I %=0 W !,"Say YES to sort labels by BUILDING, then by ROOM within BUILDING.",!,"If you say NO, labels will be sorted by EQUIPMENT ID#." G CAT11
        S:%=2 ENLOCSRT=0
        S %ZIS("A")="Select BARCODE PRINTER: ",%ZIS("B")="",%ZIS="Q" I $D(ENEQIO),ENEQIO=IO S %ZIS=""
        K IO("Q") D ^%ZIS K %ZIS G:POP EXIT1^ENLBL8
        S ENBCIO=IO,ENBCIOSL=IOSL,ENBCIOF=IOF,ENBCION=ION,ENBCIOST=IOST,ENBCIOST(0)=IOST(0),ENBCIOS=IOS S:$D(IO("S")) ENBCIO("S")=IO("S")
        I $D(IO("Q")) S ZTIO=ION,ZTRTN="CAT2^ENLBL3",ZTSAVE("EN*")="",ZTDESC="Barcode Labels by CATEGORY" D ^%ZTLOAD K ZTSK,IO("Q") G EXIT1^ENLBL8
        ;HD308658
CAT2    G:'$D(^ENG(6911,ENEQDA,0)) EXIT1^ENLBL8 S ENEQBY="Equip Cat: "_$P(^ENG(6911,ENEQDA,0),U,1),ENBCIO=IO
        I $D(ENEQIO) D OPEN^ENLBL9 I POP G:$D(ZTQUEUED) REQ^ENLBL8 W !,*7,"Companion Printer UNAVAILABLE." D HOLD G EXIT1^ENLBL8
        K ^TMP($J) S I1=0 F J1=0:0 S I1=$O(^ENG(6914,"G",ENEQDA,I1)) Q:I1'>0  S DA=I1 D STATCK I DA]"" D SORT D:'(DA#10) DOTS
        I $D(^TMP($J)) U ENBCIO D FORMAT^ENLBL7 S I1="" F J1=0:0 S I1=$O(^TMP($J,I1)) Q:I1=""  F DA=0:0 S DA=$O(^TMP($J,I1,DA)) Q:DA'>0  U ENBCIO D NXPRT^ENLBL7 D:$D(ENEQIO) CPRNT^ENLBL9 D:'(DA#10) DOTS D BCDT^ENLBL7
        G EXIT^ENLBL8
        ;
SORT    I 'ENLOCSRT S ^TMP($J,DA,DA)="" Q
        S X=$S($D(^ENG(6914,DA,3)):$P(^(3),U,5),1:0) S:X="" X=0
        G:X=0 SORT1
        I X=+X,$D(^ENG("SP",X,0)) D  G SORT1
        . I $D(^ENG("SP",X,9)) S X(0)=$P(^(9),U) I X(0)]"" S X=X(0) Q
        . S X=$P(^ENG("SP",X,0),U) F I=1,2,3 S X(I)=$P(X,"-",I)
        . S X=X(3)_":"_X(2)_":"_X(1)
        F I=1,2,3 S X(I)=$P(X,"-",I)
        S X=X(3)_":"_X(2)_":"_X(1)
SORT1   S ^TMP($J,X,DA)=""
        Q
        ;
STATCK  S:'$D(^ENG(6914,DA,0)) DA="" I DA]"" S ENA=$G(^(3)) D:ENA]""  Q
        . I $P(ENA,U)>3,$P(ENA,U)<6 S DA="" Q
        . I $G(ENEQREP),$P(ENA,U,10)]"" S DA=""
        ;
STA     I $D(^DIC(6910,1,0)),$P(^(0),U,2)]"" S ENEQSTA=$P(^(0),U,2)
        E  S ENEQSTA="^"
        I ENEQSTA'="^" S ENEQSTAN="DVAMC "_$P(^DIC(6910,1,0),U),ENEQLM=(135+(4*$L(ENEQSTAN)))
        Q
        ;
DOTS    ;Act indic
        Q:$D(ZTQUEUED)
        I '$D(ENEQIO) U IO(0) W "." Q
        I ENEQIO'=IO(0) U IO(0) W "."
        Q
        ;
HOLD    W !,"Press <RETURN> to continue..." R X:DTIME
        Q
        ;
QUIT    I $D(ENEQSTA),ENEQSTA="^" W !!,"Can't seem to find your Station Number. Please check File 6910 (ENG INIT",!,"PARAMETERS).",*7
        G EXIT1^ENLBL8
        ;ENLBL3
