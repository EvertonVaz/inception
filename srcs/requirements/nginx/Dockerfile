FROM debian:oldstable

RUN apt-get update -y && apt-get upgrade -y && \
    apt-get install nginx openssl -y

RUN openssl req -x509 -sha256 -nodes -newkey rsa:2048 -days 365 \
	-keyout /etc/ssl/private/private.key \
	-out /etc/ssl/certs/certificate.crt \
	-subj "/C=BR/ST=SP/L=Sao Paulo/O=42sp/CN=egeraldo.42.fr"

COPY ./conf/nginx.conf /etc/nginx/conf.d

RUN chmod 755 /var/www
RUN chown -R www-data:www-data /var/www

CMD ["nginx", "-g", "daemon off;"]