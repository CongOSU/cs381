--cs381 HW4 
--by Li Li, Xinyang Chen, Heng Wang


--Exercise 1. Runtime Stack

-- 1 { 	int x;
-- 2 	int y;
-- 3 	y := 1;
-- 4 	{ 	int f(int x) {
-- 5 		if x=0 then {
-- 6 				y := 1 }
-- 7 		else {
-- 8 				y := f(x-1)*y+1 };
-- 9 		return y;
-- 10 		};
-- 11 		x := f(2);
-- 12	 };
-- 13 }

-- Draw a complete runtime stack, assume static scoping and call-by-value parameter passing.
{-
	0	[]
	1	[x:?]		
	2	[y:?,x:?]	
	3	[y:1,x:?]
	4	[f:{},y:1,x:?]	
	11	>>	
				[x:2,f:{},y:1,x:?]		
			8	>>	--since x=2, goto else
						[x:1,x:2,f:{},y:1,x:?]
					8	>>	--since x=1, goto else
								[x:0,x:1,x:2,f:{},y:1,x:?]
							8	[x:0,x:1,x:2,f:{},y:1,x:?]	--as x=0, y=1
							9	[res:1,x:0,x:1,x:2,f:{},y:1,x:?]
						<<
					8	[x:1,x:2,f:{},y:2,x:?]
					9	[res:2,x:1,x:2,f:{},y:2,x:?]
				<<
			8	[x:2,f:{},y:5,x:?]
			9	[res:5,x:2,f:{},y:5,x:?]
		<<
	11	[f:{},y:5,x:5]
	12	[f:{},y:5,x:5]
	13	[]
-}

-- Exercise 2. Static and Dynamic Scope
-- 1 {		int x;
-- 2 		int y;
-- 3 		int z;
-- 4 		x := 3;
-- 5 		y := 7;
-- 6 		{ 	int f(int y) { return x*y };
-- 7 			int y;
-- 8 			y := 11;
-- 9 			{ 	int g(int x) { return f(y) };
-- 10 				{ 	int y;
-- 11 					y := 13;
-- 12 					z := g(2);
-- 13 				};
-- 14 			};
-- 15 		};
-- 16 }

--	Assume call-by-value parameter passing.
--	a)Which value will be assigned to z in line 12 under static scoping?

{-
	0	[]
	3	[z:?,y:?,x:?]
	5	[z:?,y:7,x:3]
	6	[f:{},z:?,y:7,x:3]
	7	[y:?,f:{},z:?,y:7,x:3]
	8	[y:11,f:{},z:?,y:7,x:3]
	9	[g:{},y:11,f:{},z:?,y:7,x:3]
	10	[y:?,g:{},y:11,f:{},z:?,y:7,x:3]
	11	[y:13,g:{},y:11,f:{},z:?,y:7,x:3]
	12	>>
				[x:2,y:13,g:{},y:11,f:{},z:?,y:7,x:3]
			9	>>
					[y:11,x:2,y:13,g:{},y:11,f:{},z:?,y:7,x:3]
				6	>>
						[res:33,y:11,x:2,y:13,g:{},y:11,f:{},z:?,y:7,x:3]
					<<
				6	[res:33,x:2,y:13,g:{},y:11,f:{},z:?,y:7,x:3]	-- return of f
				<<
			9	[res:33,y:13,g:{},y:11,f:{},z:?,y:7,x:3]	--return of g
		<<
	12	[y:13,g:{},y:11,f:{},z:33,y:7,x:3]
	...
-}

-- So, after 12, the value of z is 33 under static scoping.

--	b) Which value will be assigned to z in line 12 under dynamic scoping?

