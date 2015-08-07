# __edit__ : "benchi"
Feature: 在webapp中购买参与买赠活动的商品
	用户能在webapp中购买"参与买赠活动的商品"

Background:
	Given jobs登录系统
	And jobs已添加商品规格
		"""
		[{
			"name": "尺寸",
			"type": "文字",
			"values": [{
				"name": "M"
			}, {
				"name": "S"
			}]
		}]
		"""
	And jobs已添加商品
		"""
		[{
			"name": "商品1",
			"price": 100.00,
			"model": {
				"models": {
					"standard": {
						"price": 100.00,
						"stock_type": "有限",
						"stocks": 5
					}
				}
			}
		}, {
			"name": "商品2",
			"price": 200.00
		}, {
			"name": "商品3",
			"price": 50.00
		}, {
			"name": "商品4",
			"model": {
				"models": {
					"standard": {
						"price": 40.00,
						"stock_type": "有限",
						"stocks": 20
					}
				}
			}
		}, {
			"name": "商品5",
			"is_enable_model": "启用规格",
			"model": {
				"models":{
					"M": {
						"price": 7,
						"stock_type": "有限",
						"stocks": 2
					},
					"S": {
						"price": 8,
						"stock_type": "无限"
					}
				}
			}
		}]
		"""
	#支付方式
	Given jobs已添加支付方式
		"""
		[{
			"type": "微信支付",
			"is_active": "启用"
		}, {
			"type": "货到付款",
			"is_active": "启用"
		}]
		"""
	When jobs创建买赠活动
		"""
		[{
			"name": "商品1买二赠一",
			"start_date": "今天",
			"end_date": "1天后",
			"products": ["商品1"],
			"premium_products": [{
				"name": "商品2",
				"count": 1
			}, {
				"name": "商品3",
				"count": 2
			}],
			"count": 2,
			"is_enable_cycle_mode": true
		}, {
			"name": "商品2买一赠一",
			"start_date": "今天",
			"end_date": "1天后",
			"products": ["商品2"],
			"premium_products": [{
				"name": "商品4",
				"count": 5
			}],
			"count": 1,
			"is_enable_cycle_mode": true
		}, {
			"name": "商品5买一赠一",
			"start_date": "今天",
			"end_date": "1天后",
			"products": ["商品5"],
			"premium_products": [{
				"name": "商品4",
				"count": 1
			}],
			"count": 1,
			"is_enable_cycle_mode": true
		}]
		"""
	Given bill关注jobs的公众号
	And tom关注jobs的公众号
	And marry1关注jobs的公众号
	And marry2关注jobs的公众号
	And marry3关注jobs的公众号
	And marry4关注jobs的公众号


@mall2 @mall.promotion @mall.webapp.promotion
Scenario: 1 购买买赠商品，不满足买赠基数

	When bill访问jobs的webapp
	When bill购买jobs的商品
		"""
		{
			"products": [{
				"name": "商品1",
				"count": 1
			}]
		}
		"""
	Then bill成功创建订单
		"""
		{
			"status": "待支付",
			"final_price": 100.00,
			"products": [{
				"name": "商品1",
				"count": 1,
				"promotion": null
			}]
		}
		"""


@mall2 @mall.promotion @mall.webapp.promotion
Scenario: 2 购买买赠活动商品，满足买赠基数

	When bill访问jobs的webapp
	When bill购买jobs的商品
		"""
		{
			"products": [{
				"name": "商品1",
				"count": 2
			}]
		}
		"""
	Then bill成功创建订单
		"""
		{
			"status": "待支付",
			"final_price": 200.00,
			"products": [{
				"name": "商品1",
				"count": 2,
				"promotion": {
					"type": "premium_sale"
				}
			}, {
				"name": "商品2",
				"count": 1,
				"promotion": {
					"type": "premium_sale:premium_product"
				}
			}, {
				"name": "商品3",
				"count": 2,
				"promotion": {
					"type": "premium_sale:premium_product"
				}
			}]
		}
		"""


