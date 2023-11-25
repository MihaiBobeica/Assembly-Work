# Assembly-Work
This repository has some of the projects in x64 Assembly which I've implemented for the Computer Organization course offered by TUDelft during my Bachelor of Computer Science and Engineering.

## WSL: Windows Subsystem for Linux
$\textit{Supported systems: Windows 10 and 11}$

Windows includes the option to install and run Linux inside of Windows. It is simple to install and set up. Follow the instructions from the part under [“Install WSL command”](https://docs.microsoft.com/en-us/windows/wsl/install). If any issues occur, you can follow the instructions from the [Microsoft install menu](https://docs.microsoft.com/en-us/windows/wsl/install-manual). When instructed, install the “Ubuntu” app from the store (the one without version number).

You can now launch Ubuntu from your start menu. The first time you will be asked to set a username and password for your Linux account (be sure to remember these or write them down). Finally, run the following command to install the necessary build tools:

apt update && apt upgrade -y && apt install build-essential gdb -y

For more instructions and troubleshooting, see [this](https://docs.microsoft.com/en-us/windows/wsl/troubleshooting).

## Running a file in Visual Studio COde
Visual Studio Code has an extension for easy integration with WSL. You can find it [here](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-wsl). In Visual Studio code, install GNU Assembler Language Support as follows:
1. Launch VS Code Quick Open (Ctrl + P)
2. Paste ext install basdp.language-gas-x86
3. Press enter
Save your files with the .s extension and VS Code will automatically enable the syntax highlighting

To open a file, you first need to open it. f your files are at C:\Users\Student\Documents\CO\Lab, you should use the following command to navigate to it in WSL (case sensitive!):

cd /mnt/c/Users/Student/Documents/CO/Lab


Once in the right folder, we can compile the file using the following command:

gcc -no-pie -o nameofyourprogram nameofyoursource.s

To run the code, we then type the following command:

./nameofyourprogram




