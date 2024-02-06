
function cmat = fdcmat2d(ngrids, spacings)


	ngx = ngrids(1); ngy = ngrids(2);
	dx = spacings(1); dy = spacings(2); 

	ngrids2 = ngy*ngx;
	cmat = sparse(ngrids2, ngrids2);

	dx2 = dx^2; dy2 = dy^2;
	idx2 = 1.0/dx^2; idy2 = 1.0/dy2;
	c = 2*(dy2+dx2)/(dx2*dy2);
	
	m=0;
  	for n=1:ngrids2

    	if rem(n, ngx)==0
      		m = m + 1;
    	endif
    
    	if ( n<ngx || n>ngrids2-ngx || rem(n-1,ngx)==0 || rem(n, ngx)==0 )
      		cmat(n,n) = 1;
		else
      		indices = [n-ngx, n-1, n, n+1, n+ngx];
      		cmat(n, indices) = [idy2 idx2 -c  idx2 idy2];
		endif
               
	endfor

endfunction
