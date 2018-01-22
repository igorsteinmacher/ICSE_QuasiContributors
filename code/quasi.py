import requests
import json
import time
from requests.auth import HTTPBasicAuth
import os.path
import urllib3
urllib3.disable_warnings()
errors = []

GH_USER = ""#your github username
GH_PASSWD = ""#your github passwd


def get_json(url):
   resp = requests.get(url, auth=HTTPBasicAuth(GH_USER, GH_PASSWD)) 
   json_objs = resp.json()
   return json_objs

def get_user(owner, repo, PR_number):
   url = 'https://api.github.com/repos/'+owner+'/'+repo+'/pulls/'+str(PR_number)
   github_resp = get_json(url)
   user = github_resp['user']['login']
   return user
   
def get_PRs(owner, repo, user):
   #retrieve merged pull requests made by a given user. 
    url = 'https://api.github.com/search/issues?q=is:merged+is:pr+is:closed+repo:'+owner+'/'+repo + '+author:'+ user
    json_objs = get_json(url)
    #If there is 0, he never got in and we retrieve the # of tries
    PRs = []
    array=[]
    try:
        if (json_objs['total_count'] == 0):
            url = 'https://api.github.com/search/issues?q=is:unmerged+is:pr+is:closed+repo:'+owner+'/'+repo + '+author:'+ user
            json_objs = get_json(url)
            for PR in json_objs['items']:
                PRs.append(PR['number'])
            print user + ' -- ' + str(json_objs['total_count'])
            array = [user, json_objs['total_count'], PRs]
    except:
        print url
        errors.append (url)
        pass
    return array
    
def list_unmerged (owner, repo, users_done):
   unmerged_PRs = []
   i = 1;
   thousands=1
   num_pages = 1;
   last_creation = '2011-07-01'
   while (i <= num_pages):
      url = 'https://api.github.com/search/issues?q=is:unmerged+is:pr+is:closed+repo:'+owner+'/'+repo + '+created:>='+last_creation+'&page='+str(i) +'&per_page=100&sort=created&order=asc'
      print url
      json_objs = get_json(url)
      if (i == 1):
         num_pages = (json_objs['total_count'] / 100) + 1
      for PR in json_objs['items']:   
         user = PR['user']['login'] 
         if ((user not in unmerged_PRs) and (user not in users_done)):
            print user 
            unmerged_PRs.append(user)
      i += 1
      if (i == 11):
         thousands += 1
         last_creation = PR['created_at'].split('T')[0]
         i = 1
      time.sleep(2)
   return unmerged_PRs


def retrieve_OK(filename):
    done = []
    print filename
    file_out = open(filename, 'r')
    for line in iter(file_out):
        done.append(line.split(';')[0])
        print line
    print str(done)
    return done


#try: 
proj_list=[['kubernetes','kubernetes']]#pallets','flask'], ['bitcoin','bitcoin']]#['spring-projects','spring-framework'],['opencv','opencv'],['BVLC','caffe']]
for project in proj_list:
    owner= project[0]
    repo=project[1]
    filename=repo+'.txt'
    users_done = []
    if (os.path.isfile(filename)):
        users_done=retrieve_OK(filename)
    list_users = list_unmerged (owner, repo, users_done)
    list_PRs = []
    print "foram encontrados " + str(len(list_users)) + " usuarios potenciais"
    target = open(filename, 'a+')
    for user in list_users:
        time.sleep(3)
        item = get_PRs(owner, repo, user)
        if (len(item) > 0):
            list_PRs.append(item)
            target.write (str(item[0]) + ';' + str(item[1]) + ';')
            pr_csv = ''
            for pr in item[2]:
                pr_csv = str(pr_csv) + str(pr) + ';'
            target.write (pr_csv[:-1] + '\n')
    target.close()
    print "foram confirmados " + str(len(list_users)) + " que nao conseguiram ter o PR aceito"
    #except Exception as e:
        #print e
        #pass








        

