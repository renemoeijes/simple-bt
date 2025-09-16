#!/usr/bin/expect -f

# Stap 1: Start bluetoothctl op de juiste manier.
set env(TERM) dumb
spawn bluetoothctl

send "agent on\r"
send "default-agent\r"
send "pairable on\r"
send "discoverable on\r"

# Disconnect all connected devices. 

# Haal lijst met apparaten op en probeer ieder apparaat te disconnecten.

# Set variabelen:
set old_timeout $timeout
set timeout 1
set macs {}
set curmac ""


send "devices\r"
expect {
    -re {Device ([0-9A-F:]{17})} {
        lappend macs $expect_out(1,string)
        exp_continue
    }
    timeout {}
}
foreach m $macs {
    send "disconnect $m\r"
    expect {
        -re {Successful|Failed|not available} {}
        timeout {}
    }
}
set timeout $old_timeout




# Oneindige lus om alle toekomstige prompts te vangen
while {1} {
   expect {
      -re ".*\\(yes/no\\):" {
         send "yes\r"
         exp_continue
      }
      # Detecteer nieuw transport (voor audio apparaten zoals telefoons)
      -re {.*NEW.*Transport /org/bluez/hci0/dev_([0-9A-F_]{17})/fd[0-9]+} {
         set curmac [string map {_ :} $expect_out(1,string)]
         puts "\[DEBUG\] NEW Transport macaddress: $curmac"
         # Disconnect all other connected devices
         send "devices Connected\r"
         expect {
            -re {Device ([0-9A-F:]{17})} {
               if {$expect_out(1,string) != $curmac} {
                  send "disconnect $expect_out(1,string)\r"
                  expect {
                     -re {Successful|Failed|not available} {}
                     timeout {}
                  }
               }
               exp_continue
            }
            timeout {}
         }
         # If spotify exist, stop it.
         set status [catch {exec systemctl is-active spotifyd} result]
         if {$status == 0 && $result == "active"} {
            # spotifyd draait, DBus pause uitvoeren
            exec dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotifyd \
                  /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.Pause
         } else {
            puts "\[INFO\] spotifyd draait niet, niets te pauzeren"
         }
         exp_continue
      }
   eof { break }
   }
}
