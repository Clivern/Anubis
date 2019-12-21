cd /tmp

echo "Installing pip"

curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py

python3 get-pip.py
python3 -m pip -V

python get-pip.py
python -m pip -V
