
:- op(800,fx,if). % unary operator
:- op(700,xfx,then). % non associative operator
:- op(300,xfy,or). % righ-associative operator
:- op(200,xfy,and). % lower precedence == higher priority

fact(hall_wet).
fact(toilet_wet).
fact(window_closed).

fact(a).
fact(b).
fact(c).

if hall_wet and kitchen_dry then leak_in_toilet.
if hall_wet and toilet_wet then kitchen_problem.
if window_closed or no_rain then no_water_entered.
if kitchen_problem and no_water_entered then leak_in_kitchen.

if a and b and c then d.

if x or d or y then e.

% forward chaining (slides version)

forward(L):-forward([],L).

forward(L1,L2) :- new_fact(L1,P), !, forward([P|L1],L2).
forward(L1,L1).

new_fact(L,P) :- not_yet_seen(L,P).
not_yet_seen(L,P) :- fact(P), \+ member(P,L).
not_yet_seen(L,P) :- if Conditions then P, check(L, Conditions), \+ member(P,L).

check(L,C1 and C2) :- member(C1,L), member(C2,L).
check(L,C1 or C2) :- member(C1,L); member(C2,L).


isTrue(P) :- fact(P).
isTrue(P) :- if Conditions then P, isTrue(Conditions).
isTrue(C1 and C2) :- isTrue(C1), isTrue(C2).
isTrue(C1 or C2) :- isTrue(C1); isTrue(C2).