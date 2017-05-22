# hybrid-workshop

On your Swarm manager node (should be lin-xxx-1):

```
git clone https://github.com/mikegcoleman/hybrid-workshop.git
Cloning into 'hybrid-workshop'...
remote: Counting objects: 13, done.
remote: Compressing objects: 100% (10/10), done.
remote: Total 13 (delta 1), reused 10 (delta 1), pack-reused 0
Unpacking objects: 100% (13/13), done.
Checking connectivity... done.
```

`cd hybrid-workshop/linux_tweet_app/`

`docker build -t <your docker id>/linux_tweet_app .`

```
docker login
Login with your Docker ID to push and pull images from Docker Hub. If you don't have a Docker ID, head over to https://hub.docker.com to create one.
Username: mikegcoleman
Password:
Login Succeeded
```
```
docker push <your user id>/linux_tweet_app
The push refers to a repository [docker.io/mikegcoleman/linux_tweet_app]
4d8d2fc9cf5a: Pushed
08e6bf75740d: Mounted from library/nginx
f12c15fc56f1: Mounted from library/nginx
8781ec54ba04: Mounted from library/nginx
latest: digest: sha256:c89bbabda050e5eba0f8ee3bf40a0c672da08107e612e58062b97988ea463277 size: 1155
```
```
docker service create --detach=true -p 8080:80 --name linux_tweet_app <your docker id>/linux_tweet_app
sbkz4dl6slrd6xl7e6rp1qlt2
```
```
docker service ls
ID                  NAME                MODE                REPLICAS            IMAGE                                 PORTS
sbkz4dl6slrd        linux_tweet_app     replicated          1/1                 mikegcoleman/linux_tweet_app:latest   *:8080->80/tcp
```
```
docker service ps linux_tweet_app
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
```
docker service create \
   --name windows_tweet_app \
   --publish mode=host,target=80,published=8081 \
   --detach=true \
   --name windows_tweet_app \
   --constraint 'node.platform.os == windows' \
   mikegcoleman/windows_tweet_app
```