@mall2 @mall.promotion @mall.webapp.promotion
Scenario: 3 购买多个买赠活动商品，满足买赠基数，并满足循环买赠
	商品2满足循环买赠，赠品应该累加
	赠品数量刚好等于赠品库存

	When bill访问jobs的webapp
	When bill购买jobs的商品
		"""
		{
			"products": [{
				"name": "商品1",
				"count": 2
			}, {
				"name": "商品2",
				"count": 4
			}]
		}
		"""
	Then bill成功创建订单
		"""
		{
			"status": "待支付",
			"final_price": 1000.00,
			"products": [{
				"name": "商品1",
				"count": 2,
				"promotion": {
					"type": "premium_sale"
				}
			}, {
				"name": "商品2",
				"count": 1,
				"promotion": {
					"type": "premium_sale:premium_product"
				}
			}, {
				"name": "商品3",
				"count": 2,
				"promotion": {
					"type": "premium_sale:premium_product"
				}
			}, {
				"name": "商品2",
				"count": 4,
				"promotion": {
					"type": "premium_sale"
				}
			}, {
				"name": "商品4",
				"count": 20,
				"promotion": {
					"type": "premium_sale:premium_product"
				}
			}]
		}
		"""


@mall2 @mall.promotion @mall.webapp.promotion
Scenario: 4 购买单个买赠商品，超出库存限制
	第一次购买2个，成功；第二次购买4个，超出商品库存，确保缓存更新

	When bill访问jobs的webapp
	When bill购买jobs的商品
		"""
		{
			"products": [{
				"name": "商品1",
				"count": 2
			}]
		}
		"""
	Then bill成功创建订单
		"""
		{
			"status": "待支付",
			"final_price": 200.0
		}
		"""
	When bill购买jobs的商品
		"""
		{
			"products": [{
				"name": "商品1",
				"count": 4
			}]
		}
		"""
	Then bill获得创建订单失败的信息
		"""
		{
			"detail": [{
				"id": "商品1",
				"msg": "有商品库存不足，请重新下单",
				"short_msg": "库存不足"
			}]
		}
		"""


@mall2 @mall.promotion @mall.webapp.promotion
Scenario: 5 购买单个买赠商品，赠品数量超出库存限制

	When bill访问jobs的webapp
	When bill购买jobs的商品
		"""
		{
			"products": [{
				"name": "商品2",
				"count": 5
			}]
		}
		"""
	Then bill获得创建订单失败的信息
		"""
		{
			"detail": [{
				"id": "商品4",
				"msg": "库存不足",
				"short_msg": "库存不足"
			}]
		}
		"""


@mall2 @mall.promotion @mall.webapp.promotion
Scenario: 6 购买多个 有规格的参与买赠的商品

	When bill访问jobs的webapp
	When bill购买jobs的商品
		"""
		{
			"products": [{
				"name": "商品5",
				"model": "M",
				"count": 1
			}, {
				"name": "商品5",
				"model": "S",
				"count": 2
			}]
		}
		"""
	Then bill成功创建订单
		"""
		{
			"status": "待支付",
			"final_price": 23.00,
			"products": [{
				"name": "商品5",
				"count": 1,
				"model": "M",
				"promotion": {
					"type": "premium_sale"
				}
			}, {
				"name": "商品5",
				"count": 2,
				"model": "S",
				"promotion": {
					"type": "premium_sale"
				}
			}, {
				"name": "商品4",
				"count": 3,
				"promotion": {
					"type": "premium_sale:premium_product"
				}
			}]
		}
		"""

@mall2 @mall.promotion @mall.webapp.promotion
Scenario: 7  创建多规格商品 非循环买赠活动，购买多个 有规格的参与买赠的商品 赠品只赠送一次
	Given jobs登录系统
	And jobs已添加商品
	"""
		[{
			"name": "商品6",
			"is_enable_model": "启用规格",
			"model": {
				"models":{
					"M": {
						"price": 7,
						"stock_type": "有限",
						"stocks": 2
					},
					"S": {
						"price": 8,
						"stock_type": "无限"
					}
				}
			}
		}]
	"""
	When jobs创建买赠活动
	"""
		[{
			"name": "商品6买一赠一",
			"start_date": "今天",
			"end_date": "1天后",
			"products": ["商品6"],
			"premium_products": [{
				"name": "商品4",
				"count": 1
			}],
			"count": 1,
			"is_enable_cycle_mode": false
		}]
	"""
	When bill访问jobs的webapp
	When bill购买jobs的商品
		"""
		{
			"products": [{
				"name": "商品6",
				"model": "M",
				"count": 1
			}, {
				"name": "商品6",
				"model": "S",
				"count": 2
			}]
		}
		"""
	Then bill成功创建订单
		"""
		{
			"status": "待支付",
			"final_price": 23.00,
			"products": [{
				"name": "商品6",
				"count": 1,
				"model": "M",
				"promotion": {
					"type": "premium_sale"
				}
			}, {
				"name": "商品6",
				"count": 2,
				"model": "S",
				"promotion": {
					"type": "premium_sale"
				}
			}, {
				"name": "商品4",
				"count": 1,
				"promotion": {
					"type": "premium_sale:premium_product"
				}
			}]
		}
		"""
