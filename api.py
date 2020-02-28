# coding=utf-8
import sys
import flask_restful
from flask import redirect, url_for,flash
import  base64
import  re
import  requests
import urllib3
import urllib
import urllib.parse
import json
import time
import codecs
import subprocess
import api.admin
import api.subconverter
import api.default
import os
from flask import Flask,render_template,request
urllib3.disable_warnings()

def safe_base64_decode(s): # 解密
    try:
        if len(s) % 4 != 0:
            s = s + '=' * (4 - len(s) % 4)
        base64_str = base64.urlsafe_b64decode(s)
        return bytes.decode(base64_str)
    except Exception as e:
        print('解码错误')   

def safe_base64_encode(s): # 加密
    try:
        return base64.urlsafe_b64encode(bytes(s, encoding='utf8'))
    except Exception as e:
        print('加密错误',e)


app = Flask(__name__)
ip = api.default.api
app.secret_key = 'some_secret'

@app.route('/',methods=['GET', 'POST'])
def login():
    if request.method == "POST":
        if request.form['submit'] == 'clash': 
            clash = request.form.get('clash')
            sysproxy = request.form.get('sysproxy')
            issys = '系统代理：开启'
            if '开启' in sysproxy:
                issys = '系统代理：关闭'
            if clash == '启动Clash':
                try:
                    #p=subprocess.Popen('start.bat',shell=False)            
                    #p.wait()
                    os.system('taskkill /IM clash-win64.exe  1>NUL 2>NUL')
                    print('kill')
                    os.system('wscript ".\\App\\tmp.vbs"')                    
                    flash('Clash 正在运行 '+issys)
                    print('start')
                    return render_template('login.html',clash='关闭Clash',sysproxy=sysproxy)
                except :
                    flash('启动Clash失败')    
                    return render_template('login.html',clash='启动Clash',sysproxy=sysproxy)
            if clash == '关闭Clash':
                try:
                    #subprocess.Popen('stop.bat',shell=False)
                    os.system('taskkill /IM clash-win64.exe  1>NUL 2>NUL')  
                    print('stop')
                    flash('Clash 未运行 '+issys)
                    return render_template('login.html',clash='启动Clash',sysproxy=sysproxy)
                except :
                    flash('关闭Clash失败')
                    return render_template('login.html',clash='关闭Clash',sysproxy=sysproxy)
        if request.form['submit'] == '系统代理': 
            clash = request.form.get('clash')
            sysproxy = request.form.get('sysproxy')
            isclash = 'Clash 正在运行'
            if '启动' in clash:
                isclash = 'Clash 未运行'
            if sysproxy == '开启系统代理':
                try:
                    #p=subprocess.Popen('setsys.bat',shell=False)
                    #p.wait()
                    os.system('reg add "HKCU\\Software\\Microsoft\\Windows\\CurrentVersion\\Internet Settings" /v ProxyEnable /t REG_DWORD /d 0 /f >NUL')
                    flash(isclash+' 系统代理：开启')
                    print('start')
                    return render_template('login.html',sysproxy='关闭系统代理',clash=clash)
                except :
                    flash('开启系统代理失败')    
                    return render_template('login.html',sysproxy='开启系统代理',clash=clash)
            if sysproxy == '关闭系统代理':
                try:
                    #p=subprocess.Popen('dissys.bat',shell=False)
                    #p.wait()
                    cmd1 = 'reg add "HKCU\\Software\\Microsoft\\Windows\\CurrentVersion\\Internet Settings" /v ProxyEnable /t REG_DWORD /d 1 /f >NUL'
                    cmd2 = 'reg add "HKCU\\Software\\Microsoft\\Windows\\CurrentVersion\\Internet Settings" /v ProxyServer /d "127.0.0.1:7890" /f >NUL'
                    cmd3 = 'reg add "HKCU\\Software\\Microsoft\\Windows\\CurrentVersion\\Internet Settings" /v ProxyOverride /t REG_SZ /d "" /f >NUL'
                    cmd = cmd1 + '&&' + cmd2 + '&&' + cmd3
                    os.system(cmd)
                    flash(isclash+' 系统代理：关闭')
                    return render_template('login.html',sysproxy='开启系统代理',clash=clash)
                except :
                    flash('关闭系统代理失败')
                    return render_template('login.html',sysproxy='关闭系统代理',clash=clash)
        if request.form['submit'] == '查看 代理':
            clash = request.form.get('clash')
            sysproxy = request.form.get('sysproxy')
            if clash == '启动Clash':
                flash('请先启动Clash')
                return render_template('login.html',clash=clash,sysproxy=sysproxy)
            try:
                currentconfig = api.admin.getfile('./App/tmp.vbs')
                currentconfig = str(currentconfig).split('-f')[1].split('\"')[0].replace(' ','')
                isDashboard = api.admin.getfile(currentconfig)
                if 'external-ui: dashboard_Razord' in isDashboard :
                    return redirect('http://127.0.0.1:9090/ui/#/proxies')
                else:
                    return redirect('http://clash.razord.top/#/proxies')
            except:
                flash('查看代理失败')
                return redirect(request.url)
        if request.form['submit'] == '配置 文件':
            return redirect('profiles')
        if request.form['submit'] == '高级 设置':
            return redirect('admin')
        if request.form['submit'] == '关闭 程序':
            try:
                os._exit()
            except:
                print('Program is dead.')
    a = os.popen('check.bat')
    a = a.read()
    clash = '启动Clash'
    isclash = 'Clash 未运行'
    if 'Console' in str(a):
        clash = '关闭Clash'
        isclash = 'Clash 正在运行'
    a = os.popen('checksys.bat')
    a = a.read().replace(' ','').replace('\n','')
    sysproxy = '关闭系统代理'
    issys = '系统代理：开启'
    if str(a).endswith('0x0'):
         sysproxy = '开启系统代理'
         issys = '系统代理：关闭'   
    flash(isclash+'\n'+issys) 
    return render_template('login.html',clash=clash,sysproxy=sysproxy)

