PSBOCM  ;BIRMINGHAM/TEJ-COVERSHEET MEDICATION OVERVIEW REPORT ;Mar 2004
        ;;3.0;BAR CODE MED ADMIN;**32,50**;Mar 2004;Build 78
        ;Per VHA Directive 2004-038 (or future revisions regarding same), this routine should not be modified.
        ;
        ; Reference/IA
        ; File 4/10090
        ; File 200/10060
EN      ;
        N PSBX1X,RESULTS,RESULT,PSBFUTR
        S PSBFUTR=$TR(PSBRPT(1),"~","^")
        S (PSBOCRIT,PSBXFLG,PSBCFLG)=""        ;  Order Status search criteria - "A"ctive, "D"C ed, "E"xpired"
        S:$P(PSBFUTR,U,7) PSBOCRIT=PSBOCRIT_"D" S:$P(PSBFUTR,U,8) PSBOCRIT=PSBOCRIT_"E" S:$P(PSBFUTR,U,5) PSBOCRIT=PSBOCRIT_"A"
        S:$P(PSBFUTR,U,4) PSBOCRIT=PSBOCRIT_"F"
        S:$P(PSBFUTR,U,11) PSBXFLG=1
        I $D(PSBRPT(.2)) I $P(PSBRPT(.2),U,8) S PSBCFLG=1
        K PSBSRTBY,PSBCMT,PSBADM,PSBDATA,PSBOUTP,PSBLGD,PSBHDR,PSBSTS
        S PSBSORT=1
        D NOW^%DTC S (Y,PSBNOWX)=% D DD^%DT S PSBDTTM=$E(Y,1,18)
        D GETPAR^PSBPAR("ALL","PSB ADMIN BEFORE")
        S PSBB4=0 S:RESULTS(0)>0 PSBB4=+RESULTS(0)
        D GETPAR^PSBPAR("ALL","PSB ADMIN AFTER")
        S PSBAFT=0 S:RESULTS(0)>0 PSBAFT=+RESULTS(0)
        K ^XTMP("PSBO",$J,"PSBLIST")
        S (PSBPGNUM,PSBLNTOT,PSBTOT,PSBX1X)=""
        K PSBLIST,PSBLIST2
        S PSBXDFN=$P(PSBRPT(.1),U,2)
        S PSBLIST(PSBXDFN)=""
        S (PSBX1X,PSBTOT)=0
        F  S PSBX1X=$O(PSBLIST(PSBX1X)) Q:+PSBX1X=0  D
        .D RPC^PSBCSUTL(.PSBAREA,PSBX1X)
        .M PSBDATA=@PSBAREA
        .S PSBX2X=1
        .S PSBLIST2("ACTIVE")=0,PSBLIST2("FUTURE")=0,PSBLIST2("EXPIRED/DC'd")=0,PSBLIST2(" * ERROR * ")=0
        .F  S PSBX2X=$O(PSBDATA(PSBX2X)) Q:+PSBX2X=0  D
        ..S PSBDATA=PSBDATA(PSBX2X)
        ..I $P(PSBDATA,U)="ORD" D  Q
        ...K PSBDRUGN
        ...S PSBORDN=$P(PSBDATA,U,3)
        ...S PSBTB=$P(PSBDATA,U,29) S PSBTB=$S(PSBTB=1:"UD",PSBTB=2:"IVPB",PSBTB=3:"IV",1:" * ERROR * ")
        ...S PSBTB(PSBORDN,PSBTB)=""
        ...S PSBSTS=$P(PSBDATA,U,23) S PSBSTS=$S((PSBSTS="A")&(($P(PSBDATA,U,27)>PSBNOWX)):"Active",PSBSTS="H":"On Hold",PSBSTS="D":"Discontinued",PSBSTS="DE":"Discontinued (Edit)",(PSBSTS="E")!($P(PSBDATA,U,27)'>PSBNOWX):"Expired",1:" * ERROR * ")
        ...S PSBSTS(PSBORDN,PSBSTS)=""
        ...S PSBSTSX=$S($P(PSBDATA,U,27)'>PSBNOWX:"EXPIRED/DC'd",$$FMADD^XLFDT($P(PSBDATA,U,22),,,-PSBB4)'>PSBNOWX:"ACTIVE",$P(PSBDATA,U,22)>$$FMADD^XLFDT(PSBNOWX,,,PSBB4):"FUTURE",1:" * ERROR * ")
        ...S PSBLIST2(PSBSTSX,$P(PSBDATA,U,9),PSBORDN)="" S PSBLIST2(PSBSTSX)=PSBLIST2(PSBSTSX)+1
        ...S:PSBOCRIT[$E(PSBSTSX,1) PSBTOT=PSBTOT+1
        ...S PSBSCHTY=$P(PSBDATA,U,6)
        ...I PSBTB="IV" S PSBSCHTY=" "
        ...S PSBSCHTY(PSBORDN,PSBSCHTY)=""
        ...S PSBDOSR=$P(PSBDATA,U,10)_", "_$P(PSBDATA,U,11)
        ...S PSBDOSR=$TR($E(PSBDOSR,1)," ")_$E(PSBDOSR,2,999)
        ...S PSBDOSR(PSBORDN,PSBDOSR)="" K PSBOMDR(PSBORDN)
        ...S PSBSCHD=$P(PSBDATA,U,7) I PSBSCHD="" S PSBSCHD=" "
        ...S PSBSCHD(PSBORDN,PSBSCHD)=""
        ...S PSBNXTX1=$$NEXTADM^PSBCSUTX(PSBX1X,PSBORDN)
        ...I PSBSTS["Hold" S PSBNXTX2="Provider Hold"
        ...I PSBSTS'["Hold",(PSBNXTX1]"") D
        ....I PSBNOWX>$$FMADD^XLFDT(PSBNXTX1,,,PSBAFT) S PSBNXTX2="MISSED "_PSBNXTX1
        ....E  S:+PSBNXTX1>0 PSBNXTX2="DUE "_PSBNXTX1
        ...S PSBNXTX1=$$FMTDT^PSBOCE1(PSBNXTX1)
        ...I ("^P^OC^O"[("^"_PSBSCHTY))!(PSBTB="IV")!(PSBSTS["Discontinued")!(PSBSTS["Expired") S:PSBSTS'["Hold" PSBNXTX2=" "
        ...S PSBNXTX(PSBORDN,$G(PSBNXTX2," "))=""
        ...; ** SPECIAL INSTRUCTIONS  **
        ...S PSBX2X=PSBX2X+1
        ...S PSBSI=$P(PSBDATA(PSBX2X),U,2)
        ...I PSBSI]" " S PSBSI(PSBORDN,PSBSI)=""
        ...S PSBOSTDT=$P(PSBDATA,U,22)
        ...S PSBOSTDT(PSBORDN,PSBOSTDT)=""
        ...S PSBOSPDT=$P(PSBDATA,U,27)
        ...S PSBOSPDT(PSBORDN,PSBOSPDT)=""
        ..I "^DD^ADD^SOL"[(U_$P(PSBDATA(PSBX2X),U)) D  Q
        ...F I=PSBX2X:1 S PSBDATA1=PSBDATA(I) D  Q:$D(PSBOMDR(PSBORDN))
        ....I "^DD^ADD^SOL"[(U_$P(PSBDATA1,U)) S PSBX2X=I S PSBDRUGN=$G(PSBDRUGN,"")_$P(PSBDATA1,U,3)_", " Q
        ....S $E(PSBDRUGN,$L(PSBDRUGN)-1)="" S PSBDRUGN(PSBORDN,$E(PSBDRUGN,1,250))=PSBDRUGN
        ....S PSBOMDR(PSBORDN,$E((PSBDRUGN_"; "_PSBDOSR),1,250))=PSBDRUGN_"; "_PSBDOSR
        ..I $P(PSBDATA,U)="END" Q
        ..I $P(PSBDATA(PSBX2X),U)="ORF" D  Q
        ...S PSBDATA=PSBDATA(PSBX2X)
        ...S:$P(PSBDATA,U,2)]"" PSBFLGD(PSBORDN,$P(PSBDATA,U,3)_" - "_$P(PSBDATA,U,4))=""
        ..I ($P(PSBDATA,U)="ADM")&($P(PSBDATA,U,4)]"") D
        ...S PSBXID=$P(PSBDATA,U,6)_U_$P(PSBDATA,U,4),PSBADM(PSBORDN,(-1*($P(PSBDATA,U,6))),PSBXID)=PSBDATA
        ...S PSBTEST="" F  S PSBTEST=$O(PSBFLGD(PSBORDN,PSBTEST)) Q:PSBTEST=""  I $P(PSBTEST,":")="NOX" K PSBFLGD(PSBORDN,PSBTEST) Q
        ...I $O(PSBSCHTY(PSBORDN,""))="P" S PSBPRNR(PSBORDN,$P(PSBDATA,U,4))=$P(PSBDATA,U,9)
        ...I $P(PSBDATA,U,3)]"" S PSBBID(PSBORDN,$P(PSBDATA,U,4))=$P(PSBDATA,U,3)
        ...S:PSBXFLG PSBLGD(PSBORDN,"X","INITIALS",$P(PSBDATA,U,8))=""
        ...K PSBDATA(PSBX2X)
        ...I ($P(PSBDATA(PSBX2X+1),U)="CMT")  F  S PSBDATA=PSBDATA(PSBX2X+1) Q:($P(PSBDATA,U)'="CMT")  D
        ....S PSBX2X=PSBX2X+1
        ....S PSBDATA=PSBDATA(PSBX2X)
        ....K PSBDATA(PSBX2X)
        ....S:$P(PSBDATA,U,3)]"" PSBPRNEF(PSBORDN,$P(PSBXID,U,2))=$P(PSBDATA,U,3)
        ....I 'PSBCFLG S PSBDATA=PSBDATA(PSBX2X+1) Q
        ....I $P(PSBDATA,U,2)'="" D
        .....S PSBLGD(PSBORDN,"C","INITIALS",$P(PSBDATA,U,4))=""
        .....S PSBCMT(PSBORDN,$P(PSBXID,U,2),(-1*$P(PSBDATA,U,6)),PSBX2X)=PSBDATA
        I +PSBTOT=0 K PSBLIST,^XTMP("PSBO",$J,"PSBLIST")
        D CREATHDR^PSBOCM1
        D SUBHDR^PSBOCE
        D BLDRPT
        D WRTRPT^PSBOCM1
        Q
BLDRPT  ; Buld REPORT DATA
        S PSBTOPHD=PSBLNTOT-2
        K PSBL2ULN
        I '$D(PSBLIST2) D  Q
        .S PSBOUTP(0,PSBLNTOT)="W !!,""<<<< NO ORDERS TO DISPLAY >>>>"",!!"
        S PSBMORE=5 F PSBX1X="ACTIVE","FUTURE","EXPIRED/DC'd"," * ERROR * " D
        .I PSBX1X'=" * ERROR * " S PSBSUM=PSBX1X_" ["_PSBLIST2(PSBX1X)_$S(PSBLIST2(PSBX1X)=1:" Order",1:" Orders")_"]" S PSBOUTP($$PGTOT,PSBLNTOT)="W !!,"""_PSBSUM_""""
        .Q:PSBLIST2(PSBX1X)=0
        .Q:PSBOCRIT'[$E(PSBX1X,1)
        .S:$L(PSBSUM)>$G(PSBL2ULN,0) PSBL2ULN=$L(PSBSUM)
        .S PSBOUTP($$PGTOT(2),PSBLNTOT)="W !,$TR($J("""",PSBL2ULN),"" "",""=""),!"
        .S PSBOUTP($$PGTOT,PSBLNTOT)="W !"
        .K PSBDATA
        .S X0="",PSBTOT1=0
        .F  S X0=$O(PSBLIST2(PSBX1X,X0))  Q:X0=""  S PSBX2X="" F  S PSBX2X=$O(PSBLIST2(PSBX1X,X0,PSBX2X)) Q:PSBX2X=""  D
        ..M PSBLGD("INITIALS")=PSBLGD(PSBX2X,"X","INITIALS") M PSBLGD("INITIALS")=PSBLGD(PSBX2X,"C","INITIALS")
        ..S PSBDATA(1,1)=$O(PSBTB(PSBX2X,""))
        ..S PSBDATA(1,2)=$O(PSBSTS(PSBX2X,""))
        ..S PSBDATA(1,3)=$O(PSBSCHTY(PSBX2X,""))
        ..S Y0=$O(PSBOMDR(PSBX2X,"")) I Y0]"" S PSBDATA(1,4)="("_X0_")",PSBDATA(1,4,0)=PSBOMDR(PSBX2X,Y0)
        ..S PSBDATA(1,5)=$O(PSBSCHD(PSBX2X,""))
        ..S PSBDATA(1,6)=$O(PSBNXTX(PSBX2X,""))
        ..S:PSBDATA(1,6)'["Hold" $P(PSBDATA(1,6)," ",2)=$$FMTDT^PSBOCE1($P(PSBDATA(1,6)," ",2))
        ..S PSBDATA(1,7)=$$FMTDT^PSBOCE1($O(PSBOSTDT(PSBX2X,"")))
        ..S PSBDATA(1,8)=$$FMTDT^PSBOCE1($E($O(PSBOSPDT(PSBX2X,"")),1,12))
        ..S PSBSIDAT(1)=$O(PSBSI(PSBX2X,""))
        ..S PSBTOT1=PSBTOT1+1
        ..K PSBDATA(2),PSBDATA(3),PSBSILN
        ..D BUILDLN^PSBOCM1,SIOPI(.PSBSIDAT,PSBTAB8,$S(PSBX2X["V":"Other Print Info:",1:""))
        ..I $D(PSBRPLN) S PSBMORE=$O(PSBRPLN(""),-1)+6 I $D(PSBSILN) S PSBMORE=PSBMORE+$O(PSBSILN(""),-1)
        ..K PSB1,X I $D(PSBFLGD(PSBX2X)) S PSB="" F  S PSB=$O(PSBFLGD(PSBX2X,PSB)) Q:PSB=""  I ($P(PSB,":")'="NOX")&($P(PSB,":")'="STAT") S PSB1=$G(PSB1,"")_PSB
        ..S PSBCNT=PSBTOT1_"   "_$G(PSB1,"")
        ..S PSBOUTP($$PGTOT,PSBLNTOT)="W """_PSBCNT_""""
        ..S I="" F  S I=$O(PSBRPLN(I)) Q:+I=0  D
        ...S PSBOUTP($$PGTOT,PSBLNTOT)="W !,"""_PSBRPLN(I)_""""
        ..S I="" F  S I=$O(PSBSILN(I)) Q:+I=0  D
        ...S PSBOUTP($$PGTOT,PSBLNTOT)="W !,"""_PSBSILN(I)_""""
        ..S PSBOUTP($$PGTOT(2),PSBLNTOT)="W !,$TR($J("""",PSBTAB8),"" "",""-""),!"
        ..K PSBRPLN,PSBDATA,PSBSILN
        D:+PSBTOT>0 LGD
        Q
PGTOT(X)        ;mnt PAGE Number
        I (PSBLNTOT+PSBMORE)>(IOSL) D PGC^PSBOCE1
        I $G(X,1) S PSBLNTOT=PSBLNTOT+$G(X,1),PSBMORE=PSBMORE-$G(X,1)
        Q PSBPGNUM
SIOPI(PSBXSI,TAB,Y)     ;
        Q:$G(PSBXSI(1))']""
        I $G(Y,"")']"" S Y="Special Instructions: "
        S PSBXSI(1)="  "_Y_PSBXSI(1)
        N X
        K J,TXT1,TXT2 S J(0)=""
        S J=($O(J(""),-1)+1) S PSBSILN(J)="",J(J)="" S J=($O(J(""),-1)+1)
        F X=1:1 Q:'$D(PSBXSI(X))  D
        .S TXT1=PSBXSI(X)
        .I ($L(TXT1)>0),$F(TXT1,"""")>1 D
        ..S TXT1=$TR(TXT1,"""","^")
        ..I $L(TXT1)+5'<TAB S TXT2=$E(TXT1,TAB-9,999),TXT1=$E(TXT1,1,TAB-10)
        ..I $L(TXT1,"^")>1 F Y=1:1:$L(TXT1,"^")-1 S $P(TXT1,"^",Y)=$P(TXT1,"^",Y)_""""
        ..I $D(TXT2) I $L(TXT2,"^")>1 F X=1:1:$L(TXT2,"^")-1 S $P(TXT2,"^",X)=$P(TXT2,"^",X)_""""
        ..S TXT1=$TR(TXT1,"^","""") I $D(TXT2) S TXT2=$TR(TXT2,"^","""")
        .S $E(PSBSILN(J),5,999)=TXT1,J(J)="",J=J+1
        .I $D(TXT2) S $E(PSBSILN(J),5,999)=TXT2,J(J)="",J=J+1
        S $E(PSBSILN(J),3,999)=" ",J(J)="",J=J+1
        Q
LGD     ; Create Report's Legend
        K PSBLGDO
        S PSBLGD("ORDER TYPES","C")="Continuous"
        S PSBLGD("ORDER TYPES","O")="One Time"
        S PSBLGD("ORDER TYPES","OC")="On Call"
        S PSBLGD("ORDER TYPES","P")="PRN"
        S PSB=0 F  S PSB=$O(PSBLGD("INITIALS",PSB)) Q:+PSB=0  D
        .S PSBINIT=$$GET1^DIQ(200,PSB_",","INITIAL"),PSBLGD("INITIALS",$S(PSBINIT']" ":"*n/a*",1:PSBINIT))=$$GET1^DIQ(200,PSB_",","NAME")
        .K PSBLGD("INITIALS",PSB)
        S PSBPGNUM=$O(PSBOUTP(""),-1),PSBLGDO(0)="REPORT LEGEND"
        S PSBLGDO(1)=""
        S PSBLGDO(2)=$S($G(PSBNO,0):"",1:"SCHEDULE TYPES")
        S PSBLGDO(3)=""
        I '$G(PSBNO,0) S X1="",X2=3 F  S X1=$O(PSBLGD("ORDER TYPES",X1)) Q:X1=""  S X2=X2+1,PSBLGDO(X2)=X1,$E(PSBLGDO(X2),5)="- "_PSBLGD("ORDER TYPES",X1)
        I $D(PSBLGD("INITIALS")) S $E(PSBLGDO(2),35)="INITIALS" S X1="",X2=3 F  S X1=$O(PSBLGD("INITIALS",X1)) Q:X1=""  S X2=X2+1,$E(PSBLGDO(X2),35)=X1,$E(PSBLGDO(X2),40)="- "_PSBLGD("INITIALS",X1)
        S (PSBMORE,X0)=10+($O(PSBLGDO(""),-1))
        I (PSBLNTOT+PSBMORE)'<IOSL S PSBLNTOT=PSBTOPHD-2,PSBPGNUM=PSBPGNUM+1
        I IOSL<1000 S X2=PSBLNTOT F  Q:X2'<(IOSL-(X0+3))  S PSBOUTP($$PGTOT,PSBLNTOT)="W !",X2=X2+1
        S PSBMORE=X0
        S PSBOUTP($$PGTOT(2),PSBLNTOT)="W !,"""_$TR($J("",IOM)," ","=")_""",!"
        F X1=0:1 Q:'$D(PSBLGDO(X1))  S PSBOUTP($$PGTOT,PSBLNTOT)="W !,"""_$G(PSBLGDO(X1)," ")_""""
        S PSBOUTP($$PGTOT(2),PSBLNTOT)="W !,"""_$TR($J("",IOM)," ","=")_""",!"
        Q
