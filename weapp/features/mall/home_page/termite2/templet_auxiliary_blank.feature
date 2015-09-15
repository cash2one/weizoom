#author：师帅
#_edit_：新新
Feature: 自定义模块-辅助空白

Background:
	Given jobs登录系统
	And jobs已添加模块
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

#默认每次调节辅助线最小为1px
Scenario: 辅助空白
	When jobs将辅助线调到最低的20px
	Then jobs展示区显示20px的空白高度
	When jobs将辅助线调到最高的100px
	Then jobs展示区显示100px的空白高度
	When jobs每次调整辅助线1px
	Then jobs展示区相应空白高度变化1px

#删除辅助空白

	When jobs删除辅助空白
	Then jobs展示区弹出提示信息
	And jobs展示区当前辅助空白删除,焦点消失
	And  jobs编辑区对应的编辑窗体关闭
	