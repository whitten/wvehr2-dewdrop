ONCACD0 ;Hines OIFO/GWB - NAACCR extract driver ;06/11/01
        ;;2.11;Oncology;**9,12,20,24,25,28,29,30,36,37,38,40,41,44,45,47,48**;Mar 07, 1995;Build 13
        ;
EN1(DEVICE,STEXT)       ;Select extract from ONCOLOGY DATA EXTRACT FORMAT (160.16)
EN2     N EXTRACT,HDRIEN,STAT,STAT1,STAT2,DATE,YESNO,BDT,SDT,EDT,QUEUE,NCDB
        K ^TMP($J)
        S DEVICE=$G(DEVICE,0),STEXT=$G(STEXT,0),(EXTRACT,QUEUE)=0,EXT=""
        I STEXT=0 S EXTRACT=$O(^ONCO(160.16,"B","NCDB EXTRACT V11.2",0))
        S (STAT,DATE,OUT,SDT,EDT)=0
        S HDRIEN=EXTRACT
        D DISPLAY
        I STEXT=1 D GETREC(.EXTRACT,.OUT)
        I 'OUT S STAT=$$GETHOSP
        I 'STAT S OUT=1
        I 'OUT S STAT1=$P(STAT,U,1),STAT2=$P(STAT,U,2)
        I 'OUT D GETDATE(.DATE,.OUT)
        I 'OUT,STEXT D GETDT(.SDT,.EDT,DATE,.OUT)
        I 'OUT D VERIFY(STAT,DATE,SDT,EDT,STEXT,.YESNO,.OUT)
        I 'OUT G:'YESNO EN2
        I 'OUT D DEVICE(DEVICE,.OUT)
        I 'OUT D:'QUEUE PRINT(DEVICE,.OUT)
        D EXIT
        Q
        ;
GETREC(EXTRACT,OUT)     ;Select record layout
        W !!," Available record layouts:",!
        W !,"  1) VACCR Record Layout v11.2 (VA Registry)"
        W !,"  2) NAACCR State Record Layout v11.2"
        W !
        N DIR,X,Y
        S DIR(0)="SAO^1:VACCR Record Layout v11.2;2:NAACCR State Record Layout v11.2"
        S DIR("A")=" Select record layout: "
        S DIR("?")="Select the record layout to use"
        D ^DIR
        I $D(DIRUT) S OUT=1 Q
        I +Y<1 S OUT=1 Q
        I Y=1 S EXT="VACCR",EXTRACT=$O(^ONCO(160.16,"B","VACCR EXTRACT V11.2",0))
        I Y=2 S EXT="STATE",EXTRACT=$O(^ONCO(160.16,"B","STATE EXTRACT V11.2",0))
        S HDRIEN=EXTRACT
        Q
        ;
DISPLAY ;Display on-line instructions
        N X,DIR,Y
        S DIR("A")="    DISPLAY/PRINT on-line instructions"
        S DIR("B")="No"
        S DIR(0)="Y"
        D ^DIR I ($D(DIRUT))!(+Y<1) Q
        I X=0 Q
        I X<0 S OUT=1 Q
        W ! S DIC="^ONCO(160.2,",L=0,DHD="@"
        S FLDS="1",BY="@.01"
        I STEXT S (FR,TO)="STATE REPORTING ACOS INFOA"
        E  S (FR,TO)="PRIMARY ACOS INFO (850)"
        D EN1^DIP
        S:'($D(DTOUT)+$D(DUOUT)=0) OUT=1
        S X=$$ASKY^ONCOU("Continue")
        S:X<1 OUT=1
        Q
        ;
GETDT(SDT,EDT,DATE,OUT) ; Select a date range
        K DIR
        S DIR(0)="SAO^1:Date Case Completed;2:Date Case Last Changed"
        S DIR("A")=" Select date field to be used for Start/End range: "
        S DIR("?")="Select the date field you wish to use for this download's Start/End range prompts."
        D ^DIR
        I $D(DIRUT) S OUT=1 Q
        I Y<1 S OUT=1 Q
        I +Y=2 S STEXT=2
