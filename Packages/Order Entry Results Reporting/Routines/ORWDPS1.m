ORWDPS1 ; SLC/KCM/JLI - Pharmacy Calls for Windows Dialog; 03/10/2008
        ;;3.0;ORDER ENTRY/RESULTS REPORTING;**85,132,141,163,215,255,243**;Dec 17, 1997;Build 242
        ;
ODSLCT(LST,PSTYPE,DFN,LOC)      ; return default lists for dialog
        ; PSTYPE: pharmacy type (U=unit dose, F=IV fluids, O=outpatient)
        N ILST S ILST=0
        S ILST=ILST+1,LST(ILST)="~Priority" D PRIOR
        S ILST=ILST+1,LST(ILST)="~DispMsg"
        S ILST=ILST+1,LST(ILST)="d"_$$DISPMSG
        ;
        ; I PSTYPE="F" D  Q                           ; IV Fluids
        ; . S ILST=ILST+1,LST(ILST)="~ShortList" D SHORT
        ;
        I PSTYPE="O" D                                ; Outpatient
        . S ILST=ILST+1,LST(ILST)="~Refills"
        . S ILST=ILST+1,LST(ILST)="d0^0"
        . S ILST=ILST+1,LST(ILST)="~Pickup"
        . S ILST=ILST+1,LST(ILST)="d"_$$DEFPICK($G(LOC))
        . ; S ILST=ILST+1,LST(ILST)="~Supply"
        . ; S ILST=ILST+1,LST(ILST)="d^"_$$DEFSPLY(DFN)
        Q
PKI(ORY,OI,PSTYPE,ORVP,PKIACTIV)        ; return DEA Schedule for drug
        N ILST,ORDOSE,ORWPSOI,ORWDOSES,X1,X2,X
        K ^TMP("PSJINS",$J),^TMP("PSJMR",$J),^TMP("PSJNOUN",$J),^TMP("PSJSCH",$J),^TMP("PSSDIN",$J)
        S ILST=0
        S ORWPSOI=0
        S:+OI ORWPSOI=+$P($G(^ORD(101.43,+OI,0)),U,2)
        D START^PSSJORDF(ORWPSOI,$S(PSTYPE="U":"I",1:"O")) ; dflt route, schedule, etc.
        I '$L($T(DOSE^PSSOPKI1)) D DOSE^PSSORUTL(.ORDOSE,ORWPSOI,PSTYPE,ORVP)       ; dflt doses
        I $L($T(DOSE^PSSOPKI1)) D DOSE^PSSOPKI1(.ORDOSE,ORWPSOI,PSTYPE,ORVP)       ; dflt doses NEW PKI CODE from pharmacy
        D EN^PSSDIN(ORWPSOI)                               ; nfi text
        S ORY="" ;PKI
        I $D(ORDOSE("DEA")) S X="",X1=$P(ORDOSE("DEA"),";"),X2=$P(ORDOSE("DEA"),";",2) D
        . I '$L(X2) Q
        . I $G(PKIACTIV) S X=X2
        S ORY=X
        K ^TMP("PSJINS",$J),^TMP("PSJMR",$J),^TMP("PSJNOUN",$J),^TMP("PSJSCH",$J),^TMP("PSSDIN",$J)
        Q
