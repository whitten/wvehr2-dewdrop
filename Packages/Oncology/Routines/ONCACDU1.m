ONCACDU1        ;Hines OIFO/GWB - NAACCR extract utilities #1 ;06/23/00
        ;;2.11;Oncology;**12,14,16,20,21,22,24,26,27,28,33,36,37,42,45,46,49**;Mar 07, 1995;Build 38
        ;
BEHAV(IEN)      ;Behavior Code (called by extract RULES)
        N BEHAV
        S BEHAV=$E($$HIST^ONCFUNC(IEN),5)
        Q BEHAV
        ;
DATE(FMDT)      ;Convert date to NAACCR format mmddyyyy
        N DATE
        S DATE=""
        I FMDT'="" D
        .N MM,DD,YYYY,YYYMMDD,MMDDCCYY
        .S YYYMMDD=FMDT
        .I YYYMMDD="0000000" S DATE="00000000" Q
        .I YYYMMDD="8888888" S DATE="88888888" Q
        .I YYYMMDD="9999999" S DATE="99999999" Q
        .D
        ..S YYYY=($E(YYYMMDD,1,3)+1700)
        ..I YYYY=1900,$E(YYYMMDD,4,7)="0000" S YYYY="0000"
        .S MM=$S($E(YYYMMDD,4,5)'="00":$E(YYYMMDD,4,5),1:99)
        .S DD=$S($E(YYYMMDD,6,7)'="00":$E(YYYMMDD,6,7),1:99)
        .S MMDDCCYY=MM_DD_YYYY
        .S DATE=MMDDCCYY
        Q DATE
        ;
CNTY(IEN)       ;County at DX [90] 83-85
        N COUNTYPT,COUNTYNM,COUNTYIE,STATE,FIPSCODE
        S FIPSCODE=""
        S COUNTYPT=$$GET1^DIQ(165.5,IEN,10,"I")    ;Pointer to COUNTY (5.1)
        I COUNTYPT="" G QCNTY
        S FIPSCODE=$$GET1^DIQ(5.1,COUNTYPT,2,"I")  ;SEER COUNTY CODE (5.1,2)
        G:FIPSCODE'="" QCNTY                       ;QUIT if FIPSCODE found
        S COUNTYNM=$$GET1^DIQ(165.5,IEN,10,"E")    ;COUNTY (5.1) name 
        S STATE=$$GET1^DIQ(5.1,COUNTYPT,1,"I")     ;Pointer to STATE (5)
        S COUNTYIE=$O(^DIC(5,STATE,1,"B",COUNTYNM,0))
        I COUNTYIE'="" S FIPSCODE=$P($G(^DIC(5,STATE,1,COUNTYIE,0)),U,3)
        S:FIPSCODE="" FIPSCODE=999
QCNTY   Q FIPSCODE
        ;
AGEDX(IEN)      ;Age at Diagnosis [230] 119-121
        N ACDAGE,D0,X
        S D0=IEN
        D AGE^ONCOCOM S ACDAGE=$S(X=""!(X<0)!(X>999):"",1:X)
        Q ACDAGE
        ;
OCCUP(ACD160)   ;Text--Usual Occupation [310] 143-182
        N X,OCCUP
        S X="UNKNOWN"
        S OCCUP=$O(^ONCO(160,ACD160,7,0))
        I OCCUP'<1 D
        .N OCC
        .S OCC=$P($G(^ONCO(160,ACD160,7,OCCUP,0)),U,1)
        .Q:OCC<1
        .S X=$$GET1^DIQ(61.6,OCC,.01,"I")
        Q X
        ;
IND(ACD160)     ;Text--Usual Industry [320] 183-222
        N X,OCCUP
        S X="UNKNOWN"
        S OCCUP=$O(^ONCO(160,ACD160,7,0))
        I OCCUP'<1 D
        .N IND
        .S IND=$P($G(^ONCO(160,ACD160,7,OCCUP,0)),U,4)
        .Q:IND=""
        .S X=IND
        Q X
        ;
TOB(IEN)        ;Tobacco History [340] 224-224 VACCR extract only
        N X,AASTOB
        S X=$P($G(^ONCO(160,ACD160,8)),U,2)
        S AASTOB=$S(X="Y":"Y",X="N":0,X="U":9,1:X)
        I AASTOB="Y" D
        .N X S X=""
        .S X=$O(^ONCO(160,ACD160,5,X),-1)
        .I X'<1 I $G(^ONCO(160,ACD160,5,X,0))'="" D
        ..N Y S Y=^ONCO(160,ACD160,5,X,0)
        ..I $P(Y,U,3)'="" S AASTOB=5 Q  ;Previous use
        ..S AASTOB=$S($P(Y,U)=1:1,$P(Y,U)=2:2,$P(Y,U)=3:2,$P(Y,U)=4:3,$P(Y,U)=5:3,$P(Y,U)=7:4,1:9)
        .I AASTOB="Y" S AASTOB=9
        Q AASTOB
        ;
ALC(IEN)        ;Alcohol History [350] 225-225 VACCR extract only
        N X,AASALCO
        S X=$P($G(^ONCO(160,ACD160,8)),U,3)
        S AASALCO=$S(X="Y":"Y",X="N":0,X="U":9,1:X)
        I AASALCO="Y" D
        .N X S X=""
        .S X=$O(^ONCO(160,ACD160,6,X),-1)
        .I X'<1 I $G(^ONCO(160,ACD160,6,X,0))'="" D
        ..N Y S Y=^ONCO(160,ACD160,6,X,0)
        ..I $P(Y,U,4)'="" S AASALCO=2 Q  ;Past history of alcohol use
        ..S AASALCO=1
        .I AASALCO="Y" S AASALCO=9
        Q AASALCO
        ;
SG(IEN,TYPE)    ;TNM Stage Groups
        ;TNM Path Stage Group  [910]  569-570
        ;TNM Clin Stage Group  [970]  579-580
        N GS
        S GS=""
        I TYPE="" Q GS
        I TYPE="P" S GS=$$GET1^DIQ(165.5,IEN,88,"I")
        I TYPE="C" S GS=$$GET1^DIQ(165.5,IEN,38,"I")
        I GS'="" S GS=$S("^0^0A^0S^1^1A^1B^1S^1C^2^2A^2B^2C^3^3A^3B^3C^4^4A^4B^4C^OC^88^99^"[("^"_GS_"^"):GS,GS="1A1":"A1",GS="1A2":"A2",GS="1B1":"B1",GS="1B2":"B2",1:"99")
        Q GS
        ;
CC      ;Comorbid/Complication 1-10
        ;[3110] 675-679
        ;[3120] 680-684
        ;[3130] 685-689
        ;[3140] 690-694
        ;[3150] 695-699
        ;[3160] 700-704
        ;[3161] 717-721
        ;[3162] 722-726
        ;[3163] 727-731
        ;[3164] 732-736
        S CCEX(1)="00000"
        F CCSUB=1:1:10 S CC(CCSUB)=""
        S CCSUB=0
        F FLD=25:.1:25.9 S CC=$$GET1^DIQ(160,ACD160,FLD,"I") S:CC'="" CC=$$GET1^DIQ(80,CC,.01,"I") S CCSUB=CCSUB+1,CC(CCSUB)=$P(CC," ",1)
        F CCEXSUB=1:1:10 S CCEX(CCEXSUB)=""
        I CC(1)="" Q
        I EXT="VACCR" F CCSUB=1:1:10 S CCEX(CCSUB)=$P(CC(CCSUB),".",1)_$P(CC(CCSUB),".",2) G CCEX
        S CCEXSUB=0
        S CCSUB=0 F  S CCSUB=$O(CC(CCSUB)) Q:CCSUB'>0  D
        .I ($E(CC(CCSUB),1)="E")!($E(CC(CCSUB),1)="V")!((+CC(CCSUB)>99.9)&(+CC(CCSUB)<290))!(+CC(CCSUB)>319) S CCEXSUB=CCEXSUB+1,CCEX(CCEXSUB)=$P(CC(CCSUB),".",1)_$P(CC(CCSUB),".",2)
CCEX    K CC,CCEXSUB,CCSUB,FLD
        Q
        ;
RXCOD(IEN)      ;RX Coding System--Current [1460] 888-889
        N OUT
        S OUT="06"
        Q OUT
        ;
ZIP(ACD160)     ;Addr Current--Postal Code [1830] 1329-1337
        N X,D0,ONCOX1,OIEN,ONCOM,ONCON,ONCOT,ONCOX
        S X=""
        S D0=ACD160
        I $D(^ONCO(160,D0,0)) D SETUP1^ONCOES
        I $D(ONCOX1) S X=$S($D(@ONCOX1):$P(@ONCOX1,U,6),1:"")
        Q X
        ;
FHCT    ;Family History of Cancer Text 1456-1505 VACCR extract only
        K ONC S IEN160=ACD160_"," D GETS^DIQ(160,IEN160,"44*","","ONC")
        S (ACDANS,FHCTIEN)=""
        F  S FHCTIEN=$O(ONC(160.044,FHCTIEN)) Q:FHCTIEN'>0  D
        .S FHCT=ONC(160.044,FHCTIEN,.01)_"("_ONC(160.044,FHCTIEN,1)_")"
        .Q:($L(ACDANS)+$L(FHCT))>50
        .S ACDANS=ACDANS_FHCT_"/"
        S ACDANS=$E(ACDANS,1,$L(ACDANS)-1)
        K ONC,IEN160,FHCTIEN,FHCT
        Q
        ;
PHCT    ;Patient History of Cancer Text 1785-1804 VACCR extract only
        S ACDANS=""
        F I=148.1,148.2,148.3,148.4 S PHCTPT=$$GET1^DIQ(165.5,IEN,I,"I") D
        .Q:PHCTPT=""
        .S PHCT=$$GET1^DIQ(164.2,PHCTPT,.01,"I")
        .Q:PHCT="NOT APPLICABLE"
        .Q:($L(ACDANS)+$L(PHCT))>20
        .S ACDANS=ACDANS_PHCT_"/"
        S ACDANS=$E(ACDANS,1,$L(ACDANS)-1)
        K I,PHCTPT,PHCT
        Q
        ;
NL      ;Name--Last [2230] 1947-1971
        S ACDANS=$$STRIP^XLFSTR(ACDANS," !""""#$%&'()*+,./:;<=>?[>]^_\{|}~`")
        Q
        ;
ALIAS(ACD160)   ;Name--Alias [2280] 2006-2020
        N X,DO,ONCOX,XD0,XD1
        S X=""
        S D0=ACD160
        I $D(^ONCO(160,D0,0)) D
        .D SETUP^ONCOES
        .Q:$P(ONCOX,";",2)'="DPT("  S XD0=$P(ONCOX,";")
        .S XD1=0 F  S XD1=$O(^DPT(XD0,.01,XD1)) Q:XD1'>0  S X=$P(^(XD1,0),U) Q
        Q X
