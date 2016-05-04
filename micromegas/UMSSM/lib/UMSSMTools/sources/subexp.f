      SUBROUTINE SUBEXP(PROB)

***********************************************************************
*   Subroutine to check experimental constraints
*
*   The required data files and numbers (inv. Z width, lower bounds on
*   sparticle masses) are transferred via COMMON/LEP/...
*
*   On output:
*      PROB(I)  = 0, I = 2 - 23, 38, 39, 41-45, 51-52: OK
*            
*      PROB(2) =/= 0   excluded by Z -> neutralinos
*      PROB(3) =/= 0   charged Higgs too light
*      PROB(4) =/= 0   excluded by ee -> hZ 
*      PROB(5) =/= 0   excluded by ee -> hZ, h -> bb
*      PROB(6) =/= 0   excluded by ee -> hZ, h -> tautau
*      PROB(7) =/= 0   excluded by ee -> hZ, h -> invisible 
*      PROB(8) =/= 0   excluded by ee -> hZ, h -> 2jets
*      PROB(9) =/= 0   excluded by ee -> hZ, h -> 2photons
*      PROB(10) =/= 0  excluded by ee -> hZ, h -> AA -> 4bs
*      PROB(11) =/= 0  excluded by ee -> hZ, h -> AA -> 4taus
*      PROB(12) =/= 0  excluded by ee -> hZ, h -> AA -> 2bs 2taus
*      PROB(13) =/= 0  excluded by Z -> hA (Z width)
*      PROB(14) =/= 0  excluded by ee -> hA -> 4bs
*      PROB(15) =/= 0  excluded by ee -> hA -> 4taus
*      PROB(16) =/= 0  excluded by ee -> hA -> 2bs 2taus
*      PROB(17) =/= 0  excluded by ee -> hA -> AAA -> 6bs
*      PROB(18) =/= 0  excluded by ee -> hA -> AAA -> 6taus
*      PROB(19) =/= 0  excluded by ee -> Zh -> ZAA -> Z + light pairs
*      PROB(20) =/= 0  excluded by stop -> b l sneutrino
*      PROB(21) =/= 0  excluded by stop -> neutralino c
*      PROB(22) =/= 0  excluded by sbottom -> neutralino b
*      PROB(23) =/= 0  squark/gluino too light
*      PROB(38) =/= 0  excluded by Upsilon(1S) -> A gamma
*      PROB(39) =/= 0  excluded by eta_b(1S) mass measurement
*      PROB(41) =/= 0  excluded by ee -> hZ, h -> AA -> 4taus (new ALEPH analysis)
*      PROB(42) =/= 0  excluded by top -> b H+, H+ -> c s (CDF, D0)
*      PROB(43) =/= 0  excluded by top -> b H+, H+ -> tau nu_tau (D0)
*      PROB(44) =/= 0  excluded by top -> b H+, H+ -> W+ A, A -> 2taus (CDF)
*      PROB(45) =/= 0  excluded by t -> bH+ (LHC)
*      PROB(51) =/= 0: excluded by H/A->tautau
*      PROB(52) =/= 0: Excluded H_125->AA->4mu (CMS)
*
***********************************************************************

      IMPLICIT NONE

      INTEGER I,J,K
      INTEGER NhZind,NhZbb,NhZll,NhZinv,NhZjj,NhZgg
      INTEGER NhA4b,NhA4tau,NhA2b2tau,NhA2tau2b
      INTEGER NAAA6b,NAAA6tau,NAAZ4b,NAAZ4tau,NAAZ2b2tau
      INTEGER Ncccc02,Ncccc04,Ncccc05,Ncccc06,Ncccc08,Ncccc1
      INTEGER Nccgg02,Nccgg04,Nccgg05,Nccgg06,Nccgg08,Nccgg1
      INTEGER Ncctt02,Ncctt04,Ncctt05,Ncctt06,Ncctt08,Ncctt1
      INTEGER Ngggg02,Ngggg04,Ngggg05,Ngggg06,Ngggg08,Ngggg1
      INTEGER Nttgg02,Nttgg04,Nttgg05,Nttgg06,Nttgg08,Nttgg1
      INTEGER Ntttt02,Ntttt04,Ntttt05,Ntttt06,Ntttt08,Ntttt1
      INTEGER Nstblsn,Nstnc,Nsbnb,Nglsq

      DOUBLE PRECISION PROB(*),PI,S,SQRS,SQR2,CONV
      DOUBLE PRECISION MGL,MCH(2),U(2,2),V(2,2),MNEU(6),NEU(6,6)
      DOUBLE PRECISION SMASS(3),SCOMP(3,3),PMASS,PCOMP(3,3),CMASS
      DOUBLE PRECISION BRJJ(4),BREE(4),BRMM(4),BRLL(4),BRSS(4),BRCC(4)
      DOUBLE PRECISION BRBB(4),BRTT(4),BRWW(3),BRZZ(3),BRGG(4)
      DOUBLE PRECISION BRZG(4),BRHHH(4),BRHAA(3),BRHCHC(3)
      DOUBLE PRECISION BRHAZ(3),BRAHZ(3),BRHCW(4)
      DOUBLE PRECISION BRHIGGS(4),BRNEU(4,6,6),BRCHA(4,3)
      DOUBLE PRECISION BRHSQ(3,10),BRHSL(3,9),BRASQ(2),BRASL
      DOUBLE PRECISION BRSUSY(4),WIDTH(4),MBQM
      DOUBLE PRECISION brtopbw,brtopbh,brtopneutrstop(6,2)
      DOUBLE PRECISION brtopcs,brtoplim,brtoptau,brtopa1
      DOUBLE PRECISION minf(9),msup(9),binf(9),bsup(9)
      DOUBLE PRECISION mh4m(4),mh4p(4),br4m(4),br4p(4),brtau(8)
      DOUBLE PRECISION mh7(5),br7(5),br9(5)
      DOUBLE PRECISION HCBRM,HCBRL,HCBRSU,HCBRBU,HCBRSC,HCBRBC
      DOUBLE PRECISION HCBRBT,HCBRWH(5),HCBRWHT,HCBRNC(5,2)
      DOUBLE PRECISION HCBRSQ(5),HCBRSL(3),HCBRSUSY,HCWIDTH
      DOUBLE PRECISION MH,MA,h1,h2,R,Rmax,BRINV,M1,M2
      DOUBLE PRECISION GZ,GZMAX,ALSMZ,ALEMMZ,GF,g1,g2,S2TW,g
      DOUBLE PRECISION GZINV,GZINVMAX,MCMIN,SIGNEU1,SIGNEU
      DOUBLE PRECISION MSQMIN,MGLMIN,MMIN
      DOUBLE PRECISION MS,MC,MB,MBP,MT,MTAU,MMUON,MZ,MW
      DOUBLE PRECISION LAMBDA,X,Y,Z,Q,O,DZ,E1,E2,SIG
      DOUBLE PRECISION MUR,MUL,MDR,MDL,MLR,MLL,MNL
      DOUBLE PRECISION MST1,MST2,MSB1,MSB2,MSL1,MSL2,MSNT
      DOUBLE PRECISION CST,CSB,CSL,MSMU1,MSMU2,MSMUNT,CSMU,MAtest,ceff
      DOUBLE PRECISION hZind(1000,2),hZbb(1000,2),hZll(1000,2)
      DOUBLE PRECISION hZinv(1000,2),hZjj(1000,2),hZgg(1000,2)
      DOUBLE PRECISION hA4b(10000,3),hA4tau(10000,3)
      DOUBLE PRECISION hA2b2tau(10000,3),hA2tau2b(10000,3)
      DOUBLE PRECISION AAA6b(10000,3),AAA6tau(10000,3)
      DOUBLE PRECISION AAZ4b(10000,3),AAZ4tau(10000,3)
      DOUBLE PRECISION AAZ2b2tau(10000,3)
      DOUBLE PRECISION cccc02(100,2),cccc04(100,2),cccc05(100,2)
      DOUBLE PRECISION cccc06(100,2),cccc08(100,2),cccc1(100,2)
      DOUBLE PRECISION ccgg02(100,2),ccgg04(100,2),ccgg05(100,2)
      DOUBLE PRECISION ccgg06(100,2),ccgg08(100,2),ccgg1(100,2)
      DOUBLE PRECISION cctt02(100,2),cctt04(100,2),cctt05(100,2)
      DOUBLE PRECISION cctt06(100,2),cctt08(100,2),cctt1(100,2)
      DOUBLE PRECISION gggg02(100,2),gggg04(100,2),gggg05(100,2)
      DOUBLE PRECISION gggg06(100,2),gggg08(100,2),gggg1(100,2)
      DOUBLE PRECISION ttgg02(100,2),ttgg04(100,2),ttgg05(100,2)
      DOUBLE PRECISION ttgg06(100,2),ttgg08(100,2),ttgg1(100,2)
      DOUBLE PRECISION tttt02(100,2),tttt04(100,2),tttt05(100,2)
      DOUBLE PRECISION tttt06(100,2),tttt08(100,2),tttt1(100,2)
      DOUBLE PRECISION stblsn(100,2),stnc(100,2),sbnb(100,2)
      DOUBLE PRECISION glsq(100,2)
      DOUBLE PRECISION ALEM0,MY,BRYMUMU,C,ZZ,AP,GYEE
      DOUBLE PRECISION ALPHAS,ALSMY,DELTA,CLEOTAU,CLEOMU
      DOUBLE PRECISION M0,RETA,GAM2,XX,YY,F,YMAX,FMAX,D,MEMAX,UU,VV
      DOUBLE PRECISION CU(4),CD(4),CV(3),CVZ(3),CJ(4),CG(4),CB(4)
      DOUBLE PRECISION XIN(6),HM1(6),HM2(6),HM3(6),HM4(6),HM5(6)
      DOUBLE PRECISION DMA,HMIN,HMAX
      DOUBLE PRECISION UPARF,SAZZ,CAZZ,VEV,NCP,VEVS,G1P
      DOUBLE PRECISION QD,QU,QS,QQ,QUP,QDOW,QL,QE,QN
      DOUBLE PRECISION AAT,AAB,Mch2,SST,SSB
      DOUBLE PRECISION TANBETA,SINBETA,COSBETA,LDA,AL,ATAU

      DATA XIN/.2D0,.25D0,.4D0,.5D0,.7D0,1D0/
      DATA HM1/70D0,94D0,99.7D0,102.3D0,105.2D0,108.4D0/
      DATA HM2/70D0,93D0,98.6D0,101.6D0,105D0,108D0/
      DATA HM3/70D0,92.3D0,98.3D0,100.3D0,104.6D0,107.6D0/
      DATA HM4/70D0,90.8D0,98D0,100.1D0,104D0,107D0/
      DATA HM5/70D0,86.7D0,97D0,99D0,103.5D0,106D0/
      DATA minf/60d0,70d0,80d0,100d0,110d0,120d0,130d0,140d0,150d0/
      DATA msup/70d0,80d0,100d0,110d0,120d0,130d0,140d0,150d0,155d0/
      DATA binf/.09d0,0d0,.21d0,.21d0,.15d0,.12d0,.08d0,.1d0,.20d0/
      DATA bsup/.12d0,0d0,.21d0,.15d0,.12d0,.08d0,.1d0,.13d0,.19d0/
      DATA mh4m/85d0,90d0,100d0,120d0/
      DATA mh4p/90d0,100d0,120d0,140d0/
      DATA br4m/.5d0,.33d0,.27d0,.35d0/
      DATA br4p/.33d0,.27d0,.35d0,.52d0/
      DATA mh7/90d0,100d0,120d0,140d0,160d0/
      DATA br7/.13d0,.1d0,.13d0,.2d0,.3d0/
      DATA br9/.11d0,.08d0,.09d0,.14d0,.21d0/
      DATA brtau/.16d0,.15d0,.16,.17d0,.175,.18d0,.19d0,.18d0/

      COMMON/ALEM0/ALEM0
      COMMON/GAUGE/ALSMZ,ALEMMZ,GF,g1,g2,S2TW
      COMMON/SMSPEC/MS,MC,MB,MBP,MT,MTAU,MMUON,MZ,MW
      COMMON/SUSYSPEC/MGL,MCH,U,V,MNEU,NEU
      COMMON/HIGGSPEC/SMASS,SCOMP,PMASS,PCOMP,CMASS
      COMMON/SFSPEC/MUR,MUL,MDR,MDL,MLR,MLL,MNL,
     .      MST1,MST2,MSB1,MSB2,MSL1,MSL2,MSNT,
     .      CST,CSB,CSL,MSMU1,MSMU2,MSMUNT,CSMU
      COMMON/BRN/BRJJ,BREE,BRMM,BRLL,BRSS,BRCC,BRBB,BRTT,BRWW,BRZZ,
     .      BRGG,BRZG,BRHHH,BRHAA,BRHCHC,BRHAZ,BRAHZ,
     .      BRHCW,BRHIGGS,BRNEU,BRCHA,BRHSQ,BRHSL,BRASQ,BRASL,
     .      BRSUSY,WIDTH
      COMMON/BRC/HCBRM,HCBRL,HCBRSU,HCBRBU,HCBRSC,HCBRBC,
     . HCBRBT,HCBRWH,HCBRWHT,HCBRNC,HCBRSQ,HCBRSL,
     . HCBRSUSY,HCWIDTH
      COMMON/BR_top2body/brtopbw,brtopbh,brtopneutrstop
      COMMON/LEP/GZMAX,GZINVMAX,MCMIN,SIGNEU1,SIGNEU,
     .      MSQMIN,MGLMIN,
     .      hZind,hZbb,hZll,hZinv,hZjj,hZgg,
     .      hA4b,hA4tau,hA2b2tau,hA2tau2b,
     .      AAA6b,AAA6tau,AAZ4b,AAZ4tau,AAZ2b2tau,
     .      cccc02,cccc04,cccc05,cccc06,cccc08,cccc1,
     .      ccgg02,ccgg04,ccgg05,ccgg06,ccgg08,ccgg1,
     .      cctt02,cctt04,cctt05,cctt06,cctt08,cctt1,
     .      gggg02,gggg04,gggg05,gggg06,gggg08,gggg1,
     .      ttgg02,ttgg04,ttgg05,ttgg06,ttgg08,ttgg1,
     .      tttt02,tttt04,tttt05,tttt06,tttt08,tttt1,
     .      stblsn,stnc,sbnb,glsq,
     .      NhZind,NhZbb,NhZll,NhZinv,NhZjj,NhZgg,
     .      NhA4b,NhA4tau,NhA2b2tau,NhA2tau2b,
     .      NAAA6b,NAAA6tau,NAAZ4b,NAAZ4tau,NAAZ2b2tau,
     .      Ncccc02,Ncccc04,Ncccc05,Ncccc06,Ncccc08,Ncccc1,
     .      Nccgg02,Nccgg04,Nccgg05,Nccgg06,Nccgg08,Nccgg1,
     .      Ncctt02,Ncctt04,Ncctt05,Ncctt06,Ncctt08,Ncctt1,
     .      Ngggg02,Ngggg04,Ngggg05,Ngggg06,Ngggg08,Ngggg1,
     .      Nttgg02,Nttgg04,Nttgg05,Nttgg06,Nttgg08,Nttgg1,
     .      Ntttt02,Ntttt04,Ntttt05,Ntttt06,Ntttt08,Ntttt1,
     .      Nstblsn,Nstnc,Nsbnb,Nglsq
      COMMON/REDCOUP/CU,CD,CV,CVZ,CJ,CG,CB
      COMMON/UMSSM/SAZZ,CAZZ,VEV,NCP,QD,QU,QS,VEVS,G1P,QQ,
     .      QUP,QDOW,QL,QE,QN
      COMMON/NOBUG/TANBETA,AAT,AAB,Mch2,SST,SSB,LDA,AL,ATAU

      LAMBDA(X,Y,Z)= DSQRT(X**2+Y**2+Z**2-2d0*X*Y-2d0*X*Z-2d0*Y*Z)

      PI=4d0*DATAN(1d0)
      SQR2=DSQRT(2d0)
      SQRS=209d0
      S=SQRS**2
      CONV=.3894D9
      g=(g1+g2)/2d0
      COSBETA=1.D0/DSQRT(1.D0+TANBETA**2)
      SINBETA=TANBETA*COSBETA
      h2=1d0/DSQRT(2d0*DSQRT(2d0)*(1d0+TANBETA**2)*GF)
      h1=h2*TANBETA

