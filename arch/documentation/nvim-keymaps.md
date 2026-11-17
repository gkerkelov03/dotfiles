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
- `0`: first character of the line
- `^`: first non-blank character of the line
- `$`: end of the line
- `Ctrl + d`: move cursor and screen down 1/2 page
- `Ctrl + u`: move cursor and screen up 1/2 page

### Move by word and paragraph

- `w` / `b`: N words forward / backward
- `W` / `B`: N WORDS forward / backward
- `e` / `ge`: forward to end of word / backward to end of previous word
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
- `%`: matching bracket, comment, or preprocessor directive; with matchit, also jumps between tags and keyword pairs (`if` / `else` / `end`)
- `g%`: like `%`, but cycle backward through the matches (matchit)
- `M`: go to the middle of the screen

### Search

- `/{pattern}<CR>` / `?{pattern}<CR>`: search forward / backward
- `n` / `N`: next / previous match
- `*` / `#`: search forward / backward for the word under the cursor

### Marks and positions

- `g;` / `g,`: older / newer position in the change list
- `m{a-z}`: set a mark
- `'{a-z}` / `` `{a-z} ``: jump to the line / exact position of a mark
- `''`: jump back to where you were before the last jump
- `Ctrl-o` / `Ctrl-i`: older / newer position in the jump list

### Insert and replace

- `i` / `a`: insert before / after the cursor
- `I` / `A`: insert at the first non-blank character / end of the line
- `gi`: insert where Insert mode was last stopped
- `o` / `O`: open a new line below / above
- `r{char}`: replace N characters with {char}

### Operators

- `["x]d{motion}`: delete
- `["x]c{motion}`: delete and start Insert mode
- `["x]y{motion}`: yank
- `>{motion}` / `<{motion}`: indent / unindent lines
- `={motion}`: auto-indent lines
- `gu{motion}` / `gU{motion}`: lowercase / uppercase
- `g~{motion}`: swap case
- `gc{motion}`: comment / uncomment

### Line shortcuts

- `>>` / `<<`: indent / unindent N lines
- `==`: auto-indent N lines
- `["x]dd` / `["x]cc` / `["x]yy`: delete / change / yank N lines
- `["x]D`: delete to the end of the line
- `["x]C`: change to the end of the line
- `["x]Y`: yank to the end of the line (Neovim default)
- `gcc`: comment / uncomment N lines

### Small edits

- `["x]x` / `["x]X`: delete N characters to the right / to the left
- `~`: swap the case of N characters
- `J` / `gJ`: join N lines with / without a space
- `CTRL-A` / `CTRL-X`: add / subtract N from the number at or after the cursor

### Put

- `["x]p` / `["x]P`: put after / before the cursor

### Undo and repeat

- `u` / `CTRL-R`: undo / redo
- `.`: repeat the last change

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

### Files, info, and misc

- `gf`: edit the file under the cursor
- `gF`: edit the file under the cursor and jump to the line number after it
- `gx`: open the path under the cursor with the system application
- `K`: look up the keyword (LSP hover when a server is attached)
- `do` / `dp`: `:diffget` / `:diffput`

---

## Text objects

Use after an operator or in Visual mode. `i` means inside or inner; `a` means around, which also includes the surrounding characters or white space.

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
- `it` / `at`: tag block (HTML, XML, JSX tags)

## Square bracket commands

- `[%` / `]%`: go to the start / end of the enclosing block (matchit)
- `[c` / `]c`: previous / next difference (diff mode only)
- `[z` / `]z`: start / end of the open fold

## Commands starting with `z`

### Scroll

- `zz` / `zt` / `zb`: put the cursor line at the center / top / bottom
- `zh` / `zl`: scroll N characters right / left when `wrap` is off
- `zH` / `zL`: scroll half a screen right / left when `wrap` is off

### Folds

- `za` / `zA`: toggle the fold under the cursor / toggle all the folds nested under the cursor
- `zm` / `zM`: close 1 more level of folds through the whole file / close all folds
- `zr` / `zR`: open 1 more level of folds through the whole file / open all folds

## Visual mode

Most Normal mode commands also work here. These are the ones that differ.

### Selection

- `o`: move to the other end of the selection
- `O`: move horizontally to the other corner in block mode
- `a%`: select the matching pair, including its contents (matchit, Visual mode only)

### Edit the selection

- `d` / `x`: delete the selection
- `D` / `X`: delete the selected lines
- `c`: delete the selection and start Insert mode
- `C`: delete the selected lines and start Insert mode
- `y`: yank the selection
- `Y`: yank the selected lines
- `p`: replace with a register, saving the deleted text in the unnamed register
- `P`: replace with a register, leaving registers unchanged
- `u` / `U` / `~`: lowercase / uppercase / swap case
- `J` / `gJ`: join lines with / without spaces
- `>` / `<`: indent / unindent
- `CTRL-A` / `CTRL-X`: add / subtract N from numbers
- `g CTRL-A` / `g CTRL-X`: add / subtract N from numbers, increasing by N on each line

### Block mode

- `I`: insert the same text before the block on every line
- `A`: append the same text after the block on every line

### Other

- `:`: start a command with the selected lines as a range

## Ex commands

### Files and quitting

- `:w` / `:wa`: save / save all
- `:q` / `:qa`: quit / quit all
- `:wq`: save and quit
- `:sav <file-name.extension>`: save under another name
- `:restart`: restart nvim

### Editing

- `:s`: find and replace. `:%s/old/new/gc` replaces in the whole file, asking for confirmation on each match
- `:g`: run a command on matching lines. `:g/TODO/d` deletes every matching line
- `:v`: run a command on non-matching lines. `:v/keep/d` deletes everything else
