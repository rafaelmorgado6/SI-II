/*addition --> number, ['+'], number.
number --> sign, integer ; integer.
integer --> digit ; digit, integer.
digit --> [0]; [1]; [2]; [3]; [4]; [5]; [6]; [7]; [8]; [9].
sign --> ['+']; ['-'].
*/

/*
digit(D) --> [D], { integer(D), D =<9, D>= 0 }.
integer(N,L) --> digit(D), integer(M, K), { L is 10*K, N is M + L*D }.
integer(D,1) --> digit(D).
*/

sentence --> nounPhrase, verbPhrase.
nounPhrase --> article, noun.
verbPhrase --> verb.
article --> [the].
noun --> [cat]; [cats].
verb --> [sleeps]; [sleep].
verb --> [runs]; [run].