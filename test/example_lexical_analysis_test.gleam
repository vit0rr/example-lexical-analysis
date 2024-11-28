import gleeunit
import gleeunit/should
import lexer
import token

pub fn main() {
  gleeunit.main()
}

pub fn read_char_test() {
  let input = "abc"

  let initial_lexer = lexer.new(input)

  let updated_lexer = lexer.read_char(initial_lexer)

  initial_lexer
  |> should.equal(lexer.Lexer("abc", 0, 1, "a"))
  updated_lexer
  |> should.equal(lexer.Lexer("abc", 1, 2, "b"))
}

pub fn skip_whitespace_test() {
  let input = "  abc"

  let initial_lexer = lexer.new(input)

  let updated_lexer = lexer.skip_whitespace(initial_lexer)

  initial_lexer
  |> should.equal(lexer.Lexer("  abc", 0, 1, " "))
  updated_lexer
  |> should.equal(lexer.Lexer("  abc", 2, 3, "a"))
}

pub fn read_type_test() {
  let input = "abc123 xyz"
  let initial_lexer = lexer.new(input)

  let #(updated_lexer, result) = lexer.read_type(lexer.is_letter, initial_lexer)

  initial_lexer
  |> should.equal(lexer.Lexer("abc123 xyz", 0, 1, "a"))

  updated_lexer
  |> should.equal(lexer.Lexer("abc123 xyz", 3, 4, "1"))

  result
  |> should.equal("abc")
}

pub fn tokenize_test() {
  let input =
    "let five = 5;
    let ten = 10;
    let add = fn(x, y) {
      x + y;
    };"

  let tokens = lexer.gen_tokens(input)
  let expected = [
    token.Token(token.LET, "let"),
    token.Token(token.IDENT, "five"),
    token.Token(token.ASSIGN, "="),
    token.Token(token.INT, "5"),
    token.Token(token.SEMICOLON, ";"),
    token.Token(token.LET, "let"),
    token.Token(token.IDENT, "ten"),
    token.Token(token.ASSIGN, "="),
    token.Token(token.INT, "10"),
    token.Token(token.SEMICOLON, ";"),
    token.Token(token.LET, "let"),
    token.Token(token.IDENT, "add"),
    token.Token(token.ASSIGN, "="),
    token.Token(token.FUNCTION, "fn"),
    token.Token(token.LPAREN, "("),
    token.Token(token.IDENT, "x"),
    token.Token(token.COMMA, ","),
    token.Token(token.IDENT, "y"),
    token.Token(token.RPAREN, ")"),
    token.Token(token.LBRACE, "{"),
    token.Token(token.IDENT, "x"),
    token.Token(token.PLUS, "+"),
    token.Token(token.IDENT, "y"),
    token.Token(token.SEMICOLON, ";"),
    token.Token(token.RBRACE, "}"),
    token.Token(token.SEMICOLON, ";"),
    token.Token(token.EOF, ""),
  ]

  tokens
  |> should.equal(expected)
}

pub fn tokenize_operators_test() {
  let input = "=+(){},;"

  let tokens = lexer.gen_tokens(input)
  let expected = [
    token.Token(token.ASSIGN, "="),
    token.Token(token.PLUS, "+"),
    token.Token(token.LPAREN, "("),
    token.Token(token.RPAREN, ")"),
    token.Token(token.LBRACE, "{"),
    token.Token(token.RBRACE, "}"),
    token.Token(token.COMMA, ","),
    token.Token(token.SEMICOLON, ";"),
    token.Token(token.EOF, ""),
  ]

  tokens
  |> should.equal(expected)
}

pub fn tokenize_keywords_test() {
  let input = "fn let true false if else return"

  let tokens = lexer.gen_tokens(input)
  let expected = [
    token.Token(token.FUNCTION, "fn"),
    token.Token(token.LET, "let"),
    token.Token(token.TRUE, "true"),
    token.Token(token.FALSE, "false"),
    token.Token(token.IF, "if"),
    token.Token(token.ELSE, "else"),
    token.Token(token.RETURN, "return"),
    token.Token(token.EOF, ""),
  ]

  tokens
  |> should.equal(expected)
}
