#!/usr/bin/tclsh
#
# TkCounter XQuery version
#

package require Tcl 8.6
package require Tk
package require xqilla

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

xqilla db

after 500 Update

proc Exit {} {
    db close
    exit
}

proc Update {} {
    set diff 0
    set exprs [db prepare  {days-from-duration(xs:dateTime('2020-08-21T18:00:00') - current-dateTime())}]
    set result [$exprs execute]

    while {[$result next]} {
        set diff [$result string_value]
    }

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
    $result close
    $exprs close

    after 10000 Update
}
