PSOORED6        ;BIR/SAB - edit orders from backdoor ;03/06/96
        ;;7.0;OUTPATIENT PHARMACY;**78,104,117,133,143,219,148,247,268,260,269**;DEC 1997;Build 4
        ;External reference to ^PSDRUG supported by DBIA 221
        ;External reference to ^PS(50.7 supported by DBIA 2223
        ;External reference ^PS(50.606 supported by DBIA 2174
DRG     ;select drug
        S PSORX("EDIT")=1,RX0HLD=RX0
        S PSODRUG("IEN")=$S($G(PSODRUG("IEN"))]"":PSODRUG("IEN"),1:$P(RX0,"^",6)),PSODRUG("NAME")=$S($G(PSODRUG("NAME"))]"":PSODRUG("NAME"),1:$P(^PSDRUG($P(RX0,"^",6),0),"^"))
        D ^PSODRG I PSODRUG("IEN")=$P(RX0,"^",6) K PSORXED("FLD",6)
        D:PSODRUG("IEN")'=$P(RX0,"^",6)  I $G(PSORX("DFLG")) K PSORXED("FLD",6) S PSORXED("DFLG")=1 Q
        .D POST^PSODRG
        .I '$O(^PSRX(PSORXED("IRXN"),1,0)) S PSORXED("FLD",17)=$G(PSODRUG("COST"))
        .I $G(PSORX("DFLG")) K PSORXED("FLD",6),PSODRUG,PSOOIFLG,PSOSIGFL,VALMSG Q
        .D KV S DIR(0)="Y",DIR("B")="YES"
        .S DIR("A",1)="You have changed the dispense drug from"
        .S DIR("A",2)=$P(^PSDRUG($P(PSORXED("RX0"),"^",6),0),"^")_" to "_$P(^PSDRUG(PSODRUG("IEN"),0),"^")_"."
        .I $P($G(^PSRX(PSORXED("IRXN"),"SIG")),"^",2),$O(^PSRX(PSORXED("IRXN"),"SIG1",0)) S DIR("A",3)="" D
        ..F I=0:0 S I=$O(^PSRX(PSORXED("IRXN"),"SIG1",I)) Q:'I  S DIR("A",3+I)=$S(I=1:"Current SIG: ",1:"")_$G(^PSRX(PSORXED("IRXN"),"SIG1",I,0))
        .S DIR("A")="Do You want to Edit the SIG"
        .D ^DIR K DIR I $D(DIRUT) S PSORX("DFLG")=1 D M1
        .Q:$D(DIRUT)!('Y)
        .S PSOREEDQ=1 D DOLST^PSOORED3,DOSE^PSOORED3 K PSOREEDQ
        .I '$O(PSORXED("DOSE",0)) S PSORX("DFLG")=1 Q
        .D:$G(PSOSIGFL) M2
        S RX0=RX0HLD K RX0HLD I $G(PSODRUG("OI"))=$G(PSOI) D  Q
        .D:$O(^TMP("PSORXDC",$J,0))
        ..W !!,"This edit will discontinue the duplicate Rx & change the dispensed drug!"
        ..K DIR,X,Y S DIR("A")="Do You Want to Proceed",DIR("B")="NO",DIR(0)="Y"
        ..D ^DIR K DIR S:'Y!($D(DIRUT)) PSORXED("DFLG")=1 D:Y DCORD^PSONEW2
        .Q:$G(PSORXED("DFLG"))
        .I PSODRUG("IEN")'=$P(RX0,"^",6) D
        ..S PSORXED("FLD",6)=PSODRUG("IEN"),PSORXED("FLD",39.2)=PSOI
        .S:$G(PSODRUG("TRADE NAME"))]"" PSORXED("FLD",6.5)=PSODRUG("TRADE NAME")
        .S:$G(PSODRUG("NDC"))]"" PSORXED("FLD",27)=PSODRUG("NDC")
        .S:$G(PSODRUG("DAW"))]"" PSORXED("FLD",81)=PSODRUG("DAW")
        W !!,"New Orderable Item selected. This edit will create a new prescription!",! D PAUSE^VALM1 S VALMSG="New Orderable Item selected. This edit will create a new prescription!" S (PSOOIFLG,PSOSIGFL)=1
        Q
