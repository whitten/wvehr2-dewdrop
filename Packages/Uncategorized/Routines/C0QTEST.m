C0PTEST   ; ERX/GPL - eRx Refill utilities ; 3/19/10 11:53am
 ;;0.1;C0P;nopatch;noreleasedate;Build 25
 ;Copyright 2009,2010 George Lilly.  Licensed under the terms of the GNU
 ;General Public License See attached copy of the License.
 ;
 ;This program is free software; you can redistribute it and/or modify
 ;it under the terms of the GNU General Public License as published by
 ;the Free Software Foundation; either version 2 of the License, or
 ;(at your option) any later version.
 ;
 ;This program is distributed in the hope that it will be useful,
 ;but WITHOUT ANY WARRANTY; without even the implied warranty of
 ;MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 ;GNU General Public License for more details.
 ;
 ;You should have received a copy of the GNU General Public License along
 ;with this program; if not, write to the Free Software Foundation, Inc.,
 ;51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
 ;
 Q
 ;
TESTMEDS ; PRINT OUT MEDICATIONS FOR INPATIENTS WITH MEDS BUT NO INPATIENT
 ; MEDS
 S ZI=""
 D BUILD^C0QPRML
 S GNEW=$NA(C0QLIST("NoMedOrders"))
 S GOLD=$NA(C0QLIST("HasMed"))
 K G
 D UNITY^C0QSET("G",GNEW,GOLD)
 F  S ZI=$O(G(1,ZI)) Q:ZI=""  D  ; FOR EACH PATIENT IN BOTH LISTS
 . K GG
 . D COVER^ORWPS(.GG,ZI) ; GET MED LIST
 . W !,"PATIENT: ",ZI,!
 . ZWR GG
 Q
 ;
TESTREQ(ZDUZ,ZDFN) ; TEST REFILL REQUEST
 I '$D(ZDFN) S ZDFN=""
 D REFREQ("ZG",ZDUZ,ZDFN)
 W !
 ZWR C0PRXML
 Q
 ;
REFREQ(GRTN,IDUZ,IDFN) ; MAKE A WEB SERVICE CALL TO GENERATE A REFIL REQUEST
 ; 
 N GPL,C0PFARY,GVOR
 D ENCREQ("GPL",IDUZ,IDFN)
 S GVOR("XMLIN")=GPL
 S GVOR("ORIG-FILL-DATE")=""
 S GVOR("CREATE-MED-YN")="0"
 ;D EN^C0PMAIN("GG","GURL",IDUZ,IDFN,"GENREFILL","GVOR")
 D INITXPF^C0PWS2("C0PFARY")
 D SOAP^C0PWS2("GRTN","GENREFILL",IDUZ,IDFN,"GVOR")
 ;D SOAP^C0CSOAP("GRTN","GENREFILL",,,"GG","C0PFARY") ;
 Q
 ;
