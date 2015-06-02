# __author__ : "benchi"
Feature: bill在webapp中进入到待评价列表，对已到货的商品进行评价,评价完成后，商品部在该列表中显示
    

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
            "price": 10.00
        }, {
            "name": "商品2",
            "price": 20.00
        }, {
            "name": "商品3",
            "price": 30.00
        },  {
            "name": "商品4",
            "is_enable_model": "启用规格",
            "model": {
                "models":{
                    "M": {
                        "price": 40.00,
                        "stock_type": "无限"
                    },
                    "S": {
                        "price": 40.00,
                        "stock_type": "无限"
                    }
                }
            }
        }]
    """
    Given bill关注jobs的公众号
    And jobs已有的订单
    """
    [{
        "order_no":"1",
        "member":"bill",
        "type":"普通订单",
        "status":"已完成",
        "sources":"本店",
        "order_price":10.00,
        "payment_price":10.00,
        "freight":0,
        "ship_name":"bill",
        "ship_tel":"13013013011",
        "ship_area":"北京市,北京市,海淀区",
        "ship_address":"泰兴大厦",
        "products":[{
            "name":"商品1",
            "price": 10.00,
            "count": 1
        }]
    },{
        "order_no":"5",
        "member":"bill",
        "type":"普通订单",
        "status":"已完成",
        "sources":"本店",
        "order_price":10.00,
        "payment_price":10.00,
        "freight":0,
        "ship_name":"bill",
        "ship_tel":"13013013011",
        "ship_area":"北京市,北京市,海淀区",
        "ship_address":"泰兴大厦",
        "products":[{
            "name":"商品1",
            "price": 10.00,
            "count": 1
        }]
    },{
        "order_no":"2",
        "member":"bill",
        "type":"普通订单",
        "status":"已完成",
        "sources":"本店",
        "order_price":20.00,
        "payment_price":20.00,
        "freight":0,
        "ship_name":"bill",
        "ship_tel":"13013013011",
        "ship_area":"北京市,北京市,海淀区",
        "ship_address":"泰兴大厦",
        "products":[{
            "name":"商品2",
            "price": 20.00,
            "count": 1
        }]
    },{
        "order_no":"3",
        "member":"bill",
        "type":"普通订单",
        "status":"待支付",
        "sources":"本店",
        "order_price":30.00,
        "payment_price":30.00,
        "freight":0,
        "ship_name":"bill",
        "ship_tel":"13013013011",
        "ship_area":"北京市,北京市,海淀区",
        "ship_address":"泰兴大厦",
        "products":[{
            "name":"商品3",
            "price": 30.00,
            "count": 1
        }]
    },{
        "order_no":"4",
        "member":"bill",
        "type":"普通订单",
        "status":"已完成",
        "sources":"本店",
        "order_price":10.00,
        "payment_price":10.00,
        "freight":0,
        "ship_name":"bill",
        "ship_tel":"13013013011",
        "ship_area":"北京市,北京市,海淀区",
        "ship_address":"泰兴大厦",
        "products":[
        {
            "name":"商品4",
            "model":"M",
            "price": 40.00,
            "count": 1
        }, {
            "name":"商品4",
            "model":"S",
            "price": 40.00,
            "count": 1
        }]
    }]
    """

    When bill访问jobs的webapp
    # 1)在"待评价"中显示的是订单状态为"已完成"的订单；
    Then bill成功获取个人中心的'待评价'列表
    """
    [{
        "order_no": "1",
        "products": [
            {
                "product_name": "商品1"
            }
        ]

    },{
        "order_no": "5",
        "products": [
            {
                "product_name": "商品1"
            }
        ]

    },{
        "order_no": "2",
        "products": [
            {
                "product_name": "商品2"
            }
        ]

    },{
        "order_no": "4",
        "products": [
            {
                "product_name": "商品4",
                "product_model_name": "M"
            },{
                "product_name": "商品4",
                "product_model_name": "S"
            }
        ]
    }]
    """

@mall2 @mall.webapp.comment.ee
Scenario: 1 bill 进入待评价列表，该列表中显示的是订单状态为"已完成"的订单，可以对商品进行评价
            1)在"待评价"中显示的是订单状态为"已完成"的订单；
            2）对订单中的商品评价完后（包括，文字，晒图），那么下次进入"待评价"中，则不会看到该商品
            3）只提供文字评价后，下次进入"待评价"中，则会看到该商品 下，显示"追加晒图"添加完图片之后，该商品则不会显示在"待评价"列表中
            

    #2）对订单中的商品评价完后（包括，文字，晒图），那么下次进入"待评价"中，则不会看到该商品
    When bill完成订单'1'中'商品1'的评价包括'文字与晒图'
    """
        {
            "product_score": "4",
            "review_detail": "商品1还不错！！！！！",
            "serve_score": "4",
            "deliver_score": "4",
            "process_score": "4",
            "picture_list": ["data:image/jpeg;base64,/9j/4AAQSkZJRgABAQEAYABgAAD/2wBDAAIBAQIBAQICAgICAgICAwUDAwMDAwYEBAMFBwYHBwcGBwcICQsJCAgKCAcHCg0KCgsMDAwMBwkODw0MDgsMDAz/2wBDAQICAgMDAwYDAwYMCAcIDAwMDAwMDAwMDAwMDAwMDAwMDAwMDAwMDAwMDAwMDAwMDAwMDAwMDAwMDAwMDAwMDAz/wAARCAAFAAoDASIAAhEBAxEB/8QAHwAAAQUBAQEBAQEAAAAAAAAAAAECAwQFBgcICQoL/8QAtRAAAgEDAwIEAwUFBAQAAAF9AQIDAAQRBRIhMUEGE1FhByJxFDKBkaEII0KxwRVS0fAkM2JyggkKFhcYGRolJicoKSo0NTY3ODk6Q0RFRkdISUpTVFVWV1hZWmNkZWZnaGlqc3R1dnd4eXqDhIWGh4iJipKTlJWWl5iZmqKjpKWmp6ipqrKztLW2t7i5usLDxMXGx8jJytLT1NXW19jZ2uHi4+Tl5ufo6erx8vP09fb3+Pn6/8QAHwEAAwEBAQEBAQEBAQAAAAAAAAECAwQFBgcICQoL/8QAtREAAgECBAQDBAcFBAQAAQJ3AAECAxEEBSExBhJBUQdhcRMiMoEIFEKRobHBCSMzUvAVYnLRChYkNOEl8RcYGRomJygpKjU2Nzg5OkNERUZHSElKU1RVVldYWVpjZGVmZ2hpanN0dXZ3eHl6goOEhYaHiImKkpOUlZaXmJmaoqOkpaanqKmqsrO0tba3uLm6wsPExcbHyMnK0tPU1dbX2Nna4uPk5ebn6Onq8vP09fb3+Pn6/9oADAMBAAIRAxEAPwD9F/2sf2ZviFo/x9/ZygX9pz44yL4g+JN7ZqW07win9mgeEvElxviCaGoc/uPL23AmTbKzbfNWOWP6BtP2YvG1taxxv+0V8Y53RArSyab4UDSED7x26KFyevAA9AKKKAP/2Q=="]
        }
    """
    Then bill成功获取个人中心的'待评价'列表
    """
    [{
        "order_no": "5",
        "products": [
            {
                "product_name": "商品1"
            }
        ]

    },{
        "order_no": "2",
        "products": [
            {
                "product_name": "商品2"
            }
        ]

    },{
        "order_no": "4",
        "products": [
            {
                "product_name": "商品4",
                "product_model_name": "M"
            },{
                "product_name": "商品4",
                "product_model_name": "S"
            }
        ]
    }]
    """

    #3）只提供文字评价后，下次进入"待评价"中，则会看到该商品 下，显示"追加晒图",添加完图片之后，该商品则不会显示在"待评价"列表中 
    When bill完成订单'2'中'商品2'的评价包括'文字'
    """
        {
            "product_score": "4",
            "review_detail": "商品2不太好！！！！！",
            "serve_score": "4",
            "deliver_score": "4",
            "process_score": "4"
        }
    """
    Then bill成功获取个人中心的'待评价'列表
    """
    [{
        "order_no": "5",
        "products": [
            {
                "product_name": "商品1"
            }
        ]

    },{
        "order_no": "2",
        "products": [
            {
                "product_name": "商品2"
            }
        ]

    },{
        "order_no": "4",
        "products": [
            {
                "product_name": "商品4",
                "product_model_name": "M"
            },{
                "product_name": "商品4",
                "product_model_name": "S"
            }
        ]
    }]
    """

    When bill完成订单'2'中'商品2'的评价包括'晒图'
    """
        {
            "product_score": "4",
            "review_detail": "商品2不太好！！！！！",
            "serve_score": "4",
            "deliver_score": "4",
            "process_score": "4",
            "picture_list": ["data:image/jpeg;base64,/9j/4AAQSkZJRgABAQEAYABgAAD/2wBDAAIBAQIBAQICAgICAgICAwUDAwMDAwYEBAMFBwYHBwcGBwcICQsJCAgKCAcHCg0KCgsMDAwMBwkODw0MDgsMDAz/2wBDAQICAgMDAwYDAwYMCAcIDAwMDAwMDAwMDAwMDAwMDAwMDAwMDAwMDAwMDAwMDAwMDAwMDAwMDAwMDAwMDAwMDAz/wAARCAAFAAoDASIAAhEBAxEB/8QAHwAAAQUBAQEBAQEAAAAAAAAAAAECAwQFBgcICQoL/8QAtRAAAgEDAwIEAwUFBAQAAAF9AQIDAAQRBRIhMUEGE1FhByJxFDKBkaEII0KxwRVS0fAkM2JyggkKFhcYGRolJicoKSo0NTY3ODk6Q0RFRkdISUpTVFVWV1hZWmNkZWZnaGlqc3R1dnd4eXqDhIWGh4iJipKTlJWWl5iZmqKjpKWmp6ipqrKztLW2t7i5usLDxMXGx8jJytLT1NXW19jZ2uHi4+Tl5ufo6erx8vP09fb3+Pn6/8QAHwEAAwEBAQEBAQEBAQAAAAAAAAECAwQFBgcICQoL/8QAtREAAgECBAQDBAcFBAQAAQJ3AAECAxEEBSExBhJBUQdhcRMiMoEIFEKRobHBCSMzUvAVYnLRChYkNOEl8RcYGRomJygpKjU2Nzg5OkNERUZHSElKU1RVVldYWVpjZGVmZ2hpanN0dXZ3eHl6goOEhYaHiImKkpOUlZaXmJmaoqOkpaanqKmqsrO0tba3uLm6wsPExcbHyMnK0tPU1dbX2Nna4uPk5ebn6Onq8vP09fb3+Pn6/9oADAMBAAIRAxEAPwD9F/2sf2ZviFo/x9/ZygX9pz44yL4g+JN7ZqW07win9mgeEvElxviCaGoc/uPL23AmTbKzbfNWOWP6BtP2YvG1taxxv+0V8Y53RArSyab4UDSED7x26KFyevAA9AKKKAP/2Q=="]
        }
    """
    Then bill成功获取个人中心的'待评价'列表
    """
    [{
        "order_no": "5",
        "products": [
            {
                "product_name": "商品1"
            }
        ]

    }, {
        "order_no": "4",
        "products": [
            {
                "product_name": "商品4",
                "product_model_name": "M"
            },{
                "product_name": "商品4",
                "product_model_name": "S"
            }
        ]
    }]
    """

@mall2 @mall.webapp.comment.ee
Scenario: 3 同一商品，不同规格进行评价，不会互相影响
    
    When bill关注jobs的公众号
    And bill访问jobs的webapp
    When bill完成订单'4'中'商品4:S'的评价包括'文字与晒图'
    """
        {
            "product_score": "4",
            "review_detail": "商品2不太好！！！！！",
            "serve_score": "4",
            "deliver_score": "4",
            "process_score": "4",
            "picture_list": ["data:image/jpeg;base64,/9j/4AAQSkZJRgABAQEAYABgAAD/2wBDAAIBAQIBAQICAgICAgICAwUDAwMDAwYEBAMFBwYHBwcGBwcICQsJCAgKCAcHCg0KCgsMDAwMBwkODw0MDgsMDAz/2wBDAQICAgMDAwYDAwYMCAcIDAwMDAwMDAwMDAwMDAwMDAwMDAwMDAwMDAwMDAwMDAwMDAwMDAwMDAwMDAwMDAwMDAz/wAARCAAFAAoDASIAAhEBAxEB/8QAHwAAAQUBAQEBAQEAAAAAAAAAAAECAwQFBgcICQoL/8QAtRAAAgEDAwIEAwUFBAQAAAF9AQIDAAQRBRIhMUEGE1FhByJxFDKBkaEII0KxwRVS0fAkM2JyggkKFhcYGRolJicoKSo0NTY3ODk6Q0RFRkdISUpTVFVWV1hZWmNkZWZnaGlqc3R1dnd4eXqDhIWGh4iJipKTlJWWl5iZmqKjpKWmp6ipqrKztLW2t7i5usLDxMXGx8jJytLT1NXW19jZ2uHi4+Tl5ufo6erx8vP09fb3+Pn6/8QAHwEAAwEBAQEBAQEBAQAAAAAAAAECAwQFBgcICQoL/8QAtREAAgECBAQDBAcFBAQAAQJ3AAECAxEEBSExBhJBUQdhcRMiMoEIFEKRobHBCSMzUvAVYnLRChYkNOEl8RcYGRomJygpKjU2Nzg5OkNERUZHSElKU1RVVldYWVpjZGVmZ2hpanN0dXZ3eHl6goOEhYaHiImKkpOUlZaXmJmaoqOkpaanqKmqsrO0tba3uLm6wsPExcbHyMnK0tPU1dbX2Nna4uPk5ebn6Onq8vP09fb3+Pn6/9oADAMBAAIRAxEAPwD9F/2sf2ZviFo/x9/ZygX9pz44yL4g+JN7ZqW07win9mgeEvElxviCaGoc/uPL23AmTbKzbfNWOWP6BtP2YvG1taxxv+0V8Y53RArSyab4UDSED7x26KFyevAA9AKKKAP/2Q=="]
        }
    """

    Then bill成功获取个人中心的'待评价'列表
    """
    [{
        "order_no": "1",
        "products": [
            {
                "product_name": "商品1"
            }
        ]

    },{
        "order_no": "5",
        "products": [
            {
                "product_name": "商品1"
            }
        ]

    },{
        "order_no": "2",
        "products": [
            {
                "product_name": "商品2"
            }
        ]

    },{
        "order_no": "4",
        "products": [
            {
                "product_name": "商品4",
                "product_model_name": "M"
            }
        ]
    }]
    """
