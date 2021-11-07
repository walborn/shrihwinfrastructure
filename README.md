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


# Запуск на виртуальной машине
https://cloud.yandex.ru/docs/container-registry/solutions/run-docker-on-vm
1. Добавляем сервисному аккаунту роль container-registry.images.puller
  - я добавил все роли своему аккаунту codebor@yandex.ru
2. Создаем виртуальную машину
  - я создал ubuntu
3. Зашел на свою ВМ
```bash
echo <oauth-токен> | docker login --username oauth --password-stdin cr.yandex
ssh codebor@51.250.4.110
```
4. Поставил там докер `sudo apt install docker.io`
5. Выполнил команду
```bash
curl -H Metadata-Flavor:Google 169.254.169.254/computeMetadata/v1/instance/service-accounts/default/token | cut -f1 -d',' | cut -f2 -d':' | tr -d '"' | sudo docker login --username iam --password-stdin cr.yandex
```
6. Закачал и установил свой контейнер из облака
```bash
sudo docker pull cr.yandex/crp8ambq9gr5dlh9u0sd/shrihwinfrastructure:17985340de0cb95f70dbfc9397cec6d08aa0323fc
sudo docker run -d -p 80:3000 cr.yandex/crp8ambq9gr5dlh9u0sd/shrihwinfrastructure:17985340de0cb95f70dbfc9397cec6d08aa0323fc
```
7. Теперь можно зайти в приложение так http://51.250.4.110/
  