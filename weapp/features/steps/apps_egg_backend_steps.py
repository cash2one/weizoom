#!/usr/bin/env python
# -*- coding: utf-8 -*-
from apps.customerized_apps.egg.models import EggRecord

from behave import *
from test import bdd_util
from collections import OrderedDict

from features.testenv.model_factory import *
import steps_db_util
from mall.promotion import models as  promotion_models
from modules.member import module_api as member_api
from utils import url_helper
import datetime as dt
from mall.promotion.models import CouponRule
from weixin.message.material import models as material_models
from apps.customerized_apps.egg import models as egg_models
import termite.pagestore as pagestore_manager
import json

def __debug_print(content,type_tag=True):
	"""
	debug工具函数
	"""
	if content:
		print('++++++++++++++++++  START ++++++++++++++++++++++++++++++++++++')
		if type_tag:
			print("====== Type ======")
			print(type(content))
			print("===================")
		print(content)
		print('++++++++++++++++++++  END  ++++++++++++++++++++++++++++++++++')
	else:
		pass

def __bool2Bool(bo):
	"""
	JS字符串布尔值转化为Python布尔值
	"""
	bool_dic = {'true':True,'false':False,'True':True,'False':False}
	if bo:
		result = bool_dic[bo]
	else:
		result = None
	return result

def __name2Bool(name):
	"""
	"是"--> true
	"否"--> false
	"""
	name_dic = {u'是':"true",u'否':"false"}
	if name:
		return name_dic[name]
	else:
		return None

def __date2time(date_str):
	"""
	字符串 今天/明天……
	转化为字符串 "%Y-%m-%d %H:%M"
	"""
	cr_date = date_str
	p_time = "{} 00:00".format(bdd_util.get_date_str(cr_date))
	return p_time

def __datetime2str(dt_time):
	"""
	datetime型数据，转为字符串型，日期
	转化为字符串 "%Y-%m-%d %H:%M"
	"""
	dt_time = dt.datetime.strftime(dt_time, "%Y-%m-%d %H:%M")
	return dt_time

def __limit2name(limit):
	"""
	传入积分规则，返回名字
	"""
	limit_dic={
	"once_per_user":u"一人一次",
	"once_per_day":u"一天一次",
	"twice_per_day":u"一天两次",
	"no_limit":u"不限"
	}
	if limit:
		return limit_dic[limit]
	else:
		return ""

def __name2limit(name):
	"""
	传入积分名字，返回积分规则
	"""
	name_dic={
		u"一人一次":"once_per_user",
		u"一天一次":"once_per_day",
		u"一天两次":"twice_per_day",
		u"不限":"no_limit"
	}
	if name:
		return name_dic[name]
	else:
		return ""

def __name2type(name):
	type_dic = {
		u"全部":"-1",
		u"积分":"integral",
		u"优惠券":"coupon",
		u"实物":"entity",
		u"未中奖":"no_prize"
	}
	if name:
		return type_dic[name]
	else:
		return ""

def __delivery2Bool(name):
	d_dic ={
		u"所有用户":"false",
		u'仅限未中奖用户':"true"
	}

	if name:
		return d_dic[name]
	else:
		return ""

def __get_coupon_json(coupon_rule_name):
	"""
	获取优惠券json
	"""
	coupon_rule = promotion_models.CouponRule.objects.get(name=coupon_rule_name)
	coupon ={
		"id":coupon_rule.id,
		"count":coupon_rule.count,
		"name":coupon_rule.name
	}
	return coupon

def __get_coupon_rule_id(coupon_rule_name):
	"""
	获取优惠券id
	"""
	coupon_rule = promotion_models.CouponRule.objects.get(name=coupon_rule_name)
	return coupon_rule.id

def __egg_name2id(name):
	"""
	给抽奖项目的名字，返回id元祖
	返回（related_page_id,egg_egg中id）
	"""
	obj = egg_models.Egg.objects.get(name=name)
	return (obj.related_page_id,obj.id)

def __status2name(status_num):
	"""
	抽奖：状态值 转 文字
	"""
	status2name_dic = {-1:u"全部",0:u"未开始",1:u"进行中",2:u"已结束"}
	return status2name_dic[status_num]

def __name2status(name):
	"""
	抽奖： 文字 转 状态值
	"""
	if name:
		name2status_dic = {u"全部":-1,u"未开始":0,u"进行中":1,u"已结束":2}
		return name2status_dic[name]
	else:
		return -1

