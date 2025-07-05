% Path planner 

decide(S,S,_,[S],0). % procediemnto auxiliar recursivo

decide(IS,GS,Visited,[IS|Plan],Cost)
:- connected(IS,X),
    \+ member(X,Visited),
   current_cost(IS,X,C1),
    decide(X,GS,[X|Visited],Plan,C2),
    Cost is C1 + C2.

decide(IG,GS,Plan)
:- findall(P/C,decide(IG,GS,[IS],P,C)writeln(P/C),L),
   member(Plan/Cost,L),
   \+ (member(P/C,L),C < Cost).


% Uncoment to test with python
:- [topology].

current_cost(_,_,1).