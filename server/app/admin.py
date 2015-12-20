from django.contrib import admin

from .models import *


class RegionAdmin(admin.ModelAdmin):
    search_fields = ['name']

admin.site.register(Region, RegionAdmin)
admin.site.register(School)
admin.site.register(Grade)
admin.site.register(Tag)
admin.site.register(Subject)
admin.site.register(Level)
admin.site.register(Price)
admin.site.register(Role)
admin.site.register(Profile)
admin.site.register(Teacher)
admin.site.register(Highscore)
admin.site.register(Ability)
admin.site.register(Certificate)
admin.site.register(InterviewRecord)
admin.site.register(Account)
admin.site.register(BankCard)
admin.site.register(BankCodeInfo)
admin.site.register(AccountHistory)
admin.site.register(Feedback)
admin.site.register(Memberservice)
admin.site.register(Parent)
admin.site.register(Coupon)
admin.site.register(WeeklyTimeSlot)
admin.site.register(Order)
admin.site.register(TimeSlot)
admin.site.register(Comment)
admin.site.register(Message)