* Test on stop -> b l sneutrino

      I=1
      DOWHILE(stblsn(I,1).LE.MST1 .AND. I.LT.Nstblsn)
       I=I+1
      ENDDO
      IF(I.GT.1 .AND. MST1.LT.stblsn(Nstblsn,1))THEN
       MMIN=stblsn(I-1,2)+(MST1-stblsn(I-1,1))
     .  /(stblsn(I,1)-stblsn(I-1,1))*(stblsn(I,2)-stblsn(I-1,2))
       PROB(20)=DDIM(1d0,MNL/MMIN)
      ENDIF

* Test on stop -> neutralino c

      I=1
      DOWHILE(stnc(I,1).LE.DABS(MNEU(1)) .AND. I.LT.Nstnc)
       I=I+1
      ENDDO
      IF(I.GT.1 .AND. DABS(MNEU(1)).LT.stnc(Nstnc,1))THEN
       MMIN=stnc(I-1,2)+(DABS(MNEU(1))-stnc(I-1,1))
     .  /(stnc(I,1)-stnc(I-1,1))*(stnc(I,2)-stnc(I-1,2))
       PROB(21)=DDIM(1d0,MST1/MMIN)
      ENDIF

* Test on sbottom -> neutralino b

      I=1
      DOWHILE(sbnb(I,1).LE.MSB1 .AND. I.LT.Nsbnb)
       I=I+1
      ENDDO
      IF(I.GT.1 .AND. MSB1.LT.sbnb(Nsbnb,1))THEN
       MMIN=sbnb(I-1,2)+(MSB1-sbnb(I-1,1))/(sbnb(I,1)-sbnb(I-1,1))
     .  *(sbnb(I,2)-sbnb(I-1,2))
       PROB(22)=DDIM(1d0,DABS(MNEU(1))/MMIN)
      ENDIF

* Test on gluino/squark masses

      I=1
      DOWHILE(glsq(I,1).LE.DABS(MGL) .AND. I.LT.Nglsq)
       I=I+1
      ENDDO
      MMIN=MSQMIN
      IF(I.GT.1 .AND. DABS(MGL).LT.glsq(Nglsq,1))THEN
       MMIN=glsq(I-1,2)+(DABS(MGL)-glsq(I-1,1))
     .  /(glsq(I,1)-glsq(I-1,1))*(glsq(I,2)-glsq(I-1,2))
      ENDIF
      PROB(23)=DDIM(1d0,MIN(MUR,MUL,MDR,MDL)/MMIN)
     .       +DDIM(1d0,DABS(MGL)/MGLMIN)

* Test on Z1 width into neutralinos

      IF(DABS(MNEU(1)).LT.MZ/2d0)THEN
       GZINV=MZ**3*GF/(12d0*DSQRT(2d0)*PI)
     .     *(CAZZ*(NEU(1,3)**2-NEU(1,4)**2)
     .     +2*DSQRT(S2TW)*NCP*SAZZ
     .     *(QD*NEU(1,3)**2+QU*NEU(1,4)**2+QS*NEU(1,5)**2))**2
     .     *(1d0-4*MNEU(1)**2/MZ**2)**1.5
        PROB(2)=DDIM(GZINV/GZINVMAX,1d0)
      ENDIF

* Test on neutralinos

      DZ = 1d0/(S-MZ**2)**2
      DO I=1,6
       DO J=I,6
        IF(DABS(MNEU(I))+DABS(MNEU(J)).LT.SQRS)THEN
         O= (CAZZ*NEU(I,3)*NEU(J,3)-CAZZ*NEU(I,4)*NEU(J,4)
     .     +2*DSQRT(S2TW)*NCP*SAZZ
     .     *(QD*NEU(I,3)*NEU(J,3)+QU*NEU(I,4)*NEU(J,4)
     .     +QS*NEU(I,5)*NEU(J,5)))
         E1= (S+MNEU(I)**2-MNEU(J)**2)/(2d0*SQRS)
         E2= (S+MNEU(J)**2-MNEU(I)**2)/(2d0*SQRS)
         Q= LAMBDA(S,MNEU(I)**2,MNEU(J)**2)/(2d0*SQRS)
         SIG= 1d0/(4d0*PI)*Q/SQRS*DZ*(E1*E2+Q**2/3d0
     .       -MNEU(I)*MNEU(J))* g**2*O**2*(.25d0-S2TW+2d0*S2TW**2)
         SIG= CONV*SIG
         IF(I.EQ.J)SIG= SIG/2d0
         IF(I.EQ.1)THEN
          IF(J.GT.1)PROB(2)=PROB(2)+DDIM(SIG/SIGNEU1,1d0)
         ELSE
          PROB(2)=PROB(2)+DDIM(SIG/SIGNEU,1d0)
         ENDIF
        ENDIF
       ENDDO
      ENDDO

* Test on charged Higgs mass

       PROB(3)=DDIM(1d0,CMASS/MCMIN)
      
* Light A Physics

      MA=PMASS

* Test on Upsilon(1S) -> A gamma (from CLEO)

      MY=9.46d0 ! Upsilon(1S) mass
      MBQM=4.9d0 ! b quark mass in quark models
      ALSMY=ALPHAS(MY,2) ! alpha_s at MY, 2 loop calculation
      BRYMUMU=2.48D-2 ! BR(Upsilon(1S) -> mu mu)

      IF(MA.LT.MY)THEN

      ZZ=1d0-MA**2/MY**2 ! energy fraction of the photon
      AP=6d0*ZZ**.2d0 ! Nason function for QCD corrections
      C=1d0+4d0*ALSMY/(3d0*PI)*(4d0-AP) ! QCD corrections
      DELTA=1.2d0**2/MBQM**2 ! function for rel. corrections
      C=C* ! relativistic corrections (for MA<~8.8 GeV)
     .  (MY**2-MA**2)**2/(4d0*MBQM**2-MA**2)**2*(1d0-
     .  DELTA/3d0*(36d0*MBQM**2+MA**2)/(4d0*MBQM**2-MA**2))

      C=MAX(C,1.D-6)

      RMAX=0d0
      RMAX=SQR2*PI*ALEM0*CLEOTAU(MA)/(GF*MBQM**2*ZZ*C*BRYMUMU)
      IF(RMAX.NE.0d0)PROB(38)=DDIM(CB(4)**2*BRLL(4)/RMAX,1d0)

      RMAX=0d0
      RMAX=SQR2*PI*ALEM0*CLEOMU(MA)/(GF*MBQM**2*ZZ*C*BRYMUMU)
      IF(RMAX.NE.0d0)PROB(38)=DDIM(CB(4)**2*BRMM(4)/RMAX,1d0)

      IF(WIDTH(4).GT.1.D-2)PROB(38)=-PROB(38)

      ENDIF

