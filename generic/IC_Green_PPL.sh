#!/bin/sh
# IC_Green_PPL

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
put_template 0  "01/44/01"
put_template 1  "ff/27/36"
put_template 2  "41/a6/38"
put_template 3  "76/a8/31"
put_template 4  "2e/c3/b9"
put_template 5  "50/a0/96"
put_template 6  "3c/a0/78"
put_template 7  "e6/fe/f2"
put_template 8  "03/5c/03"
put_template 9  "b4/fa/5c"
put_template 10 "ae/fb/86"
put_template 11 "da/fa/87"
put_template 12 "2e/fa/eb"
put_template 13 "50/fa/fa"
put_template 14 "3c/fa/c8"
put_template 15 "e0/f1/dc"

color_foreground="e0/f1/dc"
color_background="2c/2c/2c"

if [ -n "$ITERM_SESSION_ID" ]; then
  # iTerm2 proprietary escape codes
  put_template_custom Pg "e0f1dc"
  put_template_custom Ph "2c2c2c"
  put_template_custom Pi "acfb80"
  put_template_custom Pj "116b41"
  put_template_custom Pk "e0f1dc"
  put_template_custom Pl "47fa6b"
  put_template_custom Pm "292929"
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
