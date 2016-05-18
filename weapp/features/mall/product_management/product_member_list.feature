# watcher: tianfengmin@weizoom.com, benchi@weizoom.com
# __author__ : "田丰敏" 2016-05-18

Feature: 商品管理-购买人
"""
----自营平台----

【商品】-在售商品管理 -操作 增加“购买人”链接
		-待售商品管理 -操作 增加“购买人”链接

jobs通过“购买人”链接查看购买该商品的所有会员信息：
	1、会员状态包括：已关注，取消关注
	2、会员列表：会员、会员等级、好友数、积分、关注事件&来源、分组、操作

备注：
	1、会员购买该商品的订单状态：待发货、已发货、已完成、退款中、退款完成（即只要付款成功），按照销量规则来做筛选
	2、可对列表中的会员做单独操作：调分组、设等级、发优惠券、加积分、查看聊天记录
					     多人操作：群发消息、修改等级、添加分组、发优惠券
	   分组、设等级、发优惠券、加积分等操作与【会员】-【会员列表】同步


"""


Background:
	Given jobs登录系统
	When jobs已添加支付方式
		"""
		[{
			"type": "微信支付",
			"is_active": "启用"
		}, {
			"type": "货到付款",
			"is_active": "启用"
		}, {
			"type": "支付宝",
			"is_active": "启用"
		}]
		"""
	And jobs已添加商品
		"""
		[{
			"name": "商品1",
			"price": 100.00,
			"stock_type": "无限"
		},{
			"name": "商品2",
			"price": 200.00,
			"stock_type": "无限"
		 }]
		"""
	When tom1关注jobs的公众号
	When tom2关注jobs的公众号
	When tom3关注jobs的公众号
	When tom3取消关注jobs的公众号
	When tom5关注jobs的公众号
	When tom6关注jobs的公众号
	When tom6取消关注jobs的公众号

	When 微信用户批量消费jobs的商品
		| order_id |  date  | consumer | product | payment | pay_type | postage*| price* | paid_amount*| alipay*| wechat*| cash* |    action    | order_status*|
		|   0001   | 1天前  | tom1     | 商品1   |         | 微信支付 |  0.00   |  100.00| 100.00      | 0.00   | 100.00 | 0.00  |              | 待支付       |
		|   0002   | 1天前  | tom2     | 商品1   | 支付    | 货到付款 |  0.00   |  100.00| 100.00      | 0.00   | 0.00   | 100.00|              | 待发货       |
		|   0003   | 1天前  | tom3     | 商品1   |         | 支付宝   |  0.00   |  100.00| 100.00      | 100.00 | 0.00   | 0.00  |              | 待支付       |
		|   0004   | 1天前  | tom3     | 商品1   | 支付    | 货到付款 |  0.00   |  100.00| 100.00      | 0.00   | 0.00   | 100.00| jobs,完成    | 已完成       |
		|   0005   | 1天前  | tom4     | 商品1   | 支付    | 货到付款 |  0.00   |  100.00| 100.00      | 0.00   | 0.00   | 100.00| jobs,发货    | 已发货       |
		|   0006   | 1天前  | tom4     | 商品1   | 支付    | 货到付款 |  0.00   |  100.00| 100.00      | 0.00   | 0.00   | 100.00| jobs,退款    | 退款中       |
		|   0007   | 1天前  | tom5     | 商品1   |         | 微信支付 |  0.00   |  100.00| 100.00      | 0.00   | 100.00 | 0.00  |              | 待支付       |
		|   0008   | 1天前  | tom5     | 商品1   | 支付    | 货到付款 |  0.00   |  100.00| 100.00      | 0.00   | 0.00   | 100.00| jobs,完成退款| 退款完成     |
		|   0009   | 1天前  | tom6     | 商品1   | 支付    | 货到付款 |  0.00   |  100.00| 100.00      | 0.00   | 0.00   | 100.00| jobs,取消    | 已取消       |
		|   0010   | 1天前  | tom1     | 商品2   | 支付    | 货到付款 |  0.00   |  200.00| 200.00      | 0.00   | 0.00   | 200.00|              | 待发货       |


Scenario:1 选择一商品，获得购买人列表（已关注会员+取消关注会员）
	Given jobs登录系统
	Then jobs获得商品'商品1'的会员列表
		| member | member_rank | friend_count | integral | attention_time  |  source  |    tags     |   status  |
		| tom6   |   普通会员  |       0      |     0    |   2016-05-15    | 直接关注 |   未分组    |   已取消  | 
		| tom5   |   普通会员  |       0      |     0    |   2016-05-15    | 直接关注 |   未分组    |   已关注  |
		| tom3   |   普通会员  |       0      |     0    |   2016-05-15    | 直接关注 |   未分组    |   已取消  |
		| tom2   |   普通会员  |       0      |     0    |   2016-05-15    | 直接关注 |   未分组    |   已关注  |
