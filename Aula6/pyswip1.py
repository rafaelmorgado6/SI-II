
from pyswip import Prolog

prolog = Prolog()

prolog.assertz("father(michael,john)")
prolog.assertz("father(michael,gina)")

prolog.assertz("umalista([1,2,3])")