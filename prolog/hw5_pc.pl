/* 
CS381 Homework 5 
By Chao Peng & Canhua Huang
*/

/* Exercise 1. Database Application*/
when(275,10).
when(261,12).
when(381,11).
when(398,12).
when(399,12).

where(275,owen102).
where(261,dear118).
where(381,cov216).
where(398,dear118).
where(399,cov216).

enroll(mary,275).
enroll(john,275).
enroll(mary,261).
enroll(john,381).
enroll(jim,399).
/*enroll(jim,398).*/

schedule(X,P,T):-enroll(X,Z),where(Z,P),when(Z,T).

usage(P,T):-where(S,P),when(S,T).

conflict(X,Y):-when(X,T),when(Y,T),where(X,P),where(Y,P),X\=Y.

/*there is a conflict*/
/*meet(X,Y):-conflict(SX,SY),enroll(X,SX),enroll(Y,SY).*/
/*in the same subject*/
meet(X,Y):-enroll(X,S),enroll(Y,S),X\=Y.

/*back to back & no repetition*/
/*meet(X,Y):-enroll(X,SX),enroll(Y,SY),where(SX,P),where(SY,P),when(SX,TX),when(SY,TY),TX=:=TY+1.*/
meet(X,Y):-enroll(X,SX),enroll(Y,SY),where(SX,P),where(SY,P),when(SX,TX),when(SY,TY),TX=:=TY-1.

/* Exercise 2 */
/*(a)*/
/*there is repitition result is too long*/
rdup([],[]).
rdup(L,M):-append(L1,[X|L2],L),append(L1,L2,L3),member(X,L3),rdup(L3,M).
rdup([X|L],[X|M]):-not(member(X,L)),rdup(L,M).

/*(b)*/
flat([],[]).
flat([X|L],M):-append(X,L,W),flat(W,M).
flat([X|L],[X|M]):-not(append(X,[],X)),flat(L,M).

/*(c)*/
/*using length*/
project([],_,[]).
project([X|N],E,L):-length(E,C),X>C,project(N,E,L).
project([X|N],E,[R|L]):-length(E,C),not(X>C),X>0,I is X-1,append(E1,[R|_],E),length(E1,I),project(N,E,L).
project([X|N],E,L):-not(X>0),project(N,E,L).
/*usually useless*/

