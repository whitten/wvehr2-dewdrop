OCXBDT6 ;SLC/RJS,CLA - BUILD OCX PACKAGE DIAGNOSTIC ROUTINES (Build Runtime Library Routine OCXDI2) ;8/04/98  13:21
 ;;3.0;ORDER ENTRY/RESULTS REPORTING;**32**;Dec 17,1997
 ;;  ;;ORDER CHECK EXPERT version 1.01 released OCT 29,1998
 ;
EN() ;
 ;
 N R,LINE,TEXT,NOW,RUCI,XCM
 S NOW=$$NOW^OCXBDT3,RUCI=$$CUCI^OCXBDT
 F LINE=1:1:999 S TEXT=$P($T(TEXT+LINE),";",2,999) Q:TEXT  S TEXT=$P(TEXT,";",2,999) S R(LINE,0)=$$CONV^OCXBDT3(TEXT)
 ;
 M ^TMP("OCXBDT",$J,"RTN")=R
 ;
 S DIE="^TMP(""OCXBDT"","_$J_",""RTN"",",XCN=0,X="OCXDI2"
 W !,X X ^%ZOSF("SAVE") W "  ... ",XCM," Lines filed" K ^TMP("OCXBDT",$J,"RTN")
 ;
 Q XCM
 ;
