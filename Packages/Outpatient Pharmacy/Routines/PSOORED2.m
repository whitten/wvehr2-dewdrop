PSOORED2        ;ISC-BHAM/SAB-edit orders from backdoor con't ;03/06/95 10:24
        ;;7.0;OUTPATIENT PHARMACY;**2,51,46,78,102,114,117,133,159,148,247,260,281,289,276,358**;DEC 1997;Build 35
        ;Reference to $$DIVNCPDP^BPSBUTL supported by IA 4719
        ;Reference to $$ECMEON^BPSUTIL supported by IA 4410
        ;called from psooredt. cmop edit checks.
        Q
ISDT    D CHK K RF I $G(CMRL) W !,"Released by CMOP.  No editing allowed on Issue Date." D PAUSE^VALM1 K CMRL Q
        S %DT="AEX",%DT(0)=-$P(^PSRX(DA,2),"^",2),Y=$P(RX0,"^",13) X ^DD("DD") S %DT("A")="ISSUE DATE: ",%DT("B")=Y D ^%DT I "^"[$E(X) K X,Y,%DT,DTOUT,DUOUT Q
        G:Y=-1 ISDT S PSORXED("FLD",1)=Y
        ;S DR="1///"_Y,DIE=52 D ^DIE
        D KV K X,Y,%DT
        Q
FLDT    D CHK K RF I $G(CMRL) W !,"Released by CMOP.  No editing allowed on Fill Date." D PAUSE^VALM1 K CMRL Q
        D KV S Y=$P(^PSRX(DA,2),"^",2) X ^DD("DD") S DIR("A")="FILL DATE",DIR("B")=Y
        S DIR(0)="D^"_$P(RX0,"^",13)_":"_$P(PSORXED("RX2"),"^",6)_":EX"
        S DIR("?",1)="The earliest fill date allowed is determined by the Issue Date,",DIR("?",2)="the Fill Date cannot be before the Issue Date or past the Expiration Date."
        S DIR("?")="Both the month and day are required." D ^DIR
        I $D(DIRUT) D KV K PSORXED("FLD",22),X,Y Q
        S PSORXED("FLD",22)=Y ;S DR="22R///"_Y,DIE=52 D ^DIE
        K X,Y
KV      K DIR,DUOUT,DTOUT,DIRUT
        Q
CHK     I $D(^PSRX("AR",+$P(PSORXED("RX2"),"^",13),PSORXED("IRXN"))) S CMRL=1 Q
        F RF=0:0 S RF=$O(^PSRX(PSORXED("IRXN"),1,RF)) Q:'RF  I $D(^PSRX("AR",+$P(^PSRX(PSORXED("IRXN"),1,RF,0),"^",18),PSORXED("IRXN"))) S CMRL=1
        Q
CHK1    I +^PSRX(PSORXED("IRXN"),"STA")=5 D  Q:'$G(CMRL)
        .S SURX=$O(^PS(52.5,PSORXED("IRXN"),0)) Q:'SURX  I $P(^PS(52.5,SURX,0),"^",7)']""!($P(^(0),"^",7)="Q") S CMRL=1
        .E  S CMRL=0
        F FEV=0:0 S FEV=$O(^PSRX(PSORXED("IRXN"),4,FEV)) Q:'FEV  I '$P(^PSRX(PSORXED("IRXN"),4,FEV,0),"^",3),$P(^(0),"^",4)<3 S CMRL=0
        Q
REF     ;shows refill info
        S RFN=0 F N=0:0 S N=$O(^PSRX(PSORXED("IRXN"),1,N)) Q:'N  S RFM=N,RFN=RFN+1
        ;G:RFM=1 SRF 
        W ! K DA,DR D KV S DIR(0)="Y",DIR("B")="No",DIR("A")="There "_$S(RFN>1:"are ",1:"is ")_RFN_" refill"_$S(RFN>1:"s.",1:".")_"  Do you want to edit"
        D ^DIR D KV Q:'Y
