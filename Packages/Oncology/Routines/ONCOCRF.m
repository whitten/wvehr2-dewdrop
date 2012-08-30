ONCOCRF ;Hines OIFO/GWB - FOLLOW-UP ;07/13/00
        ;;2.11;ONCOLOGY;**6,11,16,22,25,26,28,44,45,49**;Mar 07, 1995;Build 38
        ;
LD      ;DATE OF LAST CONTACT OR DEATH (160.04,.01)
        N O1,O2,STOP S LD="",STOP=0
        S O1=""
        F  S O1=$O(^ONCO(160,XD0,"F","B",O1)) Q:'O1  D  Q:STOP
        .S O2=""
        .F  S O2=$O(^ONCO(160,XD0,"F","B",O1,O2)) Q:'O2  D  Q:STOP
        ..S LD=$G(^ONCO(160,XD0,"F",O2,0))
        ..I $P(LD,U,2)=0 S STOP=1 ;VITAL STATUS (160.04,1)="Dead"
        Q
        ;
R1      ;Kill STATUS (160,15) "AS" and DUE FOLLOW-UP (160,27) "AD"
        ;cross-references
        S XD=$G(^ONCO(160,XD0,1)) Q:XD=""
        S OS=$P(XD,U,1) K:OS'="" ^ONCO(160,"AS",OS,XD0)
        S OD=$P(XD,U,2) K:OD'="" ^ONCO(160,"AD",OD,XD0)
        Q
        ;
LDXT    ;Return follow-up record for last date of contact excluding this one
        S LD=$O(^ONCO(160,XD0,"F","AA",0)) I LD'="" S:$D(^(LD,DA)) LD=$O(^ONCO(160,XD0,"F","AA",LD)) I LD'="" S LD=+$O(^(LD,0)),LD=$G(^ONCO(160,XD0,"F",LD,0))
        Q
        ;
SLF     ;Set DATE OF LAST CONTACT OR DEATH (160.04,.01) "AA" cross-reference
        ;Set REGISTRAR (160.04,11) and DATE ENTERED (160.04)
        N ONCDUZ,ONCDT
        S XD0=DA(1),X1=9999999-X,^ONCO(160,XD0,"F","AA",X1,DA)=""
        S ONCDUZ=DUZ
        S ONCDT=DT
        S:$P(^ONCO(160,XD0,"F",DA,0),U,10)="" $P(^ONCO(160,XD0,"F",DA,0),U,10)=ONCDUZ
        S:$P(^ONCO(160,XD0,"F",DA,0),U,11)="" $P(^ONCO(160,XD0,"F",DA,0),U,11)=ONCDT
        G EX
        ;
KLF     ;Kill .01 of FOLLOW-UP MULTIPLE-RESETS: #16(1;2), STATUS #15(1;1), FOLLOWUP STATUS #15.2(1;7), DUE FOLLOW-UP #27(2;3), if alive, DATE DEATH #29 (1;8)
        ;CODE MODIFIED TO ELIMINATE FM RE-INDEXING DATA LOSS
        ;CHANGE MADE TO PREVENT DELETING DEATH DATA, IN FM CROSS-REFERENCING
        S XD0=DA(1),X1=9999999-X K ^ONCO(160,XD0,"F","AA",X1,DA) G EX
        ;
SVS     ;VITAL STATUS->STATUS (160,15) trigger AND UPDATE DUE FOLLOW-UP IF DEAD
        ;Invoked by "AC" xref on VITAL STATUS sub-field (160.04,1)
        S XD0=DA(1) D LD ;get the last sub-record alive (or the first dead)
        D UVS^ONCOCRFA   ;update vital status
        Q
        ;
KVS     ;Kill: reset STATUS
        S XD0=DA(1) D LDXT ;get the last sub-record (excluding this one)
        D UVS^ONCOCRFA     ;update vital status
        Q
        ;
NF      ;Set DUE FOLLOW-UP (160,27)
        S NF=$S(FS=0:"",1:$E(LC,1,3)+1_$E(LC,4,5)_"00")
        S $P(^ONCO(160,XD0,1),U,2)=NF
        I NF'="" S ^ONCO(160,"AD",NF,XD0)=""
        Q
        ;
