DVBHCE23 ; ;09/25/12
 S X=DG(DQ),DIC=DIE
 X ^DD(2,.525,1,1,1.3) I X S X=DIV S Y(1)=$S($D(^DPT(D0,.52)):^(.52),1:"") S X=$S('$D(^DIC(22,+$P(Y(1),U,6),0)):"",1:$P(^(0),U,1)) S DIU=X K Y S X=DIV S X="" X ^DD(2,.525,1,1,1.4)
 S X=DG(DQ),DIC=DIE
 X ^DD(2,.525,1,2,1.3) I X S X=DIV S Y(1)=$S($D(^DPT(D0,.52)):^(.52),1:"") S X=$P(Y(1),U,7) S DIU=X K Y S X=DIV S X="" X ^DD(2,.525,1,2,1.4)
 S X=DG(DQ),DIC=DIE
 X ^DD(2,.525,1,3,1.3) I X S X=DIV S Y(1)=$S($D(^DPT(D0,.52)):^(.52),1:"") S X=$P(Y(1),U,8) S DIU=X K Y S X=DIV S X="" X ^DD(2,.525,1,3,1.4)
 S X=DG(DQ),DIC=DIE
 D AUTOUPD^DGENA2(DA)
 S X=DG(DQ),DIC=DIE
 X "S DFN=DA D EN^DGMTR K DGREQF"
 S X=DG(DQ),DIC=DIE
 D EVENT^IVMPLOG(DA)
