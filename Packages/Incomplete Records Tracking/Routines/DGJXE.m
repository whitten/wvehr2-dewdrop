DGJXE ; GENERATED FROM 'DGJ EDIT IRT RECORD' INPUT TEMPLATE(#460), FILE 393;09/19/10
 D DE G BEGIN
DE S DIE="^VAS(393,",DIC=DIE,DP=393,DL=1,DIEL=0,DU="" K DG,DE,DB Q:$O(^VAS(393,DA,""))=""
 I $D(^(0)) S %Z=^(0) S %=$P(%Z,U,2) S:%]"" DE(3)=% S %=$P(%Z,U,3) S:%]"" DE(5)=% S %=$P(%Z,U,4) S:%]"" DE(9)=% S %=$P(%Z,U,5) S:%]"" DE(12)=% S %=$P(%Z,U,6) S:%]"" DE(15)=% S %=$P(%Z,U,7) S:%]"" DE(25)=% S %=$P(%Z,U,8) S:%]"" DE(18)=%
 I  S %=$P(%Z,U,9) S:%]"" DE(26)=% S %=$P(%Z,U,10) S:%]"" DE(28)=% S %=$P(%Z,U,12) S:%]"" DE(19)=%
 K %Z Q
 ;
W W !?DL+DL-2,DLB_": "
 Q
