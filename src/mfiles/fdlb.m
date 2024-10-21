
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

			# Drift
			for i=1:nflows 
				f.value(:,:,i) = circshift(f.value(:,:,i), [this.cys(i), this.cxs(i)]);
			end 
			
			bndry = zeros(ngrdy, ngrdx, nflows); 
			for i=1:lenc		
				bndry(cidy(i),cidx(i),:) = f.value(cidy(i), cidx(i), [1,6,7,8,9,2,3,4,5]);
			end

		   # Calculate fluid variables
			rho = sum(f.value,3);

			ux = zeros(ngrdy, ngrdx); uy = zeros(ngrdy, ngrdx);
			for i=1:nflows
				ux = ux + this.cxs(i)*f.value(:,:, i);
				uy = uy + this.cys(i)*f.value(:,:, i);
			end

			ux = ux./rho; uy = uy./rho;
			
			feq = zeros(ngrdy, ngrdx, nflows);	
			# Calculate eq. distribution - here dx/dt = 1
			for i=1:nflows
				dotcu = this.cxs(i)*ux + this.cys(i)*uy;
				dotuu = ux.^2 + uy.^2;
				feq(:,:,i) = this.weights(i)*rho.*(1 + 3*dotcu + 9/2*dotcu.^2 - 3/2*dotuu );
			end
			
			f.value = f.value - (f.value - feq)/this.tau;
			
			for i=1:lenc
				f.value(cidy(i), cidx(i), :) = bndry(cidy(i), cidx(i), :);
				ux(cidy(i), cidx(i))=uy(cidy(i), cidx(i))=0;
			end 
		end

	end

end


