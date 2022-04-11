set rst 1
set rst 0

// Comptage d'impair en impair

set p 0
set clk 1
set clk 0
check c[3..0] 0001

set clk 1
set clk 0
check c[3..0] 0011

set clk 1
set clk 0
check c[3..0] 0101

set clk 1
set clk 0
check c[3..0] 0111

set clk 1
set clk 0
check c[3..0] 1001

set clk 1
set clk 0
check c[3..0] 1011

set clk 1
set clk 0
check c[3..0] 1101

set clk 1
set clk 0
check c[3..0] 1111

set clk 1
set clk 0
check c[3..0] 0001

// Comptage de pair en pair

set p 1

set clk 1
set clk 0
check c[3..0] 0010

set clk 1
set clk 0
check c[3..0] 0100

set clk 1
set clk 0
check c[3..0] 0110

set clk 1
set clk 0
check c[3..0] 1000

set clk 1
set clk 0
check c[3..0] 1010

set clk 1
set clk 0
check c[3..0] 1100

set clk 1
set clk 0
check c[3..0] 1110

set clk 1
set clk 0
check c[3..0] 0000

set clk 1
set clk 0
check c[3..0] 0010

// Passages intempestifs d'impair à pair, et vice et versa :-)

set p 0
set clk 1
set clk 0
check c[3..0] 0011

set p 1
set clk 1
set clk 0
check c[3..0] 0100

set p 0
set clk 1
set clk 0
check c[3..0] 0101

set p 1
set clk 1
set clk 0
check c[3..0] 0110

set p 0
set clk 1
set clk 0
check c[3..0] 0111

set p 1
set clk 1
set clk 0
check c[3..0] 1000

set p 0
set clk 1
set clk 0
check c[3..0] 1001

set p 1
set clk 1
set clk 0
check c[3..0] 1010

set p 0
set clk 1
set clk 0
check c[3..0] 1011

set p 1
set clk 1
set clk 0
check c[3..0] 1100

set p 0
set clk 1
set clk 0
check c[3..0] 1101

set p 1
set clk 1
set clk 0
check c[3..0] 1110

set p 0
set clk 1
set clk 0
check c[3..0] 1111

set p 1
set clk 1
set clk 0
check c[3..0] 0000

set p 0
set clk 1
set clk 0
check c[3..0] 0001

set p 1
set clk 1
set clk 0
check c[3..0] 0010