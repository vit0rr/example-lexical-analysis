import gleam/io
import lexer/lexer

pub fn main() {
  let input = "let hello = \"world\";"

  let tokens = lexer.gen_tokens(input)
  io.debug(tokens)
}
