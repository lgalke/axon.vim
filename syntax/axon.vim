" Vim syntax file
" Language:		Axon
" Maintainer:		Lukas Galke Poech
" Last Change:		2026 June 02 by Lukas Galke Poech
" Original Author:	Lukas Galke Poech (based on haskell.vim by John Williams <jrw@pobox.com>)

" quit when a syntax file was already loaded
if exists("b:current_syntax")
  finish
endif

" (Qualified) identifiers (no default highlighting)
syn match ConId "\(\<[A-Z][a-zA-Z0-9_']*\.\)*\<[A-Z][a-zA-Z0-9_']*\>" contains=@NoSpell
syn match VarId "\(\<[A-Z][a-zA-Z0-9_']*\.\)*\<[a-z][a-zA-Z0-9_']*\>" contains=@NoSpell

" Infix operators--most punctuation characters and any (qualified) identifier
" enclosed in `backquotes`. An operator starting with : is a constructor,
" others are variables (e.g. functions).
syn match axonVarSym "\(\<[A-Z][a-zA-Z0-9_']*\.\)\=[-!#$%&\*\+/<=>\?@\\^|~.][-!#$%&\*\+/<=>\?@\\^|~:.]*"
syn match axonConSym "\(\<[A-Z][a-zA-Z0-9_']*\.\)\=:[-!#$%&\*\+./<=>\?@\\^|~:]*"
syn match axonVarSym "`\(\<[A-Z][a-zA-Z0-9_']*\.\)\=[a-z][a-zA-Z0-9_']*`"
syn match axonConSym "`\(\<[A-Z][a-zA-Z0-9_']*\.\)\=[A-Z][a-zA-Z0-9_']*`"

" (Non-qualified) identifiers which start with # are labels
syn match axonLabel "#[a-z][a-zA-Z0-9_']*\>"

" Reserved symbols--cannot be overloaded.
syn match axonDelimiter  "(\|)\|\[\|\]\|,\|;\|{\|}"

" Strings and constants
syn match   axonSpecialChar	contained "\\\([0-9]\+\|o[0-7]\+\|x[0-9a-fA-F]\+\|[\"\\'&\\abfnrtv]\|^[A-Z^_\[\\\]]\)"
syn match   axonSpecialChar	contained "\\\(NUL\|SOH\|STX\|ETX\|EOT\|ENQ\|ACK\|BEL\|BS\|HT\|LF\|VT\|FF\|CR\|SO\|SI\|DLE\|DC1\|DC2\|DC3\|DC4\|NAK\|SYN\|ETB\|CAN\|EM\|SUB\|ESC\|FS\|GS\|RS\|US\|SP\|DEL\)"
syn match   axonSpecialCharError	contained "\\&\|'''\+"
syn region  axonString		start=+"+  skip=+\\\\\|\\"+  end=+"+  contains=axonSpecialChar,@NoSpell
syn match   axonCharacter		"[^a-zA-Z0-9_']'\([^\\]\|\\[^']\+\|\\'\)'"lc=1 contains=axonSpecialChar,axonSpecialCharError
syn match   axonCharacter		"^'\([^\\]\|\\[^']\+\|\\'\)'" contains=axonSpecialChar,axonSpecialCharError
syn match   axonNumber		"\v<[0-9]%(_*[0-9])*>|<0[xX]_*[0-9a-fA-F]%(_*[0-9a-fA-F])*>|<0[oO]_*%(_*[0-7])*>|<0[bB]_*[01]%(_*[01])*>"
syn match   axonFloat		"\v<[0-9]%(_*[0-9])*\.[0-9]%(_*[0-9])*%(_*[eE][-+]?[0-9]%(_*[0-9])*)?>|<[0-9]%(_*[0-9])*_*[eE][-+]?[0-9]%(_*[0-9])*>|<0[xX]_*[0-9a-fA-F]%(_*[0-9a-fA-F])*\.[0-9a-fA-F]%(_*[0-9a-fA-F])*%(_*[pP][-+]?[0-9]%(_*[0-9])*)?>|<0[xX]_*[0-9a-fA-F]%(_*[0-9a-fA-F])*_*[pP][-+]?[0-9]%(_*[0-9])*>"

" Keyword definitions.
syn keyword axonModule		module
syn match   axonImportGroup	"\<import\>.*" contains=axonImport,axonImportModuleName,axonImportMod,axonLineComment,axonBlockComment,axonImportList,@NoSpell nextgroup=axonImport
syn keyword axonImport import contained nextgroup=axonImportModuleName
syn match   axonImportModuleName '\<[A-Z][A-Za-z.]*' contained
syn region  axonImportList start='(' skip='([^)]\{-})' end=')' keepend contained contains=ConId,VarId,axonDelimiter,axonBlockComment,axonTypedef,@NoSpell

syn keyword axonImportMod contained as qualified hiding
syn keyword axonInfix infix infixl infixr
syn keyword axonStructure class data deriving instance default where
syn keyword axonTypedef type
syn keyword axonNewtypedef newtype
syn keyword axonTypeFam family
syn keyword axonStatement mdo do case of let in
syn keyword axonConditional if then else

" Not real keywords, but close.
if exists("hs_highlight_boolean")
  " Boolean constants from the standard prelude.
  syn keyword axonBoolean True False
endif
if exists("hs_highlight_types")
  " Primitive types from the standard prelude and libraries.
  syn keyword axonType Int Integer Char Bool Float Double IO Void Addr Array String
