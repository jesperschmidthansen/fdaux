

function [sol status] = fdpois2d(w, grdspace, method, argmethod)
	
	switch (method)
		case "sor"
			phi = argmethod{1};
			relxfac = argmethod{2}; 
			err = argmethod{3};	
	
			[sol, it, status] = fdsor2d(phi, w, grdspace, relxfac, err);
				
		case "direct"	
			[ngrdy, ngrdx] = size(w);

			A = fdcmat2d([ngrdy, ngrdx], grdspace); 
			W = fdm2v2d(w);
			
			sol = fdv2m2d(A\W, [ngrdy, ngrdx]);
			status = 1;

		case "spectral"
			[ngrdy, ngrdx] = size(w);
			if ngrdy != ngrdx 
				error("Spectral method only accepts square domains");
			end
					
			[sol ksq] = fdspec2d(w, ngrdx, grdspace) 			

		otherwise
			error("Not a valid method");
	end

end
