    ; A >= Prev, leftProgressive(B, New_I, N, Prev, L1, L),!
    ).

rightProgressive(_, 0, _, R, R).
rightProgressive([A|B], J, Prev, R1, R):-
    New_J is J - 1,
    ( A > Prev,
      put_assoc(J, R1, A, Rminus),
      New_Prev is A,
      rightProgressive(B, New_J, New_Prev, Rminus, R),!
    ; A =< Prev, rightProgressive(B, New_J, Prev, R1, R),!
    ).

minDist([], _, _, [], _, _, _, A, A).
minDist([_|RL], [], PortH, [_|B], [], PortableR, _, CurDist, Dist):-
    minDist(RL, PortH, PortH, B, PortableR, PortableR, 0, CurDist, Dist),!.
minDist([YL|RL], [YR|RR], PortH, [A|B], [C|D], PortableR, PrevR, CurDist, Dist):-
    /*print(YL),
    print('*'),
    print(YR),*/
    ( YL =< YR,!,
      /*print('Synexeia'),*/
      minDist([YL|RL], RR, PortH, [A|B], D, PortableR, C, CurDist, Dist),!
    ; YL > YR,
      /*print('Break'),*/
      New_D is PrevR - A,
      ( New_D > CurDist,!,
        /*print(New_D ),*/
        minDist(RL, PortH, PortH, B, PortableR, PortableR, 0, New_D, Dist),!
      ; New_D =< CurDist,!,
        minDist(RL, PortH, PortH, B, PortableR, PortableR, 0, CurDist, Dist),!
      )
    ).


skitrip(File, Dist):-
    read_input(File, Heights, N),
    nth1(1, Heights, P),
    New_P is P + 1,
    empty_assoc(L1),
    leftProgressive(Heights, 1, N, New_P, L1, L0),
    assoc_to_values(L0, L),
    assoc_to_keys(L0, LIndex),
    reverse(Heights, Rev),
    empty_assoc(R10),
    rightProgressive(Rev, N, 0, R10, R0),
    assoc_to_values(R0, R),
    assoc_to_keys(R0, RIndex),
   /* print(L),
    print(R),
    print(LIndex),
    print(RIndex),*/
    minDist(L, R, R, LIndex, RIndex, RIndex, 0, 0, Dist).
