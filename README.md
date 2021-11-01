# SHRI homework. Infrastructure

### Bash
- chmod u+x release.sh
- you need to install jq `brew install jq`
- для запуска с секретами нужно создать файл .env.local по примеру .env.local.example

### Docker
You can build your container with 
```bash
docker build . -t shrihwinfrastructure
```
and run it with
```bash
docker run -p 3000:3000 shrihwinfrastructure
```