DCLC    K DIR
        S DIR(0)="D^::X"
        I STEXT=1 D
        .S DIR("A")=" Start, Date Case Completed"
        .S DIR("?",1)="   Enter the DATE CASE COMPLETED of the"
        .S DIR("?",2)="   FIRST abstract you would like to report."
        I (STEXT=2)!($G(NCDB)=2) D
        .S DIR("A")=" Start, Date Case Last Changed"
        .S DIR("?",1)="   Enter the DATE CASE LAST CHANGED of the"
        .S DIR("?",2)="   FIRST abstract you would like to report."
        S DIR("?")=" "
        D ^DIR I $D(DIRUT) S OUT=1 Q
        S (SDT,BDT)=Y
        K DIR
        S DIR(0)="D^::X"
        I STEXT=1 D
        .S DIR("A")="   End, Date Case Completed"
        .I EXT="VACCR",$P($G(^ONCO(160.1,ONCSPIEN,0)),U,8)'="" S DIR("B")=$$GET1^DIQ(160.1,ONCSPIEN,61)
        .I EXT="STATE",$P($G(^ONCO(160.1,ONCSPIEN,0)),U,9)'="" S DIR("B")=$$GET1^DIQ(160.1,ONCSPIEN,62)
        .S DIR("?",1)="   Enter the DATE CASE COMPLETED of the"
        .S DIR("?",2)="   LAST abstract you would like to report."
        I (STEXT=2)!($G(NCDB)=2) D
        .S DIR("A")="   End, Date Case Last Changed"
        .I EXT="VACCR",$P($G(^ONCO(160.1,ONCSPIEN,0)),U,10)'="" S DIR("B")=$$GET1^DIQ(160.1,ONCSPIEN,63)
        .I EXT="STATE",$P($G(^ONCO(160.1,ONCSPIEN,0)),U,11)'="" S DIR("B")=$$GET1^DIQ(160.1,ONCSPIEN,64)
        .S DIR("?",1)="   Enter the DATE CASE LAST CHANGED  of the"
        .S DIR("?",2)="   LAST abstract you would like to report."
        D ^DIR I $D(DIRUT) S OUT=1 Q
        S EDT=Y
        I EXT="" Q
        I $G(NCDB)=2 Q
        I EXT="VACCR" S ACO=1 Q
        K DIR
        S DIR("A")=" Analytic cases only"
        S DIR("B")="YES"
        S DIR(0)="Y"
        S DIR("?")=" "
        S DIR("?",1)=" Answer 'YES' if you want only analytic cases (CLASS OF CASE 0-2) extracted."
        S DIR("?",2)=" Answer  'NO' if you want all cases (analytic and non-analytic) extracted."
        D ^DIR
        I $D(DIRUT) S OUT=1 Q
        S ACO=Y
        Q
        ;
PRINT(DEVICE,OUT)       ;Capture output data
        I 'DEVICE D  Q:OUT
        .N X
        .W !!
        .W !,?6,"--------------------------------------------------------------"
        .W !,?6,"|Please activate your PC capture program.  The data will be  |"
        .W !,?6,"|sent in 2 minutes or when you press the return key.         |"
        .W !,?6,"--------------------------------------------------------------"
        .W !!!
        .R X:120
        .I X="^" S OUT=1
        U IO D EN1^ONCACD1
        Q
        ;
EXIT    ;Exit
        K D0,DI,DIC,DISYS,DQ,FIL,ONCOM,ONCOT,ONCOYR,OUT,ST,STGIND,X,Y
        I '$D(^TMP($J)) W !?3,"No records extracted." G EX
        W !
        S DIC="^ONCO(165.5,",L=0,FLDS="[ONC EXTRACT]",BY(0)="^TMP($J,",L(0)=1
        S:DEVICE IOP=ION
        I STEXT=0 S DHD=$P(^ONCO(160.16,HDRIEN,0),U,1) W !
        I (STEXT=1)!(STEXT=2) S DHD=$P(^ONCO(160.16,HDRIEN,0),U,1)_" "_$$FMTE^XLFDT(BDT,"2D")_" - "_$$FMTE^XLFDT(EDT,"2D")
        D EN1^DIP
        I IOST?1"C".E K DIR S DIR(0)="E" D ^DIR Q:'Y
EX      K ^TMP($J)
        K %ZIS
        D ^%ZISC
        Q
        ;
