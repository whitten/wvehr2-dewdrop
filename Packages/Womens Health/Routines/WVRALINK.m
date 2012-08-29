WVRALINK        ;HCIOFO/FT-RAD/NM-WOMEN'S HEALTH LINK  ;6/10/04  14:51
        ;;1.0;WOMEN'S HEALTH;**3,5,7,9,10,16,18,23**;Sep 30, 1998;Build 5
        ;
        ; This routine uses the following IAs:
        ; #2480  - FILE 70         (private)
        ; #2481  - FILE 71         (private)
        ; #2482  - FILE 71.2       (private)
        ; #10035 - FILE 2          (supported)
        ; #10063 - ^%ZTLOAD        (supported)
        ; #10070 - ^XMD            (supported)
        ; #10141 - ^XPDUTL         (supported)
        ; #2541  - ^XUPARAM        (supported)
        ;
        ;;  Original routine created by IHS/ANMC/MWR
        ;;* MICHAEL REMILLARD, DDS * ALASKA NATIVE MEDICAL CENTER *
        ;;  CREATE MAMMOGRAM PROCEDURE IN WOMEN'S HEALTH FOR THIS PATIENT.
        ;;  CALLED BY ^RART WHEN A RADIOLOGY REPORT IS VERIFIED.
        ;;  CALLED BY ^RARTE1 WHEN A RADIOLOGY REPORT IS UNVERIFIED.
        ;;  CALLED BY ^WVEXPTRA WHEN EXPORTING HISTORICAL MAMS TO WOMEN'S HEALTH
        ;
        ;---> REQUIRED VARIABLES: DFN  = DFN OF RADIOLOGY PATIENT.
        ;--->                     DATE = INVERSE DATE/TIME OF VISIT.
        ;--->                     CASE = IEN OF RADIOLOGY EXAM (CASE).
        ;
        ;---> OPTIONAL VARIABLE:  WVNEWP = TOTAL NEW WH PATIENTS ADDED.
        ;--->                     WVMCNT = TOTAL NEW MAMS PROCEDURES ADDED.
        ;--->                     THESE IF CALLED FROM ^WVEXPTRA ROUTINE.
        ;
        ;---> GENERATED VARIBLES:
        ;---> WVPROC = IEN OF RADIOLOGY PROCEDURE (FILE #71), THEN IT
        ;--->          GETS CHANGED TO WOMEN'S HEALTH PROCEDURE TYPE
        ;--->                                   (FILE #790.2).
        ;---> WVLOC  = WARD/CLINIC/LOCATION (FILE #44).
        ;---> WVDATE = DATE OF THE PROCEDURE.
        ;---> WVPROV = ORDERING PROVIDER.
        ;---> WVMOD  = LEFT OR RIGHT, IF IT'S A UNILATERAL MAMMOGRAM.
        ;---> WVDX   = RADIOLOGY DIAGNOSTIC CODE.
        ;---> WVBWDX = WOMEN'S HEALTH RESULT/DIAGNOSIS.
        ;
CREATE(DFN,DATE,CASE)   ;
        Q:'+$$VERSION^XPDUTL("WV")
        Q:($G(DFN)']"")!($G(DATE)']"")!($G(CASE)']"")
        N ZTDESC,ZTDTH,ZTIO,ZTRTN,ZTSAVE
        S:'$D(DUZ)#2 DUZ=.5
        S:'$D(DUZ(2))#2 DUZ(2)=$$KSP^XUPARAM("INST")
        S ZTRTN="CREATEQ^WVRALINK",ZTDESC="WV CREATE MAMMOGRAM ENTRY"
        S ZTSAVE("DFN")="",ZTSAVE("DATE")="",ZTSAVE("CASE")=""
        S ZTIO="",ZTDTH=$H
        D ^%ZTLOAD
        Q
CREATEH(DFN,DATE,CASE,STATUS)   ; Entry from ^WVEXPTRA which looks for exams
        ; created before the WH package was installed.
        Q:($G(DFN)']"")!($G(DATE)']"")!($G(CASE)']"")!($G(STATUS)']"")
        ; 
CREATEQ ; Queue data entry creation. Called from CREATE above
        N WVPROC,WVLOC,WVDATE,WVDR,WVPROV,WVMOD,WVDX,WVBWDX,WVLEFT,WVRIGHT
        N WVCASE,WVCPT,WVERR,WVCREDIT,WVEXAM0,WVZSTAT
        ;---> QUIT IF RADIOLOGY DATA IS NOT DEFINED OR ="".
        I $D(ZTQUEUED) S ZTREQ="@"
        Q:'$D(^RADPT(DFN,"DT",DATE,"P",CASE,0))
        ;
        ;---> QUIT IF THIS PROCEDURE DOES NOT HAVE A MAM CPT CODE.
        ;---> QUIT IF THIS PROCEDURE DOES NOT HAVE AN ULTRASOUND CPT CODE.
        ;---> WVEXAM0=ZERO NODE OF RADIOLOGY EXAM.
        S WVEXAM0=^RADPT(DFN,"DT",DATE,"P",CASE,0)
        S WVCPT=$$GET1^DIQ(71,$P(WVEXAM0,U,2),9,"I") Q:WVCPT=""
        S WVPROC=$O(^WV(790.2,"AC",WVCPT,0)) ;cpt code x-ref to get 790.2 ien
        Q:'WVPROC  ;cpt code is not tracked in 790.2
        Q:$P($G(^WV(790.2,+WVPROC,0)),U,5)'="R"  ;cpt is not rad/nm procedure
        Q:$P($G(^DPT(DFN,0)),U,2)'="F"  ;not female
        ;
        ;---> QUIT IF NO WOMEN'S HEALTH SITE PARAMETER FILE ON THIS MACHINE.
        ;     OR NO DEFAULT CASE MANAGER
        Q:'$D(^WV(790.02,DUZ(2)))
        Q:'$P($G(^WV(790.02,+$G(DUZ(2)),0)),U,2)
        ;
        ;---> IF NOT CALLED FROM ^WVEXPTRA (i.e., STATUS is undefined) CHECK
        ;---> SITE PARAMETER AND QUIT IF "IMPORT MAMMOGRAMS FROM RADIOLOGY"
        ;---> IS NOT SET TO "YES". CHECK VETERAN STATUS AND ELIGIBILITY CODE.
        N Y S Y=^WV(790.02,DUZ(2),0)
        I '$D(STATUS) Q:'$P(Y,U,10)
        I '$D(STATUS) Q:'$$VNVEC^WVRALIN1()  ;vet/non-vet/eligibility code check
        ;
        ;---> SET WVZSTAT =THE STATUS (OPEN OR CLOSED) IN WOMEN'S HEALTH.
        ;---> THAT MAMMOGRAMS SHOULD RECEIVE WHEN COPIED OVER FROM RADIOLOGY.
        S WVZSTAT=$P(Y,U,23) S:WVZSTAT="" WVZSTAT="o"
        I $G(STATUS)]"" S WVZSTAT=$G(STATUS) ;status selected in ^WVEXPTRA
        ;
        D COPY(WVEXAM0)
        ;
