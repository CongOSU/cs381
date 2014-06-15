module Fun2 where

data Digit = Zero | One
			deriving Show
data Bin = LinkD Digit
			| LinkB Digit Bin
				deriving Show
l0l = LinkB One (LinkB Zero( LinkD One))

data BExpr = T | F | Not BExpr
           | Or BExpr BExpr
		   deriving Show
--nnt :: BExpr
nnt = Not (Not T)

--tonnt :: BExpr
tonnt = Or T nnt
