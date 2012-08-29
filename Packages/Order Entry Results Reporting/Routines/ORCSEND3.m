ORCSEND3        ;SLC/MKB,AGP-Release cont ;05/20/2008
        ;;3.0;ORDER ENTRY/RESULTS REPORTING;**243**;Dec 17, 1997;Build 242
        ;
CHILD(STRT)     ; Create child order, send to package
        N ORAPPT
        K ORIFN D EN^ORCSAVE Q:'$G(ORIFN)  D STARTDT^ORCSAVE2(ORIFN)
        I $G(STRT) D DATES^ORCSAVE2(ORIFN,STRT)
        S ORCHLD=+$G(ORCHLD)+1,^OR(100,ORPARENT,2,ORIFN,0)=ORIFN,ORLAST=ORIFN
        S ORAPPT=$P($G(^OR(100,ORPARENT,0)),U,18)
        S $P(^OR(100,ORIFN,0),U,18)=ORAPPT,$P(^(3),U,9)=ORPARENT
        I $G(PKG)="LR" S $P(^OR(100,ORIFN,8,1,0),U,4)=8 K ^OR(100,"AS",ORVP,9999999-ORLOG,ORIFN,1) ;signature tracked on parent order only, for Labs
        I $G(PKG)?1"PS".E D
        . N X0 S X0=$G(^OR(100,ORPARENT,8,1,0))
        . I $P(X0,U,4)'=2 D SIGN^ORCSAVE2(ORIFN,+$P(X0,U,5),ORNOW,$P(X0,U,4),1)
        . I $D(^OR(100,ORPARENT,9)) M ^OR(100,ORIFN,9)=^OR(100,ORPARENT,9)
        . I $G(ORENEW) S OLD=$O(ORENEW(0)) I OLD S $P(^OR(100,OLD,3),U,6)=ORIFN,$P(^OR(100,ORIFN,3),U,5)=OLD,$P(^(3),U,11)=2 K ORENEW(OLD)
        D RELEASE^ORCSAVE2(ORIFN,1,ORNOW,DUZ,$G(NATURE)),NEW^ORMBLD(ORIFN)
        Q
        ;
DOSES(IFN)      ;
        N I,CNT S CNT=0
        S I=+$O(^OR(100,+$G(IFN),4.5,"ID","NOW",0)) I I,$G(^OR(100,+$G(IFN),4.5,I,1)) S CNT=CNT+1
        Q CNT
        ;
GETORDER(IFN)   ; Set ORX(Inst,Ptr)=Value
        N I,X,Y,PTR,INST,TYPE,SOLCNT,ADDCNT
        S (SOLCNT,ADDCNT)=0
        S I=0 F  S I=$O(^OR(100,IFN,4.5,I)) Q:I'>0  S X=$G(^(I,0)),Y=$G(^(1)) D
        . S PTR=+$P(X,U,2),INST=+$P(X,U,3),TYPE=$P($G(^ORD(101.41,PTR,1)),U)
        . I TYPE'="W" S ORX(PTR,INST)=Y Q
        . ;S ORX(INST,PTR)="^OR(100,"_IFN_",4.5,"_I_",2)"
        . S ORX(PTR,INST)="^OR(100,"_IFN_",4.5,"_I_",2)"
        Q
PSJI    ;
        ;IV dialog
        N ORPARENT,OR0,ORNP,ORDIALOG,ORDUZ,ORLOG,ORL,ORDG,ORCAT,ORX,ORP,ORI,STS
        N ORDOSE,ORT,ORSCH,ORDUR,ORSTRT,ORFRST,ORCONJ,ORID,ORDD,ORSTR,ORDGNM
        N ORSTART,ORCHLD,ORLAST,ORSIG,OROI,ID,OR3,ORIG,CODE,PKG,ORENEW,I,ORADMIN
        N ORDUR
        N CNT
        S ORPARENT=+ORIFN,OR0=$G(^OR(100,ORPARENT,0)),OR3=$G(^OR(100,ORPARENT,3))
        S ORCAT="I",ORNP=+$P(OR0,U,4)
        ;Q:$P(OR0,U,12)'="I"  S ORCAT="I",ORNP=+$P(OR0,U,4)
        S ORDIALOG=+$P(OR0,U,5),ORDUZ=+$P(OR0,U,6),ORLOG=$P(OR0,U,7)
        S ORL=$P(OR0,U,10),ORDG=+$P(OR0,U,11),PKG=$$GET1^DIQ(9.4,+$P(OR0,U,14)_",",1)
        ;Build ORDIALOG Array and ORX local array
        D GETDLG1^ORCD(ORDIALOG),GETORDER(ORPARENT)
        ;
        S ORSCH=$$PTR("SCHEDULE"),ORDUR=$$PTR("DURATION")
        D STRT S ORSTART=$G(ORSTRT("BEG"))
        S ORADMIN=$$PTR("ADMIN TIMES")
        D DATES^ORCSAVE2(ORPARENT,ORSTART) Q:$$DOSES(ORPARENT)<1
        S ORFRST=$$PTR("NOW"),ORSIG=$$PTR("SIG")
        ;
        I $P(OR3,U,11)=2,$O(^OR(100,+$P(OR3,U,5),2,0)) D
        . S ORENEW=+$P(OR3,U,5),I=0
        . I $$VALUE^ORX8(ORENEW,"NOW") S I=$O(^OR(100,ORENEW,2,0))
        . F  S I=$O(^OR(100,ORENEW,2,I)) Q:I<1  S ORENEW(I)=""
        ;
