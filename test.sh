#!/user/bin/bash

#This will compile all the files with extension .java
javac -cp /mnt/c/Users/sharm/Documents/a1788080/2021/s2/ds/ds-21-s2-assignment2/xstream-1.4.17.jar:/mnt/c/Users/sharm/Documents/a1788080/2021/s2/ds/ds-21-s2-assignment2/ *.java
sleep 3

#TESTCASE1:  Test case 1 checks if the xml parsing is correct or not it runs the contentserver file and in argument it says testcase_1, due to this content server runs the code that I have written to check if xml parsing is working or not
#It stores the output in file called output_testcase_1.txt and I have already made a file called expected_output_testcase_1

java -cp /mnt/c/Users/sharm/Documents/a1788080/2021/s2/ds/ds-21-s2-assignment2/xstream-1.4.17.jar:/mnt/c/Users/sharm/Documents/a1788080/2021/s2/ds/ds-21-s2-assignment2/ ContentServer localhost:4567 content_1.txt testcase_1 > output_testcase_1.txt

#We compare both files to see if there is any difference
diff expected_output_testcase_1.txt output_testcase_1.txt > difference_1.txt
#If there is any difference the test case didn't pass
if [ $? -eq 0 ]; 
then
    echo "Test case 1 passed"
else
	echo "Test case 1 didn't pass"
fi

#TESTCASE2
#This test case checks if the Aggregation server is responding with the right error code if there is any problem with the put request
java -cp /mnt/c/Users/sharm/Documents/a1788080/2021/s2/ds/ds-21-s2-assignment2/xstream-1.4.17.jar:/mnt/c/Users/sharm/Documents/a1788080/2021/s2/ds/ds-21-s2-assignment2/ AggregationServer &
export AggregationServer=$! #Stores the id of the server to kill it afterwards
sleep 3
# testcase_2 is passed as an argument during running the content server so that it knows we are testing
java -cp /mnt/c/Users/sharm/Documents/a1788080/2021/s2/ds/ds-21-s2-assignment2/xstream-1.4.17.jar:/mnt/c/Users/sharm/Documents/a1788080/2021/s2/ds/ds-21-s2-assignment2/ ContentServer localhost:4567 content_1.txt testcase_2 > output_testcase_2.txt
sleep 3
#We compare both files to see if there is any difference
diff expected_output_testcase_2.txt output_testcase_2.txt > difference_2.txt
#If there is any difference the test case didn't pass
if [ $? -eq 0 ]; 
then
    echo "Test case 2 passed"
else
	echo "Test case 2 didn't pass"
fi

#TESTCASE3
# This testcase is to check if everything works perfectly, two put requests are send to AS and then client requests a get request to see if it is the right result
java -cp /mnt/c/Users/sharm/Documents/a1788080/2021/s2/ds/ds-21-s2-assignment2/xstream-1.4.17.jar:/mnt/c/Users/sharm/Documents/a1788080/2021/s2/ds/ds-21-s2-assignment2/ ContentServer localhost:4567 content_1.txt &
export content_server_1=$! #saving the id of the process
sleep 3
java -cp /mnt/c/Users/sharm/Documents/a1788080/2021/s2/ds/ds-21-s2-assignment2/xstream-1.4.17.jar:/mnt/c/Users/sharm/Documents/a1788080/2021/s2/ds/ds-21-s2-assignment2/ ContentServer localhost:4567 content_2.txt &
export content_server_2=$!#saving the id of the process
sleep 3
java -cp /mnt/c/Users/sharm/Documents/a1788080/2021/s2/ds/ds-21-s2-assignment2/xstream-1.4.17.jar:/mnt/c/Users/sharm/Documents/a1788080/2021/s2/ds/ds-21-s2-assignment2/ GETClient localhost:4567 > output_testcase_3.txt

#We compare both files to see if there is any difference
diff expected_output_testcase_3.txt output_testcase_3.txt > difference_3.txt

#If there is any difference the test case didn't pass
if [ $? -eq 0 ]; 
then
    echo "Test case 3 passed"
else
	echo "Test case 3 didn't pass"
fi

#TESTCASE4
# This test case checks if the heartbeat is working correctly, we kill the second content server and check if the content of the server is deleted or not

kill $content_server_2 #killing the content server

sleep 12 #sleeping 12 seconds to check if the content is removed

#running the client again
java -cp /mnt/c/Users/sharm/Documents/a1788080/2021/s2/ds/ds-21-s2-assignment2/xstream-1.4.17.jar:/mnt/c/Users/sharm/Documents/a1788080/2021/s2/ds/ds-21-s2-assignment2/ GETClient localhost:4567 > output_testcase_4.txt
#We compare both files to see if there is any difference
diff expected_output_testcase_4.txt output_testcase_4.txt > difference_4.txt
#If there is any difference the test case didn't pass
if [ $? -eq 0 ]; 
then
    echo "Test case 4 passed"
