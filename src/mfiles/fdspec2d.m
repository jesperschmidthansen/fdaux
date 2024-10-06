
function [sol ksq] = fdspec2d(phi, ngrd, dx, ksq) 
	
	if nargin == 3
		lbox = ngrd*dx;
		k = 2*pi/lbox.*[ [0:ngrd/2-1], [-ngrd/2:-1] ]';
    	[KX, KY] = meshgrid(k,k);
        
    	ksq = -(KX.^2 + KY.^2);
         
		if ( abs(ksq(1,1)) < 1e-6 )
                 ksq(1 , 1) = 1 ;
		end
	end	
	
    sol = real(ifft2(fft2(phi)./ksq));

end


