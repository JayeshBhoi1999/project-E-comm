from django.shortcuts import render

# Create your views here.


def home(request):
    #products = Product.objects.all()
    #return render(request,"index.html",{'products':products})
    return render(request,"index.html")