DEVICE(DEVICE,OUT)      ;Select output device
        Q:'DEVICE
        S %ZIS="Q"
        D ^%ZIS
        I POP S OUT=1 Q
        I $D(IO("Q")) D
        .S ZTRTN="PRINT^ONCACD0(DEVICE,.OUT)"
        .S ZTDESC=$S('STEXT:"ONC NCDB Extract",STEXT:"ONC State Extract",1:"")
        .S ZTSAVE("STAT1")=""
        .S ZTSAVE("DATE")=""
        .S ZTSAVE("STEXT")=""
        .S ZTSAVE("DEVICE")=""
        .S ZTSAVE("OUT")=""
        .S ZTSAVE("BDT")=""
        .S ZTSAVE("SDT")=""
        .S ZTSAVE("EDT")=""
        .S ZTSAVE("EXT")=""
        .S ZTSAVE("EXTRACT")=""
        .S ZTSAVE("HDRIEN")=""
        .S ZTSAVE("NCDB")=""
        .D ^%ZTLOAD
        .I $D(ZTSK)[0 S OUT=1 W !!,?20,"Report Canceled!"
        .E  W !!,?20,"Report Queued!" S QUEUE=1
        .D HOME^%ZIS
        Q
        ;
VERIFY(STAT,DATE,SDT,EDT,STEXT,YESNO,OUT)       ;Verify settings
        N DIR,Y
        S RL=$P(^ONCO(160.16,HDRIEN,0),U,1)
        W !!," These are your current settings:"
        W !
        W !," Record layout.......................: ",RL
        W !," Facility Identification Number (FIN): ",STAT1
        I EXT="STATE" D
        .W !," State to be extracted...............: ",STATE
        I STEXT=0 D
        .W !," Accession Year......................: ",DATE
        .W !," Selection criterion.................: ",$S(NCDB=1:"All cases",NCDB=2:"Date Case Last Changed date range",1:"")
        I (STEXT=1)!(STEXT=2)!($G(NCDB)=2) D
        .W !," Start date..........................: ",$$FMTE^XLFDT(SDT,"2D")
        .W !," End date............................: ",$$FMTE^XLFDT(EDT,"2D")
        I EXT="STATE" D
        .W !," Analytic cases only.................: ",$S(ACO=1:"YES",1:"NO")
        W !
        S DIR("A")=" Are these settings correct"
        S DIR("B")="YES"
        S DIR(0)="Y"
        D ^DIR
        I $D(DIRUT) S OUT=1 Q
        S YESNO=Y
        I STEXT=1,EXT="VACCR" S $P(^ONCO(160.1,ONCSPIEN,0),U,8)=EDT
        I STEXT=1,EXT="STATE" S $P(^ONCO(160.1,ONCSPIEN,0),U,9)=EDT
        I STEXT=2,EXT="VACCR" S $P(^ONCO(160.1,ONCSPIEN,0),U,10)=EDT
        I STEXT=2,EXT="STATE" S $P(^ONCO(160.1,ONCSPIEN,0),U,11)=EDT
        Q
        ;
GETDATE(DATE,OUT)       ;Select ACCESSION YEAR
        Q:STEXT=1
        N CYR,DIR,SCREEN,Y
        S DATE=0
        S CYR=1700+($E(DT,1,3)),SCREEN="K:X>CYR X"
        S DIR(0)="NAO^1900:"_CYR_":0^"_SCREEN
        S DIR("A")=" Accession Year: "
        D ^DIR
        I $D(DIRUT) S OUT=1 Q
        S DATE=Y
        K DIR
        W !
        W !,?6,"Select one of the following:"
        W !
        W !,?11,"1 All eligible cases for this year"
        W !,?11,"2 Cases within a 'Date Case Last Changed' date range"
        W !
        S DIR(0)="SAO^1:All cases;2:Cases within a date range"
        S DIR("A")=" Select extraction criterion: "
        S DIR("B")="All cases"
        S DIR("?")=" "
        S DIR("?",1)=" Select 'All cases' if you want to extract all"
        S DIR("?",2)=" of the eligible cases for this Accession Year."
        S DIR("?",3)=""
        S DIR("?",4)=" Select 'Cases within a date range' if you want"
        S DIR("?",5)=" to specify a 'Date Case Last Changed' date range"
        S DIR("?",6)=" for this Accession Year."
        D ^DIR
        I $D(DIRUT) S OUT=1 Q
        I Y<1 S OUT=1 Q
        S NCDB=Y
        I NCDB=2 W ! D DCLC
        Q
        ;
GETHOSP()       ;Facility Identification Number (FIN)
        N STAT,STATI,ALLOK
        S STAT=0,ALLOK=$$GETDXH(.STAT)
        I STAT S STATI=6_STAT_0,STAT=STAT_"^"_STATI
        Q STAT
        ;
GETDXH(DXH)     ;INSTITUTION ID NUMBER (160.1,27)
        N OKHERE,DIE,DA,DR,ONCOL
        W !
        S DIE=160.1
        S DA=$O(^ONCO(160.1,"C",DUZ(2),0))
        I DA="" S DA=$O(^ONCO(160.1,0))
        S ONCSPIEN=DA
        S DR=27_$J("",1)_"Facility Identification Number (FIN)"
        S ONCOL=0
        L +^ONCO(160.1,DA):0 I $T D ^DIE L -^ONCO(160.1,DA) S ONCOL=1
        I 'ONCOL W !,"This site paramaters record is being edited by another user."
        K ONCOL,DIE
        I $D(Y)=0 S DXH=$$GET1^DIQ(160.19,X,.01,"I")
        I X'="" S STATE=$P($G(^ONCO(160.19,X,0)),U,4)
        ;S FACPNT=$P($G(^ONCO(160.1,DA,1)),U,4) D FNPI^ONCNPI
        S OKHERE=($D(Y)=0)
        Q OKHERE