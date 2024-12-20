# Reset
Color_Off='\033[0m'       # Text Reset

# Regular Colors
Black='\033[0;30m'        # Black
Red='\033[0;31m'          # Red
Green='\033[0;32m'        # Green
Yellow='\033[0;33m'       # Yellow
Blue='\033[0;34m'         # Blue
Purple='\033[0;35m'       # Purple
Cyan='\033[0;36m'         # Cyan
White='\033[0;37m'        # White

# Bold
BBlack='\033[1;30m'       # Black
BRed='\033[1;31m'         # Red
BGreen='\033[1;32m'       # Green
BYellow='\033[1;33m'      # Yellow
BBlue='\033[1;34m'        # Blue
BPurple='\033[1;35m'      # Purple
BCyan='\033[1;36m'        # Cyan
BWhite='\033[1;37m'       # White

# Underline
UBlack='\033[4;30m'       # Black
URed='\033[4;31m'         # Red
UGreen='\033[4;32m'       # Green
UYellow='\033[4;33m'      # Yellow
UBlue='\033[4;34m'        # Blue
UPurple='\033[4;35m'      # Purple
UCyan='\033[4;36m'        # Cyan
UWhite='\033[4;37m'       # White

# Background
On_Black='\033[40m'       # Black
On_Red='\033[41m'         # Red
On_Green='\033[42m'       # Green
On_Yellow='\033[43m'      # Yellow
On_Blue='\033[44m'        # Blue
On_Purple='\033[45m'      # Purple
On_Cyan='\033[46m'        # Cyan
On_White='\033[47m'       # White

# High Intensity
IBlack='\033[0;90m'       # Black
IRed='\033[0;91m'         # Red
IGreen='\033[0;92m'       # Green
IYellow='\033[0;93m'      # Yellow
IBlue='\033[0;94m'        # Blue
IPurple='\033[0;95m'      # Purple
ICyan='\033[0;96m'        # Cyan
IWhite='\033[0;97m'       # White

# Bold High Intensity
BIBlack='\033[1;90m'      # Black
BIRed='\033[1;91m'        # Red
BIGreen='\033[1;92m'      # Green
BIYellow='\033[1;93m'     # Yellow
BIBlue='\033[1;94m'       # Blue
BIPurple='\033[1;95m'     # Purple
BICyan='\033[1;96m'       # Cyan
BIWhite='\033[1;97m'      # White

# High Intensity backgrounds
On_IBlack='\033[0;100m'   # Black
On_IRed='\033[0;101m'     # Red
On_IGreen='\033[0;102m'   # Green
On_IYellow='\033[0;103m'  # Yellow
On_IBlue='\033[0;104m'    # Blue
On_IPurple='\033[0;105m'  # Purple
On_ICyan='\033[0;106m'    # Cyan
On_IWhite='\033[0;107m'   # White


# the escape character in bash, hex and octal respectively:

