# NESSUS Automations

## Installation

Spin up a Python Virtual Enviornment
```bash
$ python3 -m venv venv
$ source venv/bin/activate
```
Install from `requirements.txt`
```bash
(venv)$ pip install -r requirements.txt
```
Touch application log file
```shell
(venv)$ touch nessus_automations.log
```
Obtain a copy of cred's needed, and move them into `setup.cfg`
```shell
(venv)$ mv setup_example.cfg setup.cfg
```
Execute `scan_list.py` for verification
```shell
(venv)$ python scan_list.py
```