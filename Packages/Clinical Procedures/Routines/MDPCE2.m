MDPCE2  ; HOIFO/NCA - Routine For Data Extract For Hemo Dialysis;9/10/04  11:23
        ;;1.0;CLINICAL PROCEDURES;**6**;Apr 01, 2004;Build 102
        ; Integration Agreements:
        ; IA# 1889 [Subscription] Create New Visit - DATA2PCE^PXAPI call
        ;     1890 [Subscription] Delete existing visit - DELVFILE^PXAPI call
        ;     1995 [Supported] ICPTCOD API Call
        ;     3990 [Supported] ICDCODE API Call
        ;    10040 [Supported] Hospital Location File Access
        ;    10082 [Supported] Global Access to ICD Diagnosis file (#80)
        ;    10048 [Supported] FILE 9.4 references
        ;    10103 [Supported] XLFDT calls
        ;
EN1(MDENC,MDINST,MDPDTE,MDPR,MDTYP,MDETYP,MDCLOC)       ; [Function] PCE Visit Creation
        ; Input parameters
        ;  1. MDENC [Literal/Required] Billing data array
        ;  2. MDINST [Literal/Required] Transaction IEN
        ;  3. MDPDTE [Literal/Optional] Procedure Date/Time
        ;  4. MDPR [Literal/Required] CP Definition
        ;  5. MDTYP [Literal/Required] Type of Visit (Ambulatory or Hospitalization)
        ;  6. MDETYP [Literal/Required] Encounter Type (Primary or Ancillary)
        ;  7. MDCLOC [Literal/Required] Workload Reporting hospital location
        ;
        N DATA,MDCCOD,MDCLIN,MDPERR,MDJ,MDK,MDL,MDLST,MDM,MDNOD,MDOK,MDPKG,MDPROV,MDRES,MDSC,MDSTR,MDV1,MDVISIT,MDDRES K ^TMP("MDPXAPI",$J)
        S MDOUT="",(MDOK,MDSC)=0
        S MDPKG=$$FIND1^DIC(9.4,"","MX","CLINICAL PROCEDURES")
        I 'MDPKG Q "-1^CLINICAL PROCEDURES does not exist in Package File."
        I '$D(^MDD(702,MDINST,0)) Q "-1^No Study Record."
        S MDSTR=$G(^MDD(702,MDINST,0))
        S MDCLIN=$G(^MDD(702,MDINST,1))
        S MDRES=""
        I +$P(MDCLIN,U) S MDRES=$$DELVFILE^PXAPI("PRV^POV^CPT",+$P(MDCLIN,U),"","CLINICAL PROCEDURES") S MDVISIT=+MDCLIN
        ;I +MDRES<0 Q $P(MDRES,"^")_"^Cannot purge existing visit during PCE data set."
        S (MDJ,MDK,MDL,MDM)=0,MDJ=MDJ+1,MDPROV=""
        I '$G(MDCLOC) S MDCLOC=$$GET1^DIQ(702.01,+MDPR_",",.05,"I") I 'MDCLOC Q "-1^No Hospital Location for CP Definition."
        S ^TMP("MDPXAPI",$J,"ENCOUNTER",MDJ,"ENC D/T")=MDPDTE
        S ^TMP("MDPXAPI",$J,"ENCOUNTER",MDJ,"PATIENT")=$P(MDSTR,"^",1)
        S ^TMP("MDPXAPI",$J,"ENCOUNTER",MDJ,"HOS LOC")=MDCLOC
        S ^TMP("MDPXAPI",$J,"ENCOUNTER",MDJ,"SERVICE CATEGORY")=$S(MDTYP="V":"A",1:MDTYP)
        S ^TMP("MDPXAPI",$J,"ENCOUNTER",MDJ,"ENCOUNTER TYPE")=MDETYP
        I $$GET1^DIQ(44,MDCLOC_",",3,"I") S ^TMP("MDPXAPI",$J,"ENCOUNTER",MDJ,"INSTITUTION")=$$GET1^DIQ(44,MDCLOC_",",3,"I")
        S MDLST="" F  S MDLST=$O(MDENC(MDLST)) Q:MDLST=""  S MDNOD=$G(MDENC(MDLST)) D
        .I $P(MDNOD,"^")["SC" D  Q
        ..S:+$P(MDNOD,";",2) ^TMP("MDPXAPI",$J,"ENCOUNTER",MDJ,"SC")=+$P($P(MDNOD,";",2),U,2) S:+$P($P(MDNOD,";",2),U,2)>0 MDSC=1
        ..I $P(MDNOD,";",3)="AO" Q:+MDSC>0  S:+$P(MDNOD,";",4) ^TMP("MDPXAPI",$J,"ENCOUNTER",MDJ,"AO")=+$P($P(MDNOD,";",4),"^",2)
        ..I $P(MDNOD,";",5)="IR" Q:+MDSC>0  S:+$P(MDNOD,";",6) ^TMP("MDPXAPI",$J,"ENCOUNTER",MDJ,"IR")=+$P($P(MDNOD,";",6),"^",2)
        ..I $P(MDNOD,";",7)="EC" Q:+MDSC>0  S:+$P(MDNOD,";",8) ^TMP("MDPXAPI",$J,"ENCOUNTER",MDJ,"EC")=+$P($P(MDNOD,";",8),"^",2)
        ..I $P(MDNOD,";",9)="MST" Q:+MDSC>0  S:+$P(MDNOD,";",10) ^TMP("MDPXAPI",$J,"ENCOUNTER",MDJ,"MST")=+$P($P(MDNOD,";",10),"^",2)
        ..I $P(MDNOD,";",11)="HNC" Q:+MDSC>0  S:+$P(MDNOD,";",12) ^TMP("MDPXAPI",$J,"ENCOUNTER",MDJ,"HNC")=+$P($P(MDNOD,";",12),"^",2)
        ..I $P(MDNOD,";",13)="CV" Q:+MDSC>0  S:+$P(MDNOD,";",14) ^TMP("MDPXAPI",$J,"ENCOUNTER",MDJ,"CV")=+$P($P(MDNOD,";",14),"^",2)
        .I $P(MDNOD,"^")="PRV" I $P(MDNOD,"^",2)'="" D  Q
        ..S MDK=MDK+1,^TMP("MDPXAPI",$J,"PROVIDER",MDK,"NAME")=$P(MDNOD,"^",2) S:'MDOK MDOK=1
        ..S ^TMP("MDPXAPI",$J,"PROVIDER",MDK,"PRIMARY")=$P(MDNOD,"^",6)
        ..S:MDPROV="" MDPROV=$P(MDNOD,"^",2)
        ..Q
        .I $P(MDNOD,"^")="POV" D  Q
        ..Q:$P(MDNOD,"^",3)=""
        ..S MDCCOD=$$CODEN^ICDCODE($P(MDNOD,"^",3),"") S MDCCOD=+$P(MDCCOD,"^") Q:+MDCCOD<1
        ..S MDL=MDL+1,^TMP("MDPXAPI",$J,"DX/PL",MDL,"DIAGNOSIS")=MDCCOD
        ..S ^TMP("MDPXAPI",$J,"DX/PL",MDL,"PRIMARY")=$P(MDNOD,"^",6)
        ..S ^TMP("MDPXAPI",$J,"DX/PL",MDL,"ORD/RES")="R"
        ..S ^TMP("MDPXAPI",$J,"DX/PL",MDL,"CATEGORY")=$P(MDNOD,"^",4)
        ..S ^TMP("MDPXAPI",$J,"DX/PL",MDL,"NARRATIVE")=$P($G(^ICD9(+MDCCOD,0)),"^",3)
        ..S:MDPROV ^TMP("MDPXAPI",$J,"DX/PL",MDL,"ENC PROVIDER")=MDPROV
        ..S:'MDOK MDOK=1
        .I $P(MDNOD,"^")="CPT" D  Q
        ..Q:$P(MDNOD,U,3)=""
        ..S MDCCOD=$$CPT^ICPTCOD($P(MDNOD,U,3)) Q:+MDCCOD<1
        ..S MDM=MDM+1 S:'MDOK MDOK=1
        ..S ^TMP("MDPXAPI",$J,"PROCEDURE",MDM,"PROCEDURE")=$P(MDCCOD,"^")
        ..S ^TMP("MDPXAPI",$J,"PROCEDURE",MDM,"NARRATIVE")=$P(MDCCOD,"^",3)
        ..S ^TMP("MDPXAPI",$J,"PROCEDURE",MDM,"CATEGORY")=$P(MDNOD,"^",4)
        ..S ^TMP("MDPXAPI",$J,"PROCEDURE",MDM,"QTY")=$P(MDNOD,"^",7)
        ..S:MDPROV ^TMP("MDPXAPI",$J,"PROCEDURE",MDM,"ENC PROVIDER")=MDPROV
        I MDOK S ^TMP("MDPXAPI",$J,"ENCOUNTER",1,"CHECKOUT D/T")=$$NOW^XLFDT
        S MDRES=$$DATA2PCE^PXAPI("^TMP(""MDPXAPI"",$J)",MDPKG,"CLINICAL PROCEDURES",.MDVISIT,"","",1,"",.MDPERR)
        I MDRES<1 D  Q MDOUT
        .S MDOUT=1
        .I MDVISIT>0 S MDFDA(702,MDINST_",",.13)=MDVISIT,MDOUT=MDVISIT_"^"_MDCLOC_";"_MDPDTE_";"_MDTYP,MDFDA(702,MDINST_",",.07)=MDTYP_";"_MDPDTE_";"_MDCLOC D FILE^DIE("K","MDFDA")
        .K ^TMP("MDPXAPI",$J) Q
        S:MDVISIT>0 MDFDA(702,MDINST_",",.13)=MDVISIT
        S MDOUT=MDVISIT_"^"_MDCLOC_";"_MDPDTE_";"_MDTYP
        S MDFDA(702,MDINST_",",.07)=MDTYP_";"_MDPDTE_";"_MDCLOC
        D FILE^DIE("K","MDFDA") K ^TMP("MDPXAPI",$J)
        Q MDOUT