--CS 381
--homework 2
--Authors : Chao Peng & Canhua Huang
--Date: April 30,2013
module Homework2 where

import SVG (ppLines)

-- Exercise 1 A Stack Language 
-- Exercise 2 Extending the Stack Language by Macros
-- Exercise 2 Extending the Stack Language by Macros(a)
-- Exercise 2 Extending the Stack Language by Macros(b)
type Prog = [Cmd]
data Cmd = LD Int
         | ADD
 		 | MULT 
		 | DUP 
		 | Call String
		 | Def String Prog deriving Show 

type Stack = Maybe [Int]
type D = Stack -> Stack 

type Macros = [(String, Prog)]
type State = (Stack, Macros)
type E = Maybe State -> Maybe State

--start from stack = []
-- Exercise 1 A Stack Language 
sem :: Prog -> Stack
sem [] = Nothing
sem xs = sEm' xs (Just [])

sEm' :: Prog -> D
sEm' [] (Just s) = Just s
sEm' (x:xs) (Just s) = sEm' xs (semCmd x (Just s))
sEm' xs Nothing = Nothing   

semCmd :: Cmd -> D
semCmd (LD i) (Just xs) = Just (i:xs)
semCmd ADD (Just xs) 
			| length xs <= 1 = Nothing 
			| otherwise      = case semCmd (LD ((head xs) + ((head.tail) xs))) (Just (drop 2 xs)) of
								Just i -> Just i
								_	   -> Nothing
semCmd MULT (Just xs)
			| length xs <= 1 = Nothing 
			| otherwise      = case semCmd (LD ((head xs) * ((head.tail) xs))) (Just (drop 2 xs)) of
								Just i -> Just i
								_	   -> Nothing
semCmd DUP (Just xs) 
			| length xs < 1 = Nothing 
			| otherwise     = case semCmd (LD (head xs)) (Just xs) of 
								Just i -> Just i
								_	   -> Nothing 		   

--Exercise 2 Extending the Stack Language by Macros(c)
--Check existing macros Exist => True otherwise false
doExist :: String -> State -> Bool
doExist s t = s `elem` (map fst (snd t))

findIndex :: String -> State -> Prog
findIndex s (t,c:cs) 
				 | fst c == s = snd c
				 | otherwise  = findIndex s (t,cs)
--start from [] 
sem2 :: Prog -> Maybe State
sem2 [] = Nothing
sem2 xs = sem2' xs (Just (Just [],[]))

sem2' :: Prog -> E
sem2' [] (Just s) = Just s
sem2' (x:xs) (Just s) = sem2' xs (semCmd2 x (Just s))
sem2' xs Nothing = Nothing 

semCmd2 :: Cmd -> E 
semCmd2 (LD i) (Just (s,m)) 
						 | semCmd (LD i) s == Nothing = Nothing
						 | otherwise	              = Just ((semCmd (LD i) s), m)
semCmd2 ADD (Just (s,m)) 
					  | semCmd ADD s == Nothing = Nothing
			    	  | otherwise	            = Just ((semCmd ADD s), m)
semCmd2 MULT (Just (s,m)) 
					  | semCmd MULT s == Nothing = Nothing
					  | otherwise	             = Just ((semCmd MULT s), m)
semCmd2 DUP (Just (s,m)) 
					  | semCmd DUP s == Nothing = Nothing
					  | otherwise	            = Just ((semCmd DUP s), m)
semCmd2 (Def name p) (Just (s,m)) = if not (doExist name (s,m))
					 				then Just (s,((name,p):m))
					 				else Nothing
semCmd2 (Call name) (Just (s,m)) = if doExist name (s,m)
								   then sem2' (findIndex name (s,m)) (Just (s,m))
					 			   else Nothing
--Exercise 1,2 example solution
--Nothing					
p = []
--get [36]
a = [LD 3, DUP , ADD, DUP, MULT]
--Nothing
b = [LD 3, ADD]
--Just (Just [36],[("dadm",[DUP,ADD,DUP,MULT])])
u = [LD 3, Def "dadm" [DUP,ADD,DUP,MULT], Call "dadm"]
--Nothing
z = [LD 3, Call "dadm",Def "dadm" [DUP,ADD,DUP,MULT]]
--Just (Just [72,72],[("dam",[DUP,ADD,DUP]),("dadm",[DUP,ADD,DUP,MULT])])
u' = [LD 3, Def "dadm" [DUP,ADD,DUP,MULT], Def "dam" [DUP,ADD,DUP], Call "dadm", Call "dam"]
--Nothing
b' = [LD 3, Def "dadm" [ADD,MULT], Call "dadm"]

-- Exercise 3 Mini Logo
data CMd = Pen Mode
		 | MoveTo Int Int
		 | Seq CMd CMd deriving Show

data Mode = Up | Down deriving (Eq, Show)

type State1 = (Mode, Int, Int)

type Line = (Int, Int, Int, Int)
type Lines = [Line]

sems:: CMd -> State1 -> (State1, Lines)
sems (Pen m) (_,a,b) = ((m,a,b),[])
sems (MoveTo i j) (m,a,b) 
						  | m == Up = ((m,i,j),[])
						  | m == Down = ((m,i,j),[(a,b,i,j)])
sems (Seq c d) (m,a,b) = ((fst (sems d (fst (sems c (m,a,b))))),
							((snd (sems c (m,a,b))) ++ 
								(snd (sems d (fst (sems c (m,a,b)))))))

sem' :: CMd -> Lines
sem' a = snd (sems a (Up,0,0))

----test
tri = Seq (Seq (Seq (Pen Down) (MoveTo 1 1)) (MoveTo 1 2)) (MoveTo 0 0)
square = Seq (Seq (Seq (Pen Down) (MoveTo 0 1)) (MoveTo 1 1)) (Seq (MoveTo 1 0) (MoveTo 0 0))
----testfunction
semtest :: CMd -> IO ()
semtest c = ppLines (sem' c)
