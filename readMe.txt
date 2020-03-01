docker stop $(docker ps -a -q)
docker rm $(docker ps -a -q)
docker rmi $(docker images -q)
docker build --rm -t rpg .
docker run -tid --privileged -v /sys/fs/cgroup:/sys/fs/cgroup:ro --cap-add SYS_ADMIN -p 80:80 --name rpg rpg
docker exec -ti rpg sh -c "systemctl start php-fpm && systemctl enable php-fpm && rm -rf /var/www/vendor/ && cd /var/www/ && composer install && chmod -R 777 /var/www && php /var/www/artisan key:generate && systemctl enable nginx && systemctl start nginx"



For running Tests: 
1. Navigate to project directory
2. run : #vendor/bin/phpunit --debug tests/Feature
