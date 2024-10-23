#include <octave/oct.h>

#define HELP ("\n")


DEFUN_DLD(fdcplb2, args, ,HELP){
	int i, i1, i2;
	octave_value_list retval;
	
	NDArray f(args(0).array_value());
	NDArray b(args(1).array_value());

	Matrix ux(args(2).matrix_value());
	Matrix uy(args(3).matrix_value());

	RowVector cidy(args(4).row_vector_value());
	RowVector cidx(args(5).row_vector_value());

	int lenc = cidy.numel();
	const double *ptr_cy = cidy.fortran_vec();
	const double *ptr_cx = cidx.fortran_vec();
	
	for ( i=0; i<lenc; i++ ){
		i1 = (int)ptr_cy[i] - 1; 
		i2 = (int)ptr_cx[i] - 1;	
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
		

