#!/bin/bash

HOSTS_FILE="$HOME/etc/hosts"

verify_IP() {
    HOST_NAME=$1
    FILE_IP=$2
    echo "Verific $HOST_NAME..."
    NSLOOKUP_IP=$(nslookup $HOST_NAME | awk '/Address:/ {addr = $2} END {print addr}')
    if [ -z "$NSLOOKUP_IP" ]; then
        echo "   -> nslookup nu a putut rezolva $HOST_NAME"
        return 2
    fi
    if [ "$FILE_IP" != "$NSLOOKUP_IP" ]; then
        echo "   -> Incorect IP for $HOST_NAME in $HOSTS_FILE!"
        echo "   -> (Fisier: $FILE_IP, Real: $NSLOOKUP_IP)"
        return 1
    else
        echo "   -> OK (Fisier: $FILE_IP, Real: $NSLOOKUP_IP)"
        return 0
    fi
}

while read -r line; do
    if [[ "$line" =~ ^# ]] || [[ -z "$line" ]]; then
        continue
    fi
    read -r IP NAME <<< "$line"
    if [ -n "$IP" ] && [ -n "$NAME" ]; then
        verify_IP "$NAME" "$IP"
    fi
done < "$HOSTS_FILE"