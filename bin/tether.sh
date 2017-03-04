#!/bin/bash
#
# azilink for OS X Lion
# based on http://pastie.org/405289 but works with Tunnelblick only
# (no need to install a separate copy of OpenVPN2 from macports
# or building from source by hand, thankfully)
# Requires:
# - azilink running on android phone (http://code.google.com/p/azilink/)
#   (run the app and check the box to start the service).
# - adb on system path (comes with the Android SDK;
#   add its tools folder to your PATH in ~/.profile or
#   place or symlink the sdk's tools/adb file in e.g. usr/local/bin or somewhere else on the PATH)
# - Tunnelblick, a nice OS X packaging of OpenVPN (http://code.google.com/p/tunnelblick/)
#   Install Tunnelblick to Applications. Tested with Tunnelblick 3.2beta32 (build 2817)

init() {
    if [ -f /Applications/Tunnelblick.app/Contents/Resources/openvpn/openvpn-*.*.*/openvpn ]; then
        OPENVPN=/Applications/Tunnelblick.app/Contents/Resources/openvpn/openvpn-*.*.*/openvpn
    elif [ -f $HOME/Applications/Tunnelblick.app/Contents/Resources/openvpn/openvpn-*.*.*/openvpn ]; then
        OPENVPN=$HOME/Applications/Tunnelblick.app/Contents/Resources/openvpn/openvpn-*.*.*/openvpn
    else
        echo 'Install Tunnelblick.app.' >&2
        return 1
    fi

    sudo true || return 1
    until adb forward tcp:41927 tcp:41927; do sleep 1; done
    sudo $OPENVPN --dev tun \
                  --script-security 2\
                  --remote 127.0.0.1 41927 \
                  --proto tcp-client \
                  --ifconfig 192.168.56.2 192.168.56.1 \
                  --route 0.0.0.0 128.0.0.0 \
                  --route 128.0.0.0 128.0.0.0 \
                  --keepalive 10 30 \
                  --up "$0 up" \
                  --down "$0 down"
}


up() {
    until adb forward tcp:41927 tcp:41927; do sleep 1; done
    tun_dev=$1
    ns=192.168.56.1
    sudo /usr/sbin/scutil << EOF
open
d.init
get State:/Network/Interface/$tun_dev/IPv4
d.add InterfaceName $tun_dev
set State:/Network/Service/openvpn-$tun_dev/IPv4

d.init
d.add ServerAddresses * $ns
set State:/Network/Service/openvpn-$tun_dev/DNS
quit
EOF
}


down() {
    tun_dev=$1
    sudo /usr/sbin/scutil << EOF
open
remove State:/Network/Service/openvpn-$tun_dev/IPv4
remove State:/Network/Service/openvpn-$tun_dev/DNS
quit
EOF
}


case $1 in
    up  ) up $2 ;;  # openvpn will pass tun/tap dev as $2
    down) down $2 ;;
    *   ) init ;;
esac
