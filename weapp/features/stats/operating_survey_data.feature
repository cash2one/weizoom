#_author_:王丽

Feature: 经营报告-经营概况——概况数据
"""
	说明：1）整个会员的统计只统计真实会员，没有注册直接下单的不统计
	2）有效订单：订单状态为 待发货、已发货、已完成的订单
	一、查询条件
		1、刷选日期
			1）默认为‘今天’，筛选日期：‘今天’到‘今天’
			2）包含筛选日期的开始和结束的边界值
			3）手工设置筛选日期，点击查询后，‘快速查询’的所有项都处于‘未选中状态’
		2、快速查看
		    1）今天：查询的当前日期，例如，今天是2015-6-16，筛选日期是：2015-6-16到2015-6-16
		    2）昨天：查询的前一天，例如，今天是2015-6-16，筛选日期是：2015-6-15到2015-6-15
			3）最近7天；包含今天，向前7天；例如，今天是2015-6-16，筛选日期是：2015-6-10到2015-6-16
			4）最近30天；包含今天，向前30天；例如，今天是2015-6-16，筛选日期是：2015-5-19到2015-6-16
			5）最近90天；包含今天，向前90天；例如，今天是2015-6-16，筛选日期：2015-3-19到2015-6-16
			6）全部：筛选日期更新到：2013.1.1到今天
			7）打印：打印‘经营概况’页签的内同，包含按钮
	二、店铺经营概况-综合
		1、【会员复购率】：=∑(复购会员数/【下单会员】)*100% 
			1）【复购会员数】=∑订单.买家个数[(订单.下单时间 in 查询区间) and (订单.来源="本店") and (订单.订单状态 in {待发货、已发货、已完成}) and (订单.订单编号[(订单.买家=该订单.买家) and (订单.下单时间<该订单.下单时间) and (订单.订单状态 in {待发货、已发货、已完成}) and (订单.来源 ='本店')].exist) 

			备注：满足下面条件的订单的买家个数总和；（1）下单时间在查询区间内的有效订单（1）订单的买家在该订单下单时间之前有‘有效订单’

			2）【下单会员】：=∑订单.买家个数[(订单.下单时间 in 查询区间) and (订单.来源 ='本店') and (订单.订单状态 in {待发货、已发货、已完成})]   

			备注：‘下单时间’在查询区间内的有效订单的买家个数，重复的会员不重复累加
			"？"说明弹窗：时间段内，再次购买人数/总购买人数x100%	

 
		2、【会员推荐率】：(【发起扫码会员】+ 【发起分享链接会员】)/查询结束时间点时系统的会员总数 * 100%
			1）【发起扫码会员】：在查询区间内发起‘有效扫码’的会员数
				‘有效扫码’：发起推广扫码或者带参数二维码，以二维码生成的时间为准

			2）【发起分享链接会员】：在查询区间内发起‘有效分享链接’的会员数
				‘有效分享链接’：发起分享链接的并且此链接被第一次点击的时间在查询区间

			3）查询结束时间点时系统的会员总数
				例如：筛选日期：2015-5-1到2015-5-22
					查询结束时间点时系统的会员总数=∑会员.个数[会员.加入时间 < 2015-5-23 00:00]

			备注：会员总数包含会员状态为‘关注’和‘已取消’的

			"？"说明弹窗：时间段内，发起推荐会员数/会员总数x100%
	三、店铺经营概况-销量
		1、【成交金额】：=∑订单.实付金额[(订单.下单时间 in 查询区间) and (订单.来源 ='本店') and (订单.订单状态 in {待发货、已发货、已完成})]

			"？"说明弹窗：当前所选时段内该店铺已支付订单和货到付款提交成功订单的总金额

		2、【购买总人数】：=∑订单.买家个数[(订单.下单时间 in 查询区间) and (订单.来源 ='本店') and (订单.订单状态 in {待发货、已发货、已完成})]
								+∑订单.个数[(买家未知) and (订单.下单时间 in 查询区间) and (订单.来源 ='本店') and (订单.订单状态 in {待发货、已发货、已完成})]

			备注：重复下单的买家不累加；买家未知的直接累加

			"？"说明弹窗：购买商品的总人数

		3、【成交订单】：=∑订单.个数[(订单.下单时间 in 查询区间) and (订单.来源 ='本店') and (订单.订单状态 in {待发货、已发货、已完成})]

			"？"说明弹窗：当前所选时段内该店铺已发货、待发货、已完成的订单数之和

		4、【客单价】：=【成交金额】/【成交订单】

			"？"说明弹窗：当前所选时段内平均每个订单的金额
	四、店铺经营概况-会员
		1、【发起扫码会员】：在查询区间内发起‘有效扫码’的会员数
			‘有效扫码’：发起推广扫码或者带参数二维码，以二维码生成的时间为准

			"？"说明弹窗：发起推广扫码的会员数

		2、【扫码新增会员】：=∑会员.个数[(会员.加入时间 in 查询区间) and (会员.来源 = ‘推广扫码’)]

			备注：在查询区间内通过扫码新增的会员数，包括推广扫码和带参数二维码（包含会员发起和商家发起）

			"？"说明弹窗：通过扫码新关注的会员数（包括推广扫码、带参数二维码）

		3、【发起分享链接会员】：在查询区间内发起‘有效分享链接’的会员数
			‘有效分享链接’：发起分享链接的并且此链接被第一次点击的时间在查询区间

			"？"说明弹窗：发起分享链接的会员数

		4、【分享链接新增会员】：∑会员.个数[(会员.加入时间 in 查询区间) and (会员.来源 = ‘会员分享’)]

			备注：在查询区间内通过分享链接新增的会员数

			"？"说明弹窗：通过分享链接新关注的会员数
 
"""


