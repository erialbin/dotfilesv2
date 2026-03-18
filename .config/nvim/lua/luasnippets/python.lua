local ls = require("luasnip")
local s = ls.snippet
local sn = ls.snippet_node
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local d = ls.dynamic_node
local rep = require("luasnip.extras").rep
local fmt = require("luasnip.extras.fmt").fmt

return {
  s("init", fmt(
    [[
def __init__(self) -> None:
  {}
]],
    { i(1) }
  )),

  s("main", fmt(
    [[
def main() -> None:
  {}


if __name__ == '__main__':
  main()
]],
    { i(1) }
  ))

}
