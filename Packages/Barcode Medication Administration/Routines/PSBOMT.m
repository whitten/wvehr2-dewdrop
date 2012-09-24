PSBOMT  ;BIRMINGHAM/TEJ-BCMA MEDICATION THERAPY REPORT ;Mar 2004
        ;;3.0;BAR CODE MED ADMIN;**32,50**;Mar 2004;Build 78
        ;Per VHA Directive 2004-038 (or future revisions regarding same), this routine should not be modified.
        ;
        ; Reference/IA
        ; File 50.7/2880
        ; File 52.6/436
        ; File 52.7/437
        ; File 200/10060
        ; EN^PSJBCMA1/2829
        ; IEN^PSN50P65/4543
        ; DRGIEN^PSS50P7/4662
        ; VAC^PSS50/4533
        ; ^PSDRUG(/221 
EN      ;
        N PSBHDR,PSBORDS,PSBORD,PSBOIP
        N TMP
        K TMP("PSBOIS",$J),TMP("VA CLASS",$J),TMP("PSBADDS",$J),TMP("PSBSOLS",$J),PSBLGD,PSBOIL,PSBDDL,PSBSOLL,PSBADDL
        S PSBCLSS=0,PSBCFLG=0
        S PSBXDFN=$P(PSBRPT(.1),U,2)
        S PSBSTRT=$P(PSBRPT(.1),U,6)+$P(PSBRPT(.1),U,7),PSBSTOP=$P(PSBRPT(.1),U,8)+$P(PSBRPT(.1),U,9)
        K PSBOCRIT F Y=1:1:4 I $P(PSBRPT(.2),U,Y) S PSBOCRIT=$G(PSBOCRIT,"")_$P("C^P^OC^O",U,Y)_"^"
        D NOW^%DTC S (Y,PSBNOWX)=% D DD^%DT S PSBDTTM=$E(Y,1,18)
        S:+PSBSTRT'>0 PSBSTRT=$$FMADD^XLFDT(X,-1)
        S:+PSBSTOP'>0 PSBSTOP=$P(%,".")
        I $D(PSBRPT(.2)) I $P(PSBRPT(.2),U,8) S PSBCFLG=1
        I $D(PSBRPT(2)) F XD=$O(PSBRPT(2,0)):1:$O(PSBRPT(2,"B"),-1) S PSBRPT(2,XD,0)=$TR(PSBRPT(2,XD,0),"~",U) D:$P(PSBRPT(2,XD,0),U)="MT"
        .I $P(PSBRPT(2,XD,0),U,2)="OIT" D  Q
        ..S PSBSRCHL="ORDERABLE ITEM SEARCH LIST:",PSBOIL(+$P(PSBRPT(2,XD,0),U,3))=""
        ..S PSB=$P(PSBRPT(2,XD,0),U,3) F X=1:1:$L(PSB,",") Q:$P(PSB,",",X)=""  S (TMP("PSBOIS",$J,$P(PSB,",",X)),PSBOIP("OIP",$P(PSB,",",X)))=""
        .I $P(PSBRPT(2,XD,0),U,2)="ADD" D  Q
        ..S PSBSRCHL="IV MEDICATION SEARCH LIST:"
        ..I $D(^PSDRUG("A526",$P(PSBRPT(2,XD,0),U,3))) S X2=$O(^PSDRUG("A526",$P(PSBRPT(2,XD,0),U,3),"")) S PSBADDL(X2)="",TMP("PSBOIS",$J,$$OFROMA(X2))=""
        .I $P(PSBRPT(2,XD,0),U,2)="SOL" D  Q
        ..S PSBSRCHL="IV MEDICATION SEARCH LIST:"
        ..I $D(^PSDRUG("A527",$P(PSBRPT(2,XD,0),U,3))) S X2=$O(^PSDRUG("A527",$P(PSBRPT(2,XD,0),U,3),"")) S PSBSOLL(X2)="",TMP("PSBOIS",$J,$$OFROMS(X2))=""
        .I $P(PSBRPT(2,XD,0),U,2)="DD" D  K PSBDRGS Q
        ..S PSBSRCHL="DISPENSED DRUG SEARCH LIST:",PSBDDL($P(PSBRPT(2,XD,0),U,3))=""
        ..K PSBDRGS S PSBDRGS="" D OILST^PSBRPCMO(.PSBDRGS,$P(PSBRPT(2,XD,0),U,3),"UD")
        ..F X2=PSBDRGS(0):1:$O(PSBDRGS(""),-1) I +PSBDRGS(1)'<0 S TMP("PSBOIS",$J,$P(PSBDRGS(X2),U,4))=""
        .I $P(PSBRPT(2,XD,0),U,2)="VAC" D
        ..S PSBSRCHL="VA DRUG CLASS SEARCH LIST:"
        ..S PSBCLS=$P(PSBRPT(2,XD,0),U,3) D GETCLSS(PSBCLS) K PSBDDRG("VAC") M TMP("VA CLASS",$J,PSBCLS,"DDRG")=PSBDDRG K PSBDDRG
        ..S PSBCLSS=1
        M PSBOIP("OIP")=TMP("PSBOIS",$J)
        D OUT(PSBXDFN,PSBSTRT,PSBSTOP)
        Q
OUT(PSBXDFN,PSBSTRT,PSBSTOP)    ;
        D:PSBCLSS GETOIS  ; POSSBLE CLASS ITEMS VIA AVAIL ORDERS
        D GETADSO^PSBOMT1 ; ALL ADDS AND SOLS
        D FINDIENS^PSBOMT1 ; FIND ALL MED LOG ENTRS
        D PREOUT ;   WRIT TO GLOBL
        D WRITEOT
        D CLEANSUM^PSBOMT1
        D CLEANALL^PSBOMT1
        Q
GETOIS  ;
        K ^TMP("PSJ",$J),PSBTMP
        D EN^PSJBCMA(PSBXDFN,PSBSTRT)
        Q:^TMP("PSJ",$J,1,0)<0
        M PSBTMP=^TMP("PSJ",$J) K ^TMP("PSJ",$J)
        S X=0 F  S X=$O(PSBTMP(X)) Q:+X=0  D
        .Q:$G(PSBOCRIT,"")'[$P(PSBTMP(X,1),U,2)_"^"
        .S PSBORDN=$P(PSBTMP(X,0),U,3) S PSBORDS(PSBORDN)=""
        .I $D(PSBTMP(X,700)) D  Q
        ..F XX=1:1:PSBTMP(X,700,0) D
        ...S PSBCLS="" F  S PSBCLS=$O(TMP("VA CLASS",$J,PSBCLS)) Q:+PSBCLS=0  D
        ....I '$D(TMP("VA CLASS",$J,PSBCLS,"DDRG",$P(PSBTMP(X,700,XX,0),U))) Q
        ....S PSBORDS(PSBORDN,"DD",$P(PSBTMP(X,700,XX,0),U))=""
        ....S PSBORDS(PSBORDN,"OIP",$P(PSBTMP(X,3),U))=""
        ..M PSBOIP("OIP")=PSBORDS(PSBORDN,"OIP")
        .I $D(PSBTMP(X,850)) M PSBORDS(PSBORDN,"ADD")=PSBTMP(X,850) D
        ..F XX=1:1:PSBORDS(PSBORDN,"ADD",0) S PSBORDS(PSBORDN,"OIP",$$OFROMA($P(PSBORDS(PSBORDN,"ADD",XX,0),U)))=""
        ..M PSBOIP("OIP")=PSBORDS(PSBORDN,"OIP")
        .I $D(PSBTMP(X,950)) M PSBORDS(PSBORDN,"SOL")=PSBTMP(X,950) D
        ..F XX=1:1:PSBORDS(PSBORDN,"SOL",0) S PSBORDS(PSBORDN,"OIP",$$OFROMS($P(PSBORDS(PSBORDN,"SOL",XX,0),U)))=""
        ..M PSBOIP("OIP")=PSBORDS(PSBORDN,"OIP")
        K PSBTMP
        M TMP("PSBOIS",$J)=PSBOIP("OIP")
        Q
OFROMA(PSBADD)  ;OITEM FROM AN ADDITIVE
        S X1=$$GET1^DIQ(52.6,PSBADD_",",15,"I")
        I PSBCLSS D
        .S X2=$$GETDRN(X1)
        .S PSBCLS="" K X3 F  Q:$D(X3)  S PSBCLS=$O(TMP("VA CLASS",$J,PSBCLS)) Q:+PSBCLS=0  D
        ..I $D(TMP("VA CLASS",$J,PSBCLS,"DDRG",X2)) S X3=X1
        .I '$D(X3) S X3=0
        Q $G(X3,X1)
OFROMS(PSBSOL)  ;OITEM FROM A SOLUTION
        S X1=$$GET1^DIQ(52.7,PSBSOL_",",9,"I")
        I PSBCLSS D
        .S X2=$$GETDRN(X1)
        .S PSBCLS="" K X3 F  Q:$D(X3)  S PSBCLS=$O(TMP("VA CLASS",$J,PSBCLS)) Q:+PSBCLS=0  D
        ..I $D(TMP("VA CLASS",$J,PSBCLS,"DDRG",X2)) S X3=X1
        .I '$D(X3) S X3=0
        Q $G(X3,X1)
PREOUT  ;
        K PSBUNK S XDT="" F  S XDT=$O(TMP("PSBIENS",$J,XDT),-1) Q:XDT=""  S XIEN="",XIEN=$O(TMP("PSBIENS",$J,XDT,XIEN)) D
        .Q:$$NONSTS(PSBXDFN,XIEN)
        .S PSBIEN=XIEN
        .S PSBIENS=PSBIEN_","
        .D OUTPUT
        Q
OUTPUT  ;
        S PSBSPC=$J("",80)
        S W=$E($$GET1^DIQ(53.79,PSBIENS,.02)_PSBSPC,1,20)_" "
        S W=W_$S($P(^PSB(53.79,PSBIEN,0),U,9)="":"?? ",1:$E($P(^PSB(53.79,PSBIEN,0),U,9)_"  ",1,2)_" ")
        S:$P(^PSB(53.79,PSBIEN,0),U,9)="" PSBUNK=1
        S W=W_$E($P($G(^PSB(53.79,PSBIEN,.1)),U,2)_PSBSPC,1,2)_"  "
        S W=W_$E($E($$GET1^DIQ(53.79,PSBIENS,.06),1,18)_PSBSPC,1,21)_" "
        S W=W_$E($$GET1^DIQ(53.79,PSBIENS,"ACTION BY:INITIAL")_PSBSPC,1,10)_" ",PSBLGD("INITIALS",$$GET1^DIQ(53.79,PSBIENS,"ACTION BY","I"))=""
        S W=W_$$GET1^DIQ(53.79,PSBIENS,.16)
        D ADD(W)
        K PSBV
        F PSBNODE=.5,.6,.7 D
        .S PSBDD=$S(PSBNODE=.5:53.795,PSBNODE=.6:53.796,1:53.797)
        .F PSBY=0:0 S PSBY=$O(^PSB(53.79,PSBIEN,PSBNODE,PSBY)) Q:'PSBY  D
        ..I $$GET1^DIQ(53.79,PSBIENS,.11)["V" S PSBV=1
        ..D WRAPMEDS($$GET1^DIQ(PSBDD,PSBY_","_PSBIENS,.01),$$GET1^DIQ(PSBDD,PSBY_","_PSBIENS,.03),$$GET1^DIQ(PSBDD,PSBY_","_PSBIENS,.02),$$GET1^DIQ(PSBDD,PSBY_","_PSBIENS,.04))
        D PRNEFF
        I PSBCFLG=1 D COMNTS
        D ADD("")
        Q
PRNEFF  ;Add PRN Effectiveness to Medication theropy Report  - PSB*3*50
        N PSBPRN,PSBEIECMT,PSBLINE1,PSBLINE2
        S PSBEIECMT=""
        I $P($G(PSBRPT(.2)),U,8)=0,$D(^PSB(53.79,PSBIEN,.2)) S PSBEIECMT=$$PRNEFF^PSBO(PSBEIECMT,PSBIEN)
        I $D(^PSB(53.79,PSBIEN,.2)) D
        .D ADD("")
        .D ADD($J("",35)_"PRN Effectiveness: "_$$MAKELINE^PSBOMT1("-",78))
        .I $P(^PSB(53.79,PSBIEN,.2),U,2)'="" D
        ..S PSBPRN=$P(^PSB(53.79,PSBIEN,.2),U,2)
        .I $P(^PSB(53.79,PSBIEN,.2),U,2)="" S PSBPRN="<No PRN Effectiveness Entered>"
        .S PSBLINE1=$E(PSBPRN_PSBEIECMT,1,75),PSBLINE2=$E(PSBPRN_PSBEIECMT,76,245) D WRAP(PSBLINE2,PSBLINE1,PSBIEN)
        Q 
COMNTS  ;
        N Z,CNT
        S Z="",CNT=0
        I $D(^PSB(53.79,PSBIEN,.3,0)) D
        .D ADD("")
        .D ADD($J("",44)_"Comments: "_$$MAKELINE^PSBOMT1("-",78))
        .S XT="" F  S XT=$O(^PSB(53.79,PSBIEN,.3,XT)) Q:XT=""  I XT'=0  D
        ..D:CNT=1 ADD("")
        ..S Y=$P(^PSB(53.79,PSBIEN,.3,XT,0),"^",3) D DD^%DT S XBR=Y
        ..S Z=XBR_"   "_$P(^VA(200,$P(^PSB(53.79,PSBIEN,.3,XT,0),"^",2),0),"^",2)
        ..D WRAP($P(^PSB(53.79,PSBIEN,.3,XT,0),"^",1),Z,PSBIEN)
        ..S CNT=1
        .D ADD($J("",54)_$$MAKELINE^PSBOMT1("-",78))
        Q
WRAPMEDS(MED,UG,UO,UOA) ;
        ;THIS WILL CREATE UPTO 3 LINES
        S MED=$E(MED_$J("",40),1,40)
        N UGWRAP,ORWRAP
        S (CNTX,UOA1,UOA16,UOA31)=""
        I +$G(UG)?1"."1.N S UG=0_+UG
        I +$G(UO)?1"."1.N S UO=0_+UO
        I $G(PSBV,0) S UO="NA"
        F CNT=1:15:45  D
        .D PARSE^PSBOMT1(UOA,CNT)
        .S UGWRAP=$E(UG,CNT,(CNT+7)),UOWRAP=$E(UO,CNT,(CNT+7))
        .I CNT=1 D ADD($J("",55)_MED_" "_$$PAD^PSBOMT1(UOWRAP,8)_" "_$$PAD^PSBOMT1(UGWRAP,8)_"  "_$$PAD^PSBOMT1(UOA1,15))
        .I (CNT>1),($L(UGWRAP)>0!$L(@("UOA"_CNT))>0) D ADD($J("",94)_$$PAD^PSBOMT1(UOWRAP,8)_" "_$$PAD^PSBOMT1(UGWRAP,8)_"  "_$$PAD^PSBOMT1(@("UOA"_CNT),15))
        Q
HEADA   ;
        W !
        W "Location",?21,"St Sch Administration Date",?50,"By",?61,"Injection Site",?96,"Units",?104,"Units",?113,"Units of"
        W !,?55,"Medication & Dosage",?96,"Ordered",?104,"Given",?113,"Administration"
        W !
        W $$MAKELINE^PSBOMT1("-",132)
        Q
NONSTS(PSBX,PSBY)       ;
        D CLEAN^PSBVT,PSJ1^PSBVT(PSBX,$$GET1^DIQ(53.79,PSBY_",","ORDER REFERENCE NUMBER","I"))
        Q PSBOCRIT'[PSBSCHT_"^"
WRITEOT ;
        D HDR^PSBOMT1
        D MEDS
        D PT^PSBOHDR(PSBXDFN,.PSBHDR),HEADA
        I '$D(TMP("PSBIENS",$J)) D ADD("<<<< NO HISTORY FOUND FOR THIS TIME FRAME >>>>")
        S EX="" F  S EX=$O(^TMP("PSB",$J,EX)) Q:EX=""  D
        .I $Y>(IOSL-5) D
        ..W $$PTFTR^PSBOHDR()
        ..D PT^PSBOHDR(PSBXDFN,.PSBHDR),HEADA
        .W !,$G(^TMP("PSB",$J,EX))
        D:$D(TMP("PSBIENS",$J)) LEGEND^PSBOMT1
        D FTR^PSBOMT1
        Q
MEDS    ;
        N MED,XA,XB
        S MED="",XB=$O(PSBHDR(""),-1)+1
        S PSBHDR(XB)=PSBSRCHL
        I PSBCLSS S XA=0 K PSBGOT F  S XA=$O(TMP("VA CLASS",$J,XA)) Q:+XA=0  D
        .K ^TMP($J,"PSBLIST") D IEN^PSN50P65(XA,"??","PSBLIST")
        .I ^TMP($J,"PSBLIST",0)>0 S MED=^TMP($J,"PSBLIST",XA,1) Q:$D(PSBGOT(MED))  K ^TMP($J,"PSBLIST")
        .I $L(PSBHDR(XB)_" "_$G(MED," * NO DATA FOUND * "))+3>IOM D  Q
        ..S XB=XB+1,PSBHDR(XB)="                         / "_MED S PSBGOT(MED)=""
        .S PSBHDR(XB)=PSBHDR(XB)_$S(($L(PSBHDR(XB),":")=2)&($P(PSBHDR(XB),":",2)=""):" ",1:" / ")_MED,PSBGOT(MED)=""
        I $D(PSBOIL) S XA="" K PSBGOT F  S XA=$O(PSBOIL(XA)) Q:XA=""  D
        .S MED=$$GET1^DIQ(50.7,XA,.01) Q:$D(PSBGOT(MED))  S PSBGOT(MED)=""
        .I $L(PSBHDR(XB)_" / "_MED)+3>IOM D  Q
        ..S XB=XB+1,PSBHDR(XB)="                         / "_MED
        .S PSBHDR(XB)=PSBHDR(XB)_$S(($L(PSBHDR(XB),":")=2)&($P(PSBHDR(XB),":",2)=""):" ",1:" / ")_MED
        I $D(PSBADDL) S XA="" K PSBGOT F  S XA=$O(PSBADDL(XA)) Q:XA=""  D
        .S MED=$$GET1^DIQ(52.6,XA,.01) Q:$D(PSBGOT(MED))  S PSBGOT(MED)=""
        .I $L(PSBHDR(XB)_" / "_MED)+3>IOM D  Q
        ..S XB=XB+1,PSBHDR(XB)="                         / "_MED
        .S PSBHDR(XB)=PSBHDR(XB)_$S(($L(PSBHDR(XB),":")=2)&($P(PSBHDR(XB),":",2)=""):" ",1:" / ")_MED
        I $D(PSBSOLL) S XA="" K PSBGOT F  S XA=$O(PSBSOLL(XA)) Q:XA=""  D
        .S MED=$$GET1^DIQ(52.7,XA,.01) Q:$D(PSBGOT(MED))  S PSBGOT(MED)=""
        .I $L(PSBHDR(XB)_" / "_MED)+3>IOM D  Q
        ..S XB=XB+1,PSBHDR(XB)="                         / "_MED
        .S PSBHDR(XB)=PSBHDR(XB)_$S(($L(PSBHDR(XB),":")=2)&($P(PSBHDR(XB),":",2)=""):" ",1:" / ")_MED
        I $D(PSBDDL) S XA="" F  S XA=$O(PSBDDL(XA)) Q:XA=""  D
        .S MED=$$GET1^DIQ(50,XA,.01)
        .I $L(PSBHDR(XB)_" / "_MED)+3>IOM D  Q
        ..S XB=XB+1,PSBHDR(XB)="                         / "_MED
        .S PSBHDR(XB)=PSBHDR(XB)_$S(($L(PSBHDR(XB),":")=2)&($P(PSBHDR(XB),":",2)=""):" ",1:" / ")_MED
        Q
WRAP(SIZE,ZP,BRIEN)     ;
        D ADD($J("",55)_ZP)
        D ADD($J("",55)_$E(SIZE,1,75))
        I $L(SIZE)>75 D ADD($J("",55)_$E(SIZE,76,150))
        Q
ADD(XE) ;
        S ^TMP("PSB",$J,$O(^TMP("PSB",$J,""),-1)+1)=XE
        Q
GETDRN(IEN1)    ;
        ; Get the Drug IEN (p50) via OI IEN (p50.7)
        K ^TMP($J,"PSBLIST")
        D DRGIEN^PSS50P7(IEN1,,"PSBLIST")
        S DN=$O(^TMP($J,"PSBLIST",0))
        K ^TMP($J,"PSBLIST")
        Q DN
GETCLSS(IEN1)   ;
        ; Get the Items w/i VA Class
        K ^TMP($J,"PSBLIST")
        D VAC^PSS50(IEN1,,,"PSBLIST")
        M PSBDDRG=^TMP($J,"PSBLIST")
        K ^TMP($J,"PSBLIST")
        Q
