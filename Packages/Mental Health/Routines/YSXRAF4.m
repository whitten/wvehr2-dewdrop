YSXRAF4 ; COMPILED XREF FOR FILE #602 ; 09/19/10
 ; 
 S DIKZK=1
 S DIKZ(0)=$G(^YSA(602,DA,0))
 S X=$P(DIKZ(0),U,1)
 I X'="" S ^YSA(602,"B",$E(X,1,30),DA)=""
END G ^YSXRAF5