Background:
	Given jobs登录系统
	Given 开启手动清除cookie模式

	And jobs设定会员积分策略
		#"integral_each_yuan": 10
		"""
		{
			"一元等价的积分数量": 10
		}
		"""

	When jobs已添加商品
		"""
		[{
			"name": "商品1",
			"promotion_title": "促销商品1",
			"detail": "商品1详情",
			"swipe_images": [{
				"url": "/standard_static/test_resource_img/hangzhou1.jpg"
			}],
			"model": {
				"models": {
					"standard": {
						"price": 100.00,
						"freight":"10",
						"weight": 5.0,
						"stock_type": "无限"
					}
				}
			},
			"synchronized_mall":"是"
		}, {
			"name": "商品2",
			"promotion_title": "促销商品2",
			"detail": "商品2详情",
			"swipe_images": [{
				"url": "/standard_static/test_resource_img/hangzhou1.jpg"
			}],
			"model": {
				"models": {
					"standard": {
						"price": 100.00,
						"freight":"15",
						"weight": 5.0,
						"stock_type": "无限"
					}
				}
			},
			"synchronized_mall":"是"
		}]
		"""

	And jobs设置未付款订单过期时间
		"""
		{
			"no_payment_order_expire_day":"1天"
		}
		"""

	And jobs已添加支付方式
		"""
		[{
			"type": "货到付款",
			"is_active": "启用"
		}, {
			"type": "微信支付",
			"is_active": "启用"
		}, {
			"type": "支付宝",
			"is_active": "启用"
		}]
		"""
	And jobs开通使用微众卡权限
	And jobs添加支付方式
		"""
		[{
			"type": "微众卡支付",
			"description": "我的微众卡支付",
			"is_active": "启用"
		}]
		"""

	When jobs创建积分应用活动
		"""
		[{
			"name": "商品1积分应用",
			"start_date": "2014-8-1",
			"end_date": "10天后",
			"products": ["商品1"],
			"is_permanant_active": false,
			"discount": 70,
			"discount_money": 70.0
		}]
		"""

	And jobs添加优惠券规则
		"""
		[{
			"name": "商品2优惠券",
			"money": 10.00,
			"start_date": "2014-8-1",
			"end_date": "10天后",
			"coupon_id_prefix": "coupon1_id_"
		}]
		"""


	##微信用户批量关注jobs成为会员

	When bill关注jobs的公众号于'2015-4-2'

	When mary关注jobs的公众号于'2015-4-3'
	When mary访问jobs的webapp
	When mary把jobs的微站链接分享到朋友圈

	When tom关注jobs的公众号
	When tom访问jobs的webapp
	When tom把jobs的微站链接分享到朋友圈

	When bill1关注jobs的公众号
	When bill1取消关注jobs的公众号

	#When 清空浏览器
	When bill1通过tom分享链接关注jobs的公众号
	When bill1访问jobs的webapp

	#When 清空浏览器
	When tom1通过tom分享链接关注jobs的公众号
	When tom1访问jobs的webapp

	When 清空浏览器
	When jack点击mary分享链接
	When jack把jobs的微站链接分享到朋友圈
