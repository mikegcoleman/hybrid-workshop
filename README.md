# hybrid-workshop

## Build Our Hybrid Swarm

SSH into your Linux node (it should be <location>-lin-#). Your DNS name, username and password will be on the paper you received earlier.

```
ssh docker@<location-lin-#>.westus2.cloudapp.azure.com)
```
Create your swarm by issuing the `docker swarm init` command. This command will create a swarm cluster, and add the current node as a manager.

```
$ docker swarm init
Swarm initialized: current node (z42u37g25lrmcgbpyef9fd06r) is now a manager.

To add a worker to this swarm, run the following command:

    docker swarm join \
    --token SWMTKN-1-4qm2iur0lkqjmmxlfivyj7rdn9nsso216vaxybhojgmbwa3su7-3vzae67xszr1yphz6flr9emff \
    10.0.2.32:2377

To add a manager to this swarm, run 'docker swarm join-token manager' and follow the instructions.
```

Copy the join command and paste it into a text editor, then remove the '\' and make the command a single line (this is because Windows does not know how to handle the linux-style `\`)

It should end up looking something like this:

```
docker swarm join --token SWMTKN-1-4qm2iur0lkqjmmxlfivyj7rdn9nsso216vaxybhojgmbwa3su7-3vzae67xszr1yphz6flr9emff 10.0.2.32:2377
```
Use your RDP client to connect into your Windows node (the address should be similar to `<location>-win-#.westus2.cloudapp.azure.com` your username and password are on the paper you received earlier)

Once connected to your Windows Server 2016 VM open a Powershell window by clicking the `Start` button (which looks like a flag in the lower left corner) and then click the Windows Power Shell icon (Do NOT choose Windows Powershell ISE) near the top right.

In the Powershell window paste in your Docker swarm join command. This command will contact the swarm manager you just created and use the token supplied to join the Swarm cluster.

```
docker swarm join --token SWMTKN-1-4qm2iur0lkqjmmxlfivyj7rdn9nsso216vaxybhojgmbwa3su7-3vzae67xszr1yphz6flr9emff 10.0.2.32:2377
This node joined a swarm as a worker.
```
> **Note**: Sometimes joining the swarm will cause your RDP connection to reset, simply reconnect

Switch back to your Linux VM.

To see the nodes in your cluster issue the `docker node ls` command.

```
$ docker node ls
ID                            HOSTNAME            STATUS              AVAILABILITY        MANAGER STATUS
phud37l5prpy4bk76pfdkfofw     win-pdx-20          Ready               Active
z42u37g25lrmcgbpyef9fd06r *   lin-pdx-20          Ready               Active              Leader
```

We can verify the operating system family for each node by using docker inspect.

> **Note** The command below uses the hostnames show above, your hostnames will be different

```
$ docker node inspect win-pdx-20 | grep OS
                "OS": "windows"
$ docker node inspect lin-pdx-20 | grep OS
                "OS": "linux"
```
Let's look at the OS information in a bit more detail. Issue the `docker node inspect` command on your Linux node.

`$ docker inspect lin-pdx-20`

Scroll up in your terminal until you find the `Description` section. It should look similar to this:

```
"Description": {
            "Hostname": "lin-pdx-20",
            "Platform": {
                "Architecture": "x86_64",
                "OS": "linux"
            },
```

What we want to notice here is the hierarchy. We inspected the node, and the `OS` is listed under `Platform` so the full path for the `OS` label is `node.platform.OS`. This information will be used in a later part of the lab.

## Deploy Linux and Windows web applications

Now that we've build our cluster, let's deploy a couple of web apps.

We're going to clone the workshop repo onto each machine, and then build a simple webapp for each operating system.

Let's start on the Linux node.

Make sure you're in your home directory
`$ cd ~`

And then clone the repository.

```
$ git clone https://github.com/mikegcoleman/hybrid-workshop.git
Cloning into 'hybrid-workshop'...
remote: Counting objects: 13, done.
remote: Compressing objects: 100% (10/10), done.
remote: Total 13 (delta 1), reused 10 (delta 1), pack-reused 0
Unpacking objects: 100% (13/13), done.
Checking connectivity... done.
```
Now change into the `linux_tweet_app` directory.
`$ cd ~/hybrid-workshop/linux_tweet_app/`

Next build your Linux tweet webapp. Be sure to user your own Docker ID when you build the image.

> **Note**: Feel free to examine the Dockerfile in this directory if you'd like to see how the image is being built.

```
$ docker build -t <your docker id>/linux_tweet_app .
Sending build context to Docker daemon  4.096kB
Step 1/4 : FROM nginx:latest
latest: Pulling from library/nginx
ff3d52d8f55f: Pull complete
b05436c68d6a: Pull complete
961dd3f5d836: Pull complete
Digest: sha256:12d30ce421ad530494d588f87b2328ddc3cae666e77ea1ae5ac3a6661e52cde6
Status: Downloaded newer image for nginx:latest
 ---> 3448f27c273f
Step 2/4 : COPY index.html /usr/share/nginx/html
 ---> 72d22997a765
Removing intermediate container e262b9220942
Step 3/4 : EXPOSE 80 443
 ---> Running in 54e4ff1b39a6
 ---> 2b5bd87894cd
Removing intermediate container 54e4ff1b39a6
Step 4/4 : CMD nginx -g daemon off;
 ---> Running in 54020cdec942
 ---> ed5f550fc339
Removing intermediate container 54020cdec942
Successfully built ed5f550fc339
Successfully tagged <your docker id>/linux_tweet_app:latest
```
Next we'll log into Docker hub and push our image up there for future use.

```
$ docker login
Login with your Docker ID to push and pull images from Docker Hub. If you don't have a Docker ID, head over to https://hub.docker.com to create one.
Username: <your docker id>
Password: <your docker id password>
Login Succeeded
```
After you log in, use `docker push` to upload your image up to Docker Hub.
```
$ docker push <your docker id>/linux_tweet_app
The push refers to a repository [docker.io/<your docker id>/linux_tweet_app]
4d8d2fc9cf5a: Pushed
08e6bf75740d: Mounted from library/nginx
f12c15fc56f1: Mounted from library/nginx
8781ec54ba04: Mounted from library/nginx
latest: digest: sha256:c89bbabda050e5eba0f8ee3bf40a0c672da08107e612e58062b97988ea463277 size: 1155
```
Now let's run our application by by creating a new service.

```
$ docker service create --detach=true -p 8080:80 --name linux_tweet_app <your docker id>/linux_tweet_app:
sbkz4dl6slrd6xl7e6rp1qlt2
```
Let's look at each part of that command:
`docker service create`: Creates a new service based on the supplied image (<your docker id>/linux_tweet_app)
`--detach=true`: Runs our service in the background
`-p 8080:80`: Instructs Docker to route any requests coming in on port 8080 to our service running on port 80.
`--name linux_tweet_app`: Applies a name to our service (if this is omitted Docker will choose one at random)

Use the `docker service ls` command to verify our service was created.

```
$ docker service ls
ID                  NAME                MODE                REPLICAS            IMAGE                                 PORTS
sbkz4dl6slrd        linux_tweet_app     replicated          1/1                 mikegcoleman/linux_tweet_app:latest   *:8080->80/tcp
```
And we can check the tasks in our service by running 'docker service ps' on our service

```
$ docker service ps linux_tweet_app
ID                  NAME                IMAGE                                 NODE                DESIRED STATE       CURRENT STATE                ERROR               PORTS
z8fbzmkd92kv        linux_tweet_app.1   mikegcoleman/linux_tweet_app:latest   lin-pdx-02          Running             Running about a minute ago
```
On your windows machine, open a PowerShell window.

`mkdir scm`

`cd .\scm`

```
C:\Users\docker\scm> git clone https://github.com/mikegcoleman/hybrid-workshop.git
Cloning into 'hybrid-workshop'...
remote: Counting objects: 13, done.
remote: Compressing objects: 100% (10/10), done.
remote: Total 13 (delta 1), reused 10 (delta 1), pack-reused 0
Unpacking objects: 100% (13/13), done.
```

`cd .\hybrid-workshop\windows_tweet_app\`

```
docker build -t <your docker id>/windows_tweet_app .
PS C:\Users\docker\scm\hybrid-workshop\windows_tweet_app> docker build -t mikegcoleman/windows_tweet_app .
Sending build context to Docker daemon  6.144kB
Step 1/10 : FROM microsoft/windowsservercore
 ---> 590c0c2590e4

<output snipped>

Step 10/10 : HEALTHCHECK CMD powershell -command     try {      $response = Invoke-WebRequest http://localhost -UseBasic
Parsing;      if ($response.StatusCode -eq 200) { return 0}      else {return 1};     } catch { return 1 }
 ---> Running in ab4dfee81c7e
 ---> d74eead7f408
Removing intermediate container ab4dfee81c7e
Successfully built d74eead7f408
Successfully tagged mikegcoleman/windows_tweet_app:latest
```

`docker login`

```
docker push <your docker id>/windows_tweet_app
The push refers to a repository [docker.io/mikegcoleman/windows_tweet_app]
5d08bc106d91: Pushed
74b0331584ac: Pushed
e95704c2f7ac: Pushed
669bd07a2ae7: Pushed
d9e5b60d8a47: Pushed
8981bfcdaa9c: Pushed
25bdce4d7407: Pushed
df83d4285da0: Pushed
853ea7cd76fb: Pushed
55cc5c7b4783: Skipped foreign layer
f358be10862c: Skipped foreign layer
latest: digest: sha256:e28b556b138e3d407d75122611710d5f53f3df2d2ad4a134dcf7782eb381fa3f size: 2825
```

Head back over to your Swarm manager NODE

`docker service create --name windows_tweet_app --publish mode=host,target=80,published=8081 --detach=true --name windows_tweet_app mikegcoleman/windows_tweet_app`

`docker service ps windows_tweet_app`

```
ID                  NAME                      IMAGE                                   NODE                DESIRED STATE       CURRENT STATE             ERROR                              PORTS
198ee9s2531t        windows_tweet_app.1       mikegcoleman/windows_tweet_app:latest   win-pdx-01          Running             Starting 17 seconds ago
5wt37fio1tkx         \_ windows_tweet_app.1   mikegcoleman/windows_tweet_app:latest   lin-pdx-01          Shutdown            Rejected 26 seconds ago   "No such image: mikegcoleman/w…"
vp43xjba3e2b         \_ windows_tweet_app.1   mikegcoleman/windows_tweet_app:latest   lin-pdx-01          Shutdown            Rejected 27 seconds ago   "No such image: mikegcoleman/w…"
```
docker node ls
docker node inspect <node id for win-xxx-01>

```
docker service create \
   --name windows_tweet_app \
   --publish mode=host,target=80,published=8081 \
   --detach=true \
   --name windows_tweet_app \
   --constraint 'node.platform.os == windows' \
   mikegcoleman/windows_tweet_app
```
