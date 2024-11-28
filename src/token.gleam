pub type TokenType {
  ILLEGAL
  EOF
  // Identifiers and literals
  IDENT
  INT
  // Operators
  ASSIGN
  PLUS
  MINUS
  BANG
  ASTERISK
  SLASH
  LT
  GT
  // Delimiters
  COMMA
  SEMICOLON
  LPAREN
  RPAREN
  LBRACE
  RBRACE
  // Keywords
  FUNCTION
  LET
  TRUE
  FALSE
  IF
  ELSE
  RETURN
  EQ
  NOTEQ
}

pub type Token {
  Token(TokenType, String)
}

pub fn token_to_string(token_type: TokenType) -> String {
  case token_type {
    ILLEGAL -> "ILLEGAL"
    EOF -> "EOF"
    IDENT -> "IDENT"
    INT -> "INT"
    ASSIGN -> "="
    PLUS -> "+"
    MINUS -> "-"
    BANG -> "!"
    ASTERISK -> "*"
    SLASH -> "/"
    LT -> "<"
    GT -> ">"
    COMMA -> ","
    SEMICOLON -> ";"
    LPAREN -> "("
    RPAREN -> ")"
    LBRACE -> "{"
    RBRACE -> "}"
    FUNCTION -> "FUNCTION"
    LET -> "LET"
    TRUE -> "TRUE"
    FALSE -> "FALSE"
    IF -> "IF"
    ELSE -> "ELSE"
    RETURN -> "RETURN"
    EQ -> "=="
    NOTEQ -> "!="
  }
}

pub fn lookup_ident(ident: String) -> TokenType {
  case ident {
    "fn" -> FUNCTION
    "let" -> LET
    "true" -> TRUE
    "false" -> FALSE
    "if" -> IF
    "else" -> ELSE
    "return" -> RETURN
    _ -> IDENT
  }
}

pub fn tokens_eq(tok_a: TokenType, tok_b: TokenType) -> Bool {
  case tok_a {
    ILLEGAL -> tok_b == ILLEGAL
    EOF -> tok_b == EOF
    IDENT -> tok_b == IDENT
    INT -> tok_b == INT
    ASSIGN -> tok_b == ASSIGN
    PLUS -> tok_b == PLUS
    MINUS -> tok_b == MINUS
    BANG -> tok_b == BANG
    ASTERISK -> tok_b == ASTERISK
    SLASH -> tok_b == SLASH
    LT -> tok_b == LT
    GT -> tok_b == GT
    COMMA -> tok_b == COMMA
    SEMICOLON -> tok_b == SEMICOLON
    LPAREN -> tok_b == LPAREN
    RPAREN -> tok_b == RPAREN
    LBRACE -> tok_b == LBRACE
    RBRACE -> tok_b == RBRACE
    FUNCTION -> tok_b == FUNCTION
    LET -> tok_b == LET
    TRUE -> tok_b == TRUE
    FALSE -> tok_b == FALSE
    IF -> tok_b == IF
    ELSE -> tok_b == ELSE
    RETURN -> tok_b == RETURN
    EQ -> tok_b == EQ
    NOTEQ -> tok_b == NOTEQ
  }
}

pub fn new_token(token_type: TokenType, ch: String) -> Token {
  Token(token_type, ch)
}
