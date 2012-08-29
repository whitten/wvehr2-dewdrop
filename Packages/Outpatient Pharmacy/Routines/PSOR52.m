PSOR52  ;IHS/DSD/JCM - Files refill entries in prescription file ;03/10/93
        ;;7.0;OUTPATIENT PHARMACY;**10,22,27,181,148,201,260,281**;DEC 1997;Build 41
        ;Reference to ^PSDRUG supported by DBIA 221
        ;Reference to PSOUL^PSSLOCK supported by DBIA 2789
        ;Reference SWSTAT^IBBAPI supported by DBIA 4663
        ;Reference SAVNDC^PSSNDCUT supported by DBIA 4707
        ; This routine is responsible for the actual
        ; filling of the refill prescription.
        ;---------------------------------------------------------   
EN(PSOX)        ;Entry Point
START   ;
        D:$D(XRTL) T0^%ZOSV ; Start RT monitor
        D INIT G:PSOR52("QFLG") END
        D FILE
        D DIK
        S:$D(XRT0) XRTN=$T(+0) D:$D(XRT0) T1^%ZOSV ; Stop RT Monitor
        D FINISH
END     D EOJ
        Q
        ;---------------------------------------------------------
        ;
INIT    ;
        S PSOR52("QFLG")=0
        S PSOX("QTY")=$P(PSOX("RX0"),"^",7),PSOX("DAYS SUPPLY")=$P(PSOX("RX0"),"^",8)
        S:$G(^PSDRUG($P(PSOX("RX0"),"^",6),660))]"" PSOX("COST")=$P(^PSDRUG($P(PSOX("RX0"),"^",6),660),"^",6)
        D NOW^%DTC S PSOX("LOGIN DATE")=$E(%,1,7)
        S X1=PSOX("FILL DATE"),X2=PSOX("DAYS SUPPLY")-10\1 D C^%DTC S PSOX1=X
        S X1=$P(PSOX("RX2"),"^",2)
        S X2=PSOX("DAYS SUPPLY")*(PSOX("NUMBER")+1)-10\1
        D C^%DTC S PSOX2=X
        S PSOX("NEXT POSSIBLE REFILL")=$S(PSOX1>PSOX2:PSOX1,1:PSOX2)
        K X,PSOX1,PSOX2
        S (PSOX("LAST DISPENSED DATE"),PSOX("DISPENSED DATE"))=PSOX("FILL DATE")
        I PSOX("FILL DATE")>$S($G(PSOX("LOGIN DATE")):$E(PSOX("LOGIN DATE"),1,7),1:DT),$P(PSOPAR,"^",6) D
        .S PSOX("OLD MAIL/WINDOW")=$S($G(PSOX("MAIL/WINDOW"))]"":PSOX("MAIL/WINDOW"),1:"MAIL"),PSOX("MAIL/WINDOW")="M"
        I $P(PSOX("RX2"),"^",12)]"" S PSOX("GENERIC PROVIDER")=$P(PSOX("RX2"),"^",12)
        S PSOX("PROVIDER")=$P(PSOX("RX0"),"^",4)
        S:'$D(PSOX("CLERK CODE")) PSOX("CLERK CODE")=DUZ
        S PSOX("DAW")=$$GETDAW^PSODAWUT(+PSOX("IRXN")),PSOX("NDC")=$$GETNDC^PSSNDCUT($P(PSOX("RX0"),"^",6))
INITX   Q
        ;