def __name2coupon_status(name):
	"""
	抽奖： 文字 转 优惠券领取状态值
	"""
	if name:
		name2status_dic = {u"全部":-1,u"未领取":0,u"已领取":1}
		return name2status_dic[name]
	else:
		return -1

def __get_actions(status):
	"""
	根据输入抽奖状态
	返回对于操作列表
	"""
	actions_list = [u"查看结果",u"链接",u"预览"]
	if status == u"进行中":
		actions_list.insert(2,u"关闭")
	elif status=="已结束" or "未开始":
		actions_list.insert(2,u"删除")
	return actions_list

def __get_eggPageJson(args):
	"""
	传入参数，获取模板
	"""
	__page_temple = {
		"type": "appkit.page",
		"cid": 1,
		"pid": None,
		"auto_select": False,
		"selectable": "yes",
		"force_display_in_property_view": "no",
		"has_global_content": "no",
		"need_server_process_component_data": "no",
		"is_new_created": True,
		"property_view_title": "背景",
		"model": {
			"id": "",
			"class": "",
			"name": "",
			"index": 1,
			"datasource": {
				"type": "api",
				"api_name": ""
			},
			"content_padding": "15px",
			"title": "index",
			"event:onload": "",
			"uploadHeight": "568",
			"uploadWidth": "320",
			"site_title": "砸金蛋",
			"background": ""
		},
		"components": [
			{
				"type": "appkit.eggdescription",
				"cid": 2,
				"pid": 1,
				"auto_select": False,
				"selectable": "yes",
				"force_display_in_property_view": "no",
				"has_global_content": "no",
				"need_server_process_component_data": "no",
				"property_view_title": "砸金蛋",
				"model": {
					"id": "",
					"class": "",
					"name": "",
					"index": 2,
					"datasource": {
						"type": "api",
						"api_name": ""
					},
					"title": args['title'],
					"start_time": args['start_time'],
					"end_time": args['end_time'],
					"valid_time": args['valid_time'],
					"description": args['description'],
					"expend": args['expend'],
					"delivery": args['delivery'],
					"delivery_setting": args['delivery_setting'],
					"limitation": args['limitation'],
					"chance": args['chance'],
					"allow_repeat": args['allow_repeat'],
					"background_color": args['background_color'],
					"items": [
						4,
						5,
						6
					]
				},
				"components": [
					{
						"type": "appkit.eggitem",
						"cid": 4,
						"pid": 2,
						"auto_select": False,
						"selectable": "no",
						"force_display_in_property_view": "no",
						"has_global_content": "no",
						"need_server_process_component_data": "no",
						"property_view_title": "",
						"model": {
							"id": "",
							"class": "",
							"name": "",
							"index": 3,
							"datasource": {
								"type": "api",
								"api_name": ""
							},
							"title": "一等奖",
							"prize_count": args['prize_settings'][0]['prize_count'],
							"prize": args['prize_settings'][0]['prize'],
						},
						"components": []
					},
					{
						"type": "appkit.eggitem",
						"cid": 5,
						"pid": 2,
						"auto_select": False,
						"selectable": "no",
						"force_display_in_property_view": "no",
						"has_global_content": "no",
						"need_server_process_component_data": "no",
						"property_view_title": "",
						"model": {
							"id": "",
							"class": "",
							"name": "",
							"index": 3,
							"datasource": {
								"type": "api",
								"api_name": ""
							},
							"title": "二等奖",
							"prize_count": args['prize_settings'][1]['prize_count'],
							"prize": args['prize_settings'][1]['prize'],
						},
						"components": []
					},
					{
						"type": "appkit.eggitem",
						"cid": 6,
						"pid": 2,
						"auto_select": False,
						"selectable": "no",
						"force_display_in_property_view": "no",
						"has_global_content": "no",
						"need_server_process_component_data": "no",
						"property_view_title": "",
						"model": {
							"id": "",
							"class": "",
							"name": "",
							"index": 3,
							"datasource": {
								"type": "api",
								"api_name": ""
							},
							"title": "三等奖",
							"prize_count": args['prize_settings'][2]['prize_count'],
							"prize": args['prize_settings'][2]['prize'],
						},
						"components": []
					}
				]
			},
			{
				"type": "appkit.submitbutton",
				"cid": 3,
				"pid": 1,
				"auto_select": False,
				"selectable": "no",
				"force_display_in_property_view": "no",
				"has_global_content": "no",
				"need_server_process_component_data": "no",
				"property_view_title": "",
				"model": {
					"id": "",
					"class": "",
					"name": "",
					"index": 99999,
					"datasource": {
						"type": "api",
						"api_name": ""
					},
					"text": "提交"
				},
				"components": []
			}
		]
	}
	return json.dumps(__page_temple)

