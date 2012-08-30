ONCMPH  ;Hines OIFO/GWB - Multiple primary stuffing logic ;01/26/07
        ;;2.11;ONCOLOGY;**47,49**;Mar 07, 1995;Build 38
        ;
NA      ;"Not applicable" stuffing for:
        ;MULT TUM RPT AS ONE PRIM (165.5,194)
        ;DATE OF MULTIPLE TUMORS  (165.5,195)
        ;MULTIPLICITY COUNTER     (165.5,196)
        S $P(^ONCO(165.5,DA,24),U,14)=11
        W !,"MULT TUM RPT AS ONE PRIM: NA"
        S $P(^ONCO(165.5,DA,24),U,15)=8888888
        W !,"DATE OF MULTIPLE TUMORS: 88/88/8888"
        S $P(^ONCO(165.5,DA,24),U,16)=88
        W !,"MULTIPLICITY COUNTER: 88"
        S Y=83
        Q
        ;
MTRAOP  ;MULT TUM RPT AS ONE PRIM (165.5,194)
        I X=1 D   S Y=83 Q
        .S $P(^ONCO(165.5,DA,24),U,15)="0000000"
        .W !,"DATE OF MULTIPLE TUMORS: 00/00/0000"
        .S $P(^ONCO(165.5,DA,24),U,16)="01"
        .W !,"MULTIPLICITY COUNTER: 01"
        I X=11 D  S Y=83 Q
        .S $P(^ONCO(165.5,DA,24),U,15)=8888888
        .W !,"DATE OF MULTIPLE TUMORS: 88/88/8888"
        .S $P(^ONCO(165.5,DA,24),U,16)=88
        .W !,"MULTIPLICITY COUNTER: 88"
        I X=12 D  S Y=83 Q
        .S $P(^ONCO(165.5,DA,24),U,15)=9999999
        .W !,"DATE OF MULTIPLE TUMORS: 99/99/9999"
        .S $P(^ONCO(165.5,DA,24),U,16)=99
        .W !,"MULTIPLICITY COUNTER: 99"
        Q
