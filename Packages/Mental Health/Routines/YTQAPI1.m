YTQAPI1 ;ASF/ALB- MHAX REMOTE PROCEDURES ; 4/3/07 10:50am
        ;;5.01;MENTAL HEALTH;**85**;Dec 30, 1994;Build 49
        Q
RULES(YSDATA,YS)        ;list rules for a survey
        ;input: CODE as test name
        ;output: Field^Value
        N YSBOOL,YSQID,YSRID,YSTESTN,YSTEST,G,G1,G2,N,N1,N2,Z
        S YSTEST=$G(YS("CODE"))
        I YSTEST="" S YSDATA(1)="[ERROR]",YSDATA(2)="NO code" Q  ;-->out
        S YSTESTN=$O(^YTT(601.71,"B",YSTEST,0))
        I YSTESTN'>0 S YSDATA(1)="[ERROR]",YSDATA(2)="bad code" Q  ;-->out
        S YSDATA(1)="[DATA]"
        S N1=1
        I '$D(^YTT(601.83,"C",YSTESTN)) S YSDATA(2)="No Rules" Q  ;--> out
        S N=0 F  S N=$O(^YTT(601.83,"C",YSTESTN,N)) Q:N'>0  D
        . S YSRID=$P(^YTT(601.83,N,0),U,4)
        . S G=$G(^YTT(601.82,YSRID,0)) Q:G=""  ;-->cross bad 83 vs 82
        . S G1=$G(^YTT(601.82,YSRID,1)),G2=$G(^YTT(601.82,YSRID,2))
        . S YSQID=$P(G,U,2) S:YSQID="" YSQID=0
        . S YSBOOL=$P(G,U,6) S:YSBOOL="" YSBOOL=0
        . S N1=N1+1
        . S Z(YSQID,YSBOOL,N1,1)=$P(G,U)_"="_$P(G,U,2)_U_$P(G,U,4)_U_$P(G,U,5)_U_$P(G,U,3)_U_$P(G,U,6)_U_$P(G,U,7)
        . S Z(YSQID,YSBOOL,N1,2)=$P(G1,U,2)_U_$P(G1,U,3)_U_$P(G1,U)
        . S Z(YSQID,YSBOOL,N1,3)=$P(G2,U)_U_$S($P(G2,U,2)="Y":"YES",$P(G2,U,2)="N":"NO",1:"")
        S N2=1
        S YSQID=0 F  S YSQID=$O(Z(YSQID)) Q:YSQID'>0  S YSBOOL="Z" F  S YSBOOL=$O(Z(YSQID,YSBOOL),-1) Q:YSBOOL=""  S N1=0 F  S N1=$O(Z(YSQID,YSBOOL,N1)) Q:N1'>0  D
        . S N2=N2+1,YSDATA(N2)=Z(YSQID,YSBOOL,N1,1)
        . S N2=N2+1,YSDATA(N2)=Z(YSQID,YSBOOL,N1,2)
        . S N2=N2+1,YSDATA(N2)=Z(YSQID,YSBOOL,N1,3)
        Q
EDAD(YSDATA,YS) ;Edit and Save Data
        N YSSER,YSX,YSNN,YSRESULT,G,YSF,YSV,N,YSIEN,YSFILEN
        K ^TMP("YSMHI",$J)
        S YSFILEN=$G(YS("FILEN"))
        S YSIEN=$G(YS("IEN"),"?+1")_","
        I YSFILEN="" S YSDATA(1)="[ERROR]",YSDATA(2)="bad filen " Q  ;-->out
        S N=0 F  S N=$O(YS(N)) Q:N'>0  D  Q:$G(YSRESULT)="^"
        . S G=YS(N)
        . S YSF=$P(G,U),YSV=$P(G,U,2),YSX=$P(G,U,3)
        . I '$D(^DD(YSFILEN,YSF)) S YSRESULT=1 Q
        . I YSV="" S YSRESULT=1 Q
        . S ^TMP("YSMHI",$J,YSFILEN,YSIEN,YSF)=YSV
        . D:YSX'=1 VAL^DIE(YSFILEN,YSIEN,+YSF,"E",YSV,.YSRESULT)
        . ;
        I $G(YSRESULT)="^" S YSDATA(1)="[ERROR]",YSDATA(2)="Value for Field Not Valid^"_YSV_U_YSF Q  ;--> out
        D UPDATE^DIE("E","^TMP(""YSMHI"",$J)","YSNN","YSERR")
        I $D(YSSER) S YSDATA(1)="[ERROR]",YSDATA(2)="Update Error" Q  ;-->out
        S YSDATA(1)="[DATA]",YSDATA(2)="Update ok^"_$G(YSNN(1))_U_$G(YSNN(1,0))
        ;
        Q
