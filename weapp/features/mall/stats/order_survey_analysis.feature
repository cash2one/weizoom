#_author_:王丽
#edit：张三香
#editor:王丽  2015.10.19
#editor:新新  2015.10.20

Feature: 销售概况-订单概况
"""
    对店铺的订单进行不同维度的数据统计分析，订单的订单来源为'本店'和‘商城’

    备注：
        名词解释
            已支付的订单：已支付订单和货到付款提交成功订单
            有效订单：订单状态为 待发货、已发货、已完成的订单
            订单.实付金额：=现金支付金额+微众卡支付金额；不包含优惠券和积分抵扣的金额，包含微众卡支付的金额；

    查询条件
        1、刷选日期
            1）开始日期和结束日期都为空；选择开始结束日期，精确到日期
            2）开始日期或者结束日期，只有一个为空，给出系统提示“请填写XX日期”
            3）默认为‘最近7天’，筛选日期：‘七天前’到‘今天’
            4）包含筛选日期的开始和结束的边界值
            5）手工设置筛选日期，点击查询后，‘快速查询’的所有项都处于‘未选中状态’，时间和选项匹配的，选项处于选中状态
        2、快速查看
            选择快速查看的选项后就直接查询
            1）今天：查询的当前日期，例如，今天是2015-6-16，筛选日期是：2015-6-16到2015-6-16
            2）昨天：查询的前一天，例如，今天是2015-6-16，筛选日期是：2015-6-15到2015-6-15
            3）最近7天；包含今天，向前7天；例如，今天是2015-6-16，筛选日期是：2015-6-10到2015-6-16
            4）最近30天；包含今天，向前30天；例如，今天是2015-6-16，筛选日期是：2015-5-19到2015-6-16
            5）最近90天；包含今天，向前90天；例如，今天是2015-6-16，筛选日期：2015-3-19到2015-6-16
            6）全部：筛选日期更新到：2013.1.1到今天

    订单概况
        1、【成交订单】=∑订单.个数[(订单状态 in {待发货、已发货、已完成}) and (订单.下单时间 in 查询区间)]

            "？"说明弹窗：当前所选时段内该店铺已发货、待发货、已完成的订单数之和

        2、【成交金额】=∑订单.实付金额[(订单状态 in {待发货、已发货、已完成}) and (订单.下单时间 in 查询区间)]

            "？"说明弹窗：当前所选时段内该店铺已支付订单和货到付款提交成功订单的总金额

        3、【客单价】=【成交金额】/【成交订单】

            备注：保留小数点后两位

            "？"说明弹窗：当前所选时段内平均每个订单的金额

        4、【成交商品】=∑订单.商品件数[(订单状态 in {待发货、已发货、已完成}) and (订单.下单时间 in 查询区间)]

            "？"说明弹窗：当前所选时段内所有成交订单内商品总件数

            备注：注意一个订单包含多个商品和一个商品购买多件的情况

        5、【优惠抵扣】=∑订单.积分抵扣金额[(订单状态 in {待发货、已发货、已完成}) 
                                            and (订单.下单时间 in 查询区间)] 
                            +∑订单.优惠券抵扣金额[(订单状态 in {待发货、已发货、已完成}) 
                                                    and (订单.下单时间 in 查询区间)] 

            "？"说明弹窗：当前所选时段内成交订单中使用积分或优惠券抵扣的总金额

        6、【总运费】=∑订单.运费金额[(订单状态 in {待发货、已发货、已完成}) and (订单.下单时间 in 查询区间)]

            "？"说明弹窗：当前所选时段内所有成交订单中总支付的运费金额

        备注：订单来源为本店的订单，支付方式只有三种：在线支付(微信支付、支付宝支付)、货到付款

        #虽然现在‘在线支付’只有支付宝、微信两种方式，为了增加可扩展性，修改为用整体减去‘货到付款’来得到‘在线支付’，
        #这样以后再增加了其他的在线支付方式也是不用再调整的
        
        #【在线付款订单】=∑订单.个数[(支付方式 in {'微信支付'、'支付宝支付'}) 
        #                                and (订单状态 in {待发货、已发货、已完成}) 
        #                                and (订单.下单时间 in 查询区间)]
        7、【在线付款订单】=∑订单.个数[(订单状态 in {待发货、已发货、已完成}) and (订单.下单时间 in 查询区间) 
                            -(∑订单.个数[(支付方式 in {'货到付款'}) 
                                        and (订单状态 in {待发货、已发货、已完成}) 
                                        and (订单.下单时间 in 查询区间)])

            "？"说明弹窗：当前所选时段内除货到付款之外的成交订单数

        #8、【在线付款订单金额】=∑订单.实付金额[(支付方式 in {'微信支付'、'支付宝支付'}) 
        #                                        and (订单状态 in {待发货、已发货、已完成}) 
        #                                        and (订单.下单时间 in 查询区间)]
        8、【在线付款订单金额】=∑订单.实付金额[(订单状态 in {待发货、已发货、已完成}) and (订单.下单时间 in 查询区间)]
                                -(∑订单.实付金额[(支付方式 in {'微信支付'、'支付宝支付'}) 
                                                and (订单状态 in {待发货、已发货、已完成}) 
                                                and (订单.下单时间 in 查询区间)])

            "？"说明弹窗：当前所选时段内除货到付款之外的成交订单金额

        9、【货到付款订单】=∑订单.个数[(支付方式 ='货到付款') and (订单状态 in {待发货、已发货、已完成}) 
                                        and (订单.下单时间 in 查询区间)]

            "？"说明弹窗：当前所选时段内使用货到付款方式的订单数

        10、【货到付款金额】=∑订单.货到付款金额[(支付方式 ='货到付款') and (订单状态 in {待发货、已发货、已完成}) 
                                            and (订单.下单时间 in 查询区间)]

            "？"说明弹窗：当前所选时段内使用货到付款方式的订单支付现金总计

    订单分析图表
        店铺内订单来源为'本店'，订单的'下单时间'在查询区间内的，有效订单(订单状态为：待发货、已发货、已完成)进行分析
        1、订单趋势
            店铺内订单来源为'本店'的，订单的'下单时间'在查询区间内的，订单不同状态的订单占比
            1）订单总量：=∑订单.个数[(订单状态 in {待发货、已发货、已完成}) and (订单.下单时间 in 查询区间)
                备注：待发货、已发货、已完成，订单的'下单时间'在查询区间内的订单数之和
            2）图形划过展开，展示内容为（该区域订单状态、订单量、订单量占比）
            3）点击详情跳转到，带入的查询条件
                【订单名称】：空；【订单编号】：空；【支付方式】：全部；【订单状态】：当前的图形对应的订单状态
                【复购筛选】：全部；【优惠抵扣】：全部；【仅显示微众卡抵扣订单】：否
        2、复购率
            店铺内订单，买家购买次数的统计分析
            1）订单总量：=∑订单.个数[(订单状态 in {待发货、已发货、已完成}) and (订单.下单时间 in 查询区间)]
            2）“初次购买”：在查询区间以前没有发生过购买，在查询区间内发生初次购买的用户订单数和其在总订单数占比
            3）“重复购买”：在该时间段以前发生过购买或者在该订单的订单时间之前发生过购买，在该时间段内又发生了购买的用户订单数和其在总订单数占比
                            满足下面条件的订单个数总和；（1）下单时间在查询区间内的‘有效订单’（1）订单的买家在该订单下单时间之前有‘有效订单’
            4）图形划过展开，展示内容为（该区域类型、订单量、订单量占比）
            5）点击详情跳转到，带入的查询条件
                【订单名称】：空；【订单编号】：空；【支付方式】：全部；【订单状态】：待发货、已发货、已完成
                【复购筛选】：当前的图形对应的类；【优惠抵扣】：全部；【仅显示微众卡抵扣订单】：否

            备注：1）注意买家在查询区间内发生两次购买，第一次购买为初次购买的统计到'初次购买';
                    第二次购买统计到'重复购买'。
                2）买家未知的订单按照内部的ID计算复购

        3、买家来源
            店铺内订单的'下单时间'在查询区间内的，"有效订单"的买家来源的占比
            1）订单总量：=∑订单.个数[(订单状态 in {待发货、已发货、已完成}) and (订单.下单时间 in 查询区间)]
            2）“直接关注购买”：=∑订单.个数[(买家来源 ='直接关注') and (订单状态 in {待发货、已发货、已完成}) 
                                            and (订单.下单时间 in 查询区间)]
            3）“推广扫码关注购买”：=∑订单.个数[(买家来源 ='推广扫码') and (订单状态 in {待发货、已发货、已完成}) 
                                            and (订单.下单时间 in 查询区间)]
            4）“分享链接关注购买”：=∑订单.个数[(买家来源 ='分享链接') and (订单状态 in {待发货、已发货、已完成}) 
                                            and (订单.下单时间 in 查询区间)]
            5）“其他”：=∑订单.个数[(买家来源不确定) and (订单状态 in {待发货、已发货、已完成}) 
                                            and (订单.下单时间 in 查询区间)]
            6）图形划过展开，展示内容为（该区域类型、订单量、订单量占比）
            7）点击详情跳转到，带入的查询条件
                【订单名称】：空；【订单编号】：空；【支付方式】：全部；【订单状态】：待发货、已发货、已完成
                【复购筛选】：当前的图形对应的类；【优惠抵扣】：全部；【仅显示微众卡抵扣订单】：否

            备注：1）买家可能会先下订单再关注，即买家的'关注时间'晚于订单的'下单时间'，这种订单的归类到其他
                2）没有关注店铺公众账号，直接下的订单的归类到其他
                即：所有不能确定买家的都归类到其他

        4、支付金额
            店铺内订单的'下单时间'在查询区间内的，"有效订单"的支付方式的支付金额占比
            1）订单总金额：=∑订单.实付金额[(订单状态 in {待发货、已发货、已完成}) 
                                            and (订单.下单时间 in 查询区间)]
            2）支付宝支付金额:=∑订单.支付宝支付金额[(订单状态 in {待发货、已发货、已完成}) 
                                            and (订单.下单时间 in 查询区间)]
            3）微信支付金额:=∑订单.微信支付金额[(订单状态 in {待发货、已发货、已完成}) 
                                            and (订单.下单时间 in 查询区间)]
            4）货到付款支付金额:=∑订单.货到付款支付金额[(订单状态 in {待发货、已发货、已完成}) 
                                            and (订单.下单时间 in 查询区间)]
            5）微众卡支付金额:=∑订单.微众卡支付金额[(订单状态 in {待发货、已发货、已完成}) 
                                            and (订单.下单时间 in 查询区间)]
            6）图形划过展开，展示内容为（该区域类型、金额、金额占比）

            备注：金额维度的分析，没有点击详情进入订单明细分析界面的功能                    
        
        5、优惠抵扣
            店铺内订单的'下单时间'在查询区间内的，"有效订单"的优惠抵扣方式的订单占比
            1）订单总量：=∑订单.个数[(订单状态 in {待发货、已发货、已完成}) and (订单.下单时间 in 查询区间) 
                                     and (优惠抵扣使用 in {积分、优惠券、微众卡})]
            2）微众卡支付：=∑订单.个数[(订单.优惠抵扣 = {微众卡}) and (订单状态 in {待发货、已发货、已完成}) 
                                    and (订单.下单时间 in 查询区间)]
                （1）微众卡支付金额：=∑订单.微众卡支付金额[(订单.优惠抵扣 = {微众卡}) and (订单状态 in {待发货、已发货、已完成}) 
                                    and (订单.下单时间 in 查询区间)]
            3）积分抵扣：=∑订单.个数[(订单.优惠抵扣 = {积分抵扣}) and (订单状态 in {待发货、已发货、已完成}) 
                （1）积分抵扣金额：=∑订单.积分抵扣金额[(订单.优惠抵扣 = {积分抵扣}) and (订单状态 in {待发货、已发货、已完成}) 
                                    and (订单.下单时间 in 查询区间)]    
            4）优惠券：=∑订单.个数[(订单.优惠抵扣 = {优惠券}) and (订单状态 in {待发货、已发货、已完成}) 
                                    and (订单.下单时间 in 查询区间)]
                （1）优惠券金额：=∑订单.优惠券金额[(订单.优惠抵扣 = {优惠券}) and (订单状态 in {待发货、已发货、已完成}) 
                                    and (订单.下单时间 in 查询区间)]
            5）微众卡+积分：=∑订单.个数[(订单.优惠抵扣 = {微众卡+积分}) 
                                    and (订单状态 in {待发货、已发货、已完成}) 
                                    and (订单.下单时间 in 查询区间)]
                （1）(微众卡+积分)金额：=∑订单.(微众卡+积分)金额[(订单.优惠抵扣 = {微众卡+积分}) 
                                    and (订单状态 in {待发货、已发货、已完成}) 
                                    and (订单.下单时间 in 查询区间)]
            6）微众卡+优惠券：=∑订单.个数[(订单.优惠抵扣 = {微众卡+优惠券}) 
                                    and (订单状态 in {待发货、已发货、已完成}) 
                                    and (订单.下单时间 in 查询区间)]
                （1）(微众卡+优惠券)金额：=∑订单.(微众卡+优惠券)金额[(订单.优惠抵扣 = {微众卡+优惠券}) 
                                    and (订单状态 in {待发货、已发货、已完成}) 
                                    and (订单.下单时间 in 查询区间)]
             备注：目前的一个订单中不能同时使用‘积分’和‘优惠券’，这样我们的‘优惠抵扣’的图表的两项（积分+优惠券；微众卡+积分+优惠券）就不存在了


            9）图形划过展开，展示内容为（该区域类型、订单量、订单量占比、金额）
            10）点击详情跳转到，带入的查询条件
                【筛选日期】：当前‘订单概况’的筛选日期
                【订单名称】：空；【订单编号】：空；【支付方式】：全部；
                【订单状态】：待发货、已发货、已完成【复购筛选】：全部；
                【优惠抵扣】：当前的图形对应的优惠抵扣方式；【仅显示微众卡抵扣订单】：否
"""

