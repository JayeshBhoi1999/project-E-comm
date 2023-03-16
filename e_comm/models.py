from django.db import models

# Create your models here.
class Product (models.Model):
    product_id = models.AutoField
    product_name = models.CharField(max_length=50,default="")
    category = models.CharField(max_length=50,default="")
    sub_category = models.CharField(max_length=50,default="")
    p_img_1 = models.ImageField(upload_to='static/images/',default="")
    p_img_2 = models.ImageField(upload_to='static/images/',default="")
    p_img_3 = models.ImageField(upload_to='static/images/',default="")
    p_img_4 = models.ImageField(upload_to='static/images/',default="")
    product_price = models.IntegerField(default=0)
    date_added = models.DateTimeField(auto_now_add=True)
    p_slug = models.SlugField(default="",blank=False)
    def __str__(self):
        return self.product_name

    class Meta:
        ordering = ['-date_added']


class Image(models.Model):
    image_ID = models.AutoField
    product = models.ForeignKey(Product, on_delete=models.CASCADE)
    image = models.ImageField(upload_to='images/')
    default = models.BooleanField(default=False)
        
    def __str__(self):
        return str(self.image_ID)
    
    