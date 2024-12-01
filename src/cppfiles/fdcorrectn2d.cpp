#include <octave/oct.h>
#include <stdio.h>

#define HELP ("Usage:  phi = fdcorrectn2d(phi, obstacle, idxi, idxj, nobjgrd)\n")

DEFUN_DLD(fdcorrectn2d, args, ,HELP){
	octave_value_list retval;

	if ( args.length() != 5 ) {
		error("fdcorrectn2d: Incorrect input\n");
		return retval;
	}

	Matrix phi(args(0).matrix_value());
	Matrix obstacle(args(1).matrix_value());
	RowVector idxi(args(2).vector_value());
	RowVector idxj(args(3).vector_value());
	unsigned int nobjgrds = args(4).int_value();
	
	size_t ngrdx = phi.cols(); size_t ngrdy = phi.rows();

	for (  unsigned int n=0; n<nobjgrds; n++ ){
		idxi(n) = idxi(n)-1; 
		idxj(n) = idxj(n)-1;
	}

	for ( unsigned int n=0; n<nobjgrds; n++){

		// Interior values 
		phi(idxi(n), idxj(n))=0;	

		// Then boundary values  
		if ( idxi(n) > 1 && idxi(n) < ngrdy - 2 ){
			if ( obstacle(idxi(n)-1, idxj(n)) == 0 )
				phi(idxi(n)-1, idxj(n)) = phi(idxi(n)-2, idxj(n));
		
			if ( obstacle(idxi(n)+1, idxj(n)) == 0 )
				phi(idxi(n)+1, idxj(n)) = phi(idxi(n)+2, idxj(n));
		}
		if ( idxj(n) > 1 && idxj(n) < ngrdx - 2) {
			if ( obstacle(idxi(n), idxj(n)-1) == 0 )
				phi(idxi(n), idxj(n)-1) = phi(idxi(n), idxj(n)-2);
			
			if ( obstacle(idxi(n), idxj(n)+1)==0 )
				phi(idxi(n), idxj(n)+1) = phi(idxi(n), idxj(n)+2);
		}			
	
	}

	retval.append(phi);

	return retval;

}
