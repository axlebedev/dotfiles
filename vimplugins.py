import os
import sys
import re
from os.path import expanduser
import argparse
import subprocess



def gitCmd(dir):
        return 'git --git-dir=' + dir + \
                   '.git --work-tree=' + dir + ' ' 
         


def getUrl(dir):
        grep = 'findstr' if sys.platform == 'win32' else 'grep'
        command = gitCmd(dir) + 'remote show origin | ' + grep + ' Fetch'
        if(sys.platform == 'win32'):
                command = command.replace('/', '\\')#.replace('\\', '\\\\')
                command = command.split(' ')
                          
        proc = subprocess.Popen(command, 
                        stdout=subprocess.PIPE, 
                        stderr = subprocess.STDOUT, 
                        shell=True)
        
        res = proc.communicate()[0].decode('utf-8')
        searchRe = '(?<=Fetch URL: )[a-zA-Z0-9\_\-\.\/\:]+'
        url = re.search(searchRe, res)
        if(url):
                print('OK! git remote = ' + url.group(0))
                return {'ok': True, 'url':url.group(0)}
        
        print('Error: ' + res)
        return {'ok': False, 'url': res}
        


def listPackages(dir):
        # get folders in ,vim/bundle folder
        print('list packages from ' + dir)
        dirs = [name for name in os.listdir(dir)
                        if os.path.isdir(os.path.join(dir, name))] 
        dirCount = len(dirs)
        
        # get git remote urls for each folder
        list = []
        for i in range(0, dirCount):
                print(str(i+1) + '/' + str(dirCount) + ': ' + dirs[i])
                l = getUrl(dir + dirs[i]  + '/')
                list.append(l)
        
        # write result in file
        f = open('vimplugins.list', 'w')
        errorList = []
        for record in list:
                if(record['ok']):
                        f.write(record['url'] + '\n')
                else:
                        errorList.append(record)
                        
        f.write('#errored folders:\n')
        for record in errorList:
                f.write(record['url'] + '\n')
                
        f.close()
        
        

def clonePackage(dir, url):
        searchDir = '((?<=/)[a-zA-Z0-9\_\-\.]+(?=\.git)' + \
                                '|(?<=/)[a-zA-Z0-9\_\-\.]+$)'
        
        subdir = re.search(searchDir, url)
        if(not subdir):
                print('Error processing ' + url)
                return
        
        dir = dir + subdir.group(0)
        command = 'git clone ' + url + ' ' + dir 
        os.system(command)
        
        

def getPackages(dir):
        print('get packages into ' + dir)
        f = open('vimplugins.list')
        lines = f.read().split('\n')
        errorLine = 0
        for i in range(0, len(lines)):
                if(lines[i].find('#error') == 0):
                        errorLine = i
                        break

        for i in range(0, errorLine):
                print('\n[' + str(i+1) + '/' + str(errorLine) + \
                                ']: ' + lines[i] +  '\n')
                clonePackage(dir, lines[i])
        
        for i in range(errorLine + 1, len(lines)):
                if(len(lines[i]) > 0):
                        print('\nErrored package, install it manually:\n' + lines[i])


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
