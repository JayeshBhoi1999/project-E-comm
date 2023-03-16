from django.contrib import admin
from django.urls import path ,include
from . import views
urlpatterns = [
    path('',views.home,name="home" ),
    path('<slug:p_slug>/',views.product_page,name="product_page"),

]
