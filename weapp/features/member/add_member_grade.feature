# __author__ : "冯雪静"
Feature: 增加会员等级
	Jobs能添加会员等级


Background:
	Given jobs登录系统
	Then jobs能获取会员等级列表
		"""
		[{
			"name": "普通会员",
			"upgrade": "自动升级",
			"shop_discount": "100%"
		}]
		"""


Scenario: 1 添加手动升级的会员等级
	jobs添加多组手动升级的"会员等级"后，"会员等级列表"会按照添加的顺序正序排列

	Given jobs登录系统
	When jobs添加会员等级
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
	Then jobs能获取会员等级列表
		"""
		[{
			"name": "普通会员",
			"upgrade": "自动升级",
			"shop_discount": "100%"
		}, {
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


Scenario: 2 添加自动升级的会员等级
	jobs添加多组自动升级的"会员等级"后，"会员等级列表"会按照添加的顺序正序排列

	Given jobs登录系统
	When jobs开启自动升级
		"""
		{
			"upgrade": "自动升级",
			"condition": ["满足一个条件即可"]
		}
		"""
	When jobs添加会员等级
		"""
		[{
			"name": "铜牌会员",
			"upgrade": "自动升级",
			"deal_price": 1000.00,
			"buy_counts": 20,
			"empirical_value": 10000,
			"shop_discount": "90%"
		}, {
			"name": "银牌会员",
			"upgrade": "自动升级",
			"deal_price": 3000.00,
			"buy_counts": 30,
			"empirical_value": 30000,
			"shop_discount": "80%"
		}, {
			"name": "金牌会员",
			"upgrade": "自动升级",
			"deal_price": 5000.00,
			"buy_counts": 50,
			"empirical_value": 50000,
			"shop_discount": "70%"
		}]
		"""
	Then jobs能获取会员等级列表
		"""
		[{
			"name": "普通会员",
			"upgrade": "自动升级",
			"shop_discount": "100%"
		}, {
			"name": "铜牌会员",
			"upgrade": "自动升级",
			"deal_price": 1000.00,
			"buy_counts": 20,
			"empirical_value": 10000,
			"shop_discount": "90%"
		}, {
			"name": "银牌会员",
			"upgrade": "自动升级",
			"deal_price": 3000.00,
			"buy_counts": 30,
			"empirical_value": 30000,
			"shop_discount": "80%"
		}, {
			"name": "金牌会员",
			"upgrade": "自动升级",
			"deal_price": 5000.00,
			"buy_counts": 50,
			"empirical_value": 50000,
			"shop_discount": "70%"
		}]
		"""



Scenario: 3 添加手动和自动升级的会员等级
	jobs添加多组手动升级和自动升级的"会员等级"后，"会员等级列表"会按照添加的顺序正序排列

	Given jobs登录系统
	When jobs开启自动升级
		"""
		{
			"upgrade": "自动升级",
			"condition": ["必须满足全部条件"]
		}
		"""
	When jobs添加会员等级
		"""
		[{
			"name": "铜牌会员",
			"upgrade": "自动升级",
			"deal_price": 1000.00,
			"buy_counts": 20,
			"empirical_value": 10000,
			"shop_discount": "90%"
		}, {
			"name": "银牌会员",
			"upgrade": "自动升级",
			"deal_price": 3000.00,
			"buy_counts": 30,
			"empirical_value": 30000,
			"shop_discount": "80%"
		}, {
			"name": "金牌会员",
			"upgrade": "手动升级",
			"shop_discount": "70%"
		}]
		"""
	Then jobs能获取会员等级列表
		"""
		[{
			"name": "普通会员",
			"upgrade": "自动升级",
			"shop_discount": "100%"
		}, {
			"name": "铜牌会员",
			"upgrade": "自动升级",
			"deal_price": 1000.00,
			"buy_counts": 20,
			"empirical_value": 10000,
			"shop_discount": "90%"
		}, {
			"name": "银牌会员",
			"upgrade": "自动升级",
			"deal_price": 3000.00,
			"buy_counts": 30,
			"empirical_value": 30000,
			"shop_discount": "80%"
		}, {
			"name": "金牌会员",
			"upgrade": "手动升级",
			"shop_discount": "70%"
		}]
		"""


Scenario: 4 添加自动升级的会员等级时有冲突
	jobs添加多组自动升级的会员等级时
	1. 数据有冲突，提示错误信息
	2. 等级名称为空，提示错误信息


	Given jobs登录系统
	When jobs开启自动升级
		"""
		{
			"upgrade": "自动升级",
			"condition": ["必须满足全部条件"]
		}
		"""
	#按照创建顺序，自动升级状态下的下一级必须比上一级升级条件高，折扣可以是相同或递减
	When jobs添加会员等级
		"""
		[{
			"name": "铜牌会员",
			"upgrade": "自动升级",
			"deal_price": 1000.00,
			"buy_counts": 20,
			"empirical_value": 10000,
			"shop_discount": "90%"
		}, {
			"name": "银牌会员",
			"upgrade": "自动升级",
			"deal_price": 3000.00,
			"buy_counts": 10,
			"empirical_value": 30000,
			"shop_discount": "80%"
		}, {
			"name": "金牌会员",
			"upgrade": "自动升级",
			"deal_price": 5000.00,
			"buy_counts": 50,
			"empirical_value": 50000,
			"shop_discount": "90%"
		}]
		"""
	Then jobs获得提示错误信息'等级升级条件必须逐级递增,等级折扣必须逐级递减或相同'
	And jobs能获取会员等级列表
		"""
		[{
			"name": "普通会员",
			"upgrade": "自动升级",
			"shop_discount": "100%"
		}]
		"""
	When jobs开启自动升级
		"""
		{
			"upgrade": "自动升级",
			"condition": ["必须满足全部条件"]
		}
		"""
	#填充框为空时，保存验证，提示错误信息
	When jobs添加会员等级
		"""
		[{
			"name": "",
			"upgrade": "自动升级",
			"deal_price": 1000.00,
			"buy_counts": 20,
			"empirical_value": 10000,
			"shop_discount": "90%"
		}, {
			"name": "",
			"upgrade": "自动升级",
			"deal_price": 3000.00,
			"buy_counts": 10,
			"empirical_value": 30000,
			"shop_discount": "80%"
		}, {
			"name": "",
			"upgrade": "自动升级",
			"deal_price": 5000.00,
			"buy_counts": 50,
			"empirical_value": 50000,
			"shop_discount": "90%"
		}]
		"""
	Then jobs获得提示错误信息'等级升级条件必须逐级递增,等级折扣必须逐级递减或相同'
	And jobs能获取会员等级列表
		"""
		[{
			"name": "普通会员",
			"upgrade": "自动升级",
			"shop_discount": "100%"
		}]
		"""