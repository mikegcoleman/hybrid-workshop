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

Now that we've build our cluster, let's deploy a couple of web apps. These are simple web pages that allow you to send a tweet. One is built on Linux using NGINX and the other is build on Windows Server 2016 using IIS.  

We're going to clone the workshop repo onto each machine, and then build a the webapp for each operating system.

Let's start on the Linux node.

# Deploy the Linux version of our Tweet web application

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

Next use `docker build` to build your Linux tweet web app Docker image.

> **Note**: Be sure to user your own Docker ID when you build the image.

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
$ docker service create \
   --detach=true \
   -p 8080:80 \
   --name linux_tweet_app \
   --constraint 'node.platform.os == linux' \
   mikegcoleman/linux_tweet_app
sbkz4dl6slrd6xl7e6rp1qlt2
```
Let's look at each part of that command:

- `docker service create`: Creates a new service based on the supplied image (<your docker id>/linux_tweet_app)

- `--detach=true`: Runs our service in the background

- `-p 8080:80`: Instructs Docker to route any requests coming in on port 8080 to our
service running on port 80.

- `--name linux_tweet_app`: Applies a name to our service (if this is omitted Docker will choose one at random)

- `--constraint 'node.platform.os == linux'`: This tell swarm to only start this serve on a Linux-based host

> **Note**: This is the label we looked at earlier when we did the `docker node inspect` command

We can use the `docker service ls` command to verify our service was created.

```
$ docker service ls
ID                  NAME                MODE                REPLICAS            IMAGE                                 PORTS
sbkz4dl6slrd        linux_tweet_app     replicated          1/1                 mikegcoleman/linux_tweet_app:latest   *:8080->80/tcp
```
And we can check the tasks in our service by running 'docker service ps'.

```
$ docker service ps linux_tweet_app
ID                  NAME                IMAGE                                 NODE                DESIRED STATE       CURRENT STATE                ERROR               PORTS
z8fbzmkd92kv        linux_tweet_app.1   mikegcoleman/linux_tweet_app:latest   lin-pdx-02          Running             Running about a minute ago
```
Finally, in your web browser navigate to `http://<your linux node dns name>:8080`

You should see your tweet application running. Feel free to send a tweet, since it's running in container your credentials are not saved.

# Deploy the Windows version of our Twitter web application

Move back to your Windows Server 2016 virtual machine, and open a PowerShell window.

Let's create a new directory, move into it and then clone the repo:

`PS C:\Users\docker> mkdir scm`

`PS C:\Users\docker> cd .\scm`

```
C:\Users\docker\scm> git clone https://github.com/mikegcoleman/hybrid-workshop.git
Cloning into 'hybrid-workshop'...
remote: Counting objects: 13, done.
remote: Compressing objects: 100% (10/10), done.
remote: Total 13 (delta 1), reused 10 (delta 1), pack-reused 0
Unpacking objects: 100% (13/13), done.
```
Now let's move into the tweet app directory, and once again use `docker build` to build a new image.

> **Note**: Be sure to use your docker id when tagging the docker image

```
PS C:\Users\docker\scm> cd .\hybrid-workshop\windows_tweet_app\


PS C:\Users\docker\scm\hybrid-workshop\windows_tweet_app\docker build -t <your docker id>/windows_tweet_app .
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
Successfully tagged <your docker id>/windows_tweet_app:latest
```
> **Note**: It will take a few minutes for your image to build

Let's change back to our home directory and log into Docker Hub so we can push your image up to your repository.

```
PS C:\Users\docker\scm\hybrid-workshop\windows_tweet_app> cd ~

PS C:\Users\docker> docker login
Login with your Docker ID to push and pull images from Docker Hub. If you don't have a Docker ID, head over to https://hub.docker.com to create one.
Username: <your docker id>
Password:
Login Succeeded
```
Once we are logged in we can push your new image up to Docker Hub.

```
PS C:\Users\docker> docker push <your docker id>/windows_tweet_app
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

We're going to run your application as a service on our swarm cluster. Because of this we need to issue the `docker service create` command from your manager node. With swarm, any work with the swarm needs to be done from a manager node.

> **Note**: If you want to see what happens when you try to issue swarm commands from a worker simply issue the 'docker node ls' command from your Windows Server 2016 vm. You should see an error indicating that the command can only be run from a manager node.

Head back over to your Linux VM (which is our swarm manager) and deploy our Windows tweet app.

```
$ docker service create \
   --name windows_tweet_app \
   --publish mode=host,target=80,published=8081 \
   --detach=true \
   --name windows_tweet_app \
   --constraint 'node.platform.os == windows' \
   mikegcoleman/windows_tweet_app
