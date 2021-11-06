# SHRI homework. Infrastructure

## Bash
- chmod u+x release.sh
- you need to install jq `brew install jq`
- для запуска с секретами локально нужно создать файл `.env.local` по примеру `.env.local.example`
  и грепнуть их в скриптах
  ```bash
  OAuth=$(grep OAuth .env.local | cut -d '=' -f2)
  OrgId=$(grep OrgId .env.local | cut -d '=' -f2)
  ```

## Docker
You can build your container with 
```bash
docker build . -t shrihwinfrastructure
```
and run it with
```bash
docker run -p 3000:3000 shrihwinfrastructure
```

## Github Actions
### test.yml
  Запуск тестов без запуска дополнительных скриптов
### release.yml
  1. 📦 Install jq
    добавляем пакет jq для возможности вытаскивать ключи из json-ов в ответах
  2. 🎟️ Create ticket
    выполняем скрипт ./github/workflows/scripts/release.sh
  3. 📦 Install packages
    Устанавливаем пакеты с оптимизированными настройками
  4. 🧪 Run tests
    Запускаем тесты
### publish.yml
Сборка docker-образа и доставка до registry в Yandex.Cloud
1. Берем action https://github.com/yc-actions/yc-cr-login
2. Добавляем свои ключи в yc-sa-json-credentials
```bash
# инициализация аккаунта
# для полноценной настройки нужно создать пробный аккаунт
yc init
# необходимо создать сервисный аккаунт (см. документацию)
yc iam key create --service-account-name default-sa -o key.json
# получение реестра: crp00000000000000000
yc container registry create --name my-registry
```
см. https://nikolaymatrosov.medium.com/github-action-%D0%B4%D0%BB%D1%8F-%D0%BF%D1%83%D1%88%D0%B0-%D0%B2-yandex-cloud-container-registry-cbe91d8b0198

