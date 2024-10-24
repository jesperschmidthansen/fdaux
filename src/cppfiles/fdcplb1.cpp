#include <octave/oct.h>

#define HELP ("\n")

DEFUN_DLD(fdcplb1, args, ,HELP){
	octave_value_list retval;
	
	NDArray f(args(0).array_value());
	NDArray b(f.dims(), 0.0f);
	RowVector cidy(args(1).row_vector_value());
	RowVector cidx(args(2).row_vector_value());

	const int lenc = cidy.numel();

	const int dirvec[9]= {0,5,6,7,8,1,2,3,4};

	for ( int i=0; i<lenc; i++ ){
		int i1 = cidy(i)-1;  
		int i2 = cidx(i)-1; 	
		for ( int k =0 ; k<9; k++ )
			b(i1, i2, k) =f(i1, i2, dirvec[k]);
	}

	retval.append(b);

	return retval;	
}
		

