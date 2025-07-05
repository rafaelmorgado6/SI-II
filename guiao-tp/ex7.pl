%

generatePlan(IS,Objective,Plan)                  % initial state, objective, output plan
:- retractall(node(_,_,_,_)),     % clean up the database (remove last search tree)
   reset_gensym,                                     % reset generation of unique identifier
   gensym(node_,ID),                                             % generate ID for root node
   assert(node(ID,IS,none,none)),                                          % store root node
   generatePlanRec([ID],Objective,SolID), % initial queue, objective, solution node
   getPlan(SolID,Plan).

getPlan(ID,[])                         % climb the tree from a given node (ID) up to the
:- node(ID,_,none,none).         % root and return the corresponding sequence
getPlan(ID,Plan)                      % of actions (Plan)
:- node(ID,_,Action,IDparent),
   getPlan(IDparent,Plan0),
append(Plan0,[Action],Plan).

generateTransition(ParentID,State,ChildID)
:- stripsOperator(Action,PCL,DL,AL),                         % domain-specific operators
   subset_bt(PCL,State),       % instanciate preconditions (PCL) in State, if possible
   subtract(State,DL,AuxState),     % subtract neg. effects (subtract/3 pre-defined)
   append(AuxState,AL,NewState),                               % append positive effects
   gensym(node_,ChildID),
   assert(node(ChildID,NewState,Action,ParentID)). % store new node in database

subset_bt([],_).              % similar to pre-defined subset/2, but with backtracking
subset_bt([H|T],S)
:- member(H,S),
   subset_bt(T,S).

generatePlanRec([ID|_],Objective,ID)
:- node(ID,State,_,_),
   subset(Objective,State).              % Objective is subset of State: solution found
                                                      % (end of recursion)  

generatePlanRec([ID|Queue],Objective, SolutionID)                   % recursive rule
:- node(ID,State,_,_),
   findall(ChildID,generateTransition(ID,State,ChildID),ChildList),
   append(Queue,ChildList,NewQueue),     % FIFO queue => breadth-first search
   generatePlanRec(NewQueue,Objective,SolutionID).

%%%%%%%%%%%%%%% Blocks world

stripsOperator(
   stack(X,Y),             % signature
   [holding(X),free(Y)],      % pre-conditions
   [holding(X),free(Y)],            % delete list
   [on(X,Y),robot_free,free(X)] ).  % add list

stripsOperator(
   pickUp(X), 
   [robot_free,free(X),floor(X)],
   [robot_free,free(X),floor(X)],
   [holding(X)] ).

stripsOperator(
   putdown(X), 
   [holding(X)],
   [holding(X)],
   [robot_free,floor(X),free(X)] ).

stripsOperator(
   unstack(X,Y), 
   [on(X,Y),free(X),robot_free],
   [on(X,Y),free(X),robot_free],
   [holding(X),free(Y)] ).