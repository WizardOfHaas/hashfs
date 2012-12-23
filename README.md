hashfs
===

<<<<<<< HEAD
Hash based file system for fast storage of data.
This version of Dreckig OS has all sorts of new features.
Now it has users and groups and file privledges.
To login as a privledged user use username: root password: root.
User:sean password: sean is an underprivledged user.
=======


This is a vastly more advanced version of Dreckig OS. First off, it uses my experimental hashfs file system. 
It is integrated so it functions just like normal Dreckig OS on the surface as far as files, but is running on new 
drivers. Hashfs is faster and simpler than the FAT12/bFS in standard Dreckig OS, so that opened up quite a few more 
possibilities for me.

First off, user accounts, when it boots a prompt for user name/password is given,(root root for root).
The root account is in user group 0, sean in user group 1 and guest in user group 2. 
Group 0 has access to every command and file, groups above 0 have restricted command access and restricted file access. 
Their file names are abstracted so that if someone in group 1 accesses the file "file" it would really be "1file", 
group 0 has this abstraction removed. The user command (only for group 0) lets you manage users, list lists users 
and data, add makes a new user, and kill removes a user. Also, when you log in it will run the file "run",
or if you are in group 1 "1run" and so on. It is in lang.

Next we have the MVM architecture and the brainfuck compiler. 
MVM is the multiple virtual machine architecture, I developed it for Dreckig OS, and then ported it to this branch. 
It virtualizes a novel 8-bit ISA with synchronization primitives built in. 
The brainfuck compiler compiles brainfuck code to byte-code that is ran on MVM.
To run brainfuck code just type it on the command line. Or to run a file full of the code just use the bf command,
it then prompts for the file, or you can use the bf command in lang: bf filename.
>>>>>>> d9d3fb5b260f7713235d527fb729eab2350fa72f
