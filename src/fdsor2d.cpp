//
// Optimization: Use Fortran arrays
// 
 
#include <octave/oct.h>

#define HELPTXT "Usage: [solution, niter, status]=fdsor2d(phi, w, dx, relxfac, errmax)"				


DEFUN_DLD(fdsor2d, args, , HELPTXT){

	octave_value_list retval;

	Matrix phi(args(0).matrix_value());
	Matrix phiprev(args(0).matrix_value());
	Matrix W(args(1).matrix_value());
	RowVector spacings(args(2).vector_value());

	const double relaxfac(args(3).scalar_value());
	const double errmax(args(4).scalar_value());
	
	const int ngrdx = phi.columns(); // x-direction - column wise 
	const int ngrdy = phi.rows();    // y-direction - row wise
	
	const double dx = spacings(0); const double dy = spacings(1);
	const double dx2 = dx*dx; const double dy2 = dy*dy;
	const double dxpdy = 2.0*(dx2 + dy2);
	const double prefac1 = -(dx*dy)*(dx*dy)/dxpdy;
	const double prefac2 = 1.0/dxpdy;

	const int maxiter = 1000;

	int niter = 0;
	int status = 0;
	while (1){
			
		double err = 0.0;
		for ( int j=1; j<ngrdy-1; j++ ){
			for ( int i=1; i<ngrdx-1; i++ ){
				double a = dx2*(phi(j+1,i) + phi(j-1,i));
				double b = dy2*(phi(j,i+1) + phi(j,i-1));
				phi(j,i) = prefac1*W(j,i) + prefac2*(a + b); 	

				a = phi(j,i)-phiprev(j,i); err += a*a;
			 }
		}
		
		niter++; 
		if ( niter > maxiter ) break; 
		
		if ( sqrt(err/(ngrdx*ngrdy)) < errmax ) { status = 1; break; }
	
		for ( int j=1; j<ngrdy-1; j++ ){
			for ( int i=1; i<ngrdx-1; i++ ){
				phi(j,i) = phiprev(j,i) + relaxfac*(phi(j,i) - phiprev(j,i)); 	
				phiprev(j,i) = phi(j,i);
			}
		}

	}

	retval.append(phi);	retval.append(niter); retval.append(status);

	return retval;
}

