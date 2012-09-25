VAFCSB  ;BIR/CMC-CONT ADT PROCESSOR TO RETRIGGER A08 or A04 MESSAGES WITH AL/AL (COMMIT/APPLICATION) ACKNOWLEDGEMENTS ;7/9/2010
        ;;5.3;Registration;**707,756,825**;Aug 13, 1993;Build 1
        ;
        ;Reference to $$XAMDT^RAO7UTL1 is supported by IA #4875
        ;Reference to RESUTLS^LRPXAPI is supported by IA #4245
        ;
PV2()   ;build pv2 segment
        N PV2,LSTA,APPT,VASD,VAIP,VARP,VAROOT
        S PV2=""
        ;get next outpatient appointment
        K ^UTILITY("VASD",$J) S VASD("F")=DT D SDA^VADPT
        S APPT=$P($G(^UTILITY("VASD",$J,1,"I")),"^")
        I APPT'="" S $P(PV2,HL("FS"),9)=$$HLDATE^HLFNC(APPT)
        ;GET LAST ADMISSION DATE
        K VAIP S VAIP("D")="LAST",VAIP("M")=0 D IN5^VADPT
        ; **825,CR_1184: for PV2-14, it will be re-set as the 15th piece
        ; in PV2 segment a few lines below
        ; I VAIP(2)="1^ADMISSION" S $P(PV2,HL("FS"),15)=$$HLDATE^HLFNC($P(VAIP(3),"^"))
        I VAIP(2)="1^ADMISSION" S $P(PV2,HL("FS"),14)=$$HLDATE^HLFNC($P(VAIP(3),"^"))
        ;get last registration
        S VAROOT="VARP"
        D REG^VADPT
        I $D(VARP(1,"I")),$G(VARP(1,"I"))>0 S $P(PV2,HL("FS"),46)=$$HLDATE^HLFNC($P(VARP(1,"I"),"^"),"DT"),$P(PV2,HL("FS"),24)="CR"
        ;**756 ^ ONLY RETURN DATE FOR LAST REGISTRATION AS HL7 STANDARD CAN ONLY HAVE DATE
        I PV2'="" S PV2="PV2"_HL("FS")_PV2
        Q PV2
PHARA() ;build obx to show active prescriptions
        N RET S RET=""
        I '$$PATCH^XPDUTL("PSS*1.0*101") Q RET
        N PHARM,DGLIST
        S PHARM="" D PROF^PSO52API(DFN,"DGLIST")
        I +$G(^TMP($J,"DGLIST",DFN,0))>0 S PHARM="OBX"_HL("FS")_HL("FS")_"CE"_HL("FS")_"ACTIVE PRESCRIPTIONS"_HL("FS")_HL("FS")_"Y"
        ;**756 CE added as the data type
        Q PHARM
LABE()  ;BUILD OBX FOR LAST LAB TEST DATE
        N OBX S OBX=""
        I '$$PATCH^XPDUTL("LR*5.2*295") Q OBX
        N LAB,LAB2,EN
        S LAB="" K ^TMP("DGLAB",$J) D RESULTS^LRPXAPI("DGLAB",DFN,"C")
        S EN=$O(^TMP("DGLAB",$J,"")) I EN'="" S LAB=$P($G(^TMP("DGLAB",$J,EN)),"^")
        K ^TMP("DGLAB",$J) D RESULTS^LRPXAPI("DGLAB",DFN,"A")
        S EN=$O(^TMP("DGLAB",$J,"")) I EN'="" S LAB2=$P($G(^TMP("DGLAB",$J,EN)),"^") I LAB2>LAB S LAB=LAB2
        K ^TMP("DGLAB",$J) D RESULTS^LRPXAPI("DGLAB",DFN,"M")
        S EN=$O(^TMP("DGLAB",$J,"")) I EN'="" S LAB2=$P($G(^TMP("DGLAB",$J,EN)),"^") I LAB2>LAB S LAB=LAB2
        I LAB'="" D
        .S $P(OBX,HL("FS"),2)="TS" ;**756 added the data type
        .S $P(OBX,HL("FS"),3)="LAST LAB TEST DATE/TIME"
        .S $P(OBX,HL("FS"),11)="F"
        .S $P(OBX,HL("FS"),14)=$$HLDATE^HLFNC(LAB)
        .S OBX="OBX"_HL("FS")_OBX
        Q OBX
RADE()  ;BUILD OBX FOR LAST RADIOLOGY TEST DATE
        N RET S RET=""
        I '$$PATCH^XPDUTL("RA*5.0*76") Q RET
        N RAD,RADE
        S RAD="",RADE=$$XAMDT^RAO7UTL1(DFN) I +RADE<1 Q RAD
        I +RADE>0 D
        .S $P(OBX,HL("FS"),2)="TS" ;**756 added the data type
        .S $P(RAD,HL("FS"),3)="LAST RADIOLOGY EXAM DATE/TIME"
        .S $P(RAD,HL("FS"),11)="F"
        .S $P(RAD,HL("FS"),14)=$$HLDATE^HLFNC(RADE)
        .S RAD="OBX"_HL("FS")_RAD
        Q RAD
PD1()   ;BUILD PD1 segment
        ;PREFERRED FACILITY -- NOT GOING TO BE PASSED PER IMDQ 9/7/06
        N TEAM,PD1
        S PD1=""
        ;S TEAM=$$PREF^DGENPTA(DFN)
        ;I TEAM'="" S PD1="PD1"_HL("FS")_HL("FS")_HL("FS")_$$STA^XUAF4(TEAM)
        Q PD1
PV1()   ;BUILD PV1 SEGMENT
        ;CURRENTLY ADMITTED?
        N PV1,VAINDT
        S PV1=""
        S VAINDT=DT
        D INP^VADPT
        I $G(VAIN(1))'="" S $P(PV1,HL("FS"),44)=$$HLDATE^HLFNC($P(VAIN(7),"^")),PV1="PV1"_HL("FS")_PV1
        K VAIN
        Q PV1
