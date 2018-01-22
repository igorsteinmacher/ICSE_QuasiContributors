import requests
import json
import time
from requests.auth import HTTPBasicAuth
import os.path


errors = []

ACCESS_TOKEN = ""#Github access token

def get_json(url):
	url = url+"?access_token=" + ACCESS_TOKEN
	print url
	resp = requests.get(url) 
	json_objs = resp.json()
	return json_objs
  
def get_commits(owner, repo, PR):
    try:
        url = 'https://api.github.com/repos/'+owner+'/'+repo+'/pulls/'+str(PR.strip())+'/commits'
        json_objs = get_json(url)
        commits = []
        for commit in json_objs:
            commits.append(commit['sha'])
            commits.append(commit['commit']['tree']['sha'])
        return commits
    except Exception as e:
        print e
        pass
    
def retrieve_commits(owner, repo, filename):
    done = []
    print filename
    file_out = open(filename, 'r')
    for line in iter(file_out):
    	  data=line.split(';')
    	  x = data[1]
    	  y = int(x.strip())+1
          for i in range(1,y):
    	      commits = []
              commits = get_commits(owner, repo, data[i+1])
              for commit in commits:
                  target = open(repo+"_shas.csv", 'a+')
                  merge = (data[0],data[i+1].strip(),str(commit))
                  target.write (str(merge[0]) + ';' + str(merge[1])+';' + str(merge[2]+'\n'))        
                  target.close()
                  print str(merge[0]) + ';' + str(merge[1])+';' + str(merge[2])
                  done.append(merge)
    return done

      

proj_list=[['angular', 'angular.js']#,['d3','d3'], ['BVLC','caffe'], ['bitcoin','bitcoin'],
#['twbs','bootstrap'], ['django','django'],['pallets','flask'],
#['docker','docker'],
#['jenkinsci','jenkins'],['joomla','joomla-cms'],
#['jquery','jquery'],['laravel','laravel'],['mongodb','mongo'],['opencv','opencv'],
#['rails','rails']
#,['facebook','react'],['antirez','redis'],['scikit-learn','scikit-learn'],
#['spring-projects','spring-framework'],['tensorflow','tensorflow'],['kubernetes','kubernetes']
]
for project in proj_list:
	try:
	   owner= project[0]
	   repo=project[1]
	   print "starting "+repo
#	   target = open(repo+"_shas.csv", 'w')
	   filename="projetosComMetricas/"+repo+'.txt'
	   users_done = []
	   list_commits = retrieve_commits(owner, repo, filename)
#	   for commit in list_commits:
#        target.write (str(commit[0]) + ';' + str(commit[1])+';' + str(commit[2]+'\n'))        
#	   target.close()
	except Exception as e:
	 	print e
#	 	target.close()
        
            
