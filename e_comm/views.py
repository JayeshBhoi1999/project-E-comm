from django.shortcuts import render
from .models import Product

# Create your views here.

def home(request):
    products = Product.objects.all()
    return render(request,"index.html",{'products':products})

def product_page(request,p_slug):
    product = Product.objects.get(p_slug=p_slug)
    images = product.image_set.all()

    for image in images:
        print(image.image.url)

    return render(request,"product_page.html",{"product":product,"images":images })