* Test on etab(1S) mass difference (BABAR - theory)

      M0=9.389d0 ! etab(1S) mass
      GYEE=1.34D-6 ! Gamma(Upsilon(1S) -> e+ e-)
      RETA=GYEE*9d0*MY**2/(4d0*ALEM0**2)*
     .  (1d0+16d0*ALSMY/(3d0*PI)) ! radial wave fun. at the origin
       ! Resolution of the 3rd degree eq. for the limit on Xd
      GAM2=(M0*2.D-2)**2
      XX=MA**2-M0**2

      IF(MA.LT.M0)THEN
       MEMAX=M0-3.D-2
      ELSE
       MEMAX=M0+4.D-2
      ENDIF
      YMAX=MEMAX**2-M0**2
      FMAX=XX*YMAX*(1d0+GAM2/(XX+YMAX)**2)

      D=XX**2-GAM2/27d0
      IF(D.LT.0d0)THEN
       UU=2d0*DSQRT(GAM2)/DSQRT(3d0)
       VV=-3d0*DSQRT(3d0)*XX/DSQRT(GAM2)
       YY=UU*DCOS(DACOS(VV)/3d0 + 4d0*PI/3d0)
       F=XX*YY*(1d0+GAM2/(XX+YY)**2)
       FMAX=MAX(FMAX,F)
      ENDIF

      RMAX=8d0*PI*MZ**2/(3d0*g*RETA*M0**3)*FMAX
      PROB(39)=DDIM(CB(4)**2/RMAX,1d0)

* Higgs Strahlung

      DO I=1,3

      IF(I.GT.1 .AND. DABS(SMASS(I)-SMASS(I-1)).LT.3d0)THEN
       MH=SMASS(I-1)
       R=R+CVZ(I)**2
      ELSE
       MH=SMASS(I)
       R=CVZ(I)**2
      ENDIF

      IF(MH+MZ.LT.SQRS)THEN

*  ee -> hZ flavor independent

       Rmax=1d0
       J=1
       DOWHILE(hZind(J,1).LE.MH .AND. J.LT.NhZind)
        J=J+1
       ENDDO
       IF(J.GT.1 .AND. MH.LT.hZind(NhZind,1))
     .    Rmax=hZind(J-1,2)+(MH-hZind(J-1,1))/(hZind(J,1)
     .       -hZind(J-1,1))*(hZind(J,2)-hZind(J-1,2))
       PROB(4)=PROB(4)+DDIM(R/Rmax,1d0)

*  ee -> hZ, h -> bb

       Rmax=1d0
       J=1
       DOWHILE(hZbb(J,1).LE.MH .AND. J.LT.NhZbb)
        J=J+1
       ENDDO
       IF(J.GT.1 .AND. MH.LT.hZbb(NhZbb,1))
     .    Rmax=hZbb(J-1,2)+(MH-hZbb(J-1,1))/(hZbb(J,1)-hZbb(J-1,1))
     .       *(hZbb(J,2)-hZbb(J-1,2))
       PROB(5)=PROB(5)+DDIM(R*BRBB(I)/Rmax,1d0)

*  ee -> hZ, h -> tautau

       Rmax=1d0
       J=1
       DOWHILE(hZll(J,1).LE.MH .AND. J.LT.NhZll)
        J=J+1
       ENDDO
       IF(J.GT.1 .AND. MH.LT.hZll(NhZll,1))
     .    Rmax=hZll(J-1,2)+(MH-hZll(J-1,1))/(hZll(J,1)-hZll(J-1,1))
     .       *(hZll(J,2)-hZll(J-1,2))
       PROB(6)=PROB(6)+DDIM(R*BRLL(I)/Rmax,1d0)

*  ee -> hZ, h -> invisible
*  To change for UMSSM, by including RH sneutrino
*  but negligible impact on parameter space

       Rmax=1d0
       J=1
       DOWHILE(hZinv(J,1).LE.MH .AND. J.LT.NhZinv)
        J=J+1
       ENDDO
       IF(J.GT.1 .AND. MH.LT.hZinv(NhZinv,1))
     .    Rmax=hZinv(J-1,2)+(MH-hZinv(J-1,1))/(hZinv(J,1)-hZinv(J-1,1))
     .       *(hZinv(J,2)-hZinv(J-1,2))
       BRINV=BRNEU(I,1,1)
     .  +BRHAA(I)*BRNEU(4,1,1)**2
       IF(I.EQ.2)
     .  BRINV=BRINV+BRHHH(1)*BRNEU(1,1,1)**2
       IF(I.EQ.3)
     .  BRINV=BRINV+BRHHH(2)*BRNEU(1,1,1)**2
     .   +BRHHH(3)*BRNEU(1,1,1)*BRNEU(2,1,1)
     .   +BRHHH(4)*BRNEU(2,1,1)**2
       PROB(7)=PROB(7)+DDIM(R*BRINV/Rmax,1d0)

*  ee -> hZ, h -> 2jets

       Rmax=1d0
       J=1
       DOWHILE(hZjj(J,1).LE.MH .AND. J.LT.NhZjj)
        J=J+1
       ENDDO
       IF(J.GT.1 .AND. MH.LT.hZjj(NhZjj,1))
     .    Rmax=hZjj(J-1,2)+(MH-hZjj(J-1,1))/(hZjj(J,1)-hZjj(J-1,1))
     .       *(hZjj(J,2)-hZjj(J-1,2))
       PROB(8)=PROB(8)
     .       +DDIM(R*(BRJJ(I)+BRSS(I)+BRCC(I)+BRBB(I))/Rmax,1d0)

*  ee -> hZ, h -> 2photons

       Rmax=1d0
       J=1
       DOWHILE(hZgg(J,1).LE.MH .AND. J.LT.NhZgg)
        J=J+1
       ENDDO
       IF(J.GT.1 .AND. MH.LT.hZgg(NhZgg,1))
     .    Rmax=hZgg(J-1,2)+(MH-hZgg(J-1,1))/(hZgg(J,1)-hZgg(J-1,1))
     .       *(hZgg(J,2)-hZgg(J-1,2))
       PROB(9)=PROB(9)+DDIM(R*BRGG(I)/Rmax,1d0)

*  ee -> hZ, h -> AA -> 4bs

       MA=PMASS
       IF(MH.GT.2d0*MA)THEN
        Rmax=1d0
        DO K=1,NAAZ4b
         IF(AINT(MH).EQ.AAZ4b(K,1) .AND. AINT(MA).EQ.AAZ4b(K,2))THEN
          Rmax=AAZ4b(K,3)
          GOTO 1
         ENDIF
        ENDDO
 1      PROB(10)=PROB(10)+DDIM(R*BRHAA(I)*BRBB(4)**2/Rmax,1d0)
       ENDIF

       MA=SMASS(1)
       IF(MH.GT.2d0*MA)THEN
        Rmax=1d0
        DO K=1,NAAZ4b
         IF(AINT(MH).EQ.AAZ4b(K,1) .AND. AINT(MA).EQ.AAZ4b(K,2))THEN
          Rmax=AAZ4b(K,3)
          GOTO 2
         ENDIF
        ENDDO
 2      PROB(10)=PROB(10)+DDIM(R*BRHHH(I-1)*BRBB(1)**2/Rmax,1d0)
       ENDIF

*  ee -> hZ, h -> AA -> 4taus

       MA=PMASS
       IF(MH.GT.2d0*MA)THEN
        Rmax=1d0
        DO K=1,NAAZ4tau
         IF(AINT(MH).EQ.AAZ4tau(K,1) .AND.
     .     AINT(MA).EQ.AAZ4tau(K,2))THEN
          Rmax=AAZ4tau(K,3)
          GOTO 11
         ENDIF
        ENDDO
* Apply only for MA < 9.4GeV where A <-> eta_b mixing is absent:
 11     IF(MA.LE.9.4D0) 
     . PROB(11)=PROB(11)+DDIM(R*BRHAA(I)*BRLL(4)**2/Rmax,1d0)
       ENDIF

       MA=SMASS(1)
       IF(MH.GT.2d0*MA)THEN
        Rmax=1d0
        DO K=1,NAAZ4tau
         IF(AINT(MH).EQ.AAZ4tau(K,1) .AND.
     .     AINT(MA).EQ.AAZ4tau(K,2))THEN
          Rmax=AAZ4tau(K,3)
          GOTO 12
         ENDIF
        ENDDO
 12     PROB(11)=PROB(11)+DDIM(R*BRHHH(I-1)*BRLL(1)**2/Rmax,1d0)
       ENDIF

*  ee -> hZ, h -> AA -> 4taus (new ALEPH analysis)

       MA=PMASS
       RMAX=1.D0
       IF(MH.GE.70D0)THEN
        IF(MA.GE.4D0.AND.MA.LT.6D0)THEN
      	 DMA=(6D0-MA)/2D0
      	 K=0
 991     K=K+1
      	 HMIN=HM2(K)+(HM1(K)-HM2(K))*DMA
      	 HMAX=HM2(K+1)+(HM1(K+1)-HM2(K+1))*DMA
      	 IF(MH.LE.HMAX)THEN
      	  RMAX=XIN(K)+(XIN(K+1)-XIN(K))*(MH-HMIN)/(HMAX-HMIN)
      	 ELSEIF(K.LT.5)THEN
          GOTO 991
         ENDIF
        ELSEIF(MA.GE.6D0.AND.MA.LT.8D0)THEN
         DMA=(8D0-MA)/2D0
       	 K=0
 992     K=K+1
         HMIN=HM3(K)+(HM2(K)-HM3(K))*DMA
      	 HMAX=HM3(K+1)+(HM2(K+1)-HM3(K+1))*DMA
      	 IF(MH.LE.HMAX)THEN
      	  RMAX=XIN(K)+(XIN(K+1)-XIN(K))*(MH-HMIN)/(HMAX-HMIN)
      	 ELSEIF(K.LT.5)THEN
          GOTO 992
         ENDIF
        ELSEIF(MA.GE.8D0.AND.MA.LT.10D0)THEN
       	 DMA=(10D0-MA)/2D0
       	 K=0
 993     K=K+1
      	 HMIN=HM4(K)+(HM3(K)-HM4(K))*DMA
      	 HMAX=HM4(K+1)+(HM3(K+1)-HM4(K+1))*DMA
      	 IF(MH.LE.HMAX)THEN
      	  RMAX=XIN(K)+(XIN(K+1)-XIN(K))*(MH-HMIN)/(HMAX-HMIN)
      	 ELSEIF(K.LT.5)THEN
          GOTO 993
         ENDIF
        ELSEIF(MA.GE.10D0.AND.MA.LE.12D0)THEN
       	 DMA=(12D0-MA)/2D0
         K=0
 994     K=K+1
      	 HMIN=HM5(K)+(HM4(K)-HM5(K))*DMA
      	 HMAX=HM5(K+1)+(HM4(K+1)-HM5(K+1))*DMA
      	 IF(MH.LE.HMAX)THEN
      	  RMAX=XIN(K)+(XIN(K+1)-XIN(K))*(MH-HMIN)/(HMAX-HMIN)
      	 ELSEIF(K.LT.5)THEN
          GOTO 994
         ENDIF
        ENDIF
       ENDIF
