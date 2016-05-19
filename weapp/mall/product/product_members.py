# -*- coding: utf-8 -*-
import json
from datetime import datetime
from django.contrib.auth.decorators import login_required
from django.http import HttpResponseRedirect, Http404
from django.shortcuts import render_to_response
from django.template import RequestContext
from watchdog.utils import watchdog_warning, watchdog_error

from core import paginator
from core import resource
from core.exceptionutil import unicode_full_stack
from core.jsonresponse import create_response
from mall import models  # 注意不要覆盖此module
from mall import export
from modules.member.models import WebAppUser,Member,CANCEL_SUBSCRIBED,SUBSCRIBED,MemberGrade,MemberTag
from member.member_list import build_member_has_tags_json,get_tags_json
import logging

COUNT_PER_PAGE = 50

class ProductMember(resource.Resource):
    app = 'mall2'
    resource = 'product_members'

    @login_required
    def get(request):
        """购买该商品的会员列表


        Requirement:
          id(str): must be provided,
                            商品id必须提供， 

        Return:
          HttpResponse: the context in it include:{
            'first_nav_name',
            'second_navs',
            'second_nav_name',
            'id'
          }

        Raise:
          if id is not be provided return product_list
          如果id没有被提供， 将返回到在售商品列表
        """
        mall_type = request.user_profile.webapp_type
        webapp_id = request.user_profile.webapp_id
        if not mall_type:
            return HttpResponseRedirect('/mall2/product_list/?shelve_type=1')
        has_product_id = request.GET.get('id')
        if has_product_id:
            try:
                product = models.Product.objects.get(owner=request.manager, id=has_product_id)
            except models.Product.DoesNotExist:
                return Http404
        else:
            return Http404
        member_tags = MemberTag.get_member_tags(webapp_id)
        #调整排序，将为分组放在最前面
        tags = []
        for tag in member_tags:
            if tag.name == '未分组':
                tags = [tag] + tags
            else:
                tags.append(tag)
        member_tags = tags
        #0:下架（待售） 1:上架（在售）
        if product.shelve_type == 0:
            second_nav_name = export.PRODUCT_MANAGE_OFF_SHELF_PRODUCT_NAV
        else:
            second_nav_name = export.PRODUCT_MANAGE_ON_SHELF_PRODUCT_NAV
        c = RequestContext(
            request,
            {'first_nav_name': export.PRODUCT_FIRST_NAV,
             'second_navs': export.get_mall_product_second_navs(request),
             'second_nav_name': second_nav_name,
             'product_name': product.name,
             'mall_type': mall_type,
             'shelve_type':product.shelve_type,
             'id':has_product_id,
             'user_tags': member_tags,
             'grades': MemberGrade.get_all_grades_list(webapp_id),
             }
        )
        return render_to_response('mall/editor/product_member.html', c)


    @login_required
    def api_get(request):
        """获取商品下的会员列表
        API:
            method: get
            url: mall2/product_members/

        """

        # 商城类型
        mall_type = request.user_profile.webapp_type
        webapp_id = request.user_profile.webapp_id
        has_product_id = request.GET.get('id')
        
        sort_attr = request.GET.get('sort_attr', '-id') #之后处理
        order_has_products = models.OrderHasProduct.objects.filter(product_id=has_product_id, origin_order_id=0)
        order_ids = order_has_products.values_list('order', flat=True)
        orders = models.Order.objects.filter(webapp_id=webapp_id, id__in=order_ids,status__in=[models.ORDER_STATUS_PAYED_NOT_SHIP, 
            models.ORDER_STATUS_PAYED_SHIPED, models.ORDER_STATUS_SUCCESSED, models.ORDER_STATUS_REFUNDING, models.ORDER_STATUS_GROUP_REFUNDING])
        webapp_user_ids = orders.values_list('webapp_user_id', flat=True)
        member_ids = WebAppUser.objects.filter(id__in=webapp_user_ids).values_list('member_id', flat=True)
        members = Member.objects.filter(id__in=member_ids, status__in=[CANCEL_SUBSCRIBED,SUBSCRIBED], is_for_test=0, webapp_id=webapp_id).order_by(sort_attr)
        total_count = members.count()

        count_per_page = int(request.GET.get('count_per_page', COUNT_PER_PAGE))
        cur_page = int(request.GET.get('page', '1'))
        pageinfo, members = paginator.paginate(
            members,
            cur_page,
            count_per_page,
            )
        
        items = []
        for member in members:
            items.append(build_return_member_json(member))
        tags_json = get_tags_json(request)
        response = create_response(200)
        response.data = {
            'items': items,
            'sortAttr': request.GET.get('sort_attr', '-created_at'),
            'pageinfo': paginator.to_dict(pageinfo),
            'tags': tags_json,
            'total_count': total_count,
            'member_ids': list(member_ids)
        }
        return response.get_response()



def build_return_member_json(member):
    from mall.models import Order
    return {
        'id': member.id,
        'username': member.username_for_title,
        'username_truncated': member.username_truncated,
        'user_icon': member.user_icon,
        'grade_name': member.grade.name,
        'integral': member.integral,
        'factor': member.factor,
        'remarks_name': member.remarks_name,
        'created_at': datetime.strftime(member.created_at, '%Y-%m-%d'),
        'last_visit_time': datetime.strftime(member.last_visit_time, '%Y-%m-%d') if member.last_visit_time else '-',
        'session_id': member.session_id,
        'friend_count':  member.friend_count,
        'source':  member.source,
        'tags':build_member_has_tags_json(member),
        'is_subscribed':member.is_subscribed,
        'experience': member.experience,
    }

