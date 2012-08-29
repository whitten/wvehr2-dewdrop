LRSORC1A        ;DALISC/DRH - LRSORC Continued ;07-22-93
        ;;5.2;LAB SERVICE;**201,344,351,384**;Sep 27, 1994;Build 2
INIT    ;
        S U="^"
        D CONTROL
        Q
CONTROL ;
        D SORT
        Q
SORT    ;
        W:$E(IOST,1,2)="C-" @IOF
        W:$E(IOST,1,2)="P-" !
        D HDR
        D PRINT
        D:'LREND SUMMARY
        D END
        Q
SUMMARY ;
        I ($Y>(IOSL-7)) D:$E(IOST,1,2)="C-" WAIT Q:LREND  W @IOF D HDR
        F I=$Y:1:(IOSL-6) W !
        W ?20,"END OF SPECIAL REPORT"
        Q
END     ;
        D:($E(IOST,1,2)="C-")&('LREND) WAIT
        W @IOF D:'$D(ZTQUEUED) ^%ZISC
        K ^TMP("LR",$J)
        K ZTRTN,ZTIO,ZTDESC,ZTSAVE,ZTSK,ZTQUEUED,%ZIS,POP,%H,%DT,DTOUT,DUOUT
        K DIR,DIC,I,T,C,X,Y,L0,SEX,AGE,DFN,DOB,PNM,SSN,VA("BID"),VA("PID"),VAERR
        K LRAA,LRAD,LRDFN,LRDPF,LREND,LRFAN,LRIDT,LRLAN,LRLCS,LRSUB1,LRSUB2
        K LRLLOC,LRTX,LRTST,LRTVAL,LRCRTFLG,LRAN,LRSRT,LRPAG,LRDATE,LRDASH,LRDAT
        K LRLOC,LRPTS,LREDT,LRPDT,LRSDT,LRTREC,LRPREC,LREDAT,LRSDAT,LRSPDAT
        K LRWRD,LRHDR2,LRSUB3,LRAAA
        Q
PRINT   ;
        S LRSUB1=""
        I $O(^TMP("LR",$J,LRSUB1))="" W !!?30,"NO MATCHING DATA FOUND",!! Q
        F  S LRSUB1=$O(^TMP("LR",$J,LRSUB1)) Q:(LRSUB1="")!(LREND)  D
        .S LRSUB2=""
        .F  S LRSUB2=$O(^TMP("LR",$J,LRSUB1,LRSUB2)) Q:(LRSUB2="")!(LREND)  D
        ..S LRSUB3=""
        ..F  S LRSUB3=$O(^TMP("LR",$J,LRSUB1,LRSUB2,LRSUB3)) Q:(LRSUB3="")!(LREND)  D
        ...S LRAN=""
        ...F  S LRAN=$O(^TMP("LR",$J,LRSUB1,LRSUB2,LRSUB3,LRAN)) Q:(LRAN="")!(LREND)  D
        ....S LRPREC=^TMP("LR",$J,LRSUB1,LRSUB2,LRSUB3,LRAN)
        ....S LRDPF=$P(LRPREC,U,4)
        ....S PNM=$P(LRPREC,U),SSN=$P(LRPREC,U,2),LRLOC=$P(LRPREC,U,3)
        ....S LRSPEC=$P(^LAB(61,$P(LRPREC,U,6),0),U)
        ....S LRSPNUM=$P(LRPREC,U,6)
        ....S LRSPDAT=$P(LRPREC,U,5)
        ....I ($Y>(IOSL-8)) D:$E(IOST,1,2)="C-" WAIT Q:LREND  W @IOF D HDR
        ....;S PNM1=$P(PNM,","),PNM2=$P(PNM,",",2)
        ....;S LRCHNG=PNM1 D CHNCASE^LRSORA2 S PNM1=LRCHNG
        ....;S LRCHNG=PNM2 D CHNCASE^LRSORA2 S PNM2=LRCHNG
        ....;S PNM=PNM1_","_PNM2
        ....;S LRCHNG=LRSPEC D CHNCASE^LRSORA2 S LRSPEC=LRCHNG
        ....W !,$E(PNM,1,22),?23,$E(SSN,1,11) W:LRDPF=2 ?35,$E(LRLOC,1,12),?48,$E(LRAN,1,14)
        ....W ?63,LRSPDAT
        ....W !," ",LRSPEC
        ....D PRNTST
        Q
PRNTST  ;
        N LRRLO,LRRHI,LRCLO,LRCHI,LRTLO,LRTHI,LRFLAG,VAR
        S I=""
        F  S I=$O(^TMP("LR",$J,LRSUB1,LRSUB2,LRSUB3,LRAN,"TST",I)) Q:(I="")!(LREND)  D
        .S LRTREC=^TMP("LR",$J,LRSUB1,LRSUB2,LRSUB3,LRAN,"TST",I)
        .S LRTST=$P(LRTREC,U),LRTVAL=$P(LRTREC,U,2),LRCRTFLG=$P(LRTREC,U,3)
        .I ($Y>(IOSL-7)) D
        ..D CONT D:$E(IOST,1,2)="C-" WAIT Q:LREND
        ..W @IOF D HDR
        ..W !,$E(PNM,1,22),?23,$E(SSN,1,11) W:LRDPF=2 ?35,$E(LRLOC,1,12),?48,$E(LRAN,1,14)
        ..W ?63,LRSPDAT
        .Q:LREND
        .S LRTX=$P(LRTREC,U,5)
        .S LRFLAG=$P(LRTREC,U,6)
        .S LRREF=$G(^LAB(60,LRTX,1,LRSPNUM,0))
        .; set ranges  LRFLAG on - from file 63     LRFLAG off - from file 60
        .S LRRLO=$S(LRFLAG:$P(LRTREC,U,7),1:$P(LRREF,U,2))
        .S LRRHI=$S(LRFLAG:$P(LRTREC,U,8),1:$P(LRREF,U,3))
        .S LRCLO=$S(LRFLAG:$P(LRTREC,U,9),1:$P(LRREF,U,4))
        .S LRCHI=$S(LRFLAG:$P(LRTREC,U,10),1:$P(LRREF,U,5))
        .S LRTLO=$S(LRFLAG:$P(LRTREC,U,11),1:$P(LRREF,U,11))
        .S LRTHI=$S(LRFLAG:$P(LRTREC,U,12),1:$P(LRREF,U,12))
        .F VAR="LRRLO","LRRHI","LRCLO","LRCHI" I @VAR="" S @VAR="none"
        .;
        .S LRTST=$P($G(^LAB(60,LRTX,.1)),U)
        .I LRTST="" S LRTST=$E($P(^LAB(60,LRTX,0),U),1,10)
        .;I 'LRTST S LRTST=$E($P(^LAB(60,LRTX,0),U),1,10)
        .;S LRCHNG=LRTST D CHNCASE^LRSORA2 S LRTST=LRCHNG
        .W !,?2,$E(LRTST,1,9),?12,$J(LRTVAL,6)
        .W ?19,$E($P(LRREF,U,7),1,10),?28,LRCRTFLG
        . I 'LRTLO,('LRTHI) D RANGE
        . I LRTLO W ?32,"Ther: ",LRTLO,"-"
        . I LRTHI W LRTHI D CRITICL
        I '$O(^TMP("LR",$J,LRSUB1,LRSUB2,LRSUB3,LRAN,"COM",0)) W !
        E  D COM
        Q