EXIT    ;EP
        K I,N,X
        Q
        ;
COPY(Y) ;EP
        ;---> COPY MAM PROCEDURE DATA FROM RADIOLOGY TO WOMEN'S HEALTH.
        ;---> VARIABLE DFN=PATIENT
        ;---> LOCATION=DUZ(2)
        ;---> WARD/CLINIC/LOCATION
        N X
        S WVLOC=$P(Y,U,8)
        ;
        ;---> WVDATE=DATE OF THE PROCEDURE.
        S WVDATE=$P($P(^RADPT(DFN,"DT",DATE,0),U),".")
        ;
        ;---> RECONSTRUCT THE FULL CASE# FOR THIS RAD PROCEDURE.
        ;---> THIS IS USED AS A LINK (XREF) BETWEEN THE RADIOLOGY PROCEDURE
        ;---> AND THE WOMEN'S HEALTH PROCEDURE.
        S WVCASE=$E(WVDATE,4,7)_$E(WVDATE,2,3)_"-"_$P(Y,U)
        ;---> CHECK TO BE SURE THE CASE# XREF IS REALLY DOWN THERE.
        S:'$D(^RADPT("ADC",WVCASE,DFN,DATE,CASE)) WVCASE="UNKNOWN"
        ;
        ;---> QUIT IF THIS PROCEDURE HAS ALREADY BEEN SENT TO WOMEN'S HEALTH.
        Q:$D(^WV(790.1,"E",WVCASE))
        ;
        ;---> REQUESTING PROVIDER/ORDERING PROVIDER
        S WVPROV=$P(Y,U,14)
        ;
        ;---> IF UNILATERAL, ATTEMPT TO PICK UP LEFT OR RIGHT MODIFIER.
        I WVPROC=26 D
        .I $D(^RADPT(DFN,"DT",DATE,"P",CASE,"M",0)) D
        ..N N S N=0
        ..F  S N=$O(^RADPT(DFN,"DT",DATE,"P",CASE,"M",N)) Q:'N  D
        ...S WVMOD=$P(^RADPT(DFN,"DT",DATE,"P",CASE,"M",N,0),U)
        ...S WVMOD=$$GET1^DIQ(71.2,WVMOD,.01,"I")
        ...I "LEFTleft"[WVMOD S WVLEFT=1
        ...I "RIGHTright"[WVMOD S WVRIGHT=1
        ..Q:$D(WVLEFT)&($D(WVRIGHT))
        ..I $D(WVLEFT) S WVMOD="l" Q
        ..I $D(WVRIGHT) S WVMOD="r" Q
        ;
        ;---> IF THERE'S A DIAGNOSTIC CODE, ATTEMPT TO PICK UP DIAGNOSIS.
        ;---> USE "WV DIAGNOSTIC CODE TRANSLATION" FILE #790.32.
        S WVDX=$P(Y,U,13)
        I +WVDX I $D(^WV(790.32,"C",WVDX)) S WVBWDX=$O(^WV(790.32,"C",WVDX,0))
        ;
        ;---> GET CREDIT METHOD.
        S WVCREDIT=$P(Y,U,26)
        ;
PATIENT ;---> IF PATIENT ISN'T IN WOMEN'S HEALTH DATABASE, ADD HER.
        S WVERR=1
        I '$D(^WV(790,DFN,0)) D
        .D AUTOADD^WVPATE(DFN,DUZ(2),.WVERR)
        .I $D(WVNEWP) S:WVERR WVNEWP=WVNEWP+1
        Q:WVERR<0
        D FIND^WVRALIN1 ;check for 'unlinked' entry in File 790.1
        Q:$D(^WV(790.1,"E",WVCASE))  ;quit if link was made in WVRALIN1
PROC    ;---> CREATE MAMMOGRAM PROCEDURE IN WV PROCEDURE FILE #790.1.
        S WVDR=".02////"_DFN_";.04////"_WVPROC
        S WVDR=WVDR_";.05////"_$G(WVBWDX)_";.07////"_WVPROV
        S WVDR=WVDR_";.09////"_$G(WVMOD)_";.1////"_DUZ(2)_";.11////"_WVLOC
        S WVDR=WVDR_";.12////"_WVDATE_";.14////"_WVZSTAT_";.15////"_WVCASE
        S WVDR=WVDR_";.18////.5;.19////"_DT_";.34////"_$G(DUZ(2))_";.35////"_WVCREDIT
        ;
        D NEW2^WVPROC(DFN,WVPROC,WVDATE,WVDR,"","",.WVERR)
        I $D(WVMCNT) S:WVERR>-1 WVMCNT=WVMCNT+1
        Q:WVERR<0  ;procedure not added
        Q:$D(WVMCNT)  ;mass import of Rad/NM exams
        ;Q:$P($G(^WV(790.02,+DUZ(2),0)),U,23)="c"  ;Status=closed
        I (WVCPT=76856)!(WVCPT=76830)!(WVCPT=76645) D  Q  ;not breast related
        .D MAIL^WVRADWP(DFN,+Y,WVPROC,WVPROV) ;iens for patient, accession, procedure, provider/requestor
        .Q
        D CPRS^WVSNOMED(69,DFN,"",WVPROV,"Mammogram results available.",DATE_"~"_CASE)
        Q
        ;
DELETE(DFN,DATE,CASE)   ;EP
        ;---> MODIFY WOMEN'S HEALTH PROCEDURE TO REFLECT CHANGE.
        ;---> CALLED FROM RARTE1 (DELETE A REPORT AND UNVERIFY A REPORT).
        ;
        Q:'+$$VERSION^XPDUTL("WV")
        Q:'$D(DFN)!('$D(DATE))!('$D(CASE))
        N ZTDESC,ZTDTH,ZTIO,ZTRTN,ZTSAVE
        S ZTRTN="DELETEQ^WVRALINK",ZTDESC="WV MAMMOGRAM RPT CHANGE"
        S ZTSAVE("DFN")="",ZTSAVE("DATE")="",ZTSAVE("CASE")=""
        S ZTIO="",ZTDTH=$H
        D ^%ZTLOAD
        Q
DELETEQ ; Modify WV entry when mammogram report is unverified or deleted
        Q:'$D(^RADPT(DFN,"DT",DATE,"P",CASE,0))
        N WVIEN,WVDATE,WVCASE,WVCMGR,WVLOOP,WVMSG,WVPROV
        N XMDUZ,XMSUB,XMTEXT,XMY ;send mail message to case manager
        I $D(ZTQUEUED) S ZTREQ="@"
        ;
        ;---> WVDATE=DATE OF PROCEDURE.
        S WVDATE=$P($P(^RADPT(DFN,"DT",DATE,0),U),".")
        S WVCASE=$P(^RADPT(DFN,"DT",DATE,"P",CASE,0),U)
        ;
        ;---> WVCASE=RECONSTRUCTED CASE# OF PROCEDURE.
        S WVCASE=$E(WVDATE,4,7)_$E(WVDATE,2,3)_"-"_WVCASE
        ;---> QUIT IF NO CASE# XREF IN WOMEN'S HEALTH PROCEDURE FILE.
        Q:'$D(^WV(790.1,"E",WVCASE))
        ;
        S WVIEN=$O(^WV(790.1,"E",WVCASE,0))
        Q:'$D(^WV(790.1,WVIEN,0))
        D RADMOD^WVPROC(WVIEN) ;update wh status to "open"
        S WVPROV=+$$GET1^DIQ(790.1,WVIEN,.07,"I") ;get provider/requestor
        S WVCMGR=+$$GET1^DIQ(790,DFN,.1,"I") ;get case manager
        S:WVCMGR XMY(WVCMGR)=""
        ; if no case manager, then get default case manager(s)
        I 'WVCMGR S WVLOOP=0 F  S WVLOOP=$O(^WV(790.02,WVLOOP)) Q:'WVLOOP  D
        .S WVCMGR=$$GET1^DIQ(790.02,WVLOOP,.02,"I")
        .S:WVCMGR XMY(WVCMGR)=""
        .Q
        Q:$O(XMY(0))'>0  ;no case manager(s)
        S:WVPROV XMY(WVPROV)=""
        S XMDUZ=.5 ;message sender
        S XMSUB="RAD/NM Rpt for WH patient is UNVERIFIED/DELETED"
        S WVMSG(1)="        Patient: "_$P($G(^DPT(DFN,0)),U,1)_" (SSN: "_$$SSN^WVUTL1(DFN)_")"
        S WVMSG(2)=" WH Accession #: "_$P($G(^WV(790.1,+WVIEN,0)),U,1)
        S WVMSG(3)="  RAD/NM Case #: "_WVCASE
        S WVMSG(4)=" "
        S WVMSG(5)="NOTE: THIS PROCEDURE HAS BEEN ALTERED IN RADIOLOGY/NM."
        S WVMSG(6)="Follow-up is required in the WOMEN'S HEALTH package!"
        S XMTEXT="WVMSG("
        D ^XMD
        Q