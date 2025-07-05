ebg(Goal,GenGoal,[GenGoal])
:- operational(GenGoal), !, % if it is operational:
   call(Goal). % just prove it from known facts

ebg((Goal1,Goal2),(GenGoal1,GenGoal2),LC3) % if it is a conjunction: individual
:- !, ebg(Goal1,GenGoal1,LC1), % conditions must be explained
   ebg(Goal2,GenGoal2,LC2),
   append(LC1,LC2,LC3).

ebg(Goal,GenGoal,ListCond) % otherwise: continue explaining with some
:- clause(GenGoal,GenBody), % rule of the form GenGoal :- GenBody
   copy_term((GenGoal,GenBody),(Goal,Body)),
   ebg(Body,GenBody,ListCond).

ebl_main(Goal,(GenGoal:-GenBody))
:- Goal =.. [P|Args], length(Args,N), % number of arguments of goal predicate
   length(GenArgs,N), GenGoal =.. [P|GenArgs], % variabilized version
   ebg(Goal,GenGoal,LC), comma_list(GenBody,LC).