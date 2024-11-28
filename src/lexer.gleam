import gleam/list
import gleam/string
import token

pub type Lexer {
  Lexer(input: String, position: Int, read_position: Int, ch: String)
}

pub const null_byte = "\u{0}"

pub fn peek_char(lexer: Lexer) -> String {
  case lexer.read_position >= string.length(lexer.input) {
    True -> null_byte
    False -> {
      string.slice(lexer.input, lexer.read_position, 1)
    }
  }
}

pub fn read_char(lexer: Lexer) -> Lexer {
  let ch = peek_char(lexer)
  let position = lexer.read_position
  let read_position = position + 1
  Lexer(lexer.input, position, read_position, ch)
}

pub fn new(input: String) -> Lexer {
  let ch = peek_char(Lexer(input, 0, 0, null_byte))
  Lexer(input, 0, 1, ch)
}

pub fn is_letter(ch: String) -> Bool {
  let valid_chars = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ_"

  string.contains(valid_chars, ch)
}

pub fn is_digit(ch: String) -> Bool {
  let valid_chars = "0123456789"

  string.contains(valid_chars, ch)
}

pub fn rec_read(current_lexer: Lexer, predicate: fn(String) -> Bool) {
  case predicate(current_lexer.ch) {
    True ->
      current_lexer
      |> read_char
      |> rec_read(predicate)
    False -> current_lexer
  }
}

pub fn read_type(
  predicate: fn(String) -> Bool,
  lexer: Lexer,
) -> #(Lexer, String) {
  let position = lexer.position

  let rec_read = rec_read(_, predicate)

  let updated_lexer = rec_read(lexer)

  #(
    updated_lexer,
    string.slice(
      updated_lexer.input,
      position,
      updated_lexer.read_position - position - 1,
    ),
  )
}

pub fn read_identifier(lexer: Lexer) -> #(Lexer, String) {
  read_type(is_letter, lexer)
}

pub fn read_number(lexer: Lexer) -> #(Lexer, String) {
  read_type(is_digit, lexer)
}

pub fn skip_whitespace(lexer: Lexer) -> Lexer {
  let rec_read = rec_read(_, fn(ch) { ch == " " || ch == "\t" || ch == "\n" })

  rec_read(lexer)
}

pub fn next_char(lexer: Lexer) -> #(Lexer, token.TokenType, String) {
  let lexer = skip_whitespace(lexer)

  case lexer.ch {
    "\u{0}" -> #(lexer, token.EOF, "")
    "=" ->
      case peek_char(lexer) {
        "=" -> #(lexer |> read_char |> read_char, token.EQ, "==")
        _ -> #(read_char(lexer), token.ASSIGN, "=")
      }
    "!" ->
      case peek_char(lexer) {
        "=" -> #(lexer |> read_char |> read_char, token.NOTEQ, "!=")
        _ -> #(read_char(lexer), token.BANG, "!")
      }
    ";" -> #(read_char(lexer), token.SEMICOLON, ";")
    "(" -> #(read_char(lexer), token.LPAREN, "(")
    ")" -> #(read_char(lexer), token.RPAREN, ")")
    "{" -> #(read_char(lexer), token.LBRACE, "{")
    "}" -> #(read_char(lexer), token.RBRACE, "}")
    "+" -> #(read_char(lexer), token.PLUS, "+")
    "-" -> #(read_char(lexer), token.MINUS, "-")
    "*" -> #(read_char(lexer), token.ASTERISK, "*")
    "/" -> #(read_char(lexer), token.SLASH, "/")
    "<" -> #(read_char(lexer), token.LT, "<")
    ">" -> #(read_char(lexer), token.GT, ">")
    "," -> #(read_char(lexer), token.COMMA, ",")
    ch -> {
      case is_letter(ch) {
        True -> {
          let #(new_lexer, literal) = read_identifier(lexer)
          #(new_lexer, token.lookup_ident(literal), literal)
        }
        False -> {
          case is_digit(ch) {
            True -> {
              let #(new_lexer, literal) = read_number(lexer)
              #(new_lexer, token.INT, literal)
            }
            False -> #(read_char(lexer), token.ILLEGAL, ch)
          }
        }
      }
    }
  }
}

pub fn do_gen_tokens(lexer, tokens) {
  let #(new_lexer, token_type, literal) = next_char(lexer)
  let token = token.Token(token_type, literal)

  case token_type {
    token.EOF -> list.reverse([token, ..tokens])
    _ -> do_gen_tokens(new_lexer, [token, ..tokens])
  }
}

pub fn gen_tokens(input: String) -> List(token.Token) {
  input
  |> new
  |> do_gen_tokens([])
}