"""
	When 微信用户批量关注jobs成为会员
		|  memberID   |  name  | launch_spreading_code | launch_share_link |   direct_attention   | spreading_code_attention | share_link_attention               |   attention_time  |    entry_time     |       current_status         | member_source |
		| memberID000 |  mary  |         是            |        是         |                      |            lily          |                                    |   2015-4-3 10:50  |   2015-4-3 10:50  |             关注             |    推广扫码   |
		| memberID001 |  bill  |         是            |                   | 直接搜索jobs公众账号 |                          |                                    |   2015-5-1 10:50  |   2015-5-1 10:50  |             关注             |    直接关注   |
		| memberID002 |  tom   |                       |        是         |                      |                          |         未知                       |   2015-5-2 10:50  |   2015-5-2 10:50  |2015-6-2 11:20取消关注；已取消|    会员分享   |
		
		| memberID003 | bill1  |                       |                   |                      |           bill           |                                    |   2015-5-3 11:20  |   2015-5-3 11:20  |2015-5-4 11:20取消关注； 关注 |    推广扫码   |
		| memberID003 | bill1  |                       |                   |                      |                          |         tom                        |   2015-5-4 13:00  |   2015-5-3 11:20  |             关注             |    推广扫码   |
		
		| memberID004 |  tom1  |                       |                   |                      |                          |         tom                        |   2015-5-5 14:00  |   2015-5-5 14:00  |             关注             |    会员分享   |
		| memberID005 |  tom1  |         是            |                   |                      |           bill           |                                    |   2015-5-6 15:00  |   2015-5-6 15:00  |2015-5-7 8:00 取消关注，已取消|    推广扫码   |
		
		| memberID000 |  mary  |         是            |        是         | 直接搜索jobs公众账号 |                          |                                    |   2015-5-7 10:50  |   2015-4-3 10:50  |2015-5-7 8:00取消关注；关注   |    推广扫码   |
		
		| memberID006 |  jack  |         是            |        是         |                      |                          |         mary                       |   2015-5-9 9:30   |   2015-5-9 9:30   |             关注             |    会员分享   |
		|             |  jack1 |                       |                   |                      |    扫码jack未关注jobs    |                                    |                   |                   |                              |               |
		|             |  jack2 |                       |                   |                      |                          | 2015-5-9 9:30点击jack链接未关注jobs|                   |                   |                              |               |
		| memberID007 |  jack3 |                       |                   |                      |           jack           |                                    |   2015-6-3 10:00  |   2015-6-3 10:00  |2015-6-3 13:00取消关注；已取消|    推广扫码   |
		| memberID008 |  nokia |                       |                   | 直接搜索jobs公众账号 |                          |                                    |   2015-6-1 00:00  |   2015-6-1 00:00  |             关注             |    直接关注   |
"""

@stats @wip.operation1
Scenario: 获取当日的经营概况
	Given jobs登录系统
	When jobs设置筛选日期
		"""
		[{
			"begin_date":"今天",
			"end_date":"今天"
		}]
		"""
	And 查询'店铺经营概况'
	Then 获得店铺经营概况数据
		"""
		{
			"transaction_orders": 0,
			"transaction_money": "0.00",
			"vis_price": "0.00",
			"buyer_count": 0
		}
		"""
#		"""
#		{
#			"buyer_count": 0,
#			"transaction_money": 0,
#			"vis_price": "0.00",
#			"transaction_orders": 0,
#			"member_recommend_rate": "40.0%",
#			"member_from_share_url_count": 2,
#			"ori_qrcode_member_count": 0,
#			"share_url_member_count": 2,
#			"repeat_buying_member_rate": "0.0%",
#			"member_from_qrcode_count": 0
#		}
#		"""


