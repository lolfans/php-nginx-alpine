# php-nginx-alpine

以php官方镜像为主再集成其他相关

制作NGINX+PHP环境镜像的方式 将代码克隆到docker环境的主机

git clone https://github.com/lolfans/php-nginx-alpine.git


cd php-nginx-alpine

docker build --no-cache -t php-nginx-alpine .


tip：注意最后的一个小点 不要忽略了


docker images 就能看见你的镜像了 放到任何环境都能运行 /var/www/html 是项目目录 可以以此镜像为基础镜像 将项目代码放到该目录下即可


对性能有更多要求 可以自行调整上面php文件夹与nginx文件夹下的对应文件

