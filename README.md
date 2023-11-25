# Assembly-Work
This repository has some of the projects in x64 Assembly which I've implemented for the Computer Organization course offered by TUDelft during my Bachelor of Computer Science and Engineering.

## WSL: Windows Subsystem for Linux
$\textit{Supported systems: Windows 10 and 11}$

Windows includes the option to install and run Linux inside of Windows. It is simple to install and set up. Follow the instructions from the part under [“Install WSL command”](https://docs.microsoft.com/en-us/windows/wsl/install). If any issues occur, you can follow the instructions from the [Microsoft install menu](https://docs.microsoft.com/en-us/windows/wsl/install-manual). When instructed, install the “Ubuntu” app from the store (the one without version number).

You can now launch Ubuntu from your start menu. The first time you will be asked to set a username and password for your Linux account (be sure to remember these or write them down). Finally, run the following command to install the necessary build tools:

apt update && apt upgrade -y && apt install build-essential gdb -y

For more instructions and troubleshooting, see [this](https://docs.microsoft.com/en-us/windows/wsl/troubleshooting).
