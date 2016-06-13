# -*- coding: utf-8 -*-

import json
from datetime import datetime

from django.http import HttpResponseRedirect, HttpResponse
from django.template import RequestContext
from django.shortcuts import render_to_response
from django.db.models import F
from django.contrib.auth.decorators import login_required

from core import resource
from core import paginator
from core.jsonresponse import create_response
from core.exceptionutil import unicode_full_stack

import models as app_models
import export
from apps import request_util
from modules.member import integral as integral_api
from mall.promotion import utils as mall_api
from mall import export as mall_export
import termite.pagestore as pagestore_manager

FIRST_NAV = mall_export.MALL_PROMOTION_AND_APPS_FIRST_NAV
COUNT_PER_PAGE = 20

class EvaluateParticipance(resource.Resource):
	app = 'apps/evaluate'
	resource = 'evaluate_participance'

	def api_put(request):
		"""
		发表评价
		"""
		param = request.POST
		response = create_response(500)
		member = request.member
		if not member:
			response.errMsg = u'会员信息出错'
			return response.get_response()
		member_id = member.id
		owner_id = int(request.webapp_owner_id)
		product_id = int(param.get('product_id', 0))
		order_id = param.get('order_id', '')
		order_has_product_id = int(param.get('order_has_product_id', 0))
		template_type = param.get('template_type', 'ordinary')


		product_score = param.get('product_score', None)
		review_detail = param.get('review_detail', '')
		serve_score = param.get('serve_score', None)
		deliver_score = param.get('deliver_score', None)
		process_score = param.get('process_score', None)
		picture_list = param.get('picture_list', None)

		#创建订单评论
		try:
			order_evaluate = app_models.OrderEvaluates(
				order_id = order_id,
				owner_id = owner_id,
				member_id = member_id,
				serve_score = serve_score,
				deliver_score = deliver_score,
				process_score = process_score
			)
			order_evaluate.save()
		except:
			order_evaluate = app_models.OrderEvaluates.objects(order_id=order_id).first()

		# 创建商品评论
		product_evaluate = app_models.ProductEvaluates(
			member_id = member_id,
			order_evaluate_id = str(order_evaluate.id),
			order_id = order_id,
			owner_id = owner_id,
			product_id = product_id,
			order_has_product_id = order_has_product_id,
			score = product_score,
			detail = review_detail if template_type == 'ordinary' else json.loads(review_detail),
			pics = picture_list.split(',')
		)
		product_evaluate.save()

		response = create_response(200)
		return response.get_response()

	def api_post(request):
		"""
		追加晒图
		"""
		param = request.POST
		response = create_response(500)
		member = request.member
		if not member:
			response.errMsg = u'会员信息出错'
			return response.get_response()
		member_id = member.id
		owner_id = int(request.webapp_owner_id)
		product_id = int(param.get('product_id', 0))
		order_id = param.get('order_id', '')
		order_has_product_id = int(param.get('order_has_product_id', 0))
		picture_list = param.get('picture_list', None)
		if picture_list:
			picture_list = picture_list.split(',')
		try:
			product_evaluate = app_models.ProductEvaluates.objects.get(
				owner_id = owner_id,
				member_id = member_id,
				product_id = product_id,
				order_id = order_id,
				order_has_product_id = order_has_product_id
			)
			product_evaluate.pics += picture_list
			product_evaluate.save()
		except:
			response.errMsg = u'评价数据出错'
			return response.get_response()
		response = create_response(200)
		return response.get_response()