* Apply only for MA < 9.4GeV where A <-> eta_b mixing is absent:
       IF(MA.LE.9.4D0) 
     .   PROB(41)=PROB(41)+DDIM(R*BRHAA(I)*BRLL(4)**2/Rmax,1d0)

       MA=SMASS(1)
       RMAX=1.D0
       IF(MH.GE.70D0)THEN
        IF(MA.GE.4D0.AND.MA.LT.6D0)THEN
      	 DMA=(6D0-MA)/2D0
      	 K=0
 995     K=K+1
      	 HMIN=HM2(K)+(HM1(K)-HM2(K))*DMA
      	 HMAX=HM2(K+1)+(HM1(K+1)-HM2(K+1))*DMA
      	 IF(MH.LE.HMAX)THEN
      	  RMAX=XIN(K)+(XIN(K+1)-XIN(K))*(MH-HMIN)/(HMAX-HMIN)
      	 ELSEIF(K.LT.5)THEN
          GOTO 995
         ENDIF
        ELSEIF(MA.GE.6D0.AND.MA.LT.8D0)THEN
      	 DMA=(8D0-MA)/2D0
      	 K=0
 996     K=K+1
      	 HMIN=HM3(K)+(HM2(K)-HM3(K))*DMA
      	 HMAX=HM3(K+1)+(HM2(K+1)-HM3(K+1))*DMA
      	 IF(MH.LE.HMAX)THEN
      	  RMAX=XIN(K)+(XIN(K+1)-XIN(K))*(MH-HMIN)/(HMAX-HMIN)
      	 ELSEIF(K.LT.5)THEN
          GOTO 996
         ENDIF
        ELSEIF(MA.GE.8D0.AND.MA.LT.10D0)THEN
      	 DMA=(10D0-MA)/2D0
      	 K=0
 997     K=K+1
      	 HMIN=HM4(K)+(HM3(K)-HM4(K))*DMA
      	 HMAX=HM4(K+1)+(HM3(K+1)-HM4(K+1))*DMA
      	 IF(MH.LE.HMAX)THEN
      	  RMAX=XIN(K)+(XIN(K+1)-XIN(K))*(MH-HMIN)/(HMAX-HMIN)
      	 ELSEIF(K.LT.5)THEN
          GOTO 997
         ENDIF
        ELSEIF(MA.GE.10D0.AND.MA.LE.12D0)THEN
      	 DMA=(12D0-MA)/2D0
      	 K=0
 998     K=K+1
      	 HMIN=HM5(K)+(HM4(K)-HM5(K))*DMA
      	 HMAX=HM5(K+1)+(HM4(K+1)-HM5(K+1))*DMA
      	 IF(MH.LE.HMAX)THEN
      	  RMAX=XIN(K)+(XIN(K+1)-XIN(K))*(MH-HMIN)/(HMAX-HMIN)
      	 ELSEIF(K.LT.5)THEN
          GOTO 998
         ENDIF
        ENDIF
       ENDIF
       PROB(41)=PROB(41)+DDIM(R*BRHHH(I-1)*BRLL(1)**2/Rmax,1d0)

*  ee -> hZ, h -> AA -> 2bs 2taus

       MA=PMASS
       IF(MH.GT.2d0*MA)THEN
        Rmax=1d0
        DO K=1,NAAZ2b2tau
         IF(AINT(MH).EQ.AAZ2b2tau(K,1) .AND.
     .     AINT(MA).EQ.AAZ2b2tau(K,2))THEN
          Rmax=AAZ2b2tau(K,3)
          GOTO 21
         ENDIF
        ENDDO
* Apply only for MA < 9.4GeV or MA > 10.5GeV without A <-> eta_b mixing:
 21    IF(MA.LE.9.4D0.OR.MA.GE.10.5D0) 
     .   PROB(12)=PROB(12)
     .   +DDIM(R*BRHAA(I)*2d0*BRLL(4)*BRBB(4)/Rmax,1d0)
       ENDIF

       MA=SMASS(1)
       IF(MH.GT.2d0*MA)THEN
        Rmax=1d0
        DO K=1,NAAZ2b2tau
         IF(AINT(MH).EQ.AAZ2b2tau(K,1) .AND.
     .     AINT(MA).EQ.AAZ2b2tau(K,2))THEN
          Rmax=AAZ2b2tau(K,3)
          GOTO 22
         ENDIF
        ENDDO
 22     PROB(12)=PROB(12)
     .   +DDIM(R*BRHHH(I-1)*2d0*BRBB(1)*BRLL(1)/Rmax,1d0)
       ENDIF

*  ee -> hZ -> AAZ -> Z + light pairs

       MA=PMASS
       IF(MH.LT.2d0*MA .OR. MH.LT.40d0 .OR. MH.GT.90d0
     .   .OR. MA.LT.2d0 .OR. MA.GT.12d0)GOTO 752

*      AA -> cccc

       ceff=R*BRHAA(I)*BRCC(4)**2
       IF(ceff.GE.0.0.AND.ceff.LT.0.2)GOTO 102
       IF(ceff.GE.0.2.AND.ceff.LT.0.4)GOTO 202
       IF(ceff.GE.0.4.AND.ceff.LT.0.5)GOTO 302
       IF(ceff.GE.0.5.AND.ceff.LT.0.6)GOTO 402
       IF(ceff.GE.0.6.AND.ceff.LT.0.8)GOTO 502
       IF(ceff.GE.0.8.AND.ceff.LT.1.0)GOTO 602
       GOTO 702

 102   Rmax=.2d0
       J=1
       DOWHILE(cccc02(J,1).LE.MH .AND. J.LT.Ncccc02)
        J=J+1
       ENDDO
       MAtest=0d0
       IF(J.GT.1 .AND. MH.LT.cccc02(Ncccc02,1))
     .  MAtest=cccc02(J-1,2)+(MH-cccc02(J-1,1))/
     .   (cccc02(J,1)-cccc02(J-1,1))
     .   *(cccc02(J,2)-cccc02(J-1,2))
       PROB(19)=PROB(19)+5d0*(Rmax-ceff)*DDIM(MAtest/MA,1d0)
       GOTO 702

 202   Rmax=.4d0
       J=1
       DOWHILE(cccc04(J,1).LE.MH .AND. J.LT.Ncccc04)
        J=J+1
       ENDDO
       MAtest=0d0
       IF(J.GT.1 .AND. MH.LT.cccc04(Ncccc04,1))
     .  MAtest=cccc04(J-1,2)+(MH-cccc04(J-1,1))/
     .   (cccc04(J,1)-cccc04(J-1,1))
     .   *(cccc04(J,2)-cccc04(J-1,2))
       PROB(19)=PROB(19)+5d0*(Rmax-ceff)*DDIM(MAtest/MA,1d0)
       GOTO 702

 302   Rmax=.5d0
       J=1
       DOWHILE(cccc05(J,1).LE.MH .AND. J.LT.Ncccc05)
        J=J+1
       ENDDO
       MAtest=0d0
       IF(J.GT.1 .AND. MH.LT.cccc05(Ncccc05,1))
     .  MAtest=cccc05(J-1,2)+(MH-cccc05(J-1,1))/
     .   (cccc05(J,1)-cccc05(J-1,1))
     .   *(cccc05(J,2)-cccc05(J-1,2))
       PROB(19)=PROB(19)+10d0*(Rmax-ceff)*DDIM(MAtest/MA,1d0)
       GOTO 702

 402   Rmax=.6d0
       J=1
       DOWHILE(cccc06(J,1).LE.MH .AND. J.LT.Ncccc06)
        J=J+1
       ENDDO
       MAtest=0d0
       IF(J.GT.1 .AND. MH.LT.cccc06(Ncccc06,1))
     .  MAtest=cccc06(J-1,2)+(MH-cccc06(J-1,1))/
     .   (cccc06(J,1)-cccc06(J-1,1))
     .   *(cccc06(J,2)-cccc06(J-1,2))
       PROB(19)=PROB(19)+10d0*(Rmax-ceff)*DDIM(MAtest/MA,1d0)
       GOTO 702

 502   Rmax=.8d0
       J=1
       DOWHILE(cccc08(J,1).LE.MH .AND. J.LT.Ncccc08)
        J=J+1
       ENDDO
       MAtest=0d0
       IF(J.GT.1 .AND. MH.LT.cccc08(Ncccc08,1))
     .  MAtest=cccc08(J-1,2)+(MH-cccc08(J-1,1))/
     .   (cccc08(J,1)-cccc08(J-1,1))
     .   *(cccc08(J,2)-cccc08(J-1,2))
       PROB(19)=PROB(19)+5d0*(Rmax-ceff)*DDIM(MAtest/MA,1d0)
       GOTO 702

 602   Rmax=1d0
       J=1
       DOWHILE(cccc1(J,1).LE.MH .AND. J.LT.Ncccc1)
        J=J+1
       ENDDO
       MAtest=0d0
       IF(J.GT.1 .AND. MH.LT.cccc1(Ncccc1,1))
     .  MAtest=cccc1(J-1,2)+(MH-cccc1(J-1,1))/
     .   (cccc1(J,1)-cccc1(J-1,1))
     .   *(cccc1(J,2)-cccc1(J-1,2))
       PROB(19)=PROB(19)+5d0*(Rmax-ceff)*DDIM(MAtest/MA,1d0)

 702   CONTINUE

*      AA -> ccjj

       ceff=R*BRHAA(I)*BRCC(4)*(BRJJ(4)+BRSS(4))*2d0
       IF(ceff.GE.0.0.AND.ceff.LT.0.2)GOTO 112
       IF(ceff.GE.0.2.AND.ceff.LT.0.4)GOTO 212
       IF(ceff.GE.0.4.AND.ceff.LT.0.5)GOTO 312
       IF(ceff.GE.0.5.AND.ceff.LT.0.6)GOTO 412
       IF(ceff.GE.0.6.AND.ceff.LT.0.8)GOTO 512
       IF(ceff.GE.0.8.AND.ceff.LT.1.0)GOTO 612
       GOTO 712

 112   Rmax=.2d0
       J=1
       DOWHILE(ccgg02(J,1).LE.MH .AND. J.LT.Nccgg02)
        J=J+1
       ENDDO
       MAtest=0d0
       IF(J.GT.1 .AND. MH.LT.ccgg02(Nccgg02,1))
     .  MAtest=ccgg02(J-1,2)+(MH-ccgg02(J-1,1))/
     .   (ccgg02(J,1)-ccgg02(J-1,1))
     .   *(ccgg02(J,2)-ccgg02(J-1,2))
       PROB(19)=PROB(19)+5d0*(Rmax-ceff)*DDIM(MAtest/MA,1d0)
       GOTO 712

 212   Rmax=.4d0
       J=1
       DOWHILE(ccgg04(J,1).LE.MH .AND. J.LT.Nccgg04)
        J=J+1
       ENDDO
       MAtest=0d0
       IF(J.GT.1 .AND. MH.LT.ccgg04(Nccgg04,1))
     .  MAtest=ccgg04(J-1,2)+(MH-ccgg04(J-1,1))/
     .   (ccgg04(J,1)-ccgg04(J-1,1))
     .   *(ccgg04(J,2)-ccgg04(J-1,2))
       PROB(19)=PROB(19)+5d0*(Rmax-ceff)*DDIM(MAtest/MA,1d0)
       GOTO 712

 312   Rmax=.5d0
       J=1
       DOWHILE(ccgg05(J,1).LE.MH .AND. J.LT.Nccgg05)
        J=J+1
       ENDDO
       MAtest=0d0
       IF(J.GT.1 .AND. MH.LT.ccgg05(Nccgg05,1))
     .  MAtest=ccgg05(J-1,2)+(MH-ccgg05(J-1,1))/
     .   (ccgg05(J,1)-ccgg05(J-1,1))
     .   *(ccgg05(J,2)-ccgg05(J-1,2))
       PROB(19)=PROB(19)+10d0*(Rmax-ceff)*DDIM(MAtest/MA,1d0)
       GOTO 712

 412   Rmax=.6d0
       J=1
       DOWHILE(ccgg06(J,1).LE.MH .AND. J.LT.Nccgg06)
        J=J+1
       ENDDO
       MAtest=0d0
       IF(J.GT.1 .AND. MH.LT.ccgg06(Nccgg06,1))
     .    MAtest=ccgg06(J-1,2)+(MH-ccgg06(J-1,1))/
     .   (ccgg06(J,1)-ccgg06(J-1,1))
     .   *(ccgg06(J,2)-ccgg06(J-1,2))
       PROB(19)=PROB(19)+10d0*(Rmax-ceff)*DDIM(MAtest/MA,1d0)
       GOTO 712

 512   Rmax=.8d0
       J=1
       DOWHILE(ccgg08(J,1).LE.MH .AND. J.LT.Nccgg08)
        J=J+1
       ENDDO
       MAtest=0d0
       IF(J.GT.1 .AND. MH.LT.ccgg08(Nccgg08,1))
     .  MAtest=ccgg08(J-1,2)+(MH-ccgg08(J-1,1))/
     .   (ccgg08(J,1)-ccgg08(J-1,1))
     .   *(ccgg08(J,2)-ccgg08(J-1,2))
       PROB(19)=PROB(19)+5d0*(Rmax-ceff)*DDIM(MAtest/MA,1d0)
       GOTO 712

 612   Rmax=1d0
       J=1
       DOWHILE(ccgg1(J,1).LE.MH .AND. J.LT.Nccgg1)
        J=J+1
       ENDDO
       MAtest=0d0
       IF(J.GT.1 .AND. MH.LT.ccgg1(Nccgg1,1))
     .  MAtest=ccgg1(J-1,2)+(MH-ccgg1(J-1,1))/
     .   (ccgg1(J,1)-ccgg1(J-1,1))
     .   *(ccgg1(J,2)-ccgg1(J-1,2))
       PROB(19)=PROB(19)+5d0*(Rmax-ceff)*DDIM(MAtest/MA,1d0)
      
 712   CONTINUE

