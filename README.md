# Java_PRNG
Helper code to find and confirm the Java PRNG seed used for passwords.

These should work with basic Java and Ruby.  I've tried to use simple
constructs which could lend themselves to be moved into another program.
I've also avoided trying to make the programs too terse and opting for
readability over saving a few characters.

This uses Sergey Soldatov’s JavaCG to do the work under the covers:
https://github.com/votadlos/JavaCG

To get his code to compile on Kali, I had to create a Releases directory
and change the location of the g++ compiler that was in the provided
Makefile.

