# docker-nezha-dashboard
[nezha dashboard 1.*](https://github.com/nezhahq/nezha) + local [nezha agent 1.*](https://github.com/nezhahq/agent) + [cloudflare tunnel](https://github.com/cloudflare/cloudflared)

**still on testing**

## Demo

![demo]()

**NOTICE**

> ONLY support x64 platform  
> download required applications while build, NO ANY auto update  
> NO ANY backup, just manually download `sqlite.db` in `/dashboard/data`  
> I am thinking about more elegant and easy way to backup needed data  
> if you have any nice idea, please ISSUE  

## HOW TO USE

### build

```bash
git clone https://github.com/Matry-X/docker-nezha-dashboard.git
cd docker-nezha-dashboard
docker build -t your-tag .
```

### run

variables
```env
# required
ARGO_DOMAIN='test.example.com'
ARGO_TOKEN='ey****J9'
# optional
# use Bcrypt to generate, online tool link: https://bcrypt.online/
ADMIN_SECRET='$2a$10$pGBH10RM.LDvQREgrz60G.cP77QlrIbQVRCJ3ygB2pwKMUN8GiucW'
```

run in docker
```bash
docker run -d \
  -e ARGO_DOMAIN="test.example.com" \
  -e ARGO_TOKEN="ey****J9" \
  --name "Dashboard" \
  your-tag:latest
```

### cloudflare tunnel

![public hostname](https://pic.2rmz.com/1734929821974.png)

![tls & http2](https://pic.2rmz.com/1734929824944.png)

## INSPIRATION

[nezhahq/nezha](https://github.com/nezhahq/nezha)  
[nezhahq/agent](https://github.com/nezhahq/agent)  
[fscarmen2/Argo-X-Container-PaaS](https://github.com/fscarmen2/Argo-X-Container-PaaS)  
[fscarmen2/Argo-Nezha-Service-Container](https://github.com/fscarmen2/Argo-Nezha-Service-Container)
