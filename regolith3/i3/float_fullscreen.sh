#!/bin/sh
i3-msg floating enable
sleep 0.05
i3-msg resize set 100 ppt 100 ppt
# shrink 2 border widths
i3-msg resize shrink width 4 px
# shrink 2 border heights + statusbar height
i3-msg resize shrink height 32 px
i3-msg move position 0 0