COM     ;Print comments on specimen
        W !,"COMMENT(S): "
        S C=""
        F  S C=$O(^TMP("LR",$J,LRSUB1,LRSUB2,LRSUB3,LRAN,"COM",C)) Q:(C="")!(LREND)  D
        .I ($Y>(IOSL-7)) D
        ..D CONT D:$E(IOST,1,2)="C-" WAIT Q:LREND
        ..W @IOF D HDR
        ..W !,$E(PNM,1,22),?23,$E(SSN,1,11) W:LRDPF=2 ?35,$E(LRLOC,1,12),?48,$E(LRAN,1,14)
        ..W ?63,LRSPDAT
        ..;W !,PNM,?35,SSN W:LRDPF=2 " ",LRLOC,?60,LRAN
        ..;D HDR
        ..W !,"COMMENT(S): "
        .Q:LREND
        .W ?12,^TMP("LR",$J,LRSUB1,LRSUB2,LRSUB3,LRAN,"COM",C),!
        Q
HDR     ;
        S LRPAG=LRPAG+1
        W "SPECIAL REPORT: SEARCHING FOR CRITICAL FLAGS  "
        W LRDATE,?65,"Pg ",LRPAG,!,LRHDR2,!
        D LRGLIN^LRX
        Q
RANGE   ;
        W ?31,"Ref. Range: ",LRRLO,"-",LRRHI
        D CRITICL
        Q
CRITICL ;
        W ?57,"Critical: ",LRCLO,"-",LRCHI
        Q
WAIT    ;
        K DIR S DIR(0)="E" D ^DIR
        S:($D(DTOUT))!($D(DUOUT)) LREND=1
        Q
CONT    W !?10,"CONTINUED NEXT PAGE",! Q