{-
	0	[]
	3	[z:?,y:?,x:?]
	5	[z:?,y:7,x:3]
	6	[f:{},z:?,y:7,x:3]
	7	[y:?,f:{},z:?,y:7,x:3]
	8	[y:11,f:{},z:?,y:7,x:3]
	9	[g:{},y:11,f:{},z:?,y:7,x:3]
	10	[y:?,g:{},y:11,f:{},z:?,y:7,x:3]
	11	[y:13,g:{},y:11,f:{},z:?,y:7,x:3]
	12	>>
				[x:2,y:13,g:{},y:11,f:{},z:?,y:7,x:3]
			9	>>
					[y:13,x:2,y:13,g:{},y:11,f:{},z:?,y:7,x:3]	--read the most recent y
				6	>>
						[res:26,y:13,x:2,y:13,g:{},y:11,f:{},z:?,y:7,x:3]
					<<
				6	[res:26,x:2,y:13,g:{},y:11,f:{},z:?,y:7,x:3]	-- return of f
				<<
			9	[res:26,y:13,g:{},y:11,f:{},z:?,y:7,x:3]	--return of g
		<<
	12	[y:13,g:{},y:11,f:{},z:26,y:7,x:3]
	...
-}
-- So, after 12, the value of z is 26 under dynamic scoping.


--Exercise 3. Parameter Passing

-- 1 { 		int y;
-- 2 		int z;
-- 3 		y := 7;
-- 4 		{ 	int f(int a) {
-- 5 							y := a+1;
-- 6 							return (y+a)
-- 7 						};
-- 8 			int g(int x) {
-- 9 							y := f(x+1)+1;
-- 10 							z := f(x-y+3);
-- 11 							return (z+1)
-- 12 						}
-- 13 			z := g(y*2);
-- 14 		};
-- 15 }

-- Assume dynamic scoping.	What are the values of y and z at the end of the above block under the 
-- assumption that both parameters a and x are passed:
-- (a) Call-by-Name
{-
	0	[]
	3	[z:?,y:7]
	4	[f:{},z:?,y:7]
	8	[g:{},f:{},z:?,y:7]
	13	>>
				[<x:y*2>,g:{},f:{},z:?,y:7]
			9	>>
						[<a:x+1>,<x:y*2>,g:{},f:{},z:?,y:7]
					5	[<a:x+1>,<x:y*2>,g:{},f:{},z:?,y:16]
					6	[res:49,<a:x+1>,<x:y*2>,g:{},f:{},z:?,y:16] -- return of f
				<<
			9	[<x:y*2>,g:{},f:{},z:?,y:50] 
			10	>>
					[<a:x-y+3>,<x:y*2>,g:{},f:{},z:?,y:50]
				5	[<a:x-y+3>,<x:y*2>,g:{},f:{},z:?,y:54]
				6	[res:y+a=y+y*2-y+3=111,<a:x-y+3>,<x:y*2>,g:{},f:{},z:?,y:54] --return of f
				<<
			10	[<x:y*2>,g:{},f:{},z:111,y:54]
			11	[res:112,<x:y*2>,g:{},f:{},z:111,y:54] --return of g
	13	[g:{},f:{},z:112,y:54]
	14	[g:{},f:{},z:112,y:54]
	15	[]
-}

-- So, the answer would be y:54
--						   z:112

-- (b) Call-by Need

{-
	0	[]
	3	[z:?,y:7]
	4	[f:{},z:?,y:7]
	8	[g:{},f:{},z:?,y:7]
	13	>>
				[<x:y*2>,g:{},f:{},z:?,y:7]
			9	>>
						[<a:x+1>,<x:14>,g:{},f:{},z:?,y:7]
					5	[<a:15>,<x:14>,g:{},f:{},z:?,y:16]
					6	[res:31,<a:15>,<x:14>,g:{},f:{},z:?,y:16] -- return of f
				<<
			9	[<x:14>,g:{},f:{},z:?,y:32] 
			10	>>
					[<a:x-y+3>,<x:14>,g:{},f:{},z:?,y:32]
				5	[<a:-15>,<x:14>,g:{},f:{},z:?,y:-14]
				6	[res:-29,<a:-15>,<x:14>,g:{},f:{},z:?,y:-14] --return of f
				<<
			10	[<x:14>,g:{},f:{},z:-29,y:-14]
			11	[res:-28,<x:14>,g:{},f:{},z:-29,y:-14] --return of g
	13	[g:{},f:{},z:-28,y:-14]
	14	[g:{},f:{},z:-28,y:-14]
	15	[]
-}
-- So, the answer would be y:-14
--						   z:-28