UPD     ;Update the following fields with the most recent FOLLOW-UP (160,400)
        ;data:
        ;STATUS             (160,15)   1;1
        ;FOLLOW-UP STATUS   (160,15.2) 1;7
        ;ICD REVSION        (160,20)   1;4
        ;DUE FOLLOW-UP      (160,27)   1;2
        ;DATE@TIME OF DEATH (160,29)   1;8
        I '$D(XD0) Q:'$D(D0)  S XD0=D0
        D LD,R1 G EX:LD=""
        S LC=$P(LD,U,1),ONCOVS=$P(LD,U,2),NM=$P(LD,U,6)
        S FS=$S(NM="":1,NM<8:1,ONCOVS=0:0,1:0)
        I FS S X1=DT,X2=LC D ^%DTC S FS=$S(X>456.25:8,1:FS)
        S DIE="^ONCO(160,",DA=XD0,DR="15///"_ONCOVS_";15.2///"_FS D ^DIE
        K DIE,DR
        S $P(^ONCO(160,XD0,1),U,4)=$S(ONCOVS=0:9,1:0)
        D NF I FS S Y=NF D DD^%DT W !!?20,"Due follow-up: ",Y G EX
        S:ONCOVS=0 $P(^ONCO(160,XD0,1),U,8)=LC
        W !!," Patient not followed"
        G EX
        ;
LFU     ;LAST FOLLOW-UP SUMMARY-SELECTED DATA from Last Follow-up
        S XD0=D0 D GD I X="" W !?10,"NO Last Contact Information on Patient",! G EX
DLC     ;DATE LAST CONTACT (160,16) from "AF" cross-reference
        S XD0=D0 D GD G EX
        ;
CAS     ;CANCER STATUS Last Date Contact
DOD     ;computed Date of Death
        I $D(^ONCO(160,D0,1)),$P(^(1),U,1)=0 G DLC
        S X="" G EX
GD      ;DATE LAST CONTACT (160,16)
        S X=$S('$D(^ONCO(160,XD0,"F","AA")):"",1:9999999-$O(^ONCO(160,XD0,"F","AA",0)))
        Q
        ;
PDLC    ;DATE LAST CONTACT (165.5,200)
        S X=$S('$D(^ONCO(165.5,D0,"TS","AA")):"",1:9999999-$O(^ONCO(165.5,D0,"TS","AA",0))) G EX
        ;
PDLC1   ;DATE LAST CONTACT FILMANAGER FORMAT
        D P0 G EX:XD0="" D GD G EX
        ;
P0      S XD0=$P($G(^ONCO(165.5,D0,0)),U,2)
        Q
        ;
SDA     ;SURVIVAL DAYS
        D P0 G EX:XD0="" D SD G EX ;PRESENTS SURVIVAL IN DAYS
        ;
SUR     ;SURVIVAL (MONTHS)
        D P0 G EX:XD0="" D SD G EX:X="" S X=X/30.4375 G EX
        ;
SYR     ;SURVIVAL YEARS
        D P0 G EX:XD0="" D SD G EX:X="" S X=X/365.25 G EX
        ;
SWK     ;WEEKS FOLLOWUP
        D P0 G EX:XD0="" D SD G EX:X="" S X=X/7 G EX
        ;
SD      S XDX=$P(^ONCO(165.5,D0,0),U,16) D GD,DC
        Q
DC      ;DATE COMPARE
        S X2=XDX,X1=X S X=$S(X2="":"",X1="":"",1:0) Q:X=""  I X2>X1 S X="" Q
        D ^%DTC Q
DD      ;DATE FORMATING
        S XD=$S(XD="":"",$E(XD,6,7)="00":$E(XD,4,5)_"/"_($E(XD,1,3)+1700),1:$E(XD,4,5)_"/"_$E(XD,6,7)_"/"_($E(XD,1,3)+1700))
        Q
SDF     ;DUE FOLLOW-UP-TIGGERED BY NEXT FOLLOW-UP METHOD of FOLLOW-UP MULTIPLE
        Q
KDF     ;KILL DUE FOLLOW-UP
        Q
        ;
EX      ;KILL variables
        K FS,LC,LD,NF,NM,OD,ONCDT,ONCDUZ,ONCVS,OS,X1,X2,XD,XD0,XDX,Y
        Q
