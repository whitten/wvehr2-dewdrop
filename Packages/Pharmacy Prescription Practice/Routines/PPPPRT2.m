PPPPRT2 ;ALB/DMB/DAD - CLINIC MEDICATION PROFILE PRINT ROUTINE ; 3/12/92
 ;;V1.0;PHARMACY PRESCRIPTION PRACTICE;**17**;APR 7,1995
 ;;Per VHA Directive 10-93-142, this routine should not be modified.
 ;
START ;
 N PPPARRY,PPPDOB,PPPNAME,PPPSSN,PPPTMP,BNR1,BNR2,BNR3,RSLTPTR,UNSPTR
 N CLNPTEND,CLNPTST,CSCNEND,CSCNSTRT,DFNARRY,DIR,FFXIFN,I,IDX
 N LKUPERR,NAMEARRY,ND,NODE,NODELEN,NOPRTFLG,OUT,PAGE,PAP,PATDFN
 N PATDOB,PATNAME,PATNODE,PATSSN,PCP,PCPD,PDXNODE,PDXPTR,PDXSTAT
 N PHRMARRY,POVNAME,POVNODE,PRMNODE0,SCANDT,TMP,TPATS,X,X1,X2,Y
 N ZTQUEUED,ZTREQ
 ;
 S PPPMRT="START_PPPPRT2"
 S LKUPERR=-9003
 S CSCNSTRT=1006
 S CSCNEND=1007
 S CLNPTST=1014
 S CLNPTEND=1015
 S NOPRTFLG=1016
 S PHRMARRY="^TMP(""PPP"","_$J_",""PHRM"")"
 S DFNARRY="^TMP(""PPP"","_$J_",""DFN"")"
 S NAMEARRY="^TMP(""PPP"","_$J_",""NAME"")"
 S BNR1="PPP - Medication Profiles from other VAMC(s)"
 S BNR2="Patient Medication Profiles For Clinics On "
 S BNR3="Date Printed: "_$$DTE^PPPUTL1(DT,0)
 S PAGE=0
 S OUT=""
 S RSLTPTR=$$GETSTPTR^PPPGET7("VAQ-RSLT")
 S UNSPTR=$$GETSTPTR^PPPGET7("VAQ-UNSOL")
 S TMP=$$LOGEVNT^PPPMSC1(CLNPTST,PPPMRT)
 S PRMNODE0=$G(^PPP(1020.1,1,0))
 I PRMNODE0="" D  Q
 .S TMP=$$LOGEVNT^PPPMSC1(LKUPERR,PPPMRT,"Parameter File Not Found")
 S PCP=$P(PRMNODE0,"^",7)
 S PAP=$P(PRMNODE0,"^",8)
 S PCPD=$P(PRMNODE0,"^",10)
 I 'PCP D  Q
 .S TMP=$$LOGEVNT^PPPMSC1(NOPRTFLG,PPPMRT)
 ; Determine clinic scan date.
 I +PCPD>0 D
 .S X1=DT
 .S X2=+PCPD
 .D C^%DTC
 .S SCANDT=X
 E  D
 .S SCANDT=DT
 S BNR2=BNR2_$$I2EDT^PPPCNV1(SCANDT)
 ; Scan the clinics for patients scheduled on SCANDT
 S TMP=$$LOGEVNT^PPPMSC1(CSCNSTRT,PPPMRT)
 S TPATS=$$CLINSCAN^PPPSCN2(SCANDT,DFNARRY)
 S TMP=$$LOGEVNT^PPPMSC1(CSCNEND,PPPMRT,"TOTAL PATIENTS = "_TPATS)
 ; Now sort the clinic list by name
 S TMP=$$NAMESRT^PPPPRT4(DFNARRY,NAMEARRY)
 K @DFNARRY
 ; Now order through the NAME's and get the data to print.
 K @PHRMARRY
 S PATNAME=""
 F IDX=0:0 D  Q:(PATNAME="")!(OUT["^")
 .S PATNAME=$O(@NAMEARRY@(PATNAME)) Q:PATNAME=""
 .F PATDFN=0:0 D  Q:PATDFN=""
 ..S PATDFN=$O(@NAMEARRY@(PATNAME,PATDFN)) Q:PATDFN=""
 ..S PATNODE=$G(@NAMEARRY@(PATNAME,PATDFN))
 ..S PATDOB=$P(PATNODE,"^",1)
 ..S PATSSN=$P(PATNODE,"^",2)
 ..F FFXIFN=0:0 D  Q:FFXIFN=""
 ...S FFXIFN=$O(^PPP(1020.2,"B",PATDFN,FFXIFN)) Q:FFXIFN=""
 ...S PDXNODE=$G(^PPP(1020.2,FFXIFN,1)) Q:PDXNODE=""
 ...S POVNODE=$G(^PPP(1020.2,FFXIFN,0)) Q:POVNODE=""
 ...S PDXPTR=$P(PDXNODE,"^",1)
 ...S PDXSTAT=$P(PDXNODE,"^",3)
 ...S POVNUM=$P(POVNODE,"^",2)
 ...I $D(^DIC(4,"D",POVNUM)) S POVIEN=$O(^DIC(4,"D",POVNUM,0)),POVNAME=$P($G(^DIC(4,POVIEN,0)),"^") K POVIEN
 ...I '$D(POVNAME),$D(^PPP(1020.8,"B",POVNUM)) S POVIEN=$O(^PPP(1020.8,"B",POVNUM,0)),POVNAME=$P($P($G(^PPP(1020.8,POVIEN,0))<"^",2),".",1) K POVIEN
 ...I '$D(POVNAME) S POVNAME=POVNUM_" (Unknown)"
 ...I (PDXPTR) I ((PDXSTAT=RSLTPTR)!(PDXSTAT=UNSPTR)) I $$PDXDAT^PPPDSP2(PDXPTR) D
 ....S PPPTMP(POVNAME,0)="1^"_PDXPTR_"^"_POVNUM
 ..I PAP,($D(PPPTMP)) D
 ...S TMP=$$GLPHRM^PPPGET8(PATDFN,PHRMARRY)
 ..I $D(PPPTMP) D
 ...S TMP=$$GETPDX^PPPGET2("PPPTMP",PHRMARRY)
 ..; If there is anything to print... print it.
 ..I $D(@PHRMARRY) D
 ...S PPPNAME=PATNAME
 ...S PPPDOB=PATDOB
 ...S PPPSSN=PATSSN
 ...S PAGE=PAGE+1 D HEADING1 Q:OUT["^"  D NARRATIV
 ...K @PHRMARRY,PPPTMP
 I $E(IOST,1,2)="C-"&(OUT'["^") D
 .W !!,"Listing Complete."
 ; Log end of print utility
 S TMP=$$LOGEVNT^PPPMSC1(CLNPTEND,PPPMRT)
 K @PHRMARRY,@NAMEARRY
 Q
 ;
HEADING1 ; Write the page heading, Pause if a crt.
 ;
 I PAGE>1,$E(IOST,1,2)="C-" D  Q:OUT["^"
 .S DIR(0)="E" D ^DIR
 .I +Y=0 S OUT="^"
 W @IOF,!
 W ?((IOM-$L(BNR1))\2),BNR1,?(IOM-15),"Page ",PAGE,!
 W ?((IOM-$L(BNR3))\2),BNR3,!!
 W !,"Patient: ",PPPNAME_" ("_PPPSSN_")",?60,"DOB: ",PPPDOB
 W ! F I=1:1:IOM W "="
 Q
 ;
HEADING2 ; Write the page heading, Pause if a crt.
 ;
 I PAGE>1,($E(IOST,1,2)="C-"),($D(NARRATIV)) D  Q:OUT["^"
 .S DIR(0)="E" D ^DIR
 .I +Y=0 S OUT="^"
 W !,"RX #",?9,"DRUG",?41,"ST",?45,"QTY",?51,"ISSUED",?65,"LAST FILLED"
 W ! F I=1:1:IOM W "="
 Q
 ;
NARRATIV ; Print the narratives
 ;
 S NARRATIV=1
 S STANAME=""
 I $D(@PHRMARRY@(0)) D
 .F  S STANAME=$O(@PHRMARRY@(0,STANAME)) Q:STANAME=""!(OUT["^")  D
 ..I $Y+5>IOSL S PAGE=PAGE+1 D HEADING1 Q:OUT["^"
 ..W !!,"NARRATIVE FROM ",STANAME
 ..W !,"  => ",@PHRMARRY@(0,STANAME)
 .W !
 K NARRATIV
 ;
DRUGS I $Y+8<IOSL D HEADING2
 S RVRSDT=0
 F  S RVRSDT=$O(@PHRMARRY@(RVRSDT)) Q:RVRSDT'>0!(OUT["^")  D
 .S STAPTR=""
 .F  S STAPTR=$O(@PHRMARRY@(RVRSDT,STAPTR)) Q:STAPTR=""!(OUT["^")  D
 ..S RXIDX=-1
 ..F  S RXIDX=$O(@PHRMARRY@(RVRSDT,STAPTR,RXIDX)) Q:RXIDX=""!(RXIDX="PID")!(OUT["^")  D
 ...I $Y+6>IOSL S PAGE=PAGE+1 D HEADING1 Q:OUT["^"  D HEADING2
 ...S ND=$G(@PHRMARRY@(RVRSDT,STAPTR,RXIDX)) Q:ND=""
 ...W !!,$P(ND,"^"),?9,$E($P(ND,"^",2),1,30),?41,$E($P(ND,"^",3),1),?45,$P(ND,"^",4),?51,$$SLASHDT^PPPCNV1($P(ND,"^",5)),?65,$$SLASHDT^PPPCNV1($P(ND,"^",6))
 ...W !,?9,"SIG: ",$E($P(ND,"^",7),1,25),?40,"ISSUED AT ",$P(ND,"^",8)," (",$P(ND,"^",9),")"
 ...W !,?9,"PROVIDER: ",$P(ND,"^",10)
 K @PHRMARRY
 Q