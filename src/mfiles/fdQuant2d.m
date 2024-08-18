
classdef fdQuant2d < fdQuantity 

	properties (Access=public)
		# Grid dimensions
		ngrdx, ngrdy; 
		
		# Grid spacings
		dx, dy;
		
		# Derivative
		ddx; ddy;
		d2dx2, d2dy2;
	end


	methods  

		function this = fdQuant2d(grids, spacings, boundaries)
			
			if (nargin == 0 )
				this;
			elseif ( nargin >= 2 )

				if ( length(grids) != 2 || length(spacings) != 2 )
					error("Specification of the grid and spacings not valid");
				endif

				this.ngrdx = grids(1); this.ngrdy = grids(2);
				this.dx = spacings(1); this.dy = spacings(2);
				this.value = this.rhs = zeros(this.ngrdy, this.ngrdx);
				
			end
			
			if ( nargin == 3 )
			
				if ( isstring(boundaries) != 0 || length(boundaries) != 4 )
					error("Boundary specification not valid");
				end

				this.bcs = boundaries;
			endif	
		end

		function retval = calcddx(this, method)
			
			if nargin==1 
				this.ddx = fdcds2d(this.value, this.dx, 'x');
			else 
				switch(method)
					case "central"
						this.ddx = fdcds2d(this.value, this.dx, 'x');
					case "forward"
						this.ddx = fdfrwd2d(this.value, this.dx, 'x');
					case "backward"
						this.ddx = fdbckwd2d(this.value, this.dx, 'x');
					otherwise
						error("Invalid method");	
				end 
			end

			if this.bcs(2)=='p' 
				if ( nargin == 2 && strcmp(method, central)!=0 ) 
					error("Only central difference support for periodic bcs");
				endif
				
				this.ddx(:, 1) = (this.value(:,2) - this.value(:,end))./(2*this.dx);
    			this.ddx(:, end) = (this.value(:,1) - this.value(:,end-1))./(2*this.dx);
			end

			retval = this.ddx;
		end

		function retval = calcddy(this, method)
			
			if nargin==1
				this.ddy = fdcds2d(this.value, this.dy, 'y');
			else			
				switch(method)
					case "central"
						this.ddy = fdcds2d(this.value, this.dy, 'y');
					case "forward"
						this.ddy = fdfrwd2d(this.value, this.dy, 'y');
					case "backward"
						this.ddy = fdbckwd2d(this.value, this.dy, 'y');
					otherwise
						error("Invalid method");	
				end 
			end
			
			if this.bcs(1)=='p'
				if ( nargin == 2 && strcmp(method, central)!=0 )
					error("Only central difference support for periodic bcs");
				endif
	
				this.ddy(1,:) = (this.value(2,:) - this.value(end,:))./(2*this.dy);
    			this.ddy(end,:) = (this.value(1,:) - this.value(end-1,:))./(2*this.dy);
			end

			retval = this.ddy;
		end

		function retval = calcd2dx2(this)
			
			this.d2dx2 = fdscnd2d(this.value, this.dx, 'x');

			if this.bcs(2)=='p'
				idx2 = 1.0/(this.dx^2);
				this.d2dx2(:, 1) = (this.value(:,2) - 2*this.value(:,1) + this.value(:,end))*idx2;
			    this.d2dx2(:, end) = (this.value(:,1) - 2*this.value(:,end) + this.value(:,end-1))*idx2;
			end 

			retval = this.d2dx2;
		end

		function retval = calcd2dy2(this)
			
			this.d2dy2 = fdscnd2d(this.value, this.dy, 'y');

			if this.bcs(1)=='p'
				idy2 = 1.0/(this.dy^2);
				this.d2dy2(1,:) = (this.value(2,:) - 2*this.value(1,:) + this.value(end,:))*idy2;
			    this.d2dy2(end,:) = (this.value(1,:) - 2*this.value(end,:) + this.value(end-1,:))*idy2;
			end 
			
			retval = this.d2dy2;
		end

		function retval = laplace(this)
			
			retval = this.calcd2dx2() + this.calcd2dy2();			

		end

		function setvalue(this, value)
			this.value = value*ones(this.ngrdy, this.ngrdx);
			this.value(1,:) = this.value(this.ngrdy, :) = 0; 
			this.value(:,1) = this.value(:,this.ngrdx) = 0;
		end

		function setbcs(this, specifier)
			if ( !ischar(specifier) || length(specifier) != 4 )
				error("Boundary specifications not correct");
			endif
			this.bcs = specifier;
		end

		function applybcs(this)
			
			for n=1:4			
				if this.bcs(n)=='n' 
					if n==1
						this.value(1,:)= this.value(2,:);
					elseif n==2 
						this.value(:,this.ngrdx) = this.value(:,this.ngrdx-1);
					elseif n==3
						this.value(this.ngrdy,:) = this.value(this.ngrdy-1,:);
					else
						this.value(:,1)=this.value(:,2);	
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
