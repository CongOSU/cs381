--CS 381 HW1
--Apirl 22, 2013
--Authored by Li Li, Xinyang Chen, Heng Wang


module HW1 where


--Exercise 1: Mini Logo
--(a) Define the abstract syntax
data Cmd = Pen Mode
		 | Mov (Pos,Pos)
		 | Def String(Pars) Cmd
		 | Call String(Vals)
		 | And Cmd Cmd
		 | NoAct
		 deriving (Show)
data Mode = Up | Down
		  deriving (Show)
data Pos = Pnu Int| Pna String
		   deriving (Show)
data Pars = Pana1 String Pars| Pana2 String
		   deriving (Show)
data Vals = Vnu1 Int Vals| Vnu2 Int
		   deriving (Show)
--(b) a Mini Logo program
	-- def vector (position1,position2) ((pen down);
				-- (call vector(1,2) ;
				-- (moveto (2,2);
				-- pen up)))

vector = Def "vector" (Pana1 "position1"(Pana2 "position2")) (And(Pen Down)(And (Call "vector" (Vnu1 1(Vnu2 2))) (And (Mov ((Pnu 2),(Pnu 2))) (Pen Up))))

--(c) Define a function steps :: Int -> Cmd

steps :: Int -> Cmd
steps  0 = NoAct
steps  a = And (steps (a-1))(And (Mov (Pnu((a-1)),Pnu(a)))(Mov (Pnu(a),Pnu(a))))

-- Exercise 2. Digital Circuit Design Language

-- (a)Define the abstract syntax

data Circuit = Circon Gates Links 
			| Lambda2
				deriving(Show)  
data Gates = Gi Int GateFn Gates
			| Lambda
			deriving(Show)
data GateFn = And1
			|Or
			|Xor
			|Not
			deriving(Show)
data Links = FromTo (Int,Int) (Int,Int) Links
			| Lambda1
			deriving(Show)

-- (b) Represent the half adder circuit in Haskell

halfadder = Circon (Gi (1) (Xor) (Gi (2) (And1) ((Lambda))))(FromTo(1,1)(2,1) (FromTo(1,2)(2,2) (Lambda1))) 

-- (c)Define a Haskell function that implements a pretty printer for the above syntax

ppcir :: Circuit -> String
ppcir (Lambda2) = ";"
ppcir (Circon a b)  = ppgate a ++" "++ pplinks b

ppgate :: Gates -> String
ppgate (Lambda) = ";"
ppgate (Gi c a b) = (show c) ++": "++ ppgatefn a++" " ++ ppgate b

ppgatefn :: GateFn -> String
ppgatefn (And1) = "and\n"
ppgatefn (Or) = "or\n"
ppgatefn (Xor) = "xor\n"
ppgatefn (Not) = "not\n"

pplinks :: Links -> String
pplinks (Lambda1) =";\n"
pplinks (FromTo (a,b) (c,d) e) = "from " ++ (show a) ++"."++ (show b) ++" to "++(show c) ++"."++ (show d)++" "++ pplinks e
--print actural \n
nppcir :: Circuit ->IO()
nppcir 	(x)	= putStr (ppcir x)

-- Exercise 3. Designing Abstract Syntax
data Expr = N Int
			| Plus Expr Expr
			| Times Expr Expr
			| Neg Expr
			deriving (Show)
data Op = Add 
		| Multiply
		| Negate
			deriving (Show)
data Exp = Num Int
			| Apply Op [Exp]
			deriving (Show)

--(a) Represent the expression -(3+4)*7 in the alternative abstract syntax.

expression = Apply Negate [(Num 7),(Apply Multiply [(Num 3),(Apply Add [Num 4])])]

--(b) What are the advantages or disadvantages of either representation?

--		Expr advantage: Always construct correct Expr
--  	  disadvantage: Not clear in making a sequence to compute which two Exprs first. 
--      Exp  advantage: Always has a clear sequence to compute.
--        diaadvantage: Not always construct correct Expression, it can construct more "Num Int" than what we need.

-- c) Define a function translate :: Expr -> Exp that translates expressions given 
--in the first abstract syntax into equivalent expressions in the second abstract syntax.

translate :: Expr -> Exp
translate (N a) = (Num a)
translate (Plus a b) = (Apply Add [translate a,translate b]) 
					 
translate (Times a b) = (Apply Multiply [translate a,translate b])

translate (Neg a) = (Apply Negate [translate a]) 
                  
