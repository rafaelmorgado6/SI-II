
/* Connections and locations

8 |   __ a ___ 
7 |  /        \    d
6 |  b         c__/|
5 |  \_____e__/|   |
4 |      _/ \  |   |
3 |     /    \_g___/
2 |    f       /
1 |     \__h__/
  -------------------
     1 2 3 4 5 6 7 8  
Note: coordinates are given to the program in pyswip5.py
*/


connection(a,b).
connection(a,c).
connection(c,d).
connection(c,e).
connection(c,g).
connection(b,e).
connection(e,f).
connection(e,g).
connection(d,g).
connection(f,h).
connection(g,h).


connected(X,Y) :- connection(X,Y).
connected(X,Y) :- connection(Y,X).

