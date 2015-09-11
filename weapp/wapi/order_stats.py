# -*- coding: utf-8 -*-
"""
有关订单的统计数据
"""

#import json
#from datetime import datetime
#from django.http import HttpResponseRedirect
#from django.template import RequestContext
from django.contrib.auth.decorators import login_required
#from django.shortcuts import render_to_response
#from django.db.models import F

from core import resource
#from core import paginator
from core.jsonresponse import create_response
#from core.charts_apis import create_line_chart_response

from mall.models import *
#from utils import dateutil as util_dateutil
#import pandas as pd
#from core import dateutil
#from webapp import models as webapp_models
#from webapp import statistics_util as webapp_statistics_util
from core.charts_apis import *
#from django.conf import settings
#import stats.util as stats_util
#from stats.models import BrandValueHistory

#from core.exceptionutil import unicode_full_stack
#from watchdog.utils import watchdog_error, watchdog_warning

from wapi.decorators import wapi_access_required

#from stats.manage.brand_value_utils import get_brand_value

#from utils import dateutil as utils_dateutil

from mall import models as mall_models

class OrderStats(resource.Resource):
	"""
	获取订单的统计数据
	"""
	app = 'wapi'
	resource = 'order_stats'

	@wapi_access_required
	def api_get(request):
		"""
		获取订单的统计数据

		@param wid webapp_id
		@param date_start 起始日期
		@param date_end 结束日期
		"""
		webapp_id = request.GET.get('wid')
		#print("webapp_id: {}".format(webapp_id))
		date_start = request.GET.get('date_start')
		date_end = request.GET.get('date_end')

		orders = mall_models.Order.objects.filter( \
			webapp_id=webapp_id, \
			status__in=[mall_models.ORDER_STATUS_SUCCESSED, mall_models.ORDER_STATUS_PAYED_NOT_SHIP, mall_models.ORDER_STATUS_PAYED_SHIPED, mall_models.ORDER_STATUS_PAYED_SUCCESSED], \
			created_at__range=(date_start, date_end) )
		# 计算购买人数
		members = set([order.webapp_user_id for order in orders])
		# 计算总支付金额
		total_payment = sum([order.final_price for order in orders])

		response = create_response(200)
		response.data = {
			"webapp_id": webapp_id,
			"order_count": len(orders),
			"member_count": len(members),
			"total_payment": total_payment
		}
		return response.get_response()
