--CS 381
--homework 1
--Authors : Chao Peng & Canhua Huang
--Date: April 23,2013

module Homework1 where

-- Exercise 1 Mini Logo 
-- cmd ::= pen mode
-- 		|  moveto (pos, pos)
--		|  def name (pars) cmd
--		|  call name (vals) 
--		|  cmd;cmd
-- mode ::= up | down
-- pose ::= num | name
-- pars ::= name,pars | name
-- vals ::= num,vals | num
-- 
-- Grammars are represented as Haskell data types as follows.
--
-- (1) For each nonterminal define a data type
-- (2) For each production, define a constructor 
-- (3) Argument types of constructors are determined by the 
--     production's nonterminals
-- (4) For nonterminals that represent tokens (like Id, Con, 
--     or Num) use built-in Haskell types (like String or Integer)


-- Exercise 1 Mini Logo (a)
data Cmd = PEN Mode
		 | MOVETO (Pos,Pos)
		 | DEF String Pars Cmd
		 | CALL String Vals
		 | CC Cmd Cmd 
		 | NOOP deriving Show
data Mode = UP | DOWN deriving Show
data Pos = I Integer | S String deriving Show
data Pars = SP String Pars | ST String deriving Show
data Vals = IV Integer Vals | INT Integer deriving Show

-- Exercise 1 Mini Logo (b)
{-
Mini Logo macro vector: def vector (x1,y1,x2,y2) moveto 
								   (x1,y1);pen down;moveto (x2,y2);pen up 
-}
vector = DEF "vector" (SP "x1" (SP "y1" (SP "x2"
				 (ST "y2")))) (CC (CC (MOVETO (S "x1",S "y1"))
				 (PEN DOWN)) (CC (MOVETO (S "x2",S "y2")) (PEN UP)))

-- Exercise 1 Mini Logo (c)
steps :: Integer->Cmd
steps 0 = NOOP
steps n = CC (CC (MOVETO (I n, I n)) (PEN DOWN)) (stairs(n))

stairs :: Integer -> Cmd
stairs 0 = (PEN UP)
stairs n = CC (CC (MOVETO (I (n-1), I n)) (MOVETO (I (n-1), I (n-1)))) 
				(stairs(n-1))


--Exercise 2 Digit Circuit Design Language
--
--circuit ::= gates; links
--gates ::= num:gateFn ; gates | ε
--gateFn ::= and |or |xor |not
--links ::= from num.num to num.num; links | ε


--Exercise 2 Digit Circuit Design Language (a)
--when I use Int instead of Integer
--I got an error:
--Couldn't match expected type `Int' with actual type `Integer'
--Expected type: (Gates, [Link])
--  Actual type: ([(Integer, GateFn)], [Link])
--In the first argument of `ppTSc', namely `halfAdder'
--In the expression: ppTSc halfAdder
type Circuit = (Gates, Links)
type Gates = [(Integer,GateFn)]
data GateFn = AND | OR | XOR | NOT deriving Show
type Links = [Link]
data Link = FROM (Integer, Integer) (Integer, Integer) deriving Show

--Exercise 2 Digit Circuit Design Language (b)

halfAdder = ([(1, XOR),(2, AND)], [FROM (1, 1) (2, 1), FROM (1, 2) (2, 2)])

--Exercise 2 Digit Circuit Design Language (c)

--pretty printer for GateFn:data GateFn = AND | OR | XOR | NOT
ppGateFn :: GateFn -> String
ppGateFn AND = ":and;\n"
ppGateFn OR = ":or;\n"
ppGateFn XOR = ":xor;\n"
ppGateFn NOT = ":not;\n"

--pretty printer for Gates:type Gates = [(Integer,GateFn)]
ppGates :: [(Integer,GateFn)] -> String
ppGates [] = ""
ppGates (x:xs) = ppSym x ++ ppGates xs

ppSym :: (Integer, GateFn) -> String
ppSym (x,y) 
	| x==0 = "0" ++ ppGateFn y
	| x==1 = "1" ++ ppGateFn y
	| x==2 = "2" ++ ppGateFn y

--pretty printer for [Link]:data Link = FROM (Integer, Integer) 
--							(Integer, Integer)
ppLink' :: Link -> String
ppLink' (FROM (x,y) (w,z)) = "from "++ str x ++"." ++ str y
							 ++ " to "++ str w ++ "." ++ str z ++ ";\n"
str :: Integer -> String
str 0 = "0"
str 1 = "1"
str 2 = "2"

ppLink :: [Link] -> String
ppLink [] = ""
ppLink (x:xs) = ppLink' x ++ ppLink xs

--pretty printer for Circuit:type Circuit = (Gates, Links)
ppCircuit:: Circuit-> String
ppCircuit (x,y) = ppGates x ++ ";\n" ++ ppLink y

ppTSc :: (Gates, [Link])  -> IO()
ppTSc p = putStr (ppCircuit p)

--Exercise 3 Designing Abstract Syntax
data Expr = N Int
          | Plus Expr Expr
          | Times Expr Expr
          | Neg Expr 
          --deriving Show
--alternative abstract syntax 
data Op = Add | Multiply | Negate deriving Show
data Exp = Num Int
	     | Apply Op [Exp] deriving Show

--Exercise 3 Designing Abstract Syntax (a)
--original representation:
--y = Times (Neg (Plus (N 3) (N 4)) )  (N 7)
--Represent the expression -(3+4)*7 in the alternative abstract syntax
x = Apply Multiply [ Apply Negate [ Apply Add[ Num 3, Num 4 ] ], Num 7]

--Exercise 3 Designing Abstract Syntax (b)
--
--The first abstract syntax ensures that Neg constructor can only take one 
--operand, which is definitely right to normal neg syntax. But the 
--alternative one allows Neg to have more than one operands or no operand. 
--That's impossible.Relatively, other legal operations in the alternative 
--one allow more than two operands. It is easy to define long arithmetic 
--expressions.

--Exercise 3 Designing Abstract Syntax (c)
translator :: Expr -> Exp
translator (N i) = Num i
translator (Plus f s) = Apply Add [translator f, translator s]
translator (Times f s) = Apply Multiply [translator f, translator s]
translator (Neg i) = Apply Negate [translator i] 
--test:
-- translator y
--Apply Multiply [Apply Negate [Apply Add [Num 3,Num 4]],Num 7]