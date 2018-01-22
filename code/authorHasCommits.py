import requests
import json
import time
from requests.auth import HTTPBasicAuth
import os.path


errors = []
ACCESS_TOKEN = "" #here you have to use your github access token


def get_json(url):
	url = url+"&access_token=" + ACCESS_TOKEN
	resp = requests.get(url)
	json_objs = resp.json()
	print json_objs
	return json_objs


def retrieve_commits(owner, repo, filename):
    done = []
    print filename
    file_out = open(filename, 'r')
    for line in iter(file_out):
    	  data=line.split(';')
    	  x = data[0]
    	  url = 'https://api.github.com/repos/'+owner+'/'+repo+'/commits?author='+str(x)
    	  json_objs = get_json(url)
    	  if json_objs:
              target = open(repo+"_unicos.csv", 'a+')
              target.write(x+"\n")
              print "SIM " + x;
              target.close()
          else:
              print "Nao " + x
    return done



proj_list=[#['angular', 'angular.js'],['d3','d3'], ['BVLC','caffe'], ['bitcoin','bitcoin']
#['twbs','bootstrap'], ['django','django'],['pallets','flask'],
#['docker','docker'],
#['jenkinsci','jenkins'],['joomla','joomla-cms'],
#['jquery','jquery'],['laravel','laravel'],['mongodb','mongo'],['opencv','opencv'],
#['rails','rails']
#['facebook','react'],['antirez','redis'],['scikit-learn','scikit-learn'],
#['spring-projects','spring-framework'],['tensorflow','tensorflow'],
['kubernetes','kubernetes']
]
for project in proj_list:
	try:
	   owner= project[0]
	   repo=project[1]
	   print "starting "+repo
	   filename="projetosComMetricas/"+repo+'.txt'
	   users_done = []
	   list_commits = retrieve_commits(owner, repo, filename)
#	   for commit in list_commits:
#        target.write (str(commit[0]) + ';' + str(commit[1])+';' + str(commit[2]+'\n'))
#	   target.close()
	except Exception as e:
	 	print e
#	 	target.close()
