-- ~/.config/nvim/luasnippets/tex.lua (for example)

local ls = require("luasnip")
local s = ls.snippet
local sn = ls.snippet_node
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local d = ls.dynamic_node
local rep = require("luasnip.extras").rep
local fmta = require("luasnip.extras.fmt").fmta

-- vimtex helper: math / text condition
local function in_mathzone()
  return vim.fn["vimtex#syntax#in_mathzone"]() == 1
end

local function in_text()
  return not in_mathzone()
end

local snippets = {}
local autosnippets = {}

local function ms(context, nodes, opts)
  table.insert(snippets, s(context, nodes, opts or {}))
end

local function ma(context, nodes, opts)
  opts = opts or {}
  opts.snippetType = "autosnippet"
  table.insert(autosnippets, s(context, nodes, opts))
end

----------------------------------------------------------------------
-- TEXT MODE SNIPPETS (option "t")
----------------------------------------------------------------------
ms({ trig = "maintex", wordTrig = true, condition = in_text }, {
  t("%! Tex root = main.tex"),
})

ms({ trig = "sps", wordTrig = true, condition = in_text }, {
  t("Suppose"),
})

ma({ trig = "HYPOTHESIS", wordTrig = true, condition = in_text }, {
  t("$\\textbf{Hypothesis}$ "),
  i(0),
})

ma({ trig = "CONCLUSION", wordTrig = true, condition = in_text }, {
  t("$\\textbf{Conclusion}$ "),
  i(0),
})

ma({ trig = "PROOF", wordTrig = true, condition = in_text }, {
  t("$\\textit{\\textbf{Proof.}}$ "),
  i(0),
})

ma({ trig = "wts", wordTrig = true, condition = in_text }, {
  t("$\\textit{w.t.s.}$ "),
  i(0),
})

ms({ trig = "beg", wordTrig = true, condition = in_text },
  fmta([[
  \begin{<>}
    <>
  \end{<>}
  ]], {
    i(1),
    i(0),
    rep(1),
  })
)

ms({ trig = "table", wordTrig = true, condition = in_text },
  fmta([[
  \begin{table}
    \centering
    \begin{tabular}{ |c|c|c| }
      \hline
      cell1 & cell2 & cell3 \\
      cell4 & cell5 & cell6 \\
      cell7 & cell8 & cell9 \\
      \hline
    \end{tabular}
  \end{table}
  ]], {})
)

ms({ trig = "fig", wordTrig = true, condition = in_text },
  fmta([[
  \begin{figure}
    \centering
    \includegraphics[0.7=\textwidth]{<>}
    \caption{<>}
    \label{<>}
  \end{figure}
  ]], {
    i(1),
    i(2),
    i(3),
  })
)

----------------------------------------------------------------------
-- TEXT → MATH (your “mk” and “dm”)
----------------------------------------------------------------------

-- inline math
ma(
  { trig = "mk", wordTrig = true, condition = in_text },
  fmta("$<>$ <>", {
    i(1),
    i(0),
  })
)

-- display math
ma(
  { trig = "dm", wordTrig = true, condition = in_text },
  fmta(
    [[
$$
<>
$$
]],
    {
      i(1),
    }
  )
)

----------------------------------------------------------------------
-- MATH MODE SNIPPETS (option "m")
----------------------------------------------------------------------

-- Color
ma(
  { trig = "clr", wordTrig = true, condition = in_mathzone },
  fmta("\\color{<>} <>", {
    i(1, "white"),
    i(0),
  })
)

-- \begin{}...\end{}
ma(
  { trig = "beg", wordTrig = true, condition = in_mathzone },
  fmta(
    [[
\begin{<>}
  <>
\end{<>}]],
    {
      i(1),
      i(2),
      rep(1),
    }
  )
)

-- Fractions, powers, limits, etc.
ma(
  { trig = "//", wordTrig = true, condition = in_mathzone },
  fmta("\\frac{<>}{<>} <>", {
    i(1),
    i(2),
    i(0),
  })
)

