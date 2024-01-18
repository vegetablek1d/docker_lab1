FROM ubuntu:20.04

#Установка пакетов и очистка кэша
RUN apt-get update
RUN apt-get upgrade -y
RUN apt-get install -y nginx
RUN apt-get clean
RUN rm -rf /var/www/*

#Создание директорий и копрование файлов
RUN mkdir /var/www/docker_1 && mkdir /var/www/my_project/img
COPY index.html /var/www/docker_1/
COPY img.jpg /var/www/docker_1/img/

#Права на директорию
RUN chmod -R 755 /var/www/docker_1

#Создание пользователей и группы
RUN useradd andrey
RUN groupadd students
RUN usermod -aG andrey students
RUN chown -R andrey:students /var/www/docker_1

#Настройка NGINX
RUN sed -i 's/\/var\/www\/html/\/var\/www\/docker_1/g' /etc/nginx/sites-enabled/default
RUN nginx_user_file=$(grep -rl 'user .*;' /etc/nginx/)
RUN sed -i 's/www-data/andrey/g' nginx.conf

# Запуск NGINX
CMD ["nginx", "-g", "daemon off;"]