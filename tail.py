import argparse
import re
#import pprint
from sh import tail
from signal import signal, SIGINT
from sys import exit
#from columnar import columnar
import time
import pandas as pd 


parser = argparse.ArgumentParser(description="""
This tails a log file containing key=value pairs and sends output as columns
Usage:
python tail.py $SPLUNK_HOME/var/log/splunk/metrics.log --search ".+queue.+(name=.*)"
""")
parser.add_argument("file", help="Full path of file to tail")
parser.add_argument("--search",  help="Search string ")
args = parser.parse_args()

#TEXT = args.file
start = time.time() #start time
end = time.time()
# runs forever
list_dict=[]
for line in tail("-f", args.file, _iter=True):
    end = time.time()
    #print(line)
    dict_out={}
    if args.search is not None:
        timestamp=re.search("^([\d\-\s:]+)" , line)
        #print(timestamp.group(1))
        test = re.search(args.search , line)
        #print(line)
        if test is not None:
            elapsed=end-start
            start = time.time() #start time
            
            
            if elapsed>1:
                #print("Elapsed time is  {}".format(elapsed))
                df = pd.DataFrame(list_dict) 
                print(df)
                print("-"*120)
                print("\n\n")
                list_dict=[]
            else:
                line_string="time="+str(timestamp.group(1))+","+str(test.group(1))
                #print(line_string)

                dict_out=dict(re.findall(r'([^\s,]+)=([^,]+)', line_string))
                list_dict.append(dict_out)

            #print(test.group(1))
            #dict_out=dict(re.findall(r'(\S+)=(".*?"|\S+)', test.group(1)))
            #dict_out=dict(re.findall(r'(\S+)=([^,\s]+)', test.group(1)))
            #pp = pprint.PrettyPrinter(indent=4,compact=True,width=100)
            #pp.pprint(dict_out)
            #l1 = list(dict_out.items())
            #print(l1)
            #table = columnar(l1,headers=None, no_borders=True)
            #print(table)


