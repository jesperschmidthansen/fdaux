
/*****************************************************************
 * vectomat.cpp      : Vector to matrix conversion 
 * Author            : Jesper Schmidt Hansen
 * Last modified     : 15/1-2018 
 ***************************************************************/

#include <octave/oct.h>

#define HELP ("usage:  B = fdv2m2d(a, grids) \n")

DEFUN_DLD(fdv2m2d, args, , HELP){
  octave_value_list retval;

  if ( args.length() != 2 ) {
    error("vectomat: Incorrect input\n");
    return retval;
  }

  ColumnVector a( args(0).vector_value() );
  ColumnVector grids (args(1).vector_value() );

  size_t nc = (unsigned)grids(0);
  size_t nr = (unsigned)grids(1); //args(2).int_value() );
  
  Matrix B(nr, nc);

  for ( size_t i=0; i<nr; i++ ){
    for ( size_t j=0; j<nc; j++ ){
      size_t n = i*nc + j;
      B(i,j) = a(n);
    }
  }
  
  retval.append(B);
 
  return retval;
}

