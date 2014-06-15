--CS381
--HW2
--Authored by Li Li, Heng Wang, Xinyang Chen

module HW2 where
import SVG (ppLines)
import Data.Maybe
import Data.List
import System.IO
--Exercise 1. A Stack Language

type Prog =[Cmd]
data Cmd = LD Int
		 | ADD
		 | MULT
		 | DUP
		 deriving (Show)
type Stack = [Int]

type D = Maybe Stack -> Maybe Stack

sem :: Prog -> D
sem [] s = s
sem (p:ps) s = sem ps(semCmd p s)

semCmd :: Cmd -> D
semCmd (LD n) s = 
		case s of
            Just s -> if n < 0
                 then Nothing
                 else Just (s ++ [n])
--  push
semCmd ADD s = 
       case s of
            Just s -> if length s < 2
                 then Nothing
                 else Just (init(init s) ++ [last s + last(init s)])
semCmd MULT s =
       case s of
            Just s -> if length s < 2
                 then Nothing
                 else Just (init(init s) ++ [last s * last(init s)])
semCmd DUP s =
       case s of
            Just s -> if length s < 1
                 then Nothing
                 else Just (s ++ [(last s)])
-- test
s = Just []


p1 = [LD 3,DUP,ADD,DUP,MULT]
p2 = [LD 3,ADD]
p3 = []

t1 = sem p1 s
--should pass
t2 = sem p2 s
--should fail


-- Exercise 2. Extending the Stack Language by Macros

--(a) Extend the abstract syntax to represent macro definitions and calls, that is, give a correspondingly changed
-- data definition for Cmd.
type Prog2 =[Cmd2]
data Cmd2 = LD2 Int
		 | ADD2
		 | MULT2
		 | DUP2
		 | DEF2 String Prog2
		 | CALL2 String
		 deriving (Show)
-- (b) Define a new type State to represent the state for the new language. 
type Stack2 = [Int]

type Macros2 = [(String, Prog2)]

type D2 = Maybe (Stack2, Macros2) -> Maybe (Stack2, Macros2)

-- (c) Define the semantics for the extended language as a function sem2. As in exercise 1, you probably want to
-- define an auxiliary function semCmd2 for the semantics of individual operations.
sem2 :: Prog2 -> D2
sem2 []     c = c
sem2 (o:os) c = sem2 os (semCmd2 o c)

semCmd2 :: Cmd2 -> D2

semCmd2 (LD2 x) (Just (xs, m)) = Just ((x:xs), m)
semCmd2 (LD2 _) _              = Nothing

semCmd2 ADD2 (Just ((x:y:xs), m)) = Just ((x+y:xs), m)
semCmd2 ADD2 _                    = Nothing

semCmd2 MULT2 (Just ((x:y:xs), m)) = Just ((x*y:xs), m)
semCmd2 MULT2 _                    = Nothing

semCmd2 DUP2 (Just ((x:xs), m)) = Just ((x:x:xs), m)
semCmd2 DUP2 _                  = Nothing

semCmd2 (DEF2 n p) (Just (l, ms)) = Just (l, (n,p):ms)
semCmd2 (DEF2 _ _) _              = Nothing

semCmd2 (CALL2 n) (Just (l, ms)) = case findDef n ms of
										Just x    -> sem2 (snd x) (Just (l, ms))
										otherwise -> Nothing
semCmd2 (CALL2 _) _              = Nothing

findDef :: String -> Macros2 -> Maybe (String, Prog2)
findDef n ms = find (\c -> fst c == n) ms

--test2
test2 :: Prog2 -> Maybe (Stack2, Macros2)
test2 l = sem2 l (Just ([], []))


--Exercise 3 Mini Logo
data Cmd3 = Pen Mode
		 | MoveTo Int Int
		 | Seq Cmd3 Cmd3 deriving Show

data Mode = Up | Down deriving (Eq, Show)

type State1 = (Mode, Int, Int)

type Line = (Int, Int, Int, Int)
type Lines = [Line]

sems:: Cmd3 -> State1 -> (State1, Lines)
sems (Pen a) (_,b,c) = ((a,b,c),[])
sems (MoveTo i j) (a,b,c) 
						  | a == Up = ((a,i,j),[])
						  | a == Down = ((a,i,j),[(b,c,i,j)])
sems (Seq x y) (a,b,c) = ((fst (sems y (fst (sems x (a,b,c))))),
							((snd (sems x (a,b,c))) ++ 
								(snd (sems y (fst (sems x (a,b,c)))))))

sem' :: Cmd3 -> Lines
sem' a = snd (sems a (Up,0,0))

----test
tri = Seq (Seq (Seq (Pen Down) (MoveTo  0 3)) (MoveTo 4 0)) (MoveTo 0 0)
square = Seq (Seq (Seq (Pen Down) (MoveTo 0 2)) (MoveTo 2 2)) (Seq (MoveTo 2 0) (MoveTo 0 0))
----testfunction
semtest :: Cmd3 -> IO ()
semtest c = ppLines (sem' c)