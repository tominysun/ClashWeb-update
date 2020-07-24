# coding=utf-8
import sys
import flask_restful
from flask import redirect, url_for,flash
import  re
import  requests
import urllib3
import urllib
import urllib.parse
import json
import time
import codecs
import subprocess
import base64
import api.admin
import api.subconverter
import api.default
import api.airport
import api.togist
import api.clashapi
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
ip = api.default.clashweb
clashapi = api.default.dashboard.split('ui')[0]
dashboard = api.default.dashboard
app.secret_key = 'some_secret'
mypath = os.getcwd().replace('\\','/')
sysflag = ''
print(mypath)

@app.route('/',methods=['GET', 'POST'])
def login():
    if request.method == "POST":
        if request.form['submit'] == 'clash': 
            clash = request.form.get('clash')

            sysproxy = request.form.get('sysproxy')
            if '开启' in sysproxy:
                issys = '系统代理：关闭'
            else:
                issys = '系统代理：开启'

            if clash == '启动Clash':
                try:
                    currentconfig = api.admin.getfile('./App/tmp.vbs')
                    currentconfig = str(currentconfig).split('-f')[1].split('\"')[0].replace(' ','').replace('.\\Profile\\','')
                    p=subprocess.Popen(mypath+'/bat/start.bat',shell=False)            
                    p.wait() 
                    print('start clash')
                    path=mypath+'/Profile/'+currentconfig
                    path=path.replace('/','\\')
                    p=requests.put(clashapi+'configs',data=json.dumps({'path':path}))     
                    if '' == p.text:
                        clash = '关闭Clash'
                        isclash = 'Clash 正在运行'
                        try:                            
                            api.clashapi.setproxies('./Profile/save/'+currentconfig.replace('.yaml','.txt'))  
                            print('加载保存的节点选择')
                            print('./Profile/'+currentconfig.replace('.yaml','.txt'))
                        except:
                            flash('1.当前配置未保存过节点。 无妨，Clash已成功启动！') 
                    else:
                        clash = '启动Clash'
                        isclash = 'Clash启动失败:'+p.text+'   '          
                    if(api.default.opensysafterstartclash):
                        p=subprocess.Popen(mypath+'/bat/setsys.bat',shell=False)
                        p.wait()
                        print("启动系统代理")
                        issys = '系统代理：开启'
                        sysproxy = '关闭系统代理'
                    flash(isclash+' '+issys)
                    return render_template('login.html',clash=clash,sysproxy=sysproxy)
                except :
                    flash('启动Clash失败')    
                    return redirect(ip)
            if clash == '关闭Clash':
                try:
                    currentconfig = api.admin.getfile('./App/tmp.vbs')
                    currentconfig = str(currentconfig).split('-f')[1].split('\"')[0].replace(' ','').replace('.yaml','.txt').replace('.\\Profile\\','')
                    try:
                        api.clashapi.getallproxies('./Profile/save/'+currentconfig)    
                        print('保存当前节点选择成功') 
                    except:
                        pass                  
                    p=subprocess.Popen(mypath+'/bat/stop.bat',shell=False)
                    p.wait()
                    #os.system('taskkill /IM clash-win64.exe  1>NUL 2>NUL')  
                    print('stop Clash')
                    flash('Clash 未运行 '+'系统代理：关闭')
                    return render_template('login.html',clash='启动Clash',sysproxy='开启系统代理')
                except :
                    flash('关闭Clash失败')
                    return redirect(ip)

        '''
        if request.form['submit'] == '系统代理': 
            clash = request.form.get('clash')
            sysproxy = request.form.get('sysproxy')
            isclash = 'Clash 正在运行'
            if '启动' in clash:
                isclash = 'Clash 未运行'
            if sysproxy == '开启系统代理':
                try:
                    p=subprocess.Popen(mypath+'/bat/setsys.bat',shell=False)
                    p.wait()
                    #os.system('reg add "HKCU\\Software\\Microsoft\\Windows\\CurrentVersion\\Internet Settings" /v ProxyEnable /t REG_DWORD /d 0 /f >NUL')
                    flash(isclash+' 系统代理：开启')
                    print('start system proxy')
                    return render_template('login.html',sysproxy='关闭系统代理',clash=clash)
                except :
                    flash('开启系统代理失败')    
                    return redirect(ip)
            if sysproxy == '关闭系统代理':
                try:
                    p=subprocess.Popen(mypath+'/bat/dissys.bat',shell=False)
                    p.wait()
                    #cmd1 = 'reg add "HKCU\\Software\\Microsoft\\Windows\\CurrentVersion\\Internet Settings" /v ProxyEnable /t REG_DWORD /d 1 /f >NUL'
                    #cmd2 = 'reg add "HKCU\\Software\\Microsoft\\Windows\\CurrentVersion\\Internet Settings" /v ProxyServer /d "127.0.0.1:7890" /f >NUL'
                    #cmd3 = 'reg add "HKCU\\Software\\Microsoft\\Windows\\CurrentVersion\\Internet Settings" /v ProxyOverride /t REG_SZ /d "" /f >NUL'
                    #cmd = cmd1 + '&&' + cmd2 + '&&' + cmd3
                    #os.system(cmd)
                    print('stop system proxy')
                    flash(isclash+' 系统代理：关闭')
                    return render_template('login.html',sysproxy='开启系统代理',clash=clash)
                except :
                    flash('关闭系统代理失败')
                    return redirect(ip)
        '''
        if request.form['submit'] == '切换 节点':
            clash = request.form.get('clash')
            sysproxy = request.form.get('sysproxy')
            if clash == '启动Clash':
                flash('请先启动Clash')
                return render_template('login.html',clash=clash,sysproxy=sysproxy)
            try:
                currentconfig = api.admin.getfile('./App/tmp.vbs')
                currentconfig = str(currentconfig).split('-f')[1].split('\"')[0].replace(' ','')
                isDashboard = api.admin.getfile(currentconfig)
                os.system('start '+dashboard)
                return redirect(ip)
            except:
                flash('查看代理失败')
                return redirect(request.url)
        if request.form['submit'] == '订阅  管理':
            return redirect('profiles')
        '''
        if request.form['submit'] == '保存 节点':
            currentconfig = api.admin.getfile('./App/tmp.vbs')
            currentconfig = str(currentconfig).split('-f')[1].split('\"')[0].replace(' ','').replace('.yaml','.txt').replace('.\\Profile\\','')
            api.clashapi.getallproxies('./Profile/save/'+currentconfig)    
            flash('【手动】记忆当前节点选择成功！！！ 当你重启Clash或者关闭Clash时会【自动】记忆节点！！！')
            return redirect(ip)
        '''
        if request.form['submit'] == '高级 设置':
            return redirect('admin')
    #time.sleep(1)
    a = os.popen(mypath+'/bat/check.bat')
    a = a.read()
    if 'Console' in str(a):   #检查是否正常运行，console in 表示在运行。
        clash = '关闭Clash'
        isclash = 'Clash 正在运行'
    else:
        clash = '启动Clash' 
        isclash = 'Clash 未运行'   
    a = os.popen(mypath+'/bat/checksys.bat')
    a = a.read().replace(' ','').replace('\n','')
    if str(a).endswith('0x0'):
        sysproxy = '开启系统代理'
        issys = '系统代理：关闭'   
    else:
        sysproxy = '关闭系统代理'
        issys = '系统代理：开启'
    flash(isclash+'\n'+issys) 
    return render_template('login.html',clash=clash,sysproxy=sysproxy)

