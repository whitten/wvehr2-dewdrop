PSS551  ;BHM/DB - API FOR PHARMACY PATIENT FILE ;15 JUN 05
        ;;1.0;PHARMACY DATA MANAGEMENT;**108,118,133**;9/30/97;Build 1
        ;DFN: IEN of Patient [REQUIRED]
        ;PO: Order # [optional]
        ;PSDATE: Start Date [optional]
        ;PEDATE: End Date [optional]
        ;If a start date is sent, an end date must also be sent
        ;LIST: Subscript name used in ^TMP global [REQUIRED]
        N PSSPO,PSSIEN,DA,DR,DIC,PSS,CNT1,X,PSSTMP
        I $G(LIST)="" Q
        K ^TMP($J,LIST)
        I $G(DFN)="" S ^TMP($J,LIST,0)=-1_"^"_"NO DATA FOUND" Q
        S PSSIEN=$G(DFN),PSSPO=$G(PO) S ^TMP($J,LIST,0)=0
        I $G(PSSPO)>0,$G(PSSIEN)>0 S DA=PSSIEN,(IEN,DA(55.06))=PSSPO G DIQ431
        I $G(PSSPO)="",$G(PSDATE)'="",$G(PEDATE)'="" S PSDATE=$S('$P(PSDATE,".",2):PSDATE_.000001,1:PSDATE),PEDATE=$S('$P($G(PEDATE),".",2):PEDATE_.999999,1:$G(PEDATE)) N PSS56 G DT431
        I $G(PSSPO)="" N PSSPO1 G LOOP431
        Q
LOOP431 S (PSSPO1,PSSPO)=0 F  S PSSPO1=$O(^PS(55,DFN,5,"B",PSSPO1)) Q:PSSPO1'>0  F  S PSSPO=$O(^PS(55,DFN,5,"B",PSSPO1,PSSPO)) Q:PSSPO'>0  S PO=PSSPO D DIQ431
        Q
DIQ431  ;
        I '$D(^PS(55,DFN,5,PO,0)) Q
        S PSSIEN=PO_","_DFN_"," K DIQ
        D GETS^DIQ(55.06,PSSIEN,".01;.5;1;2*;3;4;5;6;7;11;12;27;27.1;28;66","IE","^TMP(""PSS5506"",$J)")
        F X=.01,.5,1,3,4,5,6,7,11,12,27,27.1,28,66 S ^TMP($J,LIST,+PSSPO,X)=$G(^TMP("PSS5506",$J,55.06,PSSIEN,X,"I"))
        F X=.5,1,3,4,5,6,7,27,27.1,28 S ^TMP($J,LIST,+PSSPO,X)=$S($G(^TMP("PSS5506",$J,55.06,PSSIEN,X,"E"))'="":^TMP($J,LIST,+PSSPO,X)_"^"_$G(^TMP("PSS5506",$J,55.06,PSSIEN,X,"E")),1:"")
        S PSSTMP=$P($G(^PS(55,DFN,5,PO,.2)),U) S ^TMP($J,LIST,IEN,108)=$S($G(PSSTMP)="":"",1:$$ORDITEM^PSS55(+PSSTMP))
        S (PSS(1),CNT1)=0 F  S PSS(1)=$O(^TMP("PSS5506",$J,55.07,PSS(1))) Q:'PSS(1)  D
        .S ^TMP($J,LIST,+PSSPO,"DDRUG",+PSS(1),.11)=$G(^TMP("PSS5506",$J,55.07,PSS(1),.11,"I"))
        .S ^TMP($J,LIST,+PSSPO,"DDRUG",+PSS(1),.12)=$G(^TMP("PSS5506",$J,55.07,PSS(1),.12,"I"))
        .S ^TMP($J,LIST,+PSSPO,"DDRUG",+PSS(1),.01)=$S($G(^TMP("PSS5506",$J,55.07,PSS(1),.01,"E"))'="":$G(^TMP("PSS5506",$J,55.07,PSS(1),.01,"I"))_"^"_$G(^TMP("PSS5506",$J,55.07,PSS(1),.01,"E")),1:"")
        .S ^TMP($J,LIST,+PSSPO,"DDRUG",+PSS(1),.02)=$G(^TMP("PSS5506",$J,55.07,PSS(1),.02,"I"))
        .S ^TMP($J,LIST,+PSSPO,"DDRUG",+PSS(1),.03)=$S($G(^TMP("PSS5506",$J,55.07,PSS(1),.03,"E"))'="":$G(^TMP("PSS5506",$J,55.07,PSS(1),.03,"I"))_"^"_$G(^TMP("PSS5506",$J,55.07,PSS(1),.03,"E")),1:"")
        .S ^TMP($J,LIST,+PSSPO,"DDRUG",+PSS(1),.04)=$G(^TMP("PSS5506",$J,55.07,PSS(1),.04,"I"))
        .S ^TMP($J,LIST,+PSSPO,"DDRUG",+PSS(1),.05)=$G(^TMP("PSS5506",$J,55.07,PSS(1),.05,"I"))
        .S ^TMP($J,LIST,+PSSPO,"DDRUG",+PSS(1),.06)=$G(^TMP("PSS5506",$J,55.07,PSS(1),.06,"I"))
        .S ^TMP($J,LIST,+PSSPO,"DDRUG",+PSS(1),.07)=$G(^TMP("PSS5506",$J,55.07,PSS(1),.07,"I"))
        .S ^TMP($J,LIST,+PSSPO,"DDRUG",+PSS(1),.08)=$G(^TMP("PSS5506",$J,55.07,PSS(1),.08,"I"))
        .S ^TMP($J,LIST,+PSSPO,"DDRUG",+PSS(1),.09)=$G(^TMP("PSS5506",$J,55.07,PSS(1),.09,"I"))
        .S ^TMP($J,LIST,+PSSPO,"DDRUG",+PSS(1),.1)=$G(^TMP("PSS5506",$J,55.07,PSS(1),.1,"I"))
        .S CNT1=CNT1+1
        K ^TMP("PSS5506",$J),PSS(1) S ^TMP($J,LIST,"B",+PSSPO)=""
        S ^TMP($J,LIST,0)=^TMP($J,LIST,0)+1
        S ^TMP($J,LIST,+PSSPO,"DDRUG",0)=$S(CNT1=0:"-1^NO DATA FOUND",1:CNT1)
        S ^TMP($J,LIST,0)=$S(^TMP($J,LIST,0)=0:"-1^NO DATA FOUND",1:^TMP($J,LIST,0))
        Q
DT431   F  S PSDATE=$O(^PS(55,DFN,5,"AUS",PSDATE)) Q:((+$G(PEDATE)>0)&(PSDATE>$G(PEDATE)))  Q:PSDATE'>0  D
        .S PSS56=0 F  S PSS56=$O(^PS(55,DFN,5,"AUS",PSDATE,PSS56)) Q:PSS56'>0  S (PSSPO,PO)=PSS56 D DIQ431
        S ^TMP($J,LIST,0)=$S(^TMP($J,LIST,0)=0:"-1^NO DATA FOUND",1:^TMP($J,LIST,0))
        K CNT1,LIST,DA,DFN,DIC,DIQ,DR,IEN,PEDATE,PO,PSDATE,PSS,PSS56,PSSPO,PSSPO1,X Q