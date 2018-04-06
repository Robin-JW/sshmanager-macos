#!/usr/bin/expect -f

## 由于需要expect的支持，用于自动输入登录密码，so 需要安装expect
## brew install expect

set username [lindex $argv 0]
set host [lindex $argv 1]
set port [lindex $argv 2]
set pwd [lindex $argv 3]
spawn ssh $username@$host -p $port

expect {
    "*yes/no" { send "yes\r"; exp_continue }
    "*password:" { send "$pwd\n" }
}

interact
