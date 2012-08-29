VAQBUL06 ;ALB/JRP - BULLETINS;09-JUN-93
 ;;1.5;PATIENT DATA EXCHANGE;**9**;NOV 17, 1993
UNSOL(TRANPTR) ;SEND UNSOLICITED RECEIVED BULLETIN
 ;INPUT  : TRANPTR - Pointer to VAQ - TRANSACTION file
 ;OUTPUT : 0 - Bulletin sent
 ;         -1^Error_Text - Bulletin not sent
 ;
 ;CHECK INPUT
 S TRANPTR=+$G(TRANPTR)
 Q:(('TRANPTR)!('$D(^VAT(394.61,TRANPTR)))) "-1^Did not pass valid transaction"
 ;DECLARE VARIABLES
 N TRANNUM,NAME,PID,DOB,ATHRBY,SITE,DOMAIN,RCVON
 N TMP,TMPARR,LINE,OFFSET,SPACE,COMMENT,X,DIWL,DIWR,DIWF
 N SENSITVE,XMY,Y,ERROR
 S TMPARR="^TMP(""VAQ-BUL"","_$J_")"
 K @TMPARR,^UTILITY($J,"W")
 S SPACE="  "
 ;MAKE SURE TRANSACTION IS AN UNSOLICITED
 S TMP=$$STATYPE^VAQCON1(TRANPTR,1)
 Q:($P(TMP,"^",1)="-1") TMP
 Q:($P(TMP,"^",2)'="UNS") "-1^Transaction was not an Unsolicited PDX"
 ;GET TRANSACTION NUMBER
 S TMP=$G(^VAT(394.61,TRANPTR,0))
 S TRANNUM=+TMP
 Q:('TRANNUM) "-1^Transaction did not contain a transaction number"
 ;CHECK REMOTE SENSITIVITY
 S SENSITVE=+$P(TMP,"^",4)
 ;GET PATIENT INFORMATION
 S TMP=$G(^VAT(394.61,TRANPTR,"QRY"))
 S NAME=$P(TMP,"^",1)
 S:(NAME="") NAME="Not listed"
 S DOB=$$DOBFMT^VAQUTL99($P(TMP,"^",3),0)
 S:(DOB="") DOB="Not listed"
 S PID=$P(TMP,"^",4)
 I (PID="") D
 .;GET PID FROM SSN
 .S PID=$P(TMP,"^",2)
 .I (PID="") S PID="Not listed" Q
 .S PID=$$DASHSSN^VAQUTL99(PID)
 ;GET TRANSACTION INFORMATION
 S TMP=$G(^VAT(394.61,TRANPTR,"ATHR1"))
 S RCVON=$$DOBFMT^VAQUTL99($P(TMP,"^",1),1)
 S:(RCVON="") RCVON="Could not be determined"
 S ATHRBY=$P(TMP,"^",2)
 S:(ATHRBY="") ATHBY="Uknown"
 S TMP=$G(^VAT(394.61,TRANPTR,"ATHR2"))
 S SITE=$P(TMP,"^",1)
 S:(SITE="") SITE="Could not be determined"
 S DOMAIN=$P(TMP,"^",2)
 S:(DOMAIN="") DOMAIN="Could not be determined"
 ;BUILD MESSAGE
 S LINE=1
 S TMP="The following Unsolicited PDX has been received ..."
 S @TMPARR@(LINE,0)=TMP
 S LINE=LINE+1
 S TMP=""
 S @TMPARR@(LINE,0)=TMP
 S LINE=LINE+1
 ;PUT IN TRANSACTION INFO
 S TMP=SPACE_"Transaction number: "_TRANNUM
 S @TMPARR@(LINE,0)=TMP
 S LINE=LINE+1
 S TMP=SPACE_"Name: "_NAME
 S @TMPARR@(LINE,0)=TMP
 S LINE=LINE+1
 S TMP=SPACE_"PID: "_PID
 S @TMPARR@(LINE,0)=TMP
 S LINE=LINE+1
 S TMP=SPACE_"DOB: "_DOB
 S @TMPARR@(LINE,0)=TMP
 S LINE=LINE+1
 S TMP=""
 S @TMPARR@(LINE,0)=TMP
 S LINE=LINE+1
 ;PRINT SENSITIVITY
 I (SENSITVE) D
 .S TMP="*** PATIENT WAS LISTED AS SENSITIVE AT THE REMOTE FACILITY ***"
 .S TMP=SPACE_TMP
 .S @TMPARR@(LINE,0)=TMP
 .S LINE=LINE+1
 .S TMP=""
 .S @TMPARR@(LINE,0)=TMP
 .S LINE=LINE+1
 ;PUT IN RECEIVING INFO
 S TMP=SPACE_"Received on: "_RCVON
 S @TMPARR@(LINE,0)=TMP
 S LINE=LINE+1
 S TMP=""
 S @TMPARR@(LINE,0)=TMP
 S LINE=LINE+1
 ;PUT IN AUTHORIZING INFO
 S TMP=SPACE_"Sent by: "_ATHRBY
 S @TMPARR@(LINE,0)=TMP
 S LINE=LINE+1
 S TMP=SPACE_"Site: "_SITE
 S @TMPARR@(LINE,0)=TMP
 S LINE=LINE+1
 S TMP=SPACE_"Domain: "_DOMAIN
 S @TMPARR@(LINE,0)=TMP
 S LINE=LINE+1
 S TMP=""
 S @TMPARR@(LINE,0)=TMP
 S LINE=LINE+1
 ;DETERMINE IF COMMENT EXIST
 S COMMENT=0
 S COMMENT=$D(^VAT(394.61,TRANPTR,"CMNT"))
 S:(COMMENT) COMMENT=+$O(^VAT(394.61,TRANPTR,"CMNT",0))
 ;NO COMMENT/REASON
 I ('COMMENT) D
 .S TMP=SPACE_"Comments: None listed"
 .S @TMPARR@(LINE,0)=TMP
 .S LINE=LINE+1
 ;COMMENT/REASON
 I (COMMENT) D
 .S TMP=SPACE_"Comments:"
 .S @TMPARR@(LINE,0)=TMP
 .S LINE=LINE+1
 .;FORMAT TEXT
 .K ^UTILITY($J,"W")
 .S OFFSET=0
 .F  S OFFSET=+$O(^VAT(394.61,TRANPTR,"CMNT",OFFSET)) Q:('OFFSET)  D
 ..S X=$G(^VAT(394.61,TRANPTR,"CMNT",OFFSET,0))
 ..S DIWL=0
 ..S DIWR=0
 ..S DIWF="I"_$L(SPACE)_"C75"
 ..D ^DIWP
 .;PUT COMMENT INTO MESSAGE
 .S OFFSET=""
 .F  S OFFSET=$O(^UTILITY($J,"W",0,OFFSET)) Q:(OFFSET="")  D
 ..S TMP=$G(^UTILITY($J,"W",0,OFFSET,0))
 ..S @TMPARR@(LINE,0)=TMP
 ..S LINE=LINE+1
 .K ^UTILITY($J,"W")
 ;SEND TO UNSOLICITED MAIL GROUP
 S XMY("G.VAQ UNSOLICITED RECEIVED")=""
 ;ADD SECURITY OFFICER IF PATIENT IS SENSITIVE AT REMOTE FACILITY
 S:(SENSITVE) X=$$LOADXMY^DGSEC()
 ;SEND BULLETIN
 S TMP="Unsolicited PDX for "_NAME
 S X="PDX"
 S Y="Patient Data eXchange"
 S ERROR=$$SENDBULL^VAQBUL(TMP,X,Y,TMPARR)
 S:(ERROR>0) ERROR=0
 ;DONE (CLEAN UP)
 K @TMPARR,^UTILITY($J,"W")
 Q ERROR