@ignore 
Scenario: 1  经营概况：筛选日期，默认筛选日期当天；快速查询；

	Given jobs登录系统
	#筛选日期默认今天
	When 浏览'经营概况'页面
	# [?] 是不是应该为when？
	#Then job获取'今天'选中
	Then jobs设置筛选日期
		"""
		[{
			"begin_date":"今天",
			"end_date":"今天"
		}]
		"""

	#备注：昨天，今天是2015-6-16，筛选日期：2015-6-15到2015-6-15
	When jobs选中'昨天'
	Then jobs设置筛选日期
		"""
		[{
			"begin_date":"昨天",
			"end_date":"昨天"
		}]
		"""

	#备注：最近7天，今天是2015-6-16，筛选日期：2015-6-10到2015-6-16
	When jobs选中'最近7天'
	Then jobs设置筛选日期
		"""
		[{
			"begin_date":"7天前",
			"end_date":"今天"
		}]
		"""

	#备注：最近30天，今天是2015-6-16，筛选日期：2015-5-19到2015-6-16
	When jobs选中'最近30天'
	Then jobs设置筛选日期
		"""
		[{
			"begin_date":"30天前",
			"end_date":"今天"
		}]
		"""

	#备注：最近90天，今天是2015-6-16，筛选日期：2015-3-19到2015-6-16
	When jobs选中'最近90天'
	Then jobs设置筛选日期
		"""
		[{
			"begin_date":"90天前",
			"end_date":"今天"
		}]
		"""

	#备注：全部，今天是2015-6-16，筛选日期：2013-1-1到2015-6-16
	When jobs选中'全部'
	Then jobs获得查询条件
		"""
		[{
			"begin_date":"2013-1-1",
			"end_date":"今天"
		}]
		"""
	#打印：？？


@stats @wip.operation2
Scenario: 2  经营概况：综合
	#consumer字段“*jack”这样带“*”代表非会员
	When 微信用户批量消费jobs的商品
		# consumer前有'-'表示清空浏览器
		| date       | consumer | type |businessman|product   | integral | coupon | payment | action    |
		| 60天前 	| mary | 购买 | jobs      |商品1,1  |          |  1      | 支付    |           |
		| 今天		| bill 	| 购买 | jobs      |商品1,1  |          |  1      | 	    |           |
		| 今天		| tom 	| 购买 | jobs      |商品2,1  |          |  1      | 支付    |           |
		| 今天		| tom 	| 测试 | jobs      |商品2,1  |          |  1      | 支付    |           |
		| 今天		| bill 	| 购买 | jobs      |商品1,1  |          |  1      | 支付    |           |
		| 今天		| bill1 	| 购买 | jobs      |商品1,1  |          |  1      | 支付    |           |
		| 今天		| bill1 	| 购买 | jobs      |商品2,1  |          |  1      | 支付    |           |
		| 今天		| mary 	| 购买 | jobs      |商品2,2  |          |  1      | 支付    |           |

#		| 今天   	| jack   | 购买 | jobs      | 商品2,2  | 支付    | 支付宝       | 15      | 100      |  0       | 20     | 195         | 0            | 195    |    0   | 0    |   jobs,发货 | 已发货       |
	And jack购买jobs的商品
		"""
		{
			"products": [{
				"name": "商品2",
				"count": 2
			}],
		}
		"""
	##下单会员：4（bill、tom、bill1、mary）;复购会员数：3（tom、bill、mary）
	##发起扫码会员：0；发起分享链接会员：2（mary、tom）；会员总数：(mary、tom、bill、bill1、tom1)

	Given jobs登录系统
	When jobs设置筛选日期
		"""
		[{
			"begin_date":"今天",
			"end_date":"今天"
		}]
		"""
	
	And 查询'店铺经营概况'
	Then 获得店铺经营概况数据
		"""
		{
			"buyer_count": 4,
			"transaction_money": "700.00",
			"vis_price": "116.67",
			"transaction_orders": 6
		}
		"""
#		"""
#		{	
#			"member_recommend_rate": "40.0%",
#			"repeat_buying_member_rate": "50.0%",
#			"member_from_share_url_count": 2,
#			"ori_qrcode_member_count": 0,
#			"share_url_member_count": 2,
#			"member_from_qrcode_count": 0
#		}
#		"""