PSJI1   ;
        ;Build Order Dialog Prompts that can have Multiple Responses
        F ORP="ADDITIVE","ORDERABLE ITEM","STRENGTH PSIV","UNITS","VOLUME" D
        . N PTR S PTR=$$PTR(ORP) Q:PTR'>0  Q:'$D(ORX(PTR,1))
        . S CNT=0 F  S CNT=$O(ORX(PTR,CNT)) Q:CNT'>0  S ORDIALOG(PTR,CNT)=ORX(PTR,CNT)
        ;
        ;Build Order Dialog Responses that should be in both Child Orders
        F ORP="INFUSION RATE","IV TYPE","ROUTE","URGENCY","WORD PROCESSING 1" D
        . N PTR S PTR=$$PTR(ORP) Q:PTR'>0  Q:'$D(ORX(PTR,1))
        . S ORDIALOG(PTR,1)=ORX(PTR,1) S:$E(ORP)="O" OROI=ORX(PTR,1) Q
        ;
        ;If NOW order create NOW Child Order
        I $G(ORX(ORFRST,1)) D
        . S:$D(ORX(ORP,1)) ORDIALOG(ORP,1)=ORX(ORP,1)
        . ;S ID=$G(ORX(ORI,ORID)) S:$P(ID,"&",6) ORDIALOG(ORDD,1)=$P(ID,"&",6)
        . S ORDIALOG(ORSCH,1)="NOW",ORSTART=$$NOW^XLFDT
        . D CHILD(ORSTART)
        ;
        ;Build Order Fields for non-NOW Child Order
        F ORP=ORSCH,ORADMIN,ORDUR S:$D(ORX(ORP,1)) ORDIALOG(ORP,1)=ORX(ORP,1) K:'$D(ORX(ORP,1)) ORDIALOG(ORP,1)
        S ORSTART=$G(ORSTRT(1))
        D CHILD(ORSTART)
        ;
        S:$G(ORCHLD) ^OR(100,ORPARENT,2,0)="^100.002PA^"_ORLAST_U_ORCHLD
        S ORIFN=ORPARENT,ORQUIT=1,OR3=$G(^OR(100,ORIFN,3)),STS=$P(OR3,U,3)
        I (STS=1)!(STS=13)!(STS=11) S ORERR="1^Unable to release orders"
        D RELEASE^ORCSAVE2(ORIFN,1,ORNOW,DUZ,$G(NATURE)) K ^TMP("ORWORD",$J)
        S $P(^OR(100,ORIFN,3),U,8)=1 ;veil parent order - set stop date/time?
        Q:(STS=1)!(STS=13)!(STS=11)  ;unsuccessful
PSJI2   ; ck if parent is unsigned or edit
        I $P($G(^OR(100,ORIFN,8,1,0)),U,4)=2 S $P(^(0),U,4)="" K ^OR(100,"AS",ORVP,9999999-ORLOG,ORIFN,1) ;clear ES
        Q:$P(OR3,U,11)'=1  S ORIG=$P(OR3,U,5) Q:ORIG'>0
        S CODE=$S($P($G(^OR(100,ORIG,3)),U,3)=5:"CA",1:"DC")
        D MSG^ORMBLD(ORIG,CODE) I "^1^13^"[(U_$P($G(^OR(100,ORIG,3)),U,3)_U) D
        . N NATR S NATR=+$O(^ORD(100.02,"C","C",0))
        . S $P(^OR(100,ORIG,3),U,3)=12,$P(^(3),U,7)=0,^(6)=NATR_U_DUZ_U_ORNOW
        . D CANCEL^ORCSEND(ORIG) ;ck for unrel actions
        Q
PTR(X)  ; Returns ptr of prompt X in Order Dialog file
        Q +$O(^ORD(101.41,"AB",$E("OR GTX "_X,1,63),0))
        ;
STRT    ; Build ORSTRT(inst)=date.time array of start times by dose
        N OI,PSOI,XD,XH,XM,XS,ORWD,ORI,SCH,ORSD,X,ORD K ORSTRT
        S OI=$G(ORX($$PTR^ORCD("OR GTX ORDERABLE ITEM"),1))
        ;if OI is null assume Intermittent IV order this does not required a 
        ;solution check for an additive only value
        I OI="" S OI=$G(ORX($$PTR^ORCD("OR GTX ADDITIVE"),1))
        S PSOI=+$P($G(^ORD(101.43,+OI,0)),U,2),(XD,XH,XM,XS)=0
        S ORWD=+$G(^SC(+$G(ORL),42)) ;ward
        ;S ORI=0 F  S ORI=$O(ORX(ORI)) Q:ORI<1  D
        S SCH=$G(ORX(ORSCH,1)),ORSD="" S:'$L(SCH) X=$$NOW^XLFDT
        S:$L(SCH) ORSD=$$STARTSTP^PSJORPOE(+ORVP,SCH,PSOI,ORWD),X=$P(ORSD,U,4)
        S ORSTRT(1)=$$FMADD^XLFDT(X,XD,XH,XM,XS) ;START+OFFSET
        ; find beginning date.time for parent
        S ORI=0,X=9999999 F  S ORI=$O(ORSTRT(ORI)) Q:ORI<1  I ORSTRT(ORI)<X S X=ORSTRT(ORI)
        S ORSTRT("BEG")=X
        Q