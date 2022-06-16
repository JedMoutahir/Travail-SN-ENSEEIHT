#!/bin/sh
# PM, le 31/3/21

export PATH=.:$PATH
rep=`pwd`
res=OK

gcc -Wall miniminishell.c -o ms
ms < a/bar > foo

if [ ! \( -f foo \) ] ; then 
res=KO
fi

grep -v '>>>' foo | grep -v 'Salut'| sort > a/b/core
sort lala.o > a/s
diff a/b/core  a/s
if [ $? -ne 0 ] ; then 
res=KO
fi

if [ \( `grep '^>>>' foo | wc -l` -lt 3 \) -o  \( `grep 'SUCCES' foo | wc -l` -lt 2 \) -o \
\( `grep 'ECHEC' foo | wc -l` -lt 1 \) ] ; then
res=KO
fi

if [ `grep '^Salut' foo | wc -l` -ne 1 ] ; then
res=KOOK
fi

echo $res