def __prize_settings_process(prize_settings):
	"""
	处理prize_settings

	Tag为page，返回page的prize字典
	Tage为egg,返回egg_egg的prize字典
	"""

	page_prize_list = []
	egg_prize_list = []
	egg_prize_dic = {}

	if prize_settings:
		index = 0
		plist = [u'一等奖',u'二等奖',u'三等奖']
		for prize_setting in prize_settings:
			#Page
			page_prize_dic = {}
			page_prize_dic['title'] = prize_setting.get("prize_grade","")
			page_prize_dic['prize_count'] = prize_setting.get("prize_counts","")
			page_prize_dic['leftCount'] = prize_setting.get("rest","")

			page_prize_dic['prize'] = {}
			prize_type = __name2type(prize_setting.get("prize_type"))
			if prize_type == "integral":
				prize_data = prize_setting.get("integral")
			elif prize_type == "coupon":
				coupon_name = prize_setting.get("coupon")
				coupon_id = __get_coupon_rule_id(coupon_name)
				prize_data = {
					"id":coupon_id,
					"name":coupon_name
				}
			elif prize_type == "entity":
				prize_data = prize_setting.get("gift","")
			else:
				prize_data = ""
			page_prize_dic['prize']["type"] = prize_type
			page_prize_dic['prize']["data"] = prize_data

			page_prize_list.append(page_prize_dic)

			#egg_egg
			egg_prize_dic[plist[index]] = {
				"title":prize_setting.get("prize_grade",""),
				"prize_count":prize_setting.get("prize_counts",""),
				"leftCount":prize_setting.get("rest",""),
				"prize_type":prize_type,
				"prize_data":prize_data
			}
			index += 1

		return (page_prize_list,egg_prize_dic)
	else:
		return []

def __Create_Egg(context,text,user):
	"""
	模拟用户登录页面
	创建砸金蛋项目
	写入mongo表：
		1.egg_egg表
		2.page表
	"""

	design_mode = 0
	version = 1
	text = text

	title = text.get("name","")

	cr_start_date = text.get('start_date', u'今天')
	start_date = bdd_util.get_date_str(cr_start_date)
	start_time = "{} 00:00".format(bdd_util.get_date_str(cr_start_date))

	cr_end_date = text.get('end_date', u'1天后')
	end_date = bdd_util.get_date_str(cr_end_date)
	end_time = "{} 00:00".format(bdd_util.get_date_str(cr_end_date))

	valid_time = "%s~%s"%(start_time,end_time)

	desc = text.get('desc','')#描述
	reduce_integral = text.get('reduce_integral',0)#消耗积分
	send_integral = text.get('send_integral',0)#参与送积分
	send_integral_rules = text.get('send_integral_rules',"")#送积分规则
	egg_limit = __name2limit(text.get('lottery_limit',u'一人一次'))#抽奖限制
	win_rate = text.get('win_rate','0%').split('%')[0]#中奖率
	is_repeat_win = __name2Bool(text.get('is_repeat_win',"true"))#重复中奖
	lottory_color = text.get('lottory_color', '')
	expect_prize_settings_list = text.get('prize_settings',[])
	page_prize_settings,egg_prize_settings = __prize_settings_process(expect_prize_settings_list)

	page_args = {
		"title":title,
		"start_time":start_time,
		"end_time":end_time,
		"valid_time":valid_time,
		"description":desc,#描述
		"expend":reduce_integral,#消耗积分
		"delivery":send_integral,#参与送积分
		"delivery_setting":__delivery2Bool(send_integral_rules),#送积分规则
		"limitation":egg_limit,#抽奖限制
		"chance":win_rate,#中奖率
		"allow_repeat":is_repeat_win,#重复中奖
		"prize_settings":page_prize_settings,
		"background_color": lottory_color
	}
	#step1：登录页面，获得分配的project_id
	get_egg_response = context.client.get("/apps/egg/egg/")
	egg_args_response = get_egg_response.context
	project_id = egg_args_response['project_id']#(str){new_app:egg:0}

	#step2: 编辑页面获得右边的page_json
	dynamic_url = "/apps/api/dynamic_pages/get/?design_mode={}&project_id={}&version={}".format(design_mode,project_id,version)
	dynamic_response = context.client.get(dynamic_url)
	dynamic_data = dynamic_response.context#resp.context=> data ; resp.content => Http Text

	#step3:发送Page
	page_json = __get_eggPageJson(page_args)

	termite_post_args = {
		"field":"page_content",
		"id":project_id,
		"page_id":"1",
		"page_json": page_json
	}
	termite_url = "/termite2/api/project/?design_mode={}&project_id={}&version={}".format(design_mode,project_id,version)
	post_termite_response = context.client.post(termite_url,termite_post_args)
	related_page_id = json.loads(post_termite_response.content).get("data",{})['project_id']

	#step4:发送egg_args
	post_egg_args = {
		"name":title,
		"start_time":start_time,
		"end_time":end_time,
		"expend":reduce_integral,#消耗积分
		"delivery":send_integral,#参与送积分
		"delivery_setting":__delivery2Bool(send_integral_rules),#送积分规则
		"limitation":egg_limit,#抽奖限制
		"chance":win_rate,#中奖率
		"allow_repeat":is_repeat_win,#重复中奖
		"prize":json.dumps(egg_prize_settings),
		"related_page_id":related_page_id
	}
	egg_url ="/apps/egg/api/egg/?design_mode={}&project_id={}&version={}&_method=put".format(design_mode,project_id,version)
	post_egg_response = context.client.post(egg_url,post_egg_args)

	#跳转,更新状态位
	design_mode = 0
	count_per_page = 1000
	version = 1
	page = 1
	enable_paginate = 1

	rec_egg_url ="/apps/egg/api/lotteries/?design_mode={}&version={}&count_per_page={}&page={}&enable_paginate={}".format(design_mode,version,count_per_page,page,enable_paginate)
	rec_egg_response = context.client.get(rec_egg_url)

