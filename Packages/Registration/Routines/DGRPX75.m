DGRPX75 ; ;09/25/12
 S X=DE(28),DIC=DIE
 X ^DD(2,.3025,1,1,2.3) I X S X=DIV S Y(1)=$S($D(^DPT(D0,.3)):^(.3),1:"") S X=$P(Y(1),U,3),X=X S DIU=X K Y S X="" X ^DD(2,.3025,1,1,2.4)
 S X=DE(28),DIC=DIE
 K DIV S DIV=X,D0=DA,DIV(0)=D0 S Y(0)=X S X='$$TOTCHK^DGLOCK2(DA) I X S X=DIV S Y(1)=$S($D(^DPT(D0,.362)):^(.362),1:"") S X=$P(Y(1),U,20),X=X S DIU=X K Y S X="" X ^DD(2,.3025,1,2,2.4)
 S X=DE(28),DIC=DIE
 D EVENT^IVMPLOG(DA)
