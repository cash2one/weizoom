#_author_:张三香 2015.12.03

Feature:微信投票-统计

Background:
	Given jobs登录系统
	When jobs添加优惠券规则
		"""
		[{
			"name": "优惠券1",
			"money": 100.00,
			"count": 5,
			"limit_counts": "无限",
			"using_limit": "满50元可以使用",
			"start_date": "今天",
			"end_date": "1天后",
			"coupon_id_prefix": "coupon1_id_"
		}]
		"""
	When jobs新建微信投票活动
		"""
		[{
			"title":"微信投票01",
			"subtitle":"微信投票01",
			"content":"谢谢投票",
			"start_date":"今天",
			"end_date":"2天后",
			"permission":"无需关注即可参与",
			"prize_type":"优惠券",
			"coupon":"优惠券1",
			"text_options":
				[{
					"title":"选择题1",
					"type":"单选",
					"is_required":"是",
					"option":[{
							"options":"1"
						},{
							"options":"2"
						},{
							"options":"3"
					}]
				},{
					"title":"选择题2",
					"type":"多选",
					"is_required":"否",
					"option":[{
							"options":"A"
						},{
							"options":"B"
						},{
							"options":"C"
					}]
				}],
			"participate_info":[{
				"items_select":[{
							"item_name":"姓名",
							"is_selected":true
						},{
							"item_name":"手机",
							"is_selected":true
						},{
							"item_name":"邮箱",
							"is_selected":true
						},{
							"item_name":"QQ",
							"is_selected":"false"
						},{
							"item_name":"职位",
							"is_selected":"false"
						},{
							"item_name":"住址",
							"is_selected":"false"
						}],
				"items_add":[{
						"item_name":"填写项1",
						"is_required":"是"
					},{
						"item_name":"填写项2",
						"is_required":"否"
					}]
				}]
		}]
		"""

	When bill关注jobs的公众号
	When tom关注jobs的公众号
	When tom1关注jobs的公众号
	When tom2关注jobs的公众号


	When bill参加微信投票活动"微信投票01"于"2天前"
		"""
		{
			"文本选项":
				[{
					"title":"选择题1",
					"value":[{
							"title":"1",
							"type":"单选",
							"isSelect":"是"
						},{
							"title":"2",
							"type":"单选",
							"isSelect":"否"
						},{
							"title":"3",
							"type":"单选",
							"isSelect":"否"
						}]
				},{
					"title":"选择题2",
					"value":[{
							"title":"A",
							"type":"多选",
							"isSelect":"是"
						},{
							"title":"B",
							"type":"多选",
							"isSelect":"否"
						},{
							"title":"C",
							"type":"多选",
							"isSelect":"否"
						}]
				}],
			"参与人信息":
				[{
					"value":{
						"姓名":"bill",
						"手机":"15111223344",
						"邮箱":"1234@qq.com",
						"填写项1":"11",
						"填写项2":""
					}
				}]
		}
		"""
	When tom参加微信投票活动"微信投票01"于"昨天"
		"""
		{
			"文本选项":
				[{
					"title":"选择题1",
					"value":[{
							"title":"1",
							"type":"单选",
							"isSelect":"否"
						},{
							"title":"2",
							"type":"单选",
							"isSelect":"是"
						},{
							"title":"3",
							"type":"单选",
							"isSelect":"否"
						}]
				},{
					"title":"选择题2",
					"value":[{
							"title":"A",
							"type":"多选",
							"isSelect":"否"
						},{
							"title":"B",
							"type":"多选",
							"isSelect":"是"
						},{
							"title":"C",
							"type":"多选",
							"isSelect":"否"
						}]
				}],
			"参与人信息":
				[{
					"value":{
						"姓名":"tom",
						"手机":"15211223344",
						"邮箱":"2234@qq.com",
						"填写项1":"22",
						"填写项2":""
					}
				}]
		}
		"""
	When tom1参加微信投票活动"微信投票01"于"今天"
		"""
		{
			"文本选项":
				[{
					"title":"选择题1",
					"value":[{
							"title":"1",
							"type":"单选",
							"isSelect":"是"
						},{
							"title":"2",
							"type":"单选",
							"isSelect":"否"
						},{
							"title":"3",
							"type":"单选",
							"isSelect":"否"
						}]
				},{
					"title":"选择题2",
					"value":[{
							"title":"A",
							"type":"多选",
							"isSelect":"否"
						},{
							"title":"B",
							"type":"多选",
							"isSelect":"是"
						},{
							"title":"C",
							"type":"多选",
							"isSelect":"否"
						}]
				}],
			"参与人信息":
				[{
					"value":{
						"姓名":"tom1",
						"手机":"15311223344",
						"邮箱":"3234@qq.com",
						"填写项1":"33",
						"填写项2":""
					}
				}]
		}
		"""
	When tom2参加微信投票活动"微信投票01"于"今天"
		"""
		{
			"文本选项":
				[{
					"title":"选择题1",
					"value":[{
							"title":"1",
							"type":"单选",
							"isSelect":"否"
						},{
							"title":"2",
							"type":"单选",
							"isSelect":"否"
						},{
							"title":"3",
							"type":"单选",
							"isSelect":"是"
						}]
				},{
					"title":"选择题2",
					"value":[{
							"title":"A",
							"type":"多选",
							"isSelect":"是"
						},{
							"title":"B",
							"type":"多选",
							"isSelect":"否"
						},{
							"title":"C",
							"type":"多选",
							"isSelect":"否"
						}]
				}],
			"参与人信息":
				[{
					"value":{
						"姓名":"tom2",
						"手机":"15411223344",
						"邮箱":"4234@qq.com",
						"填写项1":"44",
						"填写项2":""
					}
				}]
		}
		"""

@mall2 @apps @vote @vote_statistics
Scenario:1 访问微信投票的统计
	Given jobs登录系统
	When jobs访问微信投票活动'微信投票01'的统计
	Then jobs获得微信投票活动'微信投票01'的统计结果
		"""
		[{
			"participate_count":4,
			"title":"选择题1",
			"type":"单选",
			"values":
				[{
					"options":"1",
					"count":2,
					"percent":"50%"
				},{
					"options":"2",
					"count":1,
					"percent":"25%"
				},{
					"options":"3",
					"count":1,
					"percent":"25%"
				}]
		},{
			"participate_count":4,
			"title":"选择题2",
			"type":"多选",
			"values":
				[{
					"options":"A",
					"count":2,
					"percent":"50%"
				},{
					"options":"B",
					"count":2,
					"percent":"50%"
				},{
					"options":"C",
					"count":0,
					"percent":"0%"
				}]
		}]
		"""