def __Update_Egg(context,text,page_id,egg_id):
	"""
	模拟用户登录页面
	编辑抽奖项目
	写入mongo表：
		1.egg_egg表
		2.page表
	"""

	design_mode=0
	version=1
	project_id = "new_app:egg:"+page_id

	title = text.get("name","")

	cr_start_date = text.get('start_date', u'今天')
	start_date = bdd_util.get_date_str(cr_start_date)
	start_time = "{} 00:00".format(bdd_util.get_date_str(cr_start_date))

	cr_end_date = text.get('end_date', u'1天后')
	end_date = bdd_util.get_date_str(cr_end_date)
	end_time = "{} 00:00".format(bdd_util.get_date_str(cr_end_date))

	valid_time = "%s~%s"%(start_time,end_time)

	desc = text.get('desc','')#描述
	reduce_integral = text.get('reduce_integral',0)#消耗积分
	send_integral = text.get('send_integral',0)#参与送积分
	send_integral_rules = text.get('send_integral_rules',"")#送积分规则
	egg_limit = __name2limit(text.get('lottery_limit',u'一人一次'))#抽奖限制
	win_rate = text.get('win_rate','0%').split('%')[0]#中奖率
	is_repeat_win = __name2Bool(text.get('is_repeat_win',"true"))#重复中奖
	lottory_color = text.get('lottory_color', '')
	expect_prize_settings_list = text.get('prize_settings',[])
	page_prize_settings,egg_prize_settings = __prize_settings_process(expect_prize_settings_list)


	page_args = {
		"title":title,
		"start_time":start_time,
		"end_time":end_time,
		"valid_time":valid_time,
		"description":desc,#描述
		"expend":reduce_integral,#消耗积分
		"delivery":send_integral,#参与送积分
		"delivery_setting":__delivery2Bool(send_integral_rules),#送积分规则
		"limitation":egg_limit,#抽奖限制
		"chance":win_rate,#中奖率
		"allow_repeat":is_repeat_win,#重复中奖
		"prize_settings":page_prize_settings,
		"background_color": lottory_color
	}

	page_json = __get_eggPageJson(page_args)

	update_page_args = {
		"field":"page_content",
		"id":project_id,
		"page_id":"1",
		"page_json": page_json
	}

	update_egg_args = {
		"name":title,
		"start_time":start_time,
		"end_time":end_time,
		"expend":reduce_integral,#消耗积分
		"delivery":send_integral,#参与送积分
		"delivery_setting":__delivery2Bool(send_integral_rules),#送积分规则
		"limitation":egg_limit,#抽奖限制
		"chance":win_rate,#中奖率
		"allow_repeat":is_repeat_win,#重复中奖
		"prize":json.dumps(egg_prize_settings),
		"id":egg_id#updated的差别
	}


	#page 更新Page
	update_page_url = "/termite2/api/project/?design_mode={}&project_id={}&version={}".format(design_mode,project_id,version)
	update_page_response = context.client.post(update_page_url,update_page_args)

	#step4:更新egg
	update_egg_url ="/apps/egg/api/egg/?design_mode={}&project_id={}&version={}".format(design_mode,project_id,version)
	update_egg_response = context.client.post(update_egg_url,update_egg_args)

	#跳转,更新状态位
	design_mode = 0
	count_per_page = 1000
	version = 1
	page = 1
	enable_paginate = 1

	rec_egg_url ="/apps/egg/api/eggs/?design_mode={}&version={}&count_per_page={}&page={}&enable_paginate={}".format(design_mode,version,count_per_page,page,enable_paginate)
	rec_egg_response = context.client.get(rec_egg_url)