PRIOR   ; from DLGSLCT, get list of allowed priorities
        N X,XREF
        S XREF=$S(PSTYPE="O":"S.PSO",1:"S.PSJ")
        S X="" F  S X=$O(^ORD(101.42,XREF,X)) Q:'$L(X)  D
        . I XREF["PSJ",X'="ASAP",X'="ROUTINE",X'="STAT" Q
        . S ILST=ILST+1,LST(ILST)="i"_$O(^ORD(101.42,XREF,X,0))_U_X
        S ILST=ILST+1,LST(ILST)="d"_$O(^ORD(101.42,"B","ROUTINE",0))_U_"ROUTINE"
        Q
DEFPICK(LOC)          ; return default routing
        N X,DLG,PRMT
        S DLG=$O(^ORD(101.41,"AB","PSO OERR",0)),X=""
        S PRMT=$O(^ORD(101.41,"AB","OR GTX ROUTING",0))
        I $D(^TMP("ORECALL",$J,+DLG,+PRMT,1)) S X=^(1)
        I X'="" S EDITONLY=1 Q X  ; EDITONLY used by default action
        ;
        ;S X=$$GET^XPAR("ALL^"_"LOC.`"_LOC,"ORWDPS ROUTING DEFAULT",1,"I")
        S X=$$GET^XPAR("LOC.`"_LOC_"^SYS","ORWDPS ROUTING DEFAULT",1,"I")
        I X="C" S X="C^in Clinic" G XPICK
        I X="M" S X="M^by Mail"   G XPICK
        I X="W" S X="W^at Window" G XPICK
        I X="N" S X=""            G XPICK
        I X=""  S X=$S($D(^PSX(550,"C")):"M^by Mail",1:"W^at Window")
XPICK   Q X
        ;
DEFSPLY(DFN)       ; return default days supply for this patient
        N ORWX
        S ORWX("PATIENT")=DFN
        D DSUP^PSOSIGDS(.ORWX)
        Q $G(ORWX("DAYS SUPPLY"))
        ;
DFLTSPLY(VAL,UPD,SCH,PAT,DRG)          ; return days supply given quantity
        ; VAL: default days supply
        N ORWX,I
        S ORWX("PATIENT")=PAT
        I DRG S ORWX("DRUG")=DRG
        F I=1:1:$L(UPD,U)-1 D
        . S ORWX("DOSE ORDERED",I)=$P(UPD,U,I)
        . S ORWX("SCHEDULE",I)=$P(SCH,U,I)
        D DSUP^PSOSIGDS(.ORWX)
        S VAL=$G(ORWX("DAYS SUPPLY"))
        Q
DISPMSG()             ; return 1 to suppress dispense message
        Q +$$GET^XPAR("ALL","ORWDPS SUPPRESS DISPENSE MSG",1,"I")
        ;
DOWSCH(LST,DFN,LOCIEN)      ; return all schedules
        N CNT,FREQ,ILST,ORARRAY,WIEN
        S WIEN=$$WARDIEN^ORWDPS32(+$G(LOCIEN))
        D SCHED^PSS51P1(WIEN,.ORARRAY)
        S ILST=0
        S CNT=0 F  S CNT=$O(ORARRAY(CNT)) Q:CNT'>0  D
        .S NODE=$G(ORARRAY(CNT))
        .I $P(NODE,U,4)="C" D
        ..K ^TMP($J,"ORWDPS1 DOWSCH")
        ..D ZERO^PSS51P1($P(NODE,U),,,,"ORWDPS1 DOWSCH")
        ..S FREQ=$G(^TMP($J,"ORWDPS1 DOWSCH",$P(NODE,U),2))
        ..K ^TMP($J,"ORWDPS1 DOWSCH")
        ..I +FREQ=0 Q
        ..I +FREQ>1440 Q
        ..S ILST=ILST+1,LST(ILST)=$P(ORARRAY(CNT),U,2,5)
        Q
        ;
SCHALL(LST,DFN,LOCIEN)      ; return all schedules
        N CNT,ILST,ORARRAY,WIEN
        S WIEN=$$WARDIEN^ORWDPS32(+$G(LOCIEN))
        D SCHED^PSS51P1(WIEN,.ORARRAY)
        S ILST=0
        S CNT=0 F  S CNT=$O(ORARRAY(CNT)) Q:CNT'>0  D
        .S ILST=ILST+1,LST(ILST)=$P(ORARRAY(CNT),U,2,5)
        Q
        ;
FORMALT(ORLST,ORIEN,PSTYPE)     ; return a list of formulary alternatives
        N PSID,I
        S ORIEN=+$P(^ORD(101.43,ORIEN,0),U,2)
        D EN1^PSSUTIL1(.ORIEN,PSTYPE)
        S PSID=0,I=0
        F  S PSID=$O(ORIEN(PSID)) Q:'PSID  D
        . S OI=+$O(^ORD(101.43,"ID",PSID_";99PSP",0))
        . I OI S I=I+1,ORLST(I)=OI,$P(ORLST(I),U,2)=$P(^ORD(101.43,OI,0),U)
        Q
DOSEALT(LST,DDRUG,CUROI,PSTYPE) ; return a list of formulary alternatives for dose
        N I,OI,ORWLST,ILST S ILST=0
        D ENRFA^PSJORUTL(DDRUG,PSTYPE,.ORWLST)
        S I=0 F  S I=$O(ORWLST(I)) Q:'I  D
        . S OI=+$O(^ORD(101.43,"ID",+$P(ORWLST(I),U,4)_";99PSP",0))
        . I OI,OI'=CUROI S ILST=ILST+1,LST(ILST)=OI_U_$P(^ORD(101.43,OI,0),U)
        Q
QOMEDALT(ORY,ODIEN)     ;
        N ARRAY,IDIEN,ORDERID,PKG,PSTYPE,VALUE
        S ORY=0,PKG=+$P(^ORD(101.41,ODIEN,0),U,7)
        S PSTYPE=$S($$GET1^DIQ(9.4,PKG_",",1)="PSO":"O",1:"I")
        S ORDERID=$O(^ORD(101.41,"B","OR GTX ORDERABLE ITEM","")) Q:ORDERID'>0
        S IDIEN=$O(^ORD(101.41,ODIEN,6,"D",ORDERID,"")) Q:IDIEN'>0
        S VALUE=$G(^ORD(101.41,ODIEN,6,IDIEN,1)) Q:VALUE'>0
        I $P($G(^ORD(101.43,VALUE,"PS")),U,6)=1 S ORY=VALUE
        ;D FORMALT(.ARRAY,VALUE,PSTYPE) I $D(ARRAY)>0 S ORY=VALUE
        ;I ORY=0,$P($G(^ORD(101.43,VALUE,"PS")),U,6)=1 S ORY=VALUE
        Q
FAILDEA(FAIL,OI,ORNP,PSTYPE)       ; return 1 if DEA check fails for this provider
        N DEAFLG,PSOI,TPKG
        S FAIL=0,TPKG=$P($G(^ORD(101.43,+$G(OI),0)),U,2)
        Q:TPKG'["PS"
        S PSOI=+TPKG Q:PSOI'>0
        I '$L($T(OIDEA^PSSUTLA1)) Q
        S DEAFLG=$$OIDEA^PSSUTLA1(PSOI,PSTYPE) Q:DEAFLG'>0
        I '$L($$DEA^XUSER(,+$G(ORNP))) S FAIL=1
        Q
FDEA1(FAIL,OI,OITYPE,ORNP)      ; only be called for an outpaitent and IV dialog
        ;OI: IV Orderable Item
        ;OITYPE: A:ADDITIVE  S:SOLUTION
        N DEAFLG,PSOI,TKPG
        S FAIL=0,TPKG=$P($G(^ORD(101.43,+$G(OI),0)),U,2)
        Q:TPKG'["PS"
        S PSOI=+TPKG Q:PSOI'>0
        I '$L($T(IVDEA^PSSUTIL1)) Q
        S DEAFLG=$$IVDEA^PSSUTIL1(PSOI,OITYPE) Q:DEAFLG'>0
        I '$L($P($G(^VA(200,+$G(ORNP),"PS")),U,2)),'$L($P($G(^("PS")),U,3)) S FAIL=1
        Q
        ;
CHK94(VAL)           ; return 1 if patch 94 has been installed
        S VAL=0
        I $O(^ORD(101.41,"B","PS MEDS",0)) S VAL=1
        Q
LOCPICK(Y,LOC)  ; return default Location level routing
        S Y=""
        S Y=$$GET^XPAR("LOC.`"_LOC_"^SYS","ORWDPS ROUTING DEFAULT",1,"I")
        I Y="C" S Y="C^in Clinic"
        I Y="M" S Y="M^by Mail"
        I Y="W" S Y="W^at Window"
        I Y="N" S Y=""
        Q
HASOIPI(Y,QOID) ; Check if QO put orderable item's PI into Sig
        N PIIEN,OIX
        S Y=0
        Q:'$D(^ORD(101.41,QOID,0))
        S PIIEN=$O(^ORD(101.41,"B","OR GTX PATIENT INSTRUCTIONS",0))
        Q:'PIIEN
        S OIX=0
        Q:'$D(^ORD(101.41,QOID,6,"D"))
        F  S OIX=$O(^ORD(101.41,+QOID,6,"D",OIX)) Q:'OIX  D
        . I OIX=PIIEN S Y=1 Q
        Q
HASROUTE(Y,QOID)        ;Check if QO has a ROUTE defined
        N ROUTID
        S Y=0,ROUTID=0
        S ROUTID=$O(^ORD(101.41,"B","OR GTX ROUTING",0))
        Q:'ROUTID
        Q:'$D(^ORD(101.41,+QOID))
        I $D(^ORD(101.41,+QOID,6,"D",ROUTID)) S Y=1
        Q
QOCHECK(ORY,DIEN)       ;
        N ARY,DG,FORMIEN,NAME,OI,OIIEN,ORDIALOG,ORPKG,TYPE
        S ORPKG=$$NMSP^ORCD($P($G(^ORD(101.41,DIEN,0)),U,7)) Q:ORPKG'["PS"
        S DG=$P(^ORD(101.41,DIEN,0),U,5)
        S NAME=$P(^ORD(100.98,DIEN,0),U)
        S TYPE=$S(NAME="INPATIENT MEDICATIONS":"I",NAME="OUTPATIENT MEDICATIONS":"O",1:"")
        I TYPE="" Q
        S ORDIALOG=$$DEFDLG^ORCD(DIEN) Q:ORDIALOG
        D GETDLG^ORCD(ORDIALOG),GETORDER^ORCD("^ORD(101.41,"_DIEN_",6)")
        I $D(ORDIALOG)'>0 Q
        S OI=$P($G(ORDIALOG("B","ORDERABLE")),U,2) Q:OI'>0
        S OIIEN=$G(ORDIALOG(OI,1)) Q:OIIEN'>0
        D FORMALT(.ARY,OIIEN,TYPE) I $D(ARY)'>0 Q
        S ORY=OIIEN
        Q