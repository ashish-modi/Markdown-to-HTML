final.out: bsn.tab.c lex.yy.c
	gcc bsn.tab.c lex.yy.c -o final.out

lex.yy.c:lexx.l bsn.tab.h
	flex lexx.l

bsn.tab.c:bsn.y
	bison -d bsn.y

bsn.tab.h:bsn.y
	bison -d bsn.y
