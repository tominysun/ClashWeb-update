# -*- coding: utf-8 -*-
import configparser
import os
class MyConfigParser(configparser.ConfigParser):
    def __init__(self, defaults=None):
        configparser.ConfigParser.__init__(self, defaults=defaults)

    def optionxform(self, optionstr):
        return optionstr


proDir = os.getcwd()
configPath = os.path.join(proDir, "api\default.ini")
conf = MyConfigParser()
conf.read(configPath, encoding="utf-8")

def getvalue(group,key):
    return conf.get(group,key)

    