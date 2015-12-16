#!/usr/bin/env python
# -*- coding: utf-8 -*-
__author__ = 'kuki'

from behave import *
from test import bdd_util
from collections import OrderedDict

from features.testenv.model_factory import *
import steps_db_util
from modules.member import module_api as member_api
from utils import url_helper
import datetime as dt
import termite.pagestore as pagestore_manager
from mall.promotion import models as  promotion_models
from apps.customerized_apps.event.models import event, eventParticipance
from weixin.message.material import models as material_models
from modules.member.models import Member, SOURCE_MEMBER_QRCODE
from utils.string_util import byte_to_hex
import json
import re

def __itemName2item(itemName):
	itemName_dic={u"姓名":'name',u"手机":'phone',u"邮箱":'email',u"QQ":'qq',u"qq":'qq',u"职位":"job",u"住址":"addr"}
	if itemName in itemName_dic:
		return itemName_dic[itemName]
	else:
		return itemName

def __get_event_rule_id(event_name):
	return event.objects.get(name=event_name).id

def __get_coupon_rule_id(coupon_rule_name):
	"""
	获取优惠券id
	"""
	coupon_rule = promotion_models.CouponRule.objects.get(name=coupon_rule_name)
	return coupon_rule.id

def __get_into_event_pages(context,webapp_owner_id,event_rule_id,openid):
	#进入微助力活动页面
	url = '/m/apps/event/m_event/?webapp_owner_id=%s&id=%s&fmt=%s&opid=%s' % (webapp_owner_id, event_rule_id, context.member.token, openid)
	url = bdd_util.nginx(url)
	context.link_url = url
	response = context.client.get(url)
	if response.status_code == 302:
		print('[info] redirect by change fmt in shared_url')
		redirect_url = bdd_util.nginx(response['Location'])
		context.last_url = redirect_url
		response = context.client.get(bdd_util.nginx(redirect_url))
		if response.status_code == 302:
			print('[info] redirect by change fmt in shared_url')
			redirect_url = bdd_util.nginx(response['Location'])
			context.last_url = redirect_url
			response = context.client.get(bdd_util.nginx(redirect_url))
		else:
			print('[info] not redirect')
	else:
		print('[info] not redirect')
	return response

def __participate_event(context,webapp_owner_id,event_rule_id,member_id, date):
	termite_data = json.loads(context.text)
	i = 0
	data = {}
	for k,v in termite_data.iteritems():
		item_name = __itemName2item(k) if k!=u'' else ''
		name = '0'+str(i)+'_'+item_name
		data[name] = {
			'type': 'appkit.textlist',
			'value': v
        }
		i += 1
	related_page_id = event.objects.get(id=event_rule_id).related_page_id
	pagestore = pagestore_manager.get_pagestore('mongo')
	page = pagestore.get_page(related_page_id, 1)
	prize = page['component']['components'][0]['model']['prize']
	params = {
		'webapp_owner_id': webapp_owner_id,
		'belong_to': event_rule_id,
		'termite_data': json.dumps(data),
		'prize': json.dumps(prize)
	}
	response = context.client.post('/m/apps/event/api/event_participance/?_method=put', params)
	event_info = eventParticipance.objects.get(member_id=member_id, belong_to=str(event_rule_id))
	event_info.update(set__created_at=date)
	context.response_json = json.loads(response.content)

@when(u"{webapp_user_name}参加活动报名'{event_name}'于'{date}'")
def step_tmpl(context, webapp_user_name, event_name, date):
	webapp_owner_id = context.webapp_owner_id
	user = User.objects.get(id=context.webapp_owner_id)
	openid = "%s_%s" % (webapp_user_name, user.username)
	date = bdd_util.get_date(date)
	event_rule_id = __get_event_rule_id(event_name)
	member = member_api.get_member_by_openid(openid, context.webapp_id)
	response = __get_into_event_pages(context,webapp_owner_id,event_rule_id,openid)
	related_page_id = event.objects.get(id=event_rule_id).related_page_id
	pagestore = pagestore_manager.get_pagestore('mongo')
	page = pagestore.get_page(related_page_id, 1)
	print(page['component']['components'][0]['model'])
	permission = page['component']['components'][0]['model']['permission']
	if permission == 'member':
		if member.is_subscribed == True:
			__participate_event(context,webapp_owner_id,event_rule_id,member.id,date)
		else:
			pass #弹二维码
	else:
		__participate_event(context,webapp_owner_id,event_rule_id,member.id,date)


@then(u'{webapp_user_name}获得提示"{msg}"')
def step_tmpl(context, webapp_user_name, msg):
	expected = msg
	response_json = context.response_json
	if response_json['code'] == 200:
		actual = u"提交成功"
	elif response_json['code'] == 500:
		actual = response_json['data']
	context.tc.assertEquals(expected, actual)