PSOCOU  ;patient counseling
        K DIC,DIQ S DIC=52,DA=PSORXED("IRXN"),DIQ="PSORXED",DR=41 D EN^DIQ1 K DIC,DIQ
        D KV S DIR(0)="52,41" S:$G(PSORXED(52,DA,DR))]"" DIR("B")=PSORXED(52,DA,DR) D ^DIR K DIR,PSORXED(52,DA,DR)
        I $D(DIRUT) K PSORXED("FLD",41) D KV Q
        S PSORXED("FLD",DR)=Y D  K DIRUT
        .I Y D  Q
        ..K DIC,DIQ S DIC=52,DA=PSORXED("IRXN"),DIQ="PSORXED",DR=42 D EN^DIQ1 K DIC,DIQ
        ..K DIR,DIRUT S DIR(0)="52,42" S:$G(PSORXED(52,DA,DR))]"" DIR("B")=PSORXED(52,DA,DR) D ^DIR K DIR,PSORXED(52,DA,DR)
        ..I $D(DIRUT) K PSORXED("FLD",41),DUOUT,DTOUT Q
        ..S PSORXED("FLD",42)=Y
        .S PSORXED("FLD",41)=0,PSORXED("FLD",42)="@"
        Q
PSOI    ;select orderable item
        W !!,"Current Orderable Item: "_$P(^PS(50.7,PSOI,0),"^")_" "_$P(^PS(50.606,$P(^(0),"^",2),0),"^")
        S DIC("B")=$P(^PS(50.7,PSOI,0),"^"),DIC="^PS(50.7,",DIC(0)="AEMQZ"
        S DIC("S")="I '$P(^PS(50.7,+Y,0),""^"",4)!($P(^(0),""^"",4)'<DT) N PSOF,PSOL S (PSOF,PSOL)=0 F  S PSOL=$O(^PSDRUG(""ASP"",+Y,PSOL)) Q:PSOF!'PSOL  "
        S DIC("S")=DIC("S")_"I $P($G(^PSDRUG(PSOL,2)),U,3)[""O"",'$G(^(""I""))!($G(^(""I""))'<DT) S PSOF=1"
        ;BHW;PSO*7*269;Modify ^DIC call to call MIX^DIC to use only the B and C Cross-References.
        S D="B^C" D MIX^DIC1 I "^"[X S PSORXED("DFLG")=1 Q
        G:Y<1 PSOI Q:PSOI=+Y
        S PSODRUG("OI")=+Y,PSODRUG("OIN")=Y(0,0) K DIC
        I PSOI'=PSODRUG("OI") W !!,"New Orderable Item selected. This edit will create a new prescription!",! D  K PSHOLDD Q
        .D PAUSE^VALM1,M2
        .S PSHOLDD=$G(PSODRUG("IEN")) K PSODRUG("IEN"),PSODRUG("NAME") S PSODRUG("DEA")="",(PSOOIFLG,PSOSIGFL)=1
        .D DREN^PSOORNW2
        .I $G(PSHOLDD),$G(PSODRUG("IEN")),$G(PSHOLDD)'=$G(PSODRUG("IEN")) D  Q:$G(PSORX("DFLG"))
        ..D FULL^VALM1,POST^PSODRG S VALMBCK="R"
        ..I $G(PSORX("DFLG")) K PSODRUG S PSODRUG("IEN")=$G(PSHOLDD),PSODRUG("NAME")=$P($G(^PSDRUG(PSODRUG("IEN"),0)),"^") K PSOOIFLG,PSOSIGFL S VALMSG=""
        .I '$G(PSODRUG("IEN")) W !!,"DRUG NAME REQUIRED!" D 2^PSOORNW1
        .I '$G(PSODRUG("IEN")) K PSORXED("FLD"),INDEL,^TMP($J,"INS1"),PSOSIGFL,VALMSG S PSORXED("DFLG")=1,VALMSG="Dispense Drug NOT Selected!" Q
        .D KV S DIR(0)="Y",DIR("B")="NO",DIR("A",1)="You have changed the Orderable Item from",DIR("A",2)=$P(^PS(50.7,PSOI,0),"^")_" to "_PSODRUG("OIN")_".",DIR("A")="Do You want to Edit the SIG"
        .D ^DIR K DIR I $D(DIRUT) K PSODRUG("OIN"),PSOOIFLG,PSOSIGFL S PSODRUG("OI")=PSOI,VALMSG="",PSORX("DFLG")=1 Q
        .I 'Y S PSORX("DFLG")=1 Q
        .S PSOREEDQ=1 D DOLST^PSOORED3,DOSE^PSOORED3 K PSOREEDQ
        .I '$O(PSORXED("DOSE",0)) S PSORX("DFLG")=1 Q
        .D:$G(PSOSIGFL) M2
        S PSORXED("FLD",39.2)=PSOI
        Q
NCPDP   ;Reverse previously billed Rx on an edited orderable item or drug. 
        N RX,NPSOY
        S RX=$G(PSORXED("IRXN")) I RX="" D
        . S NPSOY=$O(PSONEW("OLD LAST RX#","")),NPSOY=$G(PSONEW("OLD LAST RX#",NPSOY)),RX=$O(^PSRX("B",NPSOY,RX))
        I 'RX Q
        D REVERSE^PSOBPSU1(RX,,"DC",7) S NCPDPFLG=0
        Q
UPDATE  ;add new data to file
        N RXREF,UPDATE,FLDS,CHGNDC
        Q:'$G(PSORXED("IRXN"))
        I $O(PSORXED("FLD",0))!($G(^TMP($J,"INS1",0))]"")!($G(INSDEL))!($O(PSORXED("ODOSE",0))) D  G:'Y UPDX
        .K DIR,DIRUT,DTOUT,DUOUT
        .S DIR(0)="Y",DIR("A")="Are You Sure You Want to Update Rx "_$P(^PSRX(PSORXED("IRXN"),0),"^"),DIR("B")="Yes"
        .D ^DIR K DIR I 'Y D M1 Q
        .I $D(^PSRX(PSORXED("IRXN"),1,0))  D
        ..S RXREF=$P(^PSRX(PSORXED("IRXN"),0),"^",9)-$P(^PSRX(PSORXED("IRXN"),1,0),"^",4)
        .E  S RXREF=0
        .K X,DIRUT,DUOUT,DTOUT
        I $D(PSORXED("FLD",39.3)) D UPDATE^PSODIAG  ;update ICD's after edit
        ; - Retrieving fields before changes that are relevant for 3rd Party Billing
        D GETS^DIQ(52,PSORXED("IRXN")_",","4;7;8;20;22;27;81","I","FLDS")
        K Y S DA=PSORXED("IRXN"),DIE="^PSRX(",FLD=0
        F  S FLD=$O(PSORXED("FLD",FLD)) Q:'FLD  D
        .I FLD=12!(FLD=24)!(FLD=35) D  Q
        ..I FLD=12,PSORXED("FLD",12)="@" S $P(^PSRX(DA,3),"^",7)="" Q
        ..I FLD=12,PSORXED("FLD",12)]"" S $P(^PSRX(DA,3),"^",7)=PSORXED("FLD",12) Q
        ..I FLD=24,PSORXED("FLD",24)="@" S $P(^PSRX(DA,2),"^",4)="" Q
        ..I FLD=24,PSORXED("FLD",24)]"" S $P(^PSRX(DA,2),"^",4)=PSORXED("FLD",24) Q
        ..I FLD=35,PSORXED("FLD",35)="@" S $P(^PSRX(DA,"MP"),"^")="" Q
        ..I FLD=35,PSORXED("FLD",35)]"" S $P(^PSRX(DA,"MP"),"^")=PSORXED("FLD",35) Q
        .I FLD=114 D  Q
        ..I PSORXED("FLD",114)="@" K ^PSRX(DA,"INS"),^PSRX(DA,"INS1")
        ..I PSORXED("FLD",114)'="@" D
        ...S ^PSRX(DA,"INS")=PSORXED("FLD",114)
        ...S X=PSORXED("FLD",114) D SIG^PSOHELP Q:$G(INS1)']""
        ...S PSORXED("SIG",1)=$E(INS1,2,9999999) K ^PSRX(DA,"INS1")
        ...S ^PSRX(DA,"INS1",0)="^52.0115^1^1^"_DT_"^^"
        ...S ^PSRX(DA,"INS1",1,0)=PSORXED("SIG",1)
        ..D DOLST^PSOORED3 K:PSORXED("FLD",114)="@" PSORXED("SIG") D EN^PSOFSIG(.PSORXED),UPDSIG^PSOORED3
        .I FLD=27 D  Q
        ..I PSORXED("FLD",27)'=$$GETNDC^PSONDCUT(DA,0) D
        ...S CHGNDC=1 D RXACT^PSOBPSU2(DA,0,"NDC changed from "_$$GETNDC^PSONDCUT(DA,0)_" to "_PSORXED("FLD",27)_".","E")
        ..D SAVNDC^PSONDCUT(DA,0,PSORXED("FLD",27),0,1)
        .I FLD=81 D SAVDAW^PSODAWUT(DA,0,PSORXED("FLD",81)) Q
        .S DR=FLD_"////"_PSORXED("FLD",FLD) D ^DIE
        .I FLD=4 D UDPROV^PSOOREDT Q
        ;
        ; - Re-submitting Rx to ECME due to edits
        D RESUB^PSOORED7
        ;
        I $G(INSDEL) K ^PSRX(DA,"INS"),^PSRX(DA,"INS1") D DOLST^PSOORED3 K PSORXED("SIG") D EN^PSOFSIG(.PSORXED),UPDSIG^PSOORED3 G UPDX
        I $O(^TMP($J,"INS1",0)) D
        .K ^PSRX(DA,"INS"),^PSRX(DA,"INS1"),DD,PSORXED("SIG")
        .F I=0:0 S I=$O(^TMP($J,"INS1",I)) Q:'I  S (PSORXED("SIG",I),^PSRX(DA,"INS1",I,0))=^TMP($J,"INS1",I,0),DD=$G(DD)+1
        .S ^PSRX(DA,"INS1",0)=^TMP($J,"INS1",0)
        .I DD=1 S ^PSRX(DA,"INS")=^PSRX(DA,"INS1",1,0)
        .D DOLST^PSOORED3,EN^PSOFSIG(.PSORXED),UPDSIG^PSOORED3
        ;
