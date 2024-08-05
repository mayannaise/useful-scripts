# Description: plist Reader utility
# Written by:  Owen Jeffreys
# Date:        32 July 2020
# OS:          Ubuntu 18
# Python:      Version 3.6.9
#
# Utility to read Apple's plist (property list) message list from iPhone backup
# Converts XML plist to CSV
# To convert binary plist file, first convert from binary to XML using
# `plistutil -i Messages.plist`

import xml.etree.ElementTree as ET
tree = ET.parse('messages.plist')

got_message = False
got_phone_number = False

my_messages = {}
current_phone_number = 0

for elem in tree.iter():
    if str(elem.tag) == 'key' and str(elem.text) == 'Number':     # Phone Number
        got_phone_number = True
    elif str(elem.tag) == 'key' and str(elem.text) == 'Content':  # SMS Content
        got_message = True


    if str(elem.tag) == 'string':
        if got_message:
            print (current_phone_number + '\t' + elem.text.replace('\n','. '))
            got_message = False
            if current_phone_number not in my_messages:
                my_messages[current_phone_number] = [elem.text]
            else:
                my_messages[current_phone_number].append(elem.text)

        elif got_phone_number:
            current_phone_number = elem.text
            got_phone_number = False

# for phone_number in my_messages:
#     print (phone_number + '\t', end='')
#     for msg in my_messages[phone_number]:
#         print (msg.replace('\n','. '), end='')
#     print ('')
