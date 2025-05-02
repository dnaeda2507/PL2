all: white

white: white.tab.c lex.yy.c
	gcc -o white white.tab.c lex.yy.c -lm

lex.yy.c: white.l white.tab.h
	flex white.l
	
white.tab.c white.tab.h: white.y
	bison -d white.y



clean:
	rm -f white lex.yy.c white.tab.c white.tab.h
