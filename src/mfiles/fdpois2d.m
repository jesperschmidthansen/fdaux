

function [sol status] = fdpois2d(phi, w, grdspace, method, argmethod, errsor)

	switch (method)
		case "sor"
			[sol, it, status] = fdsor2d(phi, w, grdspace, 1.5, 1.0e-5);
				
		case "direct"	
			[ngrdy, ngrdx] = size(phi);
			
			x = linspace(0, ngrdx*grdspace(1), ngrdx);
			y = linspace(0, ngrdy*gidspace(2), ngrdy);
			[X Y]=meshgrid(x,y);

			A = cmat2d(X,Y);
			W = mattovec(w);
			sol = vectomat(A\W, ngrdy, ngrdx);
			status = 1;

		case "spectral"
						
			
		otherwise
			error("Not a valid method");
	endswitch

endfunction
