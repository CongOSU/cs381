append([], L, L).
append([X|L],L1,[X|L2]) :- append(L,L1,L2).