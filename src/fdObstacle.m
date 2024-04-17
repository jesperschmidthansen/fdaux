
classdef fdObstacle < handle

        properties
                # Obstacle position (intervals) 
                xpos; ypos; zpos;

				# Dimension
				ndim;
       	end

        methods
				
			function disp(this)
				
				printf("%d %d\n", xpos(1), xpos(2));
				if ndim > 1
					printf("%d %d\n", ypos(1), ypos(2));
				end
				if ndim > 2
					printf("%d %d\n", zpos(1), zpos(2));
				end
			end	

		end

end
