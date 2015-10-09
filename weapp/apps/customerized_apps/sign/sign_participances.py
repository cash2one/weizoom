# -*- coding: utf-8 -*-
import json
from datetime import datetime
from django.http import HttpResponseRedirect, HttpResponse
from django.template import RequestContext
from django.shortcuts import render_to_response
from django.db.models import F
from django.contrib.auth.decorators import login_required
from core import resource
from core import paginator
from core.jsonresponse import create_response
from modules.member import models as member_models
import models as app_models
import export

FIRST_NAV = 'apps'
COUNT_PER_PAGE = 20

class SignParticipances(resource.Resource):
	app = 'apps/sign'
	resource = 'sign_participances'
	
	@login_required
	def get(request):
		"""
		响应GET
		"""
		has_data = app_models.SignParticipance.objects(belong_to=request.GET['id']).count()
		
		c = RequestContext(request, {
			'first_nav_name': FIRST_NAV,
			'second_navs': export.get_second_navs(request),
			'second_nav_name': "signs",
			'has_data': has_data,
			'activity_id': request.GET['id']
		});
		
		return render_to_response('sign/templates/editor/sign_participances.html', c)
	
	@staticmethod
	def get_datas(request):
		datas = app_models.SignParticipance.objects(belong_to=request.GET['id']).order_by('-id')
		#进行分页
		count_per_page = int(request.GET.get('count_per_page', COUNT_PER_PAGE))
		cur_page = int(request.GET.get('page', '1'))
		pageinfo, datas = paginator.paginate(datas, cur_page, count_per_page, query_string=request.META['QUERY_STRING'])
		
		return pageinfo, datas

	@login_required
	def api_get(request):
		"""
		响应API GET
		"""
		pageinfo, datas = SignParticipances.get_datas(request)
		
		webappuser2datas = {}
		webapp_user_ids = set()
		for data in datas:
			webappuser2datas.setdefault(data.webapp_user_id, []).append(data)
			webapp_user_ids.add(data.webapp_user_id)
			data.participant_name = u'未知'
			data.participant_icon = '/static/img/user-1.jpg'
		
		webappuser2member = member_models.Member.members_from_webapp_user_ids(webapp_user_ids)
		if len(webappuser2member) > 0:
			for webapp_user_id, member in webappuser2member.items():
				for data in webappuser2datas.get(webapp_user_id, ()):
					data.participant_name = member.username_for_html
					data.participant_icon = member.user_icon
		
		items = []
		for data in datas:
			items.append({
				'id': str(data.id),
				'participant_name': data.participant_name,
				'participant_icon': data.participant_icon,
				'created_at': data.created_at.strftime("%Y/%m/%d %H:%M:%S"),
				'latest_date': data.latest_date.strftime("%Y/%m/%d %H:%M:%S"),
				'total_count': data.total_count,
				'serial_count': data.serial_count,
				'top_serial_count': data.top_serial_count,
				'total_integral': data.prize['integral'],
				'latest_coupon': data.prize['coupon'].split(',')[-1]
			})
		response_data = {
			'items': items,
			'pageinfo': paginator.to_dict(pageinfo),
			'sortAttr': 'id',
			'data': {}
		}
		response = create_response(200)
		response.data = response_data
		return response.get_response()		

