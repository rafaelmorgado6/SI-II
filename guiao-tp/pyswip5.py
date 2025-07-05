
# Program: pyswip5.py

import math
import random

from pyswip import Prolog, registerForeign

class TravellerAgent:

    def __init__(self,spots,topology):
        self.spots = spots
        self.prolog = Prolog()
        self.prolog.consult(topology)
        self.prolog.consult("planner.pl")  # your planner

    def distance(self,s1,s2):
        (x1,y1) = self.spots[s1]
        (x2,y2) = self.spots[s2]
        return math.sqrt((x1-x2)**2 + (y1-y2)**2)

    def perceive(self): # random simulation of traffic intensity;
                        # traffic affects cost evaluation (see above)
        dimx = 2 + max([x for (x,y) in self.spots.values()])
        dimy = 2 + max([y for (x,y) in self.spots.values()])
        return [ [random.random() for y in range(dimy)] for x in range(dimx) ]

    def decide(self,current,end): # wrapper of Prolog procedure
        q = f'decide({current},{end},Plan)'
        queryresult = list(self.prolog.query(q))
        if queryresult != []:
            return queryresult[0]['Plan']

    def act(self,current,plan): # perform state transition
        if plan[0]==current and len(plan)>1:
            print(current,'->',plan[1])
            return plan[1] # return new state

    def mainLoop(self,start,end):
        plan = None
        current = start
        while current!=end:
            self.perception = self.perceive()
            plan = self.decide(current,end)
            if plan==None:
                print('No plan exists')
                return
            print('current plan -->',plan)
            current = self.act(current,plan)
        print('Goal reached')

traveller = TravellerAgent( { 'a':(3,8), 'b':(1,6), 'c':(6,6), 
                              'd':(8,7), 'e':(4,5), 'f':(2,2), 
                              'g':(6,3), 'h':(4,1) }, "topology.pl" )

# Foreign procedure (i.e. foreign to Prolog) used 
# to compute travelling costs based on distances and 
# perceived traffic; 
# ( this is just an example of the kind of calculations that 
#   can be more easily done in Python, instead of Prolog )
def current_cost(*args): 
    s1, s2 = args[0].value, args[1].value # input arguments

    if s1 not in traveller.spots or s2 not in traveller.spots:
        return False # as a predicate, it will fail here

    # you don't need to understand the details below
    (x1,y1) = traveller.spots[s1]
    (x2,y2) = traveller.spots[s2]
    minx, miny = min(x1,x2), min(y1,y2)
    maxx, maxy = max(x1,x2), max(y1,y2)
    acum, count = 0, 0
    for x in range(minx,maxx+1):
        for y in range(miny,maxy+1):
            acum += traveller.perception[x][y]
            count += 1

    # compute action cost and send it out via third argument
    args[2].value = (1+2*acum/count)*traveller.distance(s1,s2)
    return True # as a predicate, it will succeed here
 
# Tell Prolog that the above python procedure 
# can be used as a predicate with 3 arguments: 
# -- current_cost(+State1,+State2,-Cost)
registerForeign(current_cost, arity=3)


# testing

"""
# method tests
traveller.perception = traveller.perceive()
print('perceive: ',traveller.perception)
print('act:      ',traveller.act('a',['a','c','d','h']))
print('distance: ',traveller.distance('a','h'))
print('decide:   ',traveller.decide('a','h'))

#planner tests under varying conditions
for i in range(10):
    traveller.perception = traveller.perceive()
    print('decide(a,h):',traveller.decide('a','h'))
    print('++++++++++++++++++++++++++++++++++++++')
print()

# complete test:
print("------------------------------------------")
print("Travelling from from 'a' to 'h'")
print("------------------------------------------")
traveller.mainLoop('a','h')
print("------------------------------------------")
print("Travelling from from 'a' to 'x'")
print("------------------------------------------")
traveller.mainLoop('a','x')

"""