Scenario: commented
"""
		| date		| consumer| type |businessman| product	| payment | payment_method | freight |   price  | integral | coupon | paid_amount | weizoom_card | alipay | wechat | cash | action    | order_status   |
		| 2015-4-4  	| mary    | 购买 | jobs      | 商品1,1  | 支付    | 微信支付     | 10      | 100      | 10       | 0      | 100         | 0            | 0      |   100  | 0    |   jobs,完成 | 已完成       |
		| 今天     	| bill    | 购买 | jobs      | 商品1,1  |         | 支付宝       | 10      | 100      |  0       | 0      |  0          | 0            | 0      |    0   | 0    |   jobs,取消 | 已取消       |
		| 今天   	| tom     | 购买 | jobs      | 商品2,1  | 支付    | 微信支付     | 15      | 100      |  0       | 0      | 115         | 0            | 0      |    115 | 0    |   jobs,完成 | 已完成       |
		| 今天   	| tom     | 测试 | jobs      | 商品2,1  | 支付    | 微信支付     | 15      | 100      |  0       | 0      | 115         | 0            | 0      |    115 | 0    |   jobs,完成 | 已完成       |
		| 今天		| bill    | 购买 | jobs      | 商品1,1  | 支付    | 货到付款     | 10      | 100      |  0       | 30     | 80          | 0            | 0      |    0   | 80   |             | 待发货       |
		| 今天     	| tom     | 购买 | jobs      | 商品1,1  | 支付    | 货到付款     | 10      | 100      |  20      | 0      | 90          | 0            | 0      |    0   | 90   |   jobs,发货 | 已发货       |
		| 今天   	| bill1   | 购买 | jobs      | 商品1,1  | 支付    | 支付宝       | 10      | 100      |  0       | 0      | 110         | 0            | 110    |    0   | 0    |   jobs,完成 | 已完成       |
		| 今天   	| bill1   | 购买 | jobs      | 商品2,1  | 支付    | 微信支付     | 15      | 100      |  0       | 0      | 115         | 0            | 0      |   115  | 0    |   jobs,发货 | 已发货       |
		| 今天   	| mary    | 购买 | jobs      | 商品2,2  | 支付    | 支付宝       | 15      | 100      |  0       | 20     | 195         | 0            | 195    |    0   | 0    |   jobs,发货 | 已发货       |
"""
"""
		|        date   	| consumer| type |businessman|      product     | payment | payment_method | freight |   price  | integral | coupon | paid_amount | weizoom_card | alipay | wechat | cash |      action       |  order_status   |
		| 2015-4-4  10:20  	| mary    | 购买 | jobs      | 商品1,1          | 支付    |   微信支付     | 10      | 100      | 10       | 0      | 100         | 0            | 0      |   100  | 0    |   jobs发货，完成  |    已完成       |
		| 今天  8:00     	| bill    | 购买 | jobs      | 商品1,1          |         |   支付宝       | 10      | 100      |  0       | 0      |  0          | 0            | 0      |    0   | 0    |   jobs，取消      |    已取消       |
		| 今天  10:00   	| tom     | 购买 | jobs      | 商品2,1          | 支付    |   微信支付     | 15      | 100      |  0       | 0      | 115         | 0            | 0      |    115 | 0    |   jobs发货，完成  |    已完成       |
		| 今天  11:00   	| tom     | 测试 | jobs      | 商品2,1          | 支付    |   微信支付     | 15      | 100      |  0       | 0      | 115         | 0            | 0      |    115 | 0    |   jobs发货，完成  |    已完成       |
		| 今天  9:00  	    | bill    | 购买 | jobs      | 商品1,1          | 支付    |   货到付款     | 10      | 100      |  0       | 30     | 80          | 0            | 0      |    0   | 80   |                   |    待发货       |
		| 今天  9:00     	| tom     | 购买 | jobs      | 商品1,1          | 支付    |   货到付款     | 10      | 100      |  20      | 0      | 90          | 0            | 0      |    0   | 90   |   jobs发货        |    已发货       |
		| 今天  10:00   	| bill1   | 购买 | jobs      | 商品1,1          | 支付    |   支付宝       | 10      | 100      |  0       | 0      | 110         | 0            | 110    |    0   | 0    |   jobs发货，完成  |    已完成       |
		| 今天  10:00   	| bill1   | 购买 | jobs      | 商品2,1          | 支付    |   微信支付     | 15      | 100      |  0       | 0      | 115         | 0            | 0      |   115  | 0    |   jobs发货        |    已发货       |
		| 今天  13:20   	| mary    | 购买 | jobs      | 商品2,2          | 支付    |   支付宝       | 15      | 100      |  0       | 20     | 195         | 0            | 195    |    0   | 0    |   jobs发货        |    已发货       |
		| 今天  15:20   	| *jack   | 购买 | jobs      | 商品2,2          | 支付    |   支付宝       | 15      | 100      |  0       | 20     | 195         | 0            | 195    |    0   | 0    |   jobs发货        |    已发货       |
"""



