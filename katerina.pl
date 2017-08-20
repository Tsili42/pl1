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

leftProgressive(_, Same, Same, _, L, L, A, A).
leftProgressive(AHeights, I, N, Prev, L1, L, CurList, Lindex):-
    get_assoc(I, AHeights, Value),
    New_I is I + 1,
    ( Value < Prev,
      put_assoc(I, L1, Value, Lminus),
      append(CurList, [I], NewList),
      New_Prev is Value,
      leftProgressive(AHeights, New_I, N, New_Prev, Lminus, L, NewList, Lindex),!
    ; Value >= Prev, leftProgressive(AHeights, New_I, N, Prev, L1, L, CurList, Lindex),!
    ).

rightProgressive(_, 0, _, R, R, A, A).
rightProgressive(AHeights, J, Prev, R1, R, CurList, Rindex):-
    get_assoc(J, AHeights, Value),
    New_J is J - 1,
    ( Value > Prev,
      put_assoc(J, R1, Value, Rminus),
      append(CurList, [J], NewList),
      New_Prev is Value,
      rightProgressive(AHeights, New_J, New_Prev, Rminus, R, NewList, Rindex),!
    ; Value =< Prev, rightProgressive(AHeights, New_J, Prev, R1, R, CurList, Rindex),!
    ).

minDist(_, _, [], _, _, _, A, A).
minDist(L, R, [_|B], [], PortableR, _, CurDist, Dist):-
    minDist(L, R, B, PortableR, PortableR, 0, CurDist, Dist),!.
minDist(L, R, [A|B], [C|D], PortableR, PrevR, CurDist, Dist):-
    get_assoc(A, L, YL),
    get_assoc(C, R, YR),
    /*print(YL),
    print('*'),
    print(YR),*/
    ( YL =< YR,
      /*print('Synexeia'),*/
      minDist(L, R, [A|B], D, PortableR, C, CurDist, Dist),!
    ; YL > YR,
      /*print('Break'),*/
      New_D is PrevR - A,
      ( New_D > CurDist,
        /*print(New_D ),*/
        minDist(L, R, B, PortableR, PortableR, 0, New_D, Dist),!
      ; New_D =< CurDist,
        minDist(L, R, B, PortableR, PortableR, 0, CurDist, Dist),!
      )
    ).


skitrip(File, Dist):-
    read_input(File, Heights, N),
    numlist(1, N, Keys),
    pairs_keys_values(Pairs, Keys, Heights),
    list_to_assoc(Pairs, AHeights),
    empty_assoc(L1),
    nth1(1, Heights, P),
    New_P is P + 1,
    leftProgressive(AHeights, 1, N, New_P, L1, L, [], LIndex),
    empty_assoc(R1),
    rightProgressive(AHeights, N, 0, R1, R, [], RIndex1),
    reverse(RIndex1, RIndex),
    minDist(L, R, LIndex, RIndex, RIndex, 0, 0, Dist).
