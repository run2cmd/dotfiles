" Fix for empty bracket expressions (e.g. [].name) in two contexts:
"
"   1. Inside parameter expansion defaults: ${1:-[].name}
"      → shDerefPattern region
"   2. As bare command arguments: az vm list --query [].name
"      → shBracketExpr region
"
" The built-in sh.vim generates regions via s:GenerateBracketExpressionItems
" with start="\[[!^]\=\\\=\]" end="\]" which matches [] as the region opener
" and then hunts for a second ] that never arrives, leaving the rest of the
" string unsyntaxed.
"
" Defining plain matches for [] after the built-in rules gives them higher
" priority (last definition wins at the same buffer position in Vim syntax).
syn match shDerefPattern contained "\[\]" nextgroup=shDerefPattern
syn match shBracketExpr "\[\]"
