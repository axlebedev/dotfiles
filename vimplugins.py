import os
from os.path import expanduser
import argparse
import subprocess
    
def getUrl(dir):
    command = 'git --git-dir=' + dir + '.git --work-tree=' + dir +  ' remote show origin | grep Fetch'
    #print(command)
    with subprocess.Popen([command], stdout=subprocess.PIPE, shell=True) as proc:
        print(proc.stdout.read())
    
def listPackages(dir):
    print('list packages from ' + dir)
    dirs = [name for name in os.listdir(dir)
            if os.path.isdir(os.path.join(dir, name))] 
    for d in dirs:
        getUrl(dir + d + '/')
    
def getPackages(dir):
    print('get packages into ' + dir)
    

def main():
    print('vimplugins started...')
    parser = argparse.ArgumentParser()
    parser.add_argument('-g', '--get', help='get packages via "git clone" command', action='store_true')
    parser.add_argument('-l', '--list', help='write packages urls into vimplugins.list', action='store_true')
    parser.add_argument('-p', '--path', type=str, help='location of .vim folder, "~/.vim/bundle/" by default') 
    args = parser.parse_args()
    
    if(not args.path):
        args.path = expanduser("~") + '/.vim/bundle/'
    
    if(args.list):
        listPackages(args.path)
    elif(args.get):
        getPackages(args.path)
    
    print('vimplugins finished')

if __name__ == '__main__':
    main()
