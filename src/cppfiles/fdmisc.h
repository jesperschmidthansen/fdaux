#ifndef __MISC_H__
#define __MISC_H__

#define _getidx2d(ri, ci, nrows) (ri + ci*nrows)
#define _getidx3d(ri, ci, pi, nrows, nrc) (ri + ci*nrows + pi*nrc)
#define _getval2d(a, ri, ci, nrows) a[ri + ci*nrows]
#define _getval3d(a, ri, ci, pi, nrows, nrc) a[ri + ci*nrows + pi*nrc]

#endif
