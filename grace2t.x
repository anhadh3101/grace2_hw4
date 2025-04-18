{
module Grace2t  where
}

%wrapper "basic"

$op = [\+\-\*\/]
$alpha = [A-Za-z_]
$digit = 0-9
$alphanum = [$alpha $digit]
$white = [\ \t\n\r]


-- Add your token regular expressions and associated actions below.
tokens :-
  $white+                        ;

  \(                             { \_ -> OpenParen }
  \)                             { \_ -> CloseParen }
  $op                            { \s -> Operator s }
  let                            { \_ -> Let }
  in                             { \_ -> In }
  lambda                         { \_ -> Lambda }
  $alpha[$alphanum]*             { \s -> Identifier s }
  $digit+(\.$digit+)?            { \s -> PosNum (read s) }

  .                              { \s -> error "lexical error" }
{
-- The token type:

data Token = OpenParen
           | CloseParen
           | Operator String
           | PosNum Double
           | Let
           | Lambda
           | In
           | Identifier String
    deriving (Show, Eq)
}