endif
if exists("hs_highlight_more_types")
  " Types from the standard prelude libraries.
  syn keyword axonType Maybe Either Ratio Complex Ordering IOError IOResult ExitCode
  syn keyword axonMaybe Nothing
  syn keyword axonExitCode ExitSuccess
  syn keyword axonOrdering GT LT EQ
endif
if exists("hs_highlight_debug")
  " Debugging functions from the standard prelude.
  syn keyword axonDebug undefined error trace
endif


" Comments
syn match   axonLineComment      "---*\([^-!#$%&\*\+./<=>\?@\\^|~].*\)\?$" contains=axonTodo,@Spell
syn region  axonBlockComment     start="{-"  end="-}" contains=axonBlockComment,axonTodo,@Spell
syn region  axonPragma	       start="{-#" end="#-}" contains=axonPragmaKeyword,axonString,@NoSpell

syn keyword axonPragmaKeyword   contained CHECKPOINTS MAIN TASK TOKENIZER

syn keyword axonTodo	        contained FIXME TODO XXX NOTE

" C Preprocessor directives. Shamelessly ripped from c.vim and trimmed
" First, see whether to flag directive-like lines or not
if (!exists("hs_allow_hash_operator"))
    syn match	cError		display "^\s*\(%:\|#\).*$"
endif
" Accept %: for # (C99)
syn region	cPreCondit	start="^\s*\(%:\|#\)\s*\(if\|ifdef\|ifndef\|elif\)\>" skip="\\$" end="$" end="//"me=s-1 contains=cComment,cCppString,cCommentError
syn match	cPreCondit	display "^\s*\(%:\|#\)\s*\(else\|endif\)\>"
syn region	cCppOut		start="^\s*\(%:\|#\)\s*if\s\+0\+\>" end=".\@=\|$" contains=cCppOut2
syn region	cCppOut2	contained start="0" end="^\s*\(%:\|#\)\s*\(endif\>\|else\>\|elif\>\)" contains=cCppSkip
syn region	cCppSkip	contained start="^\s*\(%:\|#\)\s*\(if\>\|ifdef\>\|ifndef\>\)" skip="\\$" end="^\s*\(%:\|#\)\s*endif\>" contains=cCppSkip
syn region	cIncluded	display contained start=+"+ skip=+\\\\\|\\"+ end=+"+
syn match	cIncluded	display contained "<[^>]*>"
syn match	cInclude	display "^\s*\(%:\|#\)\s*include\>\s*["<]" contains=cIncluded
syn cluster	cPreProcGroup	contains=cPreCondit,cIncluded,cInclude,cDefine,cCppOut,cCppOut2,cCppSkip,cCommentStartError
syn region	cDefine		matchgroup=cPreCondit start="^\s*\(%:\|#\)\s*\(define\|undef\)\>" skip="\\$" end="$"
syn region	cPreProc	matchgroup=cPreCondit start="^\s*\(%:\|#\)\s*\(pragma\>\|line\>\|warning\>\|warn\>\|error\>\)" skip="\\$" end="$" keepend

syn region	cComment	matchgroup=cCommentStart start="/\*" end="\*/" contains=cCommentStartError,cSpaceError contained
syntax match	cCommentError	display "\*/" contained
syntax match	cCommentStartError display "/\*"me=e-1 contained
syn region	cCppString	start=+L\="+ skip=+\\\\\|\\"\|\\$+ excludenl end=+"+ end='$' contains=cSpecial contained

" Define the default highlighting.
" Only when an item doesn't have highlighting yet

hi def link axonModule			  axonStructure
hi def link axonImport			  Include
hi def link axonImportMod			  axonImport
hi def link axonInfix			  PreProc
hi def link axonStructure			  Structure
hi def link axonStatement			  Statement
hi def link axonConditional		  Conditional
hi def link axonSpecialChar		  SpecialChar
hi def link axonTypedef			  Typedef
hi def link axonNewtypedef		  Typedef
hi def link axonVarSym			  axonOperator
hi def link axonConSym			  axonOperator
hi def link axonOperator			  Operator
hi def link axonTypeFam			  Structure
if exists("hs_highlight_delimiters")
" Some people find this highlighting distracting.
hi def link axonDelimiter			  Delimiter
endif
hi def link axonSpecialCharError		  Error
hi def link axonString			  String
hi def link axonCharacter			  Character
hi def link axonNumber			  Number
hi def link axonFloat			  Float
hi def link axonConditional			  Conditional
hi def link axonLiterateComment		  axonComment
hi def link axonBlockComment		  axonComment
hi def link axonLineComment			  axonComment
hi def link axonComment			  Comment
hi def link axonTodo			  Todo
hi def link axonPragma			  SpecialComment
hi def link axonPragmaKeyword		  PreProc
hi def link axonBoolean			  Boolean
hi def link axonType			  Type
hi def link axonMaybe			  axonEnumConst
hi def link axonOrdering			  axonEnumConst
hi def link axonEnumConst			  Constant
hi def link axonDebug			  Debug
hi def link axonLabel			  Special

hi def link cCppString			  axonString
hi def link cCommentStart		  axonComment
hi def link cCommentError		  axonError
hi def link cCommentStartError		  axonError
hi def link cInclude			  Include
hi def link cPreProc			  PreProc
hi def link cDefine			  Macro
hi def link cIncluded			  axonString
hi def link cError			  Error
hi def link cPreCondit			  PreCondit
hi def link cComment			  Comment
hi def link cCppSkip			  cCppOut
hi def link cCppOut2			  cCppOut
hi def link cCppOut			  Comment

let b:current_syntax = "haskell"

" Options for vi: ts=8 sw=2 sts=2 nowrap noexpandtab ft=vim
