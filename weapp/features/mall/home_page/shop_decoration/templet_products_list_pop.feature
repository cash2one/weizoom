#_author_:师帅 15/10/12


Feature:自定义模块——【基础模块】商品列表-页面

Background:
	Given jobs登录系统
	And jobs已添加分组
		"""
		[{
			"name": "分组1"
		},{
			"name": "分组2",
		},{
			"name": "分组3"
		},{
			"name": "分组4"
		},{
			"name": "分类5"
		},{
			"name": "分类6"
		},{
			"name": "分类7"
		},{
			"name": "分类8"
		},{
			"name": "分类9",
		}]
		"""
	And jobs已添加商品
		"""
		[{
			"name": "商品1可单行显示",
			"category": "分组1,分组2,分组3",
			"shelve_type":"上架",
			"price": 1.0
		},{
			"name": "商品2可两行显示",
			"category": "分组1,分组2,分组3",
			"shelve_type":"上架",
			"price": 2.0
		},{
			"name": "商品3不可两行显示",
			"category": "分组1,分组2,分组3",
			"shelve_type":"上架",
			"price": 3.0
		},{
			"name": "商品4",
			"category": "分组1,分组2,分组3",
			"shelve_type":"上架",
			"price": 4.0
		},{
			"name": "商品5",
			"category": "分组1,分组2,分组3",
			"shelve_type":"上架",
			"price": 5.0
		},{
			"name": "商品6",
			"category": "分组1,分组2,分组3",
			"shelve_type":"上架",
			"price": 6.0
		}]
		"""

Scenario:0选择商品分组窗体：商品分组列表搜索、添加新商品分组
	#选择商品分组名称的搜索
	#模糊匹配
	When jobs按商品分组名称搜索
		"""
		[{
			"search":"分类"
		}]
		"""
	Then jobs在微页面获得商品分组列表
		"""
		[{
			"name": "分类5",
		},{
			"name": "分类6",
		},{
			"name": "分类7",
		},{
			"name": "分类8",
		},{
			"name": "分类9",
		}]
		"""
	#完全匹配
	When jobs按商品分组名称搜索
		"""
		[{
			"search":"分类6"
		}]
		"""
	Then jobs在微页面获得商品分组列表
		"""
		[{
			"name": "分类6",
		}]
		"""
	#空搜索
	When jobs按商品分组名称搜索
		"""
		[{
			"search":""
		}]
		"""
	Then jobs在微页面获得商品分组列表
		"""
		[{
			"name": "分组1",
		},{
			"name": "分组2",
		},{
			"name": "分组3",
		},{
			"name": "分组4",
		},{
			"name": "分类5",
		},{
			"name": "分类6",
		},{
			"name": "分类7",
		},{
			"name": "分类8",
		},{
			"name": "分类9",
		}]
		"""
	#添加新分组
	When jobs添加分组
		"""
		[{
			"name":"新分组",
		}]
		"""
	Then jobs在微页面获得商品分组列表
		"""
		[{
			"name": "分组1"
		},{
			"name": "分组2"
		},{
			"name": "分组3"
		},{
			"name": "分组4"
		},{
			"name": "分类5"
		},{
			"name": "分类6"
		},{
			"name": "分类7",
		},{
			"name": "分类8"
		},{
			"name": "分类9"
		},{
			"name": "新分组"
		}]
		"""

Scenario:1 商品分组选择列表分页
	When jobs获取商品分组选择列表
		"""
		[{
			"name": "分组1",
		},{
			"name": "分组2",
		},{
			"name": "分组3",
		},{
			"name": "分组4",
		},{
			"name": "分类5",
		},{
			"name": "分类6",
		},{
			"name": "分类7",
		},{
			"name": "分类8",
		},{
			"name": "分类9",
		}]
		"""

	Then jobs获取商品列表模块商品分组选择列表显示共2页
	When jobs访问商品分组列表第1页
	Then jobs获取商品分组选择列表
		"""
		[{
			"name": "分组1",
		},{
			"name": "分组2",
		},{
			"name": "分组3",
		},{
			"name": "分组4",
		},{
			"name": "分类5",
		},{
			"name": "分类6",
		},{
			"name": "分类7",
		},{
			"name": "分类8",
			}]
	"""
	When jobs在微页面浏览'下一页'商品分组
	Then jobs获取商品分组选择列表
		"""
		[{
			"name": "分类9",
		}]
		"""
	When jobs在微页面浏览'上一页'商品分组
	Then jobs获取商品分组列表
		"""
		[{
			"name": "分组1",
		},{
			"name": "分组2",
		},{
			"name": "分组3",
		},{
			"name": "分组4",
		},{
			"name": "分类5",
		},{
			"name": "分类6",
		},{
			"name": "分类7",
		},{
			"name": "分类8",
		}]
		"""

Scenario:4 分组管理修改商品名，商品列表中使用该分组的商品来源，也应该同步修改

	#商品列表模块显示个数'6','详细列表'样式,'默认样式'
	When jobs创建微页面
		"""
		[{	"title":{
				"name": "微页面标题1"
			},
			"products_source": {
				"items":[{
					"products_source_name":"分组1"
				}],
				"display_count":"6"
				"list_style1":"列表",
				"list_style2":"默认样式"
			}
		}]
		"""
	Then jobs能获取'微页面标题1'
		"""
		{
			"title":{
				"name": "微页面标题1"
			},
			"products_source":{
				"items":[{
					"name":"商品1可单行显示",
					"price": 1.0
					},{
					"name":"商品2可两行显示",
					"price": 2.0
					},{
					"name":"商品3不可两行显示",
					"price": 3.0
					},{
					"name":"商品4",
					"price": 4.0
					},{
					"name":"商品5",
					"price": 5.0
					},{
					"name":"商品6",
					"price": 6.0
				}],
				"list_style1":"列表",
				"list_style2":"默认样式"
			}
		}
		"""

	#修改商品分组名称
	When jobs更新商品分组'分组1'
		"""
		{
			"grouping_name":"分组1——修改"
		}
		"""
	Then jobs在微页面获得商品分组列表
		"""
		[{
			"name": "分组1——修改"
		},{
			"name": "分组2"
		},{
			"name": "分组3"
		},{
			"name": "分组4"
		},{
			"name": "分类5"
		},{
			"name": "分类6"
		},{
			"name": "分类7"
		},{
			"name": "分类8"
		}]
		"""
	When jobs-永久删除商品分组'分组2'
	Then jobs在微页面获得商品分组列表
		"""
		[{
			"name": "分组1——修改"
		},{
			"name": "分组3"
		},{
			"name": "分组4"
		},{
			"name": "分类5"
		},{
			"name": "分类6"
		},{
			"name": "分类7"
		},{
			"name": "分类8"
		},{
			"name": "分类9"
		}]
		"""
