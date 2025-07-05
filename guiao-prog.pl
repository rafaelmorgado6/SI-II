% 1.1
len([],0).
len([_|T],N):- len(T,N1), N is N1+1.

% 1.2
soma([],0).
soma([H|T],S):- soma(T,S1), S is S1+H. 

% 1.3 
occurs([X|_], X).
occurs([_|T], X):- occurs(T, X ).

% 1.4
conc([],L,L).
conc([H|T], L, [H|C]):- conc(T, L, C).

% 1.5
inverter([],[]).
inverter([H|T],I):- inverter(T,I0), append(I0,[H],I).

% 1.6
capicua(L):- inverter(L,I), L == I.

% 1.7
conc_listas([],[]).
conc_listas([H|T],C):- conc_listas(T,C0), append(H,C0,C).

% 1.8
substituir([],_,_,[]).
substituir([X|T],X,Y,[Y|R0]):- substituir(T,X,Y,R0).
substituir([H|T],X,Y,[H|R0]):- H\=X, substituir(T,X,Y,R0).

% 1.9
uniao_ord([],L,L).
uniao_ord(L,[],L).
uniao_ord([H1|T1],[H2|T2], [H1|U]):- H1<H2, !,uniao_ord(T1,[H2|T2],U).
uniao_ord([H1|T1],[H2|T2], [H2|U]):- uniao_ord([H1|T1],T2,U).

% 2.1
separar([],[],[]).
separar([(X, Y)|T], [X|L1], [Y|L2]):- separar(T,L1,L2).

% 2.2
remove_e_conta([],_,[],0).
remove_e_conta([X|T],X,L,N):- remove_e_conta(T,X,L,N0), N is N0+1.
remove_e_conta([H|T], X, [H|L], N) :- H \= X, remove_e_conta(T, X, L, N).

% 2.3
ocurrencias([],[]).
ocurrencias([H|T],R):- ocurrencias(T,R0), atualizar_contagem(H, R0, R).

atualizar_contagem(H, [], [(H,1)]).
atualizar_contagem(H, [(H,N)|T], [(H,N1)|T]) :- N1 is N + 1.
atualizar_contagem(H, [(X,N)|T], [(X,N)|R]) :- H \= X, atualizar_contagem(H, T, R).

% 3.1
cabeça([],[]).
cabeça([H|_],H):- H\=[].

% 3.2
cauda([],[]).
cauda([_|T],T):- T\=[].

% 3.3
homologo([],[],[]).
homologo([H1|T1],[H2|T2],[(H1,H2)|T]):- homologo(T1,T2,T).

% 3.4
menor([X],X).
menor([H|T],M0):- menor(T,M0), M0<H,!.
menor([H|_],H).

% 3.5
menor_resto([],[]).
menor_resto(L,(M,R)) :- menor(L, M), delete(L, M, R).

% 3.6
min_max([X],(X,X)).
min_max([H|T],(Mn,Mx)):- min_max(T,(Mn0,Mx0)), Mn is min(H,Mn0), Mx is max(H,Mx0).

% 3.7
menores_resto([],[]).
menores_resto(L,(M1,M2,R)):- menor_resto(L,(M1,R0)), menor_resto(R0,(M2,R)).

% 3.8
media_mediana(L,(Media,Mediana)):- media(L,Media), len(L,N), mediana(L,N,Mediana).

media(L,Media):- soma(L,S), len(L,N), Media is S/N.

mediana(L,N,Mediana):-  % impar
    N mod 2 =:= 1,
    Middle is N//2,
    nth0(Middle,L,Mediana).

mediana(L,N,Mediana):-  % par
    N mod 2 =:= 0,
    Middle1 is N//2-1,
    Middle2 is N//2,
    nth0(Middle1,L,Mediana1),
    nth0(Middle2,L,Mediana2),
    Mediana is (Mediana1+Mediana2)/2.

% 4.6
universal([],_).
universal([H|T],Pred):- call(Pred,H), universal(T,Pred).

positivo(X):- X > 0.

% 4.7
existencial([],_):- fail.
existencial([H|T], Pred):- call(Pred,H); existencial(T,Pred).

% 4.8
subconjunto([],_).
subconjunto([H|T],L):- member(L,H), subconjunto(T,L).

% 4.9
menor_relação([X],_,X).
menor_relação([H|T],Rel,Menor):- menor_relação(T,Rel,MenorT), 
                                 (call(Rel,H,MenorT) -> Menor=H ; Menor=MenorT).

menor_que(X,Y):- X < Y.
maior_que(X,Y):- X > Y.

% 4.10
menor_resto([X],_,(X,[])).
menor_resto([H|T],Rel,(Menor,Resto)):- menor_resto(T,Rel,(MenorT,RestoT)), 
                                       (call(Rel,H,MenorT) -> Menor=H,Resto=T ; Menor=MenorT,Resto=[H|RestoT]).

% 4.11
dois_menores_resto([X,Y],_,(X,Y,[])).
dois_menores_resto(L,Rel,(M1,M2,Resto)):- menor_resto(L,Rel,(M1,ListaSemM1)), 
                                          menor_resto(ListaSemM1,Rel,(M2,Resto)).

% 4.12
cartesianas_para_polares([],[]).
cartesianas_para_polares([(X,Y)|T], [(R,Th)|P]):- R is sqrt(X*X + Y*Y),
                                                  Th is atan2(Y,X),
                                                  cartesianas_para_polares(T,P).

% 4.13
junção_ordenada(L,[],_,L).
junção_ordenada([],L,_,L).
junção_ordenada([H1|T1],[H2|T2],Rel,[H1|R]):- call(Rel,H1,H2), junção_ordenada(T1, [H2|T2],Rel,R).
junção_ordenada([H1|T1],[H2|T2],Rel,[H2|R]):- junção_ordenada([H1|T1], T2,Rel,R).

% 4.14
conc_aplic([],_,[]).
conc_aplic([H|T],F,R):- maplist(F,H,Htrans), conc_aplic(T,F,Resto),append(Htrans,Resto,R). 

quadrado(X,Y):- Y is X*X.

% 4.15
aplic_combin([],[],_,[]).
aplic_combin([H1|T1],[H2|T2],F,[R|T]):- call(F,H1,H2,R), aplic_combin(T1,T2,F,T).

soma(X,Y,R):- R is X+Y.

% 4.16
reduz_linhas([],_,_,[]).
reduz_linhas([H|T],F,E,[R|RT]):- foldl(F,H,E,R), reduz_linhas(T,F,E,RT). 




                                        