TEXT ;
 ;;OCXDI2 ;SLC/RJS,CLA - OCX PACKAGE DIAGNOSTIC UTILITY ROUTINE ;|NOW|
 ;;|OCXLIN2|
 ;;|OCXLIN3|
 ;; ;
 ;;S ;
 ;; ;  Record Utilities
 ;; Q
 ;; ;
 ;;ADDREC(OCXCREF) ;
 ;; ;
 ;; ;
 ;; N QUIT,OCXDD,OCXDA,OCXGREF,OCXNAME
 ;; S OCXDD=$O(@OCXCREF@("")) Q:'OCXDD 0
 ;; Q:'OCXFLGC 0
 ;; I (OCXFLGA) S QUIT=$$READ("Y"," Do you want to add a local '"_$$FILENAME^OCXBDTD(+OCXDD)_"' record ?","YES") Q:'QUIT (QUIT[U)
 ;; ;
 ;; S OCXDA=0 D CREATE(OCXCREF,OCXDD,.OCXDA,0)
 ;; S OCXNAME=$G(@OCXCREF@(OCXDD,.01,"E")) S:$L(OCXNAME) ^TMP("OCXDIAG",$J,"A",+OCXDD,OCXNAME)=""
 ;; ;
 ;; Q 0
 ;; ;
 ;;DELREC(OCXFILE,OCXDA) ;
 ;; ;
 ;; ;
 ;; N QUIT
 ;; Q:'OCXFLGC 0 Q:$G(OCXAUTO) 0
 ;; I (OCXFLGA) S QUIT=$$READ("Y"," Do you want to delete the local '"_$$FILENAME^OCXBDTD(+OCXFILE)_"' record ?","YES") Q:'QUIT (QUIT[U)
 ;; ;
 ;; W !,OCXFILE," ",OCXDA
 ;; D DIE(OCXFILE,$$FILE^OCXBDTD(OCXFILE,"GLOBAL NAME"),.01,"@",OCXDA,0)
 ;; W !!,"  deleted..."
 ;; ;
 ;; Q 0
 ;; ;
 ;;DELDUP(OCXFILE,OCXNAME) ;
 ;; ;
 ;; ;
 ;; N OCXQUIT,OCXCGL,OCXOGL,OCXD0,RESP,OCXKEY,KEYLEN,OCXKEEP
 ;; ;
 ;; I (OCXFLGR) W !," There are duplicate copies of the '"_$$FILENAME^OCXBDTD(+OCXFILE)_":"_OCXNAME_"' record."
 ;; I '$G(OCXAUTO),'OCXFLGC Q 0
 ;; I (OCXFLGA) S RESP=$$READ("Y"," Do you want to purge duplicate copies of the '"_$$FILENAME^OCXBDTD(+OCXFILE)_":"_OCXNAME_"' record ?","YES") Q:'RESP 0 Q:(RESP[U) -10
 ;; ;
 ;; S OCXOGL=$$FILE^OCXBDTD(OCXFILE,"GLOBAL NAME")
 ;; S OCXCGL=$$CREF^DILF(OCXOGL)
 ;; F KEYLEN=$L(OCXNAME):-1:1 S OCXKEY=$E(OCXNAME,1,KEYLEN)  Q:$D(@OCXCGL@("B",OCXKEY))
 ;; S OCXD0=0 F  S OCXD0=$O(@OCXCGL@("B",OCXKEY,OCXD0)) Q:'OCXD0  Q:($P($G(@OCXCGL@(OCXD0,0)),U,1)=OCXNAME)
 ;; W:OCXFLGR !,"Keep:   ",OCXFILE," ",OCXNAME," ",OCXD0
 ;; S OCXKEEP=OCXD0 F  S OCXD0=$O(@OCXCGL@("B",OCXKEY,OCXD0)) Q:'OCXD0  I ($P($G(@OCXCGL@(OCXD0,0)),U,1)=OCXNAME) D
 ;; .W:OCXFLGR !!,"Delete: ",OCXFILE," ",OCXNAME," ",OCXD0
 ;; .D DIE(OCXFILE,OCXOGL,.01,"@",OCXD0,0)
 ;; .W:OCXFLGR "  deleted..."
 ;; ;
 ;; I ($P($G(@OCXCGL@(OCXKEEP,0)),U,1)=OCXNAME) S ^TMP("OCXDIAG",$J,"A",FILE,OCXNAME)=""
 ;; ;
 ;; Q OCXKEEP
 ;; ;
 ;;CREATE(OCXCREF,OCXDD,OCXDA,OCXLVL) ;
 ;; ;
 ;; N OCXFLD,OCXGREF,OCXKEY
 ;; ;
 ;; S OCXKEY=@OCXCREF@(OCXDD,.01,"E")
 ;; S OCXGREF=$$GETREF(+OCXDD,.OCXDA,OCXLVL) Q:'$L(OCXGREF)
 ;; I 'OCXDA D
 ;; .S OCXDA=$O(^TMP("OCXDIAG",$J,"B",+OCXDD,OCXKEY,0)) Q:OCXDA
 ;; .S OCXDA=$O(@(OCXGREF_""" "")"),-1)+1
 ;; .F OCXDA=OCXDA:1 Q:'$D(@(OCXGREF_OCXDA_",0)"))
 ;; .I $D(@(OCXGREF_OCXDA_",0)")) S OCXDA=0
 ;; ;
 ;; I 'OCXDA W !!,"Error adding record..." Q
 ;; ;
 ;; I '$D(@(OCXGREF_"0)")) S @(OCXGREF_"0)")=U_$$FILEHDR^OCXBDTD(+OCXDD)_U_U
 ;; ;
 ;; S OCXFLD=0 F  S OCXFLD=$O(@OCXCREF@(OCXDD,OCXFLD)) Q:'OCXFLD  Q:(OCXFLD[":")  I '$$EXFLD^OCXDI1(+OCXDD,OCXFLD) D
 ;; .I $L($G(@OCXCREF@(OCXDD,OCXFLD,"E"))) D DIE(OCXDD,OCXGREF,OCXFLD,@OCXCREF@(OCXDD,OCXFLD,"E"),.OCXDA,OCXLVL)
 ;; .I $O(@OCXCREF@(OCXDD,OCXFLD,0)) D WORD(OCXDD,OCXGREF,OCXFLD,.OCXDA,OCXCREF)
 ;; ;
 ;; D PUSH(.OCXDA)
 ;; S OCXFLD="" F  S OCXFLD=$O(@OCXCREF@(OCXDD,OCXFLD)) Q:'$L(OCXFLD)  I (OCXFLD[":") D
 ;; .S OCXDA=$P(OCXFLD,":",2) W:OCXFLGR ! D CREATE($$APPEND(OCXCREF,OCXDD),OCXFLD,.OCXDA,OCXLVL+1)
 ;; D POP(.OCXDA)
 ;; Q
 ;; ;
 ;;LOADWORD(RREF,OCXDD,OCXFLD,OCXSUB) ;
 ;; ;
 ;; N QUIT,DDPATH,INDEX,OCXDA,OCXGREF
 ;; S DDPATH=$P($P($$APPEND(RREF,OCXDD),"(",2),")",1)
 ;; F INDEX=1:1:$L(DDPATH,",") S OCXDA($L(DDPATH,",")-INDEX)=+$P($P(DDPATH,",",INDEX),":",2)
 ;; S OCXDA=$G(OCXDA(0)) K OCXDA(0)
 ;; Q:'OCXFLGC 0 I OCXFLGA S QUIT=$$READ("Y"," Do you want to reload the local '"_$$FIELD^OCXBDTD(+OCXDD,+OCXFLD,"LABEL")_"' field ?","YES") Q:'QUIT (QUIT[U)
 ;; S OCXGREF=$$GETREF(+OCXDD,.OCXDA,$L(DDPATH,",")-1) Q:'$L(OCXGREF)
 ;; D WORD(OCXDD,OCXGREF,OCXFLD,.OCXDA,RREF)
 ;; Q 0
 ;; ;
 ;;GETREF(OCXDD,OCXDA,OCXLVL) ;
 ;; ;
 ;; Q:'OCXDD ""
 ;; ;
 ;; N OCXIENS,OCXERR,OCXX
 ;; S OCXIENS=$$IENS^DILF(.OCXDA),OCXERR=""
 ;; S OCXX=$$ROOT^DILFD(OCXDD,OCXIENS,0,OCXERR)
 ;; Q OCXX
 ;; ;
 ;;WORD(DD,GREF,FLD,DA,RREF) ;
 ;; ;
 ;; N SUB,GLROOT,LINE
 ;; S SUB=$P($$FIELD^OCXBDTD(+DD,FLD,"GLOBAL SUBSCRIPT LOCATION"),";",1) S:'(SUB=+SUB) SUB=""""_SUB_""""
 ;; S GLROOT=GREF_DA_","_SUB_")" K @GLROOT
 ;; S LINE=0 F  S LINE=$O(@RREF@(DD,FLD,LINE)) Q:'LINE  D
 ;; .S @GLROOT@($O(@GLROOT@(""),-1)+1,0)=@RREF@(DD,FLD,LINE)
 ;; S LINE=$O(@GLROOT@(""),-1),@GLROOT@(0)=U_U_LINE_U_LINE_U_$$DATE("T")_U
 ;; ;
 ;; Q
 ;; ;
 ;;DATE(X) N %DT,Y S %DT="" D ^%DT Q +Y
 ;; ;
 ;;DIE(OCXDD,OCXDIC,OCXFLD,OCXVAL,OCXDA,OCXLVL) ;
 ;; ;
 ;; N DIC,DIE,X,Y,DR,DA,OCXDVAL,OCXPTR,OCXGREF,D0
 ;; S (D0,DA)=OCXDA,(DIC,DIE)=OCXDIC,DR=""
 ;; S:OCXLVL D0=OCXDA(1),DR="S DA(1)="_(+D0)_",D0="_(+D0)_";"
 ;; S:OCXVAL="?" OCXVAL="? "
 ;; ;
 ;; I '(OCXVAL="@"),OCXFLGR W !,?(OCXLVL*5),$$FIELD^OCXBDTD(+OCXDD,OCXFLD,"LABEL"),": ",OCXVAL
 ;; ;
 ;; I '(OCXVAL="@") D
 ;; .N OCXIEN,SHORT
 ;; .S OCXPTR=+$P($$FIELD^OCXBDTD(+OCXDD,OCXFLD,"SPECIFIER"),"P",2)
 ;; .I 'OCXPTR S DR=DR_OCXFLD_"///^S X=OCXVAL" Q
 ;; .S OCXGREF="^"_$$FIELD^OCXBDTD(+OCXDD,OCXFLD,"POINTER")
 ;; .I '($E(OCXGREF,1,4)="^OCX"),'(OCXGREF="^ORD(100.9,"),'(OCXGREF="^ORD(100.8,") Q
 ;; .S OCXIEN=$$DIC(OCXGREF,OCXVAL,0)
 ;; .S:'OCXIEN OCXIEN=$$DIC(OCXGREF,OCXVAL,1),^TMP("OCXDIAG",$J,"B",OCXPTR,OCXVAL,OCXIEN)=""
 ;; .S DR=DR_OCXFLD_"///`"_(+OCXIEN)
 ;; ;
 ;; I (OCXVAL="@") S DR=DR_OCXFLD_"///^S X=OCXVAL"
 ;; S OCXSCR=1
 ;; D ^DIE
 ;; ;
 ;; ; I $D(Y) -> DIE FILER ERROR
 ;; ;
 ;; Q
 ;; ;
 ;;DIC(DIC,X,OCXADD) S DIC(0)="MX",OCXSCR=1 S:OCXADD DIC(0)="MXL" D ^DIC Q:(+Y>0) +Y Q 0
 ;; ;
 ;;PUSH(OCXDA) ;
 ;; N OCXSUB S OCXSUB="" F  S OCXSUB=$O(OCXDA(OCXSUB),-1) Q:'OCXSUB  S OCXDA(OCXSUB+1)=OCXDA(OCXSUB)
 ;; S OCXDA(1)=OCXDA,OCXDA=0
 ;; Q
 ;; ;
 ;;POP(OCXDA) ;
 ;; N OCXSUB S OCXSUB="" F  S OCXSUB=$O(OCXDA(OCXSUB)) Q:'OCXSUB  S OCXDA(OCXSUB)=$G(OCXDA(OCXSUB+1))
 ;; S OCXDA=OCXDA(1) K OCXDA($O(OCXDA(""),-1))
 ;; Q
 ;; ;
 ;;APPEND(ARRAY,OCXSUB) ;
 ;; S:'(OCXSUB=+OCXSUB) OCXSUB=""""_OCXSUB_""""
 ;; Q:'(ARRAY["(") ARRAY_"("_OCXSUB_")"
 ;; Q $E(ARRAY,1,$L(ARRAY)-1)_","_OCXSUB_")"
 ;; ;
 ;;READ(OCXZ0,OCXZA,OCXZB,OCXZL) ;
 ;; N OCXLINE,DIR,DTOUT,DUOUT,DIRUT,DIROUT
 ;; Q:'$L($G(OCXZ0)) U
 ;; S DIR(0)=OCXZ0
 ;; S:$L($G(OCXZA)) DIR("A")=OCXZA
 ;; S:$L($G(OCXZB)) DIR("B")=OCXZB
 ;; F OCXLINE=1:1:($G(OCXZL)-1) W !
 ;; D ^DIR
 ;; I $D(DTOUT)!$D(DUOUT)!$D(DIRUT)!$D(DIROUT) Q U
 ;; Q Y
 ;; ;
 ;;PAUSE() Q:'OCXFLGC 0 W "  Press Enter " R X:DTIME W ! Q (X[U)
 ;; ;
 ;;$
 ;1;
 ;