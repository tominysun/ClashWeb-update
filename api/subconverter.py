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
urllib3.disable_warnings()
def Retry_request(url): #远程下载
    i = 0
    for i in range(2):
        try:
            headers = {
                "User-Agent": "ClashforWindows/<0.11.3>"
            }
            res = requests.get(url, headers = headers) # verify =false 防止请求时因为代理导致证书不安全
            return res.text
        except Exception as e:
            i = i+1
    return 'erro'

