'''
Referemces:
    For installing a package from Python code:
    https://stackoverflow.com/questions/12332975/installing-python-module-within-code
'''

import sys
import subprocess

def install(package):
    subprocess.check_call([sys.executable, "-m", "pip", "install", package])

with open('requirements.txt', 'r') as inp:
    reqs = inp.readlines()

installed = 0
needed = 0
for req in reqs:
    if not req in sys.modules:
        needed += 1
        try:
            install(req)
        except:
            installed += 1

if needed > installed:
    print('not all packages installed, this may cause classification to fail')
    exit(1)
else:
    print('packages installed correctly')
    exit(0)