Background:
    #说明：toms代表微众商城，jobs代表商户
    #jobs的基础数据设置

    Given jobs登录系统
    And jobs设定会员积分策略
        """
        {
            "be_member_increase_count":400,
            "integral_each_yuan": 10
        }
        """

    When jobs添加支付方式
        """
        [{
            "type": "货到付款",
            "description": "我的货到付款",
            "is_active": "启用"
        },{
            "type": "微信支付",
            "description": "我的微信支付",
            "is_active": "启用",
            "weixin_appid": "12345", 
            "weixin_partner_id": "22345", 
            "weixin_partner_key": "32345", 
            "weixin_sign": "42345"
        },{
            "type": "支付宝",
            "description": "我的支付宝支付",
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
    Given jobs已创建微众卡
        """
        {
            "cards":[{
                "id":"0000001",
                "password":"1234567",
                "status":"未使用",
                "price":110.00
            },{
                "id":"0000002",
                "password":"1234567",
                "status":"未使用",
                "price":90.00
            },{
                "id":"0000003",
                "password":"1234567",
                "status":"未使用",
                "price":100.00
            },{
                "id":"0000004",
                "password":"1234567",
                "status":"未使用",
                "price":50.00
            }]
        }
        """

    And jobs已添加商品
        """
        [{
            "name": "商品1",
            "postage": 10.00,
            "swipe_images": [{
                "url": "/standard_static/test_resource_img/hangzhou1.jpg"
            }],
            "model": {
                "models": {
                    "standard": {
                        "price": 100.00,
                        "weight": 5.0,
                        "stock_type": "无限"
                    }
                }
            },
            "synchronized_mall":"是"
        }, {
            "name": "商品2",
            "postage": 15.00,
            "swipe_images": [{
                "url": "/standard_static/test_resource_img/hangzhou1.jpg"
            }],
            "model": {
                "models": {
                    "standard": {
                        "price": 100.00,
                        "weight": 5.0,
                        "stock_type": "无限"
                    }
                }
            },
            "synchronized_mall":"是"
        }]
        """

    When jobs创建积分应用活动
        """
        [{
            "name": "商品1积分应用",
            "start_date": "2014-8-1",
            "end_date": "10天后",
            "product_name": "商品1",
            "is_permanant_active": "true",
            "rules": [{
                "member_grade": "全部",
                "discount": 20,
                "discount_money": 20.00
            }]
        }, {
            "name": "商品2积分应用",
            "start_date": "2014-8-1",
            "end_date": "10天后",
            "product_name": "商品2",
            "is_permanant_active": "true",
            "rules": [{
                "member_grade": "全部",
                "discount": 20,
                "discount_money": 20.00
            }]
        }]
        """
    And jobs添加优惠券规则
        """
        [{
            "name": "全体券1",
            "money": 10.00,
            "start_date": "2014-8-1",
            "end_date": "10天后",
            "coupon_id_prefix": "coupon1_id_"
        }]
        """

    When jobs批量获取微信用户关注
        | member_name | attention_time    | member_source |    extra   |
        | bill        | 2014-8-5 8:00:00  | 直接关注      | -          |
        | tom         | 2014-9-1 8:00:00  | 推广扫码      | 渠道扫码01 |
        | marry       | 2014-9-1 10:00:00 | 会员分享      | bill       |
        | tom1        | 2014-9-1 8:00:00  | 会员分享      | bill       |
        | tom2        | 2014-9-3 8:00:00  | 会员分享      | bill       |
        | tom3        | 2014-6-1 8:00:00  | 推广扫码      | 渠道扫码01 |

        #在查询区间之前有有效订单；
        #在查询区间之前有无效订单；
        #在查询区间之前无订单；
        #三种有效订单类型：待发货、已发货、已完成
        #无效订单类型：待支付、已取消、退款中、退款完成
        #三种支付方式：支付宝、微信支付、货到付款
        #优惠期扣：微众卡、优惠券、积分、微众卡+优惠券、微众卡+积分
    When 微信用户批量消费jobs的商品
        | order_id |   date   | consumer | product  | payment | pay_type | postage*   | price*    | product_integral |       coupon         | paid_amount*   |  weizoom_card   | alipay*   | wechat*   | cash*   |   action    | order_status*|
        |   0001   | 2014-8-5 | bill     | 商品1,1  | 支付    | 支付宝   | 10.00      | 100.00    |                  |                      | 110.00         | 0000001,1234567 | 0.00      | 0.00      | 0.00    |             | 待发货       |
        |   0002   | 2014-8-6 | tom      | 商品2,2  |         |          | 15.00      | 100.00    |                  |                      | 215.00         |                 | 0.00      | 0.00      | 0.00    |  jobs,取消  | 已取消       |    
        |   0003   | 2014-9-1 | bill     | 商品2,2  | 支付    | 支付宝   | 15.00      | 100.00    |                  |                      | 215.00         | 0000002,1234567 | 125.00    | 0.00      | 0.00    |             | 待发货       |
        |   0004   | 2014-9-2 | tom      | 商品1,1  | 支付    | 微信支付 | 10.00      | 100.00    |                  |                      | 110.00         |                 | 0.00      | 110.00    | 0.00    |  jobs,发货  | 已发货       |
        |   0005   | 2014-9-3 | marry    | 商品1,1  | 支付    | 货到付款 | 10.00      | 100.00    |                  |                      | 110.00         |                 | 0.00      | 0.00      | 110.00  |             | 待发货       |
        |   0006   | 2014-9-3 | tom1     | 商品1,1  |         |          | 10.00      | 100.00    |                  |                      | 110.00         |                 | 0.00      | 0.00      | 0.00    |  jobs,取消  | 已取消       |
        |   0007   | 2014-9-4 | bill     | 商品1,1  | 支付    | 货到付款 | 10.00      | 100.00    |                  |                      | 110.00         |                 | 0.00      | 0.00      | 110.00  |             | 待发货       |
        |   0008   | 2014-9-4 | marry    | 商品1,1  | 支付    | 支付宝   | 10.00      | 100.00    | 200              |                      | 90.00          |                 | 90.00     | 0.00      | 0.00    |  jobs,发货  | 已发货       |
        |   0009   | 2014-9-5 | bill     | 商品1,2  | 支付    | 微信支付 | 10.00      | 100.00    |                  | 全体券1,coupon1_id_1 | 200.00         | 0000003,1234567 | 0.00      | 100.00    | 0.00    |             | 待发货       |
        |   0010   | 2014-9-5 | marry    | 商品1,1  | 支付    | 微信支付 | 10.00      | 100.00    | 200              |                      | 90.00          |                 | 0.00      | 0.00      | 0.00    |  jobs,退款  | 退款中       |
        |   0011   | 2014-9-6 | tom      | 商品1,1  | 支付    | 支付宝   | 10.00      | 100.00    |                  | 全体券1,coupon1_id_2 | 100.00         |                 | 100.00    | 0.00      | 0.00    |  jobs,完成  | 已完成       |
        |   0012   | 2014-9-7 | tom1     | 商品2,1  | 支付    | 微信支付 | 15.00      | 100.00    | 200              |                      | 95.00          |                 | 0.00      | 95.00     | 0.00    |  jobs,完成  | 已完成       |
        |   0013   | 2014-9-8 | tom2     | 商品1,1  | 支付    | 支付宝   | 10.00      | 100.00    |                  | 全体券1,coupon1_id_3 | 100.00         |                 | 100.00    | 0.00      | 0.00    |  jobs,完成  | 已完成       |
        |   0014   | 2014-9-9 | tom3     | 商品2,1  | 支付    | 微信支付 | 15.00      | 100.00    | 200              |                      | 95.00          | 0000004,1234567 | 0.00      | 45.00     | 0.00    |  jobs,完成  | 已完成       |
       #|   0015   | 2014-9-1 | -tom4    | 商品2,1  | 支付    | 货到付款 | 15.00      | 100.00    |                  |                      | 115.00         |                 | 0.00      | 0.00      | 115.00  |  jobs,完成  | 已完成       |
       #|   0016   | 2014-9-1 | -tom4    | 商品2,1  | 支付    | 微信支付 | 15.00      | 100.00    |                  |                      | 115.00         |                 | 0.00      | 0.00      | 115.00  |jobs,完成退款| 退款成功     |
        |   0017   | 今天     | bill     | 商品2,1  |         |          | 15.00      | 100.00    | 200              |                      | 95.00          |                 | 0.00      | 0.00      | 0.00    |             | 待支付       |
        |   0018   | 今天     | tom      | 商品2,1  | 支付    | 支付宝   | 15.00      | 100.00    | 200              |                      | 95.00          |                 | 95.00     | 0.00      | 0.00    |  jobs,发货  | 已发货       |            

@mall2 @bi @salesAnalysis   @stats @stats.order_survey @112233
Scenario:1 订单概况数据，查询区间

    Given jobs登录系统

    When jobs设置筛选日期
        """
        {
            "start_date":"2014-9-1",
            "end_date":"2014-9-21"
        }
        """

    When jobs查询订单概况统计

    #订单概况
    Then jobs获得订单概况统计数据
        """
        {
            "成交订单": 10,
            "成交金额": 1285.00,
            "客单价": 128.50,
            "成交商品": 12,
            "优惠抵扣": 30.00
        }
        """

    #订单趋势
    Then jobs获得订单趋势统计数据
        """
        {
            "待发货":4,
            "已发货":2,
            "已完成":4
        }
        """

    #复购率
    And jobs获得复购率统计数据
        """
        {
            "初次购买":5,
            "重复购买":5
        }
        """

    #买家来源
    And jobs获得买家来源统计数据
        """
        {
            "直接关注购买":3,
            "推广扫码关注购买":3,
            "分享链接关注购买":4,
            "其他":0
        }
        """

    #支付金额
    And jobs获得支付金额统计数据
        """
        {
            "支付宝":435.00,
            "微信支付":390.00,
            "货到付款":220.00,
            "微众卡支付":240.00
        }
        """

    #优惠抵扣
    And jobs获得优惠抵扣统计数据
        """
        {
            "微众卡支付.单量":2,
            "微众卡支付.金额":140.00,
            "积分抵扣.单量":0,
            "积分抵扣.金额":0.00,
            "优惠券.单量":2,
            "优惠券.金额":20.00,
            "微众卡+积分.单量":0,
            "微众卡+积分.金额":0.00,
            "微众卡+优惠券.单量":1,
            "微众卡+优惠券.金额":110.00,
            "优惠抵扣订单总数":5
        }
        """




