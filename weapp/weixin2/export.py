# -*- coding: utf-8 -*-

UNBIND_ACCOUNT_FIRST_NAVS = [{
    'name': u'微信',
    'url': '/new_weixin/unbind_account/',
    'inner_name': 'unbind_account',
    'permission': ''
}]

UNBIND_ACCOUNT_FIRST_NAV = 'unbind_account'

UNBIND_ACCOUNT_NAV = {
    'section': u'微信',
    'navs': [
    ]
}

def get_unbind_account_second_navs(request):
    if request.user.username == 'manager':
        pass
    else:
        # webapp_module_views.get_modules_page_second_navs(request)
        second_navs = [UNBIND_ACCOUNT_NAV]

    return second_navs


FIRST_NAVS = [{
    'name': u'首页',
    'url': '/new_weixin/outline/',
    'inner_name': 'home',
    'permission': ''
}, {
    'name': u'消息互动',
    'url': '/new_weixin/realtime_messages/',
    'inner_name': 'message',
    'permission': ''
}, {
    'name': u'高级管理',
    'url': '/new_weixin/materials/',
    'inner_name': 'advance_manage',
    'permission': ''
}, {
    'name': u'公众号设置',
    'url': '/new_weixin/menu/',
    'inner_name': 'mp_user',
    'permission': ''
}, {
    'name': u'百宝箱',
    'url': '/apps/',
    'inner_name': 'apps',
    'permission': ''
}]


#
# 微信概况导航信息
#
HOME_FIRST_NAV = 'home'
HOME_OUTLINE_NAV = 'outline'

HOME_NAV = {
    'section': u'微信概况',
    'navs': [
        {
            'name': HOME_OUTLINE_NAV,
            'title': u'微信概况',
            'url': '/new_weixin/outline/',
            'need_permissions': []
        }
    ]
}

def get_home_second_navs(request):
    if request.user.username == 'manager':
        pass
    else:
        # webapp_module_views.get_modules_page_second_navs(request)
        second_navs = [HOME_NAV]

    return second_navs


#
# 消息互动导航信息
#
MESSAGE_FIRST_NAV = 'message'
MESSAGE_REALTIME_MESSAGE_NAV = 'realtime_messages'
MESSAGE_MASS_SENDING_NAV = 'mass_sending'
MESSAGE_AUTO_REPLY_NAV = 'auto_reply'
MESSAGE_TEMPLATE_MESSAGE_NAV = 'template_message'

MESSAGE_NAV = {
    'section': u'消息互动',
    'navs': [
        {
            'name': MESSAGE_REALTIME_MESSAGE_NAV,
            'title': u'实时消息',
            'url': '/new_weixin/realtime_messages/',
            'need_permissions': []
        },
        {
            'name': MESSAGE_MASS_SENDING_NAV,
            'title': u'群发消息',
            'url': '/new_weixin/mass_sending_messages/',
            'need_permissions': []
        },
        {
            'name': MESSAGE_AUTO_REPLY_NAV,
            'title': u'自动回复',
            'url': '/new_weixin/keyword_rules/',
            'need_permissions': []
        },
        {
            'name': MESSAGE_TEMPLATE_MESSAGE_NAV,
            'title': u'模板消息',
            'url': '/new_weixin/template_messages/',
            'need_permissions': []
        }
    ]
}

def get_message_second_navs(request):
    if request.user.username == 'manager':
        pass
    else:
        # webapp_module_views.get_modules_page_second_navs(request)
        second_navs = [MESSAGE_NAV]

    return second_navs


#
# 高级管理导航信息
#
ADVANCE_MANAGE_FIRST_NAV = 'advance_manage'
ADVANCE_MANAGE_MATERIAL_NAV = 'material'
ADVANCE_MANAGE_FANS_NAV = 'fans'
ADVANCE_MANAGE_QRCODE_NAV = 'qrcode'

ADVANCE_MANAGE_NAV = {
    'section': u'高级管理',
    'navs': [
        {
            'name': ADVANCE_MANAGE_MATERIAL_NAV,
            'title': u'图文管理',
            'url': '/new_weixin/materials/',
            'need_permissions': []
        },
        {
            'name': ADVANCE_MANAGE_FANS_NAV,
            'title': u'粉丝管理',
            'url': '/new_weixin/fanses/',
            'need_permissions': []
        },
        {
            'name': ADVANCE_MANAGE_QRCODE_NAV,
            'title': u'带参数二维码',
            'url': '/new_weixin/qrcodes/',
            'need_permissions': []
        }
    ]
}

def get_advance_manage_second_navs(request):
    if request.user.username == 'manager':
        pass
    else:
        # webapp_module_views.get_modules_page_second_navs(request)
        second_navs = [ADVANCE_MANAGE_NAV]

    return second_navs



#
# 公众号设置导航信息
#
MPUSER_FIRST_NAV = 'mp_user'
MPUSER_BINDING_NAV = 'binding'
MPUSER_MENU_NAV = 'menu'
MPUSER_DIRECT_FOLLOW_NAV = 'direct_follow'

MPUSER_NAV = {
    'section': u'公众号设置',
    'navs': [
        {
            'name': MPUSER_MENU_NAV,
            'title': u'自定义菜单',
            'url': '/new_weixin/menu/',
            'need_permissions': []
        },
        {
            'name': MPUSER_DIRECT_FOLLOW_NAV,
            'title': u'快速关注',
            'url': '/new_weixin/direct_follow/',
            'need_permissions': []
        },
         {
            'name': MPUSER_BINDING_NAV,
            'title': u'公众号绑定',
            'url': '/new_weixin/mp_user/',
            'need_permissions': []
        }
    ]
}

def get_mpuser_second_navs(request):
    if request.user.username == 'manager':
        pass
    else:
        # webapp_module_views.get_modules_page_second_navs(request)
        second_navs = [MPUSER_NAV]

    return second_navs