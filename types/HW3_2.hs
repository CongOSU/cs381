--code from Shape.hs

data Shape = X
	| TD Shape Shape
	| LR Shape Shape
	deriving Show

type Pixel = (Int,Int)
type Image = [Pixel]

sem :: Shape -> Image 
sem X           = [(1,1)]
sem (LR s1 s2) = d1 ++ [(x+maxx d1,y) | (x,y) <- sem s2] 
                 where d1 = sem s1
sem (TD s1 s2) = d2 ++ [(x,y+maxy d2) | (x,y) <- sem s1] 
                 where d2 = sem s2

maxx :: [Pixel] -> Int
maxx = maximum . map fst

maxy :: [Pixel] -> Int
maxy = maximum . map snd

--defining some shapes for testing

s1 = LR (TD X X) X
{-

should this be:

XX
X

or 

X
XX

it looks like it does end up making the second shape...
okay, i'll assume that's the correct behavior of this function

-}

s2 = LR (TD X X) (TD X X)
{-
XX
XX
-}

s3 = LR (LR X X) (LR X X)

--helper functions, used throughout this problem
rangeX x1 = maximum (fst(unzip x)) - minimum (fst(unzip x))+1
	where
		x = (sem x1) 

rangeY x1 = maximum (snd(unzip x)) - minimum (snd(unzip x))+1
	where
		x = (sem x1) 

{- (a)
	define a type checker for the shape language

	which I'm assuming in this case means to return the bounding box
	of a given shape
-}

type BBox = (Int,Int)

bbox :: Shape -> BBox
bbox x1 = (rangeX x1,rangeY x1)
	
--tests
t1 = bbox s1 --(2,2)
t2 = bbox s2 --still (2,2)
t3 = bbox s3 --(4,1)

{- (b)
Rectangles are a subset of shapes and thus describe a more restricted set of types. By restricting
the application of the TD and LR operations to rectangles only one could ensure that only convex
shapes without holes can be constructed. Define a type checker for the shape language that assigns
types only to rectangular shapes by defining a Haskell function

--

here's one simple way of calculating this:

if the product of the dimensions of our bounding box is equal to the number of pairs...
we have a rectangle

-}

rect :: Shape -> Maybe BBox
rect x1 = 			if ( (rangeX x1)*(rangeY x1) /= length (sem x1)) --see above note
               			then Nothing
               		else Just (rangeX x1,rangeY x1)

t4 = rect s1 -- not a rectangle
t5 = rect s2 -- square (which is a rectangle)
t6 = rect s3 -- is a rectangle



	 
	


