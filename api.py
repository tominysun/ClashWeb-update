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
        if request.form['submit'] == '启动Clash':
            try:
                p=subprocess.Popen('start.bat',shell=False)
                p.wait()
                flash('开启成功')
                return redirect(request.url) 
            except :
                flash('启动失败')
                return redirect(request.url)         
        if request.form['submit'] == '关闭Clash':
            try:
                p=subprocess.Popen('stop.bat',shell=False)
                p.wait()
                flash('关闭成功')
                return redirect(request.url)
            except :
                flash('关闭失败')
                return redirect(request.url)
        if request.form['submit'] == '查看 代理':
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
    return render_template('login.html')

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
                    fileadd = './Profile/'+request.form.get('file') 
                    backfile = fileadd+'bac'
                    api.admin.writefile(api.admin.getfile(fileadd),backfile)   #备份
                    content = api.subconverter.Retry_request(url)  #下载           
                    api.admin.writefile(content,fileadd)            #写入
                    flash('下载配置成功！')
                    return render_template('content.html',content=content)   
                if request.form['submit'] == '修改  配置':               
                    content = request.form.get('content')
                    fileadd = './Profile/'+request.form.get('file')             
                    api.admin.writefile(content,fileadd)
                    content= api.admin.getfile(fileadd)
                    flash('修改配置成功！')
                    return render_template('content.html',content=content)  
                if request.form['submit'] == '查看  配置': 
                    fileadd = './Profile/'+request.form.get('file')              
                    content= api.admin.getfile(fileadd)
                    flash('查看配置成功！')
                    return render_template('content.html',content=content)         
                if  request.form['submit'] == '重启 Clash' :
                    fileadd = './Profile/'+request.form.get('file') 
                    fileadd = str(fileadd).replace('/','\\')
                    script = 'CreateObject("WScript.Shell").Run "clash-win64 -d .\Profile -f {file}",0'.format(file=fileadd)
                    api.admin.writefile(script,'./App/tmp.vbs')
                    p=subprocess.Popen('start.bat',shell=False)
                    p.wait()
                    flash('重启成功')
                    return redirect(ip)
                if  request.form['submit'] == '返回  主页' :
                    return redirect(ip)
        filelist = os.listdir('./Profile')
        filename = ''
        for i in filelist:
            if i.endswith('.yaml'):
                filename += i+'\n' 
        filename += '\n以上是你的所有配置文件'
        return render_template('profiles.html',currentfile=filename,file='config.yaml')
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