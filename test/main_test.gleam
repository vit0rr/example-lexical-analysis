import gleeunit
import gleeunit/should
import lexer/lexer
import lexer/token

pub fn main() {
  gleeunit.main()
}

pub fn read_char_test() {
  let input = "abc"

  let initial_lexer = lexer.new(input)

  let updated_lexer = lexer.read_char(initial_lexer)

  initial_lexer
  |> should.equal(lexer.Lexer(
    input: "abc",
    position: 0,
    read_position: 1,
    ch: "a",
    literal: "",
  ))
  updated_lexer
  |> should.equal(lexer.Lexer(
    input: "abc",
    position: 1,
    read_position: 2,
    ch: "b",
    literal: "a",
  ))
}

pub fn skip_whitespace_test() {
  let input = "  abc"

  let initial_lexer = lexer.new(input)

  let updated_lexer = lexer.skip_whitespace(initial_lexer)

  initial_lexer
  |> should.equal(lexer.Lexer("  abc", 0, 1, " ", ""))
  updated_lexer
  |> should.equal(lexer.Lexer("  abc", 2, 3, "a", "  "))
}

pub fn read_type_test() {
  let input = "abc123 xyz"
  let initial_lexer = lexer.new(input)

  let #(updated_lexer, result) = lexer.read_type(lexer.is_letter, initial_lexer)

  initial_lexer
  |> should.equal(lexer.Lexer("abc123 xyz", 0, 1, "a", ""))

  updated_lexer
  |> should.equal(lexer.Lexer("abc123 xyz", 3, 4, "1", "abc"))

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
    token.Token(token.Let, "let"),
    token.Token(token.Ident, "five"),
    token.Token(token.Assign, "="),
    token.Token(token.Int, "5"),
    token.Token(token.Semicolon, ";"),
    token.Token(token.Let, "let"),
    token.Token(token.Ident, "ten"),
    token.Token(token.Assign, "="),
    token.Token(token.Int, "10"),
    token.Token(token.Semicolon, ";"),
    token.Token(token.Let, "let"),
    token.Token(token.Ident, "add"),
    token.Token(token.Assign, "="),
    token.Token(token.Function, "fn"),
    token.Token(token.LParen, "("),
    token.Token(token.Ident, "x"),
    token.Token(token.Comma, ","),
    token.Token(token.Ident, "y"),
    token.Token(token.RParen, ")"),
    token.Token(token.LBrace, "{"),
    token.Token(token.Ident, "x"),
    token.Token(token.Plus, "+"),
    token.Token(token.Ident, "y"),
    token.Token(token.Semicolon, ";"),
    token.Token(token.RBrace, "}"),
    token.Token(token.Semicolon, ";"),
    token.Token(token.Eof, ""),
  ]

  tokens
  |> should.equal(expected)
}

pub fn tokenize_operators_test() {
  let input = "=+(){},;"

  let tokens = lexer.gen_tokens(input)
  let expected = [
    token.Token(token.Assign, "="),
    token.Token(token.Plus, "+"),
    token.Token(token.LParen, "("),
    token.Token(token.RParen, ")"),
    token.Token(token.LBrace, "{"),
    token.Token(token.RBrace, "}"),
    token.Token(token.Comma, ","),
    token.Token(token.Semicolon, ";"),
    token.Token(token.Eof, ""),
  ]

  tokens
  |> should.equal(expected)
}

pub fn tokenize_keywords_test() {
  let input = "fn let true false if else return"

  let tokens = lexer.gen_tokens(input)
  let expected = [
    token.Token(token.Function, "fn"),
    token.Token(token.Let, "let"),
    token.Token(token.True, "true"),
    token.Token(token.False, "false"),
    token.Token(token.If, "if"),
    token.Token(token.Else, "else"),
    token.Token(token.Return, "return"),
    token.Token(token.Eof, ""),
  ]

  tokens
  |> should.equal(expected)
}