WPED(YSDATA,YS) ;Replace WP field
        ;INPUT: filen,ien,field,ys(1)...ys(x)= text
        N YSF,N,YSIEN,YSERR,YSFILEN
        K ^TMP("YSMHI",$J)
        S YSFILEN=$G(YS("FILEN"))
        I YSFILEN="" S YSDATA(1)="[ERROR]",YSDATA(2)="bad filen " Q  ;-->out
        S YSIEN=$G(YS("IEN"))
        I YSIEN'?1N.N S YSDATA(1)="[ERROR]",YSDATA(2)="bad IEN " Q  ;-->out
        S YSIEN=YSIEN_","
        S YSF=$G(YS("FIELD")) S X=$$VFIELD^DILFD(YSFILEN,YSF) I X=0 S YSDATA(1)="[ERROR]",YSDATA(2)="BAD FIELD #" Q  ;-->out
        S N=0 F  S N=$O(YS(N)) Q:N'>0  D
        . S ^TMP("YSMHI",$J,N)=$G(YS(N))
        D WP^DIE(YSFILEN,YSIEN,YSF,,"^TMP(""YSMHI"",$J)","YSERR")
        I $D(YSERR) S YSDATA(1)="[ERROR]",YSDATA(2)="very BAD Update Error" Q  ;-->out
        S YSDATA(1)="[DATA]",YSDATA(2)="ZZUpdate ok WP "_YSIEN
        Q
GETANS(YSDATA,YS)       ;get an answer
        ;AD = ADMINISTRATION #
        ;QN= QUESTION #
        N G,G1,N,YSAD,YSQN
        S YSAD=$G(YS("AD"))
        S YSQN=$G(YS("QN"))
        I YSAD'?1N.N S YSDATA(1)="[ERROR]",YSDATA(2)="bad ad num" Q  ;-->out
        I YSQN'?1N.N S YSDATA(1)="[ERROR]",YSDATA(2)="bad quest num" Q  ;-->out
        I '$D(^YTT(601.85,"AC",YSAD,YSQN)) S YSDATA(1)="[ERROR]",YSDATA(2)="no such reference" Q  ;-->out
        S YSDATA(1)="[DATA]"
        S G=0,N=1
        S G=$O(^YTT(601.85,"AC",YSAD,YSQN,G)) Q:G'>0  S G1=0 D
        . S:$P(^YTT(601.85,G,0),U,4)?1N.N N=N+1,YSDATA(N)=$P(^YTT(601.85,G,0),U,4) ;ASF 3/10/04 ***
        . F  S G1=$O(^YTT(601.85,G,1,G1)) Q:G1'>0  S N=N+1,YSDATA(N)=$G(^YTT(601.85,G,1,G1,0))
        Q
CAPIE(YSDATA,YS)        ;
        N N,N1,N2,YSFIELDS,YSFILEN,YSIENS,X
        K ^TMP("YS",$J)
        K ^TMP("YSDATA",$J) S YSDATA=$NA(^TMP("YSDATA",$J))
        S ^TMP("YSDATA",$J,1)="[ERROR]"
        S YSFILEN=$G(YS("FILEN"),0) I $$VFILE^DILFD(YSFILEN)<1 S ^TMP("YSDATA",$J,2)="BAD FILE N" Q  ;--->out
        S YSFIELDS=$G(YS("FIELDS"),"")
        S:YSFIELDS="*" YSFIELDS="**"
        I YSFIELDS="**"&(YSFILEN=604) S YSFIELDS=".03:200"
        I YSFIELDS?1N.N S N=$$VFIELD^DILFD(YSFILEN,YSFIELDS) I N<1 S ^TMP("YSDATA",$J,2)="BAD field" Q  ;--> out
        S YSIENS=$G(YS("IENS")) I YSIENS'?1N.N S ^TMP("YSDATA",$J,2)="BAD IENS" Q  ;-->out
        S YSIENS=YSIENS_","
        D GETS^DIQ(YSFILEN,YSIENS,YSFIELDS,"IE","^TMP(""YS"",$J")
        S N=1,^TMP("YSDATA",$J,1)="[DATA]"
        S N1=0 F  S N1=$O(^TMP("YS",$J,YSFILEN,YSIENS,N1)) Q:N1'>0  D
        . S N2=0 F  S N2=$O(^TMP("YS",$J,YSFILEN,YSIENS,N1,N2)) Q:N2'>0  S N=N+1,^TMP("YSDATA",$J,N)=N1_";"_N2_U_$$GET1^DID(YSFILEN,N1,"","LABEL")_U_^TMP("YS",$J,YSFILEN,YSIENS,N1,N2)
        . I ^TMP("YS",$J,YSFILEN,YSIENS,N1,"I")'?1"^TMP(".E S N=N+1,^TMP("YSDATA",$J,N)=N1_U_$$GET1^DID(YSFILEN,N1,"","LABEL")_U_$G(^TMP("YS",$J,YSFILEN,YSIENS,N1,"I"))
        . S:(^TMP("YS",$J,YSFILEN,YSIENS,N1,"E")'=^TMP("YS",$J,YSFILEN,YSIENS,N1,"I")) ^TMP("YSDATA",$J,N)=^TMP("YSDATA",$J,N)_U_^TMP("YS",$J,YSFILEN,YSIENS,N1,"E")
        K ^TMP("YS",$J)
        Q