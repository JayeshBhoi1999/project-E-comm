# Generated by Django 4.1.5 on 2023-02-03 05:37

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('e_comm', '0007_rename_product_image_product_p_img_1_product_p_img_2_and_more'),
    ]

    operations = [
        migrations.AddField(
            model_name='product',
            name='p_slug',
            field=models.SlugField(default='-'),
        ),
    ]
