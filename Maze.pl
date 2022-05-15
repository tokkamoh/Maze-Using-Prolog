:-use_module(library(lists)).

move(gateA,gateB).
move(gateA,gateG).
move(gateB,gateC).
move(gateB,gateH).
move(gateG,gateL).
move(gateG,gateF).
move(gateL,gateS).
move(gateC,gateD).
move(gateH,gateO).
move(gateD,gateJ).
move(gateD,gateI).
move(gateI,gateP).
move(gateP,gateQ).
move(gateJ,gateR).
move(gateR,hall).

move(fromNone,gateK).
move(fromNone,gateE).
move(fromNone,gateN).
move(fromNone,gateM).


move(gateS,none).
move(gateQ,none).
move(gateF,none).
move(gateO,none).

goal(hall).

% FIRST SOLUTION WITH OPEN AND CLOSED LISTS

path([],_,_):-
    write('No solution'),nl,!,
    false. % return false when no solution

path([[Goal,Parent] | _], Closed, Goal):-
    write('A solution is found'), nl ,
    printsolution([Goal,Parent],Closed),!.

path(Open, Closed, Goal):-
    removeFromOpen(Open, [State, Parent], RestOfOpen),
    getchildren(State, Open, Closed, Children),
    append(Children , RestOfOpen, NewOpen), %to be appended in a DFS way.
    path(NewOpen, [[State, Parent] | Closed], Goal).

getchildren(State, Open ,Closed , Children):-
    bagof(X, moves( State, Open, Closed, X), Children), ! .

getchildren(_,_,_, []).

removeFromOpen([State|RestOpen], State, RestOpen).

moves( State, Open, Closed,[Next,State]):-
    move(State,Next).% will not use member to be able to go back to the previous step if got to an end path.

    % \+ member([Next,_],Open),!,
    % \+ member([Next,_],Closed),!.

printsolution([State, null],_):-
    write(State).
    % write(" -> ").

printsolution([State, Parent], Closed):-
    member([Parent, GrandParent], Closed),
    printsolution([Parent, GrandParent], Closed),
    write(" -> "),
    write(State).

goSolveTheMaze(Start, Goal) :-
    path([[Start,null]],[],Goal).


% SECOND SOLUTION WITHOUT OPEN AND CLOSED LISTS

myPrint([H]):-
    write(H).

myPrint([H|T]):-
    write(H),
    write(' -> '),
    myPrint(T).


depthFirst(Node, _, Path):-
    goal(Node),!,
    myPrint(Path),
    write(' -> '),
    write(Node).


depthFirst(Node, Goal,Path):-
    move(Node,NextNode),
    % \+member(NextNode, Path), !,
    append(Path, [Node], NewPath),
    depthFirst(NextNode,Goal,NewPath).

solveMaze(Start, Goal,Path):-
   % goal(Start),!,
   depthFirst(Start, Goal,Path).

goSolve(Start,Goal):-
    solveMaze(Start,Goal,[]),!.


