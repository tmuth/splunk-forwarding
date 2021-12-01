import socket
import sys
import argparse
from faker import Faker
fake = Faker()
from datetime import datetime
my_date = datetime.now()
print(my_date.isoformat())

parser = argparse.ArgumentParser(description="""
This script sends data over TCP
""")
parser.add_argument("--text", default="faker", help="Text to send over TCP. If null uses fake.first_name()")
parser.add_argument("--loops", type=int, default=1, help="Number of times to send the text. (default: %(default)s)")
#parser.add_argument("--address", help="Address of Employee")

args = parser.parse_args()

TEXT = args.text
LOOPS = args.loops


HOST, PORT = "localhost", 5001
#data = " ".join(sys.argv[1:])
data = TEXT

# Create a socket (SOCK_STREAM means a TCP socket)
with socket.socket(socket.AF_INET, socket.SOCK_STREAM) as sock:
    # Connect to server and send data
    sock.connect((HOST, PORT))
    x=0
    while x<LOOPS:
      if TEXT=="faker":
        data=fake.first_name()

      my_date = datetime.now()
      #print(my_date.isoformat())
      data=my_date.isoformat()+","+data
      sock.sendall(bytes(data + "\n", "utf-8"))
      x+=1
      print("Sent:     {}".format(data))


    # Receive data from the server and shut down
    #received = str(sock.recv(1024), "utf-8")

#print("Sent:     {}".format(data))
#print("Received: {}".format(received))