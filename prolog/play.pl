/* play */

/*
del(X,[],[]).
del(X,[X|L],L).
del(X,[Y|L],[Y,M]):- del(X,L,M). #(a,[a,b],[a,M]), M=del(a,[b],M)=del(a,[b|[]],[b,[]].
M=[b,[]]. Z=[Y,M]=[a,[b,[]]].
*/

del(X,[],[]).
del(X,[X|L],L).
del(X,[Y|L],[Y,M]):- L\=M, del(X,L,M).

story([3,little,pigs]).

member(X,[X|_]).
member(X,[_|Y]):- member(X,Y).