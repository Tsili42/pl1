% ! mesw tou seect mporw synexws na meiwnw to megethos ths reversed?
% aksizei?!
distJ(_, [], 0, _, _).
distJ(A, [RA|RB], D, I, J):-
    ( RA >= A,
      D is J - I
    ; RA < A,
      NEW_J is J - 1,
      distJ(A, RB, D, I, NEW_J)
    ).

maxDist([], _, _, A, _, A).
maxDist([A|B], X, N, D, I, Prev):-
    distJ(A, X, D, I, N),
    NEW_I is I + 1,
    ( D > Prev,
      maxDist(B, X, N, D, NEW_I, D)
    ; D =< Prev, maxDist(B, X, N, Prev, NEW_I, Prev)
    ).

skitrip(Heights, N, D):-
    reverse(Heights, X),
    maxDist(Heights, X, N, D, 1, 0).
