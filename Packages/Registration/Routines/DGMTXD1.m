DGMTXD1 ; ;09/19/10
 S X=DG(DQ),DIC=DIE
 I $D(^DGMT(408.22,DA,0)),$P(^(0),U,12)=0,$P(^(0),U,11) D INC^DGMTDD2
 S X=DG(DQ),DIC=DIE
 D E40822^DGRTRIG(DA)