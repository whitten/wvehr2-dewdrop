HLCSRPT3        ;ISC-SF/RAH-TRANS LOG MESSAGE SEARCH ;08/25/2010
        ;;1.6;HEALTH LEVEL SEVEN;**50,57,145,151**;Oct 13, 1995;Build 1
        ;Per VHA Directive 2004-038, this routine should not be modified.
        ;
        Q
ADVSRCH ; Entry point for message search. (from HLCSRPT)
        S (HLCSLS,HLSCES,HLCSSC)=0
        D GETTIME Q:$D(STOP)
        D DT2IEN Q:$D(STOP)
        D STATCHK Q:$D(STOP)
        D LNKSRCH Q:$D(STOP)
        D EVNSRCH Q:$D(STOP)
        D SEARCH
        D EXIT
        S STOP=1
        Q
GETTIME ;
        W @IOF,! S HLCSHDR="Start/Stop Time Selection" D HLCSBAR
GETSTART        ;
        W !!,"  Enter START Date and Time. Date is required.",!
        S DIR(0)="D^::AEPSTX",DIR("?")="^D HELP^%DTC",DIR("B")="T"
        D ^DIR S:$D(DIRUT)!(X="") STOP=1 I $D(STOP) K DIR,X,Y Q
        I Y'["." S Y=Y_".000001"
        S HLCSST=Y K DIR,X,Y
GETEND  ;
        W !!,"  Enter END Date and Time. Date is required.",!
        S DIR(0)="D^::AESTX",DIR("?")="^D HELP^%DTC",DIR("B")="NOW"
        D ^DIR S:$D(DIRUT)!(X="") STOP=1 I $D(STOP) K DIR,X,Y Q
        I Y'["." S Y=Y_".235959"
        S HLCSET=Y K DIR,X,Y
        Q
        ;
DT2IEN  ;
        ;set variable to HLCSST-.0000001
        ;$O thru ^HL(772,"B",dt)
        ;get ien from "B" xref. 
        ; that's starting value for $O(^HLMA("B",772ien,ien))
        S HLCSI=HLCSST-.0000001
        S HLCSI=$O(^HL(772,"B",HLCSI))
        I HLCSI="" S STOP=1 W !!,HLCSNREC,!! S DIR(0)="E" D ^DIR K DIR Q
        S HLCSJ=0 S HLCSJ=$O(^HL(772,"B",HLCSI,HLCSJ))
        S HLCSST=HLCSJ
        ;set variable to HLCSET+.0000001
        ;reverse $O thru ^HL(772,"B",dt)
        ;get ien fron "B" xref.
        ;that's ending value for the $O thru ^HLMA("B"
        S HLCSI=HLCSET+.0000001
        S HLCSI=$O(^HL(772,"B",HLCSI),-1)
        S HLCSJ="Z" S HLCSJ=$O(^HL(772,"B",HLCSI,HLCSJ),-1)
        S HLCSET=HLCSJ
        Q
        ;
DISPLAY ; common display method
        ; clean-up here
        S HLCSPTR=$P(^TMP("TLOG",$J,1)," "),HLCSK=$O(^HLMA("C",HLCSPTR,0))
        S HLCSPTR=+$P($G(^HLMA(+HLCSK,0)),U)
        I VERS22'="YES" D DOCLIST^DDBR("^TMP($J,""LIST"")","NR")
        E  D BROWSE^DDBR("^TMP(""TLOG"",$J)","NA",HLCSTITL)
        Q
        ;
