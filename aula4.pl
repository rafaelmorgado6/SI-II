:- discontiguous verb/3.

anbncn(N) --> seq_a(N), seq_b(N), seq_c(N).
seq_a(N) --> [a], seq_a(K), { N is K + 1 }.
seq_a(0) --> [].
seq_b(N) --> [b], seq_b(K), { N is K + 1 }.
seq_b(0) --> [].
seq_c(N) --> [c], seq_c(K), { N is K + 1 }.
seq_c(0) --> [].

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

sentence --> np, vp.
np --> properNoun.
np --> article, commonNoun.
np --> pron.
pp --> prep, np.
vp --> verb(LSubCat), complements(LSubCat).

complements([]) --> [].
complements([np|L]) --> np, complements(L).
complements([pp|L]) --> pp, complements(L).
complements([adjective|L]) --> adjective, complements(L).
complements([sentence]) --> sentence.

properNoun --> [mary]; [aveiro].
commonNoun --> [pit]; [wumpus]; [gold].
pron --> [you]; [me].
adjective --> [awful]; [smelly].
article --> [a]; [the].
prep --> [in]; [to]; [like].

verb([np, pp]) --> [give].
verb([np,np]) --> [give]. 
verb([np]) --> [smell]. 
verb([adjective]) --> [smell]. 
verb([pp]) --> [smell]. 
verb([adjective]) --> [is]. 
verb([np]) --> [is].
verb([pp]) --> [is].
verb([]) --> [died]. 
verb([phrase]) --> [believes]. 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
/*
sentence(Sem) --> np(NP), vp(NP^Sem).
vp(VP) --> verb(NP^VP), np(NP).
verb(Obj^Subj^loves(Subj,Obj)) --> [loves].
np(NP) --> properNoun(NP).
properNoun(john) --> [john].
properNoun(mary) --> [mary].
*/
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

sentence(Sem) --> np(NP), vp(NP^Sem), { convert_FOL(Sem,SemFOL) }.
np(NP) --> properNoun(NP).
np(quant(Q, X, F)) --> article(Q), commonNoun(X^F).
vp(VP) --> verb(NP^VP), np(NP).
verb(Obj^Subj^loves(Subj, Obj)) --> [loves].

properNoun(john) --> [john].
properNoun(mary) --> [mary].
commonNoun(X^man(X)) --> [man].
commonNoun(X^woman(X)) --> [woman].
article(univ) --> [every].
article(exist) --> [a].

/* 
To convert from QLF to first-order logic:
    – For each term quant (univ,X,Sem) in a formula QLF, 
      replace this term by Semand the formula becomes univ(X, Sem=>QLF)
    – Similarly, for each term quant(exist,X,Sem) in a formula QLF, 
      replace this term by Sem and the formula becomes exist (X,Sem & QLF)
*/

/*
convert_FOL(QLF,FOL):- QLF =.. [P,Subj,Obj], 
                       convert_QLF_argument(QLF,Subj,FOL_Subj),
                       convert_QLF_argument(QLF,Obj,FOL_Obj),
                       FOL =.. [P,FOL_Subj,FOL_Obj].

convert_FOL(quant(univ,X,Sem),univ(X,))
*/

:- op(500,xfx,=>).
:- op(500,xfx,&).

convert_FOL(FOL,FOL)
:- FOL =.. [_,Subj,Obj], atom(Subj), atom(Obj), !.

convert_FOL(QLF,quant(univ,Obj,F=>FOL))
:- QLF =.. [P,Subj,quant(univ,Obj,F)], atom(Subj), !, FOL =.. [P,Subj,Obj].

convert_FOL(QLF,quant(exist,Obj,F&FOL))
:- QLF =.. [P,Subj,quant(exist,Obj,F)], atom(Subj), !, FOL =.. [P,Subj,Obj].
                    
convert_FOL(QLF,quant(univ,Subj,F=>FOL))
:- QLF =.. [P,quant(univ,Subj,F),Obj], atom(Obj), !, FOL =.. [P,Subj,Obj].

convert_FOL(QLF,quant(exist,Subj,F=>FOL))
:- QLF =.. [P,quant(exist,Subj,F),Obj], atom(Obj), !, FOL =.. [P,Subj,Obj].

convert_FOL(QLF,quant(exist,Subj,F1 & quant(exist,Obj,F2, F2 & FOL)))
:- QLF =.. [P,quant(exist,Subj,F1),quant(exist,Subj,F2)], !, FOL =.. [P,Subj,Obj].