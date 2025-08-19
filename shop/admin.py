from django.contrib import admin
from .models import Product,Image

# Register your models here.
# Register the Image model in the admin
@admin.register(Image)
class ImageAdmin(admin.ModelAdmin):
    list_display = ('product', 'image')  # Display image ID, associated product, and the image field
    search_fields = ('product__product_name',)  # Allow search by product name

# Register the Product model and include an inline for Image (to manage images directly inside Product)
class ImageInline(admin.TabularInline):
    model = Image  # Associate the Image model with the Product model
    extra = 0  # No extra forms for adding images (adjust as needed)
    fields = ('image',)  # Only display the image field in the inline form

@admin.register(Product)
class ProductAdmin(admin.ModelAdmin):
    list_display = ('product_name', 'category', 'sub_category', 'product_price', 'date_added', 'p_slug')
    search_fields = ('product_name', 'category', 'sub_category')  # Allow search by product name, category, or subcategory
    inlines = [ImageInline]  # Include the ImageInline to manage images for each product