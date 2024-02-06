#include <octave/oct.h>

#define HELP ("Usage:  dphidx = fdcds2d(phi, dx, direction)\n")


DEFUN_DLD(fdcds2d, args, ,HELP){
	octave_value_list retval;

	if ( args.length() != 3 ) {
		error("fdcds2d: Incorrect input\n");
		return retval;
	}

	Matrix phi(args(0).matrix_value());
 	double dx(args(1).scalar_value());
   	const std::string dir = args(2).string_value();	
	 
	size_t ngrdx = phi.cols(); size_t ngrdy = phi.rows();

	Matrix dphi(ngrdy, ngrdx, 0.0);
	const double i2dx = 1.0/(2.0*dx);

	if ( strcmp(dir.c_str(), "x")==0 ){
		for ( size_t j=1; j<ngrdy-1; j++ )
			for ( size_t i=1; i<ngrdx-1; i++ ) 
				dphi(j,i) = i2dx*(phi(j, i+1) - phi(j,i-1));
	}
	else if  ( strcmp(dir.c_str(), "y")==0 ){
		for ( size_t i=1; i<ngrdx-1; i++ )
			for ( size_t j=1; j<ngrdy-1; j++ ) 
				dphi(j,i) = i2dx*(phi(j+1, i) - phi(j-1,i));
	}

	retval.append(dphi);

	return retval;
}