@app.route('/profiles', methods=['GET', 'POST'])
def profiles():
    try:
        if request.method == "POST":
                if request.form['submit'] == '更新  配置':            
                    url = request.form.get('url')  
                    fileadd = './Profile/'+request.form.get('configselect')    
                    configtype =request.values.get('customRadioInline1')         
                    if '://' in url:
                        if configtype == 'notclash':
                            url = urllib.parse.quote(url)
                            url = '{ip}/sub?target=clashr&url={sub}'.format(ip=api.default.subconverter,sub=url)    #非Clash进行拼接 
                        if '127.0.0.1' in url or 'localhost' in url:
                            p=subprocess.Popen(mypath+'/bat/subconverter.bat',shell=False) 
                            p.wait()
                        content = api.subconverter.Retry_request(url)
                        p=subprocess.Popen(mypath+'/bat/stopsubconverter.bat',shell=False)
                        p.wait()
                        if content == 'erro':
                            return '下载失败，检查浏览器能否上网！如果是本地托管，请先双击/App/subconverter/subconverter.exe赋予联网权限'
                        content = '#托管地址:'+url+'NicoNewBeee的Clash控制台\n'+content     #下载           
                        api.admin.writefile(content,fileadd)                               #写入
                        flash('下载配置成功。注意查看内容是否正常，无误后请点击重启Clash以应用！')
                        return render_template('content.html',content=content,file=fileadd,sub=url) 

                    else:
                        try:
                            url=str(api.admin.getfile(fileadd)).split('NicoNewBeee的Clash控制台')[0].split('#托管地址:')[1]
                        except:
                            return '未查到托管地址，请在输入框输入托管地址'
                        if '127.0.0.1' in url or 'localhost' in url:
                            p=subprocess.Popen(mypath+'/bat/subconverter.bat',shell=False) 
                            p.wait()
                        content = api.subconverter.Retry_request(url)
                        p=subprocess.Popen(mypath+'/bat/stopsubconverter.bat',shell=False)
                        p.wait()
                        if content == 'erro':
                            return '下载失败，重新尝试,默认使用系统代理下载托管，请注意检查浏览器能否上网！！'
                        content = '#托管地址:'+url+'NicoNewBeee的Clash控制台\n'+content  #下载  
                        api.admin.writefile(content,fileadd)            #写入
                        flash('下载配置成功！托管地址未变动！注意查看内容是否正常，无误后请点击重启Clash以应用！')
                        return render_template('content.html',content=content,file=fileadd,sub=url)                         
                if request.form['submit'] == '查看  配置': 
                    fileadd = './Profile/'+request.form.get('configselect')              
                    content= api.admin.getfile(fileadd)
                    try:
                        url=content.split('NicoNewBeee的Clash控制台')[0].split('#托管地址:')[1]
                        content
                    except:
                        url='erro'
                        content=''
                    flash('查看配置成功！')
                    return render_template('content.html',content=content,file=fileadd,sub=url) 
                if  request.form['submit'] == '重启/切换' :
                    currentconfig = api.admin.getfile('./App/tmp.vbs')
                    currentconfig = str(currentconfig).split('-f')[1].split('\"')[0].replace(' ','').replace('.yaml','.txt').replace('.\\Profile\\','')
                    try:
                        api.clashapi.getallproxies('./Profile/save/'+currentconfig)  
                        print('保存当前节点选择成功,开始重启') 
                    except:
                        pass   
                    fileadd = './Profile/'+request.form.get('configselect')
                    fileadd2 = './Profile/save/'+request.form.get('configselect') 
                    fileadd = str(fileadd).replace('/','\\')
                    script = 'CreateObject("WScript.Shell").Run "clash-win64 -d .\Profile -f {file}",0'.format(file=fileadd)
                    api.admin.writefile(script,'./App/tmp.vbs')
                    p=subprocess.Popen(mypath+'/bat/start.bat',shell=False)            
                    p.wait()
                    path = mypath+fileadd
                    path = path.replace('/','\\').replace('.\\','\\')
                    p=requests.put(clashapi+'configs',data=json.dumps({'path':path}))
                    if '' == p.text:
                        try:
                            api.clashapi.setproxies(fileadd2.replace('.yaml','.txt'))
                        except:
                            pass
                        flash('重启成功')
                    else:
                        flash('重启失败： '+p.text)
                    return redirect(ip)
                if  request.form['submit'] == '返回  主页' or request.form['submit'] == '返回主页' :
                    return redirect(ip)
                if  request.form['submit'] == '修改订阅/修改配置' :
                    sub = request.form.get('sub')
                    content = request.form.get('content')
                    content = '#托管地址:'+sub+'NicoNewBeee的Clash控制台'+content.split('NicoNewBeee的Clash控制台')[1]
                    fileadd = request.form.get('file')
                    print('当前配置文件地址：'+fileadd)
                    api.admin.writefile(content,fileadd)
                    content= api.admin.getfile(fileadd)
                    try:
                        url=content.split('NicoNewBeee的Clash控制台')[0].split('#托管地址:')[1]
                        content
                    except:
                        url='erro'
                        content=''
                    flash('修改配置成功！点击重启以应用！')
                    return render_template('content.html',content=content,file=fileadd,sub=url)  
                if  request.form['submit'] == '返回上页' :
                    return redirect(request.referrer) 
                if  request.form['submit'] == '重启Clash' :
                    currentconfig = api.admin.getfile('./App/tmp.vbs')
                    currentconfig = str(currentconfig).split('-f')[1].split('\"')[0].replace(' ','').replace('.yaml','.txt').replace('.\\Profile\\','')
                    try:
                        api.clashapi.getallproxies('./Profile/save/'+currentconfig)    
                        print('保存当前节点选择成功，开始重启')  
                    except:
                        pass
                    fileadd = request.form.get('file')
                    fileadd2 = './Profile/save/'+request.form.get('file').split('./Profile/')[1] 
                    fileadd = str(fileadd).replace('/','\\')
                    script = 'CreateObject("WScript.Shell").Run "clash-win64 -d .\Profile -f {file}",0'.format(file=fileadd)
                    api.admin.writefile(script,'./App/tmp.vbs')
                    p=subprocess.Popen(mypath+'/bat/start.bat',shell=False)            
                    p.wait()
                    path = mypath+fileadd
                    path = path.replace('/','\\').replace('.\\','\\')
                    p=requests.put(clashapi+'configs',data=json.dumps({'path':path}))
                    if '' == p.text:
                        try:
                            api.clashapi.setproxies(fileadd2.replace('.yaml','.txt'))
                        except:
                            pass
                        flash('重启成功')
                    else:
                        flash('重启失败： '+p.text)
                    return redirect(ip)
                if  request.form['submit'] == '订阅转换' :   
                    os.system('explorer file:///{path}/Profile/sub-web/index.html'.format(path=mypath)) 
                    flash('订阅转换')
                    return redirect('profiles') 
                if  request.form['submit'] == '节点分组' :  
                    os.system('start /min '+ip+'/customgroup') 
                if request.form['submit'] == 'STC  特供':
                    return redirect('airport')   
                if request.form['submit'] == '上传 gist':
                    return redirect('togist')    
                if request.form['submit'] == '打开目录':
                    os.system('explorer file:///{path}/Profile'.format(path=mypath)) 
                    return redirect('profiles') 
                if request.form['submit'] == '修改名称':
                    filename = './Profile/'+request.form.get('filename')
                    if filename == "./Profile/":
                        return '请先输入名称'
                    if '.yaml' not in filename:
                        filename += '.yaml'                    
                    currentconfig = api.admin.getfile('./App/tmp.vbs')
                    currentconfig = str(currentconfig).split('-f')[1].split('\"')[0].replace(' ','').replace('.\\Profile\\','') 
                    fileadd =request.form.get('configselect')
                    fileadd = './Profile/'+fileadd 
                    try: 
                        os.rename(fileadd, filename)
                    except:
                        return "重名了！！！"   
                    currentconfig = './Profile/' + currentconfig                
                    if fileadd == currentconfig:
                        filetmp = str(filename).replace('/','\\')
                        script = 'CreateObject("WScript.Shell").Run "clash-win64 -d .\Profile -f {file}",0'.format(file=filetmp)
                        api.admin.writefile(script,'./App/tmp.vbs')                                            
                    flash('重命名成功')
                    return redirect('profiles')    
        currentconfig = api.admin.getfile('./App/tmp.vbs')
        currentconfig = str(currentconfig).split('-f')[1].split('\"')[0].replace(' ','').replace('.\\Profile\\','')
        filelist = os.listdir('./Profile')
        config = []
        config.append(currentconfig)
        for i in range(len(filelist)):
            if filelist[i].endswith('.yaml'):
                if filelist[i] == 'notchangeme.yaml':
                    continue
                if filelist[i] != currentconfig: 
                    config.append(filelist[i])    
        return render_template('profiles.html',cates=config)
    except Exception as e:
        flash('发生错误，重新操作'+e)
        return redirect(ip)

