ENLBL6  ;(WASH ISC)/DH-Print Bar Coded Equipment Labels ;10.10.97
        ;;7.0;ENGINEERING;**12,35,45,90**;Aug 17, 1993;Build 25
WING    ;General location (Space File WING)
        S ENERR=0 D STA^ENLBL3 G:ENEQSTA="^" QUIT^ENLBL3
WING1   S X="" R !,"Enter WING: ",X:DTIME G:X=""!(X="^") EXIT1^ENLBL8 I $E(X)="?" D HWING G WING1
        I $D(^ENG("SP","C",X)) G WB
        S X1=$O(^ENG("SP","C",X)),X2=$L(X) I $E(X1,1,X2)'=X S X=""
        I X]"" D
        . I $E($O(^ENG("SP","C",X1)),1,X2)'=X S X=X1 Q
        . S DIC="^ENG(""SP"",",ENDX="C" D IX^ENLIB1
        I X="" W !!,*7,"Sorry, no such WING.  Please try again or enter '^' to exit.",! G WING1
WB      ;  More than 1 BUILDING?
        S ENWNG=X K X S X=0 F  S X=$O(^ENG("SP","C",ENWNG,X)) Q:X'>0  S X($P($G(^ENG("SP",X,0)),U,2))=""
WB1     S X=$O(X(0)) I $O(X(X))="" S ENBLDG="ALL"
        E  D  G:X="^" EXIT1^ENLBL8 I ENBLDG'="ALL",'$D(X(ENBLDG)) G WB1
        . W !,"Please select a BUILDING."
        . W !,?5,"Choices are: " S X=0 F  S X=$O(X(X)) Q:X']""  W X_", " W:(IOM-$X)'>15 !,?5
        . W "or ALL."
        . R !,?5,"BUILDING: ALL// ",X:DTIME I '$T!(X="^") S X="^" Q
        . I X=""!(X="ALL") S ENBLDG="ALL" Q
        . S ENBLDG=X
WING11  S (ENFLG,ENROOM)=0 F  S ENROOM=$O(^ENG("SP","C",ENWNG,ENROOM)) Q:ENFLG!(ENROOM="")  D
        . I ENBLDG="ALL",$D(^ENG(6914,"D",ENROOM)) S ENFLG=1 Q
        . I $P($G(^ENG("SP",ENROOM,0)),U,2)=ENBLDG,$D(^ENG(6914,"D",ENROOM)) S ENFLG=1
        I 'ENFLG W !!,*7,"There does not appear to be any equipment located on this WING",!,"(",ENWNG,"). Nothing to print.",!! G WING1
        D EN^ENLBL9 G:$D(DIRUT) EXIT^ENLBL8
        I '$D(ENEQIO),%<0 G EXIT1^ENLBL8
        S %ZIS("A")="Select BAR CODE PRINTER: ",%ZIS("B")="",%ZIS="Q" I $D(ENEQIO),ENEQIO=IO S %ZIS=""
        K IO("Q") D ^%ZIS K %ZIS G:POP EXIT1^ENLBL8
        S ENBCIO=IO,ENBCIOSL=IOSL,ENBCIOF=IOF,ENBCION=ION,ENBCIOST=IOST,ENBCIOST(0)=IOST(0),ENBCIOS=IOS S:$D(IO("S")) ENBCIO("S")=IO("S")
        I $D(IO("Q")) K IO("Q") S ZTIO=ION,ZTRTN="WING2^ENLBL6",ZTSAVE("D*")="",ZTSAVE("EN*")="",ZTDESC="Equipment Bar Code Labels by WING" D ^%ZTLOAD K ZTSK G EXIT1^ENLBL8