def __Delete_egg(context,egg_id):
	"""
	删除抽奖活动
	写入mongo表：
		1.egg_egg表

	注释：page表在原后台，没有被删除
	"""
	design_mode = 0
	version = 1
	del_egg_url = "/apps/egg/api/egg/?design_mode={}&version={}&_method=delete".format(design_mode,version)
	del_args ={
		"id":egg_id
	}
	del_egg_response = context.client.post(del_egg_url,del_args)
	return del_egg_response

def __Stop_egg(context,egg_id):
	"""
	关闭抽奖活动
	"""

	design_mode = 0
	version = 1
	stop_egg_url = "/apps/egg/api/egg_status/?design_mode={}&version={}".format(design_mode,version)
	stop_args ={
		"id":egg_id,
		"target":'stoped'
	}
	stop_egg_response = context.client.post(stop_egg_url,stop_args)
	return stop_egg_response

def __Search_egg(context,search_dic):
	"""
	搜索抽奖活动

	输入搜索字典
	返回数据列表
	"""

	design_mode = 0
	version = 1
	page = 1
	enable_paginate = 1
	count_per_page = 10

	name = search_dic["name"]
	start_time = search_dic["start_time"]
	end_time = search_dic["end_time"]
	status = __name2status(search_dic["status"])



	search_url = "/apps/egg/api/eggs/?design_mode={}&version={}&name={}&status={}&start_time={}&end_time={}&count_per_page={}&page={}&enable_paginate={}".format(
			design_mode,
			version,
			name,
			status,
			start_time,
			end_time,
			count_per_page,
			page,
			enable_paginate)

	search_response = context.client.get(search_url)
	bdd_util.assert_api_call_success(search_response)
	return search_response

def __Search_egg_Result(context,search_dic):
	"""
	搜索,抽奖参与结果

	输入搜索字典
	返回数据列表
	"""

	design_mode = 0
	version = 1
	page = 1
	enable_paginate = 1
	count_per_page = 10

	id = search_dic["id"]
	participant_name = search_dic["participant_name"]
	start_time = search_dic["start_time"]
	end_time = search_dic["end_time"]
	prize_type = __name2type(search_dic['prize_type'])
	status =__name2coupon_status(search_dic['status'])

	search_url = "/apps/egg/api/egg_participances/?design_mode={}&version={}&id={}&participant_name={}&start_time={}&end_time={}&prize_type={}&status={}&count_per_page={}&page={}&enable_paginate={}".format(
			design_mode,
			version,
			id,
			participant_name,
			start_time,
			end_time,
			prize_type,
			status,
			count_per_page,
			page,
			enable_paginate)

	search_response = context.client.get(search_url)
	bdd_util.assert_api_call_success(search_response)
	return search_response

@when(u'{user}新建砸金蛋活动')
def step_impl(context,user):
	text_list = json.loads(context.text)
	for text in text_list:
		__Create_Egg(context,text,user)

