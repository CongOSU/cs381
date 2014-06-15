-- CS381, Homework 1 2013/4/22
-- Xinyang Chen, Heng Wang, Li Li

-- Exercise 1 Mini Logo
-- (a) abstract syntax
data Cmd = Pen Mode
         | MoveTo (Pos, Pos)
		 | Def String Pars Cmd
		 | Seq Cmd Cmd
		 | Call String Vals
		 | Noop 
		 deriving Show
data Mode = Up | Down
           deriving Show
data Pos = N Int | Na String
           deriving Show
data Pars = Nam String Pars 
          | Name String
		    deriving Show
data Vals = Nu Int Vals 
          | Num Int
		    deriving Show
		  
-- (b) vector macro
--     def vector(x1,y1,x2,y2)
--              moveto(x1,y1);
--              Pen down;
--              moveto(x2,y2);
--              Pen up


vector = Def "vector" (Nam "x1" (Nam "y1" (Nam "x2"(Name "y2")))) 
				(
				 Seq 
				   (
				     Seq 
					     (
					     MoveTo (Na "x1",Na "y1")
					     )
				         (Pen Down)
				   ) 
				   ( 
				     Seq (
					      MoveTo (Na "x2",Na "y2")
						  ) 
						 (Pen Up)
				   )	
				)
				
-- (c) Drawing A Stair

steps :: Int -> Cmd
steps 0 = Noop
steps n = Seq (
                Seq 
				 (MoveTo (N n, N n)) 
				 (Pen Down)
			   ) 
			   (rightangles(n))


rightangles :: Int -> Cmd
rightangles 0 = (Pen Up)
rightangles n = Seq 
              (
			    Seq 
				(MoveTo (N (n-1), N n)) 
				(MoveTo (N (n-1), N (n-1)))
			   ) 
				(rightangles(n-1))
				
				
-- Exercise 2 Digital Circuit Design Language
-- (a) Abstract Syntax

type Circuit = (Gates, Links)
type Gates = [(Int,GateFn)]
data GateFn = And
            | Or
            | Xor
            | Not
			  deriving Show
type Links = [Connect]
data Connect = FromTo (Int,Int) (Int,Int)
		      deriving Show

		   
-- (b) The Half Adder Circuit  

adder = ([(1, Xor),(2, And)],[FromTo (1,1) (2,1), FromTo (2,1) (2,2)])
        		
-- (c) pretty printer








