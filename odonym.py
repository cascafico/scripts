import os
import time
import datetime
import telepot
import subprocess


def handle(msg):
    chat_id = msg['chat']['id']
    odonym = msg['text']

    print 'Got odonym: %s' % odonym
    now=datetime.datetime.now()
    csvname = "/tmp/" + odonym.replace(" ", "") + ".csv"

    query = "cat /home/pi/git/scripts/latestrelease/???_names.csv | grep \"" + odonym + "\" > " + csvname                    
    addheader = "sed -i '1 i\odonym,lat,lon' " + csvname

    print 'Built command: %s' % query
    bot.sendMessage(chat_id, "Fetching {} from italian highway names...".format(odonym))
    os.system(query)
    matches = subprocess.check_output("wc -l {} | cut -d\" \" -f1".format(csvname), shell=True)
    bot.sendMessage(chat_id, "Found {}".format(matches))
    os.system(addheader)
    bot.sendDocument(chat_id, document=open(csvname, 'rb'))
#   curl -T my-local-file.txt ftp://ftp.example.com --user user:secret

bot = telepot.Bot('place your token here')
bot.message_loop(handle)
print 'I am listening ...'

while 1:
    time.sleep(4)