*      AA -> cctautau

       ceff=R*BRHAA(I)*BRCC(4)*BRLL(4)*2d0
       IF(ceff.GE.0.0.AND.ceff.LT.0.2)GOTO 122
       IF(ceff.GE.0.2.AND.ceff.LT.0.4)GOTO 222
       IF(ceff.GE.0.4.AND.ceff.LT.0.5)GOTO 322
       IF(ceff.GE.0.5.AND.ceff.LT.0.6)GOTO 422
       IF(ceff.GE.0.6.AND.ceff.LT.0.8)GOTO 522
       IF(ceff.GE.0.8.AND.ceff.LT.1.0)GOTO 622
       GOTO 722

 122   Rmax=.2d0
       J=1
       DOWHILE(cctt02(J,1).LE.MH .AND. J.LT.Ncctt02)
        J=J+1
       ENDDO
       MAtest=0d0
       IF(J.GT.1 .AND. MH.LT.cctt02(Ncctt02,1))
     .  MAtest=cctt02(J-1,2)+(MH-cctt02(J-1,1))/
     .   (cctt02(J,1)-cctt02(J-1,1))
     .   *(cctt02(J,2)-cctt02(J-1,2))
       PROB(19)=PROB(19)+5d0*(Rmax-ceff)*DDIM(MAtest/MA,1d0)
       GOTO 722

 222   Rmax=.4d0
       J=1
       DOWHILE(cctt04(J,1).LE.MH .AND. J.LT.Ncctt04)
        J=J+1
       ENDDO
       MAtest=0d0
       IF(J.GT.1 .AND. MH.LT.cctt04(Ncctt04,1))
     .  MAtest=cctt04(J-1,2)+(MH-cctt04(J-1,1))/
     .   (cctt04(J,1)-cctt04(J-1,1))
     .   *(cctt04(J,2)-cctt04(J-1,2))
       PROB(19)=PROB(19)+5d0*(Rmax-ceff)*DDIM(MAtest/MA,1d0)
       GOTO 722

 322   Rmax=.5d0
       J=1
       DOWHILE(cctt05(J,1).LE.MH .AND. J.LT.Ncctt05)
        J=J+1
       ENDDO
       MAtest=0d0
       IF(J.GT.1 .AND. MH.LT.cctt05(Ncctt05,1))
     .  MAtest=cctt05(J-1,2)+(MH-cctt05(J-1,1))/
     .   (cctt05(J,1)-cctt05(J-1,1))
     .   *(cctt05(J,2)-cctt05(J-1,2))
       PROB(19)=PROB(19)+10d0*(Rmax-ceff)*DDIM(MAtest/MA,1d0)
       GOTO 722

 422   Rmax=.6d0
       J=1
       DOWHILE(cctt06(J,1).LE.MH .AND. J.LT.Ncctt06)
        J=J+1
       ENDDO
       MAtest=0d0
       IF(J.GT.1 .AND. MH.LT.cctt06(Ncctt06,1))
     .  MAtest=cctt06(J-1,2)+(MH-cctt06(J-1,1))/
     .   (cctt06(J,1)-cctt06(J-1,1))
     .   *(cctt06(J,2)-cctt06(J-1,2))
       PROB(19)=PROB(19)+10d0*(Rmax-ceff)*DDIM(MAtest/MA,1d0)
       GOTO 722

 522   Rmax=.8d0
       J=1
       DOWHILE(cctt08(J,1).LE.MH .AND. J.LT.Ncctt08)
        J=J+1
       ENDDO
       MAtest=0d0
       IF(J.GT.1 .AND. MH.LT.cctt08(Ncctt08,1))
     .  MAtest=cctt08(J-1,2)+(MH-cctt08(J-1,1))/
     .   (cctt08(J,1)-cctt08(J-1,1))
     .   *(cctt08(J,2)-cctt08(J-1,2))
       PROB(19)=PROB(19)+5d0*(Rmax-ceff)*DDIM(MAtest/MA,1d0)
       GOTO 722

 622   Rmax=1d0
       J=1
       DOWHILE(cctt1(J,1).LE.MH .AND. J.LT.Ncctt1)
        J=J+1
       ENDDO
       MAtest=0d0
       IF(J.GT.1 .AND. MH.LT.cctt1(Ncctt1,1))
     .  MAtest=cctt1(J-1,2)+(MH-cctt1(J-1,1))/
     .   (cctt1(J,1)-cctt1(J-1,1))
     .   *(cctt1(J,2)-cctt1(J-1,2))
       PROB(19)=PROB(19)+5d0*(Rmax-ceff)*DDIM(MAtest/MA,1d0)
      
 722   CONTINUE

*      AA -> jjjj

       ceff=R*BRHAA(I)*(BRJJ(4)+BRSS(4))**2
       IF(ceff.GE.0.0.AND.ceff.LT.0.2)GOTO 132
       IF(ceff.GE.0.2.AND.ceff.LT.0.4)GOTO 232
       IF(ceff.GE.0.4.AND.ceff.LT.0.5)GOTO 332
       IF(ceff.GE.0.5.AND.ceff.LT.0.6)GOTO 432
       IF(ceff.GE.0.6.AND.ceff.LT.0.8)GOTO 532
       IF(ceff.GE.0.8.AND.ceff.LT.1.0)GOTO 632
       GOTO 732

 132   Rmax=.2d0
       J=1
       DOWHILE(gggg02(J,1).LE.MH .AND. J.LT.Ngggg02)
        J=J+1
       ENDDO
       MAtest=0d0
       IF(J.GT.1 .AND. MH.LT.gggg02(Ngggg02,1))
     .  MAtest=gggg02(J-1,2)+(MH-gggg02(J-1,1))/
     .   (gggg02(J,1)-gggg02(J-1,1))
     .   *(gggg02(J,2)-gggg02(J-1,2))
       PROB(19)=PROB(19)+5d0*(Rmax-ceff)*DDIM(MAtest/MA,1d0)
       GOTO 732

 232   Rmax=.4d0
       J=1
       DOWHILE(gggg04(J,1).LE.MH .AND. J.LT.Ngggg04)
        J=J+1
       ENDDO
       MAtest=0d0
       IF(J.GT.1 .AND. MH.LT.gggg04(Ngggg04,1))
     .  MAtest=gggg04(J-1,2)+(MH-gggg04(J-1,1))/
     .   (gggg04(J,1)-gggg04(J-1,1))
     .   *(gggg04(J,2)-gggg04(J-1,2))
       PROB(19)=PROB(19)+5d0*(Rmax-ceff)*DDIM(MAtest/MA,1d0)
       GOTO 732

 332   Rmax=.5d0
       J=1
       DOWHILE(gggg05(J,1).LE.MH .AND. J.LT.Ngggg05)
        J=J+1
       ENDDO
       MAtest=0d0
       IF(J.GT.1 .AND. MH.LT.gggg05(Ngggg05,1))
     .  MAtest=gggg05(J-1,2)+(MH-gggg05(J-1,1))/
     .   (gggg05(J,1)-gggg05(J-1,1))
     .   *(gggg05(J,2)-gggg05(J-1,2))
       PROB(19)=PROB(19)+10d0*(Rmax-ceff)*DDIM(MAtest/MA,1d0)
       GOTO 732

 432   Rmax=.6d0
       J=1
       DOWHILE(gggg06(J,1).LE.MH .AND. J.LT.Ngggg06)
        J=J+1
       ENDDO
       MAtest=0d0
       IF(J.GT.1 .AND. MH.LT.gggg06(Ngggg06,1))
     .  MAtest=gggg06(J-1,2)+(MH-gggg06(J-1,1))/
     .   (gggg06(J,1)-gggg06(J-1,1))
     .   *(gggg06(J,2)-gggg06(J-1,2))
       PROB(19)=PROB(19)+10d0*(Rmax-ceff)*DDIM(MAtest/MA,1d0)
       GOTO 732

 532   Rmax=.8d0
       J=1
       DOWHILE(gggg08(J,1).LE.MH .AND. J.LT.Ngggg08)
        J=J+1
       ENDDO
       MAtest=0d0
       IF(J.GT.1 .AND. MH.LT.gggg08(Ngggg08,1))
     .  MAtest=gggg08(J-1,2)+(MH-gggg08(J-1,1))/
     .   (gggg08(J,1)-gggg08(J-1,1))
     .   *(gggg08(J,2)-gggg08(J-1,2))
       PROB(19)=PROB(19)+5d0*(Rmax-ceff)*DDIM(MAtest/MA,1d0)
       GOTO 732

 632   Rmax=1d0
       J=1
       DOWHILE(gggg1(J,1).LE.MH .AND. J.LT.Ngggg1)
        J=J+1
       ENDDO
       MAtest=0d0
       IF(J.GT.1 .AND. MH.LT.gggg1(Ngggg1,1))
     .  MAtest=gggg1(J-1,2)+(MH-gggg1(J-1,1))/
     .   (gggg1(J,1)-gggg1(J-1,1))
     .   *(gggg1(J,2)-gggg1(J-1,2))
       PROB(19)=PROB(19)+5d0*(Rmax-ceff)*DDIM(MAtest/MA,1d0)
      
 732   CONTINUE

