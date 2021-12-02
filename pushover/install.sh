echo "Pushover for notifications"

curl https://gist.githubusercontent.com/Clivern/948e2041006ef6c9293a3161884c22c7/raw/c52d6c3a89816ce538e1909dae77f19d399d59a2/pushover.sh -O --silent

chmod +x pushover.sh

// Usage
// pushover.sh $token $user $title $message
