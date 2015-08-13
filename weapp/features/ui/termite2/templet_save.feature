#_author_:王丽

Feature: 自定义模块编辑-保存
	保存时，做如下两个校验
	1、校验自定义模块中的下面这些规则
		（1）富文本：最多只能输入1000字	
		（2）图片广告：最多只能输入20个字符	
		（3）标题：	1、标题名必填“标题名不能为空”
					2、标题名最大长度为30个字
					3、副标题最大长度为50个字
		（4）文本导航：1、导航名称是必填项‘导航名称不能为空’
						2、链接到必填‘链接地址不能为空’
						3、导航名称不得超过30个字数
		（5）图片导航：1、文字最多5
					    2、四张图片必填，请添加一张图片（此处不用校验，有默认图片，图片不会有空的情况）
						3、链接到：链接到是必填项
		（6）橱窗	1、标题名：最多可输入15个字
					2、内容区标题：最多可输入15个字
					3、内容区说明：最多输入50个字
	2、自定义模块第一次保存，弹窗填写自定义模块名称，模块名称有如下规则
			（1）模块名称不能为空
			（2）空格忽略，认为为空
			（3）去掉首尾空格
			（4）模块名称与现有系统中的自定义模块的名称不能重复


Background:
	Given jobs登录系统
	And jobs已添加自定义模块
	"""
	[{
		"templet_name":"自定义模块1"
	}]
	"""

Scenario:自定义模块保存校验
	#自定义模块添加10个基础模块
	When jobs添加基础模块
	"""
	[	
		{"modle_name": "富文本"},
		{"modle_name": "商品"},
		{"modle_name": "商品列表"},
		{"modle_name": "图片广告"},
		{"modle_name": "公告"},
		{"modle_name": "标题"},
		{"modle_name": "文本导航"},
		{"modle_name": "图片导航"},
		{"modle_name": "辅助空白"},
		{"modle_name": "橱窗"}
	]
	"""
	#校验必填项
	And jobs自定义模块保存

	Then jobs展示区焦点定位到'标题模块'
	And jobs编辑区提示错误信息'标题名不能为空'

	#修改'标题模块'的'标题名称'
	When jobs修改'标题模块'
	"""
	[{
		"title_name":"标题名称小于30"
	}]
	"""
	And jobs自定义模块保存

	Then jobs展示区焦点定位到'文本导航模块'
	And jobs编辑区提示错误信息'导航名称不能为空'
	And jobs编辑区提示错误信息'链接地址不能为空'

	#修改'文本导航模块'的'导航名称'和'链接'
	When jobs修改'文本导航模块'
	"""
	[{
		"navigation_name":"文本导航名称小于30",
		"navigation_link":"文本导航链接"
	}]
	"""
	And jobs自定义模块保存

	Then jobs展示区焦点定位到'图片导航模块'
	And jobs编辑区提示错误信息'链接地址不能为空'

	#修改'图片导航模块'的'图片'和'链接'
	When jobs修改'图片导航模块'
	"""
	[{
		"navigation_picture":"图片1",
		"navigation_link":"链接1"
	},{
		"navigation_picture":"图片2",
		"navigation_link":"链接2"
	},{
		"navigation_picture":"图片3",
		"navigation_link":"链接3"
	},{
		"navigation_picture":"图片4",
		"navigation_link":"链接4"
	}]
	"""
	And jobs自定义模块保存

	Then jobs获得自定义模块命名窗体

	#自定义模块名称校验
	#自定义模块名称为空校验
	#输入空校验
	When jobs添加自定义模块名称
	"""
	[{
		"templet_name":""
	}]
	"""
	Then jobs自定义模块名称编辑窗体提示错误信息'模块名称不能为空'

	#输入空格校验，忽略空格，认为为空
	When jobs修改自定义模块名称
	"""
	[{
		"templet_name":"  "
	}]
	"""
	Then jobs自定义模块名称编辑窗体提示错误信息'模块名称不能为空'

	#自定义模块名称重复校验'自定义模块1'，去掉名称的首尾空格
	When jobs修改自定义模块名称
	"""
	[{
		"templet_name":"  自定义模块1   "
	}]
	"""
	Then jobs自定义模块名称编辑窗体提示错误信息'模块名称不能重复'

	When jobs修改自定义模块名称
	"""
	[{
		"templet_name":"自定义模块2"
	}]
	"""
	Then jobs保存成功，跳转到自定义模块列表页

	#校验字数限制
	#修改'标题模块'的'标题'、'副标题'
	When jobs修改'标题模块'
	"""
	[{
		"title":"标题大于30",
		"subtitle":"副标题大于50"
	}]
	"""

	#修改'文本导航模块'的'导航名称'
	And jobs修改文本导航模块
	"""
	[{
		"navigation_name":"导航名称大于50"
	}]
	"""

	#修改'图片导航模块'的'文字'
	And jobs修改图片导航模块
	"""
	[,{
		"title":"图片标题1大于5"
	},{
		"title":"图片标题2大于5"
	},{
		"title":"图片标题3大于5"
	},{
		"title":"图片标题4大于5"
	}]
	"""

	#修改'橱窗模块'的'标题名'、'内容区标题'、'内容区说明'
	And jobs修改橱窗模块
	"""
	[{
		"display_window_title":"标题名大于15",
		"content_title":"内容区标题大于15",
		"content_explain":"内容区说明大于50"
	}]
	"""

	#自定义模块保存校验字数限制
	When jobs自定义模块保存

	Then jobs展示区焦点定位到'标题模块'
	And jobs编辑区提示错误信息'标题名不能超过30字'
	And jobs编辑区提示错误信息'副标题名不能超过50字'

	When jobs修改标题模块
	"""
	[{
		"title":"标题小于30",
		"subtitle":"副标题小于50"
	}]
	"""	
	And jobs自定义模块保存

	Then jobs展示区焦点定位到'文本导航模块'
	And jobs编辑区提示错误信息'导航名称最多可输入50个字'

	When jobs修改文本导航模块
	"""
	[{
		"navigation_name":"导航名称小于50"
	}]
	"""
	And jobs自定义模块保存

	Then jobs展示区焦点定位到'图片导航模块'
	Then jobs编辑区提示错误信息'描述语最多可输入5个字'

	When jobs修改图片导航模块
	"""
	[,{
		"title":"图片标题1小于5"
	},{
		"title":"图片标题2小于5"
	},{
		"title":"图片标题3小于5"
	},{
		"title":"图片标题4小于5"
	}]
	"""
	And jobs自定义模块保存

	Then jobs展示区焦点定位到'橱窗模块'
	And jobs编辑区提示错误信息'橱窗标题名不能多于15字'
	And jobs编辑区提示错误信息'内容标题不能多于15字'
	And jobs编辑区提示错误信息'内容说明不能多于50字'

	When jobs修改橱窗模块
	"""
	[{
		"display_window_title":"标题名小于15",
		"content_title":"内容区标题小于15",
		"content_explain":"内容区说明小于50"
	}]
	"""
	And jobs 自定义模块保存
	Then jobs保存成功，跳转到自定义模块列表页
