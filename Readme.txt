As we are using external Library we simply cannot use Javac *.java to compile, we have to give the specific path of the library before.

In the bash file you can see that I am compiling using the following command

javac -cp /mnt/c/Users/sharm/Documents/a1788080/2021/s2/ds/ds-21-s2-assignment2/xstream-1.4.17.jar:/mnt/c/Users/sharm/Documents/a1788080/2021/s2/ds/ds-21-s2-assignment2/ *.java

Here /mnt/c/Users/sharm/Documents/a1788080/2021/s2/ds/ds-21-s2-assignment2/xstream-1.4.17 represent my directory where the .jar file is stored
and :/mnt/c/Users/sharm/Documents/a1788080/2021/s2/ds/ds-21-s2-assignment2/ is the same directory without the jar file to let javac know where java files are


So to run the program what we will have to do is replace both of the lines above with the directory you are working in

If you see my bash file every test case has this directory so I know its a bit of work but if you could change the directory in every single line then only my test cases would work

If you are in visual studio you can just do cltr + shift + H and search for the thing you want to change and it will change it for the entire file

Once the directory is changed all you have to do is write bash test.sh and it will compile and run all the test cases. :)

All the comment is available in the code and in the bash file, so it should be pretty intuitive to understand what each line is doing :)

