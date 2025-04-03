#!/bin/bash

# Script to automate Django project setup on Ubuntu EC2

# Update and install necessary packages
echo "Updating system packages..."
sudo apt update && sudo apt upgrade -y
sudo apt install -y python3-pip python3-dev nginx virtualenv git ufw libjpeg-dev zlib1g-dev

# # Clone the project
# echo "Cloning the project repository..."
# git clone https://github.com/JayeshBhoi1999/project-E-comm.git
# cd project-E-comm/ || { echo "Failed to enter project directory"; exit 1; }

# Set up virtual environment
echo "Setting up virtual environment..."
virtualenv env
source env/bin/activate

# Install Python dependencies
echo "Installing Python dependencies..."
pip install -r requirements.txt

# Allow traffic on port 8000
echo "Allowing traffic on port 8000..."
sudo ufw allow 8000

# Create .env file
echo "Creating .env file..."
touch .env
echo "SECRET_KEY=django-insecure-f-0^una^mvj4d&20pqo$lsj2m%wbt)&q@o-yu6)gfo0m2@plar" > .env
#nano .env  # You may replace this with echo statements if you want to automate it.

# Database migrations
echo "Applying migrations..."
python manage.py makemigrations
python manage.py migrate

# Create superuser
echo "Creating Django superuser..."
python manage.py shell -c "from django.contrib.auth.models import User; User.objects.create_superuser('root', 'user@example.com', 'toor')"

# Collect static files
echo "Collecting static files..."
python manage.py collectstatic --noinput

# Deactivate virtual environment
deactivate

# Set up Gunicorn
echo "Setting up Gunicorn..."
sudo cp gunicorn.service /etc/systemd/system/
sudo cp gunicorn.socket /etc/systemd/system/
sudo systemctl start gunicorn.socket
sudo systemctl enable gunicorn.socket

# Set up Nginx
echo "Configuring Nginx..."
sudo cp project_site /etc/nginx/sites-available/
sudo ln -s /etc/nginx/sites-available/project_site /etc/nginx/sites-enabled/
sudo rm /etc/nginx/sites-enabled/default

# Set permissions
echo "Setting permissions..."
sudo chown -R www-data:www-data /home/ubuntu/project-E-comm/static/
sudo find /home/ubuntu/project-E-comm/static/ -type d -exec chmod 755 {} \;
sudo find /home/ubuntu/project-E-comm/static/ -type f -exec chmod 644 {} \;
sudo chmod 755 /home/ubuntu
sudo chmod 755 /home/ubuntu/project-E-comm

# Restart Nginx
echo "Restarting Nginx..."
sudo systemctl restart nginx

# Completion message
echo "✅ Django project setup completed successfully!"
