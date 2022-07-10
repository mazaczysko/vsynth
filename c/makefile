all:
	gcc -o ppg ppg.c ppg_data.c -Wall -lm  
run: all
	./ppg | aplay -f U8 -r 20000
