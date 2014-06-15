--cs381
--HW3
--authored by Li Li, Xinyang Chen, Heng Wang

module HW3 where


--Exercise 1. A Rank-Based Type Systems for the Stack Language
type Prog = [Cmd]
data Cmd = LD Int
		 | ADD
		 | MULT
		 | DUP
		 | INC
		 | SWAP
		 | POP Int
		 deriving Show
type Rank = Int
type CmdRank = (Int,Int)

rankC :: Cmd -> CmdRank
rankC (LD i) = (0,1)
rankC ADD = (2,1)
rankC MULT = (2,1)
rankC DUP = (1,2)
rankC INC = (1,1)
rankC SWAP = (2,2)
rankC (POP i) = (i,0)

rankP :: Prog -> Maybe Rank
rankP [] = Just 0
rankP p = rank p 0

rank :: Prog -> Rank -> Maybe Rank
rank [] r = Just r
rank (p:ps) r =  let (a,b) = rankC p in
		 if a > r then Nothing else rank ps ((r-a)+b)

--(2)
type Stack = [Int]

tc :: Prog -> Maybe Stack
tc p = let d = rankP p in
	if d == Nothing then Nothing else Just (sem p)

sem :: Prog -> Stack
sem = foldl (flip semCmd) []

semCmd :: Cmd -> Stack -> Stack
semCmd (LD i) s = (i:s)
semCmd ADD (x:y:s) = ((x+y):s)
semCmd MULT (x:y:s) = ((x*y):s)
semCmd DUP (x:s) = (x:x:s)
semCmd INC (x:s) = ((x+1):s)
semCmd SWAP (x:y:s) = (y:x:s)
semCmd (POP i) s = (drop i) s

--It can be simplified because I typecheck it before call the sem function. So I can assume the parameters coming in are type correct.

--test
p1 = [LD 3,DUP,ADD,DUP,MULT]
p2 = [LD 3,ADD]
p3 = []

t1 = tc p1 
--passes and gives result: Just [36]
t2 = tc p2
--not passes: Nothing
t3 = tc p3
--passes and gives result: Just []


-- Exercise 2. Shape Language

data Shape = X
			| TD Shape Shape
			| LR Shape Shape
			deriving Show
type BBox = (Int,Int)
type Pixel = (Int,Int)
type Image = [Pixel]

sem2 :: Shape -> Image 
sem2 X           = [(1,1)]
sem2 (LR s1 s2) = d1 ++ [(x+maxx d1,y) | (x,y) <- sem2 s2] 
                 where d1 = sem2 s1
sem2 (TD s1 s2) = d2 ++ [(x,y+maxy d2) | (x,y) <- sem2 s1] 
                 where d2 = sem2 s2

maxx :: [Pixel] -> Int
maxx = maximum . map fst

maxy :: [Pixel] -> Int
maxy = maximum . map snd
--(a)Define a type checker for the shape language as a Haskell function
bbox :: Shape -> BBox
bbox X = (1,1)
bbox (LR a b) = (maxx(sem2 (LR a b)), maxy(sem2 (LR a b)))
bbox (TD a b) = (maxx(sem2 (TD a b)), maxy(sem2 (TD a b)))

											 

--test
s1 = LR (TD X X) X
s2 = LR (TD X X) (TD X X)
s3 = LR (LR X X) (LR X X)

t21 = bbox s1 
t22 = bbox s2
t23 = bbox s3
-- (b)Rectangles are a subset of shapes and thus describe a more restricted set of types. By restricting
-- the application of the TD and LR operations to rectangles only one could ensure that only convex
-- shapes without holes can be constructed. Define a type checker for the shape language that assigns
-- types only to rectangular shapes by defining a Haskell function


checkhole::Image ->Bool
checkhole i = if maxy(i)*maxx(i)==length(i) then False
											else True


rect :: Shape -> Maybe BBox
rect a = if checkhole(sem2(a))==False then Just(x,y)
									 else Nothing
	where (x,y) = (maxx(sem2(a)),maxy(sem2(a)))
--test
t24 = rect s1 
-- not a rectangle
t25 = rect s2 
-- square (which is a rectangle)
t26 = rect s3 
-- is a rectangle

-- Exercise 3. Parametric Polymorphism

-- (a) Consider the functions f and g, which are given by the following two function definitions.
f x y = if null x then [y] else x
g x y = if not (null x) then [] else [y]

-- (1) What are the types of f and g?
--	f :: [t] -> t -> [t]
--	g :: [a] -> a1 -> [a1]

-- (2) Explain why the functions have these types.
-- for f 
-- because "null x" is syntax correct, so x is a list. if true, then returns a list contains y; otherwise returns x which is a list.
-- for g
-- assume "not (null x)" is syntax coorect. Then x is a list. If x is [], it is false and returns list -- contains y: otherwise returns [].

-- (3) Which type is more general?
-- g is more general, because it may returns empty list, it can be any type.


-- (4) Why do f and g have different types?
-- in f: x and [y] shall be the say type, so if y's type is specified then x is too.
-- if g: x can be a empty list, so the type of elements in x are not specified.

-- (b) Find a (simple) definition for a function h that has the following type.
-- h :: [b] -> [(a, b)] -> [b]
h b a = map snd a

-- (c) Find a (simple) definition for a function k that has the following type.
-- k :: (a -> b) -> ((a -> b) -> a) -> b
k a b = a (b (a ))

-- (d) Can you define a function of type a -> b? If yes, explain your definition. If not, explain why it is
-- so difficult.
x a = x a

-- It is very difficult, because we do not know the type of a or b, so there are so many possibilites.