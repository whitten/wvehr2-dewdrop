PSOQCF04        ;HINES/RMS - NON-VA MEDS DOCUMENTATION DATE ; 30 Nov 2007  7:55 AM
        ;;7.0;OUTPATIENT PHARMACY;**294**;DEC 1997;Build 13
        ;
NVADT(DFN,TEST,DATE,VALUE,TEXT) ;
        N PSOQL,PSOQDT,PSOQARR,PSOQRDT
        S TEST=0,DATE=""
        D ^PSOHCSUM
        Q:'$D(^TMP("PSOO",$J,"NVA"))
        S PSOQL=0 F  S PSOQL=$O(^TMP("PSOO",$J,"NVA",PSOQL)) Q:'+PSOQL  D  ;
        . S PSOQDT=9999999-$P($G(^TMP("PSOO",$J,"NVA",PSOQL,0)),"^",5)
        . S PSOQARR(PSOQDT)=""
        S PSOQRDT=$O(PSOQARR(0)) Q:PSOQRDT=9999999
        S TEST=1,DATE=9999999-PSOQRDT,TEXT=$$FMTE^XLFDT(DATE,"D")
        Q