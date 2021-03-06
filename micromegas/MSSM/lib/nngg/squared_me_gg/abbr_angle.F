* abbr_angle.F
* this file is part of the process {MNE1, MNE1} -> {0, 0}
* generated by WriteSquaredME 5 Oct 2009 6:36

	subroutine abbr_angle
	implicit character (a-s,u-z)
	implicit double complex (t)

#include "vars.h"


	do cha1 = 1, 2
        iint68(cha1) = Dget(MNE1sq,S,0.D0,T,MNE1sq,0.D0,
     -   chaMass(cha1)**2,MHcsq,MHcsq,MHcsq)
        iint69(cha1) = Dget(MNE1sq,0.D0,0.D0,MNE1sq,U,S,
     -   chaMass(cha1)**2,MHcsq,MHcsq,MHcsq)
        iint70(cha1) = Dget(0.D0,0.D0,MNE1sq,MNE1sq,S,U,
     -   chaMass(cha1)**2,chaMass(cha1)**2,chaMass(cha1)**2,MHcsq)
        iint71(cha1) = Cget(0.D0,MNE1sq,U,chaMass(cha1)**2,
     -   chaMass(cha1)**2,MHcsq)
        iint72(cha1) = Cget(0.D0,T,MNE1sq,chaMass(cha1)**2,
     -   chaMass(cha1)**2,MHcsq)
	iint73(cha1) = Cget(MNE1sq,0.D0,T,chaMass(cha1)**2,MHcsq,MHcsq)
        iint74(cha1) = Dget(0.D0,MNE1sq,0.D0,MNE1sq,U,T,
     -   chaMass(cha1)**2,chaMass(cha1)**2,MHcsq,MHcsq)
        iint75(cha1) = Dget(S,0.D0,T,MNE1sq,0.D0,MNE1sq,
     -   chaMass(cha1)**2,chaMass(cha1)**2,chaMass(cha1)**2,MHcsq)
        iint77(cha1) = Dget(MNE1sq,S,0.D0,T,MNE1sq,0.D0,
     -   chaMass(cha1)**2,AAABR(7),AAABR(7),AAABR(7))
        iint78(cha1) = Dget(MNE1sq,0.D0,0.D0,MNE1sq,U,S,
     -   chaMass(cha1)**2,AAABR(7),AAABR(7),AAABR(7))
        iint79(cha1) = Dget(0.D0,0.D0,MNE1sq,MNE1sq,S,U,
     -   chaMass(cha1)**2,chaMass(cha1)**2,chaMass(cha1)**2,
     -   AAABR(7))
        iint80(cha1) = Cget(0.D0,MNE1sq,U,chaMass(cha1)**2,
     -   chaMass(cha1)**2,AAABR(7))
        iint81(cha1) = Cget(0.D0,T,MNE1sq,chaMass(cha1)**2,
     -   chaMass(cha1)**2,AAABR(7))
        iint82(cha1) = Cget(MNE1sq,0.D0,T,chaMass(cha1)**2,
     -   AAABR(7),AAABR(7))
        iint83(cha1) = Dget(0.D0,MNE1sq,0.D0,MNE1sq,U,T,
     -   chaMass(cha1)**2,chaMass(cha1)**2,AAABR(7),AAABR(7))
        iint84(cha1) = Dget(S,0.D0,T,MNE1sq,0.D0,MNE1sq,
     -   chaMass(cha1)**2,chaMass(cha1)**2,chaMass(cha1)**2,
     -   AAABR(7))
        iint88(cha1) = Dget(0.D0,0.D0,MNE1sq,MNE1sq,S,U,AAABR(7),
     -   AAABR(7),AAABR(7),chaMass(cha1)**2)
        iint89(cha1) = Dget(0.D0,MNE1sq,0.D0,MNE1sq,U,T,AAABR(7),
     -   AAABR(7),chaMass(cha1)**2,chaMass(cha1)**2)
        iint90(cha1) = Dget(S,0.D0,T,MNE1sq,0.D0,MNE1sq,AAABR(7),
     -   AAABR(7),AAABR(7),chaMass(cha1)**2)
        iint91(cha1) = Dget(MNE1sq,S,0.D0,T,MNE1sq,0.D0,AAABR(7),
     -   chaMass(cha1)**2,chaMass(cha1)**2,chaMass(cha1)**2)
        iint92(cha1) = Dget(MNE1sq,0.D0,0.D0,MNE1sq,U,S,AAABR(7),
     -   chaMass(cha1)**2,chaMass(cha1)**2,chaMass(cha1)**2)
        iint93(cha1) = Cget(MNE1sq,0.D0,T,AAABR(7),
     -   chaMass(cha1)**2,chaMass(cha1)**2)
        iint94(cha1) = Cget(0.D0,MNE1sq,U,AAABR(7),AAABR(7),
     -   chaMass(cha1)**2)
        iint95(cha1) = Cget(0.D0,T,MNE1sq,AAABR(7),AAABR(7),
     -   chaMass(cha1)**2)
	enddo

	do lpd1 = 1, 3
        iint50(lpd1) = Dget(MNE1sq,S,0.D0,T,MNE1sq,0.D0,
     -   lpdMass(lpd1)**2,sldMass(lpd1)**2,sldMass(lpd1)**2,
     -   sldMass(lpd1)**2)
        iint51(lpd1) = Dget(MNE1sq,0.D0,0.D0,MNE1sq,U,S,
     -   lpdMass(lpd1)**2,sldMass(lpd1)**2,sldMass(lpd1)**2,
     -   sldMass(lpd1)**2)
        iint52(lpd1) = Dget(0.D0,0.D0,MNE1sq,MNE1sq,S,U,
     -   lpdMass(lpd1)**2,lpdMass(lpd1)**2,lpdMass(lpd1)**2,
     -   sldMass(lpd1)**2)
        iint53(lpd1) = Cget(0.D0,MNE1sq,U,lpdMass(lpd1)**2,
     -   lpdMass(lpd1)**2,sldMass(lpd1)**2)
        iint54(lpd1) = Cget(0.D0,T,MNE1sq,lpdMass(lpd1)**2,
     -   lpdMass(lpd1)**2,sldMass(lpd1)**2)
        iint55(lpd1) = Cget(MNE1sq,0.D0,T,lpdMass(lpd1)**2,
     -   sldMass(lpd1)**2,sldMass(lpd1)**2)
        iint56(lpd1) = Dget(0.D0,MNE1sq,0.D0,MNE1sq,U,T,
     -   lpdMass(lpd1)**2,lpdMass(lpd1)**2,sldMass(lpd1)**2,
     -   sldMass(lpd1)**2)
        iint57(lpd1) = Dget(S,0.D0,T,MNE1sq,0.D0,MNE1sq,
     -   lpdMass(lpd1)**2,lpdMass(lpd1)**2,lpdMass(lpd1)**2,
     -   sldMass(lpd1)**2)
        iint59(lpd1) = Dget(MNE1sq,S,0.D0,T,MNE1sq,0.D0,
     -   lpdMass(lpd1)**2,sleMass(lpd1)**2,sleMass(lpd1)**2,
     -   sleMass(lpd1)**2)
        iint60(lpd1) = Dget(MNE1sq,0.D0,0.D0,MNE1sq,U,S,
     -   lpdMass(lpd1)**2,sleMass(lpd1)**2,sleMass(lpd1)**2,
     -   sleMass(lpd1)**2)
        iint61(lpd1) = Dget(0.D0,0.D0,MNE1sq,MNE1sq,S,U,
     -   lpdMass(lpd1)**2,lpdMass(lpd1)**2,lpdMass(lpd1)**2,
     -   sleMass(lpd1)**2)
        iint62(lpd1) = Cget(0.D0,MNE1sq,U,lpdMass(lpd1)**2,
     -   lpdMass(lpd1)**2,sleMass(lpd1)**2)
        iint63(lpd1) = Cget(0.D0,T,MNE1sq,lpdMass(lpd1)**2,
     -   lpdMass(lpd1)**2,sleMass(lpd1)**2)
        iint64(lpd1) = Cget(MNE1sq,0.D0,T,lpdMass(lpd1)**2,
     -   sleMass(lpd1)**2,sleMass(lpd1)**2)
        iint65(lpd1) = Dget(0.D0,MNE1sq,0.D0,MNE1sq,U,T,
     -   lpdMass(lpd1)**2,lpdMass(lpd1)**2,sleMass(lpd1)**2,
     -   sleMass(lpd1)**2)
        iint66(lpd1) = Dget(S,0.D0,T,MNE1sq,0.D0,MNE1sq,
     -   lpdMass(lpd1)**2,lpdMass(lpd1)**2,lpdMass(lpd1)**2,
     -   sleMass(lpd1)**2)
	enddo

	do qud1 = 1, 3
        iint31(qud1) = Cget(0.D0,MNE1sq,U,qudMass(qud1)**2,
     -   qudMass(qud1)**2,sqdMass(qud1)**2)
        iint32(qud1) = Cget(0.D0,T,MNE1sq,qudMass(qud1)**2,
     -   qudMass(qud1)**2,sqdMass(qud1)**2)
        iint33(qud1) = Cget(MNE1sq,0.D0,T,qudMass(qud1)**2,
     -   sqdMass(qud1)**2,sqdMass(qud1)**2)
        iint35(qud1) = Dget(0.D0,0.D0,MNE1sq,MNE1sq,S,U,
     -   qudMass(qud1)**2,qudMass(qud1)**2,qudMass(qud1)**2,
     -   sqdMass(qud1)**2)
        iint36(qud1) = Dget(0.D0,MNE1sq,0.D0,MNE1sq,U,T,
     -   qudMass(qud1)**2,qudMass(qud1)**2,sqdMass(qud1)**2,
     -   sqdMass(qud1)**2)
        iint37(qud1) = Dget(S,0.D0,T,MNE1sq,0.D0,MNE1sq,
     -   qudMass(qud1)**2,qudMass(qud1)**2,qudMass(qud1)**2,
     -   sqdMass(qud1)**2)
        iint38(qud1) = Dget(MNE1sq,S,0.D0,T,MNE1sq,0.D0,
     -   qudMass(qud1)**2,sqdMass(qud1)**2,sqdMass(qud1)**2,
     -   sqdMass(qud1)**2)
        iint39(qud1) = Dget(MNE1sq,0.D0,0.D0,MNE1sq,U,S,
     -   qudMass(qud1)**2,sqdMass(qud1)**2,sqdMass(qud1)**2,
     -   sqdMass(qud1)**2)
        iint40(qud1) = Cget(0.D0,MNE1sq,U,qudMass(qud1)**2,
     -   qudMass(qud1)**2,sqeMass(qud1)**2)
        iint41(qud1) = Cget(0.D0,T,MNE1sq,qudMass(qud1)**2,
     -   qudMass(qud1)**2,sqeMass(qud1)**2)
        iint42(qud1) = Cget(MNE1sq,0.D0,T,qudMass(qud1)**2,
     -   sqeMass(qud1)**2,sqeMass(qud1)**2)
        iint44(qud1) = Dget(0.D0,0.D0,MNE1sq,MNE1sq,S,U,
     -   qudMass(qud1)**2,qudMass(qud1)**2,qudMass(qud1)**2,
     -   sqeMass(qud1)**2)
        iint45(qud1) = Dget(0.D0,MNE1sq,0.D0,MNE1sq,U,T,
     -   qudMass(qud1)**2,qudMass(qud1)**2,sqeMass(qud1)**2,
     -   sqeMass(qud1)**2)
        iint46(qud1) = Dget(S,0.D0,T,MNE1sq,0.D0,MNE1sq,
     -   qudMass(qud1)**2,qudMass(qud1)**2,qudMass(qud1)**2,
     -   sqeMass(qud1)**2)
        iint47(qud1) = Dget(MNE1sq,S,0.D0,T,MNE1sq,0.D0,
     -   qudMass(qud1)**2,sqeMass(qud1)**2,sqeMass(qud1)**2,
     -   sqeMass(qud1)**2)
        iint48(qud1) = Dget(MNE1sq,0.D0,0.D0,MNE1sq,U,S,
     -   qudMass(qud1)**2,sqeMass(qud1)**2,sqeMass(qud1)**2,
     -   sqeMass(qud1)**2)
	enddo

	do quu1 = 1, 3
        iint13(quu1) = Cget(0.D0,MNE1sq,U,quuMass(quu1)**2,
     -   quuMass(quu1)**2,squMass(quu1)**2)
        iint14(quu1) = Cget(0.D0,T,MNE1sq,quuMass(quu1)**2,
     -   quuMass(quu1)**2,squMass(quu1)**2)
        iint15(quu1) = Cget(MNE1sq,0.D0,T,quuMass(quu1)**2,
     -   squMass(quu1)**2,squMass(quu1)**2)
        iint17(quu1) = Dget(0.D0,0.D0,MNE1sq,MNE1sq,S,U,
     -   quuMass(quu1)**2,quuMass(quu1)**2,quuMass(quu1)**2,
     -   squMass(quu1)**2)
        iint18(quu1) = Dget(0.D0,MNE1sq,0.D0,MNE1sq,U,T,
     -   quuMass(quu1)**2,quuMass(quu1)**2,squMass(quu1)**2,
     -   squMass(quu1)**2)
        iint19(quu1) = Dget(S,0.D0,T,MNE1sq,0.D0,MNE1sq,
     -   quuMass(quu1)**2,quuMass(quu1)**2,quuMass(quu1)**2,
     -   squMass(quu1)**2)
        iint20(quu1) = Dget(MNE1sq,S,0.D0,T,MNE1sq,0.D0,
     -   quuMass(quu1)**2,squMass(quu1)**2,squMass(quu1)**2,
     -   squMass(quu1)**2)
        iint21(quu1) = Dget(MNE1sq,0.D0,0.D0,MNE1sq,U,S,
     -   quuMass(quu1)**2,squMass(quu1)**2,squMass(quu1)**2,
     -   squMass(quu1)**2)
        iint22(quu1) = Cget(0.D0,MNE1sq,U,quuMass(quu1)**2,
     -   quuMass(quu1)**2,sqvMass(quu1)**2)
        iint23(quu1) = Cget(0.D0,T,MNE1sq,quuMass(quu1)**2,
     -   quuMass(quu1)**2,sqvMass(quu1)**2)
        iint24(quu1) = Cget(MNE1sq,0.D0,T,quuMass(quu1)**2,
     -   sqvMass(quu1)**2,sqvMass(quu1)**2)
        iint26(quu1) = Dget(0.D0,0.D0,MNE1sq,MNE1sq,S,U,
     -   quuMass(quu1)**2,quuMass(quu1)**2,quuMass(quu1)**2,
     -   sqvMass(quu1)**2)
        iint27(quu1) = Dget(0.D0,MNE1sq,0.D0,MNE1sq,U,T,
     -   quuMass(quu1)**2,quuMass(quu1)**2,sqvMass(quu1)**2,
     -   sqvMass(quu1)**2)
        iint28(quu1) = Dget(S,0.D0,T,MNE1sq,0.D0,MNE1sq,
     -   quuMass(quu1)**2,quuMass(quu1)**2,quuMass(quu1)**2,
     -   sqvMass(quu1)**2)
        iint29(quu1) = Dget(MNE1sq,S,0.D0,T,MNE1sq,0.D0,
     -   quuMass(quu1)**2,sqvMass(quu1)**2,sqvMass(quu1)**2,
     -   sqvMass(quu1)**2)
        iint30(quu1) = Dget(MNE1sq,0.D0,0.D0,MNE1sq,U,S,
     -   quuMass(quu1)**2,sqvMass(quu1)**2,sqvMass(quu1)**2,
     -   sqvMass(quu1)**2)
	enddo
	end

