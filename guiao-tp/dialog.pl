%

sentence(tell,SEM)   --> np(X^WHAT), [is,in], np(Y^WHERE), 
                         { append(WHAT,WHERE,SEM0), append(SEM0,[in(X,Y)],SEM) }.
sentence(tell,SEM)   --> [the,name,of], np_simple(X^SEMX), [is], 
                          properNoun(X^NAME), {SEM=[NAME,SEMX]}.                   
sentence(ask(Y),SEM) --> [where,is], np(X^WHAT), 
                         { append(WHAT,[in(X,Y)],SEM) }.
sentence(ask(X),SEM) --> [what,is,in], np(Y^WHERE), 
                         { append(WHERE,[in(X,Y)],SEM) }.
sentence(ask(X),SEM) --> [what,is,the,name,of], np_simple(X^SEMX), 
                         { SEM = [name(X,_), SEMX] }.

np(X^SEM) --> np_simple(X^SEMX), [of], np_simple(Y^SEMY), 
              { SEM = [has(Y,X), SEMX, SEMY] }.
np(X^SEM) --> np_simple(X^SEMX), [of], properNoun(Y^SEMY), 
              { SEM = [has(Y,X), SEMX, SEMY] }.  
np(X^SEM) --> np_simple(X^SEMX), { SEM = [SEMX] }.
np(X^SEM) --> properNoun(X^NAME), { SEM = [NAME] }.
np_simple(X^SEM) --> [the],noun(X^SEM).
noun(X^member(X,Noun)) --> [Noun], { member(Noun,[bicycle,car,professor,workshop]) }.
properNoun(X^name(X,Name)) --> [Name], { member(Name,[einstein]) }.
%%%

process_sentence(Sentence)  % Frase afirmativa
:- sentence(tell,Semantics,Sentence,[]),
   identify_entities(Semantics),
   findall(_,( member(Pred,Semantics), 
               assert_special(Pred) ),_).

process_sentence(Sentence) % Frase interrogativa
:- sentence(ask(E),Semantics,Sentence,[]),
   identify_entities(Semantics),
   ( 
     var(E), !,
     writeln('Sorry, no idea')
     ;
     known_entity(E,name,Name),
     writeln(Name)
     ;
     known_entity(E,member,Type),
     writeln(Type) 
   ).

%%%%
% Guardar e Verificar Factos
assert_special(P)
:- clause('$fact'(P),true), !.
assert_special(P)
:- assert('$fact'(P)).

%%%%

identify_entities([]).
identify_entities([P|Semantics])
:- identification_step(P,Semantics),
   identify_entities(Semantics).

identification_step(P,_)   % Entidade já conhecida
:- is_entity_identifier(P,E,F,X),
   known_entity(E,F,X).
identification_step(P,Semantics) % Entidade nova, mas já aparece em outra parte da semantica
:- is_entity_identifier(P,E,F,X),
   \+ known_entity(E,F,X),
   occurs_again(E,Semantics).
identification_step(P,Semantics) % Entidade nova, não aparece de novo na semantica
:- is_entity_identifier(P,E,F,X),
   \+ known_entity(E,F,X),
   \+ occurs_again(E,Semantics),
   generate_entity_id(E).
identification_step(P,_)   % Entidade não identidicada como um tipo de identidade
:- \+ is_entity_identifier(P,_,_,_),
   known_relation(P).
identification_step(P,_)   % Nem entidade nem relação conhecida
:- \+ is_entity_identifier(P,_,_,_),
   \+ known_relation(P).

%%%%

% extrai identificadores das entidades (como member ou name).
is_entity_identifier(member(E,Type),E,member,Type).
is_entity_identifier(name(E,Name),E,name,Name).

% verifica se a entidade já foi definida.
known_entity(E,member,Type)
:- clause('$fact'(member(E,Type)),true).

known_entity(E,name,Name)
:- clause('$fact'(name(E,Name)),true).

% verifica se o predicado já foi registado.
known_relation(Relation)
:- clause('$fact'(Relation),true).

%%%%

occurs_again(E,[P|_])
:- is_entity_identifier(P,V,_,_), V==E, !.
occurs_again(E,[_|Semantics])
:- occurs_again(E,Semantics).

generate_entity_id(Entity)
:- retract('$last_id'(Id)), !,
   Entity is Id+1,
   assert('$last_id'(Entity)).
generate_entity_id(1)
:- assert('$last_id'(1)).

%%%%
% limpa todos os factos e o contador de IDs.
reset
:- retractall('$fact'(_)), 
   retractall('$last_id'(_)).

%%% Test sentences

test_sentence( 1,[the,professor,is,in,the,workshop]).
test_sentence( 2,[the,bicycle,is,in,the,workshop]).
test_sentence( 3,[where,is,the,professor]).
test_sentence( 4,[what,is,in,the,workshop]).
test_sentence( 5,[the,name,of,the,professor,is,einstein]).
test_sentence( 6,[what,is,the,name,of,the,professor]).
test_sentence( 7,[where,is,einstein]).
test_sentence( 8,[the,car,of,the,professor,is,in,the,workshop]).
test_sentence( 9,[where,is,the,car,of,the,professor]).
test_sentence(10,[where,is,the,car,of,einstein]).
test_sentence(11,[where,is,the,car]).


