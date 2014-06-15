module Fun where

aa = "Alpha"
	
bb = ["Alpha","1Beta","cGamma"]


a `ele`  []        = False
a `ele` (ab:cs)         = a==ab || (a `ele` cs)

quicksort :: Ord a => [a] -> [a]
quicksort []     = []
quicksort (p:xs) = (quicksort lesser) ++ [p] ++ (quicksort greater)
    where
        lesser  = filter (< p) xs
        greater = filter (>= p) xs

y = [1,2,3,4,5,6,7,8,9,10]		
n :: Int
n = 5

z =	[x | x<-y,x<n]


data Grade = A|B|C|D|F
	deriving (Show,Eq,Ord,Enum)
pass :: Grade -> Bool
pass g = g<D

testPass = all pass [A,C .. F]

-- data Age =  One | Zero Age
	-- deriving (Show)

-- ooo1 = Zero (Zero (Zero One))

data Age = Year Int
	deriving (Show,Eq)

birthday :: Age -> Age
birthday (Year y) = Year (y+1)

drinkingAge :: Age 
drinkingAge = Year 21

geq :: Age->Age->Bool
geq (Year y)(Year z)= y>=z

alcoholOk :: Age -> Bool
-- alcoholOk a = a 'geq' drinkingAge
alcoholOk = geq drinkingAge

jill = Year 20

data Tree = Node Int Tree Tree
			|Leaf
			deriving (Show,Eq)
t = Node 3 (Node 1 Leaf Leaf)
			(Node 5 Leaf Leaf)

find _ Leaf = False
find i (Node j l r) | i==j  =True
					| i<j   = find i l
					|otherwise =find i r
plus :: Int -> Int -> Int
plus a b = a + b

suc :: Int -> Int
suc a = a  +1

ignore x = 42

ones = 1:ones

nar [] =[]
nar (i:x) = i: nar(suc i:x)

eve (i:x) = i + i : eve(suc i:x)

squr (i:x) = i *i :squr(suc i:x)

pow2 (i:x) = 2*i: pow2(2*i:x)

num1 = [1,2,3,4,5,6,7,8,9,10]

num2 [] = []
num2 (a:b) |even a  = a :num2 b
		|otherwise = a +1 :num2 b 
			 
nats = 1 :map succ nats

evens = map (*2) (nar [1])
evens' = 2:map (+2) evens'
evens'' = filter even nats

data Nat = Zero|Succ Nat
	deriving Eq
	
data Sentence = Phrase Noun Verb Noun 
              | And Sentence Sentence 
              deriving Show
data Noun = Dogs | Teeth  deriving Show
data Verb = Have          deriving Show

s1 :: Sentence
s1  = Phrase Dogs Have Teeth

s2 :: Sentence
s2 = Phrase Teeth Have Dogs

s3 :: Sentence
s3 = And s1 s2

err2 = Phrase Dogs Have