@mall2 @mall.promotion @mall.webapp.promotion
Scenario: 8  多规格商品，买2赠1 循环买赠
	Given jobs登录系统
	And jobs已添加商品
	"""
		[{
			"name": "商品8",
			"is_enable_model": "启用规格",
			"model": {
				"models":{
					"M": {
						"price": 7,
						"stock_type": "无限"

					},
					"S": {
						"price": 8,
						"stock_type": "无限"
					}
				}
			}
		}]
	"""

	When jobs创建买赠活动
	"""
		[{
			"name": "商品8买二赠一",
			"start_date": "今天",
			"end_date": "1天后",
			"products": ["商品8"],
			"premium_products": [{
				"name": "商品4",
				"count": 1
			}],
			"count": 2,
			"is_enable_cycle_mode": true
		}]
	"""
	When bill访问jobs的webapp
	When bill购买jobs的商品
		"""
		{
			"products": [{
				"name": "商品8",
				"model": "M",
				"count": 1
			}, {
				"name": "商品8",
				"model": "S",
				"count": 1
			}]
		}
		"""
	Then bill成功创建订单
		"""
		{
			"status": "待支付",
			"final_price": 15.00,
			"products": [{
				"name": "商品8",
				"count":1,
				"model": "M",
				"promotion": {
					"type": "premium_sale"
				}
			}, {
				"name": "商品8",
				"count": 1,
				"model": "S",
				"promotion": {
					"type": "premium_sale"
				}
			}, {
				"name": "商品4",
				"count": 1,
				"promotion": {
					"type": "premium_sale:premium_product"
				}
			}]
		}
		"""

@mall2 @mall.promotion @mall.webapp.promotion
Scenario: 9  创建买赠活动，但活动时间没开始，按原有商品销售，不进行赠送
	Given jobs登录系统
	And jobs已添加商品
	"""
		[{
			"name": "商品9",
			"price": 200.00
		}]
	"""
	When jobs创建买赠活动
	"""
		[{
			"name": "商品9买1赠1",
			"start_date": "1天后",
			"end_date": "3天后",
			"products": ["商品9"],
			"premium_products": [{
				"name": "商品4",
				"count": 1
			}],
			"count": 1,
			"is_enable_cycle_mode": true
		}]
	"""
	When bill访问jobs的webapp
	When bill购买jobs的商品
		"""
		{
			"products": [{
				"name": "商品9",
				"count": 1
			}]
		}
		"""
	Then bill成功创建订单
		"""
		{
			"status": "待支付",
			"final_price": 200.00,
			"products": [{
				"name": "商品9",
				"count":1
			}]
		}
		"""

@mall2 @mall.promotion @mall.webapp.promotion
Scenario: 10  创建买赠活动，但活动时间没开始，按原有商品销售，不进行赠送
	Given jobs登录系统
	And jobs已添加商品
	"""
		[{
			"name": "商品9",
			"price": 200.00
		}]
	"""
	When jobs创建买赠活动
	"""
		[{
			"name": "商品9买1赠1",
			"start_date": "1天后",
			"end_date": "3天后",
			"products": ["商品9"],
			"premium_products": [{
				"name": "商品4",
				"count": 1
			}],
			"count": 1,
			"is_enable_cycle_mode": true
		}]
	"""
	When bill访问jobs的webapp
	When bill购买jobs的商品
		"""
		{
			"products": [{
				"name": "商品9",
				"count": 1
			}]
		}
		"""
	Then bill成功创建订单
		"""
		{
			"status": "待支付",
			"final_price": 200.00,
			"products": [{
				"name": "商品9",
				"count":1
			}]
		}
		"""

