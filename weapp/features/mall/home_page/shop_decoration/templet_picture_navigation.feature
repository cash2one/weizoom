#author：师帅
Feature: 自定义模块-图片导航

@termite2 @ss
Scenario: 1添加图片导航
	Given jobs登录系统
	When jobs创建微页面
	"""
		[{
			"title":{
				"name": "微页面标题1"
			},
			"picture_ids":[{
				"path": "/standard_static/test_resource_img/hangzhou1.jpg",
				"title": "标题1",
				"link": "店铺主页"
			},{
				"path": "/standard_static/test_resource_img/hangzhou2.jpg",
				"title": "标题2",
				"link": "我的订单"
			}, {
				"path": "/standard_static/test_resource_img/hangzhou3.jpg",
				"title": "标题3",
				"link": "会员主页"
			}, {
				"path": "/standard_static/test_resource_img/hangzhou1.jpg",
				"title": "标题4",
				"link": "会员主页"
			}]
		}]
	"""
	Then jobs能获取'微页面标题1'
	"""
		{
			"title":{
				"name": "微页面标题1"
			},
			"picture_ids":[{
				"path": "/standard_static/test_resource_img/hangzhou1.jpg",
				"title": "标题1",
				"link": "店铺主页"
			},{
				"path": "/standard_static/test_resource_img/hangzhou2.jpg",
				"title": "标题2",
				"link": "我的订单"
			}, {
				"path": "/standard_static/test_resource_img/hangzhou3.jpg",
				"title": "标题3",
				"link": "会员主页"
			}, {
				"path": "/standard_static/test_resource_img/hangzhou1.jpg",
				"title": "标题4",
				"link": "会员主页"
			}]
		}
	"""
	When jobs编辑微页面'微页面标题1'
	"""
		{
			"title":{
				"name": "微页面标题1"
			},
			"picture_ids":[{
				"path": "/standard_static/test_resource_img/hangzhou2.jpg",
				"title": "标题1",
				"link": "店铺主页"
			},{
				"path": "/standard_static/test_resource_img/hangzhou1.jpg",
				"title": "标题2",
				"link": "我的订单"
			},{
				"path": "/standard_static/test_resource_img/hangzhou3.jpg",
				"title": "标题3",
				"link": "会员主页"
			},{
				"path": "/standard_static/test_resource_img/hangzhou1.jpg",
				"title": "标题4",
				"link": "我的订单"
			}]
		}
	"""

	Then jobs能获取'微页面标题1'
	"""
		{
			"title":{
				"name": "微页面标题1"
			},
			"picture_ids":[{
				"path": "/standard_static/test_resource_img/hangzhou2.jpg",
				"title": "标题1",
				"link": "店铺主页"
			},{
				"path": "/standard_static/test_resource_img/hangzhou1.jpg",
				"title": "标题2",
				"link": "我的订单"
			},{
				"path": "/standard_static/test_resource_img/hangzhou3.jpg",
				"title": "标题3",
				"link": "会员主页"
			},{
				"path": "/standard_static/test_resource_img/hangzhou1.jpg",
				"title": "标题4",
				"link": "我的订单"
			}]
		}
	"""
	When jobs编辑微页面'微页面标题1'
	"""
		{
			"title":{
				"name": "微页面标题1"
			}
		}
	"""
	Then jobs能获取'微页面标题1'
	"""
		{
			"title":{
				"name": "微页面标题1"
			}
		}
	"""



