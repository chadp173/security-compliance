#!/usr/bin/env bash
set -x

if [ -x /usr/bin/logger ]; then
        LOGGER="/usr/bin/logger -s -p daemon.info -t FirewallHandler"
else
        LOGGER=echo
fi

case "$2" in
        up)
                if [ ! -r /etc/iptables.rules ]; then
                        ${LOGGER} "No iptables rules exist to restore."
                        return
                fi
                if [ ! -x /sbin/iptables-restore ]; then
                        ${LOGGER} "No program exists to restore iptables rules."
                        return
                fi
                ${LOGGER} "Restoring iptables rules"
                /sbin/iptables-restore -c < /etc/iptables.rules
                ;;
        down)
                if [ ! -x /sbin/iptables-save ]; then
                        ${LOGGER} "No program exists to save iptables rules."
                        return
                fi
                ${LOGGER} "Saving iptables rules."
                /sbin/iptables-save -c > /etc/iptables.rules
                ;;
        *)
                ;;
esac