@app.route('/admin', methods=['GET', 'POST'])
def admin():
    try:
        if request.method == "POST":
                if request.form['submit'] == '更新  geoip':               
                    url = "https://download.maxmind.com/app/geoip_download?edition_id=GeoLite2-Country&license_key={key}&suffix=tar.gz".format(key=api.default.key)
                    r = requests.get(url) 
                    with open("./Profile/GeoLite2-Country.tar.gz",'wb') as f:
                        f.write(r.content)
                    p=subprocess.Popen(mypath+'/bat/geoip.bat',shell=False)
                    p.wait()
                    flash('更新Geoip成功')
                    return redirect(ip)   
                if request.form['submit'] == '开机    启动':               
                    p=subprocess.Popen(mypath+'/App/startup.bat',shell=False)
                    p.wait()
                    flash('设置成功')
                    return redirect(request.url)   
                if request.form['submit'] == 'UWP回 环代理':               
                    p=subprocess.Popen(mypath+'/bat/uwp.bat',shell=False)
                    p.wait()
                    flash('打开成功')
                    return redirect(request.url)   
                if request.form['submit'] == '开启系统代理': 
                    p=subprocess.Popen(mypath+'/bat/setsys.bat',shell=False)
                    p.wait()
                    flash('开启系统代理成功')
                    return redirect(ip)   
                if  request.form['submit'] == '关闭系统代理' :
                    p=subprocess.Popen(mypath+'/bat/dissys.bat',shell=False)
                    p.wait()
                    flash('关闭系统代理成功')
                    return redirect(ip)   
                if  request.form['submit'] == '返回    主页' :
                    return redirect(ip)
        return render_template('admin.html')
    except Exception as e:
        flash('发生错误，重新操作'+e)
        return redirect(ip)

