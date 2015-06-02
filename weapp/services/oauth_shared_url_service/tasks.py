# -*- coding: utf-8 -*-
"""@package services.oauth_shared_url_service.tasks

"""

from watchdog.utils import watchdog_fatal
from core.exceptionutil import unicode_full_stack
from modules.member import member_settings

from modules.member import integral_new
from modules.member.models import Member, MemberFollowRelation, SOURCE_BY_URL

from celery import task

def process_shared_url(request, args):
	is_new_created_member = False

	if args.has_key('is_new_created_member'):
		is_new_created_member = args['is_new_created_member']

	fmt = request.GET.get(member_settings.FOLLOWED_MEMBER_TOKEN_URL_QUERY_FIELD, None)
	member = request.member

	try:
		if fmt and member and fmt != member.token:
			#建立关系，更新会员来源
			follow_member = Member.objects.get(token=fmt)
			if is_new_created_member:
				MemberFollowRelation.objects.create(member_id=follow_member.id, follower_member_id=member.id, is_fans=is_new_created_member)
				MemberFollowRelation.objects.create(member_id=member.id, follower_member_id=follow_member.id, is_fans=False)
				member.source = SOURCE_BY_URL
				member.save()
			elif MemberFollowRelation.objects.filter(member_id=member.id,follower_member_id=follow_member.id).count() == 0:
				MemberFollowRelation.objects.create(member_id=follow_member.id, follower_member_id=member.id, is_fans=is_new_created_member)
				MemberFollowRelation.objects.create(member_id=member.id, follower_member_id=follow_member.id, is_fans=False)
			#点击分享链接给会员增加积分
			try:
				integral_new.increase_for_click_shared_url(follow_member, member, request.get_full_path())
			except:
				notify_message = u"increase_for_click_shared_url:('member_id':{}), cause:\n{}".format(member.id, unicode_full_stack())
				watchdog_fatal(notify_message)

	except:
		notify_message = u"('fmt':{}), 处理分享信息 cause:\n{}".format(
				fmt, unicode_full_stack())
		watchdog_fatal(notify_message)

#@register('oautu_shared_url')
def serve(request, args):
	process_shared_url(request, args)


@task
def oauth_shared_url(request0, args):
	from services.service_manager import create_request
	request = create_request(args)
	serve(request, args)
	return 'OK'

	