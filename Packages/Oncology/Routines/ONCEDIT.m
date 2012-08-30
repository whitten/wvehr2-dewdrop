ONCEDIT ;Hines OIFO/GWB - ONCOLOGY INTER-FIELD EDITS ;09/29/00
        ;;2.11;ONCOLOGY;**27,28,34,36,39,42,43,45,46,47,49**;Mar 07, 1995;Build 38
        ;
        N BCOD,COCE,COCI,HSTE,HSTFLD,HSTI,SSTE,SSTI,STAT,TOPE,TOPI,TRSE,TRSI,X
        K MSG
        S RHSP=$$GET1^DIQ(165.5,PRM,.03,"I")  ;REPORTING FACILITY
        S COCI=$$GET1^DIQ(165.5,PRM,.04,"I")  ;CLASS OF CASE
        S COCE=$$GET1^DIQ(165.5,PRM,.04,"E")
        S STAT=$$GET1^DIQ(165.5,PRM,.091)     ;STATUS
        S TRSI=$$GET1^DIQ(165.5,PRM,1.2,"I")  ;TYPE OF REPORTING SOURCE
        S TRSE=$$GET1^DIQ(165.5,PRM,1.2,"E")
        S RFAC=$$GET1^DIQ(165.5,PRM,6,"I")    ;FACILITY REFERRED FROM
        S TFAC=$$GET1^DIQ(165.5,PRM,7,"I")    ;FACILITY REFERRED TO
        S TOPI=$$GET1^DIQ(165.5,PRM,20,"I")   ;PRIMARY SITE
        S TOPE=$$GET1^DIQ(165.5,PRM,20,"E")
        S HSTI=$$HIST^ONCFUNC(PRM,.HSTFLD)    ;HISTOLOGY
        S HSTE=$$GET1^DIQ(165.5,PRM,HSTFLD,"E")
        S BCOD=$E(HSTI,5)                     ;BEHAVIOR CODE
        S SSTI=$$GET1^DIQ(165.5,PRM,35,"I")   ;SUMMARY STAGE
        S SSTE=$$GET1^DIQ(165.5,PRM,35,"E")
        ;
IF02    S SDX=""
        S SDXI=$$GET1^DIQ(165.5,PRM,16,"I")   ;STATE AT DX
        S SDXE=$$GET1^DIQ(165.5,PRM,16,"E")
        I SDXI'="" S SDX=$P(^ONCO(160.15,SDXI,0),U,1)
        S PCDX=$$GET1^DIQ(165.5,PRM,9,"I")    ;POSTAL CODE AT DX
        I SDX="YY",PCDX'=888888888 D  D ERRMSG
        .S MSG(1)="STATE AT DX = YY ("_SDXE_")"
        .S MSG(2)="POSTAL CODE AT DX must be 888888888"
        I SDX="ZZ",PCDX'=999999999 D  D ERRMSG
        .S MSG(1)="STATE AT DX = ZZ ("_SDXE_")"
        .S MSG(2)="POSTAL CODE AT DX must be 999999999"
        K MSG,PCDX,SDX,SDXI,SDXE
        ;
IF03    I RHSP=RFAC D  D ERRMSG
        .S MSG(1)="REPORTING HOSPITAL = FACILITY REFERRED FROM"
        I RHSP=TFAC D  D ERRMSG
        .S MSG(1)="REPORTING HOSPITAL = FACILITY REFERRED TO"
        ;
IF10    I ((COCI=2)!(COCI=3)),RFAC="" D  D ERRMSG
        .S MSG(1)="CLASS OF CASE = "_COCI_" ("_COCE_")"
        .S MSG(2)="FACILITY REFERRED FROM may not be blank"
        K MSG,RHSP,RFAC,TFAC
        ;
