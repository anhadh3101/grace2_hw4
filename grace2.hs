{- CS 152 Homework 4:  Grace 2.0
   Team Name: Team Spartans - Anhadh Sran and Henry -}
module Grace2 where -- do not remove
import Grace2t  -- Make sure you run alex to generate you scanner after you modify Grace2t.x


data ParseTree = NumNode Double
               | OpNode String ParseTree ParseTree
               | IdentNode String
               | LetNode String ParseTree ParseTree
               | FuncNode String ParseTree  -- one formal parameter only lambda x (* 2 x)
               | FuncApp ParseTree ParseTree -- First ParseTree is a FunctNode
        deriving (Show, Eq)

-- Question 1 : implement the scan function below as a call to alexScanTokens
scan :: String -> [Token]
scan = alexScanTokens


-- Question 2: uncomment each step as you work on it

-- parse :: [Token] -> ParseTree

{-
-- <expr> -> POSNUM
--         | IDENTIFIER
--         | LET IDENTIFIER <expr>  IN <expr>
--         | <application>
expr :: [Token] -> (Maybe ParseTree, [Token])


-- <application> -> OPENPAREN OPERATOR <expr> <expr> CLOSEPAREN
--                | <func_application>
application:: [Token] -> (Maybe ParseTree, [Token])


-- <function> -> LAMBDA  IDENTIFIER  <expr>
function :: [Token] -> (Maybe ParseTree, [Token])


-- <func-application> ->    OPENPAREN <function>  <expr> CLOSEPAREN
func_application :: [Token] -> (Maybe ParseTree, [Token])


stringToTree:: String -> ParseTree
stringToTree = parse.scan -- for testing convenience
-}

-- Question 3: uncomment each step as you work on it
{-
eval :: [(String, Double)] -> ParseTree -> Double

evalinit :: ParseTree -> Double

interpret :: String -> Double
interpret = evalinit.parse.scan
-}