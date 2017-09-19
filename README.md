# Deploying Multi-OS applications with Docker EE
Docker EE 17.06 is the first Containers-as-a-Service platform to offer production-level support for the integrated management and security of Linux AND Windows Server Containers.

In this lab we'll build a Docker EE cluster comprised of Windows and Linux nodes. Then we'll deploy both a Linux and Windows web app, as well as a multi-service application that includes both Windows and Linux components.

This lab can be run two different ways:

* [**Using Virtual Machines**](https://github.com/mikegcoleman/hybrid-workshop/vm-readme.md): In this case you'll be provided 3 VMs and will use SSH and RDP to access those VMs in order to complete your lab exercises. 

	The major difference between using VMs and using Play With Docker is that in the VM-based labs you actually build the Docker EE cluster from the ground up. 

	**The instructions for the VM version of the lab can be found [here](https://github.com/mikegcoleman/hybrid-workshop/vm-readme.md)**

* [**Using Play With Docker**](https://github.com/hybrid-workshop/pwd-readme.md): Play with Docker is a web-based docker environment where you access your Docker hosts via a web browser. There is no need for SSH or RDP, and the Docker EE cluster is almost completely built (you will add a Windows node to see how that works). 

	**The instructions for the Play With Docker version of the lab can be found [here](https://github.com/hybrid-workshop/pwd-readme.md)**
	
> **Note**: If you are unsure which version of the lab you are doing, ask your instructor. 