*      AA -> tautaujj

       ceff=R*BRHAA(I)*BRLL(4)*(BRJJ(4)+BRSS(4))*2d0
       IF(ceff.GE.0.0.AND.ceff.LT.0.2)GOTO 142
       IF(ceff.GE.0.2.AND.ceff.LT.0.4)GOTO 242
       IF(ceff.GE.0.4.AND.ceff.LT.0.5)GOTO 342
       IF(ceff.GE.0.5.AND.ceff.LT.0.6)GOTO 442
       IF(ceff.GE.0.6.AND.ceff.LT.0.8)GOTO 542
       IF(ceff.GE.0.8.AND.ceff.LT.1.0)GOTO 642
       GOTO 742

 142   Rmax=.2d0
       J=1
       DOWHILE(ttgg02(J,1).LE.MH .AND. J.LT.Nttgg02)
        J=J+1
       ENDDO
       MAtest=0d0
       IF(J.GT.1 .AND. MH.LT.ttgg02(Nttgg02,1))
     .  MAtest=ttgg02(J-1,2)+(MH-ttgg02(J-1,1))/
     .   (ttgg02(J,1)-ttgg02(J-1,1))
     .   *(ttgg02(J,2)-ttgg02(J-1,2))
       PROB(19)=PROB(19)+5d0*(Rmax-ceff)*DDIM(MAtest/MA,1d0)
       GOTO 742

 242   Rmax=.4d0
       J=1
       DOWHILE(ttgg04(J,1).LE.MH .AND. J.LT.Nttgg04)
        J=J+1
       ENDDO
       MAtest=0d0
       IF(J.GT.1 .AND. MH.LT.ttgg04(Nttgg04,1))
     .  MAtest=ttgg04(J-1,2)+(MH-ttgg04(J-1,1))/
     .   (ttgg04(J,1)-ttgg04(J-1,1))
     .   *(ttgg04(J,2)-ttgg04(J-1,2))
       PROB(19)=PROB(19)+5d0*(Rmax-ceff)*DDIM(MAtest/MA,1d0)
       GOTO 742

 342   Rmax=.5d0
       J=1
       DOWHILE(ttgg05(J,1).LE.MH .AND. J.LT.Nttgg05)
        J=J+1
       ENDDO
       MAtest=0d0
       IF(J.GT.1 .AND. MH.LT.ttgg05(Nttgg05,1))
     .  MAtest=ttgg05(J-1,2)+(MH-ttgg05(J-1,1))/
     .   (ttgg05(J,1)-ttgg05(J-1,1))
     .   *(ttgg05(J,2)-ttgg05(J-1,2))
       PROB(19)=PROB(19)+10d0*(Rmax-ceff)*DDIM(MAtest/MA,1d0)
       GOTO 742

 442   Rmax=.6d0
       J=1
       DOWHILE(ttgg06(J,1).LE.MH .AND. J.LT.Nttgg06)
        J=J+1
       ENDDO
       MAtest=0d0
       IF(J.GT.1 .AND. MH.LT.ttgg06(Nttgg06,1))
     .  MAtest=ttgg06(J-1,2)+(MH-ttgg06(J-1,1))/
     .   (ttgg06(J,1)-ttgg06(J-1,1))
     .   *(ttgg06(J,2)-ttgg06(J-1,2))
       PROB(19)=PROB(19)+10d0*(Rmax-ceff)*DDIM(MAtest/MA,1d0)
       GOTO 742

 542   Rmax=.8d0
       J=1
       DOWHILE(ttgg08(J,1).LE.MH .AND. J.LT.Nttgg08)
        J=J+1
       ENDDO
       MAtest=0d0
       IF(J.GT.1 .AND. MH.LT.ttgg08(Nttgg08,1))
     .  MAtest=ttgg08(J-1,2)+(MH-ttgg08(J-1,1))/
     .   (ttgg08(J,1)-ttgg08(J-1,1))
     .   *(ttgg08(J,2)-ttgg08(J-1,2))
       PROB(19)=PROB(19)+5d0*(Rmax-ceff)*DDIM(MAtest/MA,1d0)
       GOTO 742

 642   Rmax=1d0
       J=1
       DOWHILE(ttgg1(J,1).LE.MH .AND. J.LT.Nttgg1)
        J=J+1
       ENDDO
       MAtest=0d0
       IF(J.GT.1 .AND. MH.LT.ttgg1(Nttgg1,1))
     .  MAtest=ttgg1(J-1,2)+(MH-ttgg1(J-1,1))/
     .   (ttgg1(J,1)-ttgg1(J-1,1))
     .   *(ttgg1(J,2)-ttgg1(J-1,2))
       PROB(19)=PROB(19)+5d0*(Rmax-ceff)*DDIM(MAtest/MA,1d0)
      
 742   CONTINUE

*      AA -> tautautautau

       ceff=R*BRHAA(I)*BRLL(4)**2
       IF(ceff.GE.0.0.AND.ceff.LT.0.2)GOTO 152
       IF(ceff.GE.0.2.AND.ceff.LT.0.4)GOTO 252
       IF(ceff.GE.0.4.AND.ceff.LT.0.5)GOTO 352
       IF(ceff.GE.0.5.AND.ceff.LT.0.6)GOTO 452
       IF(ceff.GE.0.6.AND.ceff.LT.0.8)GOTO 552
       IF(ceff.GE.0.8.AND.ceff.LT.1.0)GOTO 652
       GOTO 752

 152   Rmax=.2d0
       J=1
       DOWHILE(tttt02(J,1).LE.MH .AND. J.LT.Ntttt02)
        J=J+1
       ENDDO
       MAtest=0d0
       IF(J.GT.1 .AND. MH.LT.tttt02(Ntttt02,1))
     .  MAtest=tttt02(J-1,2)+(MH-tttt02(J-1,1))/
     .   (tttt02(J,1)-tttt02(J-1,1))
     .   *(tttt02(J,2)-tttt02(J-1,2))
       PROB(19)=PROB(19)+5d0*(Rmax-ceff)*DDIM(MAtest/MA,1d0)
       GOTO 752

 252   Rmax=.4d0
       J=1
       DOWHILE(tttt04(J,1).LE.MH .AND. J.LT.Ntttt04)
        J=J+1
       ENDDO
       MAtest=0d0
       IF(J.GT.1 .AND. MH.LT.tttt04(Ntttt04,1))
     .  MAtest=tttt04(J-1,2)+(MH-tttt04(J-1,1))/
     .   (tttt04(J,1)-tttt04(J-1,1))
     .   *(tttt04(J,2)-tttt04(J-1,2))
       PROB(19)=PROB(19)+5d0*(Rmax-ceff)*DDIM(MAtest/MA,1d0)
       GOTO 752

 352   Rmax=.5d0
       J=1
       DOWHILE(tttt05(J,1).LE.MH .AND. J.LT.Ntttt05)
        J=J+1
       ENDDO
       MAtest=0d0
       IF(J.GT.1 .AND. MH.LT.tttt05(Ntttt05,1))
     .  MAtest=tttt05(J-1,2)+(MH-tttt05(J-1,1))/
     .   (tttt05(J,1)-tttt05(J-1,1))
     .   *(tttt05(J,2)-tttt05(J-1,2))
       PROB(19)=PROB(19)+10d0*(Rmax-ceff)*DDIM(MAtest/MA,1d0)
       GOTO 752

 452   Rmax=.6d0
       J=1
       DOWHILE(tttt06(J,1).LE.MH .AND. J.LT.Ntttt06)
        J=J+1
       ENDDO
       MAtest=0d0
       IF(J.GT.1 .AND. MH.LT.tttt06(Ntttt06,1))
     .  MAtest=tttt06(J-1,2)+(MH-tttt06(J-1,1))/
     .   (tttt06(J,1)-tttt06(J-1,1))
     .   *(tttt06(J,2)-tttt06(J-1,2))
       PROB(19)=PROB(19)+10d0*(Rmax-ceff)*DDIM(MAtest/MA,1d0)
       GOTO 752

 552   Rmax=.8d0
       J=1
       DOWHILE(tttt08(J,1).LE.MH .AND. J.LT.Ntttt08)
        J=J+1
       ENDDO
       MAtest=0d0
       IF(J.GT.1 .AND. MH.LT.tttt08(Ntttt08,1))
     .  MAtest=tttt08(J-1,2)+(MH-tttt08(J-1,1))/
     .   (tttt08(J,1)-tttt08(J-1,1))
     .   *(tttt08(J,2)-tttt08(J-1,2))
       PROB(19)=PROB(19)+5d0*(Rmax-ceff)*DDIM(MAtest/MA,1d0)
       GOTO 752

 652   Rmax=1d0
       J=1
       DOWHILE(tttt1(J,1).LE.MH .AND. J.LT.Ntttt1)
        J=J+1
       ENDDO
       MAtest=0d0
       IF(J.GT.1 .AND. MH.LT.tttt1(Ntttt1,1))
     .  MAtest=tttt1(J-1,2)+(MH-tttt1(J-1,1))/
     .   (tttt1(J,1)-tttt1(J-1,1))
     .   *(tttt1(J,2)-tttt1(J-1,2))
       PROB(19)=PROB(19)+5d0*(Rmax-ceff)*DDIM(MAtest/MA,1d0)
      
 752   CONTINUE

      ENDIF
      ENDDO

* Associated production

      DO I=1,3
      MH=SMASS(I)
      MA=PMASS
      R=(PCOMP(3,1)*SCOMP(I,1)*(2*DSQRT(S2TW)*NCP*SAZZ*QD+CAZZ)
     .    + PCOMP(3,2)*SCOMP(I,2)*(2*DSQRT(S2TW)*NCP*SAZZ*QU-CAZZ)
     .    + PCOMP(3,3)*SCOMP(I,3)*2*DSQRT(S2TW)*NCP*SAZZ*QS)**2

*  Z width

      IF(MH+MA.LT.MZ)THEN
       GZ=SQR2*GF*R*LAMBDA(MZ**2,MA**2,MH**2)**3/(48d0*PI*MZ**3)
        PROB(13)=PROB(13)+DDIM(GZ/GZMAX,1d0)
      ENDIF

*  ee -> hA -> 4bs

      IF(MH+MA.LT.SQRS)THEN

       M1=MIN(MH,MA)
       M2=MAX(MH,MA)

       Rmax=1d0
       DO K=1,NhA4b
        IF(AINT(M2).EQ.hA4b(K,1) .AND. AINT(M1).EQ.hA4b(K,2))THEN
         Rmax=hA4b(K,3)
         GOTO 3
        ENDIF
       ENDDO
 3     PROB(14)=PROB(14)+DDIM(R*BRBB(I)*BRBB(4)/Rmax,1d0)

*  ee -> hA -> 4taus

       Rmax=1d0
       DO K=1,NhA4tau
        IF(AINT(M2).EQ.hA4tau(K,1) .AND. AINT(M1).EQ.hA4tau(K,2))THEN
         Rmax=hA4tau(K,3)
         GOTO 4
        ENDIF
       ENDDO
 4     PROB(15)=PROB(15)+DDIM(R*BRLL(I)*BRLL(4)/Rmax,1d0)

*  ee -> hA -> 2b 2taus

       Rmax=1d0
       IF(MA.GT.MH)THEN
        DO K=1,NhA2b2tau
         IF(AINT(M2).EQ.hA2b2tau(K,1) .AND.
     .     AINT(M1).EQ.hA2b2tau(K,2))THEN
          Rmax=hA2b2tau(K,3)
          GOTO 5
         ENDIF
        ENDDO
 5      PROB(16)=PROB(16)+DDIM(R*BRLL(I)*BRBB(4)/Rmax,1d0)
       ENDIF

       Rmax=1d0
       IF(MH.GT.MA)THEN
        DO K=1,NhA2b2tau
         IF(AINT(M2).EQ.hA2b2tau(K,1) .AND.
     .     AINT(M1).EQ.hA2b2tau(K,2))THEN
          Rmax=hA2b2tau(K,3)
          GOTO 6
         ENDIF
        ENDDO
 6      PROB(16)=PROB(16)+DDIM(R*BRBB(I)*BRLL(4)/Rmax,1d0)
       ENDIF

       Rmax=1d0
       IF(MA.GT.MH)THEN
        DO K=1,NhA2tau2b
         IF(AINT(M2).EQ.hA2tau2b(K,1) .AND.
     .     AINT(M1).EQ.hA2tau2b(K,2))THEN
          Rmax=hA2tau2b(K,3)
          GOTO 7
         ENDIF
        ENDDO
 7      PROB(16)=PROB(16)+DDIM(R*BRBB(I)*BRLL(4)/Rmax,1d0)
       ENDIF

       Rmax=1d0
       IF(MH.GT.MA)THEN
        DO K=1,NhA2tau2b
         IF(AINT(M2).EQ.hA2tau2b(K,1) .AND.
     .     AINT(M1).EQ.hA2tau2b(K,2))THEN
          Rmax=hA2tau2b(K,3)
          GOTO 8
         ENDIF
        ENDDO
 8      PROB(16)=PROB(16)+DDIM(R*BRLL(I)*BRBB(4)/Rmax,1d0)
       ENDIF

*  ee -> hA -> AAA -> 6bs

       IF(MH.GT.2d0*MA)THEN
        Rmax=1d0
        DO K=1,NAAA6b
         IF(AINT(MH).EQ.AAA6b(K,1) .AND. AINT(MA).EQ.AAA6b(K,2))THEN
          Rmax=AAA6b(K,3)
          GOTO 9
         ENDIF
        ENDDO
 9      PROB(17)=PROB(17)+DDIM(R*BRHAA(I)*BRBB(4)**3/Rmax,
     .   1d0)

*  ee -> hA -> AAA -> 6taus

        Rmax=1d0
        DO K=1,NAAA6tau
         IF(AINT(MH).EQ.AAA6tau(K,1) .AND.
     .     AINT(MA).EQ.AAA6tau(K,2))THEN
          Rmax=AAA6tau(K,3)
          GOTO 10
         ENDIF
        ENDDO
 10     PROB(18)=PROB(18)+DDIM(R*BRHAA(I)*BRLL(4)**3/Rmax,
     .   1d0)
      ENDIF

      ENDIF
      ENDDO