FILE    ;     
        ;L +^PSRX(PSOX("IRXN")):0
        I '$D(^PSRX(PSOX("IRXN"),1,0)) S ^(0)="^52.1DA^1^1"
        E  S ^PSRX(PSOX("IRXN"),1,0)=$P(^PSRX(PSOX("IRXN"),1,0),"^",1,2)_"^"_PSOX("NUMBER")_"^"_($P(^(0),"^",4)+1)
        F PSOX1=1:1 S PSOR52=$P($T(DD+PSOX1),";;",2,4) Q:PSOR52=""  K PSOY S PSOY=$P(PSOR52,";;") I $D(@PSOY) S $P(PSOR52(PSOX("IRXN"),1,PSOX("NUMBER"),$P(PSOR52,";;",2)),"^",$P(PSOR52,";;",3))=@PSOY
        K PSOX1,PSOY
        S PSOX1="" F  S PSOX1=$O(PSOR52(PSOX("IRXN"),1,PSOX("NUMBER"),PSOX1)) Q:PSOX1=""  S ^PSRX(PSOX("IRXN"),1,PSOX("NUMBER"),PSOX1)=$G(PSOR52(PSOX("IRXN"),1,PSOX("NUMBER"),PSOX1))
        K PSOX1
        S:PSOX("STA")=6 $P(^PSRX(PSOX("IRXN"),"STA"),"^")=0
        S $P(^PSRX(PSOX("IRXN"),3),"^",1,2)=PSOX("LAST DISPENSED DATE")_"^"_PSOX("NEXT POSSIBLE REFILL")
        S $P(^PSRX(PSOX("IRXN"),3),"^",4)=PSOX("LAST REFILL DATE")
        I $D(PSOX("METHOD OF PICK-UP")),PSOX("FILL DATE")'>DT S $P(^PSRX(PSOX("IRXN"),"MP"),"^")=PSOX("METHOD OF PICK-UP")
        D:$$SWSTAT^IBBAPI() GACT^PSOPFSU0(PSOX("IRXN"),PSOX("NUMBER"))
        ;L -^PSRX(PSOX("IRXN"))
        Q
        ;
DIK     ;
        K DIK,DA
        S DIK="^PSRX(",DA=PSOX("IRXN") D IX1^DIK K DIK
        I +$G(^PSRX(DA,"IB")),$P(^PSRX(DA,1,PSOX("NUMBER"),0),"^",2)="W" S ^PSRX("ACP",$P(^PSRX(DA,0),"^",2),$P(^PSRX(DA,1,PSOX("NUMBER"),0),"^"),PSOX("NUMBER"),DA)="" K DA
        D:$T(EN^PSOHDR)]"" EN^PSOHDR("PREF",PSOX("IRXN"))
        Q
        ;