WING2   S ENEQBY="WING "_ENWNG,ENLOCSRT=1,ENBCIO=IO  ;HD308658
        I $D(ENEQIO) D OPEN^ENLBL9 I POP G:$D(ZTQUEUED) REQ^ENLBL8 W !,*7,"Companion Printer UNAVAILABLE." D HOLD G EXIT1^ENLBL8
        K ^TMP($J) S ENROOM=0 F  S ENROOM=$O(^ENG("SP","C",ENWNG,ENROOM)) Q:ENROOM=""  I ENBLDG="ALL"!($$GET1^DIQ(6928,ENROOM,.5)=ENBLDG) D
        . S K=0 F  S K=$O(^ENG(6914,"D",ENROOM,K)) Q:K'>0  S DA=K D STATCK^ENLBL3 I DA]"" D SORT^ENLBL3 D:'(DA#10) DOTS^ENLBL3
        I $D(^TMP($J)) U ENBCIO D FORMAT^ENLBL7 S I1=0 F  S I1=$O(^TMP($J,I1)) Q:I1=""  D
        . S DA=0 F  S DA=$O(^TMP($J,I1,DA)) Q:DA'>0  U ENBCIO D NXPRT^ENLBL7 D:$D(ENEQIO) CPRNT^ENLBL9 D:'(DA#10) DOTS^ENLBL3 D BCDT^ENLBL7
        G EXIT^ENLBL8
        ;
HWING   S X="" W !,"Enter WING as defined in Space File. Would you like a list" S %=2 D YN^DICN Q:%'=1
        S (I,ENY)=0 F K=0:0 S I=$O(^ENG("SP","C",I)) Q:I=""  D:ENY>(IOSL-6) HWING2 Q:I="^"  W !,?5,I S ENY=ENY+1
        S X="" Q
HWING2  S ENY=0 W !,"Press <RETURN> to continue or ""^"" to escape..." R X:DTIME S:X="^" I="^"
        Q
RM      ;Single room (from Space File)
        S ENERR=0 D STA^ENLBL3 G:ENEQSTA="^" QUIT^ENLBL3
RM1     S DIC="^ENG(""SP"",",DIC(0)="AEQM" D ^DIC
        I Y'>0 G EXIT1^ENLBL8
        S ENROOM=+Y,ENROOM("TXT")=$P(^ENG("SP",ENROOM,0),U)
        I '$D(^ENG(6914,"D",ENROOM)) W !!,*7,"There does not appear to be any equipment in ",ENROOM("TXT"),".",!! K ENROOM G RM1
        D EN^ENLBL9 I '$D(ENEQIO),%<0 G EXIT1^ENLBL8
        S %ZIS("A")="Select BAR CODE PRINTER: ",%ZIS("B")="",%ZIS="Q" I $D(ENEQIO),ENEQIO=IO S %ZIS=""
        K IO("Q") D ^%ZIS K %ZIS G:POP EXIT1^ENLBL8
        S ENBCIO=IO,ENBCIOSL=IOSL,ENBCIOF=IOF,ENBCION=ION,ENBCIOST=IOST,ENBCIOST(0)=IOST(0),ENBCIOS=IOS S:$D(IO("S")) ENBCIO("S")=IO("S")
        I $D(IO("Q")) S ZTIO=ION,ZTDESC="Bar Code Labels for Room "_ENROOM("TXT"),ZTRTN="RM2^ENLBL6",ZTSAVE("EN*")="",ZTSAVE("D*")="" D ^%ZTLOAD K ZTSK,IO("Q") G EXIT1^ENLBL8
RM2     S ENEQBY="Room "_ENROOM("TXT"),ENBCIO=IO  ;HD308658
        I $D(ENEQIO) D OPEN^ENLBL9 I POP G:$D(ZTQUEUED) REQ^ENLBL8 W !,*7,"Companion Printer UNAVAILABLE." D HOLD G EXIT1^ENLBL8
        U ENBCIO D FORMAT^ENLBL7 F I1=0:0 S I1=$O(^ENG(6914,"D",ENROOM,I1)) Q:I1'>0  S DA=I1 D STATCK^ENLBL3 I DA]"" U ENBCIO D NXPRT^ENLBL7 D:$D(ENEQIO) CPRNT^ENLBL9 D:'(DA#10) DOTS^ENLBL3 D BCDT^ENLBL7
        G EXIT^ENLBL8
        ;
HOLD    W !,"Press <RETURN> to continue..." R X:DTIME
        Q
        ;
        ;ENLBL6
