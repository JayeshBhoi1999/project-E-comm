# Generated by Django 4.1.5 on 2023-02-02 06:17

from django.db import migrations


class Migration(migrations.Migration):

    dependencies = [
        ('e_comm', '0005_product_file'),
    ]

    operations = [
        migrations.RemoveField(
            model_name='product',
            name='file',
        ),
    ]
