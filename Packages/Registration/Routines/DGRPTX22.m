DGRPTX22 ; ;09/19/10
 S X=DE(17),DIC=DIE
 K DIV S DIV=X,D0=DA,DIV(0)=D0 S Y(1)=$S($D(^DPT(D0,.322)):^(.322),1:"") S X=$P(Y(1),U,14),X=X S DIU=X K Y S X="" S DIH=$G(^DPT(DIV(0),.322)),DIV=X S $P(^(.322),U,14)=DIV,DIH=2,DIG=.322014 D ^DICR
 S X=DE(17),DIC=DIE
 K DIV S DIV=X,D0=DA,DIV(0)=D0 S Y(1)=$S($D(^DPT(D0,.322)):^(.322),1:"") S X=$P(Y(1),U,15),X=X S DIU=X K Y S X="" S DIH=$G(^DPT(DIV(0),.322)),DIV=X S $P(^(.322),U,15)=DIV,DIH=2,DIG=.322015 D ^DICR
 S X=DE(17),DIC=DIE
 D AUTOUPD^DGENA2(DA)