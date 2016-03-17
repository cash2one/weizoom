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
from apps.customerized_apps.group.models import Group, GroupRelations, GroupDetail
from mall.models import *
from utils.string_util import byte_to_hex
import json
import re

import time
from django.core.management.base import BaseCommand, CommandError
from utils.cache_util import SET_CACHE
from modules.member.models import Member


def __get_group_rule_id(group_rule_name):
	return Group.objects.get(name=group_rule_name).id

def __get_product_idByname(product_name):
	return Product.objects.get(name=product_name).id

def __get_into_group_pages(context,webapp_owner_id,activity_id,openid):
	#进入团购活动页面
	url = '/m/apps/group/m_group/?webapp_owner_id=%s&id=%s&fmt=%s&opid=%s' % (webapp_owner_id, activity_id, context.member.token, openid)
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

def __get_into_group_list_pages(context,webapp_owner_id,openid):
	#进入全部团购活动列表页面
	url = '/m/apps/group/m_group_list/?webapp_owner_id=%s&fmt=%s&opid=%s' % (webapp_owner_id, context.member.token, openid)
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

def __get_group_informations(context,webapp_owner_id,activity_id,openid):
	url = '/m/apps/group/api/m_group/?webapp_owner_id=%s&id=%s&fmt=%s&opid=%s' % (webapp_owner_id, activity_id, context.member.token, openid)
	url = bdd_util.nginx(url)
	response = context.client.get(url)
	while response.status_code == 302:
		print('[info] redirect by change fmt in shared_url')
		redirect_url = bdd_util.nginx(response['Location'])
		context.last_url = redirect_url
		response = context.client.get(bdd_util.nginx(redirect_url))
	if response.status_code == 200:
		return response
	else:
		print('[info] redirect error,response.status_code :')
		print(response.status_code)

def __open_group(context,activity_id,fid,group_type,group_days,group_price,product_id,openid):
	webapp_owner_id = context.webapp_owner_id
	params = {
		'webapp_owner_id': webapp_owner_id,
		'group_record_id': activity_id,
		'fid': fid,
		'group_type': group_type,
		'group_days': group_days,
		'group_price': group_price,
		'product_id': product_id
	}
	response = context.client.post('/m/apps/group/api/group_participance/?_method=post', params)
	while response.status_code == 302:
		print('[info] redirect by change fmt in shared_url')
		redirect_url = bdd_util.nginx(response['Location'])
		context.last_url = redirect_url
		response = context.client.get(bdd_util.nginx(redirect_url))
	if response.status_code == 200:
		print('response!!!!!!!!!!!!!!!!!!')
		print(response)
		return response
	else:
		print('[info] redirect error,response.status_code :')
		print(response.status_code)

@then(u"{webapp_user_name}能获得{webapp_owner_name}的团购活动列表")
def step_tmpl(context, webapp_user_name, webapp_owner_name):
	user = User.objects.get(id=context.webapp_owner_id)
	openid = "%s_%s" % (webapp_user_name, user.username)
	webapp_owner_id = context.webapp_owner_id
	response = __get_into_group_list_pages(context,webapp_owner_id,openid)
	all_groups_can_open = response.context['all_groups_can_open']
	# 构造实际数据
	actual = []
	for group in all_groups_can_open:
		actual.append({
			"group_name": group['name'],
			"group_dict": group['all_group_dict']
		})
	print("actual_data: {}".format(actual))
	expected = json.loads(context.text)
	print("expected: {}".format(expected))
	bdd_util.assert_list(expected, actual)

@When(u'{webapp_user_name}参加{webapp_owner_name}的团购活动"{group_record_name}"')
def step_tmpl(context, webapp_user_name, webapp_owner_name,group_record_name):
	webapp_owner_id = context.webapp_owner_id
	activity_id = __get_group_rule_id(group_record_name)
	user = User.objects.get(id=context.webapp_owner_id)
	openid = "%s_%s" % (webapp_user_name, user.username)
	context.data_response = __get_group_informations(context,webapp_owner_id,activity_id,openid).content
	context.page_owner_member_id = json.loads(context.data_response)['data']['member_info']['page_owner_member_id']
	fid = context.page_owner_member_id
	data = json.loads(context.text)
	group_type= data['group_dict']['group_type']
	group_days= data['group_dict']['group_days']
	group_price= data['group_dict']['group_price']
	product_id = __get_product_idByname(data['products']['name'])
	__open_group(context,activity_id,fid,group_type,group_days,group_price,product_id,openid)