|       | bash  | hex     | octal   | NOTE                         |
|-------+-------+---------+---------+------------------------------|
| start | \e    | \x1b    | \033    |                              |
| start | \E    | \x1B    | -       | x cannot be capital          |
| end   | \e[0m | \x1b[0m | \033[0m |                              |
| end   | \e[m  | \x1b[m  | \033[m  | 0 is appended if you omit it |


# short example:

| color       | bash         | hex            | octal          | NOTE                                  |
|-------------+--------------+----------------+----------------+---------------------------------------|
| start green | \e[32m<text> | \x1b[32m<text> | \033[32m<text> | m is NOT optional                     |
| reset       | <text>\e[0m  | <text>\1xb[0m  | <text>\033[om  | o is optional (do it as best practice |


# bash exception:

If you are going to use these codes in your special bash variables

    PS0
    PS1
    PS2 (= this is for prompting)
    PS4

you should add extra escape characters so that bash can interpret them correctly. Without this adding extra escape characters it works but you will face problems when you use Ctrl + r for search in your history.

# exception rule for bash

You should add \[ before any starting ANSI code and add \] after any ending ones.
Example:
in regular usage: \033[32mThis is in green\033[0m
for PS0/1/2/4: \[\033[32m\]This is in green\[\033[m\]

\[ is for start of a sequence of non-printable characters
\] is for end of a sequence of non-printable characters

Tip: for memorize it you can first add \[\] and then put your ANSI code between them:

    \[start-ANSI-code\]
    \[end-ANSI-code\]

# type of color sequence:

    3/4 bit
    8 bit
    24 bit

# Before diving into these colors, you should know about 4 modes with these codes:
# 1. color-mode

It modifies the style of color NOT text. For example make the color bright or darker.

    0 reset
    1; lighter than normal
    2; darker than normal

This mode is not supported widely. It is fully support on Gnome-Terminal.
# 2. text-mode

This mode is for modifying the style of text NOT color.

    3; italic
    4; underline
    5; blinking (slow)
    6; blinking (fast)
    7; reverse
    8; hide
    9; cross-out

and are almost supported.
For example KDE-Konsole supports 5; but Gnome-Terminal does not and Gnome supports 8; but KDE does not.
# 3. foreground mode

This mode is for colorizing the foreground.
# 4. background mode

This mode is for colorizing the background.



# The below table shows a summary of 3/4 bit version of ANSI-color

|------------+----------+---------+-------+------------------+------------------------------+--------------------------------------|
| color-mode | octal    | hex     | bash  | description      | example (= in octal)         | NOTE                                 |
|------------+----------+---------+-------+------------------+------------------------------+--------------------------------------|
|          0 | \033[0m  | \x1b[0m | \e[0m | reset any affect | echo -e "\033[0m"            | 0m equals to m                       |
|          1 | \033[1m  |         |       | light (= bright) | echo -e "\033[1m####\033[m"  | -                                    |
|          2 | \033[2m  |         |       | dark (= fade)    | echo -e "\033[2m####\033[m"  | -                                    |
|------------+----------+---------+-------+------------------+------------------------------+--------------------------------------|
|  text-mode | ~        |         |       | ~                | ~                            | ~                                    |
|------------+----------+---------+-------+------------------+------------------------------+--------------------------------------|
|          3 | \033[3m  |         |       | italic           | echo -e "\033[3m####\033[m"  |                                      |
|          4 | \033[4m  |         |       | underline        | echo -e "\033[4m####\033[m"  |                                      |
|          5 | \033[5m  |         |       | blink (slow)     | echo -e "\033[3m####\033[m"  |                                      |
|          6 | \033[6m  |         |       | blink (fast)     | ?                            | not wildly support                   |
|          7 | \003[7m  |         |       | reverse          | echo -e "\033[7m####\033[m"  | it affects the background/foreground |
|          8 | \033[8m  |         |       | hide             | echo -e "\033[8m####\033[m"  | it affects the background/foreground |
|          9 | \033[9m  |         |       | cross            | echo -e "\033[9m####\033[m"  |                                      |
|------------+----------+---------+-------+------------------+------------------------------+--------------------------------------|
| foreground | ~        |         |       | ~                | ~                            | ~                                    |
|------------+----------+---------+-------+------------------+------------------------------+--------------------------------------|
|         30 | \033[30m |         |       | black            | echo -e "\033[30m####\033[m" |                                      |
|         31 | \033[31m |         |       | red              | echo -e "\033[31m####\033[m" |                                      |
|         32 | \033[32m |         |       | green            | echo -e "\033[32m####\033[m" |                                      |
|         33 | \033[33m |         |       | yellow           | echo -e "\033[33m####\033[m" |                                      |
|         34 | \033[34m |         |       | blue             | echo -e "\033[34m####\033[m" |                                      |
|         35 | \033[35m |         |       | purple           | echo -e "\033[35m####\033[m" | real name: magenta = reddish-purple  |
|         36 | \033[36m |         |       | cyan             | echo -e "\033[36m####\033[m" |                                      |
|         37 | \033[37m |         |       | white            | echo -e "\033[37m####\033[m" |                                      |
|------------+----------+---------+-------+------------------+------------------------------+--------------------------------------|
|         38 | 8/24     |                    This is for special use of 8-bit or 24-bit                                            |
|------------+----------+---------+-------+------------------+------------------------------+--------------------------------------|
| background | ~        |         |       | ~                | ~                            | ~                                    |
|------------+----------+---------+-------+------------------+------------------------------+--------------------------------------|
|         40 | \033[40m |         |       | black            | echo -e "\033[40m####\033[m" |                                      |
|         41 | \033[41m |         |       | red              | echo -e "\033[41m####\033[m" |                                      |
|         42 | \033[42m |         |       | green            | echo -e "\033[42m####\033[m" |                                      |
|         43 | \033[43m |         |       | yellow           | echo -e "\033[43m####\033[m" |                                      |
|         44 | \033[44m |         |       | blue             | echo -e "\033[44m####\033[m" |                                      |
|         45 | \033[45m |         |       | purple           | echo -e "\033[45m####\033[m" | real name: magenta = reddish-purple  |
|         46 | \033[46m |         |       | cyan             | echo -e "\033[46m####\033[m" |                                      |
|         47 | \033[47m |         |       | white            | echo -e "\033[47m####\033[m" |                                      |
|------------+----------+---------+-------+------------------+------------------------------+--------------------------------------|
|         48 | 8/24     |                    This is for special use of 8-bit or 24-bit                                            |







