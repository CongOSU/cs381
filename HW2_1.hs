-- Conway Tang
-- CS 381
-- Homework 2

module HW2 where

--import SVG (ppLines)
import SVG
import Data.Maybe
import Data.List
import System.IO

-- Exercise 1
type Prog = [Cmd]

data Cmd = LD Int
         | ADD
         | MULT
         | DUP
         deriving Show

type Stack = [Int]

--type D = Stack -> Stack
type D = Maybe Stack -> Maybe Stack

sem :: Prog -> D
sem [] a = a
sem (o:os) b = sem os (semCmd o b)

semCmd :: Cmd -> D
semCmd (LD e) xs =
       case xs of
            Just xs -> Just (xs ++ [e])
semCmd ADD xs = 
       case xs of
            Just xs -> if length xs < 2
                 then Nothing
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
p1 = [LD (-3),DUP,ADD,DUP,MULT]
p2 = [LD 3,ADD]
p3 = [LD (-1),DUP]

-- tests
t1 = sem p1 s1 --should pass
t2 = sem p2 s1 --should fail
t3 = sem p3 s1


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

-- (b)
type Macros = [(String,Prog2)]
type State = (Stack,Macros)

-- (c)
sem2 :: Prog2 -> State -> State
sem2 [] a = a
sem2 (o:os) b = sem2 os (semCmd2 o b)

semCmd2 :: Cmd2 -> State -> State
semCmd2 (LD2 e) (xs,m) = (xs ++ [e],m)
semCmd2 ADD2 (xs,m) = (init(init xs) ++ [last xs + last(init xs)],m)
semCmd2 MULT2 (xs,m) = (init(init xs) ++ [last xs * last(init xs)],m)
semCmd2 DUP2 (xs,m) = (xs ++ [(last xs)],m)
semCmd2 (DEF s cmds) (xs,ms) = (xs,ms ++ [(s,cmds)])
semCmd2 (CALL s) (xs,m) = sem2 (findFoo s m) (xs,m)

findIdx :: String -> Macros -> Maybe Int
findIdx str macros_list = findIndex (\c -> fst c == str) macros_list

retProg :: Maybe Int -> Macros -> Prog2
retProg n macros_list = snd (macros_list !! fromJust(n))

findFoo :: String -> Macros -> Prog2
findFoo str ms = retProg (findIdx str ms) ms

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


-- Exercise 3
data Cmd3 = Pen Mode
          | MoveTo Int Int
          | Seq Cmd3 Cmd3
          deriving Show

data Mode = Up | Down
          deriving Show

type State2 = (Mode,Int,Int)

semS :: Cmd3 -> State2 -> (State2,Lines)
semS (Seq a b) s0 = (s1,l1++l2)
                    where s1 = fst(semS b (fst(semS a s0)))
                          l1 = snd(semS a s0)
                          l2 = snd(semS b (fst(semS a s0)))
semS (Pen Up) (Up,e,f) = ((Up,e,f),[])
semS (Pen Down) (Up,e,f) = ((Down,e,f),[])
semS (Pen Down) (Down,e,f) = ((Down,e,f),[])
semS (Pen Up) (Down,e,f) = ((Up,e,f),[])
semS (MoveTo e f) (Down,g,h) = ((Down,e,f),[(g,h,e,f)])
semS (MoveTo e f) (Up,g,h) = ((Up,e,f),[])

sem' :: Cmd3 -> Lines
sem' a = snd(semS a (Down,0,0))

--states
s30 = (Up,0,0)
s31 = (Down,0,0)

--commands
c1 :: Cmd3
c1 = Seq (MoveTo 3 4) (MoveTo 5 5)
c2 = MoveTo 3 4
c3 = Pen Up
c4 = Seq c2 c3
c5 = Seq (Seq (MoveTo 3 4) (MoveTo 5 6)) (MoveTo 7 8)

--tests
t31 = semS c4 s31
t32 = semS (Seq (Seq (MoveTo 3 4) (MoveTo 5 6)) (MoveTo 7 8)) s31
t33 = sem' c5
t34 = ppLines t33