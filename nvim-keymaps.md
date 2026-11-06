## Legend

- `N`: count typed before a command
- `{motion}`: a motion or text object
- `["x]`: optional register prefix
- `word`: letters, digits, and underscores
- `WORD`: any run of non-blank characters

## Normal mode

### Move by character and line

- `h` / `l`: left / right N characters
- `j` / `k`: down / up N lines
- `gj` / `gk`: down / up N screen lines
- `0`: first character of the line
- `^`: first non-blank character of the line
- `$`: end of the line
- `g_`: last non-blank character, N-1 lines lower
- `_`: first non-blank character, N-1 lines lower
- `+` / `-`: first non-blank character N lines down / up
- `|`: column N
- `g0` / `g^` / `g$`: start / first non-blank / end of the screen line

### Move by word, sentence, and paragraph

- `w` / `b`: N words forward / backward
- `W` / `B`: N WORDS forward / backward
- `e` / `ge`: forward to end of word / backward to end of previous word
- `E` / `gE`: forward to end of WORD / backward to end of previous WORD
- `(` / `)`: N sentences backward / forward
- `{` / `}`: N paragraphs backward / forward

### Find a character

- `f{char}` / `F{char}`: Nth occurrence to the right / left
- `t{char}` / `T{char}`: until the Nth occurrence to the right / left
- `;`: repeat the last `f`, `t`, `F`, or `T`
- `,`: repeat it in the opposite direction

### Move around the file and screen

- `gg`: line N, default first line
- `G`: line N, default last line
- `{count}%`: N percent through the file
- `%`: matching bracket, comment, or preprocessor directive
- `H` / `M` / `L`: top / middle / bottom of the screen

### Search

- `/{pattern}<CR>` / `?{pattern}<CR>`: search forward / backward
- `/<CR>` / `?<CR>`: repeat the last search forward / backward
- `n` / `N`: next / previous match
- `*` / `#`: search forward / backward for the word under the cursor
- `g*` / `g#`: same, but also match inside longer words
- `gd` / `gD`: go to definition in the current function / file

### Marks and positions

- `g;` / `g,`: older / newer position in the change list

### Insert and replace

- `i` / `a`: insert before / after the cursor
- `I` / `A`: insert at the first non-blank character / end of the line
- `gI`: insert at column 1
- `gi`: insert where Insert mode was last stopped
- `o` / `O`: open a new line below / above
- `R`: enter Replace mode
- `r{char}`: replace N characters with `{char}`

### Operators

- `["x]d{motion}`: delete
- `["x]c{motion}`: delete and start Insert mode
- `["x]y{motion}`: yank
- `>{motion}` / `<{motion}`: indent / unindent lines
- `={motion}`: auto-indent lines
- `gq{motion}`: format text
- `gw{motion}`: format text and keep the cursor in place
- `gu{motion}` / `gU{motion}`: lowercase / uppercase
- `g~{motion}`: swap case
- `!{motion}{filter}`: filter text through an external command
- `zf{motion}`: create a fold

### Line shortcuts

- `["x]dd` / `["x]cc` / `["x]yy`: delete / change / yank N lines
- `>>` / `<<`: indent / unindent N lines
- `==`: auto-indent N lines
- `!!{filter}`: filter N lines through an external command
- `["x]D`: delete to the end of the line
- `["x]C`: change to the end of the line
- `["x]Y`: yank to the end of the line (Neovim default)

### Small edits

- `["x]x` / `["x]X`: delete N characters under / before the cursor
- `["x]s`: delete N characters and start Insert mode
- `["x]S`: delete N lines and start Insert mode
- `~`: swap the case of N characters
- `J` / `gJ`: join N lines with / without a space
- `CTRL-A` / `CTRL-X`: add / subtract N from the number at or after the cursor

### Put

- `["x]p` / `["x]P`: put after / before the cursor
- `["x]gp` / `["x]gP`: same, but leave the cursor after the new text
- `]p` / `[p`: put after / before, adjusting indent to the current line

### Undo and repeat

- `u` / `CTRL-R`: undo / redo
- `g-` / `g+`: older / newer text state
- `.`: repeat the last change
- `&`: repeat the last `:s` with its flags (Neovim default)
- `g&`: repeat the last `:s` on all lines

### Registers and macros

- `"{register}`: use a register for the next delete, yank, or put
- `q{register}`: start recording; press `q` again to stop
- `@{a-z}`: run a register N times
- `@@`: repeat the last `@{a-z}`
- `@:`: repeat the last `:` command N times
- `Q`: replay the last recorded register

### Visual mode and command line

- `v` / `V` / `CTRL-V`: charwise / linewise / blockwise Visual mode
- `gv`: reselect the previous Visual area
- `gn` / `gN`: select the next / previous search match
- `:`: start an Ex command
- `{count}:`: start an Ex command with a range covering N lines
- `q:`: open the command-line window
- `q/` / `q?`: open the search history window

### Files, info, and misc

