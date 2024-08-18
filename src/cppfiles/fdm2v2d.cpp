
/*****************************************************************
 * mattovec.cpp      : Matrix to vector conversion 
 * Author            : Jesper Schmidt Hansen
 * Last modified     : 26-4-2016 
 ***************************************************************/


#include <octave/oct.h>

#define HELP ("usage:  b = fdm2v2d(A) \n")

DEFUN_DLD(fdm2v2d, args, , HELP){
  octave_value_list retval;

  if ( args.length() != 1 ) {
    error("Incorrect input\n");
    return retval;
  }
  
  const Matrix A( args(0).matrix_value() );

  size_t nr = A.rows();
  size_t nc = A.cols();

  ColumnVector b(nr*nc);

  for ( size_t i=0; i<nr; i++ ){
    for ( size_t j=0; j<nc; j++ ){
      size_t n = i*nc + j;
      b(n) = A(i,j);
    }
  }
  
  retval.append(b);
 
  return retval;
}