@then(u'{user}获得砸金蛋活动列表')
def step_impl(context,user):
	design_mode = 0
	count_per_page = 10
	version = 1
	page = 1
	enable_paginate = 1

	actual_list = []
	expected = json.loads(context.text)

	#搜索查看结果
	if hasattr(context,"search_egg"):
		rec_search_list = context.search_egg
		for item in rec_search_list:
			tmp = {
				"name":item['name'],
				"status":item['status'],
				"start_time":item['start_time'],
				"end_time":item['end_time'],
				"participant_count":item['participant_count'],
			}
			tmp["actions"] = __get_actions(item['status'])
			actual_list.append(tmp)

		for expect in expected:
			if 'start_date' in expect:
				expect['start_time'] = __date2time(expect['start_date'])
				del expect['start_date']
			if 'end_date' in expect:
				expect['end_time'] = __date2time(expect['end_date'])
				del expect['end_date']
		print("expected: {}".format(expected))

		bdd_util.assert_list(expected,actual_list)#assert_list(小集合，大集合)
	#其他查看结果
	else:
		#分页情况，更新分页参数
		if hasattr(context,"paging"):
			paging_dic = context.paging
			count_per_page = paging_dic['count_per_page']
			page = paging_dic['page_num']

		for expect in expected:
			if 'start_date' in expect:
				expect['start_time'] = __date2time(expect['start_date'])
				del expect['start_date']
			if 'end_date' in expect:
				expect['end_time'] = __date2time(expect['end_date'])
				del expect['end_date']


		print("expected: {}".format(expected))

		rec_egg_url ="/apps/egg/api/eggs/?design_mode={}&version={}&count_per_page={}&page={}&enable_paginate={}".format(design_mode,version,count_per_page,page,enable_paginate)
		rec_egg_response = context.client.get(rec_egg_url)
		rec_egg_list = json.loads(rec_egg_response.content)['data']['items']#[::-1]

		for item in rec_egg_list:
			tmp = {
				"name":item['name'],
				"status":item['status'],
				"start_time":__date2time(item['start_time']),
				"end_time":__date2time(item['end_time']),
				"participant_count":item['participant_count'],
			}
			tmp["actions"] = __get_actions(item['status'])
			actual_list.append(tmp)
		print("actual_data: {}".format(actual_list))
		bdd_util.assert_list(expected,actual_list)

@when(u"{user}编辑砸金蛋活动'{egg_name}'")
def step_impl(context,user,egg_name):
	expect = json.loads(context.text)[0]
	egg_page_id,egg_id = __egg_name2id(egg_name)#纯数字
	__Update_Egg(context,expect,egg_page_id,egg_id)

@then(u"{user}获得砸金蛋活动'{egg_name}'")
def step_impl(context,user,egg_name):
	expect = json.loads(context.text)[0]

	title = expect.get("name","")

	cr_start_date = expect.get('start_date', u'今天')
	start_date = bdd_util.get_date_str(cr_start_date)
	start_time = "{} 00:00".format(bdd_util.get_date_str(cr_start_date))

	cr_end_date = expect.get('end_date', u'1天后')
	end_date = bdd_util.get_date_str(cr_end_date)
	end_time = "{} 00:00".format(bdd_util.get_date_str(cr_end_date))

	valid_time = "%s~%s"%(start_time,end_time)

	desc = expect.get('desc','')#描述
	reduce_integral = expect.get('reduce_integral',0)#消耗积分
	send_integral = expect.get('send_integral',0)#参与送积分
	send_integral_rules = expect.get('send_integral_rules',"")#送积分规则
	egg_limit = __name2limit(expect.get('lottery_limit',u'一人一次'))#抽奖限制
	win_rate = expect.get('win_rate','0%').split('%')[0]#中奖率
	is_repeat_win = __name2Bool(expect.get('is_repeat_win',"true"))#重复中奖
	expect_prize_settings_list = expect.get('prize_settings',[])
	page_prize_settings,egg_prize_settings = __prize_settings_process(expect_prize_settings_list)


	obj = egg_models.Egg.objects.get(name=egg_name)#纯数字
	lottory_record = EggRecord.objects.filter(belong_to=str(obj.id))
	related_page_id = obj.related_page_id
	pagestore = pagestore_manager.get_pagestore('mongo')
	page = pagestore.get_page(related_page_id, 1)
	page_component = page['component']['components'][0]['components']

	prize_dic = {}
	for record in lottory_record:
		if not prize_dic.has_key(record.prize_title):
			prize_dic[record.prize_title] = 1
		else:
			prize_dic[record.prize_title] += 1

	expect_egg_dic = {
		"name":title,
		"start_time":start_time,
		"end_time":end_time,
		"expend":reduce_integral,#消耗积分
		"delivery":send_integral,#参与送积分
		"delivery_setting":__delivery2Bool(send_integral_rules),#送积分规则
		"limitation":egg_limit,#抽奖限制
		"chance":win_rate,#中奖率
		"allow_repeat":is_repeat_win,#重复中奖
		"prize_settings":page_prize_settings,
	}


	actual_prize_list=[]
	for comp in page_component:
		actual_prize_dic={}
		actual_prize_dic['title'] = comp['model']['title']
		actual_prize_dic['prize_count'] = comp['model']['prize_count']
		actual_prize_dic['leftCount'] = (comp['model']['prize_count'] - prize_dic.get(comp['model']['title'], 0)) if expect_prize_settings_list[page_component.index(comp)].has_key('rest') else ""
		actual_prize_dic['prize'] = {
			"type":comp['model']['prize']['type'],
			"data":comp['model']['prize']['data']
		}
		actual_prize_list.append(actual_prize_dic)

	actual_egg_dic = {
		"name": obj.name,
		"start_time":__datetime2str(obj.start_time),
		"end_time":__datetime2str(obj.end_time),
		"expend":obj.expend,#消耗积分
		"delivery":obj.delivery,#参与送积分
		"delivery_setting":obj.delivery_setting,#送积分规则
		"limitation":obj.limitation,#抽奖限制
		"chance":obj.chance,#中奖率
		"allow_repeat":obj.allow_repeat,#重复中奖
		"prize_settings":actual_prize_list,
	}

	bdd_util.assert_dict(expect_egg_dic, actual_egg_dic)

