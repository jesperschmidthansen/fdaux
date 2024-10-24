#include <octave/oct.h>
#include "fdmisc.h"

#define HELP ("\n")


DEFUN_DLD(fdcplb2, args, ,HELP){
	octave_value_list retval;
	
	NDArray f(args(0).array_value());
	NDArray b(args(1).array_value());

	Matrix ux(args(2).matrix_value());
	Matrix uy(args(3).matrix_value());

	RowVector cidy(args(4).row_vector_value());
	RowVector cidx(args(5).row_vector_value());

	const int lenc = cidy.numel();

	for ( int i=0; i<lenc; i++ ){
		int i1 = cidy(i)-1;  
		int i2 = cidx(i)-1; 	
		for ( int k = 0; k<9; k++ ){
			f(i1, i2, k) = b(i1, i2, k);  
		}
		ux(i1,i2) = 0.0f; uy(i1, i2) = 0.0f;
	}

	retval.append(f);
	retval.append(ux);
	retval.append(uy);

	return retval;	
}
		

