# hybrid-workshop

On your linux machine:

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