@when(u"{user}删除砸金蛋活动'{egg_name}'")
def step_impl(context,user,egg_name):
	egg_page_id,egg_id = __egg_name2id(egg_name)#纯数字
	del_response = __Delete_egg(context,egg_id)
	bdd_util.assert_api_call_success(del_response)

@when(u"{user}关闭砸金蛋活动'{egg_name}'")
def step_impl(context,user,egg_name):
	egg_page_id,egg_id = __egg_name2id(egg_name)#纯数字
	stop_response = __Stop_egg(context,egg_id)
	bdd_util.assert_api_call_success(stop_response)

@when(u"{user}设置砸金蛋活动列表查询条件")
def step_impl(context,user):
	expect = json.loads(context.text)
	if 'start_date' in expect:
		expect['start_time'] = __date2time(expect['start_date']) if expect['start_date'] else ""
		del expect['start_date']

	if 'end_date' in expect:
		expect['end_time'] = __date2time(expect['end_date']) if expect['end_date'] else ""
		del expect['end_date']

	search_dic = {
		"name": expect.get("name",""),
		"start_time": expect.get("start_time",""),
		"end_time": expect.get("end_time",""),
		"status": expect.get("status",u"全部")
	}
	search_response = __Search_egg(context,search_dic)
	egg_array = json.loads(search_response.content)['data']['items']
	context.search_egg = egg_array

@when(u"{user}访问砸金蛋活动列表第'{page_num}'页")
def step_impl(context,user,page_num):
	count_per_page = context.count_per_page
	context.paging = {'count_per_page':count_per_page,"page_num":page_num}

@when(u"{user}访问砸金蛋活动列表下一页")
def step_impl(context,user):
	paging_dic = context.paging
	count_per_page = paging_dic['count_per_page']
	page_num = int(paging_dic['page_num'])+1
	context.paging = {'count_per_page':count_per_page,"page_num":page_num}

@when(u"{user}访问砸金蛋活动列表上一页")
def step_impl(context,user):
	paging_dic = context.paging
	count_per_page = paging_dic['count_per_page']
	page_num = int(paging_dic['page_num'])-1
	context.paging = {'count_per_page':count_per_page,"page_num":page_num}

@when(u"{user}查看砸金蛋活动'{egg_name}'")
def check_egg_list(context,user,egg_name):
	design_mode = 0
	version = 1
	page = 1

	if hasattr(context,"enable_paginate"):
		enable_paginate = context.enable_paginate
	else:
		enable_paginate = 1
	if hasattr(context,"count_per_page"):
		count_per_page = context.count_per_page
	else:
		count_per_page = 10


	if hasattr(context,"paging"):
		paging_dic = context.paging
		count_per_page = paging_dic['count_per_page']
		page = paging_dic['page_num']

	egg_page_id,egg_id = __egg_name2id(egg_name)#纯数字
	url ='/apps/egg/api/egg_participances/?design_mode={}&version={}&id={}&count_per_page={}&page={}&enable_paginate={}&_method=get'.format(
			design_mode,
			version,
			egg_id,
			count_per_page,
			page,
			enable_paginate,
		)
	url = bdd_util.nginx(url)
	response = context.client.get(url)
	context.participances = json.loads(response.content)
	context.egg_id = "%s"%(egg_id)