GG1 ; IDENTIFY ORPHAN NODES IN ^PS(55,DFN,"NVA",
 S ZI="" S BAD="" S ZN=0
 F  S ZI=$O(^PS(55,ZI)) Q:ZI=""  D  ;
 . S ZJ=""
 . F  S ZJ=$O(^PS(55,ZI,"NVA",ZJ)) Q:ZJ=""  D  ; FOR EACH NVA DRUG
 . . I $D(^PS(55,ZI,"NVA",ZJ,1,7,0)) D  ; IF THE CODES NODE EXISTS
 . . . I '$D(^PS(55,ZI,"NVA",ZJ,1,0)) D  ; I NO ZERO NODE
 . . . . S BAD(ZI,ZJ)=""
 . . . . S ZN=ZN+1
 K ^G
 M ^G("BAD")=BAD
 ZWR BAD
 W !,"BAD COUNT: ",ZN
 Q
 ;
GG2 ; DISPLAY THE BAD NODES
 S ZI=""
 F  S ZI=$O(^G("BAD",ZI)) Q:ZI=""  D  ;
 . S ZJ=""
 . F  S ZJ=$O(^G("BAD",ZI,ZJ)) Q:ZJ=""  D  ;
 . . W !,^PS(55,ZI,"NVA",ZJ,1,7,0)
 . . I $D(^PS(55,ZI,"NVA",ZJ,1,0)) W !,"ERROR, DRUG EXISTS!"
 Q
 ;
GGKILL ; KILL THE BAD NODES
 S ZI=""
 F  S ZI=$O(^G("BAD",ZI)) Q:ZI=""  D  ;
 . S ZJ=""
 . F  S ZJ=$O(^G("BAD",ZI,ZJ)) Q:ZJ=""  D  ;
 . . W !,^PS(55,ZI,"NVA",ZJ,1,7,0)
 . . I $D(^PS(55,ZI,"NVA",ZJ,1,0)) D  Q  ;
 . . . W !,"    ERROR, DRUG EXISTS!"
 . . . W !,"    NODE NOT KILLED, PLEASE REVIEW"
 . . K ^PS(55,ZI,"NVA",ZJ,1,7,0)
 . . W !,"     BAD NODE KILLED"
 Q
 ;
GTEST ; TESTING RENEWAL PROCESSING
 K G
 D SOAP^C0PWS2("G","REFILLS",135,961)
 S ZI=""
 F  S ZI=$O(G(ZI)) Q:ZI=""  D  ;
 . S ZG=G(ZI,"RenewalRequestGuid")
 . I ZG="" W !,"ERROR NULL GUID"
 . S ZT=$O(^TMP("C0E","INDEX",ZG,""))
 . I ZT'="" D  ; HAVE A TOKEN
 . . S ZM1=G(ZI,"DrugInfo")
 . . S ZM2=^TMP("C0E","TOKEN",ZT,"renewalToken")
 . . S ZM3=^TMP("C0E","TOKEN",ZT,"medication")
 . . W !,!,"GUID:",ZG,!," TOKEN: ",ZT
 . . W !,"DRUG1: ",ZM1,!," DRUG2: ",ZM2,!," DRUG3: ",ZM3
 . . ;ZWR ^TMP("C0E","TOKEN",ZT,*)
 Q
 ;
GTEST2 ; SECOND TEST - FINDING INCONSISTANCIES IN RENEWAL ALERTS
 S ZI=""
 S ZN=0
 S ZTMP=$NA(^TMP("C0E","TOKEN"))
 F  S ZI=$O(@ZTMP@(ZI)) Q:ZI=""  D  ; FOR EACH TOKEN
 . I @ZTMP@(ZI,"C0PRenewalName")["request for" D  ; MED WHERE NAME SHOULD BE
 . . W !,!,"TOKEN:",ZI
 . . W !,"GUID:",@ZTMP@(ZI,"C0PGuid")
 . . W !,@ZTMP@(ZI,"C0PRenewalName")
 . . W !,@ZTMP@(ZI,"medication")
 . . W !,@ZTMP@(ZI,"renewalToken")
 . . S ISTR=@ZTMP@(ZI,"renewalToken")
 . . S IDUZ=@ZTMP@(ZI,"IDUZ")
 . . S ZALRT=$P(ISTR,";",3) ; RENEWAL TOKEN
 . . S ^G2(IDUZ,ZALRT,ISTR)=""
 . . S ZN=ZN+1
 W !,!,"NUMBER OF TOKENS:",ZN
 Q
 ;
GTEST3 ; USE ^G2 TO TRY AND FIND THE ALERTS
 ;
 S ZDUZ=""
 F  S ZDUZ=$O(^G2(ZDUZ)) Q:ZDUZ=""  D  ;
 . S ZALRT=""
 . F  S ZALRT=$O(^G2(ZDUZ,ZALRT)) Q:ZALRT=""  D  ; 
 . . W !,!,ZALRT
 . . W !,$G(^XTV(8992,ZDUZ,"XQA",ZALRT,0))
 . . S NXTALRT=$O(^XTV(8992,ZDUZ,"XQA",ZALRT)) ; NEXT ALERT
 . . W !,"NEXT:",NXTALRT
 . . I NXTALRT'="" W !,$G(^XTV(8992,ZDUZ,"XQA",NXTALRT,0))
 Q
 ;
GINDEX ; INDEX THE ^TMP("C0E","TOKEN") ARRAY BY GUID
 S ZI=""
 S ZN=0
 F  S ZI=$O(^TMP("C0E","TOKEN",ZI)) Q:ZI=""  D  ;
 . S ZG=^TMP("C0E","TOKEN",ZI,"C0PGuid")
 . S ^TMP("C0E","INDEX",ZG,ZI)=""
 . S ZN=ZN+1
 W !,"NUMBER OF TOKENS: ",ZN
 Q
 ;
ENCREQ(ZRTN,ZDUZ,ZDFN) ; ENCODE AN NCSCRIPT RENEWAL REQUEST
 ;
 D GENTEST("GPL","GURL",ZDUZ,ZDFN,1)
 ;S ZI=""
 ;S GPL(1)="RxInput="_GPL(1)
 S ZI=0 ; 
 ;F  S ZI=$O(GPL(ZI)) Q:ZI=""  D  ; MAKE IT XML SAFE
 ;. S GPL(ZI)=$$SYMENC^MXMLUTL(GPL(ZI))
 ;. W !,GPL(ZI)
 S ZI=0
 S G=""
 K GPL(0) ; GET RID OF LINE COUNT
 F  S ZI=$O(GPL(ZI)) Q:ZI=""  D  ;
 . S G=G_GPL(ZI)
 S @ZRTN=$$ENCODE^RGUTUU(G)
 ;S @ZRTN=G
 Q
 ;
CERTTEST ; GENERATE XML FILES FOR NEWCROP CERTIFICATION
 ;
 N ZII
 S ZDFN=18 ; TEST PATIENT TO USE
 F ZII=154,155,156,157 D  ; IENS OF SUBSCRIBER PROFILES
 . D CERTONE(ZII,ZDFN)
 Q
 ;
CERTONE(ZI,ZDFN) ; GENERATE ONE XML FILE 
 N ZN
 D EN^C0PMAIN("C0PG1","G2",ZI,ZDFN) ; GET THE NCSCRIPT
 S ZN=$P($P(^VA(200,ZI,0),U,1),",",2) ; GIVEN NAME OF USER
 ; ON OUR SYSTEM THESE ARE ERX,DOCTOR ERX,MID-LEVEL ERX,NURSE AND ERX,MANAGER
 S ZN=ZN_".xml" ; APPEND .xml extension
 K C0PG1(0)
 S ZDIR=^TMP("C0CCCR","ODIR")
 W !,$$OUTPUT^C0CXPATH("C0PG1(1)",ZN,ZDIR)
 Q
 ;
GENTEST(RTNXML,RTNURL,ZDUZ,ZDFN,ZFILE) ; GENERATE A TEST 
 ; CLICK-THROUGH HTLM FILE FOR
 ; GENERATING REFILL REQUESTS , XML IS RETURNED IN RTN,PASSED BY NAME
 ; IF ZFILE IS 1, THE FILE IS WRITTEN TO HOST FILE
 D EN^C0PMAIN("C0PG1","G2",ZDUZ,ZDFN) ; GET THE NCSCRIPT
 ;D GETMEDS("G6",ZDFN) ;GET MEDICATIONS
 ;D QUERY^C0CXPATH("G6","//NewPrescription[1]","G7") ;JUST THE FIRST ONE
 ;D INSERT^C0CXPATH("C0PG1","G7","//NCScript")
 K C0PG1(0)
 M @RTNXML=C0PG1 ;
 S ZDIR=^TMP("C0CCCR","ODIR")
 I $G(ZFILE)=1 W $$OUTPUT^C0CXPATH("C0PG1(1)","REFILL-"_ZDFN_".xml",ZDIR)
 Q
 ;
GETMEDS(OUTARY,ZDFN) ; GET THE PATIENT'S MEDS AND PUT INTO XML
 ;
 N ZG,ZG2,ZB,ZN
 S DEBUG=0
 D GETTEMP^C0PWS2("ZG","OUTMEDS") ;GET THE MEDICATIONS TEMPLATE
 D SOAP^C0PWS2("ZG2","GETMEDS",$$PRIMARY^C0PMAIN(),ZDFN) ; GET MEDS 
 I '$D(ZG2) Q  ; SHOULDN'T HAPPEN
 I ZG2(1,"Status")'="OK" D  Q  ; BAD RETURN FROM WEB SERVER
 . W $G(ZG2(1,"Message")),!
 N ZI S ZI=""
 S ZN=$NA(^TMP("C0PREFIL",$J))
 K @ZN
 F  S ZI=$O(ZG2(ZI)) Q:ZI=""  D  ; FOR EACH MED
 . N ZV
 . S ZV=$NA(@ZN@("DATA",ZI))
 . S ZX=$NA(@ZN@("XML",ZI))
 . S @ZV@("dispenseNumber")=$G(ZG2(ZI,"Dispense"))
 . S @ZV@("dosage")="Take "_$G(ZG2(ZI,"DosageNumberDescription"))_" "_$G(ZG2(ZI,"Route"))_" "_$G(ZG2(ZI,"DosageFrequencyDescription"))
 . S @ZV@("drugIdentifier")=ZG2(ZI,"DrugID")
 . S @ZV@("drugIdentifierType")="FDB"
 . S @ZV@("pharmacistMessage")="No childproof caps please"
 . S @ZV@("pharmacyIdentifier")=1231212
 . S @ZV@("refillCount")=ZG2(ZI,"Refills")
 . S @ZV@("substitution")="SubstitutionAllowed"
 . D MAP^C0CXPATH("ZG",ZV,ZX)
 . D QUEUE^C0CXPATH("ZB",ZX,2,$O(@ZX@(""),-1))
 D BUILD^C0CXPATH("ZB",OUTARY)
 K @ZN ;CLEAN UP
 Q
 ;
 ;B
 ;
 ;D GET^C0PCUR(.ZG2,ZDFN) ; GET THE MEDS FOR THIS PATIENT
 ;D EXTRACT^C0CALERT("ZG",ZDFN,"ZG2","ALGYCBK^C0PALGY3(ALTVMAP,A1)")
 S ZN=$O(ZR(""),-1) ;NUMBER OF LINES IN OUTPUT
 D QUEUE^C0CXPATH("ZB","ZG2",2,ZN-1)
 D BUILD^C0CXPATH("ZB",OUTARY)
 Q
 ; 
RGUIDS(ZARY,ZDUZ) ; RETURNS AN ARRAY OF ALL REFILL REQUEST GUIDS FOR 
 ; DUZ ZDUZ. ZARY IS PASSED BY NAME
 ; FORMAT IS @ZARY@("GUID")=IEN
 ; THIS ROUTINE IS REUSED FOR THE STATUS ROUTINE - INCOMPLETE ORDERS
 N ZI,ZJ,ZK,ZL,ZM,ZN
 S ZI=0
 ;F  S ZI=$O(^XTV(8992.1,"R",ZDUZ,ZI)) Q:ZI=""  D  ; ALL ALERT FOR DUZ
 F  S ZI=$O(^XTV(8992,ZDUZ,"XQA",ZI)) Q:ZI=""  D  ; USE XQA MULTIPLE
 . S ZL=^XTV(8992,ZDUZ,"XQA",ZI,0) ; 
 . S ZM=$P(ZL,U,2) ; RECORD ID
 . S ZN=$O(^XTV(8992.1,"B",ZM,"")) ;IEN OF ALERT TRACKING RECORD
 . S ZK=$$GET1^DIQ(8992.1,ZN_",",.03)
 . I ZK'["OR,1130" Q  ; NOT OUR PACKAGE - ALL ERX ALERTS START WITH 1130
 . ; 11305 IS FOR REFILLS
 . ; 11306 IS FOR INCOMPLETE ORDERS
 . S ZJ=""
 . S ZJ=$$GET1^DIQ(8992.1,ZN_",",2)
 . I ZJ="" Q
 . ; FOR RENEWALS (11305) NEED TO PULL THE GUID OUT - IT IS THE FIRST PIECE
 . ; OTHERWISE USE THE ENTIRE STRING. FOR INCOMPLETE ORDERS THIS WILL
 . ; INCLUDE THE MED AND PRESCRIPTION DATE
 . I ZK["OR,11305" S ZJ=$P(ZJ,"^",1) ; FIRST PIECE IS THE GUILD GUID^DOB^SEX
 . S @ZARY@(ZJ)=ZN
 Q
 ;
EN ; BATCH ENTRY POINT FOR REFILL (RENEWAL) STATUS AND FAILEDFAX CHECKING
 D REFILL
 K ZRSLT
 ;D STATUS ; ALSO RUN CHECK FOR INCOMPLETE ORDERS
 D FAILFAX ; ALSO RUN CHECK FOR FAILED FAXES
 Q
 ;
REFILL ; PULL REFILL REQUESTS AND POST ALERTS
 ;
 N ZDUZ ; USER NUMBER UNDER WHICH WE BUILD THE WEB SERVICE CALL
 N ZDFN ; PATIENT NUMBER USED TO BUILD THE WEB SERVICE CALL
 S ZDUZ=$$PRIMARY^C0PMAIN() ; PRIMARY ERX USER FOR BATCH CALLS
 ;S ZDUZ=DUZ ; SHOULD CHANGE THIS FOR PRODUCTION TO A "BATCH" USER
 S ZDFN="" ; NO PATIENT NEEDED FOR THESE CALLS
 ; S ZDFN=18 ; SHOULD NOT NEED THIS BE MAKE THE CALL - FIX IN EN^C0PMAIN
 N ZRSLT
 D SOAP^C0PWS2("ZRSLT","REFILLS",ZDUZ,ZDFN) ; WS CALL TO RETURN REFILS
 ;S XXX=YYY  ;
 I $G(ZRSLT(1,"Status"))'="OK" Q  ; NO ROWS WERE RETURNED
 I $G(ZRSLT(1,"RowCount"))=0 Q  ; NO ROWS WERE RETURNED
 D NOTIPURG^XQALBUTL(11305) ; DELETE ALL CURRENT REFILL ALERTS
 S C0PNPIF=$$GET1^DIQ(C0PAF,C0PACCT_",",8,"I") ; LEGACY FLAG TO USE NPI FOR SID
 N ZI S ZI=0
 N ZAPACK S ZAPACK="OR" ; ALERT PACKAGE CODE
 N ZADFN S ZADFN=0 ; DFN TO ASSOCIATE ALERT WITH - WE DON'T KNOW THIS
 N ZACODE S ZACODE=11305 ; IEN TO OE/RR NOTIFICATIONS file for eRx Refills
 F  S ZI=$O(ZRSLT(ZI)) Q:+ZI=0  D  ; FOR EACH RETURNED REFILL REQUEST
 . N ZSID S ZSID=ZRSLT(ZI,"ExternalDoctorId") ; NPI FOR SUBSCRIBER
 . I C0PNPIF'=1 S ZDUZ=$O(^VA(200,"AC0PSID",ZSID,"")) ; GUID SID
 . E  S ZDUZ=$O(^VA(200,"C0PNPI",ZSID,"")) ; DUZ FOR SUBSCRIBER
 . S ZRSLT("DUZ",ZDUZ,ZI)=""
 N ZJ S ZJ=""
 F  S ZJ=$O(ZRSLT("DUZ",ZJ)) Q:ZJ=""  D  ; FOR EACH PROVIDER
 . N ZGUIDS
 . D RGUIDS("ZGUIDS",ZJ) ; GET ARRAY OF CURRENT ACTIVE GUIDS
 . S ZI=""
 . F  S ZI=$O(ZRSLT("DUZ",ZJ,ZI)) Q:ZI=""  D  ; FOR EACH REQUEST
 . . N ZRRG S ZRRG=ZRSLT(ZI,"RenewalRequestGuid") ;renewal request number
 . . I $D(ZGUIDS(ZRRG)) D  Q  ; THIS REQUEST IS A DUPLICATE, SKIP IT 
 . . . W ZRRG_" IS A DUP",!
 . . N ZDATE S ZDATE=$P(ZRSLT(ZI,"ReceivedTimestamp")," ",1) ;DATE RECEIVED
 . . I $G(^TMP("C0P","TestNoMatch"))=1 D  ;
 . . . S ZRSLT(ZI,"PatientMiddleName")="XXX" ;TESTING NO MATCH  REMOVE ME
 . . ;I DUZ=135 S ZRSLT(ZI,"PatientMiddleName")="Uta" ;TESTING NO MATCH REMOVE
 . . N ZPAT S ZPAT=$G(ZRSLT(ZI,"PatientLastName"))_","_$G(ZRSLT(ZI,"PatientFirstName")) ; PATIENT NAME LAST,FIRST
 . . I $G(ZRSLT(ZI,"PatientMiddleName"))'="" S ZPAT=ZPAT_" "_$G(ZRSLT(ZI,"PatientMiddleName"))
 . . S ZDOB=$G(ZRSLT(ZI,"PatientDOB")) ;patient date of birth
 . . S ZSEX=$G(ZRSLT(ZI,"PatientGender")) ;patient gender
 . . S ZADFN=$$PATMAT(ZPAT,ZDOB,ZSEX) ; TRY AND MATCH THE PATIENT
 . . ;W "DFN="_ZADFN," ",ZI,!
 . . N ZXQAID S ZXQAID=ZAPACK_","_ZADFN_","_ZACODE ; FORMAT FOR P1 OF XQAID
 . . N ZMED S ZMED=ZRSLT(ZI,"DrugInfo")
 . . ;S XQA(ZDUZ)="" ; WHO TO SEND THE ALERT TO
 . . I '$D(^TMP("C0P","AlertVerify")) S XQA(ZJ)="" ; WHO TO SEND THE ALERT TO
 . . E  D  ; AlertVerify sends alerts only to testers, not recipients
 . . . ; use this when installing eRx to verify ewd installation
 . . . N ZZZ S ZZZ=""
 . . . F  S ZZZ=$O(^TMP("C0P","AlertVerify",ZZZ)) Q:ZZZ=""  D  ; WHICH DUZ 
 . . . . S XQA(ZZZ)="" ; MARK THIS USER TO RECIEVE ALERTS
 . . ;S XQA(135)="" ; ALWAYS SEND TO GPL
 . . ;S XQA(148)="" ; ALWAYS SEND TO RICH
 . . N ZP6 ; STRING THAT CPRS WILL RETURN FOR MATCHING 
 . . I ZADFN=0 D  ; NO MATCH
 . . . S XQAMSG="no match: ): [eRx] "_ZPAT_" Renewal request for "_ZMED
 . . . S ZP6=ZPAT_" Renewal request for "_ZMED
 . . E  D  ;
 . . . S XQAMSG=ZPAT_": ): [eRx] Renewal request for "_ZMED
 . . . S ZP6="Renewal request for "_ZMED
 . . ;S XQAMSG=$E(XQAMSG,1,70) ; TRUNCATE TO 70 CHARS
 . . S XQAID=ZXQAID ; PACKAGE IDENTIFIER 
 . . ;S XQADATA=ZRRG ; THE GUID OF THE REQUEST. NEEDED TO PROCESS THE ALERT
 . . S XQADATA=ZRRG_"^"_ZDOB_"^"_ZSEX ; SAVE DOB AND SEX WITH GUID
 . . W "SENDING",XQAID_" "_XQADATA,!
 . . D SETUP^XQALERT ; MAKE THE CALL TO SET THE ALERT
 K ZRSLT
 ;D STATUS ; ALSO RUN CHECK FOR INCOMPLETE ORDERS
 ;D FAILFAX ; ALSO RUN CHECK FOR FAILED FAXES
 Q
 ;
PATMAT(ZNAME,INDOB,INSEX) ;EXTRINSIC TO TRY AND MATCH THE PATIENT 
 ; RETURNS ZERO IF NO EXACT MATCH IS FOUND
 N ZP
 S ZP=$O(^DPT("B",ZNAME,""))
 I ZP="" Q 0 ; EXACT MATCH NOT FOUND ON NAME
 ; CHECK DATE OF BIRTH
 ;W "CHECKING DATE OF BIRTH",!
 N DOB
 S DOB=$$GET1^DIQ(2,ZP_",",.03,"I") ; PATIENT'S DATE OF BIRTH IN VISTA
 N ZD ;INCOMING DATE OF BIRTH IS IN YYYYMMDD FORMAT
 S ZD=($E(INDOB,1,4)-1700)_$E(INDOB,5,8) ; DATE OF BIRTH CONVERTED TO FM FORMAT
 ;W ZD_" "_DOB,!
 I +ZD'=+DOB Q 0 ; DATE OF BIRTH DOES NOT MATCH
 ;
 ; CHECK GENDER
 ;W "CHECKING GENDER",!
 N GENDER
 S GENDER=$$GET1^DIQ(2,ZP_",",.02,"I") ; PATIENT'S GENDER IN VISTA
 ;W GENDER_INSEX,!
 I GENDER'=INSEX Q 0 ;GENDER DOESN'T MATCH
 Q ZP
 ;
STATUS ; BATCH CALL TO RETRIEVE ERX ACCOUNT STATUS
 ; RETURNS UNFINISHED ORDERS FOR ALL PROVIDERS
 ; AND SENDS STATUS ALERTS
 N VOR
 S VOR("STATUS-SECTION-TYPE")="AllDoctorReview"
 S VOR("SORT-ORDER")="A"
 S VOR("INCLUDE-SCHEMA")="N"
 S ZDUZ=$$PRIMARY^C0PMAIN() ; PRIMARY ERX USER FOR BATCH CALLS
 K ZRSLT
 ; D SOAP^C0PWS1("ZRSLT","STATUS",ZDUZ,"","VOR")
 D SOAP^C0PWS2("ZRSLT","STATUS",ZDUZ,"","VOR")
 I '$D(ZRSLT) Q  ; SHOULDN'T HAPPEN
 I $G(ZRSLT(1,"DrugInfo"))="" Q  ; NO ROWS
 S C0PNPIF=$$GET1^DIQ(C0PAF,C0PACCT_",",8,"I") ; LEGACY FLAG TO USE NPI FOR SID
 N ZI S ZI=0
 N ZAPACK S ZAPACK="OR" ; ALERT PACKAGE CODE
 N ZADFN S ZADFN=0 ; DFN TO ASSOCIATE ALERT WITH - WE DON'T KNOW THIS
 N ZACODE S ZACODE=11306 ; IEN TO OE/RR NOTIFICATIONS file for eRx incomplete
 ; orders
 F  S ZI=$O(ZRSLT(ZI)) Q:+ZI=0  D  ; FOR EACH RETURNED REFILL REQUEST
 . N ZSID S ZSID=$G(ZRSLT(ZI,"ExternalDoctorId")) ; NPI FOR SUBSCRIBER
 . I ZSID="" Q  ; NO EXTERNAL ID FOR THIS STATUS
 . I C0PNPIF'=1 S ZDUZ=$O(^VA(200,"AC0PSID",ZSID,"")) ; GUID SID
 . E  S ZDUZ=$O(^VA(200,"C0PNPI",ZSID,"")) ; DUZ FOR SUBSCRIBER
 . S ZRSLT("DUZ",ZDUZ,ZI)=""
 N ZJ S ZJ=""
 D RMSTATUS ; REMOVE ALL STATUS ALERTS
 F  S ZJ=$O(ZRSLT("DUZ",ZJ)) Q:ZJ=""  D  ; FOR EACH PROVIDER
 . N ZGUIDS
 . D RGUIDS("ZGUIDS",ZJ) ; GET ARRAY OF CURRENT ACTIVE ALERTS
 . S ZI=""
 . F  S ZI=$O(ZRSLT("DUZ",ZJ,ZI)) Q:ZI=""  D  ; FOR EACH REQUEST
 . . N ZRRG S ZRRG=$G(ZRSLT(ZI,"DrugInfo")) ; first piece of XQDATA
 . . S $P(ZRRG,"^",2)=$G(ZRSLT(ZI,"PrescriptionDate")) ; second piece
 . . I $D(ZGUIDS(ZRRG)) D  Q  ; THIS REQUEST IS A DUPLICATE, SKIP IT 
 . . . ;W ZRRG_" IS A DUP",!
 . . I ZRRG="^" D  Q ; THIS IS AN ERROR
 . . . B
 . . N ZDATE S ZDATE=$P($G(ZRSLT(ZI,"PrescriptionDate"))," ",1) ;
 . . N ZPAT S ZPAT=$G(ZRSLT(ZI,"ExternalPatientId")) ; format PATIENTDFN
 . . I ZPAT="" Q  ;THIS IS AN ERROR
 . . S ZADFN=$P(ZPAT,"PATIENT",2) ; EXTRACT THE DFN
 . . S ZPAT=$$GET1^DIQ(2,ZADFN_",",.01) ;PATIENT'S NAME
 . . ;W "DFN="_ZADFN," ",ZI,!
 . . N ZXQAID S ZXQAID=ZAPACK_","_ZADFN_","_ZACODE ; FORMAT FOR P1 OF XQAID
 . . N ZMED S ZMED=ZRSLT(ZI,"DrugInfo")
 . . ;S XQA(ZDUZ)="" ; WHO TO SEND THE ALERT TO
 . . S XQA(ZJ)="" ; WHO TO SEND THE ALERT TO
 . . ;S XQA(135)="" ; ALWAYS SEND TO GPL
 . . ;S XQA(148)="" ; ALWAYS SEND TO RICH
 . . N ZP6 ; STRING THAT CPRS WILL RETURN FOR MATCHING 
 . . I ZADFN=0 D  ; NO MATCH
 . . . S XQAMSG="no match: ): [eRx] "_ZPAT_" Incomplete Order for "_ZMED
 . . . S ZP6=ZPAT_" Incomplete Order for "_ZMED
 . . E  D  ;
 . . . S XQAMSG=ZPAT_": ): [eRx] Incomplete Order for "_ZMED
 . . . S ZP6="Incomplete Order for "_ZMED
 . . ;S XQAMSG=$E(XQAMSG,1,70) ; TRUNCATE TO 70 CHARS
 . . S XQAID=ZXQAID ; PACKAGE IDENTIFIER
 . . S XQADATA=ZRRG ; THE GUID OF THE REQUEST. NEEDED TO PROCESS THE ALERT
 . . D SETUP^XQALERT ; MAKE THE CALL TO SET THE ALERT
 Q
 ;
RMSTATUS ; DELETES ALL STATUS ALERTS FOR ALL USERS (THEY WILL BE
 ; RESTORED NEXT TIME STATUS^C0PREFIL IS RUN - IN ERX BATCH
 D NOTIPURG^XQALBUTL(11306) ;
 W !,"ALL ERX STATUS ALERTS HAVE BEEN DELETED"
 Q
 ;
FAILFAX ; BATCH CALL TO RETRIEVE ERX FAILED FAX STATUS
 ; RETURNS A COUNT OF FAILED FAXES AND AN ARRAY OF PATIENTS
 N VOR,ZRSLT
 S VOR("STATUS-SECTION-TYPE")="FailedFax"
 ;S VOR("ACCOUNT-PARTNERNAME")="demo"
 S VOR("SORT-ORDER")="A"
 S VOR("INCLUDE-SCHEMA")="N"
 S ZDUZ=$$PRIMARY^C0PMAIN() ; PRIMARY ERX USER FOR BATCH CALLS
 D SOAP^C0PWS1("ZRSLT","STATUS",ZDUZ,"","VOR")
 N ZCOUNT
 S ZCOUNT=$O(ZRSLT(""),-1) ; HOW MANY FAILED FAXES
 I +ZCOUNT=0 Q  ; NO FAILED FAXES
 ;I $G(ZRSLT(1,"RowCount"))=0 Q  ; NO FAILED FAXES
 ;I $G(ZRSLT(1,"RowCount"))="" Q  ; SHOULD NOT HAPPEN
 N XQA,XQAMSG,XQAID,XQAKILL
 S XQAID="C0P" ; GOING TO FIRST KILL ALL FAILED FAX ALERTS
 D DELETEA^XQALERT ; KILL ALL FAILED FAX ALERTS
 S XQA("G.ERX HELP DESK")=""
 ;S XQA(135)=""
 S XQAID="C0P"
 S XQAMSG="eRx: "_ZCOUNT_" Failed Faxes on ePrescribing"
 D SETUP^XQALERT ; CREATE NEW FAILED FAX ALERTS TO THE MAILGROUP
 Q
 ;
RUN ; USED TO PROCESS AN ALERT. THIS ROUTINE IS LISTED IN
 ; 0E/RR CPRS NOTIFICATIONS AS THE ROUTINE TO RUN TO PROCESS
 ; A C0P ERX ALERT
 W "MADE IT TO RUN C0PREFIL",!
 W XQADATA
 B
 Q
 ;
GETALRT(ZARY,ZID) ; LOOKS UP AN ALERT BY USING THE "RECORDID" FROM CPRS,
 ; PASSED BY VALUE IN ZID. RESULTS ARE RETURNED IN ZARY, PASSED BY NAME
 ;N ZIEN
 ;S ZIEN=$O(^XTV(8992.1,"B",ZID,"")) ;IEN IN THE ALERT TRACKING FILE
 ;I ZIEN="" W "ERROR RETRIEVING ALERT",! Q  ;
 D GETN^C0CRNF(ZARY,8992.1,ZID,"B") ; GET ALL THE ALERT FIELDS
 ; THE FORMAT IS @ZARY@("DATA FOR PROCESSING")="FILE^FIELD^VALUE"
 ; ALL POPULATED FIELDS (BUT NOT SUBFILES) ARE RETURNED
 Q
 ; 
UPDIE   ; INTERNAL ROUTINE TO CALL UPDATE^DIE AND CHECK FOR ERRORS
 K ZERR
 D CLEAN^DILF
 D UPDATE^DIE("","C0PFDA","","ZERR")
 I $D(ZERR) D  ;
 . W "ERROR",!
 . ZWR ZERR
 . B
 K C0PFDA
 Q
 ;
FIND ; FIND ALL CURRENT ALERTS
 N ZI S ZI="" ; DUZ
 F  S ZI=$O(^XTV(8992,"AXQAN","OR,0,11305",ZI)) Q:ZI=""  D  ;
 . N ZJ S ZJ="" ; TIME STAMP
 . F  S ZJ=$O(^XTV(8992,"AXQAN","OR,0,11305",ZI,ZJ)) Q:ZJ=""  D  ;
 . . N ZZ,ZT
 . . S ZZ=$G(^XTV(8992,ZI,"XQA",ZJ,0))
 . . S ZT=$P(ZZ,U,2)
 . . Q:ZT=""
 . . S ZG=$O(^XTV(8992.1,"B",ZT,""))
 . . Q:ZG=""
 . . S ZGUID=$G(^XTV(8992.1,ZG,2))
 . . Q:ZGUID=""
 . . S ZGUID=$P(ZGUID,U,1)
 . . W !,ZI," ",ZJ," ",ZT," ",ZG," ",ZGUID
 . . ;ZWR ^XTV(8992.1,ZG,*)
 . . S G(ZJ,ZT,ZGUID)=""
 Q
 ;