@app.route('/airport',methods=['GET', 'POST'])
def airport():
    if request.method == "POST":
        email = request.form.get('email')
        passwd = request.form.get('passwd')
        suburl = api.airport.stc(email,passwd)   #ssr订阅
        totalurl = suburl+'|'+suburl+'?mu=2'     #ssr+V2订阅
        sub = urllib.parse.quote(totalurl)
        clash = '{ip}/sub?target=clashr&url={sub}'.format(ip=api.default.subconverter,sub=sub)  #Clash订阅
        currentconfig = api.admin.getfile('./App/tmp.vbs')
        currentconfig = str(currentconfig).split('-f')[1].split('\"')[0].replace(' ','').replace('.\\Profile\\','')   #获取当前配置文件
        currentconfig = './Profile/'+currentconfig
        currentconfig2 = './Profile/save/'+currentconfig
        if '127.0.0.1' in clash or 'localhost' in clash:
            p=subprocess.Popen(mypath+'/bat/subconverter.bat',shell=False) 
            p.wait()        
        content = '#托管地址:'+clash+'NicoNewBeee的Clash控制台\n'+api.admin.Retry_request(clash)
        p=subprocess.Popen(mypath+'/bat/stopsubconverter.bat',shell=False)
        p.wait()
        api.admin.writefile(content,currentconfig) 
        p=subprocess.Popen(mypath+'/bat/start.bat',shell=False)            
        p.wait()
        path = mypath+currentconfig
        path = path.replace('/','\\').replace('.\\','\\')
        p=requests.put(clashapi+'configs',data=json.dumps({'path':path}))
        if '' == p.text:
            try:
                api.clashapi.setproxies(currentconfig2.replace('.yaml','.txt'))
            except:
                pass
            flash('重启成功')
        else:
            flash('重启失败： '+p.text)
        return redirect(ip)
        flash('尊敬的STC用户，您可以使用了！！！')
        return redirect(ip)                    
    return render_template('airport.html')