IF06    N DDXE,DDXI
        S DIAI=$$GET1^DIQ(165.5,PRM,155,"I")  ;DATE OF FIRST CONTACT
        S DIAE=$$GET1^DIQ(165.5,PRM,155,"E")
        S DDXI=$$GET1^DIQ(165.5,PRM,3,"I")    ;DATE DX
        S DDXE=$$GET1^DIQ(165.5,PRM,3,"E")
        I DIAE="99/99/9999" G IF06EX
        S MSG(1)="CLASS OF CASE = "_COCI_" ("_COCE_")"
        S MSG(2)="DATE OF FIRST CONTACT..: "_DIAE
        S MSG(3)=" later than"
        I COCI=0 D
        .S SPSI=$$GET1^DIQ(165.5,PRM,50,"I")  ;MOST DEFINITIVE SURG DATE
        .S SPSE=$$GET1^DIQ(165.5,PRM,50,"E")
        .S RADI=$$GET1^DIQ(165.5,PRM,51,"I")  ;DATE RADIATION STARTED
        .S RADE=$$GET1^DIQ(165.5,PRM,51,"E")
        .S CNSI=$$GET1^DIQ(165.5,PRM,52,"I")  ;RADIATION THERAPY TO CNS DATE
        .S CNSE=$$GET1^DIQ(165.5,PRM,52,"E")
        .S CHMI=$$GET1^DIQ(165.5,PRM,53,"I")  ;CHEMOTHERAPY DATE
        .S CHME=$$GET1^DIQ(165.5,PRM,53,"E")
        .S HORI=$$GET1^DIQ(165.5,PRM,54,"I")  ;HORMONE THERAPY DATE
        .S HORE=$$GET1^DIQ(165.5,PRM,54,"E")
        .S BRMI=$$GET1^DIQ(165.5,PRM,55,"I")  ;IMMUNOTHERAPY DATE
        .S BRME=$$GET1^DIQ(165.5,PRM,55,"E")
        .S OTHI=$$GET1^DIQ(165.5,PRM,57,"I")  ;OTHER TREATMENT START DATE
        .S OTHE=$$GET1^DIQ(165.5,PRM,57,"E")
        .I SPSI'="0000000",DIAI>SPSI D  D ERRMSG
        ..S MSG(4)="MOST DEFINITIVE SURG DATE....: "_SPSE
        .I RADI'="0000000",DIAI>RADI D  D ERRMSG
        ..S MSG(4)="DATE RADIATION STARTED.......: "_RADE
        .I DDXI<2960000,CNSI'="0000000",DIAI>CNSI D  D ERRMSG
        ..S MSG(4)="RADIATION THERAPY TO CNS DATE: "_CNSE
        .I CHMI'="0000000",DIAI>CHMI D  D ERRMSG
        ..S MSG(4)="CHEMOTHERAPY DATE............: "_CHME
        .I HORI'="0000000",DIAI>HORI D  D ERRMSG
        ..S MSG(4)="HORMONE THERAPY DATE.........: "_HORE
        .I BRMI'="0000000",DIAI>BRMI D  D ERRMSG
        ..S MSG(4)="IMMUNOTHERAPY DATE...........: "_BRME
        .I OTHI'="0000000",DIAI>OTHI D  D ERRMSG
        ..S MSG(4)="OTHER TREATMENT START DATE...: "_OTHE
IF06EX  K BRME,BRMI,CHME,CHMI,CNSE,CNSI,DIAI,DIAE,HORE,HORI,MSG,OTHE
        K OTHI,RADE,RADI,SPSE,SPSI
        ;
