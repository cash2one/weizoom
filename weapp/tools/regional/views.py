# -*- coding: utf-8 -*-
import time
from django.core.cache import get_cache
from core.jsonresponse import JsonResponse, create_response, decode_json_str
from core.exceptionutil import unicode_full_stack, full_stack

from models import *

def get_provinces(request):
	response = create_response(200)

	try:
		provinces = _get_all_provinces()
		response.data = provinces
	except:
		response = create_response(500)
		response.innerErrMsg = full_stack()

	return response.get_response()

def _get_all_provinces():
	provinces = {}
	for province in Province.objects.all():
		provinces[province.id] = province.name
	return provinces

def get_cities(request, province_id):
	response = create_response(200)

	try:
		cities = _get_cities_for_province(province_id)
		response.data = cities
	except:
		response = create_response(500)
		response.innerErrMsg = full_stack()

	return response.get_response()

def _get_cities_for_province(province_id):
	cities = {}
	for city in City.objects.filter(province_id=province_id):
		cities[city.id] = city.name
	return cities

def get_districts(request, city_id):
	response = create_response(200)

	try:
		districts = _get_districts_for_city(city_id)
		response.data = districts
	except:
		response = create_response(500)
		response.innerErrMsg = full_stack()

	return response.get_response()

def _get_districts_for_city(city_id):
	districts = {}
	for district in District.objects.filter(city_id=city_id):
		districts[district.id] =district.name
	return districts

def get_str_value_by_string_ids(str_ids):
	if str_ids != '' and str_ids:
		cache = get_cache('mem')
		ship_address = cache.get(str_ids)
		if not ship_address:
			area_args = str_ids.split('_')
			ship_address = ''
			curren_area = ''
			for index, area in enumerate(area_args):

				if index == 0:
					curren_area = Province.objects.get(id=int(area))
				elif index == 1:
					curren_area = City.objects.get(id=int(area))
				elif index == 2:
					curren_area = District.objects.get(id=int(area))
				ship_address =  ship_address + ' ' + curren_area.name
			cache.set(str_ids, ship_address)
		return u'{}'.format(ship_address.strip())
	else:
		return None
try:
	ID2PROVINCE = dict([(p.id, p.name) for p in Province.objects.all()])
	ID2CITY = dict([(c.id, c.name) for c in City.objects.all()])
	ID2DISTRICT = dict([(d.id, d.name) for d in District.objects.all()])
except:
	pass

def get_str_value_by_string_ids_new(str_ids):
	if str_ids != '' and str_ids:
		area_args = str_ids.split('_')
		ship_address = ''
		curren_area = ''
		for index, area in enumerate(area_args):
			if index == 0:
				curren_area = ID2PROVINCE.get(int(area))
			elif index == 1:
				curren_area = ID2CITY.get(int(area))
			elif index == 2:
				curren_area = ID2DISTRICT.get(int(area))
			ship_address =  ship_address + ' ' + curren_area
		return u'{}'.format(ship_address.strip())
	else:
		return None