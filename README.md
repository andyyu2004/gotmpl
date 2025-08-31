# Go template

```bash
echo 'clusters/{{get . "dirOverride" | default .cluster}}/values/redis.yaml' | go run . -- cluster=test
```