IF0708  S DXCF=$$GET1^DIQ(165.5,PRM,26,"I")   ;DIAGNOSTIC CONFIRMATION
        S SEQ=$$GET1^DIQ(165.5,PRM,.06,"I")   ;SEQUENCE NUMBER
        S SEQN=+$$GET1^DIQ(165.5,PRM,.06,"I")
        S PRIM=$$GET1^DIQ(165.5,PRM,20,"I")   ;PRIMARY SITE
        S OVER=$$GET1^DIQ(165.5,PRM,223,"I")  ;OVERRIDE HOSPSEQ/DXCONF
        I TRSI=6,COCI'=5 D  D ERRMSG
        .S MSG(1)="TYPE OF REPORTING SOURCE = 6 ("_TRSE_")"
        .S MSG(2)="CLASS OF CASE must be 5 (Dx at autopsy)"
        I COCI=5,TRSI'=6 D  D ERRMSG
        .S MSG(1)="CLASS OF CASE = 5 ("_COCE_")"
        .S MSG(2)="TYPE OF REPORTING SOURCE must be 6 (Autopsy only)"
        I TRSI=7,DXCF'=9 D  D ERRMSG
        .S MSG(1)="TYPE OF REPORTING SOURCE = 7 ("_TRSE_")"
        .S MSG(2)="DIAGNOSTIC CONFIRMATION must be 9 (Unk if microscopically confirmed)"
        I TRSI=6,((DXCF'=1)&(DXCF'=6)) D  D ERRMSG
        .S MSG(1)="TYPE OF REPORTING SOURCE = 6 ("_TRSE_")"
        .S MSG(2)="DIAGNOSTIC CONFIRMATION must be 1 (Pos histology) or"
        .S MSG(3)="                                6 (Direct visualization)"
        I ($E(PRIM,3,4)=76)!(PRIM=67809) G IF11
        I DXCF>5,((SEQN>0)&(SEQN<60))!(SEQN>88),OVER="" D  D ERRMSG K DIR S DIR(0)="YA",DIR("A")="Do you wish to set the OVERRIDE HOSPSEQ/DXCONF flag to 'Reviewed'? ",DIR("B")="Y" D ^DIR W ! I Y=1 S $P(^ONCO(165.5,PRM,"OVRD"),U,19)=1,CMPLT=SAVCMPLT
        .S SAVCMPLT=CMPLT
        .S MSG(1)="DIAGNOSTIC CONFIRMATION > 5 ("_DXCF_")"
        .S MSG(2)="SEQUENCE NUMBER > 00 ("_SEQ_")"
        .S MSG(3)="OVERRIDE HOSPSEQ/DXCONF is required"
        K MSG,DXCF,SEQ,SEQN,PRIM,OVER,SAVCMPLT,DIR,Y
        ;
IF11    G:TOPI="" IF11EX
        S PORG=$$GET1^DIQ(164,TOPI,.07,"I")   ;PAIRED ORGAN
        S LTRL=$$GET1^DIQ(165.5,PRM,28,"I")   ;LATERALITY
        I PORG=1,LTRL=0,DDXI>3031231 D  D ERRMSG
        .S MSG(1)=TOPE_" is a paired site"
        .S MSG(2)="LATERALITY must be provided for specified paired organs/sites"
        .S MSG(3)=""
        .S:TOPI=67300 MSG(4)="NOTE: If NASAL CARTILAGE or NASAL SEPTUM, override this warning."
        .S:TOPI=67340 MSG(4)="NOTE: If CARINA, override this warning."
        .S:TOPI=67413 MSG(4)="NOTE: If STERNUM, override this warning."
        .S:TOPI=67414 MSG(4)="NOTE: If SACRUM, COCCYX or SYMPHYSIS PUBIS, override this warning."
        I PORG=1,LTRL="" D  D ERRMSG
        .S MSG(1)=TOPE_" is a paired site"
        .S MSG(2)="LATERALITY must be provided for specified paired organs/sites"
        I PORG="",LTRL'=0 D  D ERRMSG
        .S MSG(1)=TOPE_" is an unpaired site"
        .S MSG(2)="LATERALITY must be 0 (Not a paired site)"
