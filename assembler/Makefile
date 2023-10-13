all: lex.yy.c y.tab.c
	gcc main.c -lm y.tab.c lex.yy.c

y.tab.c:
	yacc main.y

lex.yy.c:
	lex main.l

.PHONY: clean
clean:
	rm -f y.tab.c lex.yy.c