@app.route('/customgroup', methods=['GET', 'POST'])
def customgroup():
    try:
        if request.method == "POST":
            if request.form['submit'] == '点击添加节点分组':            
                ori1 = request.form['custom1']
                ori2 = request.form['custom2']
                ori3 = request.form['custom3']
                add1 = '@'+ request.form['firstname']
                add2 = '@'+request.form['lastname']
                add3='@'+  request.values.get('method')
                if add1 == '@':
                    return '未填写名称'                
                if add2 == '@':
                    return '未填写节点'
                return render_template('groups.html',custom1=ori1+add1,custom2=ori2+add2,custom3=ori3+add3)    
            s = request.form['left']
            s = s.replace('\n','|').replace('\r','')
            if s.split('|')[-1]== '':
                s = s[:-1]        
            if '://' in s:
                n=request.form['custom1']           
                c=request.form['custom2']
                method = request.form['custom3']
                len1 = len(str(n).split('@'))
                len2 = len(str(c).split('@'))
                len3 = len(str(method).split('@'))
                if len1 != len2 or len1 != len3 or len2 != len3:
                    return('检查分组是否一一对应')
                groups = str(safe_base64_encode(api.subconverter.getgroups(n,c,method))).split('\'')[1]
                sub = urllib.parse.quote(s)
                try:
                    tool=str(request.values.get('tool'))
                    emoji = request.form.get('emoji')
                    if emoji == None:
                        emoji = 'false'
                    fdn = request.form.get('fdn')
                    if fdn == None:
                        fdn= 'false'
                except :
                    return '出现BUG，请反馈'      
                if tool == 'clash':
                        CustomGroupvmess = '{ip}/sub?target=clash&url={sub}&groups={groups}&emoji={emoji}&fdn={fdn}'.format(ip=api.default.subconverter,sub=str(sub),groups=groups,emoji=emoji,fdn=fdn)
                        api2 = 'https://gfwsb.114514.best/sub?target=clash&url={sub}&emoji={emoji}&fdn={fdn}'.format(sub=str(sub),emoji=emoji,fdn=fdn) 
                        return render_template('clashr.html',sub = s,custom=n+c+method+'  备用暂时不支持',api=CustomGroupvmess,api2=api2)         
                if tool == 'clashr':
                        CustomGroupvmess = '{ip}/sub?target=clashr&url={sub}&groups={groups}&emoji={emoji}&fdn={fdn}'.format(ip=api.default.subconverter,sub=str(sub),groups=groups,emoji=emoji,fdn=fdn)
                        api2 = 'https://gfwsb.114514.best/sub?target=clashr&url={sub}&emoji={emoji}&fdn={fdn}'.format(sub=str(sub),emoji=emoji,fdn=fdn) 
                        return render_template('clashr.html',sub = s,custom=n+c+method+'  备用暂时不支持',api=CustomGroupvmess,api2=api2)                       
                if tool == 'surge':
                        CustomGroupvmess = '{ip}/sub?target=surge&url={sub}&groups={groups}&ver=4&emoji={emoji}&fdn={fdn}'.format(ip=api.default.subconverter,sub=str(sub),groups=groups,emoji=emoji,fdn=fdn)
                        api2 = 'https://gfwsb.114514.best/sub?target=surge&url={sub}&emoji={emoji}&fdn={fdn}'.format(sub=str(sub),emoji=emoji,fdn=fdn) 
                        return render_template('surge.html',sub = s,custom=n+c+method+'\n备用暂时不支持\n'+'默认为surge4，参数为为ver=4。',api=CustomGroupvmess,api2=api2)
                if tool == 'quanx':
                        CustomGroupvmess = '{ip}/sub?target=quanx&url={sub}&groups={groups}&emoji={emoji}&fdn={fdn}'.format(ip=api.default.subconverter,sub=str(sub),groups=groups,emoji=emoji,fdn=fdn)
                        api2 = 'https://gfwsb.114514.best/sub?target=quanx&url={sub}&emoji={emoji}&fdn={fdn}'.format(sub=str(sub),emoji=emoji,fdn=fdn) 
                        return render_template('quanx.html',sub = s,custom=n+c+method+'  备用暂时不支持',api=CustomGroupvmess,api2=api2)  
                if tool == 'loon':
                        CustomGroupvmess = '{ip}/sub?target=loon&url={sub}&groups={groups}&emoji={emoji}&fdn={fdn}'.format(ip=api.default.subconverter,sub=str(sub),groups=groups,emoji=emoji,fdn=fdn)
                        api2 = 'https://gfwsb.114514.best/sub?target=loon&url={sub}&emoji={emoji}&fdn={fdn}'.format(sub=str(sub),emoji=emoji,fdn=fdn) 
                        return render_template('loon.html',sub = s,custom=n+c+method+'  备用暂时不支持',api=CustomGroupvmess,api2=api2)  
                if tool == 'mellow':
                        CustomGroupvmess = '{ip}/sub?target=mellow&url={sub}&groups={groups}&emoji={emoji}&fdn={fdn}'.format(ip=api.default.subconverter,sub=str(sub),groups=groups,emoji=emoji,fdn=fdn)
                        api2 = 'https://gfwsb.114514.best/sub?target=mellow&url={sub}&emoji={emoji}&fdn={fdn}'.format(sub=str(sub),emoji=emoji,fdn=fdn) 
                        return render_template('mellow.html',sub = s,custom=n+c+method+'  备用暂时不支持',api=CustomGroupvmess,api2=api2)
                if tool == 'surfboard':
                        CustomGroupvmess = '{ip}/sub?target=surfboard&url={sub}&groups={groups}&emoji={emoji}&fdn={fdn}'.format(ip=api.default.subconverter,sub=str(sub),groups=groups,emoji=emoji,fdn=fdn)
                        api2 = 'https://gfwsb.114514.best/sub?target=surfboard&url={sub}&emoji={emoji}&fdn={fdn}'.format(sub=str(sub),emoji=emoji,fdn=fdn) 
                        return render_template('surfboard.html',sub = s,custom=n+c+method+'  备用暂时不支持',api=CustomGroupvmess,api2=api2)                                          
                else:
                    return render_template('groups.html')    
            else:
                return '订阅不规范'
        return render_template('groups.html')
    except Exception as e:
        return e

