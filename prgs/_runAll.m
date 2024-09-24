
clear all
files = glob("run*.m");
for n=1:length(files)
	printf("Running %s ...\n", files{n,1}); fflush(stdout);
	run(files{n,1});
end


