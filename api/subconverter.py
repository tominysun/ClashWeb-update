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
import api.loglog
urllib3.disable_warnings()
def Retry_request(url): #远程下载
    i = 0
    headers = {
        "User-Agent": "ClashforWindows/<0.11.3>"
    }
    proxies = { "http": None, "https": None}
    for i in range(2):
        try:
            api.loglog.loglog('download without proxy')
            res = requests.get(url, headers = headers, proxies=proxies) 
            return res.text
        except Exception as e:
            try: 
                api.loglog.loglog('download with proxy')
                res = requests.get(url, headers = headers) 
                return res.text
            except Exception as e:
                api.loglog.loglog('download erro'+e)
                i = i+1
    return 'erro'

