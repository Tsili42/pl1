rev([], Z, Z).
rev([H|T], Z, Acc):- rev(T, Z, [H|Acc]).
reverse(A, B):- rev(A, B, []).

distJ1(_, [], 0, _, _).
distJ1([A|B], [RA|RB], D, I, J):-
    ( RA >= A,
      D is J - I
    ; RA < A,
      NEW_J is J - 1,
      distJ1([A|B], RB, D, I, NEW_J)
    ).
distJ(L1, L2, N, D):- distJ1(L1, L2, D, 1, N).

maxDist([], _, _, A, A).
maxDist([A|B], X, N, D, Prev):-
    distJ([A|B], X, N, D),
    ( D > Prev,
      maxDist(B, X, N, D, D)
    ; D =< Prev, maxDist(B, X, N, Prev, Prev)
    ).

skitrip(Heights, N, D):-
    once(reverse(Heights, X)),
    maxDist(Heights, X, N, D, 0).
