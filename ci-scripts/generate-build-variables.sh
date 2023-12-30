#!/bin/bash


BUILD_FILE=Scripts/Singletons/Build.gd

cat << EOF > $BUILD_FILE
extends Node

var encryption_password := '${ENCRYPTION_PASSWORD:-dev}'
EOF

if [ -n "$FALLBACK_ICE_SERVERS" ]; then
cat << EOF >> $BUILD_FILE
var fallback_ice_servers: Array = $FALLBACK_ICE_SERVERS
EOF
fi

cat << EOF >> $BUILD_FILE
func _ready() -> void:
EOF

if [ -n "$NAKAMA_SERVER_KEY" -a -n "$NAKAMA_HOST" -a -n "$NAKAMA_PORT" ]; then
NAKAMA_SERVER_KEY=$(base64 -d <<< "$NAKAMA_SERVER_KEY")
cat << EOF >> $BUILD_FILE
	Online.nakama_host = '$NAKAMA_HOST'
	Online.nakama_port = $NAKAMA_PORT
	Online.nakama_server_key = '$NAKAMA_SERVER_KEY'
	Online.nakama_scheme = 'https'
	
EOF
fi

if [ -n "$ICE_SERVERS" ]; then
cat << EOF >> $BUILD_FILE
	OnlineMatch.ice_servers = $ICE_SERVERS
EOF
fi