FINISH  ;
        I $G(PSOX("QS"))="S" D  G FINISHX
        . S DA=PSOX("IRXN"),RXFL(PSOX("IRXN"))=PSOX("NUMBER")
        . D SUS^PSORXL K DA
        ;
        ; - Previous ePharmacy Refill was Deleted and a new one is being entered
        I '$$SUBMIT^PSOBPSUT(PSOX("IRXN"),PSOX("NUMBER")),$$STATUS^PSOBPSUT(PSOX("IRXN"),PSOX("NUMBER"))'="" D
        . D RETRXF^PSOREJU2(PSOX("IRXN"),PSOX("NUMBER"),1)
        ;
        I PSOX("FILL DATE")>$S($G(PSOX("LOGIN DATE")):$E(PSOX("LOGIN DATE"),1,7),1:DT),$P(PSOPAR,"^",6) D  G FINISHX
        .K PSOXRXFL I $D(RXFL(PSOX("IRXN"))) S PSOXRXFL=$G(RXFL(PSOX("IRXN")))
        .S DA=PSOX("IRXN"),RXFL(PSOX("IRXN"))=PSOX("NUMBER")
        .D SUS^PSORXL K DA
        .I $G(PSOXRXFL)'="" S RXFL(PSOX("IRXN"))=$G(PSOXRXFL) K PSOXRXFL
        ;
        ; - Calling ECME for claims generation and transmission / REJECT handling
        N ACTION,PSOERX,PSOERF
        S PSOERX=PSOX("IRXN"),PSOERF=PSOX("NUMBER")
        I $$SUBMIT^PSOBPSUT(PSOERX,PSOERF) D  I ACTION="Q"!(ACTION="^") Q
        . S ACTION="" D ECMESND^PSOBPSU1(PSOERX,PSOERF,PSOX("FILL DATE"),"RF")
        . I $$FIND^PSOREJUT(PSOERX,PSOERF) D
        . . S ACTION=$$HDLG^PSOREJU1(PSOERX,PSOERF,"79,88","OF","IOQ","Q")
        . I $$STATUS^PSOBPSUT(PSOERX,PSOERF)="E PAYABLE" D
        . . D SAVNDC^PSSNDCUT(+$$GET1^DIQ(52,PSOERX,6,"I"),$G(PSOSITE),$$GETNDC^PSONDCUT(PSOERX,PSOERF))
        ;
        I $G(PSOX("QS"))="Q" D  G FINISHX
        . I $G(PPL),$L(PPL_PSOX("IRXN")_",")>240 D TRI^PSOBBC D Q^PSORXL K PPL,RXFL
        . S RXFL(PSOX("IRXN"))=PSOX("NUMBER")
        . I $G(PPL) S PPL=PPL_PSOX("IRXN")_","
        . E  S PPL=PSOX("IRXN")_","
        ;
        I $G(PSORX("PSOL",1))']"" S PSORX("PSOL",1)=PSOX("IRXN")_",",RXFL(PSOX("IRXN"))=PSOX("NUMBER") G FINISHX
        F PSOX1=0:0 S PSOX1=$O(PSORX("PSOL",PSOX1)) Q:'PSOX1  S PSOX2=PSOX1
        I $L(PSORX("PSOL",PSOX2))+$L(PSOX("IRXN"))<220 S PSORX("PSOL",PSOX2)=PSORX("PSOL",PSOX2)_PSOX("IRXN")_","
        E  S PSORX("PSOL",PSOX2+1)=PSOX("IRXN")_","
        S RXFL(PSOX("IRXN"))=PSOX("NUMBER")
        ;
FINISHX ; 
        I $G(PSORX("MAIL/WINDOW"))["W" S BINGCRT=1,BINGRTE="W",BBFLG=1 D BBRX^PSORN52C
        K PSOX1,PSOX2
        Q
EOJ     ;
        I $D(PSOX("OLD MAIL/WINDOW")) S PSOX("MAIL/WINDOW")=PSOX("OLD MAIL/WINDOW") K PSOX("OLD MAIL/WINDOW")
        S DA=$O(^PS(52.41,"ARF",PSOX("IRXN"),0)) I DA D  S DIK="^PS(52.41," D ^DIK
        .S PSORFKL=DA D PSOUL^PSSLOCK(PSORFKL_"S") K PSORFKL
        K PSOR52,DA,DIK
        Q
        ;
DD      ;rx data nodes
        ;;PSOX("PROVIDER");;0;;17
        ;;PSOX("QTY");;0;;4
        ;;PSOX("DAYS SUPPLY");;0;;10
        ;;PSOX("MAIL/WINDOW");;0;;2
        ;;PSOX("REMARKS");;0;;3
        ;;PSOX("CLERK CODE");;0;;7
        ;;PSOX("COST");;0;;11
        ;;PSOSITE;;0;;9
        ;;PSOX("LOGIN DATE");;0;;8
        ;;PSOX("FILL DATE");;0;;1
        ;;PSOX("PHARMACIST");;0;;5
        ;;PSOX("LOT #");;0;;6
        ;;PSOX("DISPENSED DATE");;0;;19
        ;;PSOX("NDC");;1;;3
        ;;PSOX("DAW");;EPH;;1
        ;;PSOX("MANUFACTURER");;0;;14
        ;;PSOX("EXPIRATION DATE");;0;;15
        ;;PSOX("GENERIC PROVIDER");;1;;1
        ;;PSOX("RELEASED DATE/TIME");;0;;18