-- idea of block
-- { 	int x;
		-- int y;
		-- x := 1;
		-- { 	int x;
			-- x := 5;
			-- y := x;
		-- };
-- { 	int z;
		-- y := x;
-- }
-- }
-- activation record
-- virtual stack
-- []
-- [<x:?,y:?>]	push
-- [<x:1,y:?>]
-- [<x:?>,<x:1,y:?>] push
-- [<x:5>,<x:1,y:5>]
-- [<x:1,y:5>]	pop
-- [<z:?>,<x:1,y:5>] push
-- [<z:?>,<x:1,y:1>]
-- [<x:1,y:1>]	pop
-- []	pop

-- A declaration of a group of variables is equivalent to a corresponding group of nested blocks for each variable.