* top -> H+ b, H+ -> c s (from CDF, 0907.1269, and D0, 0908.1811)
       
       brtopcs=brtopbh*HCBRSC
       PROB(42)=0d0
       
       DO I=1,9
        IF((minf(i).LE.CMASS).AND.(CMASS.LE.msup(i))) THEN
        brtoplim=binf(i)+
     .      (CMASS-minf(i))*(bsup(i)-binf(i))/(msup(i)-minf(i))
         PROB(42)=PROB(42)+DDIM(brtopcs/brtoplim,1d0)
        ENDIF
       ENDDO

* top -> H+ b, H+ -> tau nu_tau (from D0, 0908.1811)

       brtoptau=brtopbh*HCBRL
       PROB(43)=0d0
    
       DO I=1,7
        IF((minf(i+2).LE.CMASS).AND.(CMASS.LE.msup(i+2))) THEN
        brtoplim=brtau(i)+
     .    (CMASS-minf(i+2))*(brtau(i+1)-brtau(i))/(msup(i+2)-minf(i+2))
         PROB(43)=PROB(43)+DDIM(brtoptau/brtoplim,1d0)
        ENDIF
       ENDDO

* top -> H+ b, H+ -> W+ A_1, A_1 -> 2taus (from CDF Note 10104)

       MA=PMASS
       brtopa1=brtopbh*HCBRWH(4)*BRLL(4)
       PROB(44)=0d0

      IF(MA.LE.4d0) then     
       DO I=1,4
        IF((mh4m(i).LE.CMASS).AND.(CMASS.LE.mh4p(i))) THEN
          brtoplim=br4m(i)+
     .      (CMASS-mh4m(i))*(br4p(i)-br4m(i))/(mh4p(i)-mh4m(i))
         PROB(44)=PROB(44)+DDIM(brtopa1/brtoplim,1d0)
        ENDIF
       ENDDO
      ENDIF

      IF((MA.gt.4d0).and.(MA.LE.7d0)) then     
       DO I=1,3
        IF((mh7(i).LE.CMASS).AND.(CMASS.LE.mh7(i+1))) THEN
          brtoplim=br4p(i)+(MA-4d0)*(br7(i)-br4p(i))/3d0
     .     +(br4p(i+1)-br4p(i)
     .      +(br7(i+1)-br7(i)-br4p(i+1)+br4p(i))*(MA-4d0)/3d0)
     .     *(CMASS-mh7(i))/(mh7(i+1)-mh7(i))
         PROB(44)=PROB(44)+DDIM(brtopa1/brtoplim,1d0)
        ENDIF
       ENDDO
      ENDIF

      IF((MA.gt.7d0).and.(MA.LE.9d0)) then     
       DO I=1,4
        IF((mh7(i).LE.CMASS).AND.(CMASS.LE.mh7(i+1))) THEN
          brtoplim=br7(i)+(MA-7d0)*(br9(i)-br7(i))/2d0
     .     +(br7(i+1)-br7(i)
     .      +(br9(i+1)-br9(i)-br7(i+1)+br7(i))*(MA-7d0)/2d0)
     .     *(CMASS-mh7(i))/(mh7(i+1)-mh7(i))
         PROB(44)=PROB(44)+DDIM(brtopa1/brtoplim,1d0)
        ENDIF
       ENDDO
      ENDIF

      END


      DOUBLE PRECISION FUNCTION CLEOTAU(MX)

*  CLEO constraints on BR(Y -> A gamma)*BR(A -> tau tau)

      IMPLICIT NONE

      INTEGER I,N
      PARAMETER (N=17)
      DOUBLE PRECISION MX,X(N),M(N)

      DATA M/3.75d0,4.25d0,4.75d0,5.1d0,5.8d0,6.15d0,6.6d0,7d0,
     .      7.4d0,7.6d0,8d0,8.25d0,8.6d0,9d0,9.25d0,9.35d0,9.41d0/
      DATA X/2.9D-5,2.5D-5,2.D-5,2.3D-5,5.1D-5,2.5D-5,2.5D-5,2.7D-5,
     .      4.5D-5,3.7D-5,2.7D-5,7.2D-5,6.8D-5,8.6D-5,2.1D-4,2.85D-4,
     .      4.75D-4/

      CLEOTAU=0d0

      IF(MX.LT.M(1).OR.MX.GT.M(N))RETURN

      DO I=2,N
       IF(MX.LT.M(I))THEN
        CLEOTAU=X(I-1)+(MX-M(I-1))/(M(I)-M(I-1))*(X(I)-X(I-1))
        RETURN
       ENDIF
      ENDDO

      END


      DOUBLE PRECISION FUNCTION CLEOMU(MX)

*  CLEO constraints on BR(Y -> A gamma)*BR(A -> mu mu)

      IMPLICIT NONE

      INTEGER I,N
      PARAMETER (N=2)
      DOUBLE PRECISION MX,X(N),M(N)

      DATA M/.25d0,3.75d0/
      DATA X/9.D-6,9.D-6/

      CLEOMU=0d0

      IF(MX.LT.M(1).OR.MX.GT.M(N))RETURN

      DO I=2,N
       IF(MX.LT.M(I))THEN
        CLEOMU=X(I-1)+(MX-M(I-1))/(M(I)-M(I-1))*(X(I)-X(I-1))
        RETURN
       ENDIF
      ENDDO

      END


* No use of SUBROUTINE SUSYLHCSP, because it applies for GUT parameters

* Sparticle searches at LHC (NMSPEC)

      SUBROUTINE CMS_TAUTAU(PROB)

* Constraints from ggF/bb->H/A->tautau from CMS-PAS-HIG-13-021 and ATLAS-CONF-2014-049
*      PROB(51) =/= 0: excluded by H/A->tautau

      IMPLICIT NONE

      INTEGER I,I1,J,J1,NX,JBAR,JBARbb
      PARAMETER(NX=18)

      DOUBLE PRECISION PROB(*)
      DOUBLE PRECISION SMASS(3),SCOMP(3,3),PMASS,PCOMP(3,3),CMASS
      DOUBLE PRECISION CU(4),CD(4),CV(3),CVZ(3),CJ(4),CG(4),CB(4)
      DOUBLE PRECISION BRJJ(4),BREE(4),BRMM(4),BRLL(4),BRSS(4),BRCC(4)
      DOUBLE PRECISION BRBB(4),BRTT(4),BRWW(3),BRZZ(3),BRGG(4)
      DOUBLE PRECISION BRZG(4),BRHHH(4),BRHAA(3),BRHCHC(3)
      DOUBLE PRECISION BRHAZ(3),BRAHZ(3),BRHCW(4)
      DOUBLE PRECISION BRHIGGS(4),BRNEU(4,6,6),BRCHA(4,3)
      DOUBLE PRECISION BRHSQ(3,10),BRHSL(3,9),BRASQ(2),BRASL
      DOUBLE PRECISION BRSUSY(4),WIDTH(4)
      DOUBLE PRECISION HMAS(NX),XSM(NX),XSMbb(NX),LCMS(NX),LCMSbb(NX)
      DOUBLE PRECISION LATLASgg(NX),LATLASbb(NX)
      DOUBLE PRECISION MH(4),XSMH(4),LCMSH(4),SIG(4),LATLASH(4)
      DOUBLE PRECISION XSMHbb(4),LCMSHbb(4),SIGbb(4),LATLASHbb(4)
      DOUBLE PRECISION DEL,SIGTOT,MBAR,LCMSMB,LATLASMB
      DOUBLE PRECISION SIGTOTbb,MBARbb,LCMSMBbb,LATLASMBbb

      COMMON/HIGGSPEC/SMASS,SCOMP,PMASS,PCOMP,CMASS
      COMMON/REDCOUP/CU,CD,CV,CVZ,CJ,CG,CB
      COMMON/BRN/BRJJ,BREE,BRMM,BRLL,BRSS,BRCC,BRBB,BRTT,BRWW,BRZZ,
     .      BRGG,BRZG,BRHHH,BRHAA,BRHCHC,BRHAZ,BRAHZ,
     .      BRHCW,BRHIGGS,BRNEU,BRCHA,BRHSQ,BRHSL,BRASQ,BRASL,
     .      BRSUSY,WIDTH

      DATA HMAS/90d0,100d0,120d0,140d0,160d0,180d0,200d0,250d0,300d0,
     . 350d0,400d0,450d0,500d0,600d0,700d0,800d0,900d0,1000d0/

* SM Higgs ggF prod. cross sect. at 8 TeV from 
* https://twiki.cern.ch/twiki/bin/view/LHCPhysics/
* CERNYellowReportPageAt8TeV#gluon_gluon_Fusion_Process
      DATA XSM/36.32d0,29.68d0,20.8d0,15.42d0,11.96d0,8.98d0,7.081d0,
     . 4.783d0,3.594d0,3.401d0,2.921d0,2.002d0,1.283d0,.523d0,.229d0,
     . .1097d0,.0571d0,.032d0/

* SM Higgs bbH prod. cross sect. at 8 TeV from 
* https://twiki.cern.ch/twiki/bin/view/LHCPhysics/
* /CrossSectionsFigures#MSSM_WG_plots (estimated)
      DATA XSMbb/0.56d0,0.42d0,0.25d0,0.15d0,8.7d-2,5.1d-2,3.2d-2,
     . 1.2d-2,4.5d-3,2.8d-3,1.4d-3,8.2d-4,4.9d-4,2.6d-4,1.2d-4,
     . 5.2d-5,2.4d-5,1.2d-5/

* Upper limit on ggF->H->tautau (8 TeV) from CMS-PAS-HIG-13-021, Table 7
      DATA LCMS/50.2d0,31.3d0,7.38d0,2.27d0,.845d0,.549d0,.517d0,.315d0,
     . .15d0,.112d0,.103d0,.607d-1,.385d-1,.193d-1,.143d-1,.115d-1,
     . .923d-2,.865d-2/

* Upper limit on bbH->tautau (8 TeV) from CMS-PAS-HIG-13-021, Table 8
      DATA LCMSbb/6.03d0,4.14d0,1.76d0,1.25d0,.814d0,.659d0,.553d0,
     . .217d0,
     . .975d-1,.638d-1,.613d-1,.431d-1,.320d-1,.203d-1,.173d-1,.166d-1,
     . .146d-1,.133d-1/

* Upper limit on ggF->H->tautau (8 TeV) from ATLAS-CONF-2014-049, Fig. 7
      DATA LATLASgg/29.1d0,24.0d0,5.25d0,2.02d0,1.39d0,1.00d0,.794d0,
     .  .281d0,.127d0,.112d0,.773d-1,.400d-1,.240d-1,.177d-1,.127d-1,
     .  .993d-2,.840d-2,.735d-2/

* Upper limit on bbH->tautau (8 TeV) from ATLAS-CONF-2014-049, Fig. 7
      DATA LATLASbb/6.32d0,6.32d0,2.73d0,1.27d0,.966d0,.606d0,.393d0,
     .  .305d0,.116d0,.101d0,.656d-1,.363d-1,.238d-1,.159d-1,.117d-1,
     .  .943d-2,.785d-2,.716d-2/

* Loop over 4 Higgses
      DO I=1,4
        IF(I.LE.3) MH(I)=SMASS(I)
        IF(I.EQ.4) MH(I)=PMASS
        J=1
        DOWHILE(HMAS(J).LE.MH(I) .AND. J.LT.NX)
          J=J+1
        ENDDO
        IF(J.GE.2 .AND. MH(I).LT.HMAS(NX)) THEN
        XSMH(I)=0D0
	LCMSH(I)=1D10
        XSMHbb(I)=0D0
	LCMSHbb(I)=1D10
* SM Higgs ggF prod. cross sect.:
          XSMH(I)=XSM(J-1)+(MH(I)-HMAS(J-1))/
     .      (HMAS(J)-HMAS(J-1))*(XSM(J)-XSM(J-1))
