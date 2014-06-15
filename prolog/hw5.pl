/* CS381 Homework 5 */

/*  Authored by Li Li, Heng Wang ,Xinyang Chen */


/*  Exercise 1 */

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

/* (a) */

schedule(N,P,T):- enroll(N,C),when(C,T),where(C,P).

/* (b) */
usage(P,T):- where(C,P),when(C,T).

/* (c) */
conflict(X,Y):- where(X,P),where(Y,P),when(X,T),when(Y,T),X\=Y.

/* (d) */
meet(X,Y):- enroll(X,C),enroll(Y,C),X\=Y.
meet(X,Y):- schedule(X,P,T1),schedule(Y,P,T2),T1 =:= T2+1,X\=Y.
meet(X,Y):- schedule(X,P,T1),schedule(Y,P,T2),T1 =:= T2-1,X\=Y.

/* Exercise 2 */

/* (a) */
rdup([],[]).
rdup([X],[X]).
rdup([X,X|M],L):- rdup([X|M],L).
rdup([X,Y|M],[X|L]):- rdup([Y|M],L),X\=Y. 

/* (b) */
flat([],[]).
flat([X|L],M):- append(X,L,N),flat(N,M).
flat([X|L],[X|M]):- \+ is_list(X), flat(L,M).

/* (c) */

project1(_,[],[]).
project1([],_,[]).
project1(1,[X|_],X):- !.
project1(N,[_|L],X):- \+ is_list(N), N1 is N-1,project1(N1,L,X).
project1([N1|N],L,[X1|XR]):- project1(N1,L,X1),project1(N,L,XR).
project(A,B,M):-project1(A,B,L),flat(L,M).




