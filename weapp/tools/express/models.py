# -*- coding: utf-8 -*-
__author__ = 'liupeiyu'

from django.db import models

class ExpressDetail(models.Model):
	order_id = models.IntegerField(verbose_name="订单id")
	context = models.CharField(max_length=1024, verbose_name="内容")
	status = models.CharField(max_length=50, verbose_name="状态")
	time = models.DateTimeField(verbose_name="时间，原始格式")
	ftime = models.CharField(max_length=50, verbose_name="格式化后时间")
	display_index = models.IntegerField(default=1, db_index=True, verbose_name="显示的排序")
	created_at = models.DateTimeField(auto_now_add=True, verbose_name="创建时间")

	class Meta(object):
		db_table = 'tool_express_detail'
		verbose_name = '快递明细'
		verbose_name_plural = '快递明细'



class ExpressHasOrderPushStatus(models.Model):
	order_id = models.IntegerField(verbose_name="订单id")
	express_company_name = models.CharField(max_length=50, default='', verbose_name="快递公司名称")
	express_number = models.CharField(max_length=100, verbose_name="快递单号")
	status = models.BooleanField(default=False, verbose_name="状态")
	created_at = models.DateTimeField(auto_now_add=True, verbose_name="创建时间")

	class Meta(object):
		db_table = 'tool_express_has_order_push_status'
		verbose_name = '订单的推送状态'
		verbose_name_plural = '订单的推送状态'


