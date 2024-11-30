import gleam/list
import gleam/string
import lexer/token

pub type Lexer {
  Lexer(
    input: String,
    position: Int,
    read_position: Int,
    ch: String,
    literal: String,
  )
}

const null_byte = "\u{0}"

fn peek_char(lexer: Lexer) -> String {
  case lexer.read_position >= string.length(lexer.input) {
    True -> null_byte
    False -> {
      string.slice(lexer.input, lexer.read_position, 1)
    }
  }
}

/// Reads the next character in the input and returns the updated lexer.
pub fn read_char(lexer: Lexer) -> Lexer {
  let ch = peek_char(lexer)
  let position = lexer.read_position
  let read_position = position + 1
  let literal = lexer.literal <> lexer.ch
  Lexer(lexer.input, position, read_position, ch, literal)
}

/// Creates a new lexer for the given input.
pub fn new(input: String) -> Lexer {
  let ch = peek_char(Lexer(input, 0, 0, null_byte, ""))
  Lexer(input, 0, 1, ch, "")
}

/// Checks if the given character is a letter.
pub fn is_letter(ch: String) -> Bool {
  let valid_chars = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ_"

  string.contains(valid_chars, ch)
}

fn is_digit(ch: String) -> Bool {
  let valid_chars = "0123456789"

  string.contains(valid_chars, ch)
}

fn rec_read(current_lexer: Lexer, predicate: fn(String) -> Bool) {
  case predicate(current_lexer.ch) {
    True ->
      current_lexer
      |> read_char
      |> rec_read(predicate)
    False -> current_lexer
  }
}

/// Reads the next character in the input that matches the given predicate.
pub fn read_type(
  predicate: fn(String) -> Bool,
  lexer: Lexer,
) -> #(Lexer, String) {
  let lexer = Lexer(..lexer, literal: "")
  let updated_lexer = rec_read(lexer, predicate)
  #(updated_lexer, updated_lexer.literal)
}

fn read_identifier(lexer: Lexer) -> #(Lexer, String) {
  read_type(is_letter, lexer)
}

fn read_number(lexer: Lexer) -> #(Lexer, String) {
  read_type(is_digit, lexer)
}

/// Skips the whitespace characters in the input and returns the updated lexer.
pub fn skip_whitespace(lexer: Lexer) -> Lexer {
  let rec_read = rec_read(_, fn(ch) { ch == " " || ch == "\t" || ch == "\n" })

  rec_read(lexer)
}

fn next_char(lexer: Lexer) -> #(Lexer, token.TokenType, String) {
  let lexer = skip_whitespace(lexer)

  case lexer.ch {
    "\u{0}" -> #(lexer, token.Eof, "")
    "=" ->
      case peek_char(lexer) {
        "=" -> #(lexer |> read_char |> read_char, token.Eq, "==")
        _ -> #(read_char(lexer), token.Assign, "=")
      }
    "!" ->
      case peek_char(lexer) {
        "=" -> #(lexer |> read_char |> read_char, token.NotEq, "!=")
        _ -> #(read_char(lexer), token.Bang, "!")
      }
    ";" -> #(read_char(lexer), token.Semicolon, ";")
    "(" -> #(read_char(lexer), token.LParen, "(")
    ")" -> #(read_char(lexer), token.RParen, ")")
    "{" -> #(read_char(lexer), token.LBrace, "{")
    "}" -> #(read_char(lexer), token.RBrace, "}")
    "+" -> #(read_char(lexer), token.Plus, "+")
    "-" -> #(read_char(lexer), token.Minus, "-")
    "*" -> #(read_char(lexer), token.Asterisk, "*")
    "/" -> #(read_char(lexer), token.Slash, "/")
    "<" -> #(read_char(lexer), token.Lt, "<")
    ">" -> #(read_char(lexer), token.Gt, ">")
    "," -> #(read_char(lexer), token.Comma, ",")
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
              #(new_lexer, token.Int, literal)
            }
            False -> #(read_char(lexer), token.Illegal, ch)
          }
        }
      }
    }
  }
}

fn do_gen_tokens(lexer, tokens) {
  let #(new_lexer, token_type, literal) = next_char(lexer)
  let token = token.Token(token_type, literal)

  case token_type {
    token.Eof -> list.reverse([token, ..tokens])
    _ -> do_gen_tokens(new_lexer, [token, ..tokens])
  }
}

/// Generates a list of tokens from the given input.
pub fn gen_tokens(input: String) -> List(token.Token) {
  input
  |> new
  |> do_gen_tokens([])
}
