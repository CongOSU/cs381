module Quiz5 where
--2
-- {int x;
	-- x:=3;
	-- {int f(int y){
		-- x:= x+y;
		-- return(2*x);
		-- };
		-- {int x;
		-- x :=5;
		-- x :=f(x+1);	
		-- };
	-- };

-- }

--dynamic
--after 8,4,9
--8:	[<x:5>,f:{},<x:3>]
--4:	[<y:6>,<x:11>,f:{},<x:3>]
--9:	[<x:22>,f:{},<x:3>]

--static 
--8:	[<x:5>,f:{},<x:3>]
--4:	[<y:6>,<x:5>,f:{},<x:9>]
--9:	[<x:18>,f:{},<x:9>]


--3
-- {
-- int x =5;
-- int y =2;
	-- {int f (int x){
			-- return x-y;
			-- }
	-- int g (int y){
			-- return f(x+1);
			-- }
	-- {int f (int z){
			-- return x-y;
			-- }
-- ->9		x:=g(y+1);
	-- }
	
	-- }
-- }

--dynamic
-- before return of f
--	[z:6,y:3,f:{},g:{},f:{},y:2,x:5]
-- after 9
--	[f:{},g:{},f:{},y:2,x:2]

--static
--before return of f
--	[x:6,y:3,f:{},g:{},f:{},y:2,x:5]
-- after 9
-- [f:{},g:{},f:{},y:2,x:4]