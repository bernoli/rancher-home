This is how I run a Rancher server on a VM in azure

1. Install docker and certbot-auto

2. Map a public IP to the DNS name

3. Open port 80/443

4. Get Let's Encrypt certs

```
$ sudo certbot-auto certonly --standalone -d dash.qubernetes.com  -d dash.qubernetes.com
```

5. Rename cert

```
sudo cp /etc/letsencrypt/archive/dash.qubernetes.com/fullchain.pem /etc/letsencrypt/archive/dash.qubernetes.com/cert.pem
```

6. Start rancher with docker compose

```
docker-compose up -d
```

7. Update rancher by bumping the docker image version in the compose file and:

```
docker-compose down ; docker-compose up -d
```

8. Make sure you backup `/root/rancher/data` or mount it off an Azure File for example.
