IBXSC114 ; ;08/30/12
 ;;
1 N X,X1,X2 S DIXR=600 D X1(U) K X2 M X2=X D X1("F") K X1 M X1=X
 D
 . D TEMP^DGDDDTTM
 K X M X=X2 D
 . D TEMP^DGDDDTTM
 Q
X1(DION) K X
 S X(1)=$G(@DIEZTMP@("V",2,DIIENS,.1211,DION),$P($G(^DPT(DA,.121)),U,1))
 S X(2)=$G(@DIEZTMP@("V",2,DIIENS,.1212,DION),$P($G(^DPT(DA,.121)),U,2))
 S X(3)=$G(@DIEZTMP@("V",2,DIIENS,.1213,DION),$P($G(^DPT(DA,.121)),U,3))
 S X(4)=$G(@DIEZTMP@("V",2,DIIENS,.1214,DION),$P($G(^DPT(DA,.121)),U,4))
 S X(5)=$G(@DIEZTMP@("V",2,DIIENS,.1215,DION),$P($G(^DPT(DA,.121)),U,5))
 S X(6)=$G(@DIEZTMP@("V",2,DIIENS,.1216,DION),$P($G(^DPT(DA,.121)),U,6))
 S X(7)=$G(@DIEZTMP@("V",2,DIIENS,.1217,DION),$P($G(^DPT(DA,.121)),U,7))
 S X(8)=$G(@DIEZTMP@("V",2,DIIENS,.1218,DION),$P($G(^DPT(DA,.121)),U,8))
 S X(9)=$G(@DIEZTMP@("V",2,DIIENS,.12105,DION),$P($G(^DPT(DA,.121)),U,9))
 S X(10)=$G(@DIEZTMP@("V",2,DIIENS,.12112,DION),$P($G(^DPT(DA,.121)),U,12))
 S X(11)=$G(@DIEZTMP@("V",2,DIIENS,.1221,DION),$P($G(^DPT(DA,.122)),U,1))
 S X(12)=$G(@DIEZTMP@("V",2,DIIENS,.1222,DION),$P($G(^DPT(DA,.122)),U,2))
 S X(13)=$G(@DIEZTMP@("V",2,DIIENS,.1223,DION),$P($G(^DPT(DA,.122)),U,3))
 S X=$G(X(1))
 Q
