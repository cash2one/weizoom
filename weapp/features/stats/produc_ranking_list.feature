#_author_:张三香

Feature:商品概况-排行数据
         对店铺的商品进行不同维度的分析
    一、查询条件
		1、刷选日期
			1）开始日期和结束日期都为空；选择开始结束日期，精确到日期
			2）开始日期或者结束日期，只有一个为空，给出系统提示“请填写XX日期”
			3）默认为‘今天’，筛选日期：‘今天’到‘今天’
              需求变更，默认为"最近7天"，筛选日期：‘7天前’到‘今天’
			4）包含筛选日期的开始和结束的边界值
			5）手工设置筛选日期，点击查询后，‘快速查询’的所有项都处于‘未选中状态’
		2、快速查看
		    1）今天：查询的当前日期，例如，今天是2015-6-16，筛选日期是：2015-6-16到2015-6-16
		    2）昨天：查询的前一天，例如，今天是2015-6-16，筛选日期是：2015-6-15到2015-6-15
			3）最近7天；包含今天，向前7天；例如，今天是2015-6-16，筛选日期是：2015-6-10到2015-6-16
			4）最近30天；包含今天，向前30天；例如，今天是2015-6-16，筛选日期是：2015-5-19到2015-6-16
			5）最近90天；包含今天，向前90天；例如，今天是2015-6-16，筛选日期：2015-3-19到2015-6-16
			6）全部：筛选日期更新到：2013.1.1到今天
	
	二、下单单量排行top10
	    下单单量排行柱状图
	     1、【排名】：从1到10
		 2、【商品名称】：商品的名称
		 3、【次数】：查询区间内，商品被下单的次数

         备注：只统计‘有效订单’，即订单状态为待发货、已发货、已完成的订单

		 横轴：从1到10
		 纵轴：下单次数
		 鼠标滑动显示下单次数，例如"50次"	 

	三、商品被分享次数排行top10
	    商品被分享次数排行柱状图
	     1、【排名】：从1到10
		 2、【商品名称】：商品的名称
		 3、【被分享次数占比】：查询区间内，商品的被分享次数占比

		 横轴：从1到10
		 纵轴：商品被分享总次数
		 鼠标滑动时显示商品被分享总次数

		备注：
		 【被分享次数】：对应的【日期】当天该商品被分享的次数
		 ‘有效分享链接’：发起分享链接的并且此链接被第一次点击的时间在查询区间内
		 被分享次数统计规则：同一url只计算第一次被点击时的次数
             1、bill昨天分享商品1的链接，今天被人第一次点击
             2、bill今天分享商品1的链接，没人点击
             3、bill今天分享商品1的链接，明天被人第一次点击
			 4、bill分享商品1的链接（1次），被同一人点击多次；被多人点击多次
			 5、bill分享商品1的链接（2次），被同一人分别在不同时间进行第一次点击
			 6、bob分享商品1的链接，被人点击
			  
Background:
    Given jobs登录系统
    And 开启手动清除cookie模式

	And jobs已添加支付方式
	     """
	     [{
	         "type": "货到付款",
	         "is_active": "启用"
	     },{
		     "type": "微信支付",
		     "is_active": "启用"
	      },{
		     "type": "支付宝",
		     "is_active": "启用"
	      }]
	     """
    When jobs添加商品
        """
        [{
            "name": "商品1"
        }, {
            "name": "商品2"
        }, {
            "name": "商品3"
        }]  
        """
         
    When bill关注jobs的公众号
    And tom关注jobs的公众号
    And jim关注jobs的公众号
    And kate关注jobs的公众号
    And mary关注jobs的公众号
    #账号前面'-'代表取消关注的会员
        
    When 微信用户批量消费jobs的商品
         | date              | consumer | type |businessman| product          | payment | payment_method | freight | price    | integral | coupon | paid_amount | weizoom_card | alipay | wechat | cash | action    |  order_status   |
         | 今天 00:10        | bill     | 购买 | jobs      | 商品1,2          | 支付    |   支付宝       | 10      | 100      |  0       | 0      | 210         | 0            | 210    |    0   | 0    |           |    已发货       |            
         | 今天 09:10        | tom      | 购买 | jobs      | 商品1,1          | 支付    |   微信支付     | 10      | 100      |  0       | 0      | 110         | 0            | 0      |    110 | 0    |           |    已完成       |           
         | 今天 09:20        | -tom     | 购买 | jobs      | 商品1,1 商品2,1  | 支付    |   货到付款     | 10,10   | 100 ,100 |  0       | 0      | 220         | 0            | 0      |    0   | 220  |           |    待发货       |
         | 今天 10:20        | *tom1    | 购买 | jobs      | 商品1,1          | 支付    |   支付宝       | 10      | 100      |  0       | 0      | 110         | 0            | 110    |    0   | 0    |           |    待发货       |
         | 今天 12:00        | *tom1    | 购买 | jobs      | 商品1,1,商品2,1  | 支付    |   支付宝       | 10,10   | 100 ,100 |  0       | 0      | 220         | 0            | 220    |    0   | 0    |           |    待发货       |
         | 今天 16:20        | *tom1    | 购买 | jobs      | 商品1,1          | 支付    |   支付宝       | 10      | 100      |  0       | 0      | 110         | 0            | 110    |    0   | 0    |           |    待发货       |
         | 今天 20:20        | *tom2    | 购买 | jobs      | 商品1,1          | 支付    |   微信支付     | 10      | 100      |  0       | 0      | 110         | 0            | 0      |    110 | 0    |           |    待发货       |
         | 今天 23:59        | bill     | 购买 | jobs      | 商品2,1          | 支付    |   支付宝       | 10      | 100      |  0       | 0      | 110         | 0            | 110    |    0   | 0    |           |    已发货       |
         | 今天 23:59        | bill     | 购买 | jobs      | 商品3,1          | 支付    |   支付宝       | 10      | 100      |  0       | 0      | 110         | 0            | 110    |    0   | 0    |           |    已发货       |
         | 今天 21:00        | bill     | 购买 | jobs      | 商品1,1          |         |   支付宝       | 10      | 100      |  0       | 0      |  0          | 0            | 0      |    0   | 0    |           |    未支付       |       
         | 今天 22:20        | bill     | 测试 | jobs      | 商品2,1          | 支付    |   微信支付     | 10      | 100      |  0       | 0      | 110         | 0            | 0      |    110 | 0    | jobs,取消 |    已取消       |            
         | 今天 23:59        | tom      | 购买 | jobs      | 商品1,1          | 支付    |   货到付款     | 10      | 100      |  0       | 0       | 0          | 0            | 0      |    0   | 110  | jobs,退款 |    退款中       |            
       
Scenario: 1 商品排行（下单单量、被分享次数）
     Given jobs登录系统
     When  jobs设置筛选日期
      """
         {
             "start_date":"今天",
             "end_date":"今天"
         }
             
      """
     #下单单量排行top10
     Then jobs获得下单单量排行top10
         |ranking  |name   |count  |  
         |1        |商品1  |4      | 
         |2        |商品2  |3      |
         |3        |商品3  |2      |

