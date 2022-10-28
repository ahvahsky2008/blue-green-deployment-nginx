**Реализация Blue-Green Deployment + Nginx.**

За основу взят проект https://github.com/Sinkler/docker-nginx-blue-green

Схема выглядит следующим образом. 
![Blue-Green](https://miro.medium.com/max/828/1*aE4ALY3R8CipUZzpD2XPKQ.png)


В **Consul** храним текущий запущенный инстанс - либо **green** либо **blue**. Далее **Registrator** считывает все запущенные контейнеры, и шлёт их в **Consul**.
Чтобы nginx работал как **reverse-proxy** в его образ добавлен **consul-template** - утилита, которая позволяет менять конфигурацию **conf.d/nginx.conf** 
динамически в зависимости от того, что у нас хранится в **Consul (Key/Value - deploy/backend)**. Меняет **upstream** с **green** на **blue** и наоборот.


Как запускать:

1) `docker-compose -f docker-compose-consul.yml up -d` для запуска **Consul** and **Registrator**;
 `http://127.0.0.1:8500/` Смотришь запустилась ли админка **Consul**;
2) `./deploy.sh` для запуска текущего проекта в состояние **blue** (дефолтное состояние);
`http://127.0.0.1/` Если всё ок - **{"active service is": blue}**

3) Допустим вы внесли изменения в код и хотите бесшовно обновить его. Запускаем `./deploy.sh`
`http://127.0.0.1/` Если всё ок - **{"active service is": green}**

 