ma({ trig = "inv", wordTrig = true, condition = in_mathzone }, {
  t("^{-1}"),
})

ma(
  { trig = "sup", wordTrig = true, condition = in_mathzone },
  fmta("\\sup( <> ) <>", {
    i(1),
    i(0),
  })
)

ma(
  { trig = "inf", wordTrig = true, condition = in_mathzone },
  fmta("\\inf( <> ) <>", {
    i(1),
    i(0),
  })
)

ma(
  { trig = "ppp", wordTrig = true, condition = in_mathzone },
  fmta("^{ <> } <>", {
    i(1),
    i(0),
  })
)

ma(
  { trig = "pp2", wordTrig = true, condition = in_mathzone },
  fmta("^{2} <>", {
    i(0),
  })
)

ma(
  { trig = "ppn", wordTrig = true, condition = in_mathzone },
  fmta("^{n} <>", {
    i(0),
  })
)

-- inner product
ma(
  { trig = "inprod", wordTrig = true, condition = in_mathzone },
  fmta("\\langle <>, <> \\rangle <>", {
    i(1),
    i(2),
    i(0),
  })
)

ma({ trig = "_", wordTrig = false, condition = in_mathzone },
  fmta([[ _{<>}]], {
    i(1), }
  )
)

ma({ trig = "^", wordTrig = false, condition = in_mathzone },
  fmta([[ ^{<>}]], {
    i(1), }
  )
)

-- basic arrows and spacing
ma({ trig = "to", wordTrig = true, condition = in_mathzone }, fmta("\\to <>", { i(0) }))

ma({ trig = "mapsto", wordTrig = true, condition = in_mathzone }, fmta("\\mapsto <>", { i(0) }))

-- Relations and logic
ma({ trig = "iff", wordTrig = true, condition = in_mathzone }, fmta("\\iff <>", { i(0) }))

ma({ trig = "exists", wordTrig = true, condition = in_mathzone }, fmta("\\exists <>", { i(0) }))

ma({ trig = "forall", wordTrig = true, condition = in_mathzone }, fmta("\\forall <>", { i(0) }))

ma({ trig = "===", wordTrig = true, condition = in_mathzone }, fmta("\\equiv <>", { i(0) }))

ma({ trig = "!=", wordTrig = true, condition = in_mathzone }, fmta("\\neq <>", { i(0) }))
ma({ trig = ">=", wordTrig = true, condition = in_mathzone }, fmta("\\geq <>", { i(0) }))
ma({ trig = "<=", wordTrig = true, condition = in_mathzone }, fmta("\\leq <>", { i(0) }))

ma({ trig = ">>", wordTrig = true, condition = in_mathzone }, fmta("\\gg <>", { i(0) }))
ma({ trig = "<<", wordTrig = true, condition = in_mathzone }, fmta("\\ll <>", { i(0) }))

ma({ trig = "grad", wordTrig = true, condition = in_mathzone }, fmta("\\nabla <>", { i(0) }))

-- implication variants
ma({ trig = "=>", wordTrig = false, condition = in_mathzone }, fmta("\\implies <>", { i(0) }))
ma({ trig = "=<", wordTrig = false, condition = in_mathzone }, fmta("\\impliedby <>", { i(0) }))
ma({ trig = "<=>", wordTrig = false, condition = in_mathzone }, {
  t("\\Longleftrightarrow"),
})
ma({ trig = "<==>", wordTrig = false, condition = in_mathzone }, {
  t("\\Longleftrightarrow"),
})
ma({ trig = "rarr", wordTrig = true, condition = in_mathzone }, fmta("\\implies <>", { i(0) }))
ma({ trig = "lrarr", wordTrig = true, condition = in_mathzone }, {
  t("\\Longleftrightarrow"),
})
ma({ trig = "LRARR", wordTrig = true, condition = in_mathzone }, {
  t("\\Longleftrightarrow"),
})