SRF     W !!,"#  Log Date   Refill Date  Qty               Routing  Lot #       Pharmacist",! F I=1:1:80 W "="
        F N=0:0 S N=$O(^PSRX(PSORXED("IRXN"),1,N)) Q:'N  S P1=^(N,0) D
        .S DTT=$P(P1,"^",8)\1 D DAT S LOG=DAT,DTT=$P(P1,"^"),$P(RN," ",10)=" " D DAT
        .W !,N_"  "_LOG_"   "_DAT_"      "_$P(P1,"^",4)_$E("               ",$L($P(P1,"^",4))+1,15)_"  "_$S($P(P1,"^",2)="M":"MAIL  ",1:"WINDOW")_"   "_$P(P1,"^",6)_$E(RN,$L($P(P1,"^",6))+1,12)
        .W $E($S($D(^VA(200,+$P(P1,"^",5),0)):$P(^(0),"^"),1:""),1,16)
        .S PSDIV=$S($D(^PS(59,+$P(P1,"^",9),0)):$P(^(0),"^",6),1:"Unknown") W !,"Division: "_PSDIV_$E("        ",$L(PSDIV)+1,8)_"  "
        .W "Dispensed: "_$S($P(P1,"^",19):$E($P(P1,"^",19),4,5)_"/"_$E($P(P1,"^",19),6,7)_"/"_$E($P(P1,"^",19),2,3),1:"")_"  "
        .S RTS=$S($P(P1,"^",16):" Returned to Stock: "_$E($P(P1,"^",16),4,5)_"/"_$E($P(P1,"^",16),6,7)_"/"_$E($P(P1,"^",16),2,3),1:" Released: "_$S($P(P1,"^",18):$E($P(P1,"^",18),4,5)_"/"_$E($P(P1,"^",18),6,7)_"/"_$E($P(P1,"^",18),2,3),1:""))
        .W RTS W:$P(P1,"^",3)]"" !,"   Remarks: "_$P(P1,"^",3)
        S DA(1)=PSORXED("IRXN") I RFN=1 S Y=RFM G RFM
        W ! D KV S DIR("A")="Select a Refill",DIR(0)="NO^1:"_RFM_":0" D ^DIR Q:$D(DIRUT)
RFM     I '$D(^PSRX(PSORXED("IRXN"),1,Y,0)) W !,$C(7),"Invalid selection.",! G SRF
        S CMRL=0 I $D(^PSRX("AR",+$P(^PSRX(PSORXED("IRXN"),1,Y,0),"^",18),PSORXED("IRXN"),Y)) S CMRL=1 G RFX
        F FEV=0:0 S FEV=$O(^PSRX(PSORXED("IRXN"),4,FEV)) Q:'FEV  I $P(^PSRX(PSORXED("IRXN"),4,FEV,0),"^",3)=Y,$P(^(0),"^",4)<3 S CMRL=1
