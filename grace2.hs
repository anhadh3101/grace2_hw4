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
parse :: [Token] -> ParseTree
parse toks =
  case expr toks of
    (Just tree, []) -> tree
    (_, remaining)  -> error $ "Syntax Error - extra tokens: " ++ show remaining


-- <expr> -> POSNUM
--         | IDENTIFIER
--         | LET IDENTIFIER <expr>  IN <expr>
--         | <application>
expr :: [Token] -> (Maybe ParseTree, [Token])
expr (PosNum n : toks) = (Just (NumNode n), toks)
expr (Identifier x : toks) = (Just (IdentNode x), toks)
expr (Let : Identifier x : toks) =
  let (e1, toks1) = expr toks
  in case toks1 of
       (In : rest) ->
         let (e2, toks2) = expr rest
         in case (e1, e2) of
              (Just v1, Just v2) -> (Just (LetNode x v1 v2), toks2)
              _ -> (Nothing, rest)
       _ -> error $ "Syntax Error - expected 'in', found: " ++ show toks1
expr toks = application toks
expr _ = error "Syntax Error - invalid expression"


-- <application> -> OPENPAREN OPERATOR <expr> <expr> CLOSEPAREN
--                | <func_application>
application:: [Token] -> (Maybe ParseTree, [Token])
application (OpenParen : Operator op : toks) =
  let (e1, toks1) = expr toks
      (e2, toks2) = expr toks1
  in case toks2 of
       (CloseParen : rest) ->
         case (e1, e2) of
           (Just v1, Just v2) -> (Just (OpNode op v1 v2), rest)
           _ -> (Nothing, rest)
       _ -> error "Syntax Error - expected closing parenthesis"
application toks = func_application toks


-- <function> -> LAMBDA  IDENTIFIER  <expr>
function :: [Token] -> (Maybe ParseTree, [Token])
function (Lambda : Identifier x : toks) =
  let (body, rest) = expr toks
  in case body of
       Just b -> (Just (FuncNode x b), rest)
       _ -> (Nothing, rest)
function toks = (Nothing, toks)




-- <func-application> ->    OPENPAREN <function>  <expr> CLOSEPAREN
func_application :: [Token] -> (Maybe ParseTree, [Token])
func_application (OpenParen : toks) =
  let (f, toks1) = function toks
  in case f of
       Just fn ->
         let (arg, toks2) = expr toks1
         in case toks2 of
              (CloseParen : rest) ->
                case arg of
                  Just a -> (Just (FuncApp fn a), rest)
                  _ -> (Nothing, rest)
              _ -> error "Syntax Error - expected closing parenthesis"
       _ -> error $ "Syntax Error - invalid expression " ++ show toks
func_application toks = (Nothing, toks)

stringToTree:: String -> ParseTree
stringToTree = parse.scan -- for testing convenience

-- Question 3: uncomment each step as you work on it
eval :: [(String, Double)] -> ParseTree -> Double
eval _ (NumNode n) = n
eval env (IdentNode x) =
  case lookup x env of
    Just v -> v
    Nothing -> error $ "Undefined Identifier: " ++ x
eval env (OpNode op e1 e2) =
  let v1 = eval env e1
      v2 = eval env e2
  in case op of
    "+" -> v1 + v2
    "-" -> v1 - v2
    "*" -> v1 * v2
    "/" -> v1 / v2
    _   -> error $ "Unknown operator: " ++ op
eval env (LetNode name valExpr bodyExpr) =
  let val = eval env valExpr
  in eval ((name, val) : env) bodyExpr
eval env (FuncApp funcExpr argExpr) =
  let (FuncNode param body) = funcExpr
      argVal = eval env argExpr
  in eval ((param, argVal) : env) body
eval _ (FuncNode _ _) = error "Cannot evaluate a function without applying it"

evalinit :: ParseTree -> Double
evalinit = eval []

interpret :: String -> Double
interpret = evalinit.parse.scan
