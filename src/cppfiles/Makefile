
CC    = mkoctfile
FLAGS = -v -Wall -W -fopenmp 
OBJECTS= fdcds2d.oct fdfrwd2d.oct fdbckwd2d.oct \
		 fdscnd2d.oct \
		 fdsor2d.oct \
		 fdv2m2d.oct fdm2v2d.oct \
		 fdcplb1.oct fdcplb2.oct

all: $(OBJECTS)

%.oct:%.cpp
	$(CC) $(FLAGS) $<

clean:
	rm *.oct
