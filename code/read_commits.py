import os, random, sys, glob

path = os.path.dirname(os.path.abspath(__file__))
wpath = os.getcwd()

rows = []

langs = ["C", "C++", "Clojure", "CoffeeScript", "Erlang", "Go", "Haskell", "Java", "JavaScript", "Objective-C", "Perl", "PHP", "Python", "Ruby", "Scala", "TypeScript"]
#langs = ["CoffeeScript"]

def pre_process():
  head = "lang,organization,project,commiter,email,sha,files,adds,dels,date"
  rows.insert(0, head)

  for lang in langs:
    projects = glob.glob(path + "/" + lang + "/*_ccs.csv")

    for project in projects:
      project_name = os.path.basename(project).split("_ccs.csv")[0]

      with open(project, "r") as source:
        current_path = lang+"/"+project_name
        print current_path
        file = open(current_path+"_shas.txt","w") 
 
        for line in source:
          if (line[0] != ' '):
            try:
              commit = line.split(",")
              sha = commit[0]
              file.write(sha)
              file.write("\n")
            except Exception as e:
              print ("error")
              print e
              print project
              sys.exit(0)
        file.close()


pre_process()