* ggF Signal cross section*BR:
          SIG(I)=CJ(I)**2*BRLL(I)*XSMH(I)
* CMS ggF limit:
          LCMSH(I)=LCMS(J-1)+(MH(I)-HMAS(J-1))/
     .      (HMAS(J)-HMAS(J-1))*(LCMS(J)-LCMS(J-1))
          PROB(51)=PROB(51)+DDIM(1D0,LCMSH(I)/SIG(I))
* ATLAS ggF limit:
          LATLASH(I)=LATLASgg(J-1)+(MH(I)-HMAS(J-1))/
     .      (HMAS(J)-HMAS(J-1))*(LATLASgg(J)-LATLASgg(J-1))
* Correct for jump in Fig.7 at MA=200 GeV: J=8, 
* modif. LATLASgg(J-1)=LATLASgg(7)=.96D0 and not .794d0:
	  IF(J.EQ.8) THEN
            LATLASH(I)=.96D0+(MH(I)-HMAS(J-1))/
     .        (HMAS(J)-HMAS(J-1))*(LATLASgg(J)-.96D0)
	  ENDIF
          PROB(51)=PROB(51)+DDIM(1D0,LATLASH(I)/SIG(I))
***
* SM Higgs bbH prod. cross sect.:
          XSMHbb(I)=XSMbb(J-1)+(MH(I)-HMAS(J-1))/
     .      (HMAS(J)-HMAS(J-1))*(XSMbb(J)-XSMbb(J-1))
* bbH Signal cross section*BR:
          SIGbb(I)=CB(I)**2*XSMHbb(I)*BRLL(I)
* CMS Hbb limit:
          LCMSHbb(I)=LCMSbb(J-1)+(MH(I)-HMAS(J-1))/
     .      (HMAS(J)-HMAS(J-1))*(LCMSbb(J)-LCMSbb(J-1))
          PROB(51)=PROB(51)+DDIM(1D0,LCMSHbb(I)/SIGbb(I))
* ATLAS Hbb limit:
          LATLASHbb(I)=LATLASbb(J-1)+(MH(I)-HMAS(J-1))/
     .      (HMAS(J)-HMAS(J-1))*(LATLASbb(J)-LATLASbb(J-1))
* Correct for jump in Fig.7 at MA=200 GeV: J=8, 
* modif. LATLASbb(J-1)=LATLASbb(7)=.858D0 and not .393d0:
	  IF(J.EQ.8) THEN
            LATLASHbb(I)=.858d0+(MH(I)-HMAS(J-1))/
     .        (HMAS(J)-HMAS(J-1))*(LATLASbb(J)-.858d0)
	  ENDIF
          PROB(51)=PROB(51)+DDIM(1d0,LATLASHbb(I)/SIGbb(I))
*********************************************************
* Combine signal rates of 2 Higgses
          DO I1=1,I-1
            J1=1
            DOWHILE(HMAS(J1).LE.MH(I1) .AND. J1.LT.NX)
              J1=J1+1
            ENDDO
          IF(MH(I1).GE.HMAS(1) .AND. MH(I1).LT.HMAS(NX)) THEN
* Average masses weighted by the signal rates: (MBAR for ggF, MBARbb for bbH):
             MBAR=(SIG(I)*MH(I)+SIG(I1)*MH(I1))/(SIG(I)+SIG(I1))
             JBAR=1
             DOWHILE(HMAS(JBAR).LE.MBAR.AND.JBAR.LT.NX)
               JBAR=JBAR+1
             ENDDO
             MBARbb=(SIGbb(I)*MH(I)
     .         +SIGbb(I1)*MH(I1))/(SIGbb(I)+SIGbb(I1))
             JBARbb=1
             DOWHILE(HMAS(JBARbb).LE.MBARbb.AND.JBARbb.LT.NX)
               JBARbb=JBARbb+1
             ENDDO
* DEL=mass difference divided by a (small) resolution squared:
* [DEL < 1 only if |MH(I)-MH(I1)| < (MH(I)+MH(I1))/15D0;
*  otherwise the combined signal rate is small]
             DEL=((MH(I)-MH(I1))/(MH(I)+MH(I1))*15D0)**2
* Estimate of the combined ggF signal rates:
             SIGTOT=SIG(I)+SIG(I1)
     .         -SIG(I)*SIG(I1)*DEL/(SIG(I)+SIG(I1))
* Continue only if SIGTOT > 0 and 90<MBAR<1000
*      and |MH(I)-MH(I1)|/MBAR<0.20:
             IF(SIGTOT.GT.0D0.AND.MBAR.GE.HMAS(1).AND.
     .         MBAR.LT.HMAS(NX).AND.
     .           dabs(MH(I)-MH(I1))/MBAR.LE.0.20d0) THEN
* CMS ggF limit at MBAR:
               LCMSMB=LCMS(JBAR-1)+(MBAR-HMAS(JBAR-1))/
     .          (HMAS(JBAR)-HMAS(JBAR-1))*(LCMS(JBAR)-LCMS(JBAR-1))
               PROB(51)=PROB(51)+DDIM(1D0,LCMSMB/SIGTOT)
* ATLAS ggF limit at MBAR:
               LATLASMB=LATLASgg(JBAR-1)+(MBAR-HMAS(JBAR-1))/
     .       (HMAS(JBAR)-HMAS(JBAR-1))*(LATLASgg(JBAR)-LATLASgg(JBAR-1))
* Correct for jump in Fig.7 at MA=200 GeV: JBAR=8, 
* modif. LATLASgg(JBAR-1)=LATLASgg(7)=.96D0 and not .794d0:
	         IF(J.EQ.8) THEN
                   LATLASMB=.96D0+(MBAR-HMAS(JBAR-1))/
     .             (HMAS(JBAR)-HMAS(JBAR-1))*(LATLASgg(JBAR)-.96D0)
	         ENDIF
               PROB(51)=PROB(51)+DDIM(1D0,LATLASMB/SIGTOT)
             ENDIF
****
* Estimate of the combined bbH signal rates:
             SIGTOTbb=SIGbb(I)+SIGbb(I1)
     .         -SIGbb(I)*SIGbb(I1)*DEL/(SIGbb(I)+SIGbb(I1))
* Continue only if SIGTOTbb > 0 and 90<MBARbb<1000 
*      and |MH(I)-MH(I1)|/MBARbb<0.20:
             IF(SIGTOTbb.GT.0D0.AND.MBARbb.GE.HMAS(1).AND.
     .           MBARbb.LT.HMAS(NX).AND.
     .             dabs(MH(I)-MH(I1))/MBARbb.LE.0.20d0) THEN
* CMS bbH limit at MBARbb:
               LCMSMBbb=LCMSbb(JBARbb-1)+(MBARbb-HMAS(JBARbb-1))/
     .           (HMAS(JBARbb)-HMAS(JBARbb-1))*
     .             (LCMSbb(JBARbb)-LCMSbb(JBARbb-1))
               PROB(51)=PROB(51)+DDIM(1D0,LCMSMBbb/SIGTOTbb)
* ATLAS bbH limit at MBARbb:
               LATLASMBbb=LATLASbb(JBARbb-1)+(MBARbb-HMAS(JBARbb-1))/
     .           (HMAS(JBARbb)-HMAS(JBARbb-1))*
     .             (LATLASbb(JBARbb)-LATLASbb(JBARbb-1))
* Correct for jump in Fig.7 at MA=200 GeV: JBARbb=8, 
* modif. LATLASbb(JBARbb-1)=LATLASbb(7)=.858D0 and not .393d0:
	        IF(J.EQ.8) THEN
                  LATLASMBbb=.858D0+(MBARbb-HMAS(JBARbb-1))/
     .              (HMAS(JBARbb)-HMAS(JBARbb-1))*
     .                (LATLASbb(JBARbb)-.858D0)
	        ENDIF

               PROB(51)=PROB(51)+DDIM(1D0,LATLASMBbb/SIGTOTbb)
             ENDIF
           ENDIF
           ENDDO
         ENDIF
!        write(*,*) "Prob(51):",prob(51)
      ENDDO
!      write(*,*) "Prob(51):",prob(51)
      END
   

      SUBROUTINE CMS_AA_4MU(PROB)

* Sparticle searches at LHC (NMSPEC)

      IMPLICIT NONE

      INTEGER I,NX
      PARAMETER(NX=6)

      DOUBLE PRECISION PROB(*)
      DOUBLE PRECISION SMASS(3),SCOMP(3,3),PMASS,PCOMP(3,3),CMASS
      DOUBLE PRECISION BRJJ(4),BREE(4),BRMM(4),BRLL(4),BRSS(4),BRCC(4)
      DOUBLE PRECISION BRBB(4),BRTT(4),BRWW(3),BRZZ(3),BRGG(4)
      DOUBLE PRECISION BRZG(4),BRHHH(4),BRHAA(3),BRHCHC(3)
      DOUBLE PRECISION BRHAZ(3),BRAHZ(3),BRHCW(4)
      DOUBLE PRECISION BRHIGGS(4),BRNEU(4,6,6),BRCHA(4,3)
      DOUBLE PRECISION BRHSQ(3,10),BRHSL(3,9),BRASQ(2),BRASL
      DOUBLE PRECISION BRSUSY(4),WIDTH(4)
      DOUBLE PRECISION CU(4),CD(4),CV(3),CVZ(3),CJ(4),CG(4),CB(4)
      DOUBLE PRECISION X1(NX),LSIGBR(NX),LIMIT
      DOUBLE PRECISION D1,D2,CJ2,BRHTOAA
      DOUBLE PRECISION MHmin,MHmax,chi2max,chi2gam,chi2bb,chi2zz,MHcen

      COMMON/HIGGSPEC/SMASS,SCOMP,PMASS,PCOMP,CMASS
      COMMON/BRN/BRJJ,BREE,BRMM,BRLL,BRSS,BRCC,BRBB,BRTT,BRWW,BRZZ,
     .      BRGG,BRZG,BRHHH,BRHAA,BRHCHC,BRHAZ,BRAHZ,
     .      BRHCW,BRHIGGS,BRNEU,BRCHA,BRHSQ,BRHSL,BRASQ,BRASL,
     .      BRSUSY,WIDTH
      COMMON/REDCOUP/CU,CD,CV,CVZ,CJ,CG,CB
      COMMON/HIGGSFIT/MHmin,MHmax,chi2max,chi2gam,chi2bb,chi2zz

      DATA X1/.25d0,.5d0,.75d0,1.d0,2.d0,3.d0/
      DATA LSIGBR/3.8d-3,3.6d-3,4.1d-3,4.2d-3,4.4d-3,4.6d-3/

      MHcen=(MHmin+MHmax)/2d0
      D1=DDIM(SMASS(1)/MHMAX,1d0)-DDIM(1d0,SMASS(1)/MHMIN)
      D2=DDIM(SMASS(2)/MHMAX,1d0)-DDIM(1d0,SMASS(2)/MHMIN)
      CJ2=0d0
      IF(DABS(SMASS(1)-MHcen).LE.DABS(SMASS(2)-MHcen).AND.D1.EQ.0d0)THEN
       CJ2=CJ(1)**2
       BRHTOAA=BRHAA(1)
      ENDIF
      IF(DABS(SMASS(1)-MHcen).GE.DABS(SMASS(2)-MHcen).AND.D2.EQ.0d0)THEN
       CJ2=CJ(2)**2
       BRHTOAA=BRHAA(2)
      ENDIF

      I=1
      DOWHILE(PMASS.GE.X1(1).AND.X1(I).LE.PMASS .AND. I.LT.NX)
       I=I+1
      ENDDO
      IF(I.GT.1 .AND. PMASS.LT.X1(NX))THEN
       LIMIT=LSIGBR(I-1)
     .    +(PMASS-X1(I-1))/(X1(I)-X1(I-1))*(LSIGBR(I)-LSIGBR(I-1))
       PROB(52)=DDIM(CJ2*BRHTOAA*BRMM(4)**2/LIMIT,1d0)
      ENDIF

      END

