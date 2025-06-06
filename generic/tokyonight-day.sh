#!/bin/sh
# tokyonight-day

# source for these helper functions:
# https://github.com/chriskempson/base16-shell/blob/master/templates/default.mustache
if [ -n "$TMUX" ]; then
  # Tell tmux to pass the escape sequences through
  # (Source: http://permalink.gmane.org/gmane.comp.terminal-emulators.tmux.user/1324)
  put_template() { printf '\033Ptmux;\033\033]4;%d;rgb:%s\033\033\\\033\\' $@; }
  put_template_var() { printf '\033Ptmux;\033\033]%d;rgb:%s\033\033\\\033\\' $@; }
  put_template_custom() { printf '\033Ptmux;\033\033]%s%s\033\033\\\033\\' $@; }
elif [ "${TERM%%[-.]*}" = "screen" ]; then
  # GNU screen (screen, screen-256color, screen-256color-bce)
  put_template() { printf '\033P\033]4;%d;rgb:%s\007\033\\' $@; }
  put_template_var() { printf '\033P\033]%d;rgb:%s\007\033\\' $@; }
  put_template_custom() { printf '\033P\033]%s%s\007\033\\' $@; }
elif [ "${TERM%%-*}" = "linux" ]; then
  put_template() { [ $1 -lt 16 ] && printf "\e]P%x%s" $1 $(echo $2 | sed 's/\///g'); }
  put_template_var() { true; }
  put_template_custom() { true; }
else
  put_template() { printf '\033]4;%d;rgb:%s\033\\' $@; }
  put_template_var() { printf '\033]%d;rgb:%s\033\\' $@; }
  put_template_custom() { printf '\033]%s%s\033\\' $@; }
fi

# 16 color space
put_template 0  "e9/e9/ed"
put_template 1  "f5/2a/65"
put_template 2  "58/75/39"
put_template 3  "8c/6c/3e"
put_template 4  "2e/7d/e9"
put_template 5  "98/54/f1"
put_template 6  "00/71/97"
put_template 7  "61/72/b0"
put_template 8  "a1/a6/c5"
put_template 9  "f5/2a/65"
put_template 10 "58/75/39"
put_template 11 "8c/6c/3e"
put_template 12 "2e/7d/e9"
put_template 13 "98/54/f1"
put_template 14 "00/71/97"
put_template 15 "37/60/bf"

color_foreground="37/60/bf"
color_background="e1/e2/e7"

if [ -n "$ITERM_SESSION_ID" ]; then
  # iTerm2 proprietary escape codes
  put_template_custom Pg "3760bf"
  put_template_custom Ph "e1e2e7"
  put_template_custom Pi "eeeeee"
  put_template_custom Pj "99a7df"
  put_template_custom Pk "3760bf"
  put_template_custom Pl "3760bf"
  put_template_custom Pm "e1e2e7"
else
  put_template_var 10 $color_foreground
  put_template_var 11 $color_background
  if [ "${TERM%%-*}" = "rxvt" ]; then
    put_template_var 708 $color_background # internal border (rxvt)
  fi
  put_template_custom 12 ";7" # cursor (reverse video)
fi

# clean up
unset -f put_template
unset -f put_template_var
unset -f put_template_custom

unset color_foreground
unset color_background
