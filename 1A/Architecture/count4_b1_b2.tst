set rst 1
set rst 0
check c[3..0] 0000

// initialisation

set init 1
set count 0
set b1[3..0] 0001
set clk 1
set clk 0
check c[3..0] 0001

set b1[3..0] 0010
set clk 1
set clk 0
check c[3..0] 0010

set b1[3..0] 0011
set clk 1
set clk 0
check c[3..0] 0011

set b1[3..0] 0100
set clk 1
set clk 0
check c[3..0] 0100

set b1[3..0] 0101
set clk 1
set clk 0
check c[3..0] 0101

set b1[3..0] 0110
set clk 1
set clk 0
check c[3..0] 0110

set b1[3..0] 0111
set clk 1
set clk 0
check c[3..0] 0111

set b1[3..0] 1000
set clk 1
set clk 0
check c[3..0] 1000

set init 1
set count 0
set b1[3..0] 1001
set clk 1
set clk 0
check c[3..0] 1001

set b1[3..0] 1010
set clk 1
set clk 0
check c[3..0] 1010

set b1[3..0] 1011
set clk 1
set clk 0
check c[3..0] 1011

set b1[3..0] 1100
set clk 1
set clk 0
check c[3..0] 1100

set b1[3..0] 1101
set clk 1
set clk 0
check c[3..0] 1101

set b1[3..0] 1110
set clk 1
set clk 0
check c[3..0] 1110

set b1[3..0] 1111
set clk 1
set clk 0
check c[3..0] 1111

set b1[3..0] 0000
set clk 1
set clk 0
check c[3..0] 0000

// aucune action, comptage, arret, pour cahque valeur
set init 0
set count 0
set clk 1
set clk 0
check c[3..0] 0000

set init 1
set count 1
set clk 1
set clk 0
check c[3..0] 0000

set init 0
set count 1
set b2[3..0] 0001
set clk 1
set clk 0
check c[3..0] 0001

set clk 1
set clk 0
check c[3..0] 0001

set init 0
set count 0
set clk 1
set clk 0
check c[3..0] 0001

set init 1
set count 1
set clk 1
set clk 0
check c[3..0] 0001

set init 0
set count 1
set b2[3..0] 0010
set clk 1
set clk 0
check c[3..0] 0010

set clk 1
set clk 0
check c[3..0] 0010

set init 0
set count 0
set clk 1
set clk 0
check c[3..0] 0010

set init 1
set count 1
set clk 1
set clk 0
check c[3..0] 0010

set init 0
set count 1
set b2[3..0] 0011
set clk 1
set clk 0
check c[3..0] 0011

set clk 1
set clk 0
check c[3..0] 0011

set init 0
set count 0
set clk 1
set clk 0
check c[3..0] 0011

set init 1
set count 1
set clk 1
set clk 0
check c[3..0] 0011

set init 0
set count 1
set b2[3..0] 0100
set clk 1
set clk 0
check c[3..0] 0100

set clk 1
set clk 0
check c[3..0] 0100

set init 0
set count 0
set clk 1
set clk 0
check c[3..0] 0100

set init 1
set count 1
set clk 1
set clk 0
check c[3..0] 0100

set init 0
set count 1
set b2[3..0] 0101
set clk 1
set clk 0
check c[3..0] 0101

set clk 1
set clk 0
check c[3..0] 0101

set init 0
set count 0
set clk 1
set clk 0
check c[3..0] 0101

set init 1
set count 1
set clk 1
set clk 0
check c[3..0] 0101

set init 0
set count 1
set b2[3..0] 0110
set clk 1
set clk 0
check c[3..0] 0110

set clk 1
set clk 0
check c[3..0] 0110

set init 0
set count 0
set clk 1
set clk 0
check c[3..0] 0110

set init 1
set count 1
set clk 1
set clk 0
check c[3..0] 0110

set init 0
set count 1
set b2[3..0] 0111
set clk 1
set clk 0
check c[3..0] 0111

set clk 1
set clk 0
check c[3..0] 0111

set init 0
set count 0
set clk 1
set clk 0
check c[3..0] 0111

set init 1
set count 1
set clk 1
set clk 0
check c[3..0] 0111

set init 0
set count 1
set b2[3..0] 1000
set clk 1
set clk 0
check c[3..0] 1000

set clk 1
set clk 0
check c[3..0] 1000

set init 0
set count 0
set clk 1
set clk 0
check c[3..0] 1000

set init 1
set count 1
set clk 1
set clk 0
check c[3..0] 1000

set init 0
set count 1
set b2[3..0] 1001
set clk 1
set clk 0
check c[3..0] 1001

set clk 1
set clk 0
check c[3..0] 1001

set b2[3..0] 1111
set clk 1
set clk 0
check c[3..0] 1010

set clk 1
set clk 0
check c[3..0] 1011

set clk 1
set clk 0
check c[3..0] 1100

set clk 1
set clk 0
check c[3..0] 1101

set clk 1
set clk 0
check c[3..0] 1110

set clk 1
set clk 0
check c[3..0] 1111

set clk 1
set clk 0
check c[3..0] 1111

