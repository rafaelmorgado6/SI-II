connection(a,b).
connection(a,c).
connection(c,d).
connection(c,e).
connection(b,e).
connection(e,f).
connection(e,g).
connection(d,g).
connection(f,h).
connection(g,h).
connected(X,Y) :- connection(X,Y).
connected(X,Y) :- connection(Y,X).