IF11EX  K MSG,PORG,LTRL
        ;
        S RADI=$$GET1^DIQ(165.5,PRM,51.2,"I")   ;RADIATION
        S RADE=$$GET1^DIQ(165.5,PRM,51.2,"E")
        S LRTI=$$GET1^DIQ(165.5,PRM,126,"I")    ;LOCATION OF RADIATION TX
        I RADI'=0,LRTI=0 D  D ERRMSG
        .S MSG(1)="RADIATION = "_RADI_" ("_RADE_")"
        .S MSG(2)="LOCATION OF RADIATION TX cannot be 0 (No radiation tx)"
        K MSG,RADI,RADE,LRTI
        ;
        ;Treatment codes of 88 or dates of 88/88/8888 will prohibit 'Completion'
        S DRS=$$GET1^DIQ(165.5,PRM,51,"E")       ;DATE RADIATION STARTED
        S DRSFAC=$$GET1^DIQ(165.5,PRM,51.5,"E")  ;RADIATION @FACILITY DATE
        S DRE=$$GET1^DIQ(165.5,PRM,361,"E")      ;DATE RADIATION ENDED
        S CI=$$GET1^DIQ(165.5,PRM,53.2,"I")      ;CHEMOTHERAPY
        S CE=$$GET1^DIQ(165.5,PRM,53.2,"E")
        S CFACI=$$GET1^DIQ(165.5,PRM,53.3,"I")   ;CHEMOTHERAPY @FAC
        S CFACE=$$GET1^DIQ(165.5,PRM,53.3,"E")   ;CHEMOTHERAPY @FAC
        S CD=$$GET1^DIQ(165.5,PRM,53,"E")        ;CHEMOTHERAPY DATE
        S CFACD=$$GET1^DIQ(165.5,PRM,53.4,"E")   ;CHEMOTHERAPY @FAC DATE
        S HTI=$$GET1^DIQ(165.5,PRM,54.2,"I")     ;HORMONE THERAPY
        S HTE=$$GET1^DIQ(165.5,PRM,54.2,"E")
        S HTFACI=$$GET1^DIQ(165.5,PRM,54.3,"I")  ;HORMONE THERAPY @FAC
        S HTFACE=$$GET1^DIQ(165.5,PRM,54.3,"E")
        S HTD=$$GET1^DIQ(165.5,PRM,54,"E")       ;HORMONE THERAPY DATE
        S HTFACD=$$GET1^DIQ(165.5,PRM,54.4,"E")  ;HORMONE THERAPY @FAC DATE
        S ITI=$$GET1^DIQ(165.5,PRM,55.2,"I")     ;IMMUNOTHERAPY
        S ITE=$$GET1^DIQ(165.5,PRM,55.2,"E")
        S ITFACI=$$GET1^DIQ(165.5,PRM,55.3,"I")  ;IMMUNOTHERAPY @FAC
        S ITFACE=$$GET1^DIQ(165.5,PRM,55.3,"E")
        S ITD=$$GET1^DIQ(165.5,PRM,55,"E")       ;IMMUNOTHERAPY DATE
        S ITFACD=$$GET1^DIQ(165.5,PRM,55.4,"E")  ;IMMUNOTHERAPY @FAC DATE
        S HTEPI=$$GET1^DIQ(165.5,PRM,153,"I")     ;HEMA TRANS/ENDOCRINE PROC
        S HTEPE=$$GET1^DIQ(165.5,PRM,153,"E")
        S HTEPD=$$GET1^DIQ(165.5,PRM,153.1,"E")  ;HEMA TRANS/ENDOCRINE PROC DATE
        I DRS="88/88/8888" D  D TXDT88,ERRMSG
        .S MSG(1)="DATE RADIATION STARTED = "_DRS
        I DRSFAC="88/88/8888" D  D ERRMSG
        .S MSG(1)="RADIATION @FACILITY DATE = "_DRSFAC
        I DRE="88/88/8888" D  D ERRMSG
        .S MSG(1)="DATE RADIATION ENDED = "_DRE
        I CI=88 D  D ERRMSG
        .S MSG(1)="CHEMOTHERAPY = "_CI_" ("_CE_")"
        I CD="88/88/8888" D  D ERRMSG
        .S MSG(1)="CHEMOTHERAPY DATE = "_CD
        I CFACI=88 D  D ERRMSG
        .S MSG(1)="CHEMOTHERAPY @FAC = "_CFACI_" ("_CFACE_")"
        I CFACD="88/88/8888" D  D ERRMSG
        .S MSG(1)="CHEMOTHERAPY @FAC DATE = "_CFACD
        I HTI=88 D  D ERRMSG
        .S MSG(1)="HORMONE THERAPY = "_HTI_" ("_HTE_")"
        I HTD="88/88/8888" D  D ERRMSG
        .S MSG(1)="HORMONE THERAPY DATE = "_HTD
        I HTFACI=88 D  D ERRMSG
        .S MSG(1)="HORMONE THERAPY @FAC = "_HTFACI_" ("_HTFACE_")"
        I HTFACD="88/88/8888" D  D ERRMSG
        .S MSG(1)="HORMONE THERAPY @FAC DATE = "_HTFACD
        I ITI=88 D  D ERRMSG
        .S MSG(1)="IMMUNOTHERAPY = "_ITI_" ("_ITE_")"
        I ITD="88/88/8888" D  D ERRMSG
        .S MSG(1)="IMMUNOTHERAPY DATE = "_ITD
        I ITFACI=88 D  D ERRMSG
        .S MSG(1)="IMMUNOTHERAPY @FAC = "_ITFACI_" ("_ITFACE_")"
        I ITFACD="88/88/8888" D  D ERRMSG
        .S MSG(1)="IMMUNOTHERAPY @FAC DATE = "_ITFACD
        I HTEPI=12 D  D ERRMSG
        .S MSG(1)="HEMA TRANS/ENDOCRINE PROC = 88 ("_HTEPE_")"
        I HTEPD="88/88/8888" D  D ERRMSG
        .S MSG(1)="HEMA TRANS/ENDOCRINE PROC DATE = "_HTEPD
        K CD,CE,CFACD,CFACE,CFACI,CI,DRE,DRS,DRSFAC,HTD,HTE,HTEPD,HTEPE,HTEPI
        K HTFACD,HTFACE,HTFACI,HTI,ITD,ITE,ITFACD,ITFACE,ITFACI,ITI
        ;
