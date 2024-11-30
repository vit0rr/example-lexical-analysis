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

/// token_to_string converts a TokenType to a string.
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

/// lookup_ident looks up an identifier and returns the corresponding TokenType.
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