RFX     N RFL,NDC,DAW,FLDS,QUIT,CHGNDC,CHANGED
        W ! S DA=Y,DIE="^PSRX("_DA(1)_",1,",DR=$S('CMRL:".01;1.1",1:"1.2:5;8")
        D GETS^DIQ(52.1,DA_","_DA(1)_",",".01;1;1.1;8;11;81","I","FLDS")
        S:$D(^PSRX(DA(1),1,DA,0)) PSORXED("RX1")=^PSRX(DA(1),1,DA,0),(RFED,RFL)=DA
        I $G(ST)=11!($G(ST)=12)!($G(ST)=14)!($G(ST)=15),$$STATUS^PSOBPSUT(PSORXED("IRXN"),RFL)'="" S QUIT=0 D RFE Q  ;short circuit for DC'd/Expired ECME RXs
        N PSORFILL S PSORFILL=DA   ;*276
        D ^DIE S QUIT=$D(Y)
        ;*276
        I '$D(^PSRX(PSORXED("IRXN"),1,PSORFILL)),'$G(PSOSFN) D
        .N DA,NOW,IR,FDA
        .S DA=$G(PSORXED("IRXN")) Q:'DA
        .S (FDA,IR)=0 F  S FDA=$O(^PSRX(DA,"A",FDA)) Q:'FDA  S IR=FDA
        .S IR=IR+1,^PSRX(DA,"A",0)="^52.3DA^"_IR_"^"_IR
        .D NOW^%DTC S NOW=%
        .S ^PSRX(DA,"A",IR,0)=NOW_"^D^"_DUZ_"^"_$S(PSORFILL>0&(PSORFILL<6):PSORFILL,1:PSORFILL+1)_"^Refill deleted during Rx edit"
        K FEV,RFN,RFM,X,Y,DR
        I '$G(DA) D REVERSE^PSOBPSU1(PSORXED("IRXN"),RFL,"DE",5) K CMRL,RFED D:$D(PSORX("PSOL"))&($G(DI)=.01) RFD Q
        I 'CMRL,'QUIT S DR="1;1.2:5;8" D ^DIE S QUIT=$D(Y)
RFE     I '$D(^PSRX(PSORXED("IRXN"),1,RFL)) Q
        I 'QUIT,$$STATUS^PSOBPSUT(PSORXED("IRXN"),RFL)'="" D
        . S NDC=$$GETNDC^PSONDCUT(PSORXED("IRXN"),RFL)
        . D EDTDAW^PSODAWUT(PSORXED("IRXN"),RFL,.DAW) I $G(DAW)="^" Q
        . D SAVDAW^PSODAWUT(PSORXED("IRXN"),RFL,+$G(DAW))
        . D NDC^PSODRG(PSORXED("IRXN"),RFL,,.NDC) I $G(NDC)="^",$G(NDC)="" Q
        . I NDC'=$$GETNDC^PSONDCUT(PSORXED("IRXN"),RFL) D
        . . S CHGNDC=1 D RXACT^PSOBPSU2(PSORXED("IRXN"),RFL,"NDC changed from "_$$GETNDC^PSONDCUT(PSORXED("IRXN"),RFL)_" to "_NDC_".","E")
        . D SAVNDC^PSONDCUT(PSORXED("IRXN"),RFL,NDC)
        S CHANGED=$$CHANGED(PSORXED("IRXN"),RFL,.FLDS)
        I CHANGED D
        . I $P(CHANGED,"^",2),'$$ECMEON^BPSUTIL($$RXSITE^PSOBPSUT(PSORXED("IRXN"),RFL)) D  Q
        . . D REVERSE^PSOBPSU1(PSORXED("IRXN"),RFL,"DC",99,"REFILL DIVISION CHANGED",1)
        . I $$SUBMIT^PSOBPSUT(PSORXED("IRXN"),RFL,1,1) D
        . . N RX S RX=PSORXED("IRXN")
        . . I '$P(CHANGED,"^",2),$$STATUS^PSOBPSUT(RX,RFL)="" Q
        . . D ECMESND^PSOBPSU1(RX,RFL,,"ED",$$GETNDC^PSONDCUT(RX,RFL),,$S($P(CHANGED,"^",2):"REFILL DIVISION CHANGED",1:"REFILL EDITED"),,+$G(CHGNDC))
        . . ; Quit if there is an unresolved Tricare non-billable reject code, PSO*7*358
        . . I $$PSOET^PSOREJP3(RX,RFL) S X="Q" Q
        . . ;- Checking/Handling DUR/79 Rejects
        . . I $$FIND^PSOREJUT(RX,RFL) S X=$$HDLG^PSOREJU1(RX,RFL,"79,88","ED","IOQ","Q")
        K DIE,CMRL,DA,DR
        Q
CHANGED(RX,RFL,PRIOR)   ; - Check if fields have changed and should for 3rd Party Claim resubmission
        ;Input:  (r) RX    - Rx IEN
        ;        (r) RFL   - Refill #
        ;        (r) PRIOR - Array with fields
        ;Output:  CHANGED  - 0 - Not changed / 1 - Refill field changed ^ Rx Division changed (1 - YES)
        N CHANGED,SAVED
        S CHANGED=0 D GETS^DIQ(52.1,RFL_","_RX_",",".01;1;1.1;8;11;81","I","SAVED")
        F I=.01,1,1.1,11,81 I $G(PRIOR(52.1,RFL_","_RX_",",I,"I"))'=$G(SAVED(52.1,RFL_","_RX_",",I,"I")) S CHANGED=1 Q
        I $$DIVNCPDP^BPSBUTL(+$G(PRIOR(52.1,RFL_","_RX_",",8,"I")))'=$$DIVNCPDP^BPSBUTL(+$G(SAVED(52.1,RFL_","_RX_",",8,"I"))) S CHANGED="1^1"
        Q CHANGED
        ;
DAT     S DAT="",DTT=DTT\1 Q:DTT'?7N  S DAT=$E(DTT,4,5)_"/"_$E(DTT,6,7)_"/"_$E(DTT,2,3)
        Q
DIE     S DIE=52 D ^DIE I $D(Y) S PSORXED("DFLG")=1
        K DIE,DR,X,Y
        Q
RFD     ;check for deleted refill
        M PSOZ1("PSOL")=PSORX("PSOL") N I,J,K,PSOX2,PSOX3,PSOX9 S (I,K)=0 D
        .F  S I=$O(PSOZ1("PSOL",I)) Q:'I!(K)  S PSOX2=PSOZ1("PSOL",I) I PSOX2[(PSORXED("IRXN")_",") S PSOX9="" D
        ..F J=1:1 S PSOX3=$P(PSOX2,",",J) Q:'PSOX3  D
        ...I 'K,PSOX3=PSORXED("IRXN") S K=1
        ...E  S PSOX9=PSOX9_$S('PSOX9:"",1:",")_PSOX3
        ..I K S:PSOX9]"" PSORX("PSOL",I)=PSOX9_"," K:PSOX9="" PSORX("PSOL",I)
        K PSOZ1("PSOL")
        Q
EDTDOSE ;edit med instructions fields
        I '$O(^PSRX(PSORXED("IRXN"),6,0)) D DOSE^PSOORED5 Q
        D ^PSOORED3
        Q
UPD     ;updates dosing array
        S HENT=ENT
UPD1    I $G(PSORXED("CONJUNCTION",(HENT+1)))]"",'$D(PSORXED("DOSE",(HENT+2))) K PSORXED("CONJUNCTION",(HENT+1)) Q
        I $G(PSORXED("CONJUNCTION",(HENT+1)))]"" S PSORXED("CONJUNCTION",HENT)=PSORXED("CONJUNCTION",(HENT+1)) D  G UPD1
        .K PSORXED("CONJUNCTION",(HENT+1))
        .F  Q:'$D(PSORXED("DOSE",(HENT+2)))  D
        ..S PSORXED("DOSE",(HENT+1))=PSORXED("DOSE",(HENT+2))
        ..S PSORXED("DOSE ORDERED",(HENT+1))=$G(PSORXED("DOSE ORDERED",(HENT+2)))
        ..S PSORXED("UNITS",(HENT+1))=$G(PSORXED("UNITS",(HENT+2)))
        ..S PSORXED("NOUN",(HENT+1))=$G(PSORXED("NOUN",(HENT+2)))
        ..S PSORXED("DURATION",(HENT+1))=$G(PSORXED("DURATION",(HENT+2)))
        ..S PSORXED("CONJUNCTION",(HENT+1))=$G(PSORXED("CONJUNCTION",(HENT+2)))
        ..S PSORXED("ROUTE",(HENT+1))=$G(PSORXED("ROUTE",(HENT+2)))
        ..S PSORXED("SCHEDULE",(HENT+1))=$G(PSORXED("SCHEDULE",(HENT+2)))
        ..S PSORXED("ODOSE",(HENT+1))=$G(PSORXED("ODOSE",(HENT+2)))
        ..S HENT=HENT+1
        ..I $G(PSORXED("CONJUNCTION",(HENT+2)))]"" Q
        ..K PSORXED("UNITS",(HENT+1)),PSORXED("NOUN",(HENT+1)),PSORXED("DURATION",(HENT+1)),PSORXED("CONJUNCTION",(HENT+1)),PSORXED("ROUTE",(HENT+1)),PSORXED("SCHEDULE",(HENT+1)),PSORXED("DOSE",(HENT+1)),PSORXED("DOSE ORDERED",(HENT+1))
        ..K PSORXED("VERB",(HENT+1)),PSORXED("ODOSE",(HENT+1))
        S PSORXED("ENT")=HENT K HENT,SENT D EN^PSOFSIG(.PSORXED)
        Q
