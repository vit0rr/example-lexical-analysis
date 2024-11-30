pub type TokenType {
  Illegal
  Eof
  // Identifiers and literals
  Ident
  Int
  // Operators
  Assign
  Plus
  Minus
  Bang
  Asterisk
  Slash
  Lt
  Gt
  // Delimiters
  Comma
  Semicolon
  LParen
  RParen
  LBrace
  RBrace
  // Keywords
  Function
  Let
  True
  False
  If
  Else
  Return
  Eq
  NotEq
}

pub type Token {
  Token(TokenType, String)
}

pub fn token_to_string(token_type: TokenType) -> String {
  case token_type {
    Illegal -> "ILLEGAL"
    Eof -> "EOF"
    Ident -> "IDENT"
    Int -> "INT"
    Assign -> "="
    Plus -> "+"
    Minus -> "-"
    Bang -> "!"
    Asterisk -> "*"
    Slash -> "/"
    Lt -> "<"
    Gt -> ">"
    Comma -> ","
    Semicolon -> ";"
    LParen -> "("
    RParen -> ")"
    LBrace -> "{"
    RBrace -> "}"
    Function -> "FUNCTION"
    Let -> "LET"
    True -> "TRUE"
    False -> "FALSE"
    If -> "IF"
    Else -> "ELSE"
    Return -> "RETURN"
    Eq -> "=="
    NotEq -> "!="
  }
}

pub fn lookup_ident(ident: String) -> TokenType {
  case ident {
    "fn" -> Function
    "let" -> Let
    "true" -> True
    "false" -> False
    "if" -> If
    "else" -> Else
    "return" -> Return
    _ -> Ident
  }
}

pub fn tokens_eq(tok_a: TokenType, tok_b: TokenType) -> Bool {
  case tok_a {
    Illegal -> tok_b == Illegal
    Eof -> tok_b == Eof
    Ident -> tok_b == Ident
    Int -> tok_b == Int
    Assign -> tok_b == Assign
    Plus -> tok_b == Plus
    Minus -> tok_b == Minus
    Bang -> tok_b == Bang
    Asterisk -> tok_b == Asterisk
    Slash -> tok_b == Slash
    Lt -> tok_b == Lt
    Gt -> tok_b == Gt
    Comma -> tok_b == Comma
    Semicolon -> tok_b == Semicolon
    LParen -> tok_b == LParen
    RParen -> tok_b == RParen
    LBrace -> tok_b == LBrace
    RBrace -> tok_b == RBrace
    Function -> tok_b == Function
    Let -> tok_b == Let
    True -> tok_b == True
    False -> tok_b == False
    If -> tok_b == If
    Else -> tok_b == Else
    Return -> tok_b == Return
    Eq -> tok_b == Eq
    NotEq -> tok_b == NotEq
  }
}

pub fn new_token(token_type: TokenType, ch: String) -> Token {
  Token(token_type, ch)
}