O D W W Y W:$X>45 !?9
 I $L(Y)>19,'DV,DV'["I",(DV["F"!(DV["K")) G RW^DIR2
 W:Y]"" "// " I 'DV,DV["I",$D(DE(DQ))#2 S X="" W "  (No Editing)" Q
TR R X:DTIME E  S (DTOUT,X)=U W $C(7)
 Q
A K DQ(DQ) S DQ=DQ+1
B G @DQ
RE G PR:$D(DE(DQ)) D W,TR
N I X="" G NKEY:$D(^DD("KEY","F",DP,DIFLD)),A:DV'["R",X:'DV,X:D'>0,A
RD G QS:X?."?" I X["^" D D G ^DIE17
 I X="@" D D G Z^DIE2
 I X=" ",DV["d",DV'["P",$D(^DISV(DUZ,"DIE",DLB)) S X=^(DLB) I DV'["D",DV'["S" W "  "_X
T G M^DIE17:DV,^DIE3:DV["V",P:DV'["S" X:$D(^DD(DP,DIFLD,12.1)) ^(12.1) I X?.ANP D SET I 'DDER X:$D(DIC("S")) DIC("S") I  W:'$D(DB(DQ)) "  "_% G V
 K DDER G X
P I DV["P" S DIC=U_DU,DIC(0)=$E("EN",$D(DB(DQ))+1)_"M"_$E("L",DV'["'") S:DIC(0)["L" DLAYGO=+$P(DV,"P",2) G:DV["*" AST^DIED D NOSCR^DIED S X=+Y,DIC=DIE G X:X<0
 G V:DV'["N" D D I $L($P(X,"."))>24 K X G Z
 I $P(DQ(DQ),U,5)'["$",X?.1"-".N.1".".N,$P(DQ(DQ),U,5,99)["+X'=X" S X=+X
V D @("X"_DQ) K YS
Z K DIC("S"),DLAYGO I $D(X),X'=U D:$G(DE(DW,"INDEX")) SAVEVALS G:'$$KEYCHK UNIQFERR^DIE17 S DG(DW)=X S:DV["d" ^DISV(DUZ,"DIE",DLB)=X G A
X W:'$D(ZTQUEUED) $C(7),"??" I $D(DB(DQ)) G Z^DIE17
 S X="?BAD"
QS S DZ=X D D,QQ^DIEQ G B
D S D=DIFLD,DQ(DQ)=DLB_U_DV_U_DU_U_DW_U_$P($T(@("X"_DQ))," ",2,99) Q
Y I '$D(DE(DQ)) D O G RD:"@"'[X,A:DV'["R"&(X="@"),X:X="@" S X=Y G N
PR S DG=DV,Y=DE(DQ),X=DU I $D(DQ(DQ,2)) X DQ(DQ,2) G RP
R I DG["P",@("$D(^"_X_"0))") S X=+$P(^(0),U,2) G RP:'$D(^(Y,0)) S Y=$P(^(0),U),X=$P(^DD(X,.01,0),U,3),DG=$P(^(0),U,2) G R
 I DG["V",+Y,$P(Y,";",2)["(",$D(@(U_$P(Y,";",2)_"0)")) S X=+$P(^(0),U,2) G RP:'$D(^(+Y,0)) S Y=$P(^(0),U) I $D(^DD(+X,.01,0)) S DG=$P(^(0),U,2),X=$P(^(0),U,3) G R
 X:DG["D" ^DD("DD") I DG["S" S %=$P($P(";"_X,";"_Y_":",2),";") S:%]"" Y=%
RP D O I X="" S X=DE(DQ) G A:'DV,A:DC<2,N^DIE17
I I DV'["I",DV'["#" G RD
 D E^DIE0 G RD:$D(X),PR
 Q
SET N DIR S DIR(0)="SV"_$E("o",$D(DB(DQ)))_U_DU,DIR("V")=1
 I $D(DB(DQ)),'$D(DIQUIET) N DIQUIET S DIQUIET=1
 D ^DIR I 'DDER S %=Y(0),X=Y
 Q
SAVEVALS S @DIEZTMP@("V",DP,DIIENS,DIFLD,"O")=$G(DE(DQ)) S:$D(^("F"))[0 ^("F")=$G(DE(DQ))
 I $D(DE(DW,"4/")) S @DIEZTMP@("V",DP,DIIENS,DIFLD,"4/")=""
 E  K @DIEZTMP@("V",DP,DIIENS,DIFLD,"4/")
 Q
NKEY W:'$D(ZTQUEUED) "??  Required key field" S X="?BAD" G QS
KEYCHK() Q:$G(DE(DW,"KEY"))="" 1 Q @DE(DW,"KEY")
BEGIN S DNM="DGJXE",DQ=1
 N DIEZTMP,DIEZAR,DIEZRXR,DIIENS,DIXR K DIEFIRE,DIEBADK S DIEZTMP=$$GETTMP^DIKC1("DIEZ")
 M DIEZAR=^DIE(460,"AR") S DICRREC="TRIG^DIE17"
 S:$D(DTIME)[0 DTIME=300 S D0=DA,DIIENS=DA_",",DIEZ=460,U="^"
1 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=1 D X1 D:$D(DIEFIRE)#2 FIREREC^DIE17 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X1 K DGJTUP
 Q
2 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=2 D X2 D:$D(DIEFIRE)#2 FIREREC^DIE17 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X2 S:DGJTNUM'["1" Y="@1"
 Q
3 S DW="0;2",DV="RP393.3'",DU="",DLB="TYPE OF DEFICIENCY",DIFLD=.02
 S DU="VAS(393.3,"
 S X=$P(^VAS(393,D0,0),"^",2)
 S Y=X
 S X=Y,DB(DQ)=1,DE(DW,"4/")="" G:X="" N^DIE17:DV,A I $D(DE(DQ)),DV["I"!(DV["#") D E^DIE0 G A:'$D(X)
 G RD:X="@",Z
X3 Q
4 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=4 D X4 D:$D(DIEFIRE)#2 FIREREC^DIE17 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X4 I X=1 S DGJTXX=$P(^VAS(393,D0,0),"^",5) S Y="@5"
 Q
5 S DW="0;3",DV="RD",DU="",DLB="EVENT DATE",DIFLD=.03
 S DE(DW)="C5^DGJXE"
 G RE
C5 G C5S:$D(DE(5))[0 K DB
 S X=DE(5),DIC=DIE
 K ^VAS(393,"C",$E(X,1,30),DA)
C5S S X="" G:DG(DQ)=X C5F1 K DB
 S X=DG(DQ),DIC=DIE
 S ^VAS(393,"C",$E(X,1,30),DA)=""
C5F1 Q
X5 S %DT="ESTX" D ^%DT S X=Y K:3991231<X!(2800101>X) X
 Q
 ;
6 S DQ=7 ;@5
7 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=7 D X7 D:$D(DIEFIRE)#2 FIREREC^DIE17 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X7 S Y="@3"
 Q
8 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=8 D X8 D:$D(DIEFIRE)#2 FIREREC^DIE17 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X8 I $P(^VAS(393,D0,0),"^",4)']"" S Y="@3"
 Q
9 D:$D(DG)>9 F^DIE17,DE S DQ=9,DW="0;4",DV="*P405'",DU="",DLB="ADMISSION",DIFLD=.04
 S DE(DW)="C9^DGJXE"
 S DU="DGPM("
 G RE
C9 G C9S:$D(DE(9))[0 K DB
 S X=DE(9),DIC=DIE
 ;
 S X=DE(9),DIC=DIE
 K ^VAS(393,"ADM",$E(X,1,30),DA)
C9S S X="" G:DG(DQ)=X C9F1 K DB
 S X=DG(DQ),DIC=DIE
 K DIV S DIV=X,D0=DA,DIV(0)=D0 S Y(1)=$S($D(^VAS(393,D0,0)):^(0),1:"") S X=$P(Y(1),U,13),X=X S DIU=X K Y S X=DIV S X=1 X ^DD(393,.04,1,1,1.4)
 S X=DG(DQ),DIC=DIE
 S ^VAS(393,"ADM",$E(X,1,30),DA)=""
C9F1 Q
X9 S DIC("S")="I $P(^(0),""^"",2)=1,($P(^(0),""^"",3)=+^DGPM(DA,0))" D ^DIC K DIC S DIC=DIE,X=+Y K:Y<0 X
 Q
 ;
10 S DQ=11 ;@3
11 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=11 D X11 D:$D(DIEFIRE)#2 FIREREC^DIE17 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X11 I $P(^VAS(393,D0,0),"^",2)=$O(^VAS(393.3,"B","DISCHARGE SUMMARY",0)) S Y="@13"
 Q
12 D:$D(DG)>9 F^DIE17,DE S DQ=12,DW="0;5",DV="R*P44'",DU="",DLB="LOCATION",DIFLD=.05
 S DU="SC("
 G RE
X12 S DIC("S")="N CA S CA=$S($D(DGJTAIFN):DGJTAIFN,1:+$P(^VAS(393,DA,0),U,4)) I $P(^SC(+Y,0),U,3)=$S(CA:""W"",1:""C"")" D ^DIC K DIC S DIC=DIE,X=+Y K:Y<0 X
 Q
 ;
13 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=13 D X13 D:$D(DIEFIRE)#2 FIREREC^DIE17 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X13 S DGJTXX=X
 Q
14 S DQ=15 ;@13
15 S DW="0;6",DV="R*P40.8'",DU="",DLB="DIVISION",DIFLD=.06
 S DU="DG(40.8,"
 S X=+DGJTDV
 S Y=X
 S X=Y,DB(DQ)=1,DE(DW,"4/")="" G:X="" N^DIE17:DV,A I $D(DE(DQ)),DV["I"!(DV["#") D E^DIE0 G A:'$D(X)
 G RD:X="@",Z
X15 Q
16 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=16 D X16 D:$D(DIEFIRE)#2 FIREREC^DIE17 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X16 S DGX=DGJTXX,DGX=$S($D(^SC(+DGX,42)):$P(^DIC(42,+(^SC(+DGX,42)),0),"^",3),$D(^SC(+DGX,0)):$P(^SC(+DGX,0),"^",8),1:"") I DGX']"" S DGX=0
 Q
17 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=17 D X17 D:$D(DIEFIRE)#2 FIREREC^DIE17 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X17 S DGJX=$S($D(^DG(393.1,"AC",DGX)):$O(^(DGX,0)),1:"") I DGJX]"" S DGJX=$P(^DG(393.1,+DGJX,0),"^",1)
 Q
18 S DW="0;8",DV="RP393.1'",DU="",DLB="SERVICE",DIFLD=.08
 S DE(DW)="C18^DGJXE"
 S DU="DG(393.1,"
 S X=DGJX
 S Y=X
 S X=Y,DB(DQ)=1 G:X="" N^DIE17:DV,A I $D(DE(DQ)),DV["I"!(DV["#") D E^DIE0 G A:'$D(X)
 G RD
C18 G C18S:$D(DE(18))[0 K DB
 S X=DE(18),DIC=DIE
 K ^VAS(393,"AC",$E(X,1,30),DA)
C18S S X="" G:DG(DQ)=X C18F1 K DB
 S X=DG(DQ),DIC=DIE
 S ^VAS(393,"AC",$E(X,1,30),DA)=""
C18F1 Q
X18 Q
19 D:$D(DG)>9 F^DIE17,DE S DQ=19,DW="0;12",DV="RP200'",DU="",DLB="PHYSICIAN RESPONSIBLE",DIFLD=.12
 S DE(DW)="C19^DGJXE"
 S DU="VA(200,"
 G RE
C19 G C19S:$D(DE(19))[0 K DB
 S X=DE(19),DIC=DIE
 ;
C19S S X="" G:DG(DQ)=X C19F1 K DB
 S X=DG(DQ),DIC=DIE
 K DIV S DIV=X,D0=DA,DIV(0)=D0 S Y(0)=X D PHYSRTRG^DGJTUTL I X S X=DIV S Y(1)=$S($D(^VAS(393,D0,0)):^(0),1:"") S X=$P(Y(1),U,14),X=X S DIU=X K Y S X=DIV S X=DIV,X=X X ^DD(393,.12,1,1,1.4)
C19F1 Q
X19 Q
20 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=20 D X20 D:$D(DIEFIRE)#2 FIREREC^DIE17 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X20 S DGJTUP=1
 Q
21 S DQ=22 ;@1
22 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=22 D X22 D:$D(DIEFIRE)#2 FIREREC^DIE17 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X22 I $P(DGJTNO,"^",2)=$O(^VAS(393.3,"B","DISCHARGE SUMMARY",0)) S Y="@6"
 Q
23 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=23 D X23 D:$D(DIEFIRE)#2 FIREREC^DIE17 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X23 I $P(DGJTNO,"^",2)=$O(^VAS(393.3,"B","DISCHARGE SUMMARY",0)) S Y=""
 Q
24 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=24 D X24 D:$D(DIEFIRE)#2 FIREREC^DIE17 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X24 S:DGJTNUM'["2" Y="@6"
 Q
25 D:$D(DG)>9 F^DIE17,DE S DQ=25,DW="0;7",DV="R*P45.7'",DU="",DLB="SPECIALTY",DIFLD=.07
 S DU="DIC(45.7,"
 G RE
X25 S DIC("S")="I $$ACTIVE^DGACT(45.7,Y,$G(DGJTDT))" D ^DIC K DIC S DIC=DIE,X=+Y K:Y<0 X
 Q
 ;
26 S DW="0;9",DV="RP200'",DU="",DLB="PRIMARY PHYSICIAN",DIFLD=.09
 S DE(DW)="C26^DGJXE"
 S DU="VA(200,"
 G RE
C26 G C26S:$D(DE(26))[0 K DB
 S X=DE(26),DIC=DIE
 ;
C26S S X="" G:DG(DQ)=X C26F1 K DB
 S X=DG(DQ),DIC=DIE
 K DIV S DIV=X,D0=DA,DIV(0)=D0 S Y(1)=$S($D(^VAS(393,D0,0)):^(0),1:"") S X=$P(Y(1),U,12),X=X S DIU=X K Y S X=DIV S X=DIV,X=X X ^DD(393,.09,1,1,1.4)
C26F1 Q
X26 Q
27 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=27 D X27 D:$D(DIEFIRE)#2 FIREREC^DIE17 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X27 I $P(DGJTDEL,"^",3)=0&($P(DGJTDEL,"^",10)="P") S DGJTUP=1 S Y="@4"
 Q
28 D:$D(DG)>9 F^DIE17,DE S DQ=28,DW="0;10",DV="P200'",DU="",DLB="ATTENDING PHYSICIAN",DIFLD=.1
 S DE(DW)="C28^DGJXE"
 S DU="VA(200,"
 G RE
C28 G C28S:$D(DE(28))[0 K DB
 S X=DE(28),DIC=DIE
 S DGJATTD=1 D PHYDEF^DGJTUTL
C28S S X="" G:DG(DQ)=X C28F1 K DB
 S X=DG(DQ),DIC=DIE
 S DGJATTD=1 D PHYDEF^DGJTUTL
C28F1 Q
X28 Q
29 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=29 D X29 D:$D(DIEFIRE)#2 FIREREC^DIE17 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X29 S DGJTUP=1
 Q
30 S DQ=31 ;@4
31 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=31 D X31 D:$D(DIEFIRE)#2 FIREREC^DIE17 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X31 S:DGJTNUM'["3" Y=""
 Q
32 S DQ=33 ;@6
33 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=33 D X33 D:$D(DIEFIRE)#2 FIREREC^DIE17 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X33 I $D(DGJTDEF)&(DGJTNUM["3") S Y="@20"
 Q
34 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=34 D X34 D:$D(DIEFIRE)#2 FIREREC^DIE17 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X34 S:DGJTNUM'["3" Y="@15"
 Q
35 D:$D(DG)>9 F^DIE17,DE S Y=U,DQ=35 D X35 D:$D(DIEFIRE)#2 FIREREC^DIE17 G A:$D(Y)[0,A:Y=U S X=Y,DIC(0)="F",DW=DQ G OUT^DIE17
X35 I $P(DGJTNO,"^",2)=$O(^VAS(393.3,"B","DISCHARGE SUMMARY",0)) D LESS48^DGJTUTL S:X=1 Y="@10" S:X=-1 Y="@15"
 Q
36 D:$D(DG)>9 F^DIE17 G ^DGJXE1