- `ZZ`: write if changed and close the window
- `ZQ`: close the window without writing
- `gf`: edit the file under the cursor
- `gF`: edit the file under the cursor and jump to the line number after it
- `gx`: open the path under the cursor with the system application
- `K`: look up the keyword (LSP hover when a server is attached)
- `ga`: show the character value under the cursor
- `g CTRL-G`: show cursor position and word counts
- `g<`: show the previous command output
- `do` / `dp`: `:diffget` / `:diffput`

---

## Text objects

Use after an operator or in Visual mode. `i` means inner; `a` also includes the surrounding characters or white space.

- `iw` / `aw`: word
- `iW` / `aW`: WORD
- `is` / `as`: sentence
- `ip` / `ap`: paragraph
- `i"` / `a"`: double-quoted string
- `i'` / `a'`: single-quoted string
- ``i` `` / ``a` ``: backtick string
- `i(` / `a(`: `()` block, same as `i)`, `ib` / `a)`, `ab`
- `i[` / `a[`: `[]` block, same as `i]` / `a]`
- `i{` / `a{`: `{}` block, same as `i}`, `iB` / `a}`, `aB`
- `i<` / `a<`: `<>` block, same as `i>` / `a>`
- `it` / `at`: tag block

## Operator-pending mode

Use after an operator, before the motion.

- `v`: force the operator to work charwise
- `V`: force the operator to work linewise
- `CTRL-V`: force the operator to work blockwise

---

## Window commands

### Create and close

- `CTRL-W s` / `CTRL-W v`: split horizontally / vertically
- `CTRL-W n`: open a new window
- `CTRL-W q`: quit the current window
- `CTRL-W c`: close the current window
- `CTRL-W o`: close all other windows

### Move between windows

- `CTRL-W h` / `j` / `k` / `l`: go left / down / up / right
- `CTRL-W w` / `CTRL-W W`: next / previous window
- `CTRL-W p`: last accessed window
- `CTRL-W t` / `CTRL-W b`: top / bottom window

### Move and arrange windows

- `CTRL-W H` / `J` / `K` / `L`: move to the far left / bottom / top / far right
- `CTRL-W T`: move the window to a new tab
- `CTRL-W r` / `CTRL-W R`: rotate windows down / up
- `CTRL-W x`: exchange with the next window

### Resize

- `CTRL-W +` / `CTRL-W -`: increase / decrease height by N
- `CTRL-W >` / `CTRL-W <`: increase / decrease width by N
- `CTRL-W =`: make all windows equal
- `CTRL-W _`: set height to N (default: maximum)
- `CTRL-W |`: set width to N (default: maximum)

### Open in a split or tab

- `CTRL-W f`: split and edit the file under the cursor
- `CTRL-W F`: same, and jump to the line number after the file name
- `CTRL-W gf`: edit the file under the cursor in a new tab
- `CTRL-W gF`: same, and jump to the line number after the file name
- `CTRL-W ]`: split and jump to the tag under the cursor
- `CTRL-W ^`: split and edit the alternate file

---

## Tabs

- `gt` / `gT`: next / previous tab
- `g<Tab>`: last accessed tab

---

## Square bracket commands

- `[(` / `])`: previous / next unmatched parenthesis
- `[{` / `]}`: previous / next unmatched curly brace
- `[[` / `]]`: N sections backward / forward
- `[]` / `][`: N SECTIONS backward / forward
- `[m` / `]m`: start of the previous / end of the next member function
- `[c` / `]c`: previous / next change
- `[s` / `]s`: previous / next misspelled word
- `[z` / `]z`: start / end of the open fold
- `[I` / `]I`: list lines containing the word under the cursor, from the file start / cursor

---

## Commands starting with `z`

### Scroll

- `zz` / `zt` / `zb`: put the cursor line at the center / top / bottom
- `zh` / `zl`: scroll N characters right / left when `wrap` is off
- `zH` / `zL`: scroll half a screen right / left when `wrap` is off
- `zs` / `ze`: put the cursor at the left / right of the screen when `wrap` is off

### Folds

- `za` / `zA`: toggle a fold / toggle recursively
- `zo` / `zO`: open a fold / open recursively
- `zc` / `zC`: close a fold / close recursively
- `zv`: open enough folds to view the cursor line
- `zm` / `zM`: fold more / close all folds
- `zr` / `zR`: fold less / open all folds
- `zj` / `zk`: start of the next fold / end of the previous fold
- `zF`: create a fold for N lines
- `zd` / `zD`: delete a fold / delete recursively
- `zE`: eliminate all folds
- `zi`: toggle folding
- `zx`: re-apply `foldlevel` and do `zv`

### Spelling

- `z=`: show spelling suggestions
- `zg` / `zw`: mark a word as correct / incorrect
- `zug` / `zuw`: undo `zg` / `zw`

---

## Visual mode

Most Normal mode commands also work here. These are the ones that differ.

### Selection

- `<Esc>`: stop Visual mode
- `v` / `V` / `CTRL-V`: switch to charwise / linewise / blockwise, or stop
- `o`: move to the other end of the selection
- `O`: move horizontally to the other corner in block mode
- `gv`: exchange the current and previous selection

