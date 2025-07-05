
:- discontiguous np/4, vp/3, properNoun/3, commonNoun/3.
:- discontiguous pronoun/2, pp/2, preposition/2, adverb/2.
:- discontiguous article/2, verb/2, adjective/2.

:- discontiguous example/2.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
example(1,[the,breeze,is,smelly]).
example(2,[aveiro,is,beautiful]).
example(3,[aveiro,is,a,city]).
example(4,[peter,is,a,man]).
example(5,[the,cats,are,beautiful]).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

sentence --> np(Num,subj), vp(Num).

np(Num,_) --> properNoun(Num).
np(Num,_) --> article(Num), commonNoun(Num).

vp(Num) --> verb(Num), np(_,obj).
vp(Num) --> verb(Num), adjective.

commonNoun(sing) --> [breeze].
commonNoun(sing) --> [city].
commonNoun(sing) --> [man].
commonNoun(plur) --> [men].
commonNoun(sing) --> [cat].
commonNoun(plur) --> [cats].

properNoun(sing) --> [peter].
properNoun(sing) --> [aveiro].

verb(sing) --> [is].
verb(pulr) --> [are].

adjective --> [smelly].
adjective --> [beautiful].

article(sing) --> [the].
article(sing) --> [a].
article(sing) --> [an].

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
example(6,[peter,is,in,aveiro]).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

vp(Num) --> verb(Num), pp.

pp --> preposition, np(_,obj).

preposition --> [in].

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
example(7,[he,is,in,aveiro]).
example(8,[she,loves,him]).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

np(Num) --> pronoun(Num,Func).

verb(plur) --> [love].
verb(plur) --> [loves].

pronoun(sing,subj) --> [i].
pronoun(sing,subj) --> [you].
pronoun(plur,subj) --> [you].
pronoun(sing,subj) --> [he].
pronoun(sing,subj) --> [she].
pronoun(plur,subj) --> [we].
pronoun(plur,subj) --> [they].

pronoun(sing,obj) --> [me].
pronoun(sing,obj) --> [you].
pronoun(plur,obj) --> [you].
pronoun(sing,obj) --> [him].
pronoun(sing,obj) --> [her].
pronoun(plur,obj) --> [them].
pronoun(plur,obj) --> [us].

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
example( 9,[you,give,the,gold,to,me]).
example(10,[you,give,me,the,gold]).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

vp(Num) --> verb(Num), np(_,Obj), np(_,Obj).
vp(Num) --> verb(Num), np(_,Obj), pp.

verb(plur,[np,pp]) --> [give].
verb(plur,[np,pp]) --> [give].
verb(sing,[np,pp]) --> [gives].
verb(sing,[np,pp]) --> [gives].

commonNoun --> [gold].

preposition --> [to].

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
example(11,[they,smell,the,wumpus]).
example(12,[the,wumpus,smells,awful]).
example(13,[peter,smells,like,a,wumpus]).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

verb(plur,[np]) --> [smell].
verb(plur,[adjective]) --> [smell].
verb(plur,[pp]) --> [smell].
verb(sing,[np]) --> [smells].
verb(sing,[adjective]) --> [smells].
verb(sing,[pp]) --> [smells].

adjective --> [awful].

preposition --> [like].

commonNoun --> [wumpus].

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
example(14,[the,cat,is,here]).
example(15,[peter,is,there]).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

vp(Num) --> verb(Num,[adverbe]), adverbe.

adverbe --> [here].
adverbe --> [there].

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
example(16,[the,beautiful,cat,died]).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

vp(Num) --> verb(Num,[]).

np(Num,_) --> article(Num), adjective, commonNoun(Num).

verb(sing) --> [died].

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% examples of incorrect syntax
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
example(17,[peter,are,a,man]).
example(18,[the,cats,is,beautiful]).
example(19,[him,is,beautiful]).
example(20,[he,are,in,aveiro]).
example(21,[you,are,the,gold,to,me]).
example(22,[you,give]).
example(23,[you,give,the,gold,there]).
example(24,[you,give,she,the,gold]).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%

% =========================================

parse_all_examples(L)
:- findall(X,(example(X,Words),sentence(Words,[])),L).

