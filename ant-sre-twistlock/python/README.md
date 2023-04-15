## Report Comparison with Python 

#### Dependencies required:
1. Install pip
```
curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py
chmod +x  get-pip.py
python get-pip.py
pip3 --version 
```

#### Compare Compliance CSV files 

1. Create a Python Virtual Environment

###### Creation of virtual environments¶
- https://docs.python.org/3/library/venv.html

```
 python -m virtualenv venv
```

2. Activate the virtual environment 
```
source virtualenv venv/bin/activate
```

3. Install requirements
```
pip install -r requirements.txt 
```

4. Execute the compare-csv.py
```
python compare-csb.py
```