-- basic symbols
ma({ trig = "iso=", wordTrig = true, condition = in_mathzone }, fmta("\\cong <>", { i(0) }))

ma({ trig = "indep", wordTrig = true, condition = in_mathzone }, fmta("\\mathrel{\\unicode{x2AEB}} <>", { i(0) }))

ma({ trig = "comp", wordTrig = true, condition = in_mathzone }, {
  t("\\circ"),
})

ma({ trig = "ooo", wordTrig = true, condition = in_mathzone }, {
  t("\\infty"),
})

ma({ trig = "sum", wordTrig = true, condition = in_mathzone }, {
  t("\\sum"),
})

ma(
  { trig = "bsum", wordTrig = true, condition = in_mathzone },
  fmta("\\sum_{<>}^{<>} <>", {
    i(1),
    i(2),
    i(0),
  })
)

ma({ trig = "prod", wordTrig = true, condition = in_mathzone }, {
  t("\\prod"),
})

ma(
  { trig = "bprod", wordTrig = true, condition = in_mathzone },
  fmta("\\prod_{<>}^{<>} <>", {
    i(1),
    i(2),
    i(0),
  })
)

ma(
  { trig = "lim", wordTrig = true, condition = in_mathzone },
  fmta("\\lim_{ <> \\to <> } <>", {
    i(1, "n"),
    i(2, "\\infty"),
    i(0),
  })
)

-- +/- etc.
ma({ trig = "+-", wordTrig = true, condition = in_mathzone }, {
  t("\\pm"),
})
ma({ trig = "-+", wordTrig = true, condition = in_mathzone }, {
  t("\\mp"),
})

ma({ trig = "...", wordTrig = true, condition = in_mathzone }, {
  t("\\dots"),
})

ma({ trig = "<->", wordTrig = true, condition = in_mathzone }, {
  t("\\leftrightarrow "),
})

-- set operations & membership
ma({ trig = "uni", wordTrig = true, condition = in_mathzone }, fmta("\\cup <>", { i(0) }))
ma({ trig = "buni", wordTrig = true, condition = in_mathzone }, {
  t("\\bigcup"),
})
ma({ trig = "bduni", wordTrig = true, condition = in_mathzone }, {
  t("\\bigsqcup"),
})
ma({ trig = "duni", wordTrig = true, condition = in_mathzone }, {
  t("\\sqcup"),
})

ma({ trig = "inn", wordTrig = true, condition = in_mathzone }, fmta("\\in <>", { i(0) }))

ma({ trig = "sseo", wordTrig = true, condition = in_mathzone }, fmta("\\subseteq <>", { i(0) }))
ma({ trig = "sso", wordTrig = true, condition = in_mathzone }, fmta("\\subset <>", { i(0) }))

ma(
  { trig = "sett", wordTrig = true, condition = in_mathzone },
  fmta("\\{ <> \\} <>", {
    i(1),
    i(0),
  })
)

ma(
  { trig = "max", wordTrig = true, condition = in_mathzone },
  fmta("\\max\\{ <> \\} <>", {
    i(1),
    i(0),
  })
)

ma(
  { trig = "min", wordTrig = true, condition = in_mathzone },
  fmta("\\min\\{ <> \\} <>", {
    i(1),
    i(0),
  })
)

-- arithmetic / vector stuff
ma({ trig = "xxx", wordTrig = true, condition = in_mathzone }, fmta("\\times <>", { i(0) }))
ma({ trig = "cdot", wordTrig = true, condition = in_mathzone }, fmta("\\cdot <>", { i(0) }))

