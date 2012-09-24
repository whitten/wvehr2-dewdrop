SCRPW26 ;RENO/KEITH - ACRP Ad Hoc Report (cont.) ; 18 Nov 98  3:31 PM
        ;;5.3;Scheduling;**144,166,370,461,559**;AUG 13, 1993;Build 10
RPT     I '$D(ZTQUEUED),$E(IOST)="C" D WAIT^DICD
        D BLD^SCRPW21 S SDXY=^%ZOSF("XY")
        F SDI="DSV","M1","MASTER","TOT","RPT","DET","RPTAP","RPTDX","RPTTAP","RPTTDX" K ^TMP("SCRPW",$J,SDI)
        S T="~",(SDSTOP,SDOUT)=0,SDT=$P(SDPAR("L",1),U),SDO(1)=$P(SDPAR("O",1),U) F SDI=1:1:6 S SDF(SDI)=$P($G(SDPAR("F",SDI)),U)
        S SDI=2 F  S SDI=$O(SDPAR("L",SDI)) Q:'SDI  S SDX=$P(SDPAR("L",SDI),U)_$P(SDPAR("L",SDI,1),U),SDPAR("LPX",SDX,SDI)=""
        S SDYR=1,SDEDT=$P(SDPAR("L",2),U)+.999999 D R0 G:SDOUT RX
        I SDF(2) S SDT=$P(SDPAR("L",1),U)-10000,SDEDT=SDEDT-10000,SDYR=2 D R0 G:SDOUT RX
        I SDF(5)>0 D R6 G:SDOUT RX
        F SDI="TOT","RPT" Q:SDOUT  D R7,STOP
        G:SDOUT RX D R8,STOP G:SDOUT RX G PRT^SCRPW27
        ;
RX      G EXIT^SCRPW27
        ;
STOP    ;Check for stop task request
        S:$D(ZTQUEUED) (SDOUT,ZTSTOP)=$S($$S^%ZTLOAD:1,1:0) Q
        ;
R0      F  S SDT=$O(^SCE("B",SDT)) Q:'SDT!(SDT>SDEDT)!SDOUT  S SDOE=0 F  S SDOE=$O(^SCE("B",SDT,SDOE)) Q:'SDOE!SDOUT  S SDOE0=$$GETOE^SDOE(SDOE) I $P(SDOE0,U,2),$P(SDOE0,U,4),'$P(SDOE0,U,6) D R1
        Q
R1      ;Evaluate perspective
        S SDSTOP=SDSTOP+1 D:SDSTOP#3000=0 STOP Q:SDOUT
        ;CHECK FOR TEST PATIENT
        I $D(^DPT("ATEST",$P(SDOE0,U,2))) Q
        K SDPER Q:'$$EVAL("P",1)  M SDPER=SDX
R2      ;Evaluate limitations
        ; SD*5.3*559 fixes bug whereby if 2 exclude lists are included for the same Limitation, 2nd exclude is essentially ignored, i.e., Limitation: OE/DV/Exclude list and Limitation: OE/ST/Exclude list.
        N SDXPAR,SDXPAR1,SDNN,SDFLAG,SDSAVE
        S (SDXPAR,SDXPAR1)="",SDNN=2,SDFLAG=1,SDSAVE=0
        I $O(SDPAR("L",SDNN)) S SDNN=$O(SDPAR("L",SDNN)) S:SDNN SDXPAR=$G(SDPAR("L",SDNN)) I SDNN S SDN1=0,SDN1=$O(SDPAR("L",SDNN,SDN1)) S:SDN1 SDXPAR1=$G(SDPAR("L",SDNN,SDN1))  ; SD*559 added 2nd IF and what follows it
        S SDFOUND=1,SDS2=2 F  S SDS2=$O(SDPAR("L",SDS2)) Q:'SDS2  D
        . I $D(SDXPAR) S:SDXPAR'=$G(SDPAR("L",SDS2)) SDFLAG=0
        . I $D(SDXPAR1) S SDN11=0,SDN11=$O(SDPAR("L",SDS2,SDN11)) I SDN11 S:SDXPAR1'=$G(SDPAR("L",SDS2,SDN11)) SDFLAG=0  ; SD*559 added
        . S:SDFLAG SDFOUND=1
        . S:'$$EVAL("L",SDS2) SDFOUND=0
        . I SDFOUND I SDFLAG S SDSAVE=1
        . I 'SDFLAG I 'SDFOUND S SDSAVE=0
        S:SDSAVE SDFOUND=SDSAVE
        Q:'SDFOUND  S (SDTOT,SDI)=0 F  S SDI=$O(SDPER(SDI)) Q:'SDI  S SDPER=SDPER(SDI) S:$G(SDPAR("P",1,6))="D" SDPER=$P(SDPER,U,2)_U_$P(SDPER,U) D R3
        K SDXPAR,SDXPAR1,SDNN,SDN1,SDN11,SDFLAG
        Q
        ;
