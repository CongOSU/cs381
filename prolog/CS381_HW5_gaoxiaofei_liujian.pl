
/* 
Name: Gao Xiaofei & Liu Jian
CS381
Homework 5 

Exercise 1 
*/

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
/* 1 - (a) */
schedule(X,P,T) :- enroll(X,Y), where(Y,P),when(Y,T).
/* 1 - (b) */
usage(P,T) :- where(X,P),when(X,T).
/* 1 - (c) */
conflict(X,Y) :- where(X,P),when(X,T),where(Y,P),when(Y,T),X\=Y.
/* 1 - (d) */
meet(A,B) :- enroll(A,Y),enroll(B,Y),A\=B.
/* Back To Back */
meet(A,B) :- schedule(A,P,T1), schedule(B,P,T2),T2 =:= T1 - 1 .
meet(A,B) :- schedule(A,P,T1), schedule(B,P,T2),T2 =:= T1 + 1 .

/* del */
del(X,[],[]).
del(X,[X|L],L).
del([X],[Y|L],[Y|M]) :- del(X,L,M).


/* Exercise 2 */
member(X,[X|_]).
member(X,[_|Y]) :- member(X,Y).

append([],L,L).
append([X|L1], L2, [X|L3]) :- append(L1, L2, L3).

/* 2 - (a) */
rdup([],[]).
rdup([X],[X]).
rdup([X,X|L1],L2) :- rdup([X|L1],L2).
rdup([X,Y|L1],[X|L2]) :- X \= Y, rdup([Y|L1],L2).

/* 2 - (b) */

flat(X,[X]) :- \+ is_list(X).
flat([],[]).
flat([X|L1],L) :- flat(X,Y), flat(L1,L2), append(Y,L2,L).

/* 3 - (c) */

element_at(1,[X|_],X).
element_at(K,[_|L],X) :- K > 1, K1 is K - 1, element_at(K1,L,X).
find([L1|K],Y,X) :- element_at(L1,Y,X1),append([X1],[],X).
find([L1|K],Y,X) :- find(K,Y,X).
project(K,Y,X) :- find(K,Y,X1),append(X1,[],X).
project(K,Y,[X1|X]) :-project(K,Y,X),append(X1,[],X).




