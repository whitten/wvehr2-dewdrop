ONCOGEN ;Hines OIFO/GWB - GENERAL REPORT DRIVER FOR SELECTED FORMATS ;02/02/00
        ;;2.11;ONCOLOGY;**6,7,11,13,16,17,18,22,24,25,26,29,44,47,49**;Mar 07, 1995;Build 38
        ;
SU      ;IR Patient Summary [ONCO ABSTRACT-INCOMP RECORD]
        W !
        S DIC="^ONCO(160,",DIC(0)="AEMQZ" D ^DIC G SUEX:Y<0
        S X=+Y
        S D="C",DIC="^ONCO(165.5,",DIC(0)="EQ" D IX^DIC G SUEX:Y<0
        S D0=+Y
        S BY="NUMBER",(FR,TO)=D0,FLDS="[ONCO XABSTRACT RECORD]",L=0
        S DIC="^ONCO(165.5,",L=0 D EN1^DIP
        K DIR S DIR(0)="E" D ^DIR
SUEX    K DIC,D,BY,FR,TO,FLDS,L
        Q
        ;
SEER    ;[QA Print Abstract QA]
        S SEER=1 G ABSEO
SER1    S ONCODA=DA
        S FLDS="[ONCQA1]"
        I $P($G(^ONCO(165.5,DA,2)),U,1)=67619 S FLDS="[ONCQA]"
        D PRT G END
        ;
ABSEO   ;[EX Print Abstract-Extended (80c)]
        ;[PA Print Complete Abstract (132c)]
        S DIC="^ONCO(160,",DIC(0)="AEMQ" D ^DIC G:Y=-1 END
        S (HI,DA,I)=0
        I $D(^ONCO(165.5,"C",$P(Y,U,1))) W !,"Choose one:" F  S DA=$O(^ONCO(165.5,"C",$P(Y,U,1),DA)) Q:DA'>0  I $$DIV^ONCFUNC(DA)=DUZ(2) S I=I+1,SI=$P(^ONCO(165.5,DA,0),U,1) W:$D(^ONCO(164.2,SI,0)) !?10,I_". "_$P(^(0),U,1) D TEXT S ^TMP($J,I)=DA S HI=I
        I HI=0 W !,"No primaries for this patient" G EX
ANS     S ANS=$$ASKNUM^ONCOU("Enter your selection","1:"_HI,1) G EX:$D(DIRUT)
        S DA=$P(^TMP($J,ANS),U,1),(Y,DA,NUMBER,HDA)=DA
        S PRTPCE=0
        I $P($G(^ONCO(165.5,DA,7)),U,15)'="" W ! K DIR S DIR(0)="YA",DIR("A")=" Print PCE data attached to this primary? ",DIR("B")="NO" D ^DIR
        S PRTPCE=Y G EX:$D(DIRUT)
        G SER1:$D(SEER),DS:$D(NS),X:III<49,Y
