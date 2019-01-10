# -*- coding: utf-8 -*-

import re
from xkeysnail.transform import *


define_keymap(None, {
    K("C-KEY_0"): launch(["rofi","-show","run"])
}, "launcher-keybind")

define_keymap(None, {
    K('C-h'): Key.LEFT,
    K('C-j'): Key.DOWN,
    K('C-k'): Key.UP,
    K('C-l'): Key.RIGHT,
    K('CAPSLOCK'): [Key.ESC, Key.LEFT_CTRL],
}, "Vim-like cursor")

define_keymap(re.compile('Terminator'), {
    K('esc'): [K('GRAVE'), K('esc')]
}, "Esc and IME off")