SEARCH  ;
        W !!," . . . PLEASE WAIT, THIS CAN TAKE AWHILE . . .",!
        S HLCSI=HLCSST-.1 S HLCSLN=0
        F I=HLCSST:1:HLCSET S HLCSI=$O(^HLMA("B",HLCSI)) Q:HLCSI>HLCSET!(HLCSI="")  D
        . S HLCSN=HLCSI,HLCSJ=0 F  S HLCSJ=$O(^HLMA("B",HLCSI,HLCSJ)) Q:(HLCSJ="")  D
        .. Q:'$D(^HLMA(HLCSJ,0))  S HLCSX=^(0),HLCSDTP=$P($G(^("S")),U)
        .. ;must have a status
        .. Q:'$G(^HLMA(HLCSJ,"P"))  S HLCSSTC=$P(^("P"),U)
        .. ;check for only one status, if not the status we want, quit
        .. I HLCSSC=1,(HLCSTSTC'=HLCSSTC) Q
        .. S HLCSLINK=$P(HLCSX,U,7) S HLCSLNK="          "
        .. I HLCSLINK'="",($D(^HLCS(870,HLCSLINK,0))) S HLCSLNK=$P(^HLCS(870,HLCSLINK,0),U,1)
        .. ; patch HL*1.6*145 start
        .. ; S HLCSEVN1=$P(HLCSX,U,13) I HLCSEVN1'="",($D(^HL(771.2,HLCSEVN1,0))) S HLCSEVN1=$P(^HL(771.2,HLCSEVN1,0),U,1)
        .. ; S HLCSEVN2=$P(HLCSX,U,14) I HLCSEVN2'="",($D(^HL(779.001,HLCSEVN2,0))) S HLCSEVN2=$P(^HL(779.001,HLCSEVN2,0),U,1)
        .. N SEG
        .. D HEADSEG^HLCSRPT1(HLCSJ,.SEG)
        .. S HLCSEVN1=$G(SEG("MESSAGE TYPE"))
        .. S HLCSEVN2=$G(SEG("EVENT TYPE"))
        .. ; patch HL*1.6*145 end
        .. I HLCSEVN1="" S HLCSEVN1="   "
        .. I HLCSEVN2="" S HLCSEVN2="   "
        .. I $L(HLCSEVN1)<3 S HLCSEVN1=HLCSEVN1_"   ",HLCSEVN1=$E(HLCSEVN1,1,3)
        .. I $L(HLCSEVN2)<3 S HLCSEVN2=HLCSEVN2_"   ",HLCSEVN2=$E(HLCSEVN2,1,3)
        .. S HLCSEVN=HLCSEVN1_":"_HLCSEVN2
        .. I HLCSLS>0,(HLCSTLNK'=HLCSLNK) Q
        .. I HLCSES>0,(HLCSES1=1)&(HLCSTEV1'=HLCSEVN1) Q
        .. I HLCSES>0,(HLCSES2=2)&(HLCSTEV2'=HLCSEVN2) Q
        .. I HLCSSC=1,(HLCSTSTC'=HLCSSTC) Q
        .. D FORMAT
        .. Q
        . Q
        I '$D(^TMP("TLOG",$J,1)) W !!,HLCSNREC,!! S DIR(0)="E" D ^DIR K DIR Q
        I VERS22'="YES" S HLCSTITL="IEN RECORD #   MESSAGE ID #         Log Link   Msg:Evn IO Sndg Apl Rcvr Apl HDR"
        E  S HLCSTITL="MESSAGE ID #         D/T Entered   Log Link   Msg:Evn IO Sndg Apl Rcvr Apl     "
        I VERS22'="YES" D FAKR^HLCSRPT1
        D DISPLAY K ^TMP("TLOG",$J)
        Q
        ;
LNKSRCH ; Report all messages on A logical link between start and end date/time
        W ! ;S HLCSHDR="Logical Link Selection" D HLCSBAR
        S DIR(0)="PAO^870:AERO",DIR("A")="Select Logical Link for Report:  ALL//"
        D ^DIR S:($D(DUOUT)!$D(DTOUT)) STOP=1 Q:$D(STOP)
        I X'="",(Y=-1) W !,X_" NOT VALID " K X,Y G LNKSRCH
        I X="" S HLCSLS=0 K DIR,X,Y Q
        S HLCSLNK=$P(Y,U,2),HLCSTLNK=HLCSLNK K DIR,X,Y
        S HLCSLS=1
        Q
        ;
EVNSRCH ; Reports matching Message and Event Types for a logical link.
        W ! ;S HLCSHDR="Message/Event Type Search" D HLCSBAR
        S HLCSES1=1,HLCSES2=2
        S DIR(0)="PAO^771.2:AEO",DIR("A")="Select Message Type for Report:  ALL//"
        D ^DIR S:$D(DUOUT)!($D(DTOUT)) STOP=1 Q:$D(STOP)
        I X'="",(Y=-1) W !,X_" NOT VALID " K X,Y G EVNSRCH
        I X="" S Y="^",HLCSES1=0
        S HLCSTEV1=$P(Y,U,2) K DIR,X,Y
        W !
        S DIR(0)="PAO^779.001:AEO",DIR("A")="Select Event Type for Report:  ALL//"
        D ^DIR S:$D(DUOUT)!($D(DTOUT)) STOP=1 Q:$D(STOP)
        I X'="",(Y=-1) W !,X_" NOT VALID " K X,Y G EVNSRCH
        I X="" S Y="^",HLCSES2=0
        S HLCSTEV2=$P(Y,U,2) K DIR,X,Y
        I HLCSTEV1="" S HLCSTEV1="   "
        I HLCSTEV2="" S HLCSTEV2="   "
        S HLCSTEVN=HLCSTEV1_":"_HLCSTEV2,HLCSES=+HLCSES1+(+HLCSES2)
        Q
        ;
STATCHK ; Determine whether a specific stauts is desired.
        W @IOF,! S HLCSHDR="Message Criteria for Search" D HLCSBAR
        S HLCSSC=1
        S DIR(0)="PAO^771.6:AEO",DIR("A")="Select Status Code for Report:  ALL//"
        D ^DIR S:$D(DUOUT)!($D(DTOUT)) STOP=1 Q:$D(STOP)
        I X'="",(Y=-1) W !,X_" NOT VALID " K DIR,X,Y G STATCHK
        I X="" S Y="^",HLCSSC=0 K DIR,X,Y Q
        S HLCSTAT=$P(Y,U,2),HLCSTSTC=$P(Y,U,1)
        K DIR,X,Y
        Q
FORMAT  ; Format a report line
        S HLCSY=""
        S HLCSRNO=HLCSJ,SPACE20="                    "
        I VERS22'="YES" D
        . S HLCSRNO=HLCSRNO_SPACE20 S HLCSRNO=$E(HLCSRNO,1,14) S HLCSY=HLCSRNO_" "
        . S HLCSMID=$P(HLCSX,U,2),HLCSMX=HLCSMID,HLCSPTR=$P(HLCSX,U,1)
        . S HLCSMID=HLCSMID_SPACE20 S HLCSMID=$E(HLCSMID,1,20)
        . S HLCSY=HLCSY_HLCSMID_" "
        I VERS22="YES" D
        . S HLCSMID=$P(HLCSX,U,2),HLCSMX=HLCSMID,HLCSPTR=$P(HLCSX,U,1)
        . S HLCSMID="$.%$CREF$^TMP($J,""MESSAGE"","_HLCSRNO_")$CREF$^"_HLCSMX_"$.%"
        . S Y=$L(HLCSMX),X=$E(SPACE20,1,20-Y) S HLCSMID=HLCSMID_X K X,Y
        . S HLCSY=HLCSMID_" "
        . S HLCSDTE=$P(HLCSX,U,1)
        . S HLCSDTE=$P(^HL(772,HLCSDTE,0),U,1)
        . S YR=$E(HLCSDTE,2,3),MO=$E(HLCSDTE,4,5),DAY=$E(HLCSDTE,6,7)
        . S HLCSDTE=MO_DAY_YR_"."_$P(HLCSDTE,".",2)
        . S HLCSDTE=HLCSDTE_SPACE20,HLCSDTE=$E(HLCSDTE,1,14)
        . S HLCSY=HLCSY_HLCSDTE_" "
        S HLCSY=HLCSY_$E(HLCSLNK_SPACE20,1,10)_" "
        S HLCSY=HLCSY_HLCSEVN_" "
        S HLCSTYP=$P(HLCSX,U,3) S:HLCSTYP="O" HLCSTYP="OT" S:HLCSTYP="I" HLCSTYP="IN"
        S HLCSY=HLCSY_$E(HLCSTYP_SPACE20,1,2)_" "
        S HLCSSRVR=$P(HLCSX,U,11) I HLCSSRVR'="" S HLCSSRVR=$P(^HL(771,HLCSSRVR,0),U,1)
        S HLCSY=HLCSY_$E(HLCSSRVR_SPACE20,1,8)_" "
        S HLCSCLNT=$P(HLCSX,U,12) I HLCSCLNT'="" S HLCSCLNT=$P(^HL(771,HLCSCLNT,0),U,1)
        S HLCSY=HLCSY_$E(HLCSCLNT_SPACE20,1,8)
        S HLCSLN=HLCSLN+1
        I VERS22'="YES" S HLCSY=HLCSY_" " I $D(^HLMA(HLCSJ,"MSH",1,0)) S HLCSY=HLCSY_^HLMA(HLCSJ,"MSH",1,0)
        S ^TMP("TLOG",$J,HLCSLN)=HLCSY
        I VERS22="YES" S ^TMP($J,"MESSAGE",HLCSJ)="$XC$^D SHOWMSG^HLCSRPT1("_HLCSJ_","_HLCSPTR_")$XC$^MESSAGE"
        Q
        ;
HLCSBAR ; Center Title on Top Line of Screen
        W RVON,?(80-$L(HLCSHDR)\2),HLCSHDR,$E(SPACE,$X,77),RVOFF,!
        Q
        ;
EXIT    ;
        Q
        ;
