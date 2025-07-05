from pyswip import Prolog
from pyswip import registerForeign

def hello(t):
    print(" Hello,", t)

registerForeign(hello,arity=1)
    
prolog = Prolog()
prolog.assertz("father(michael,john)")
prolog.assertz("father(michael,gina)")