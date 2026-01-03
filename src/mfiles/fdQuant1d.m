
classdef fdQuant1d < fdQuantity 


	properties 
 		# Grid dimensions
 		ngrd; 
			
		# Grid spacings
		dx;
			
		# Derivative
		ddx; d2dx2;
	end

	methods  

		function this = fdQuant1d(ngrids, spacing, boundaries)
			
			if nargin==0
				this;
			elseif nargin>=2
				this.ngrd = ngrids; this.dx = spacing;
				this.value = this.rhs = zeros(1, ngrids);
			end

			if nargin==3
				if ( isstring(boundaries)!=0 || length(boundaries)!=2 )
					error("Boundary specifications not valid");
				end
				this.bcs = boundaries;
			end

		end

		function retval = calcddx(this, method)
			
			this.ddx = zeros(1, this.ngrd);
			n = this.ngrd; idx = 1./this.dx;

			if nargin==1 #Default is central difference
				this.ddx(2:n-1) = (this.value(1:n-2)-this.value(3:n)).*0.5*idx;
			else 
				switch(method)
					case "central"
                    	this.ddx(2:n-1) = (this.value(1:n-2)-this.value(3:n)).*0.5*idx;
					case "forward"
                    	this.ddx(1:n-1) = (this.value(2:n)-this.value(1:n-1)).*idx;
					case "backward"
						this.ddx(2:n) =  (this.value(2:n)-this.value(1:n-1)).*idx;
					otherwise
						error("Invalid method");        
				end 
			end

			if this.bcs(1) == 'p'
				if (nargin == 2 && strcmp(method, "central")!=0 )
					method
					error("Only central difference support for periodic bcs");
				end
				this.ddx(1) = (this.value(2) - this.value(n)).*0.5*this.dx;
				this.ddx(n) = (this.value(1) - this.value(n-1)).*0.5*this.dx;
			end

			retval = this.ddx;
		end 
		
		function retval = calcd2dx2(this)
			n = this.ngrd;		
			
			this.d2dx2 = zeros(1, n);

			this.d2dx2(2:n-1) = this.value(1:n-2) - 2*this.value(2:n-1) + this.value(3:n);
 
			if this.bcs(1) == 'p'
				this.d2dx2(1) = this.value(2) - 2.0*this.value(1) + this.value(n);
				this.d2dx2(end) = this.value(end-1) - 2.0*this.value(end) + this.value(1); 
			end

			this.d2dx2 = this.d2dx2./(this.dx^2);
			retval = this.d2dx2;
		end

		function retval = laplace(this)
			
			retval = this.calcd2dx2();
				
		end

		function retval = grad(this, method='central')
			retval = this.calcddx(method);
		end

		function applybcs(this)
				
			for n=1:2                       

				if this.bcs(n)=='n' 
					if n==1
						this.value(1)= this.value(2);
					elseif n==2 
						this.value(end) = this.value(end-1);
					endif                           
				endif
				
			endfor

		end

		function update(this)
				this.pvalue = this.value;
				this.value = this.nvalue;               

				this.applybcs();        
		end

	end	

end