@app.route('/profiles', methods=['GET', 'POST'])
def profiles():
    try:
        if request.method == "POST":
                if request.form['submit'] == '下载  配置': 
                    url = request.form.get('url')  
                    writeurl = request.form.get('writeurl') 
                    if '://' in url: 
                        if (writeurl):
                            content = '#默认值\napi = \''+ip+'\'\nurl = \''+url+'\'' 
                            api.admin.writefile(content,'./api/default.py')
                    else:
                        url = api.default.url       
                    fileadd = './Profile/'+request.form.get('configselect') 
                    backfile = fileadd+'bac'
                    api.admin.writefile(api.admin.getfile(fileadd),backfile)   #备份
                    content = api.subconverter.Retry_request(url)  #下载           
                    api.admin.writefile(content,fileadd)            #写入
                    flash('下载配置成功！')
                    return render_template('content.html',content=content,file=fileadd)   
                if request.form['submit'] == '查看  配置': 
                    fileadd = './Profile/'+request.form.get('configselect')              
                    content= api.admin.getfile(fileadd)
                    flash('查看配置成功！')
                    return render_template('content.html',content=content,file=fileadd) 
                if request.form['submit'] == '修改  名称':
                    filename = './Profile/'+request.form.get('filename')
                    if '.yaml' not in filename:
                        filename += '.yaml'                    
                    currentconfig = api.admin.getfile('./App/tmp.vbs')
                    currentconfig = str(currentconfig).split('-f')[1].split('\"')[0].replace(' ','').replace('.\\Profile\\','') 
                    fileadd =request.form.get('configselect')
                    if fileadd == currentconfig:
                        filetmp = str(filename).replace('/','\\')
                        script = 'CreateObject("WScript.Shell").Run "clash-win64 -d .\Profile -f {file}",0'.format(file=filetmp)
                        api.admin.writefile(script,'./App/tmp.vbs')                                            
                    fileadd = './Profile/'+fileadd  
                    os.rename(fileadd, filename)
                    return redirect('profiles')
                if  request.form['submit'] == '重启 Clash' :
                    fileadd = './Profile/'+request.form.get('configselect') 
                    fileadd = str(fileadd).replace('/','\\')
                    script = 'CreateObject("WScript.Shell").Run "clash-win64 -d .\Profile -f {file}",0'.format(file=fileadd)
                    api.admin.writefile(script,'./App/tmp.vbs')
                    os.system('taskkill /IM clash-win64.exe  1>NUL 2>NUL')
                    print('kill')
                    os.system('wscript ".\\App\\tmp.vbs"')
                    print('start')
                    flash('重启成功')
                    return redirect(ip)
                if  request.form['submit'] == '返回  主页' or request.form['submit'] == '返回主页' :
                    return redirect(ip)
                if  request.form['submit'] == '修改配置' :
                    content = request.form.get('content')
                    fileadd = request.form.get('file')
                    print('当前配置文件地址：'+fileadd)
                    api.admin.writefile(content,fileadd)
                    content= api.admin.getfile(fileadd)
                    flash('修改配置成功！')
                    return render_template('content.html',content=content,file=fileadd)  
                if  request.form['submit'] == '返回上页' :
                    return redirect(request.referrer) 
                if  request.form['submit'] == '重启Clash' :
                    fileadd = request.form.get('file')
                    fileadd = str(fileadd).replace('/','\\')
                    script = 'CreateObject("WScript.Shell").Run "clash-win64 -d .\Profile -f {file}",0'.format(file=fileadd)
                    api.admin.writefile(script,'./App/tmp.vbs')
                    os.system('taskkill /IM clash-win64.exe  1>NUL 2>NUL')
                    print('kill')
                    os.system('wscript ".\\App\\tmp.vbs"')
                    print('start')
                    flash('重启成功')
                    return redirect(ip)                    

        currentconfig = api.admin.getfile('./App/tmp.vbs')
        currentconfig = str(currentconfig).split('-f')[1].split('\"')[0].replace(' ','').replace('.\\Profile\\','')
        filelist = os.listdir('./Profile')
        config = [currentconfig,'','','','','']
        flag = 1
        for i in range(len(filelist)):
            if flag == 6:
                break
            if filelist[i].endswith('.yaml'):
                if filelist[i] != currentconfig: 
                    config[flag]=filelist[i]
                    flag +=1        
        return render_template('profiles.html',f1=config[0],f2=config[1],f3=config[2],f4=config[3],f5=config[4],f6=config[5])
    except Exception as e:
        flash('发生错误，重新操作')
        return redirect(ip)

@app.route('/admin', methods=['GET', 'POST'])
def admin():
    try:
        if request.method == "POST":
                if request.form['submit'] == '更新  geoip':               
                    p=subprocess.Popen('geoip.bat',shell=False)
                    p.wait()
                    flash('更新Geoip成功')
                    return redirect(ip)   
                if request.form['submit'] == '开启系统代理': 
                    p=subprocess.Popen('setsys.bat',shell=False)
                    p.wait()
                    flash('开启系统代理成功')
                    return redirect(ip)   
                if  request.form['submit'] == '关闭系统代理' :
                    p=subprocess.Popen('dissys.bat',shell=False)
                    p.wait()
                    flash('关闭系统代理成功')
                    return redirect(ip)   
                if  request.form['submit'] == '返回    主页' :
                    return redirect(ip)
        return render_template('admin.html')
    except Exception as e:
        flash('发生错误，重新操作')
        return redirect(ip)

if __name__ == '__main__':
    app.run(host='0.0.0.0',debug=False,port=10086)            #自定义端口

#  os.system('wscript ".\App\tmp.vbs" ')