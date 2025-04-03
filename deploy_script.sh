sudo apt update
sudo apt install python3-pip python3-dev nginx -y
sudo apt install virtualenv -y
git clone https://github.com/JayeshBhoi1999/project-E-comm.git
cd project-E-comm/
virtualenv env
source env/bin/activate

sudo apt-get install -y python3-dev libjpeg-dev zlib1g-dev
pip install -r requirements.txt
sudo ufw allow 8000

touch .env
nano .env

python manage.py makemigrations
python manage.py migrate
python manage.py runserver 0.0.0.0:8000

python manage.py shell -c "from django.contrib.auth.models import User; User.objects.create_superuser('root', 'user@example.com', 'toor')"
gunicorn --bind 0.0.0.0:8000 project_e_comm.wsgi

deactivate


sudo vim /etc/systemd/system/gunicorn.service

[Unit]
Description=gunicorn daemon
Requires=gunicorn.socket
After=network.target

[Service]
User=ubuntu
Group=www-data
WorkingDirectory=/home/ubuntu/project-E-comm
ExecStart=/home/ubuntu/project-E-comm/env/bin/gunicorn \
          --access-logfile - \
          --workers 3 \
          --bind unix:/run/gunicorn.sock \
          project_e_comm.wsgi:application

[Install]
WantedBy=multi-user.target

sudo systemctl start gunicorn.socket
sudo systemctl enable gunicorn.socket

sudo vim /etc/nginx/sites-available/project-E-comm





server {
    listen 80;
    server_name 54.224.134.67;

    location = /favicon.ico { access_log off; log_not_found off; }
    location /static/ {
        root /home/ubuntu/project-E-comm;
    }

    location / {
        include proxy_params;
        proxy_pass http://unix:/run/gunicorn.sock;
    }
}


sudo vim /etc/nginx/sites-available/project-E-comm


sudo ln -s /etc/nginx/sites-available/project-E-comm /etc/nginx/sites-enabled/



server {
    listen 80;
    server_name default_server;

    # Serve static files (handled by Whitenoise in Django)
    location /static/ {
        alias /home/ubuntu/project-E-comm/static/;  # Change to your actual static directory
        expires 30d;  # Cache for 30 days
        add_header Cache-Control "public, no-transform, max-age=2592000";
    }

    # Serve media files
    location /media/ {
        alias /home/ubuntu/project-E-comm/media/;  # Change to your actual media directory
        expires 30d;  # Cache for 30 days
        add_header Cache-Control "public, no-transform, max-age=2592000";
    }

    location / {
        include proxy_params;
        proxy_pass http://unix:/run/gunicorn.sock;  # Gunicorn or your WSGI server
    }
}


sudo chown -R www-data:www-data /home/ubuntu/project-E-comm/static/

# Set directories to 755 and files to 644
sudo find /home/ubuntu/project-E-comm/static/ -type d -exec chmod 755 {} \;
sudo find /home/ubuntu/project-E-comm/static/ -type f -exec chmod 644 {} \;

sudo chmod 755 /home/ubuntu
sudo chmod 755 /home/ubuntu/project-E-comm


sudo systemctl restart nginx