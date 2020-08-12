#!/usr/bin/tclsh
#
# TkCounter clock command version
#

package require Tcl 8.6
package require Tk

# Setup Window size and title
wm geometry . 550x120+20+10
wm title . "Counter"

wm protocol . WM_DELETE_WINDOW {
    Exit
}

# Menu
frame .menubar -relief raised -borderwidth 2
pack .menubar -side top -fill x

menubutton .menubar.file -text File -menu .menubar.file.menu
menu .menubar.file.menu -tearoff 0
.menubar.file.menu add command -label Quit -command Exit
pack .menubar.file -side left

text .t -background white -font {"Noto Sans" -64}
pack .t -fill both -expand 1

after 500 Update

proc Exit {} {
    exit
}

proc Update {} {
    set diff [expr round(([clock scan 2020-08-21] - [clock seconds]) / double(60*60*24))]

    if {$diff < 0} {
        set diff 0
    }

    .t configure -state normal
    .t delete 0.0 end
    if {$diff <= 1} {
        .t insert end "Still $diff day left."
    } else {
        .t insert end "Still $diff days left."
    }

    .t configure -state disabled

    after 10000 Update
}