### Edit the selection

- `d` / `x`: delete the selection
- `D` / `X`: delete the selected lines
- `c` / `s`: delete the selection and start Insert mode
- `C` / `R` / `S`: delete the selected lines and start Insert mode
- `y`: yank the selection
- `Y`: yank the selected lines
- `p`: replace with a register, saving the deleted text in the unnamed register
- `P`: replace with a register, leaving registers unchanged
- `r{char}`: replace the selection with a character
- `u` / `U` / `~`: lowercase / uppercase / swap case
- `J` / `gJ`: join lines with / without spaces
- `>` / `<`: indent / unindent
- `=`: filter through `equalprg`
- `gq`: format the selected lines
- `!{filter}`: filter through an external command
- `CTRL-A` / `CTRL-X`: add / subtract N from numbers
- `g CTRL-A` / `g CTRL-X`: add / subtract N from numbers, increasing by N on each line

### Block mode

- `I`: insert the same text before the block on every line
- `A`: append the same text after the block on every line

### Other

- `:`: start a command with the selected lines as a range
- `K`: run `keywordprg` on the selection

---

## Command-line mode

- `<CR>`: run the command
- `<Esc>` / `CTRL-C`: cancel
- `<Tab>` / `<S-Tab>`: complete / previous match
- `CTRL-N` / `CTRL-P`: next / previous match or history entry
- `<Up>` / `<Down>`: history matching the text before the cursor
- `CTRL-D`: list completions
- `CTRL-A`: insert all completions
- `CTRL-L`: insert the longest common completion
- `CTRL-B` / `CTRL-E`: start / end of the command line
- `CTRL-W`: delete the word before the cursor
- `CTRL-U`: delete everything before the cursor
- `CTRL-R {register}`: insert a register as if typed
- `CTRL-V`: insert the next character literally
- `CTRL-F`: open the command-line window
- `CTRL-G` / `CTRL-T`: next / previous match while using `incsearch`

### Completion menu

- `CTRL-Y`: accept the selected match
- `CTRL-E`: stop completion and restore the original text

---

## Terminal mode

- `CTRL-\ CTRL-N`: go to Normal mode
- `CTRL-\ CTRL-O`: run one Normal mode command, then return

---

## Ex commands

### Files and quitting

- `:w`: write
- `:wa`: write all changed buffers
- `:up`: write only if the buffer changed
- `:sav`: save under another name
- `:q`: quit the window
- `:qa`: quit Neovim
- `:wq` / `:x`: write and quit
- `:xa`: write all changed buffers and quit
- `:e`: edit a file
- `:ene`: edit a new unnamed buffer
- `:r`: read a file into the buffer
- `:find`: find a file in `path` and edit it
- `:oldfiles`: list recent files
- `:restart`: restart Neovim

### Buffers

- `:ls`: list buffers
- `:b`: go to a buffer
- `:bn` / `:bp`: next / previous buffer
- `:bd`: remove a buffer from the list
- `:bw`: fully wipe a buffer

### Windows and tabs

- `:sp` / `:vs`: split horizontally / vertically
- `:new` / `:vne`: new empty window, horizontal / vertical
- `:on`: close all other windows
- `:clo`: close the current window
- `:res`: change window height
- `:tabnew`: new tab
- `:tabc`: close the tab
- `:tabo`: close all other tabs
- `:tabn` / `:tabp`: next / previous tab
- `:tabm`: move the tab
- `:tab`: open the next command's window in a new tab
- `:vert` / `:hor`: run the next split command vertically / horizontally

### Editing

- `:s`: find and replace
- `:g`: run a command on matching lines
- `:v`: run a command on non-matching lines
- `:norm`: run Normal mode commands
- `:d`: delete lines
- `:m`: move lines
- `:t` / `:co`: copy lines
- `:y`: yank lines
- `:pu`: put a register
- `:j`: join lines
- `:sor`: sort lines
- `:uni`: remove duplicate lines
- `:ret`: change tab size
- `:noh`: clear search highlighting
- `:!`: run an external command or filter lines
- `:!!`: repeat the last `:!`

### Search and quickfix

- `:gr`: run `grepprg`
- `:vim`: search for a pattern in files
- `:helpg`: search help files
- `:mak`: run `makeprg` and parse errors
- `:cope` / `:ccl`: open / close the quickfix list
- `:cw`: open or close the quickfix list based on errors
- `:cn` / `:cp`: next / previous entry
- `:cc`: go to a specific entry
- `:cfir` / `:cla`: first / last entry
- `:cnew` / `:col`: newer / older list
- `:cdo`: run a command on each entry
- `:cfd`: run a command on each file
- `:lop` / `:lcl`: open / close the location list
- `:lne` / `:lp`: next / previous location

### Inspect

- `:reg`: registers
- `:marks`: marks
- `:delm`: delete marks
- `:ju`: jump list
- `:changes`: change list
- `:mes`: messages
- `:his`: command history
- `:scr`: sourced scripts
- `:ve`: version and build info
- `:che`: health checks
- `:te`: open a terminal buffer