-- sets block
ma({ trig = "cap", wordTrig = true, condition = in_mathzone }, fmta("\\cap <>", { i(0) }))
ma({ trig = "cup", wordTrig = true, condition = in_mathzone }, fmta("\\cup <>", { i(0) }))
ma(
  { trig = "bcap", wordTrig = true, condition = in_mathzone },
  fmta("\\bigcap_{ <> } <>", {
    i(1),
    i(0),
  })
)
ma(
  { trig = "bcup", wordTrig = true, condition = in_mathzone },
  fmta("\\bigcup_{ <> } <>", {
    i(1),
    i(0),
  })
)
ma({ trig = "empty", wordTrig = true, condition = in_mathzone }, fmta("\\emptyset <>", { i(0) }))
ma(
  { trig = "powerset", wordTrig = true, condition = in_mathzone },
  fmta("\\mathbb{P}( <> ) <>", {
    i(1),
    i(0),
  })
)

ma(
  { trig = "hat", wordTrig = true, condition = in_mathzone },
  fmta("\\hat{<>} <>", {
    i(1),
    i(0),
  })
)

-- brackets & inner product
ma(
  { trig = "abs", wordTrig = true, condition = in_mathzone },
  fmta("\\lvert <> \\rvert <>", {
    i(1),
    i(0),
  })
)

ma(
  { trig = "inp", wordTrig = true, condition = in_mathzone },
  fmta("\\langle <>, <>\\rangle <>", {
    i(1),
    i(2),
    i(0),
  })
)

----------------------------------------------------------------------
-- GREEK LETTERS
----------------------------------------------------------------------

local greek = {
  { "alpha",  "\\alpha" },
  { "beta",   "\\beta" },
  { "chi",    "\\chi" },
  { "theta",  "\\theta" },
  { "gamma",  "\\gamma" },
  { "GAeMMA", "\\Gamma" },
  { "delta",  "\\delta" },
  { "DELTA",  "\\Delta" },
  { "eps",    "\\varepsilon" },
  { "sigma",  "\\sigma" },
  { "SIGMA",  "\\Sigma" },
  { "omega",  "\\omega" },
  { "OMEGA",  "\\Omega" },
}

for _, g in ipairs(greek) do
  local trig, sym = g[1], g[2]
  ma({ trig = trig, wordTrig = true, condition = in_mathzone }, fmta(sym .. " <>", { i(0) }))
end

----------------------------------------------------------------------
-- DERIVATIVES
----------------------------------------------------------------------

ma({ trig = "ddt", wordTrig = true, condition = in_mathzone }, fmta("\\frac{d}{dt} <>", { i(0) }))
ma({ trig = "dddt", wordTrig = true, condition = in_mathzone }, fmta("\\frac{d^2}{dt^2} <>", { i(0) }))

ma(
  { trig = "u_", wordTrig = false, condition = in_mathzone },
  fmta("u_{<>} <>", {
    i(1),
    i(0),
  })
)
ma(
  { trig = "v_", wordTrig = false, condition = in_mathzone },
  fmta("v_{<>} <>", {
    i(1),
    i(0),
  })
)

ma(
  { trig = "part", wordTrig = true, condition = in_mathzone },
  fmta("\\frac{\\partial <>}{\\partial <>} <>", {
    i(1),
    i(2),
    i(0),
  })
)

ma(
  { trig = "secpart", wordTrig = true, condition = in_mathzone },
  fmta("\\frac{\\partial^2 <>}{\\partial <>^2} <>", {
    i(1),
    i(2),
    i(0),
  })
)

ma(
  { trig = "mixedpart", wordTrig = true, condition = in_mathzone },
  fmta("\\frac{\\partial^2 <>}{\\partial <> \\partial <>} <>", {
    i(1),
    i(2),
    i(3),
    i(0),
  })
)

----------------------------------------------------------------------
-- INTEGRALS
----------------------------------------------------------------------

ma(
  { trig = "dint", wordTrig = true, condition = in_mathzone },
  fmta("\\int_{<>}^{<>} <> \\, d<> <>", {
    i(1, "0"),
    i(2, "\\infty"),
    i(3),
    i(4, "x"),
    i(0),
  })
)

ma({ trig = "oint", wordTrig = true, condition = in_mathzone }, {
  t("\\oint"),
})

