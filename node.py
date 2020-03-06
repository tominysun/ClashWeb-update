# coding=utf-8
import sys
import json
import time
import codecs
import subprocess
import requests
import api.admin
import api.subconverter
import api.default
import api.airport
import api.togist
import api.clashapi
import os

ip = api.default.clashweb
clashapi = api.default.dashboard.split('ui')[0]
dashboard = api.default.dashboard
mypath = os.getcwd().replace('\\','/')

if __name__ == '__main__':
    gpus = sys.argv[1]
    #gpus = 'updateconfig'
    print(gpus)
    if gpus == 'saveandclose':
        try:
            currentconfig = api.admin.getfile('./App/tmp.vbs')
            currentconfig = str(currentconfig).split('-f')[1].split('\"')[0].replace(' ','').replace('.yaml','.txt').replace('.\\Profile\\','')     
            api.clashapi.getallproxies('./Profile/'+currentconfig)                     
            p=subprocess.Popen(mypath+'/bat/stop.bat',shell=False)
            p.wait()                
        except Exception as e:
            pass
    if gpus == 'startandset':
        try:
            currentconfig = api.admin.getfile('./App/tmp.vbs')
            currentconfig = str(currentconfig).split('-f')[1].split('\"')[0].replace(' ','').replace('.\\Profile\\','')
            p=subprocess.Popen(mypath+'/bat/start.bat',shell=False)            
            p.wait() 
            path=mypath+'/Profile/'+currentconfig
            path=path.replace('/','\\')
            p=requests.put(clashapi+'configs',data=json.dumps({'path':path}))   
            print(p.text)  
            if '' == p.text:  
                print(gpus)                     
                api.clashapi.setproxies('./Profile/'+currentconfig.replace('.yaml','.txt'))              
                if(api.default.opensysafterstartclash):
                    print(gpus)
                    p=subprocess.Popen(mypath+'/bat/setsys.bat',shell=False)
                    p.wait()
        except Exception as e:
            pass

    if gpus == 'opendashboard':
        try:
            os.system('start /min '+dashboard)
        except Exception as e:
            pass

    if gpus == 'updateconfig':
        try:
            currentconfig = api.admin.getfile('./App/tmp.vbs')
            currentconfig = str(currentconfig).split('-f')[1].split('\"')[0].replace(' ','').replace('.\\Profile\\','')
            print(currentconfig)
            url=str(api.admin.getfile('./Profile/'+currentconfig)).split('NicoNewBeee的Clash控制台')[0].split('#托管地址:')[1]
        except:
            print('未查到托管地址，请在输入框输入托管地址')
        if '127.0.0.1' in url or 'localhost' in url:
            p=subprocess.Popen(mypath+'/bat/subconverter.bat',shell=False) 
            p.wait()
        content = api.subconverter.Retry_request(url)
        p=subprocess.Popen(mypath+'/bat/stopsubconverter.bat',shell=False)
        p.wait()
        if content == 'erro':
            print('下载失败，重新尝试,默认使用系统代理下载托管，请注意检查浏览器能否上网！！')
        content = '#托管地址:'+url+'NicoNewBeee的Clash控制台\n'+content  #下载  
        api.admin.writefile(content,'./Profile/'+currentconfig)           #写入
