ONCOAIP2        ;Hines OIFO/GWB,RTK - ONCO ABSTRACT-I SUB-ROUTINES ;04/12/01
        ;;2.11;ONCOLOGY;**19,24,28,32,35,36,49**;Mar 07, 1995;Build 38
        ;
LEUKEMIA(REC)   ;Systemic diseases
        N H,HISTNAM,HSTFLD,ICDFILE,ICDNUM
        S L=0
        S H=$E($$HIST^ONCFUNC(REC,.HSTFLD,.HISTNAM,.ICDFILE,.ICDNUM),1,4)
        I ICDNUM=2 I ((H'<9720)&(H'>9732))!((H'<9760)&(H'>9989)) S L=1
        I ICDNUM=3 I ((H'<9731)&(H'>9734))!((H'<9750)&(H'>9989)) S L=1
        Q L
        ;
MO      ;ASSOCIATED WITH HIV (165.5,41)
        S M=$$HIST^ONCFUNC(D0)
        S AWHFLG=0
        I $$LYMPHOMA^ONCFUNC(D0) S Y=41,AWHFLG=1 Q
        S M=$E(M,1,4)
        I M=9140 S Y=41
        E  S Y=227
        Q:Y=227  S $P(^ONCO(165.5,D0,2),U,9)=999
        K M
        Q
        ;
BLOOD   ;PERIPHERAL BLOOD INVOLVEMENT (165.5,30.5)
        ;Mycosis fungoides and Sezary's Disease (9700-9701)
        N CHK,TMP
        S TMP=$$HIST^ONCFUNC(DA),Y="@301"
        F CHK="97002","97003","97012","97013" I CHK=TMP S Y=30.5 Q
        Q
        ;
PGPE    ;PATHOLOGIC EXTENSION (165.5,30.1)
        ;Prostate C61.9
        S Y="@231"
        N TMP S TMP=$P($G(^ONCO(165.5,DA,2)),U,1)
        I TMP=67619 S Y=30.1 Q
        S $P(^ONCO(165.5,DA,2.2),U,2)=""
        Q
        ;
LN      ;BRAIN AND CEREBRAL MENINGES (SEER EOD)
        ;OTHER PARTS OF CENTRAL NERVOUS SYSTEM (SEER EOD)
        N T
        S T=$P($G(^ONCO(165.5,D0,2)),U,1)
        I (T=67700)!($E(T,3,4)=71)!($E(T,3,4)=72) D  S Y="@26" Q
        .S $P(^ONCO(165.5,D0,2),U,11)=9  ;Lymph Nodes
        .S $P(^ONCO(165.5,D0,2),U,12)=99 ;Regional Nodes Positive
        .S $P(^ONCO(165.5,D0,2),U,13)=99 ;Regional Nodes Examined
        .W !,"LYMPH NODES............: Not Applicable"
        .W !,"REGIONAL NODES EXAMINED: Unk; not stated; death cert only"
        .W !,"REGIONAL NODES POSITIVE: Unk if nodes + or -, NA"
        S Y=31
        Q
