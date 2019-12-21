cd /tmp

echo "Installing pip"

curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py
/usr/local/opt/python@3.8/bin/python3 get-pip.py
/usr/local/opt/python@3.8/bin/python3 -m pip -V
