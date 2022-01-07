#!/bin/bash
# setup: create the message1.txt and message2.txt files
/bin/rm -f message[12].txt
echo "Two things are infinite: the universe and human stupidity;" > message1.txt
echo "and I'm not sure about the the universe." >> message1.txt
echo "by Albert Einstein" >> message1.txt
echo "The quick brown fox jumped over the lazy dog." > message2.txt
echo 1: create keys alice-public.key and alice-private.key
java RSA -key alice -keygen 200
echo 2: create keys bob-public.key and bob-private.key
java RSA -key bob -keygen 200
echo 3: alice is going to encrypt a message for bob
java RSA -key bob -input message1.txt -output encrypted1.txt -encrypt
echo 4: bob will decrypt the message
java RSA -key bob -input encrypted1.txt -output message1b.txt -decrypt
echo 5: are they the same?
diff message1.txt message1b.txt
echo 6: bob now sends a message to alice
java RSA -key alice -input message2.txt -output encrypted2.txt -encrypt
echo 7: alice will decrypt the message
java RSA -key alice -input encrypted2.txt -output message2b.txt -decrypt
echo 8: are they the same?
diff message2.txt message2b.txt
echo 9: alice signs her message1.txt
java RSA -key alice -input message1.txt -sign
echo 10: bob checks that sign; they should match
java RSA -key alice -input message1.txt -checksign
echo 11: modify message1.txt
/bin/mv -f message1.txt message1.txt.bak
echo hi >> message1.txt
echo 12: bob checks that sign; they should NOT match
java RSA -key alice -input message1.txt -checksign
echo 13: restore message1.txt
/bin/mv -f message1.txt.bak message1.txt
java RSA -key alice -input message1.txt -checksign
echo 14: charlie generates an easy-to-crack key
java RSA -key charlie -keygen 10
# eve tries to crack alice's key
echo eve tries to crack alices key
java RSA -key charlie -crack
echo 15: is the cracked key the same as the original key?
diff charlie-cracked-private.key charlie-private.key
# 16: clean up files (commented out by default)
# /bin/rm -f alice*.key bob*.key charlie*.key message*.sign message?b.txt encrypted?.txt message?.txt
