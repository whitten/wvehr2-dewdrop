DGMTXX31 ; COMPILED XREF FOR FILE #408.31 ; 09/19/10
 ; 
 S DIKZK=2
 S DIKZ(0)=$G(^DGMT(408.31,DA,0))
 S X=$P(DIKZ(0),U,19)
 I X'="" K ^DGMT(408.31,"AS",X,+$P(^DGMT(408.31,DA,0),U,3),-$P(^(0),U),+$P(^(0),U,2),DA)
 S X=$P(DIKZ(0),U,19)
 I X'="" K ^DGMT(408.31,"AID",X,+$P(^DGMT(408.31,DA,0),U,2),-$P(^(0),U),DA)
 S X=$P(DIKZ(0),U,19)
 I X'="" K ^DGMT(408.31,"AD",X,+$P(^DGMT(408.31,DA,0),U,2),$P(^(0),U),DA)
 S X=$P(DIKZ(0),U,2)
 I X'="" K ^DGMT(408.31,"AS",+$P(^DGMT(408.31,DA,0),U,19),+$P(^(0),U,3),-$P(^(0),U),X,DA)
 S X=$P(DIKZ(0),U,2)
 I X'="" K ^DGMT(408.31,"AID",+$P(^DGMT(408.31,DA,0),U,19),X,-$P(^(0),U),DA)
 S X=$P(DIKZ(0),U,2)
 I X'="" K ^DGMT(408.31,"C",$E(X,1,30),DA)
 S X=$P(DIKZ(0),U,2)
 I X'="" K ^DGMT(408.31,"AD",+$P(^DGMT(408.31,DA,0),U,19),X,$P(^(0),U),DA)
 S X=$P(DIKZ(0),U,2)
 I X'="" K ^DGMT(408.31,"ADFN"_X,+^DGMT(408.31,DA,0),DA)
 S X=$P(DIKZ(0),U,3)
 I X'="" K ^DGMT(408.31,"AS",+$P(^DGMT(408.31,DA,0),U,19),X,-$P(^(0),U),+$P(^(0),U,2),DA)
 S X=$P(DIKZ(0),U,3)
 I X'="" D CUR^DGMTDD
 S X=$P(DIKZ(0),U,7)
 I X'="" K ^DGMT(408.31,"AG",$E(X,1,30),DA)
 S X=$P(DIKZ(0),U,11)
 I X'="" D:$G(DGMTYPT)<3 AUTOUPD^DGENA2(+$P(^DGMT(408.31,DA,0),U,2),2)
 S X=$P(DIKZ(0),U,16)
 I X'="" K ^DGMT(408.31,"AP",X,$P(^DGMT(408.31,DA,0),U),DA)
 S X=$P(DIKZ(0),U,20)
 I X'="" K ^DGMT(408.31,"AE",$E(X,1,30),DA)
 S X=$P(DIKZ(0),U,20)
 I X'="" S:'$P(^DGMT(408.31,DA,0),U,20) $P(^DGMT(408.31,DA,0),U,21,22)="^"
 S DIKZ(2)=$G(^DGMT(408.31,DA,2))
 S X=$P(DIKZ(2),U,2)
 I X'="" D E40831^DGRTRIG(DA)
 S X=$P(DIKZ(2),U,3)
 I X'="" D STOPAUTO^DGMTDD(DA)
 S X=$P(DIKZ(2),U,8)
 I X'="" K ^DGMT(408.31,"AT",$E(X,1,30),DA)
 S X=$P(DIKZ(0),U,1)
 I X'="" K ^DGMT(408.31,"B",$E(X,1,30),DA)
 S X=$P(DIKZ(0),U,1)
 I X'="" K ^DGMT(408.31,"AS",+$P(^DGMT(408.31,DA,0),U,19),+$P(^(0),U,3),-X,+$P(^(0),U,2),DA)
 S X=$P(DIKZ(0),U,1)
 I X'="" K ^DGMT(408.31,"AID",+$P(^DGMT(408.31,DA,0),U,19),+$P(^(0),U,2),-X,DA)
 S X=$P(DIKZ(0),U,1)
 I X'="" K ^DGMT(408.31,"AD",+$P(^DGMT(408.31,DA,0),U,19),+$P(^(0),U,2),X,DA)
 S X=$P(DIKZ(0),U,1)
 I X'="" K ^DGMT(408.31,"ADFN"_$P(^DGMT(408.31,DA,0),U,2),X,DA)
END Q