@mall2 @mall.promotion @mall.webapp.promotion
Scenario: 11  创建买赠活动，选择商品时，活动进行中，但去付款时，活动已经结束了，系统提示：该活动已经过期
	Given jobs登录系统
	And jobs已添加商品
	"""
		[{
			"name": "商品10",
			"price": 200.00
		}]
	"""
	When jobs创建买赠活动
	"""
		[{
			"name": "商品10买1赠1",
			"start_date": "2天前",
			"end_date": "1天前",
			"products": ["商品10"],
			"premium_products": [{
				"name": "商品4",
				"count": 1
			}],
			"count": 1,
			"is_enable_cycle_mode": true
		}]
	"""
	When bill访问jobs的webapp
	When bill购买jobs的商品
		"""
		{
			"products": [{
				"name": "商品10",
				"count": 1
			}]
		}
		"""
	Then bill获得创建订单失败的信息
		"""
		{
			"detail": [{
				"id": "商品10",
				"msg": "该活动已经过期",
				"short_msg": "已经过期"
			}]
		}
		"""

@mall2 @mall.promotion @mall.webapp.promotion
Scenario: 12 购买单个买赠活动商品，购买时活动进行中，提交订单时，该活动被商家手工结束

	Given jobs登录系统
	And jobs已添加商品
	"""
		[{
			"name": "商品10",
			"price": 200.00
		}]
	"""
	When jobs创建买赠活动
	"""
		[{
			"name": "商品10买1赠1",
			"start_date": "1天前",
			"end_date": "3天后",
			"products": ["商品10"],
			"premium_products": [{
				"name": "商品4",
				"count": 1
			}],
			"count": 1,
			"is_enable_cycle_mode": true
		}]
	"""
	Given jobs登录系统
	When jobs结束促销活动'商品10买1赠1'
	When bill访问jobs的webapp
	And bill购买jobs的商品
		"""
		{
			"products": [{
				"name": "商品10",
				"count": 1,
				"promotion": {
					"name": "商品10买1赠1"
				}
			}]
		}
		"""

	Then bill获得创建订单失败的信息
		"""
		{
			"detail": [{
				"id": "商品10",
				"msg": "该活动已经过期",
				"short_msg": "已经过期"
			}]
		}
		"""