@wip.operation3
Scenario: 3  经营概况：销量
	#consumer字段“*jack”这样带“*”代表非会员
	When 微信用户批量消费jobs的商品
		# 建议：date部分尽量用相对日期，比如"今天"、"10天前"。
		| date       | consumer | type |businessman|product   | integral | coupon | payment | action    |
		| 30天前 	| mary | 购买 | jobs      |商品1,1  |          |  1      | 支付    |           |
		| 今天		| bill 	| 购买 | jobs      |商品1,1  |          |  1      | 	    |           |
		| 今天		| tom 	| 购买 | jobs      |商品2,1  |          |  1      | 支付    |           |
		| 今天		| tom 	| 测试 | jobs      |商品2,1  |          |  1      | 支付    |           |
		| 今天		| bill 	| 购买 | jobs      |商品1,1  |          |  1      | 支付    |           |
		| 今天		| tom 	| 购买 | jobs      |商品1,1  |          |  1      | 支付    |           |
		| 今天		| bill1 	| 购买 | jobs      |商品1,1  |          |  1      | 支付    |           |
		| 今天		| bill1 	| 购买 | jobs      |商品2,1  |          |  1      | 支付    |           |
		| 今天		| mary 	| 购买 | jobs      |商品2,2  |          |  1      | 支付    |           |

	# jack是非关注会员
	And jack购买jobs的商品
		"""
		{
			"products": [{
				"name": "商品2",
				"count": 2
			}],
		}
		"""

	#成交金额=115+80+90+110+115+195+195=900
	#购买总人数：5(bill、tom、bill1、mary、*jack)
	Given jobs登录系统
	When jobs设置筛选日期
		"""
		[{
			"begin_date":"今天",
			"end_date":"今天"
		}]
		"""
	And 查询'店铺经营概况'
	Then 获得店铺经营概况数据
		"""
		{
			"transaction_money": 900,
			"transaction_orders": 7,
			"buyer_count": 4,
			"vis_price": "128.57"
		}
		"""

	#Then jobs获得销量数据
	#	|     item    |    quantity   |
	#	|  成交金额   |      900      |
	#	|  成交订单   |       7       |
	#	|  购买总人数 |       5       |
	#	|   客单价    |     128.57    |


@stats @wip.operation4
Scenario: 4  经营概况：会员
	#发起分享链接会员：2（mary、tom）；分享链接新增会员：tom1

	Given jobs登录系统
	When jobs设置筛选日期
		"""
		[{
			"begin_date":"今天",
			"end_date":"今天"
		}]
		"""

	And 查询'店铺经营概况'
	Then 获得店铺经营概况数据
		# 会员相关的数据被屏蔽了
		"""
		{
			"transaction_orders": 0,
			"transaction_money": "0.00",
			"vis_price": "0.00",
			"buyer_count": 0		
		}
		"""
#		"""
#		{
#			"ori_qrcode_member_count": 0,
#			"member_from_qrcode_count": 0,
#			"share_url_member_count": 2,
#			"member_from_share_url_count": 1
#		}
#		"""
	#Then jobs获得会员数据
	#	|     item        |    quantity   |
	#	| 发起扫码会员    |       0       |
	#	| 扫码新增会员    |       0       |
	#	| 发起分享链接会员|       2       |
	#	| 分享链接新增会员|       1       |
