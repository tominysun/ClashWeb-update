# coding=utf-8
import  sys
import  base64
import  re
import  requests
import  urllib3
import  urllib
import  json
import  time
import codecs
import api.default
urllib3.disable_warnings()
def Retry_request(url): #远程下载
    i = 0
    for i in range(2):
        try:
            res = requests.get(url) # verify =false 防止请求时因为代理导致证书不安全
            return res.text
        except Exception as e:
            i = i+1
    return 'erro'

def getgroups(name,custom,method):             # 节点分组相关函数 
    try:
            if custom == '' or custom == None:   #不分组的情况
                return ''          
            else:
                names = str(name).split('@')                
                groups = str(custom).split('@')
                methods = str(method).split('@')
                if len(groups) == len(names):  #分组填写正常的的情况
                        inigroup = ''
                        groupname = '`'
                        for i in range(1,len(groups)):
                            if methods[i] == 'sl':
                                inigroup += '@'+str(names[i])+'`select`'+str(groups[i])+''
                                groupname += '[]'+str(names[i])+'`'
                                continue
                            if methods[i] == 'ut':
                                inigroup += '@'+str(names[i])+'`url-test`'+str(groups[i])+'`http://www.gstatic.com/generate_204`500'
                                groupname += '[]'+str(names[i])+'`'
                                continue
                            if methods[i] == 'fb':
                                inigroup += '@'+str(names[i])+'`fallback`'+str(groups[i])+'`http://www.gstatic.com/generate_204`500'
                                groupname += '[]'+str(names[i])+'`'
                                continue
                            if methods[i] == 'lb':
                                inigroup += '@'+str(names[i])+'`load-balance`'+str(groups[i])+'`http://www.gstatic.com/generate_204`500'
                                groupname += '[]'+str(names[i])+'`'
                        proxygroup = api.default.proxygroup.format(groupname=groupname)
                        inicustom = proxygroup+inigroup                
                        return inicustom                         
    except Exception as e:
        return 'erro'