```
> **Note**: In this case we set the constraint to 'node.platform.os == windows' to ensure the service is only started on a Windows-based host.

> **Note**: You'll notice the format for publishing the network ports are different with our Windows application. That's because that this time Windows does not support the integrated ingress load balancing, and we need to expost the ports in "host mode". See the Docker documentation for more information on host mode.  

Use `docker service ls` to see if your service is running:

```
ID                  NAME                MODE                REPLICAS            IMAGE                                   PORTS
2cax4875jqnp        linux_tweet_app     replicated          1/1                 mikegcoleman/linux_tweet_app:latest     *:8080->80/tcp
mo1y1hz592jo        windows_tweet_app   replicated          1/1                 mikegcoleman/windows_tweet_app:latest
```

>**Note**: It may take a minute for the service to start. Until it does you will see `0/1` under `REPLICAS`

You can verify the task started on your Windows node by issuing the `docker service ps` command and checking that your Windows host is listed under `NODE`

```
$ docker service ps windows_tweet_app
ID                  NAME                  IMAGE                                   NODE                DESIRED STATE       CURRENT STATE            ERROR               PORTS
iw4pj3pb1b2g        windows_tweet_app.1   mikegcoleman/windows_tweet_app:latest   win-pdx-20          Running             Started 2 seconds ago
```

Finally, let's visit the web app by pointing our web browser to `http:<windows vm dns name:8081`

> **Note**: Be sure to specify port *8081*

##  Deploying a multi-service hybrid application

For our last exercise we'll use a docker compose file to deploy an application that uses a Java front end designed to be deployed on Linux, with a Microsoft SQL Server back end running on windows.

Change into the `hybrid-workshop` directory

`$ cd ~/hybrid-workshop`

Let's look at the Docker Compose file:

```
version: "3.2"

services:

  database:
    image: sixeyed/atsea-db:mssql
    ports:
      - mode: host
        target: 1433
        published: 1433
    networks:
     - atsea
    deploy:
      endpoint_mode: dnsrr
      placement:
        constraints:
          - 'node.platform.os == windows'

  appserver:
    image: sixeyed/atsea-app:mssql
    ports:
      - mode: host
        target: 8080
        published: 80
    networks:
      - atsea
    deploy:
      endpoint_mode: dnsrr
      placement:
        constraints:
          - 'node.platform.os == linux'

networks:
  atsea:
```

There are two services. `appserver` is our web frontend written in Java, and `database` is our Microsoft SQL Server database. The rest of the commands should look familiar as they are very close to what we used when we deployed our tweet services manually.

One thing that is new is the creation of an overlay network (`atsea`). Overlay networks allow containers running on different hosts to communicate over a private software-defined network. In this case, the web frontend on our Linux host will use the `atsea` network to communicate with the database.

You may have used Docker Compose before to deploy multi-service applications, but with swarm we use a slightly different command: `docker stack`.

To deploy a new stack we use `docker stack create` and supply a link to our Docker Compose file as well as a name for our service (`atsea` in this case)

```
$ docker stack deploy -c docker-compose.yaml atsea
Creating network atsea_atsea
Creating service atsea_database
Creating service atsea_appserver
```

The output shows the creation of the two services, and our network.

Using `docker stack ps` will show the state of our services

```
$ docker stack ps atsea
ID                  NAME                IMAGE                     NODE                DESIRED STATE       CURRENT STATE           ERROR               PORTS
dflu6i3po6ur        atsea_appserver.1   sixeyed/atsea-app:mssql   lin-pdx-21          Running             Running 7 minutes ago                       *:80->8080/tcp
wgaf4vxptafj        atsea_database.1    sixeyed/atsea-db:mssql    win-pdx-21          Running             Running 6 minutes ago                       *:1433->1433/tcp
```

You can see from the output above the two services were deployed to the two different hosts, and are now up and Running

> **Note**: It can take a few minutes for all services to start. Just keep running the `docker stack ps` command until you see both services with a `DESIRED STATE` of `Running`

To see our running web site (an art store) visit `http://<your linux dns name>`.

This concludes our workshop, thanks for attending. 
