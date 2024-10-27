
##
## From Matias Ortiz  https://www.youtube.com/watch?v=JFWqCQHg-Hs&t=705s
##
classdef fdlb < fdIntegrator
	
	properties
		tau;
		cxs,cys;
		weights; 
	end

	methods		
	
		function this = fdlb(tau=0.6)
			this.tau = tau;
			this.cxs = [0, 0, 1, 1, 1, 0,-1,-1,-1]; 
			this.cys = [0, 1, 1, 0,-1,-1,-1, 0, 1];
			this.weights = [4/9,1/9,1/36,1/9,1/36,1/9,1/36,1/9,1/36]; 
		end

		function [ux, uy, rho] = step(this, f, obstacle) 
		
			[ngrdy, ngrdx, nflows] = size(f.value);
			
			[cidy cidx] = find( obstacle == 1 );
			lenc = length(cidy);  
	
			# Drift (next optimization point)
			for i=1:nflows 
				f.value(:,:,i) = circshift(f.value(:,:,i), [this.cys(i), this.cxs(i)]);
			end 
		
			bndry = fdcplb1(f.value, cidy, cidx);	
			
			[f.value, rho, ux, uy] = fdflowlb(f.value, this.tau);

			[f.value, ux, uy] = fdcplb2(f.value, bndry, ux, uy, cidy, cidx);
	
		end

	end

end


