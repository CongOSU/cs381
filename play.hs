module Play where
v::a
v = v
--quiz 1 
--1
mkEven:: [Int]-> [Int]
mkEven [] = []
-- mkEven (x:xs) = if odd x then (x+1:mkEven(xs))
						 -- else (x :mkEven(xs))
mkEven (x:xs) | odd x = (x+1: mkEven(xs))
			  | otherwise  = (x:mkEven(xs))
--2
xss = [[1,2],[3,4,5]]

rv:: [a] ->[a]
rv [] =[]
rv (x:xs) = rv xs ++ [x]

g [] ys = ys
g (x:xs) ys = x: g xs ys


ones a = "ones" ++ ones a
			


f a = f a


data Point = Pos Int Int

data Fig =	P Point
		 | Line Point Point
		 -- deriving Show
-- T3::Fig
-- T3 = Pos 1 2
-- T4::Fig
t4 = Line (Pos 1 1) (Pos 2 2)

-- data Action = MoveTo Int Int 
            -- | PickUp [Object] 
            -- | Drop 
            -- | Seq Action Action

-- data Object = Chair | Table

-- p = Seq (MoveTo 3 4) (PickUp [Chair])


--quiz 4 
--3
data Expr = N Int
		  | Succ Expr
		  | Single Expr
		  | Append Expr Expr
		  | Index Expr Expr
data Type = Intt
		  | Listt
		  | Errorr
		  deriving (Show,Eq)
		  
tc :: Expr -> Type
tc (N a) = Intt
tc (Succ a) | (tc a) == Intt = Intt
			| otherwise = Errorr
tc (Single a) | (tc a) == Intt = Listt
			  | otherwise = Errorr
tc (Append a b) | (tc a) == Listt && (tc b) == Listt = Listt
				| otherwise = Errorr
tc (Index a b) | (tc a) == Intt && (tc b) == Listt = Intt
			   | otherwise = Errorr
tc _ = Errorr
