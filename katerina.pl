   read_input(File, Heights, N) :-
    open(File, read, Stream),
    read_line(Stream, [N]),
    read_line(Stream, Heights).

/*
 * An auxiliary predicate that reads a line and returns the list of
 * integers that the line contains.
 */
read_line(Stream, List) :-
    read_line_to_codes(Stream, Line),
    ( Line = [] -> List = []
    ; atom_codes(A, Line),
      atomic_list_concat(As, ' ', A),
      maplist(atom_number, As, List)
    ).

leftProgressive(_, Same, Same, _, L, L, Li, Li).
leftProgressive([A|B], I, N, Prev, L1, L, Li1, LIndex):-
    New_I is I + 1,
    ( A < Prev,
      append([A], L1, Lminus),
      append([I], Li1, L1minus),
      New_Prev is A,
      leftProgressive(B, New_I, N, New_Prev, Lminus, L, L1minus, LIndex),!
    ; A >= Prev, leftProgressive(B, New_I, N, Prev, L1, L, Li1, LIndex),!
    ).

rightProgressive(_, 0, _, R, R, Ri, Ri).
rightProgressive([A|B], J, Prev, R1, R, Ri1, RIndex):-
    New_J is J - 1,
    ( A > Prev,
      append([A], R1, Rminus),
      append([J], Ri1, R1minus),
      New_Prev is A,
      rightProgressive(B, New_J, New_Prev, Rminus, R, R1minus, RIndex),!
    ; A =< Prev, rightProgressive(B, New_J, Prev, R1, R, Ri1, RIndex),!
    ).

findDist(_, [], _, _, _, 0).
findDist(Val, [A|B], [AI|BI], Index, Prev, Dist):-
    (   Val =< A,
        findDist(Val, B, BI, Index, AI, Dist),!
    ;   Val > A,
        Dist is Prev - Index
    ).


minDist([], _, [], _, A, A).
minDist([YL|RL], R, [A|B], Rindex, CurDist, Dist):-
    findDist(YL, R, Rindex, A, 0, New_D),
    ( New_D > CurDist,
      minDist(RL, R, B, Rindex, New_D, Dist),!
    ; New_D =< CurDist,
      minDist(RL, R, B, Rindex, CurDist, Dist),!
    ).


skitrip(File, Dist):-
    read_input(File, Heights, N),
    nth1(1, Heights, P),
    New_P is P + 1,
    leftProgressive(Heights, 1, N, New_P, [], L0, [], Lindex),
    reverse(L0, L),
    reverse(Lindex, LIndex),
    reverse(Heights, Rev),
    rightProgressive(Rev, N, 0, [], R, [], RIndex),
    minDist(L, R, LIndex, RIndex, 0, Dist).