@app.route('/togist',methods=['GET', 'POST'])
def togist():
    if request.method == "POST":
        email = request.form.get('email')
        passwd = request.form.get('passwd')
        fileadd = request.form.get('file')
        gist = request.form.get('gist')
        if email =='' or passwd == '' or fileadd == '' or gist == '':
            flash('检查是否漏填了或者忘记选择文件了？')
            return redirect(request.referrer)
        try:
            gist = gist.split('/')
            usrname = gist[3]
            id = gist[4]
        except:
            flash('请输入正确gist地址')
            return redirect(request.referrer)
        auth=requests.auth.HTTPBasicAuth(email,passwd)
        flag=api.togist.togist(fileadd,usrname,id,auth)
        if flag == 'erro':
            flash('发生错误')
            return redirect(request.referrer)
        else:
            return '成功上传，Gist托管地址为：'+flag                
    return render_template('togist.html')

@app.route('/start',methods=['GET', 'POST'])
def start(): 
    try:
        if sysflag == '':
            return redirect(ip)    
        return redirect(sysflag)             
    except Exception as e:
        pass    

if __name__ == '__main__':
    port = api.default.clashweb.split(':')[-1]
    try:
        sysflag = sys.argv[1]
    except:
        sysflag = ''
    print(sysflag)
    os.system('start '+ip+'/start')
    app.run(host='127.0.0.1',debug=False,port=port)            #自定义端口   

#  os.system('wscript ".\App\tmp.vbs" ')