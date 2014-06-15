module Play3 where

data BExpr = T | F | Not BExpr
           | Or BExpr BExpr
		   | And BExpr BExpr
             deriving Show 
-- Add And operation to BExpr

sem :: BExpr -> Bool
sem T         = True
sem F         = False
sem (Not b)   = not (sem b)
-- sem (Or b b') = sem b || sem b'
sem (Or b b') | sem b ==True    = True
              | otherwise = sem b'
-- sem T = True
	-- | otherwise = False
-- sem (And a b) = and [sem a,sem b]
sem (And a b) = sem a && sem b


-- Deﬁne a Haskell function to apply DeMorgan’s laws to 
-- boolean expression, i.e., a function to transform any 
-- expression not (x and y) into (not x) or (not y) (and 
-- accordingly for not (x or y))

deMor :: BExpr -> BExpr
deMor (Not (And a b)) =  Or (Not a)(Not b)
deMor (Not (Or a b)) =  And (Not a)(Not b)
deMor otherwise = otherwise

a = deMor (Not (Or T F))
b = (deMor (Not (And T F)))

--shape

data Shape = X
			| TD Shape Shape
			| LR Shape Shape
			deriving Show
type Pixel = (Int,Int)
type Image = [Pixel]

--semantics

sems:: Shape -> Image
sems X = [(1,1)]
--base case
sems (TD a b) = (ajusty (maxy b)(sems a)) ++  (sems b)
--TD
sems (LR a b) = (ajustx (maxx b)(sems a)) ++ (sems b)
--LR

maxy :: Image -> Int
maxy a = maximum ( map snd(a))

maxx :: Image -> Int
maxx a = maximum ( map fst(a))

ajusty :: Int ->Image->Image
ajusty  a b = [(x,y+a) | (x,y) <- b]

ajustx :: Int ->Image->Image
ajustx  a b = [(x+a,y) | (x,y) <- b]


