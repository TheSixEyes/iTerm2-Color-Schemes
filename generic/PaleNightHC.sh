#!/bin/sh
# PaleNightHC

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
put_template 0  "00/00/00"
put_template 1  "f0/71/78"
put_template 2  "c3/e8/8d"
put_template 3  "ff/cb/6b"
put_template 4  "82/aa/ff"
put_template 5  "c7/92/ea"
put_template 6  "89/dd/ff"
put_template 7  "ff/ff/ff"
put_template 8  "66/66/66"
put_template 9  "f6/a9/ae"
put_template 10 "db/f1/ba"
put_template 11 "ff/df/a6"
put_template 12 "b4/cc/ff"
put_template 13 "dd/bd/f2"
put_template 14 "b8/ea/ff"
put_template 15 "99/99/99"

color_foreground="cc/cc/cc"
color_background="3e/42/51"

if [ -n "$ITERM_SESSION_ID" ]; then
  # iTerm2 proprietary escape codes
  put_template_custom Pg "cccccc"
  put_template_custom Ph "3e4251"
  put_template_custom Pi "ffffff"
  put_template_custom Pj "717cb4"
  put_template_custom Pk "80cbc4"
  put_template_custom Pl "ffcb6b"
  put_template_custom Pm "323232"
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