ma({ trig = "iiint", wordTrig = true, condition = in_mathzone }, {
  t("\\iiint"),
})

ma({ trig = "iint", wordTrig = true, condition = in_mathzone }, {
  t("\\iint"),
})

ma(
  { trig = "int", wordTrig = true, condition = in_mathzone },
  fmta("\\int <> \\, d<> <>", {
    i(1),
    i(2, "x"),
    i(0),
  })
)

----------------------------------------------------------------------
-- MISC OPERATIONS / TEXT IN MATH
----------------------------------------------------------------------

ma({ trig = "ttt", wordTrig = true, condition = in_mathzone }, fmta("\\text{<>}", { i(1) }))
ma({ trig = "TTT", wordTrig = true, condition = in_mathzone }, {
  t("^T"),
})

-- underbrace
ma(
  { trig = "___", wordTrig = true, condition = in_mathzone },
  fmta("\\underbrace{ <> }_{ <> } <>", {
    i(1),
    i(2),
    i(0),
  })
)

-- vector/bold & common sets
ma(
  { trig = "vecc", wordTrig = true, condition = in_mathzone },
  fmta("\\mathbf{<>} <>", {
    i(1),
    i(0),
  })
)

ma(
  { trig = "mcal", wordTrig = true, condition = in_mathzone },
  fmta("\\mathcal{<>} <>", {
    i(1),
    i(0),
  })
)

ma(
  { trig = "mbb", wordTrig = true, condition = in_mathzone },
  fmta("\\mathbb{<>} <>", {
    i(1),
    i(0),
  })
)

local cal_macros = {
  { "XX",  "\\mathcal{X}" },
  { "FF",  "\\mathcal{F}" },
  { "LL",  "\\mathcal{L}" },
  { "HH",  "\\mathcal{H}" },
  { "CC",  "\\mathbb{C}" },
  { "QQ",  "\\mathbb{Q}" },
  { "MM",  "\\mathbb{M}" },
  { "MM2", "\\mathbb{M}_{2}" },
  { "RR",  "\\mathbb{R}" },
  { "ZZ",  "\\mathbb{Z}" },
  { "NN",  "\\mathbb{N}" },
  { "II",  "\\mathbb{1}" },
}

for _, m in ipairs(cal_macros) do
  local trig, body = m[1], m[2]
  ma({ trig = trig, wordTrig = true, condition = in_mathzone }, {
    t(body),
  })
end

-- \hat{\mathbb{1}} special
ma({ trig = "\\mathbb{1}I", wordTrig = false, condition = in_mathzone }, {
  t("\\hat{\\mathbb{1}}"),
})

----------------------------------------------------------------------
-- MATRICES / VECTORS
----------------------------------------------------------------------

ma(
  { trig = "matrix", wordTrig = true, condition = in_mathzone },
  fmta(
    [[
\begin{pmatrix}
<>
\end{pmatrix}]],
    {
      i(1),
    }
  )
)

ma(
  { trig = "vec2", wordTrig = true, condition = in_mathzone },
  fmta("\\begin{pmatrix} <> \\\\ <> \\end{pmatrix}", {
    i(1),
    i(2),
  })
)

----------------------------------------------------------------------
-- TAYLOR EXPANSION
----------------------------------------------------------------------

ma(
  { trig = "taylor", wordTrig = true, condition = in_mathzone },
  fmta(
    [[
<>(<> + <>) = <>(<>) + <>'(<> )<> + <>''(<> ) \frac{<>^{2}}{2!} + \dots<>
]],
    {
      i(1, "f"), -- function f
      i(2, "x"), -- point x
      i(3, "h"), -- increment h
      i(1),      -- f again
      i(2),
      i(1),
      i(2),
      i(3),
      i(1),
      i(2),
      i(3),
      i(0),
    }
  )
)

----------------------------------------------------------------------
-- EXPORT
----------------------------------------------------------------------

return snippets, autosnippets
