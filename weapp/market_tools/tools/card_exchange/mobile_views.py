# -*- coding: utf-8 -*-

__author__ = 'aix'

import os

from django.template import Context, RequestContext
from django.shortcuts import render_to_response

from mall.promotion.card_exchange import CardExchange

template_path_items = os.path.dirname(__file__).split(os.sep)
TEMPLATE_DIR = '%s/templates' % template_path_items[-1]

COUNT_PER_PAGE = 15
def get_page(request):
	"""
	手机端卡兑换页
	"""
	# webapp_id = request.user_profile.webapp_id
	webapp_id = request.GET.get('webapp_id','')
	#判断用户是否绑定手机号
	# member_id = request.member.id
	# member_integral = request.member.integral
	# try:
	#     member_info = MemberInfo.objects.get(member_id = member_id)
	#     member_is_bind = member_info.is_bind
	# except:
	#     member_is_bind = False

	card_exchange_dic = CardExchange.get_can_exchange_cards(request,webapp_id)

	c = RequestContext(request, {
		'card_exchange_rule': card_exchange_dic,
		# 'member_is_bind': member_is_bind,
		# 'member_integral': member_integral
	})

	return render_to_response('%s/card_exchange/webapp/m_card_exchange.html' % TEMPLATE_DIR, c)