X       S OSP=$O(^ONCO(160.1,"C",DUZ(2),0))
        I OSP="" S OSP=$O(^ONCO(160.1,0))
        D ESPD I ESPD[U K ESPD Q
        S (ONCODA,ONCOIEN)=DA D ^ONCOPA1
        G EX
Y       S DIOEND="S DN=1,D0=ONCODA F II=III:1:IIII K DXS D @(""^ONCOY""_II)"
PT      S ONCODA=DA,FLDS="[ONCOY49]"
        D PRT G END
PRT     S FR=NUMBER,TO=NUMBER,BY="@NUMBER",DIC="^ONCO(165.5,",L=0
        D EN1^DIP
        Q
        ;
PRT1    S FR=NUMBER,TO=NUMBER,BY="@NUMBER",DIC="^ONCO(160,",L=0
        D EN1^DIP
        Q
TEXT    W:$D(^ONCO(165.5,DA,8)) "  "_$P(^ONCO(165.5,DA,8),U,1) Q
DD      S Y=$E(Y,4,5)_"/"_$E(Y,6,7)_"/"_($E(Y,1,3)+1700)_$S(Y#1:" "_$E(Y_0,9,10)_":"_$E(Y_"0000",11,12),1:"")
        Q
        ;
DIS     ;[AS Abstract Screens Menu (80c)...]
        G ABSEO
DS      S (D0,ONCODA)=DA
        I $G(NF)=58 S III=50,IIII=58 D Y G END
        S FLDS="[ONCOY49]",FR=ONCODA,TO=ONCODA,BY="@NUMBER",L=0
        S DIC="^ONCO(165.5," D @("SCR"_NS) Q
SCR50   S DIOEND="S DN=1,D0=ONCODA K DXS D @(""^ONCOY50"")" D EN1^DIP,RD Q
SCR3    S DIOEND="S DN=1,D0=ONCODA K DXS D @(""^ONCOX3"")" D EN1^DIP,RD Q
SCR51   S DIOEND="S DN=1,D0=ONCODA K DXS D @(""^ONCOY51"")" D EN1^DIP,RD Q
SCR52   S DIOEND="S DN=1,D0=ONCODA K DXS D @(""^ONCOY52"")" D EN1^DIP,RD Q
SCR53   S DIOEND="S DN=1,D0=ONCODA K DXS D @(""^ONCOY53"")" D EN1^DIP,RD Q
SCR54   S DIOEND="S DN=1,D0=ONCODA F II=54,55 K DXS D @(""^ONCOY""_II)"
        D EN1^DIP Q
SCR56   S DIOEND="S DN=1,D0=ONCODA K DXS D @(""^ONCOY56"")" D EN1^DIP,RD Q
SCR57   S DIOEND="S DN=1,D0=ONCODA K DXS D @(""^ONCOY57"")" D EN1^DIP,RD Q
SCR58   S DIOEND="S DN=1,D0=ONCODA K DXS D @(""^ONCOY58"")" D EN1^DIP,RD Q
        Q
        ;
RD      K DIR S DIR(0)="E",DIR("A")="Hit Enter to continue" D ^DIR
        K QDS I Y'=1 S QDS=1
        Q
        ;
END     D ^%ZISC S IOP=ION D ^%ZIS
        ;
EX      ;Exit
        K ANS,BY,C,D,D0,DA,DATEDX,DIC,DIOEND,DIRUT,FLDS,FR,HDA,HI,I,III,IIII,L
        K NF,NS,NODE0,NUMBER,ONCODA,ONCOIEN,ONCOIO,ONCONUM,ONCOPA,ONCOQUIT,ONCQ
        K ONCX,OSP,PCEABS,PCESEL,POP,PRTPCE,QDS,S,SAVED0,SI,SEER,SITTAB,SSN
        K STGP,STGPNM,TO,TOP,TOPCOD,TOPNAM,TOPTAB,TTAB
        Q
        ;
PCEPRT  ;PRINT PCE DATA (IF ANY) FOR A PARTICULAR PRIMARY AFTER COMPLETE
        ;(OR EXT) ABSTR PRINT.  CALLED BY ROUTINE ^ONCOPA3A (FORMERLY CALLED
        ;BY ONCOX11 PRINT TEMPLATE).  ALSO CALLED BY [ONCOY58] PRINT TEMPLATE.
        I $P($G(^ONCO(165.5,ONCODA,7)),U,15)="" Q  ;IF NO PCE DATA, QUIT
        S STGP=$P($G(^ONCO(165.5,ONCODA,0)),U,1)
        S STGPNM=$P($G(^ONCO(164.2,STGP,0)),U,1),SITTAB=79-$L(STGPNM)
PRINT   ;
        D PCEVARS
        I $P($G(^ONCO(165.5,ONCODA,7)),U,15)="BLA" D PRT^ONCBPC8 Q
        I $P($G(^ONCO(165.5,ONCODA,7)),U,15)="THY" D PRT^ONCTPC8 Q
        I $P($G(^ONCO(165.5,ONCODA,7)),U,15)="STS" D PRT^ONCSPC8 Q
        I $P($G(^ONCO(165.5,ONCODA,7)),U,15)="PRO" D PRT^ONCPPC9 Q
        I $P($G(^ONCO(165.5,ONCODA,7)),U,15)="COL" D PRT^ONCCPC9 Q
        I $P($G(^ONCO(165.5,ONCODA,7)),U,15)="NHL" D PRT^ONCNPC8 Q
        I $P($G(^ONCO(165.5,ONCODA,7)),U,15)="PRO2" D PRT^ONCP2P8 Q
        I $P($G(^ONCO(165.5,ONCODA,7)),U,15)="BRE" D PRT^ONCBRP9 Q
        I $P($G(^ONCO(165.5,ONCODA,7)),U,15)="MEL" D PRT^ONCMPC9 Q
        I $P($G(^ONCO(165.5,ONCODA,7)),U,15)="HEP" D PRT^ONCHPC8 Q
        I $P($G(^ONCO(165.5,ONCODA,7)),U,15)="CNS" D PRT^ONCIPC8 Q
        I $P($G(^ONCO(165.5,ONCODA,7)),U,15)="GAS" D PRT^ONCGPC7 Q
        I $P($G(^ONCO(165.5,ONCODA,7)),U,15)="LNG" D PRT^ONCLPC9 Q
        Q
PCEPRT2 ;PRINT ALL PCE'S FOR A PARTICULAR SITE.
        S ONCQ=0
        W !!?5,"Print PCE's for a particular site"
        K DIR S DIR(0)="SM^1:Bladder;2:Thyroid;3:Soft Tissue Sarcoma;4:Prostate;5:Prostate (1998);6:Colorectal;7:Non-Hodgkin's Lymphoma;8:Breast;9:Melanoma;10:Hepatocellular;11:Intracranial;12:Gastric;13:Lung" D ^DIR Q:$D(DIRUT)
        S PCESEL=$S(Y=1:"BLA",Y=2:"THY",Y=3:"STS",Y=4:"PRO",Y=5:"PRO2",Y=6:"COL",Y=7:"NHL",Y=8:"BRE",Y=9:"MEL",Y=10:"HEP",Y=11:"CNS",Y=12:"GAS",Y=13:"LNG",1:"") Q:PCESEL=""
        W ! K DIR S DIR(0)="YA",DIR("A")="Print PCE's AND Abstracts? ",DIR("B")="Y" D ^DIR S PCEABS=Y G EX:$D(DIRUT)
        K IOP,%ZIS S %ZIS="Q" W ! D ^%ZIS S ONCOIO=ION_";"_IOST_";"_IOM_";"_IOSL G:POP EX
        I $D(IO("Q")) S ONCQ=1 D TASK G EX
RTN     ;
        S ONCOQUIT=0,ONCIOST=IOST
        I PCEABS'=1 F ONCX=0:0 S ONCX=$O(^ONCO(165.5,"APCE",PCESEL,ONCX)) Q:ONCX'>""  I $$DIV^ONCFUNC(ONCX)=DUZ(2) S ONCODA=ONCX D PRINT Q:$G(Y)=0
        I PCEABS=1 F ONCX=0:0 S ONCX=$O(^ONCO(165.5,"APCE",PCESEL,ONCX)) Q:ONCX'>""!ONCOQUIT  I $$DIV^ONCFUNC(ONCX)=DUZ(2) D
        .S ONCODA=ONCX,PRTPCE=1
        .S ONCOIEN=ONCX D MULT^ONCOPA1
        .Q
        G END
PCEVARS ;SET VARIABLES NEEDED TO PRINT THE PCE(S).
        N PATNAM K DASHES S $P(DASHES,"-",80)="-"
        S D0=ONCODA,NODE0=^ONCO(165.5,D0,0)
        S S=$P(NODE0,U,1),SITEGP=$P(^ONCO(164.2,S,0),U,1),DATEDX=$P(NODE0,U,16)
        S Y=$P(NODE0,U,2),C=$P(^DD(165.5,.02,0),U,2) D Y^DIQ S PATNAM=Y
        S SAVED0=D0 S D0=$P(NODE0,U,2) D SSN^ONCOES S SSN=X,D0=SAVED0
        S TOP=$P($G(^ONCO(165.5,D0,2)),U,1),TOPCOD="",TOPNAM=""
        I TOP'="" S TOPNAM=$P(^ONCO(164,TOP,0),U,1),TOPCOD=$P(^ONCO(164,TOP,0),U,2)
        S TOPTAB=79-$L(TOPNAM_" "_TOPCOD),TTAB=79-$L(TOPCOD)
        S STGP=$P($G(^ONCO(165.5,ONCODA,0)),U,1)
        S STGPNM=$P($G(^ONCO(164.2,STGP,0)),U,1),SITTAB=79-$L(STGPNM)
        S NOS=TOPTAB-$L(PATNAM),NOS=NOS-1 K SPACES S $P(SPACES," ",NOS)=" "
        S ONCONUM=D0,ONCOPA=$P(NODE0,U,2)
        Q
        ;
ESPD    ;Exclude sensitive patient data
        N DIR,X,Y
        W !
        S DIR("A")=" Exclude sensitive patient data"
        S DIR(0)="Y",DIR("B")="No" D ^DIR
        S ESPD=Y
        Q
        ;
TASK    ;Queue a task
        K IO("Q"),ZTUCI,ZTDTH,ZTIO,ZTSAVE
        S ZTRTN="RTN^ONCOGEN"
        S ZTREQ="@",ZTSAVE("ZTREQ")="",ZTSAVE("ONCODA")="",ZTSAVE("PCESEL")=""
        S ZTSAVE("DATEDX")="",ZTSAVE("PCEABS")="",ZTSAVE("ONCOIO")=""
        S ZTSAVE("ONCQ")="",ZTDESC="Print PCE Data"
        D ^%ZTLOAD W !,"Request Queued",!
        K ZTDESC,ZTREQ,ZTRTN,ZTSAVE
        Q