# __edit__ : 王丽   补充
Scenario: 13 不同等级的会员购买会员价，同时有会员等级买赠活动的商品
	
	Given jobs添加会员等级
		"""
		[{
			"name": "铜牌会员",
			"upgrade": "手动升级",
			"shop_discount": "90%"
		}, {
			"name": "银牌会员",
			"upgrade": "手动升级",
			"shop_discount": "80%"
		}, {
			"name": "金牌会员",
			"upgrade": "手动升级",
			"shop_discount": "70%"
		}]
		"""

	And jobs已添加商品
		"""
		[{
				"name": "商品赠品",
				"member_price": true,
				"model": {
					"models": {
						"standard": {
							"price": 10.00,
							"stock_type": "有限",
							"stocks": 100
						}
					}
				}
			},{
				"name": "商品6",
				"member_price": true,
				"model": {
					"models": {
						"standard": {
							"price": 100.00,
							"stock_type": "有限",
							"stocks": 100
						}
					}
				}
			},{
				"name": "商品7",
				"member_price": true,
				"is_enable_model": "启用规格",
				"model": {
					"models":{
						"M": {
							"price": 300,
							"stock_type": "无限"
						},
						"S": {
							"price": 300,
							"stock_type": "无限"
						}
					}
				}
		},{
				"name": "商品8",
				"member_price": false,
				"model": {
					"models": {
						"standard": {
							"price": 100.00,
							"stock_type": "有限",
							"stocks": 100
						}
					}
				}
			}]
		"""

	And jobs调整会员等级
		"""
		[{
			"name":"marry2",
			"member_rank":"铜牌会员"
		},{
			"name":"marry3",
			"member_rank":"银牌会员"
		},{
			"name":"marry4",
			"member_rank":"金牌会员"
		}]
		"""

	When jobs创建买赠活动
		"""
		[{
			"name": "商品6买一赠二",
			"start_date": "今天",
			"end_date": "1天后",
			"products": ["商品6"],
			"premium_products": [{
				"name": "商品6",
				"count": 1
			},{
				"name": "商品赠品",
				"count": 1
			}],
			"count": 1,
			"member_grade_name":"金牌会员",
			"is_enable_cycle_mode": true
		},{
			"name": "商品7买二赠二",
			"start_date": "今天",
			"end_date": "1天后",
			"products": ["商品7"],
			"premium_products": [{
				"name": "商品赠品”,
				"count": 2
			}],
			"count": 2,
			"member_grade_name":"全部会员",
			"is_enable_cycle_mode": true
		},{
			"name": "商品8买一赠一",
			"start_date": "今天",
			"end_date": "1天后",
			"products": ["商品8"],
			"premium_products": [{
				"name": "商品赠品”,
				"count": 1
			}],
			"count": 1,
			"member_grade_name":"铜牌会员",
			"is_enable_cycle_mode": true
		}]
		"""


	#购买有单会员等级买赠活动，无会员价商品”商品8“

		#普通会员等级的会员marry1,购买铜牌会员等级买赠活动商品"商品8"，按照原价购买，无赠品
			When marry1访问jobs的webapp
			And marry1购买jobs的商品
				"""
				{
					"ship_name": "marry1",
					"ship_tel": "12345678911",
					"ship_area": "北京市 北京市 海淀区",
					"ship_address": "泰兴大厦",
					"products": [{
						"name": "商品8",
						"count": 1
					}]
				}
				"""
			Then marry1成功创建订单
				"""
				{
					"status": "待支付",
					"ship_name": "marry1",
					"ship_tel": "12345678911",
					"ship_area": "北京市 北京市 海淀区",
					"ship_address": "泰兴大厦",
					"final_price": 100,
					"member_price":100.00,
					"members_money":0.00,
					"products": [{
						"name": "商品8",
						"price": 100,
						"count": 1
					}]
				}
				"""

		#铜牌会员等级的会员marry2,购买铜牌会员等级买赠活动商品"商品8"，按照原价购买，有赠品
			When marry2访问jobs的webapp
			And marry2购买jobs的商品
				"""
				{
					"ship_name": "marry2",
					"ship_tel": "12345678912",
					"ship_area": "北京市 北京市 海淀区",
					"ship_address": "泰兴大厦2",
					"products": [{
						"name": "商品8",
						"count": 1
					}]
				}
				"""
			Then marry2成功创建订单
				"""
				{
					"status": "待支付",
					"ship_name": "marry2",
					"ship_tel": "12345678912",
					"ship_area": "北京市 北京市 海淀区",
					"ship_address": "泰兴大厦2",
					"final_price": 100,
					"member_price":100.00,
					"members_money":0.00,
					"products": [{
						"name": "商品8",
						"price": 100,
						"count": 1
					},{
						"name": "商品赠品",
						"price": 10,
						"count": 1
					}]
				}
				"""

	#购买有单会员等级买赠活动，有会员价商品”商品6“

		#铜牌会员等级的会员marry2,购买金牌会员等级买赠活动商品"商品6"，按照会员价购买，无赠品
			When marry2访问jobs的webapp
			And marry2购买jobs的商品
				"""
				{
					"ship_name": "marry2",
					"ship_tel": "12345678912",
					"ship_area": "北京市 北京市 海淀区",
					"ship_address": "泰兴大厦2",
					"products": [{
						"name": "商品6",
						"count": 1
					}]
				}
				"""
			Then marry2成功创建订单
				"""
				{
					"status": "待支付",
					"ship_name": "marry2",
					"ship_tel": "12345678912",
					"ship_area": "北京市 北京市 海淀区",
					"ship_address": "泰兴大厦2",
					"final_price": 90,
					"member_price":90.00,
					"members_money":10.00,
					"products": [{
						"name": "商品6",
						"price": 100,
						"count": 1
					}]
				}
				"""

		#金牌会员等级的会员marry4,购买金牌会员等级买赠活动商品"商品6"，按照原价购买，有赠品
			When marry4访问jobs的webapp
			And marry4购买jobs的商品
				"""
				{
					"ship_name": "marry4",
					"ship_tel": "12345678914",
					"ship_area": "北京市 北京市 海淀区",
					"ship_address": "泰兴大厦4",
					"products": [{
						"name": "商品6",
						"count": 1
					}]
				}
				"""
			Then marry4成功创建订单
				"""
				{
					"status": "待支付",
					"ship_name": "marry4",
					"ship_tel": "12345678914",
					"ship_area": "北京市 北京市 海淀区",
					"ship_address": "泰兴大厦4",
					"final_price": 100,
					"member_price":100.00,
					"members_money":0.00,
					"products": [{
						"name": "商品6",
						"price": 100,
						"count": 2
					},{
						"name": "商品赠品",
						"price": 10,
						"count": 1
					}]
				}
				"""

	#购买全部会员等级买赠活动，有会员价多规格商品”商品7“

		#普通会员等级的会员marry1,购买全部会员等级买赠活动，有会员价商品"商品7"，单规格没有达到买赠数量条件，按照原价购买，无赠品
			When marry1访问jobs的webapp
			And marry1购买jobs的商品
				"""
				{
					"ship_name": "marry1",
					"ship_tel": "12345678911",
					"ship_area": "北京市 北京市 海淀区",
					"ship_address": "泰兴大厦",
					"products": [{
						"name": "商品7",
						"model": "M"
						"count": 1
					}]
				}
				"""
			Then marry1成功创建订单
				"""
				{
					"status": "待支付",
					"ship_name": "marry1",
					"ship_tel": "12345678911",
					"ship_area": "北京市 北京市 海淀区",
					"ship_address": "泰兴大厦",
					"final_price": 300,
					"member_price":300.00,
					"members_money":0.00,
					"products": [{
						"name": "商品7",
						"model": "M"
						"price": 300,
						"count": 1
					}]
				}
				"""

		#银牌会员等级的会员marry3,购买全部会员等级买赠活动，有会员价商品"商品7"，整体数量达到买赠数量条件，单规格没有达到买赠数量条件，按照原价购买，无赠品
			When marry3访问jobs的webapp
			And marry3购买jobs的商品
				"""
				{
					"ship_name": "marry3",
					"ship_tel": "12345678913",
					"ship_area": "北京市 北京市 海淀区",
					"ship_address": "泰兴大厦3",
					"products": [{
						"name": "商品7",
						"model": "M"
						"count": 1
					},{
						"name": "商品7",
						"model": "s"
						"count": 1
					}]
				}
				"""
			Then marry3成功创建订单
				"""
				{
					"status": "待支付",
					"ship_name": "marry3",
					"ship_tel": "12345678913",
					"ship_area": "北京市 北京市 海淀区",
					"ship_address": "泰兴大厦3",
					"final_price": 600,
					"member_price":600.00,
					"members_money":0.00,
					"products": [{
						"name": "商品7",
						"model": "M"
						"price": 300,
						"count": 1
					},{
						"name": "商品7",
						"model": "s"
						"price": 300,
						"count": 1
					}]
				}
				"""

		#金牌会员等级的会员marry4,购买全部会员等级买赠活动，有会员价商品"商品7"，整体数量达到买赠数量条件，单规格达到买赠数量条件，按照原价购买，有赠品
			When marry4访问jobs的webapp
			And marry4购买jobs的商品
				"""
				{
					"ship_name": "marry4",
					"ship_tel": "12345678914",
					"ship_area": "北京市 北京市 海淀区",
					"ship_address": "泰兴大厦4",
					"products": [{
						"name": "商品7",
						"model": "M"
						"count": 3
					},{
						"name": "商品7",
						"model": "s"
						"count": 3
					}]
				}
				"""
			Then marry4成功创建订单
				"""
				{
					"status": "待支付",
					"ship_name": "marry4",
					"ship_tel": "12345678914",
					"ship_area": "北京市 北京市 海淀区",
					"ship_address": "泰兴大厦4",
					"final_price": 1800,
					"member_price":1800.00,
					"members_money":0.00,
					"products": [{
						"name": "商品7",
						"model": "M"
						"price": 300,
						"count": 3
					},{
						"name": "商品7",
						"model": "s"
						"price": 300,
						"count": 3
					},{
						"name": "商品赠品",
						"price": 10,
						"count": 4
					}]
				}
				"""


	