UPDX    ;
        K DIE,DA,DR,FLD,X,Y,PSORXED("FLD"),DD,^TMP($J,"INS1")
KV      K DIR,DIRUT,DTOUT,DUOUT
        Q
UPD     ;updates dosing array
        S HENT=ENT
UPD1    ;
        I $G(PSORXED("CONJUNCTION",(HENT+1)))]"" S PSORXED("CONJUNCTION",HENT)=PSORXED("CONJUNCTION",(HENT+1)) D  G UPD
        .K PSORXED("CONJUNCTION",(HENT+1))
        .I $D(PSORXED("DOSE",(HENT+2))) D
        ..S PSORXED("DOSE",(HENT+1))=PSORXED("DOSE",(HENT+2))
        ..S PSORXED("ODOSE",(HENT+1))=$G(PSORXED("ODOSE",(HENT+2)))
        ..S PSORXED("DOSE ORDERED",(HENT+1))=$G(PSORXED("DOSE ORDERED",(HENT+2)))
        ..S PSORXED("UNITS",(HENT+1))=$G(PSORXED("UNITS",(HENT+2)))
        ..S PSORXED("NOUN",(HENT+1))=$G(PSORXED("NOUN",(HENT+2)))
        ..S PSORXED("DURATION",(HENT+1))=$G(PSORXED("DURATION",(HENT+2)))
        ..S PSORXED("CONJUNCTION",(HENT+1))=$G(PSORXED("CONJUNCTION",(HENT+2)))
        ..S PSORXED("ROUTE",(HENT+1))=$G(PSORXED("ROUTE",(HENT+2)))
        ..S PSORXED("SCHEDULE",(HENT+1))=$G(PSORXED("SCHEDULE",(HENT+2)))
        ..S PSORXED("VERB",(HENT+1))=$G(PSORXED("VERB",(HENT+2)))
        ..K PSORXED("DOSE",(HENT+2)),PSORXED("ODOSE",(HENT+2)),PSORXED("DOSE ORDERED",(HENT+2))
        ..K PSORXED("UNITS",(HENT+2)),PSORXED("NOUN",(HENT+2)),PSORXED("DURATION",(HENT+2)),PSORXED("ROUTE",(HENT+2)),PSORXED("SCHEDULE",(HENT+2)),PSORXED("VERB",(HENT+2))
        .S HENT=HENT+1
        F I=0:0 S I=$O(PSORXED("DOSE",I)) Q:'I  S SENT=$G(SENT)+1
        Q
        ;
M1      D M1^PSOOREDX
        Q
M2      D M2^PSOOREDX
        Q