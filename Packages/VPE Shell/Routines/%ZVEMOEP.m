%ZVEMOEP ;DJB,VRROLD**CHANGE - Print [12/31/94]
 ;;7.0;VPE;;COPYRIGHT David Bolduc @1993
 ;
PRINTA ;Print All - Heading,Tag,Line
 S CODETG=$P(CD,$C(9)),(CODELN,TEMP)=$P(CD,$C(9),2,999)
 F YCNT=1:1 Q:$L(CODELN)<(YCNT*WIDTH+1)
 D CLRSCRN^%ZVEMOEU
 S DX=14 X VEES("CRSR")
 W @VEE("RON") X VEES("XY") W "LINE:",$J(VRRLN,3),@VEE("ROFF")
 S DX=27 X VEES("CRSR")
 W @VEE("RON") X VEES("XY") W "LENGTH:",$J($L(CD),4),@VEE("ROFF")
 S DX=43 X VEES("CRSR")
 W @VEE("RON") X VEES("XY") W "<ESC>H=Help",@VEE("ROFF")
 S DX=58 X VEES("CRSR")
 W @VEE("RON") X VEES("XY") W "<RET>=Quit",@VEE("ROFF")
 S DX=0,DY=DY+1 X VEES("CRSR")
 W @VEE("RON") X VEES("XY") W "  TAG-->" S DX=$X W @VEE("ROFF") X VEES("XY")
 W " ",CODETG
 S DX=0,DY=DY+1 X VEES("CRSR")
 W @VEE("RON") X VEES("XY") W " LINE-->" S DX=$X W @VEE("ROFF") X VEES("XY")
 W " ",$E(CODELN,1,WIDTH) S TEMP=$E(CODELN,WIDTH+1,999)
PRINTA1 ;Print remainder of line
 I TEMP="" D CLRSCRN1^%ZVEMOEU Q
 W !?9,$E(TEMP,1,WIDTH) S TEMP=$E(TEMP,WIDTH+1,999)
 G PRINTA1
PRINTL ;Print Line
 S CODETG=$P(CD,$C(9)),CODELN=$P(CD,$C(9),2,999)
 S TEMP=$E(CODELN,XCHAR,999)
 F YCNT=1:1 Q:$L(CODELN)<(YCNT*WIDTH+1)
 I YCNT>YCNTHLD S TOP=TOP-1,YCNTHLD=YCNTHLD+1 D PRINTA Q  ;When lines scroll up.
 S DX=34,DY=TOP X VEES("CRSR")
 W @VEE("RON") X VEES("XY") W $J($L(CD),4),@VEE("ROFF")
 I XCUR>START S DX=XCUR,DY=TOP+1+YCUR X VEES("CRSR") W @VEES("BLANK_C_EOS")
 I XCUR=START,YCUR=1 S DX=XCUR,DY=TOP+1+YCUR X VEES("CRSR") W @VEES("BLANK_C_EOS")
 I XCUR=START,YCUR>1 S DX=WIDTH+START,DY=TOP+1+YCUR-1 X VEES("CRSR") W @VEES("BLANK_C_EOS") S DX=XCUR,DY=TOP+1+YCUR
 X VEES("CRSR")
 W $E(TEMP,1,WIDTH+START-XCUR) S TEMP=$E(TEMP,WIDTH+START+1-XCUR,999)
PRINTL1 ;Print remainder of line
 I TEMP="" X VEES("CRSR") Q
 W !?START,$E(TEMP,1,WIDTH) S TEMP=$E(TEMP,WIDTH+1,999)
 G PRINTL1
 Q
PRINTT ;Print Tag
 S CODETG=$P(CD,$C(9)),CODELN=$P(CD,$C(9),2,999)
 S DX=34,DY=TOP X VEES("CRSR") W @VEE("RON"),$J($L(CD),4),@VEE("ROFF")
 S DX=XCUR,DY=TOP+1 X VEES("CRSR") W @VEES("BLANK_C_EOL") X VEES("XY")
 W $E(CODETG,XCHAR,999)
 S DX=XCUR,DY=TOP+1 X VEES("CRSR")
 Q