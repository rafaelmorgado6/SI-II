from pyswip import Prolog, Atom
from pyswip import registerForeign

def atom_checksum(*a):
    if isinstance(a[0], Atom):
        r = sum(ord(c)&0xFF for c in str(a[0]))
        a[1].value = r&0xFF
        return True
    else:
        return False

p = Prolog()
registerForeign(atom_checksum, arity=2)