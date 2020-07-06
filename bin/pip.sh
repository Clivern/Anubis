cd /tmp

echo "Installing pip"

curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py

python3 get-pip.py
python3 -m pip -V

python get-pip.py
python -m pip -V

rm get-pip.py

python3 -m pip install --upgrade pip
python -m pip install --upgrade pip

# Add pipenv
python3 -m pip install pipenv
