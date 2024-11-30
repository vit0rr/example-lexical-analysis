import gleam/io
import lexer/lexer

pub fn main() {
  let input = "let yeah = 1;"

  let tokens = lexer.gen_tokens(input)
  io.debug(tokens)
}
