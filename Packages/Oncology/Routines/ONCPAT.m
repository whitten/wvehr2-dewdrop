ONCPAT  ;Hines OIFO/GWB - PATIENT IDENTIFICATION ;12/08/00
        ;;2.11;ONCOLOGY;**27,32,33,34,37,41,45,49**;Mar 07, 1995;Build 38
        ;
        W !
        K DR
        S DIE="^ONCO(160,",DA=ONCOD0,DR=""
        S DR(1,160,1)="7    PLACE OF BIRTH............."
        S DR(1,160,2)="8    RACE 1.....................//^S X=RACE"
        S DR(1,160,3)="I X'=99 S Y=""@81"""
        S DR(1,160,4)="8.1////99"
        S DR(1,160,5)="8.2////99"
        S DR(1,160,6)="8.3////99"
        S DR(1,160,7)="8.4////99"
        S DR(1,160,8)="W !,""    RACE 2.....................: Unknown"""
        S DR(1,160,9)="W !,""    RACE 3.....................: Unknown"""
        S DR(1,160,10)="W !,""    RACE 4.....................: Unknown"""
        S DR(1,160,11)="W !,""    RACE 5.....................: Unknown"""
        S DR(1,160,12)="S Y=9"
        S DR(1,160,13)="@81"
        S DR(1,160,14)="8.1    RACE 2.....................//NA"
        S DR(1,160,15)="S Y=$S(X=88:""@8288"",X=99:""@8299"",X="""":""@8200"",1:""@82"")"
        S DR(1,160,16)="@8288"
        S DR(1,160,17)="8.2////88"
        S DR(1,160,18)="8.3////88"
        S DR(1,160,19)="8.4////88"
        S DR(1,160,20)="W !,""    RACE 3.....................: NA"""
        S DR(1,160,21)="W !,""    RACE 4.....................: NA"""
        S DR(1,160,22)="W !,""    RACE 5.....................: NA"""
        S DR(1,160,23)="S Y=9"
        S DR(1,160,24)="@8299"
        S DR(1,160,25)="8.2////99"
        S DR(1,160,26)="8.3////99"
        S DR(1,160,27)="8.4////99"
        S DR(1,160,28)="W !,""    RACE 3.....................: Unknown"""
        S DR(1,160,29)="W !,""    RACE 4.....................: Unknown"""
        S DR(1,160,30)="W !,""    RACE 5.....................: Unknown"""
        S DR(1,160,31)="S Y=9"
        S DR(1,160,32)="@8200"
        S DR(1,160,33)="8.2////@"
        S DR(1,160,34)="8.3////@"
        S DR(1,160,35)="8.4////@"
        S DR(1,160,36)="W !,""    RACE 3.....................:"""
        S DR(1,160,37)="W !,""    RACE 4.....................:"""
        S DR(1,160,38)="W !,""    RACE 5.....................:"""
        S DR(1,160,39)="S Y=9"
        S DR(1,160,40)="@82"
        S DR(1,160,41)="8.2    RACE 3.....................//NA"
        S DR(1,160,42)="S Y=$S(X=88:""@8388"",X=99:""@8399"",X="""":""@8300"",1:""@83"")"
        S DR(1,160,43)="@8388"
        S DR(1,160,44)="8.3////88"
        S DR(1,160,45)="8.4////88"
        S DR(1,160,46)="W !,""    RACE 4.....................: NA"""
        S DR(1,160,47)="W !,""    RACE 5.....................: NA"""
        S DR(1,160,48)="S Y=9"
        S DR(1,160,49)="@8399"
        S DR(1,160,50)="8.3////99"
        S DR(1,160,51)="8.4////99"
        S DR(1,160,52)="W !,""    RACE 4.....................: Unknown"""
        S DR(1,160,53)="W !,""    RACE 5.....................: Unknown"""
        S DR(1,160,54)="S Y=9"
        S DR(1,160,55)="@8300"
        S DR(1,160,56)="8.3////@"
        S DR(1,160,57)="8.4////@"
        S DR(1,160,58)="W !,""    RACE 4.....................:"""
        S DR(1,160,59)="W !,""    RACE 5.....................:"""
        S DR(1,160,60)="S Y=9"
        S DR(1,160,61)="@83"
        S DR(1,160,62)="8.3    RACE 4.....................//NA"
        S DR(1,160,63)="S Y=$S(X=88:""@8488"",X=99:""@8499"",X="""":""@8400"",1:""@84"")"
        S DR(1,160,64)="@8488"
        S DR(1,160,65)="8.4////88"
        S DR(1,160,66)="W !,""    RACE 5.....................: NA"""
        S DR(1,160,67)="S Y=9"
        S DR(1,160,68)="@8499"
        S DR(1,160,69)="8.4////99"
        S DR(1,160,70)="W !,""    RACE 5.....................: Unknown"""
        S DR(1,160,71)="S Y=9"
        S DR(1,160,72)="@8400"
        S DR(1,160,73)="8.4////@"
        S DR(1,160,74)="W !,""    RACE 5.....................:"""
        S DR(1,160,75)="S Y=9"
        S DR(1,160,76)="@84"
        S DR(1,160,77)="8.4    RACE 5.....................//NA"
        S DR(1,160,78)="9    SPANISH ORIGIN.............//^S X=""Non-Spanish, non-Hispanic"""
        S DR(1,160,79)="10    SEX........................"
        S DR(1,160,80)="48    AGENT ORANGE EXPOSURE......//^S X=AOE"
        S DR(1,160,81)="50    IONIZING RADIATION EXPOSURE//^S X=IRE"
        S DR(1,160,82)="52    CHEMICAL EXPOSURE.........."
        S DR(1,160,83)="61    ASBESTOS EXPOSURE.........."
        S DR(1,160,84)="62    VIETNAM SERVICE............//^S X=VSI"
        S DR(1,160,85)="55    LEBANON SERVICE............//^S X=LSI"
        S DR(1,160,86)="63    GRENADA SERVICE............//^S X=GSI"
        S DR(1,160,86.1)="64    PANAMA SERVICE.............//^S X=PSI"
        S DR(1,160,86.2)="51    PERSIAN GULF SERVICE.......//^S X=PGS"
        S DR(1,160,86.3)="56    SOMALIA SERVICE............//^S X=SS"
        S DR(1,160,86.4)="65    YUGOSLAVIA SERVICE.........//^S X=YSI"
        S DR(1,160,87)="W ! K DIR S DIR(0)=""E"" D ^DIR"
        S DR(1,160,88)="I $D(DIRUT) S Y=""@99"""
        S DR(1,160,89)="W @IOF"
        S DR(1,160,90)="W !?4,""Patient name: "",ONCONAM,!"
        S DR(1,160,91)="D CC^ONCPAT1"
        S DR(1,160,92)="D ^ONCPL"
        S DR(1,160,93)="I $D(DIRUT) S Y=""@99"""
        S DR(1,160,94)="25    COMORBIDITY/COMPLICATION #1"
        S DR(1,160,95)="I X'="""" S Y=""@251"""
        S DR(1,160,96)="25.1////@"
        S DR(1,160,97)="25.2////@"
        S DR(1,160,98)="25.3////@"
        S DR(1,160,99)="25.4////@"
        S DR(1,160,100)="25.5////@"
        S DR(1,160,101)="25.6////@"
        S DR(1,160,102)="25.7////@"
        S DR(1,160,103)="25.8////@"
        S DR(1,160,104)="25.9////@"
        S DR(1,160,105)="D CC2^ONCPAT1"
        S DR(1,160,106)="S Y=""@99"""
        S DR(1,160,107)="@251"
        S DR(1,160,108)="25.1    COMORBIDITY/COMPLICATION #2"
        S DR(1,160,109)="I X'="""" S Y=""@252"""
        S DR(1,160,110)="25.2////@"
        S DR(1,160,111)="25.3////@"
        S DR(1,160,112)="25.4////@"
        S DR(1,160,113)="25.5////@"
        S DR(1,160,114)="25.6////@"
        S DR(1,160,115)="25.7////@"
        S DR(1,160,116)="25.8////@"
        S DR(1,160,117)="25.9////@"
        S DR(1,160,118)="D CC3^ONCPAT1"
        S DR(1,160,119)="S Y=""@99"""
        S DR(1,160,120)="@252"
        S DR(1,160,121)="25.2    COMORBIDITY/COMPLICATION #3"
        S DR(1,160,122)="I X'="""" S Y=""@253"""
        S DR(1,160,123)="25.3////@"
        S DR(1,160,124)="25.4////@"
        S DR(1,160,125)="25.5////@"
        S DR(1,160,126)="25.6////@"
        S DR(1,160,127)="25.7////@"
        S DR(1,160,128)="25.8////@"
        S DR(1,160,129)="25.9////@"
        S DR(1,160,130)="D CC4^ONCPAT1"
        S DR(1,160,131)="S Y=""@99"""
        S DR(1,160,132)="@253"
        S DR(1,160,133)="25.3    COMORBIDITY/COMPLICATION #4"
        S DR(1,160,134)="I X'="""" S Y=""@254"""
        S DR(1,160,135)="25.4////@"
        S DR(1,160,136)="25.5////@"
        S DR(1,160,137)="25.6////@"
        S DR(1,160,138)="25.7////@"
        S DR(1,160,139)="25.8////@"
        S DR(1,160,140)="25.9////@"
        S DR(1,160,141)="D CC5^ONCPAT1"
        S DR(1,160,142)="S Y=""@99"""
        S DR(1,160,143)="@254"
        S DR(1,160,144)="25.4    COMORBIDITY/COMPLICATION #5"
        S DR(1,160,145)="I X'="""" S Y=""@255"""
        S DR(1,160,146)="25.5////@"
        S DR(1,160,147)="25.6////@"
        S DR(1,160,148)="25.7////@"
        S DR(1,160,149)="25.8////@"
        S DR(1,160,150)="25.9////@"
        S DR(1,160,151)="D CC6^ONCPAT1"
        S DR(1,160,152)="S Y=""@99"""
        S DR(1,160,153)="@255"
        S DR(1,160,154)="25.5    COMORBIDITY/COMPLICATION #6"
        S DR(1,160,155)="I X'="""" S Y=""@256"""
        S DR(1,160,156)="25.6////@"
        S DR(1,160,157)="25.7////@"
        S DR(1,160,158)="25.8////@"
        S DR(1,160,159)="25.9////@"
        S DR(1,160,160)="D CC7^ONCPAT1"
        S DR(1,160,161)="S Y=""@99"""
        S DR(1,160,162)="@256"
        S DR(1,160,163)="25.6    COMORBIDITY/COMPLICATION #7"
        S DR(1,160,164)="I X'="""" S Y=""@257"""
        S DR(1,160,165)="25.7////@"
        S DR(1,160,166)="25.8////@"
        S DR(1,160,167)="25.9////@"
        S DR(1,160,168)="D CC8^ONCPAT1"
        S DR(1,160,169)="S Y=""@99"""
        S DR(1,160,170)="@257"
        S DR(1,160,171)="25.7    COMORBIDITY/COMPLICATION #8"
        S DR(1,160,172)="I X'="""" S Y=""@258"""
        S DR(1,160,173)="25.8////@"
        S DR(1,160,174)="25.9////@"
        S DR(1,160,175)="D CC9^ONCPAT1"
        S DR(1,160,176)="S Y=""@99"""
        S DR(1,160,177)="@258"
        S DR(1,160,178)="25.8    COMORBIDITY/COMPLICATION #9"
        S DR(1,160,179)="I X'="""" S Y=""@259"""
        S DR(1,160,180)="25.9////@"
        S DR(1,160,181)="D CC10^ONCPAT1"
        S DR(1,160,182)="S Y=""@99"""
        S DR(1,160,183)="@259"
        S DR(1,160,184)="25.9    COMORBIDITY/COMPLICATION #10"
        S DR(1,160,185)="@99"
        D ^DIE
        K AOE,DIE,DR,IRE,GSI,LSI,ONCODO,PGS,PSI,SS,VSI,YSI
        Q
