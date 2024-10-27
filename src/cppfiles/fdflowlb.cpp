#include <octave/oct.h>
#include "fdmisc.h"
//#include <omp.h>

#define HELP ("\n")

void calc_rhovel(double *rho, double *ux, double *uy, double *f, double tau, int nr, int nc){
	int i, j, k, id1, id2;
	double feq, dotcu, dotuu; 
	const int nrc = nr*nc;
	const double itau = 1.0/tau;
	const int cxs[9] = {0, 0, 1, 1, 1, 0,-1,-1,-1}; 
	const int cys[9] = {0, 1, 1, 0,-1,-1,-1, 0, 1};
	const double w[9] = {4./9.,1./9.,1./36.,1./9.,1./36.,1./9.,1./36.,1./9.,1./36.}; 

//#pragma omp parallel for private(i, j, k, id1, id2, feq, dotcu, dotuu)
	for ( i=0; i<nr; i++ ){
		for ( j=0; j<nc; j++ ){
			
			id1 = _getidx2d(i, j, nr);
			rho[id1] = 0.0f; ux[id1] = 0.0f; uy[id1] = 0.0f;
			
			for ( k=0; k<9; k++ ){
				id2 = _getidx3d(i, j, k, nr, nrc);			
				rho[id1] += f[id2];
				ux[id1] += cxs[k]*f[id2];
				uy[id1] += cys[k]*f[id2];	
			}
		
			ux[id1] = ux[id1]/rho[id1];
			uy[id1] = uy[id1]/rho[id1];
		
			for ( k=0; k<9; k++ ){
				dotcu = cxs[k]*ux[id1] + cys[k]*uy[id1];
				dotuu = ux[id1]*ux[id1] + uy[id1]*uy[id1];
				id2 = _getidx3d(i, j, k, nr, nrc);			
				feq = w[k]*rho[id1]*(1.0 + 3.0*dotcu + 4.5*dotcu*dotcu - 1.5*dotuu);
				f[id2] = f[id2] - (f[id2]-feq)*itau; 
			}	

		}
	}

}	


DEFUN_DLD(fdflowlb, args, ,HELP){
	octave_value_list retval;
	
	NDArray f(args(0).array_value());
	double tau = args(1).scalar_value();

	// This can be calculated in function
	int nr = f.dim1(); int nc = f.dim2();
	Matrix rho(nr, nc); Matrix ux(nr, nc); Matrix uy(nr, nc);

	double *ptr_f = f.fortran_vec();
	double *ptr_ux = ux.fortran_vec();
	double *ptr_uy = uy.fortran_vec();
	double *ptr_rho = rho.fortran_vec();

	calc_rhovel(ptr_rho, ptr_ux, ptr_uy, ptr_f, tau, nr, nc);

	retval.append(f);
	retval.append(rho); 
	retval.append(ux); retval.append(uy);
	
	return retval;	
}
		

