
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

forward :- new_fact(P), !, writeln(P), forward.
forward :- writeln('No more facts').
new_fact(P) :- not_yet_seen(P), assert('$seen'(P)).
not_yet_seen(P) :- fact(P), \+ seenfact(P).
not_yet_seen(P) :- if Conditions then P, \+ seenfact(P), check(Conditions).

seenfact(P) :- clause('$seen'(P),true).

check(C1 and C2) :- seenfact(C1), seenfact(C2).
check(C1 or C2) :- seenfact(C1); seenfact(C2).

isTrue(P) :- fact(P).
isTrue(P) :- if Conditions then P, isTrue(Conditions).
isTrue(C1 and C2) :- isTrue(C1), isTrue(C2).
isTrue(C1 or C2) :- isTrue(C1); isTrue(C2).