@then(u"{webapp_user_name}获得砸金蛋活动'{power_me_rule_name}'的结果列表")
def step_tmpl(context, webapp_user_name, power_me_rule_name):

	if hasattr(context,"search_egg_result"):
		participances = context.search_egg_result
	else:
		participances = context.participances['data']['items']
	actual = []

	for p in participances:
		p_dict = OrderedDict()
		p_dict[u"member_name"] = p['participant_name']
		p_dict[u"mobile"] = p['tel']
		p_dict[u"prize_grade"] = p['prize_title']
		p_dict[u"prize_name"] = p['prize_name']
		p_dict[u"lottery_time"] = bdd_util.get_date_str(p['created_at'])
		p_dict[u"receive_status"] = u'已领取' if p['status'] else u'未领取'
		p_dict[u"actions"] = u'' if p['status'] else u'领取'
		actual.append((p_dict))
	print("actual_data: {}".format(actual))
	expected = []
	if context.table:
		for row in context.table:
			cur_p = row.as_dict()
			if cur_p['lottery_time']:
				cur_p['lottery_time'] = bdd_util.get_date_str(cur_p['lottery_time'])
			expected.append(cur_p)
	else:
		expected = json.loads(context.text)
	print("expected: {}".format(expected))

	bdd_util.assert_list(expected, actual)

@when(u"{user}设置砸金蛋活动结果列表查询条件")
def step_impl(context,user):
	expect = json.loads(context.text)

	if 'lottery_start_time' in expect:
		expect['start_time'] = __date2time(expect['lottery_start_time']) if expect['lottery_start_time'] else ""
		del expect['lottery_start_time']

	if 'lottery_end_time' in expect:
		expect['end_time'] = __date2time(expect['lottery_end_time']) if expect['lottery_end_time'] else ""
		del expect['lottery_end_time']

	print("expected: {}".format(expect))
	id = context.egg_id
	participant_name = expect.get("member_name","")
	start_time = expect.get("start_time","")
	end_time = expect.get("end_time","")
	prize_type = expect.get("prize_type",u"全部")
	status = expect.get("status",u"全部")
	search_dic = {
		"id":id,
		"participant_name":participant_name,
		"start_time":start_time,
		"end_time":end_time,
		"prize_type":prize_type,
		"status":status
	}

	search_response = __Search_egg_Result(context,search_dic)
	egg_result_array = json.loads(search_response.content)['data']['items']
	context.search_egg_result = egg_result_array

@when(u"{user}访问砸金蛋活动'{egg_name}'的结果列表第'{page_num}'页")
def step_impl(context,user,egg_name,page_num):
	count_per_page = context.count_per_page
	context.paging = {'count_per_page':count_per_page,"page_num":page_num}
	check_egg_list(context,user,egg_name)

@when(u"{user}访问砸金蛋活动'{egg_name}'的结果列表下一页")
def step_impl(context,user,egg_name):
	paging_dic = context.paging
	count_per_page = paging_dic['count_per_page']
	page_num = int(paging_dic['page_num'])+1
	context.paging = {'count_per_page':count_per_page,"page_num":page_num}
	check_egg_list(context,user,egg_name)

@when(u"{user}访问砸金蛋活动'{egg_name}'的结果列表上一页")
def step_impl(context,user,egg_name):
	paging_dic = context.paging
	count_per_page = paging_dic['count_per_page']
	page_num = int(paging_dic['page_num'])-1
	context.paging = {'count_per_page':count_per_page,"page_num":page_num}
	check_egg_list(context,user,egg_name)

# @then(u"{user}能批量导出砸金蛋'{egg_name}'")
# def step_impl(context,user,egg_name):
# 	egg_page_id,egg_id = __egg_name2id(egg_name)#纯数字
# 	url ='/apps/egg/api/egg_participances_export/?_method=get&export_id=%s' % (egg_id)
# 	url = bdd_util.nginx(url)
# 	response = context.client.get(url)
# 	bdd_util.assert_api_call_success(response)