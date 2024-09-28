
clear all
files = glob("run*.m");
for n=1:length(files)
	printf("Running %s ...", files{n,1}); fflush(stdout);
	run(files{n,1});
	printf("Done\n"); fflush(stdout);
end


