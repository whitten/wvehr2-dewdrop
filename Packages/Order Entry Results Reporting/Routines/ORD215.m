ORD215 ; COMPILED XREF FOR FILE #100.051 ; 08/11/09
 ; 
 S DA=0
A1 ;
 I $D(DISET) K DIKLM S:DIKM1=1 DIKLM=1 G @DIKM1
0 ;
A S DA=$O(^OR(100,DA(1),5.1,DA)) I DA'>0 S DA=0 G END
1 ;
 S DIKZ(0)=$G(^OR(100,DA(1),5.1,DA,0))
 S X=$P(DIKZ(0),U,1)
 I X'="" S ^OR(100,DA(1),5.1,"B",$E(X,1,30),DA)=""
 G:'$D(DIKLM) A Q:$D(DISET)
END G ^ORD216