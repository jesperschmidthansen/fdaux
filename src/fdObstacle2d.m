
classdef fdObstacle2d < fdObstacle

	methods
		
		function this = fdObstacle2d(xpos, ypos)

			this.xpos = xpos; this.ypos = ypos;
  
		end


		function value = correct(this, value)

			[ngy ngx] = size(value);

			ypos = this.ypos; xpos = this.xpos;
	
			value(ypos(1):ypos(2), xpos(1):xpos(2)) = 0;

			value(ypos(1):ypos(2), xpos(1)-1) = value(ypos(1):ypos(2), xpos(1)-2);
			value(ypos(1):ypos(2), xpos(2)+1) = value(ypos(1):ypos(2), xpos(2)+2);

			value(ypos(1)-1,xpos(1):xpos(2))=value(ypos(1)-2,xpos(1):xpos(2));
			value(ypos(2)+1,xpos(1):xpos(2))=value(ypos(2)+2,xpos(1):xpos(2));

		end


	end

end
