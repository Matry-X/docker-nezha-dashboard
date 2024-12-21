# docker-nezha-dashboard
nezha dashboard 1.* + local nezha agent + cloudflare tunnel

**still on testing**

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