PHCSEQ  S SEQ=$$GET1^DIQ(165.5,PRM,.06,"I")
        S PHC=$$GET1^DIQ(165.5,PRM,148,"E")
        I PHC="Yes",(SEQ="00")!(SEQ=60) D  D ERRMSG
        .S MSG(1)="PREVIOUS HISTORY OF CANCER = Yes"
        .S MSG(2)="SEQUENCE NUMBER = "_SEQ
        .S MSG(3)="SEQUENCE NUMBER cannot not be 00 or 60"
        I PHC="No",(SEQ'="00")&(SEQ'=60) D  D ERRMSG
        .S MSG(1)="PREVIOUS HISTORY OF CANCER = "_PHC
        .S MSG(2)="SEQUENCE NUMBER = "_SEQ
        .S MSG(3)="SEQUENCE NUMBER must be 00 or 60"
        K SEQ,PHC,MSG
        ;
        G ^ONCEDIT2
        ;
ERRMSG  ;Error message
        S CMPLT=0
        W !," WARNING: "
        S MSGSUB=0 F  S MSGSUB=$O(MSG(MSGSUB)) Q:MSGSUB'>0  W ?10,MSG(MSGSUB),!
        R Z:10
        K MSGSUB,Z
        Q
        ;
TXDT88  ;Treatment date = 88/88/8888 error message
        S MSG(2)="This abstract cannot be 'Complete' without a valid treatment date."
        S MSG(3)="This inter-field edit WARNING may not be overridden."
        S OVERRIDE="NO"
        Q
