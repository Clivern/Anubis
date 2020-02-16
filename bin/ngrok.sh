cd /tmp

echo "Installing ngrok"

curl -sS https://bin.equinox.io/c/4VmDzA7iaHb/ngrok-stable-darwin-amd64.zip > ngrok.zip

unzip ngrok.zip

chmod +x ./ngrok

mv -f ngrok /usr/local/bin/ngrok

rm ngrok.zip
