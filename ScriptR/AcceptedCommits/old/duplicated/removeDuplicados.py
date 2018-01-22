import requests
import json
import time
from requests.auth import HTTPBasicAuth
import os.path



proj_list=[['d3','d3'], ['BVLC','caffe'], ['angular', 'angular.js'],['bitcoin','bitcoin'],
['twbs','bootstrap'], ['django','django'],['pallets','flask'],
['docker','docker'],
['jenkinsci','jenkins'],['joomla','joomla-cms'],
['jquery','jquery'],['laravel','laravel'],['mongodb','mongo'],['opencv','opencv'],
['rails','rails'],['facebook','react'],['antirez','redis'],['scikit-learn','scikit-learn'],
['spring-projects','spring-framework'],['tensorflow','tensorflow'],['kubernetes','kubernetes']
]
for project in proj_list:
   owner= project[0]
   repo=project[1]
   print "starting "+repo
   ler = open(repo+"_temCommit.csv", 'r')
   escrever =open(repo+ "_temCommit_unico.csv", 'w') 
   prev_line = ""
   for line in iter(ler):
   	if (line!=prev_line):
   		escrever.write(line)
   		prev_line=line 