R3      S DFN=$P(SDOE0,U,2)
        S:'SDTOT ^TMP("SCRPW",$J,"TOT",SDYR,1,1,DFN,$P(SDT,"."))="",^TMP("SCRPW",$J,"TOT",SDYR,1,1,"ENC")=$G(^TMP("SCRPW",$J,"TOT",SDYR,1,1,"ENC"))+1,SDTOT=1
        S ^TMP("SCRPW",$J,"M1",$P(SDPER,U,2),$P(SDPER,U))=""
        S ^TMP("SCRPW",$J,"RPT",SDYR,$P(SDPER,U,2),$P(SDPER,U),DFN,$P(SDT,"."))="",^TMP("SCRPW",$J,"RPT",SDYR,$P(SDPER,U,2),$P(SDPER,U),"ENC")=$G(^TMP("SCRPW",$J,"RPT",SDYR,$P(SDPER,U,2),$P(SDPER,U),"ENC"))+1
        I $L(SDF(3)),"EB"[SDF(3) S SDPNAM=$P($G(^DPT(DFN,0)),U) I $L(SDPNAM) S ^TMP("SCRPW",$J,"DET",$$DSV(SDPER),SDPNAM,DFN,$P(SDT,"."),SDT,SDOE)=$P(SDOE0,U,4)
        Q:(SDF(5)<1)!(SDYR=2)
        D APAC^SCRPW24(.SDX) S SDII=0 F  S SDII=$O(SDX(SDII)) Q:'SDII  D R4
        D DXPD^SCRPW24(.SDX) S SDII=0 F  S SDII=$O(SDX(SDII)) Q:'SDII  D R5(1)
        D DXSD^SCRPW24(.SDX) S SDII=0 F  S SDII=$O(SDX(SDII)) Q:'SDII  D R5(2)
        Q
        ;
R4      S SDX=SDX(SDII) Q:$P(SDX,U)="~~~NONE~~~"  S SDQT=$P(SDX,U,3) S:'SDQT SDQT=1
        S ^TMP("SCRPW",$J,"RPTAP",SDYR,$P(SDPER,U,2),$P(SDPER,U),$P(SDX,U,2))=$G(^TMP("SCRPW",$J,"RPTAP",SDYR,$P(SDPER,U,2),$P(SDPER,U),$P(SDX,U,2)))+SDQT Q
        ;
R5(SDZ) S SDX=SDX(SDII) Q:$P(SDX,U)="~~~NONE~~~"
        F SDIII=SDZ,3 S $P(^TMP("SCRPW",$J,"RPTDX",SDYR,$P(SDPER,U,2),$P(SDPER,U),$P(SDX,U,2)),U,SDIII)=$P($G(^TMP("SCRPW",$J,"RPTDX",SDYR,$P(SDPER,U,2),$P(SDPER,U),$P(SDX,U,2))),U,SDIII)+1
        Q
        ;
DSV(SDPER)      ;Encrypt detail sort values
        N SDX S SDX=$G(^TMP("SCRPW",$J,"DSV",$P(SDPER,U,2),$P(SDPER,U))) Q:SDX SDX
        S (SDX,^TMP("SCRPW",$J,"DSV",0))=$G(^TMP("SCRPW",$J,"DSV",0))+1
        S ^TMP("SCRPW",$J,"DSV",$P(SDPER,U,2),$P(SDPER,U))=SDX Q SDX
        ;
R6      S SDS1="" F  S SDS1=$O(^TMP("SCRPW",$J,"RPTAP",SDS1)) Q:SDS1=""  S SDS2="" F  S SDS2=$O(^TMP("SCRPW",$J,"RPTAP",SDS1,SDS2)) Q:SDS2=""  D R6A
        D STOP Q:SDOUT
        S SDS1="" F  S SDS1=$O(^TMP("SCRPW",$J,"RPTDX",SDS1)) Q:SDS1=""  S SDS2="" F  S SDS2=$O(^TMP("SCRPW",$J,"RPTDX",SDS1,SDS2)) Q:SDS2=""  D R6B
        D STOP Q
        ;
R6A     S SDS3="" F  S SDS3=$O(^TMP("SCRPW",$J,"RPTAP",SDS1,SDS2,SDS3)) Q:SDS3=""  S SDS4="" F  S SDS4=$O(^TMP("SCRPW",$J,"RPTAP",SDS1,SDS2,SDS3,SDS4)) Q:SDS4=""  D R6AS
        Q
R6AS    S SDQT=^TMP("SCRPW",$J,"RPTAP",SDS1,SDS2,SDS3,SDS4),^TMP("SCRPW",$J,"RPTTAP",SDS1,SDS2,SDS3,SDQT,SDS4)=""
        Q
        ;
R6B     S SDS3="" F  S SDS3=$O(^TMP("SCRPW",$J,"RPTDX",SDS1,SDS2,SDS3)) Q:SDS3=""  S SDS4="" F  S SDS4=$O(^TMP("SCRPW",$J,"RPTDX",SDS1,SDS2,SDS3,SDS4)) Q:SDS4=""  D R6BS
        Q
R6BS    S SDQT=$P(^TMP("SCRPW",$J,"RPTDX",SDS1,SDS2,SDS3,SDS4),U,3),^TMP("SCRPW",$J,"RPTTDX",SDS1,SDS2,SDS3,SDQT,SDS4)=""
        Q
        ;
R7      S SDYR=0 F  S SDYR=$O(^TMP("SCRPW",$J,SDI,SDYR)) Q:'SDYR  S SDS1="" F  S SDS1=$O(^TMP("SCRPW",$J,SDI,SDYR,SDS1)) Q:SDS1=""  S SDS2="" F  S SDS2=$O(^TMP("SCRPW",$J,SDI,SDYR,SDS1,SDS2)) Q:SDS2=""  D R7A
        Q
        ;
R7A     S DFN=0 F  S DFN=$O(^TMP("SCRPW",$J,SDI,SDYR,SDS1,SDS2,DFN)) Q:'DFN  S ^TMP("SCRPW",$J,SDI,SDYR,SDS1,SDS2,"UNI")=$G(^TMP("SCRPW",$J,SDI,SDYR,SDS1,SDS2,"UNI"))+1 D R7B
        Q
        ;
R7B     S SDT=0 F  S SDT=$O(^TMP("SCRPW",$J,SDI,SDYR,SDS1,SDS2,DFN,SDT)) Q:'SDT  S ^TMP("SCRPW",$J,SDI,SDYR,SDS1,SDS2,"VIS")=$G(^TMP("SCRPW",$J,SDI,SDYR,SDS1,SDS2,"VIS"))+1
        Q
        ;
R8      S SDORD=$E($P(SDPAR("O",1),U,2),1,3),SDS1="" F  S SDS1=$O(^TMP("SCRPW",$J,"M1",SDS1)) Q:SDS1=""  S SDS2="" F  S SDS2=$O(^TMP("SCRPW",$J,"M1",SDS1,SDS2)) Q:SDS2=""  D R8A
        Q
R8A     S SDORDV=$S(SDORD="ALP":SDS1,1:+$G(^TMP("SCRPW",$J,"RPT",1,SDS1,SDS2,SDORD))),^TMP("SCRPW",$J,"MASTER",SDORDV,SDS1,SDS2)="" Q
        ;
EVAL(SDS1,SDS2) ;Evaluate item
        D GID(SDS1,SDS2) K SDX X $P(SD(1),T,7)
        I SDS1="P",SDF(1)="S" D EVIL Q $D(SDX)>1
        D EV0(SDS1,SDS2) D:SDS1="P" EVIL
        Q $D(SDX)>1
        ;
EV0(SDS1,SDS2)  N X,Y,SDR1,SDR2,SDZ S SDZ=SD(3)="E",SDI=0 F  S SDI=$O(SDX(SDI)) Q:'SDI  S X=$P(SDX(SDI),U) D EV1
        Q
        ;
EV1     I "LN"[SD(2) K:('SDZ&'$D(SDPAR(SDS1,SDS2,5,X))) SDX(SDI) K:(SDZ&$D(SDPAR(SDS1,SDS2,5,X))) SDX Q
        S Y=$S(SD(6)="D":1,+$P(SDX(SDI),U,2)=$P(SDX(SDI),U,2):1,1:0),SDR1=$O(SDPAR(SDS1,SDS2,(4+Y),"")),SDR2=$O(SDPAR(SDS1,SDS2,(4+Y),""),-1)
        I Y S:(SD(6)="D"&(SDR2#1=0)) SDR2=SDR2+.9999 K:('SDZ&(X<SDR1!(X>SDR2))) SDX(SDI) K:(SDZ&(X'<SDR1&(X'>SDR2))) SDX Q
        I SD(0)="DXAD" S X=$P(SDX(SDI),U,2) D DXRNGE Q  ;SD*5.3*559
        S X=$P(SDX(SDI),U,2) K:('SDZ&(SDR1]X!(X]SDR2))) SDX(SDI) K:(SDZ&(SDR1']X&(X']SDR2))) SDX Q
        ;
EVIL    ;Evaluate item limitations
        N SDS2 I $D(SDX)>1 S S1=SD(0),S2=$P(SD(1),T,10) F S0=S1,S2 I $L(S0) S SDS2=0 F  S SDS2=$O(SDPAR("LPX",S0,SDS2)) Q:'SDS2  D GID("L",SDS2),EV0("L",SDS2)
        Q
        ;
GID(SDS1,SDS2)  ;Get item data
        ;Required input: SDS1,SDS2=subscript values in SDPAR array.
        K SD
        S SD(0)=$P(SDPAR(SDS1,SDS2),U)_$P(SDPAR(SDS1,SDS2,1),U),SD(1)=^TMP("SCRPW",$J,"ACT",SD(0))
        F SDI=2,3,6 S SD(SDI)=$P($G(SDPAR(SDS1,SDS2,SDI)),U)
        Q
        ;
DXRNGE  ; added per SD*5.3*461
        N SDFLG1,SDS22,SDS23
        S SDFLG1=0
        S SDS22=2
        F  S SDS22=$O(SDPAR(SDS1,SDS22)) Q:'SDS22  D
        .S SDS23=1,SDS23=$O(SDPAR(SDS1,SDS22,SDS23)) Q:'SDS23  Q:$P($G(SDPAR(SDS1,SDS22,SDS23)),U,1)'="R"   ;SD*5.3*559 Quit if 2nd limitation for DX List
        .S SDR1=$O(SDPAR(SDS1,SDS22,(4+Y),"")),SDR2=$O(SDPAR(SDS1,SDS22,(4+Y),""),-1)
        .I ('SDZ&(SDR1']X&(X']SDR2))) S SDFLG1=1
        K:'SDFLG1 SDX(SDI)
        K SDFLG1,SDS22,SDS23
        Q
        ;
TEST    K DIC,DIR D BLD^SCRPW21 S DIC="^SCE(",DIC(0)="AEMQZ" D ^DIC Q:$D(DTOUT)!$D(DUOUT)  Q:'Y  S SDOE=+Y,SDOE0=Y(0),T="~",DIR(0)="E"
        S SDI="" F  S SDI=$O(^TMP("SCRPW",$J,"ACT",SDI)) Q:SDI=""  S SDA=^TMP("SCRPW",$J,"ACT",SDI) W !!,$P(SDA,T) D TEST1 W ! ;D ^DIR Q:'Y
        D R1
        Q
TEST1   X $P(SDA,T,7) S SDII="" F  S SDII=$O(SDX(SDII)) Q:'SDII  W !?5,SDX(SDII)
        Q
        ;
INTRO   ;Intro. text
        W !!?10,"This report can be used to produce information from the ACRP",!?10,"databases in a variety of ways.  Parameter selection will",!?10,"determine how to count and screen the information."
        W !!?10,"The report user is prompted for report parameters in the",!?10,"following categories:",!!?10,$$XY^SCRPW20(IORVON),"FORMAT",$$XY^SCRPW20(IORVOFF)," - determines the style of report to be printed."
        W !!?10,$$XY^SCRPW20(IORVON),"PERSPECTIVE",$$XY^SCRPW20(IORVOFF)," - the element that the report will be organized",!?10,"and sub-totaled by."
        W !!?10,$$XY^SCRPW20(IORVON),"LIMITATIONS",$$XY^SCRPW20(IORVOFF)," - elements that can be used to narrow the scope"
        W !?10,"of the report to only include (or exclude) specified data.",!!?10,$$XY^SCRPW20(IORVON),"OUTPUT ORDER, PRINT FIELDS",$$XY^SCRPW20(IORVOFF)," - determines the order of output;"
        W !?10,"allows selection of print fields for detailed patient lists." Q