else
	echo "Test case 4 didn't pass"
fi

#TESTCASE5
#This test case checks if Aggregation server restore files and content server retry on errors

#killing the server to see if it restore files
kill $AggregationServer
#In terminal you should be able to see that content server is trying 3 times before giving up
sleep 3
#starting the server again
java -cp /mnt/c/Users/sharm/Documents/a1788080/2021/s2/ds/ds-21-s2-assignment2/xstream-1.4.17.jar:/mnt/c/Users/sharm/Documents/a1788080/2021/s2/ds/ds-21-s2-assignment2/ AggregationServer &
export AggregationServer2=$!
sleep 3
#sSending get request to check if the content is still available
java -cp /mnt/c/Users/sharm/Documents/a1788080/2021/s2/ds/ds-21-s2-assignment2/xstream-1.4.17.jar:/mnt/c/Users/sharm/Documents/a1788080/2021/s2/ds/ds-21-s2-assignment2/ GETClient localhost:4567 > output_testcase_5.txt
sleep 3
#We compare both files to see if there is any difference
diff expected_output_testcase_5.txt output_testcase_5.txt > difference_5.txt
#If there is any difference the test case didn't pass
if [ $? -eq 0 ]; 
then
    echo "Test case 5 passed"
else
	echo "Test case 5 didn't pass"
fi

#TESTCASE6
# This test case checks Synchronization and if content server are fault taulrent, since we stopped content server in the last test case we will run it again to see if it is fault tolerant
# If synchronization works that is we will do one put then a get then another put. Get should only have content of first put
java -cp /mnt/c/Users/sharm/Documents/a1788080/2021/s2/ds/ds-21-s2-assignment2/xstream-1.4.17.jar:/mnt/c/Users/sharm/Documents/a1788080/2021/s2/ds/ds-21-s2-assignment2/ ContentServer localhost:4567 content_1.txt &
sleep 3
java -cp /mnt/c/Users/sharm/Documents/a1788080/2021/s2/ds/ds-21-s2-assignment2/xstream-1.4.17.jar:/mnt/c/Users/sharm/Documents/a1788080/2021/s2/ds/ds-21-s2-assignment2/ GETClient localhost:4567 > output_testcase_6.txt
sleep 3
java -cp /mnt/c/Users/sharm/Documents/a1788080/2021/s2/ds/ds-21-s2-assignment2/xstream-1.4.17.jar:/mnt/c/Users/sharm/Documents/a1788080/2021/s2/ds/ds-21-s2-assignment2/ ContentServer localhost:4567 content_2.txt &
sleep 3
#We compare both files to see if there is any difference
diff expected_output_testcase_6.txt output_testcase_6.txt > difference_6.txt
#If there is any difference the test case didn't pass
if [ $? -eq 0 ]; 
then
    echo "Test case 6 passed"
else
	echo "Test case 6 didn't pass"
fi

#TESTCASE7
#This is to check if multiple get client can connect to AS. we do two get request and compare their results

java -cp /mnt/c/Users/sharm/Documents/a1788080/2021/s2/ds/ds-21-s2-assignment2/xstream-1.4.17.jar:/mnt/c/Users/sharm/Documents/a1788080/2021/s2/ds/ds-21-s2-assignment2/ GETClient localhost:4567 > output_testcase_7.txt
sleep 3
java -cp /mnt/c/Users/sharm/Documents/a1788080/2021/s2/ds/ds-21-s2-assignment2/xstream-1.4.17.jar:/mnt/c/Users/sharm/Documents/a1788080/2021/s2/ds/ds-21-s2-assignment2/ GETClient localhost:4567 > output_testcase_7_2.txt
sleep 3

#We compare both files to see if there is any difference
diff output_testcase_7_2.txt output_testcase_7.txt > expected_output_testcase_7.txt
diff output_testcase_7_2.txt output_testcase_7.txt > difference_7.txt

#If there is any difference the test case didn't pass
if [ $? -eq 0 ]; 
then
    echo "Test case 7 passed"
else
	echo "Test case 7 didn't pass"
fi

#Testcase8
#This test case is to check if lamport clocks are working

#While running the getclient test case 8 is passed to let the get client know that we are testing so that it can output the values of lamport clock
java -cp /mnt/c/Users/sharm/Documents/a1788080/2021/s2/ds/ds-21-s2-assignment2/xstream-1.4.17.jar:/mnt/c/Users/sharm/Documents/a1788080/2021/s2/ds/ds-21-s2-assignment2/ GETClient localhost:4567 testcase_8 > output_testcase_8.txt
sleep 3
#We compare both files to see if there is any difference
diff expected_output_testcase_8.txt output_testcase_8.txt > difference_8.txt
#If there is any difference the test case didn't pass
if [ $? -eq 0 ]; 
then
    echo "Test case 8 passed"
else
	echo "Test case 8 didn't pass"
fi



