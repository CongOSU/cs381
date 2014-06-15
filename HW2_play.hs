module HW2_play where

import Data.Maybe
import SVG



-- 1.

-- (1)
type Prog =[Cmd]

data Cmd = LD Int
		  | ADD
		  | MULT
		  | DUP
		  deriving Show
type Stack = [Int]

type D = Maybe Stack -> Maybe Stack

sem:: Prog -> D
sem [] a = a -- empty instructions, return unchanged stack
sem (c:cx) a = sem cx (semCmd c a)

semCmd:: Cmd -> D
semCmd(LD e) xs =  case xs of
						Just xs -> Just (xs ++[e])
semCmd ADD xs = case xs of
					Just xs -> if length xs <2
						then Nothing
					    -- else Just (tail (tail xs)++ [head xs + head (tail xs) ])
						else Just (init(init xs) ++ [last xs + last(init xs)])
semCmd MULT xs =
       case xs of
            Just xs -> if length xs < 2
                 then Nothing
                 else Just (init(init xs) ++ [last xs * last(init xs)])
semCmd DUP xs =
       case xs of
            Just xs -> if length xs < 1
                 then Nothing
                 else Just (xs ++ [(last xs)])  

-- stacks
s1 = Just []
s2 = Just [1,2,3,4]

-- programs
p1 = [LD 3,DUP,ADD,DUP,MULT]
p2 = [LD 3,ADD]
p3 = []

-- tests
t1 = sem p1 s1 --should pass
t2 = sem p2 s1 --should fail
t3 = sem p1 s2

-- Exercise 2
-- (a)
type Prog2 = [Cmd2]

data Cmd2 = LD2 Int
          | ADD2
          | MULT2
          | DUP2
          | DEF String [Cmd2]
          | CALL String
          deriving Show
type Macros = [(String,Prog2)]

type State = (Stack, Macros)

sem2 :: Prog2 -> State -> State
sem2 [] p = p
sem2 (o:os) p = sem2 os (semCmd2 o p)

semCmd2 :: Cmd2 -> State -> State
semCmd2 (LD2 e) (xs,m) = (xs ++ [e], m)
semCmd2 ADD2 (xs,m) = (init(init xs) ++ [last xs + last(init xs)],m)
semCmd2 MULT2 (xs,m) = (init(init xs) ++ [last xs * last(init xs)],m)
semCmd2 DUP2 (xs,m) = (xs ++ [(last xs)],m)
semCmd2 (DEF s cmds) (xs,m) = (xs,m ++ [(s,cmds)])
semCmd2 (CALL s) (xs,m) = sem2 (findmacro s m)(xs,m)

findmacro:: String -> Macros -> Prog2
findmacro s m = snd(last (filter (\i -> (fst(i) == s))  m))

--stacks
s21 = []
s22 = [1,2,3,4]

--programs
p21 :: Prog2
p21 = [LD2 3,DUP2,ADD2,DUP2,MULT2]
p22 = [LD2 3,ADD2]
p23 = []

--macros
m1 :: Macros
m1 = [("mac1",p21),("mac2",p22)]

--state
st1 = (s22,m1)

--tests
t21 = semCmd2 (CALL "mac2") st1
t22 = semCmd2 (CALL "doesn't_exist") st1
t23 = semCmd2 (DEF "newMac" [LD2 99, LD2 22]) st1

--Exercise 3
data Cmd3 = Pen Mode
		   | MoveTo Int Int
		   | Seq Cmd3 Cmd3
		   deriving Show
data Mode = Up |Down
			deriving Show
type State2 = (Mode, Int , Int)
-- type Line =(Int,Int,Int,Int)
-- type Lines = [Line]


semS:: Cmd3 -> State2 -> (State2,Lines)
semS (Pen Up) (f,x,y) = case f of
						Up -> ((Up,x,y),[])
						Down->((Up,x,y),[])
semS (Pen Down) (f,x,y) = case f of
						Up -> ((Down,x,y),[])
						Down->((Down,x,y),[])
semS(MoveTo x y) (f, m,n) = case f of 
						  Up -> ((Up,x,y),[])
						  Down ->((Down,x,y),[(m,n,x,y)])
semS(Seq c1 c2) (f,x,y) = (fst(semS c2 (fst(semS c1 (f,x,y)))) ,(snd(semS c1 (f,x,y)))++(snd(semS c2 (fst(semS c1 (f,x,y))))))
sem':: Cmd3 -> Lines
sem' c = snd(semS c (Up,0,0))--default Mode
						  
----test
tri = Seq (Seq (Seq (Pen Down) (MoveTo  0 3)) (MoveTo 4 0)) (MoveTo 0 0)
square = Seq (Seq (Seq (Pen Down) (MoveTo 0 2)) (MoveTo 2 2)) (Seq (MoveTo 2 0) (MoveTo 0 0))
----testfunction
semtest :: Cmd3 -> IO ()
semtest c = ppLines (sem' c)