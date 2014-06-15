--midterm

module Midterm where

--1.
data Tree = Node Int Tree Tree
			| Empty
			deriving Show
cnt :: Int ->Tree-> Int
cnt (x) (Empty) =0
-- cnt (x) (Node a t1 t2) = if x >a then  1 + cnt (x) (t1) +cnt (x) (t2)
						-- else cnt (x) (t1) + cnt (x) (t2)
cnt (i) (Node a t1 t2) | i >a = 1 + cnt (i) (t1) +cnt (i) (t2)
					   |otherwise = cnt (i) (t1) + cnt (i) (t2)


tre = Node 0 (Node 1 (Node 2 (Empty)(Empty))(Node 4(Empty)(Empty)))(Node 10 (Empty)(Empty))
						

					  

--2.


data Modifier = Public | Private | Static | Final
				deriving Show
data Interface = I Modifier String Names [Field]
				deriving Show
data Names = N String Names
			| Empty2
			deriving Show
data Field = F Modifier String 
			deriving Show
declare = I Private ("Foo") (N "Baz," (N "Qux" Empty2)) ([F Static "x ;" ,F Final "y ;"])
