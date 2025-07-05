%

:- dynamic declaration/2.

declaration(descartes,	subtype(mamifero,vertebrado)).	% the user who declared
declaration(darwin,	mamar(mamifero, sim)).	        % the declared relation
declaration(descartes,	altura(mamifero,1.2)).		% name of the declared relation
declaration(darwin,	subtype(homem,mamifero)).	% first argument of the declared relation
declaration(darwin,	gosta(homem,carne)).		% second argument of the declared relation
declaration(descartes,	altura(homem,1.75)).
declaration(damasio,	gosta(filosofo,filosofia)).
declaration(descartes,	member(socrates,homem)).
declaration(damasio,	member(socrates,filosofo)).
declaration(descartes,	professor(socrates,matematica)).
declaration(descartes,	professor(socrates,filosofia)).
declaration(descartes,	peso(socrates,80)).
declaration(descartes,	member(platao,homem)).
declaration(descartes,	professor(platao,filosofia)).
declaration(descartes,	member(aristoteles,homem)).

% a)
query(Property,E1,E2,U)  % non recursive rule (local query)
:- Pred =.. [Property,E1,E2],
   declaration(U,Pred).
query(Property,E1,E2,U)  % recursive rule for inheritance
:- \+ member(Property, [member,subtype]),
   member(P, [member,subtype]), 
   Pred =.. [P,E1,Parent],
   declaration(_,Pred),
   query(Property,Parent,E2,U).


% b) Após encontrar a solução nao pesquisa herança para cima 
query_cancel(Property,E1,E2,U)  % non recursive rule (local query)
:- Pred =.. [Property,E1,E2],
   declaration(U,Pred), !.
query_cancel(Property,E1,E2,U)  % recursive rule for inheritance
:- \+ member(Property, [member,subtype]),
   member(P, [member,subtype]), 
   Pred =.. [P,E1,Parent],
   declaration(_,Pred),
   query_cancel(Property,Parent,E2,U).


%        vertebrado
%            ^
%            |
%            |
%         mamifero--(altura)-->1.2
%            ^ 
%            |
%        (subtype)
%            |
%          homem--(altura)-->1.75
%          ^ ^ ^
%         /  |  \
%         (member)
%       /    |    \
% socrates platão aristoteles


%c) Mostra o caminho da herança
query_path(Property,E1,E2,[E1])  % non recursive rule (local query)
:- Pred =.. [Property,E1,E2],
   declaration(_,Pred), !.
query_path(Property,E1,E2,[E1|Path])  % recursive rule for inheritance
:- \+ member(Property, [member,subtype]),
   member(P, [member,subtype]), 
   Pred =.. [P,E1,Parent],
   declaration(_,Pred),
   query_path(Property,Parent,E2,Path).