UPD2    I $G(PSORXED("CONJUNCTION",(HENT+1)))]"",'$D(PSORXED("DOSE",(HENT+2))) K PSORXED("CONJUNCTION",(HENT+1)) Q
        I $G(PSORXED("CONJUNCTION",(HENT+1)))]"" S PSORXED("CONJUNCTION",HENT)=PSORXED("CONJUNCTION",(HENT+1)) D  G UPD1
        .K PSORXED("CONJUNCTION",(HENT+1)) I $D(PSORXED("DOSE",(HENT+2))) D
        ..S PSORXED("DOSE",(HENT+1))=PSORXED("DOSE",(HENT+2))
        ..S PSORXED("DOSE ORDERED",(HENT+1))=$G(PSORXED("DOSE ORDERED",(HENT+2)))
        ..S PSORXED("UNITS",(HENT+1))=$G(PSORXED("UNITS",(HENT+2)))
        ..S PSORXED("NOUN",(HENT+1))=$G(PSORXED("NOUN",(HENT+2)))
        ..S PSORXED("VERB",(HENT+1))=$G(PSORXED("VERB",(HENT+2)))
        ..S PSORXED("DURATION",(HENT+1))=$G(PSORXED("DURATION",(HENT+2)))
        ..S PSORXED("CONJUNCTION",(HENT+1))=$G(PSORXED("CONJUNCTION",(HENT+2)))
        ..S PSORXED("ROUTE",(HENT+1))=$G(PSORXED("ROUTE",(HENT+2)))
        ..S PSORXED("SCHEDULE",(HENT+1))=$G(PSORXED("SCHEDULE",(HENT+2)))
        ..S PSORXED("ODOSE",(HENT+1))=$G(PSORXED("ODOSE",(HENT+2)))
        ..S HENT=HENT+1
        ..I $G(PSORXED("CONJUNCTION",(HENT+1)))]"" Q
        ..K PSORXED("UNITS",(HENT+1)),PSORXED("NOUN",(HENT+1)),PSORXED("DURATION",(HENT+1)),PSORXED("ROUTE",(HENT+1)),PSORXED("SCHEDULE",(HENT+1)),PSORXED("DOSE",(HENT+1)),PSORXED("DOSE ORDERED",(HENT+1)),PSORXED("VERB",(HENT+1))
        ..K PSORXED("ODOSE",(HENT+1))
        F I=0:0 S I=$O(PSORXED("DOSE",I)) Q:'I  S SENT=$G(SENT)+1
        S PSORXED("ENT")=SENT K HENT,SENT D EN^PSOFSIG(.PSORXED)
        Q
