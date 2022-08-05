import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart';
import 'package:http/http.dart' as h;
import 'package:task_project/model/company_item.dart';

class ApiProvider{
  ///GET ALL COMPANIES
  Future<List<CompanyItem>> getCompaniesList() async {
    try {
      Response response =
      await h.get(Uri.parse("https://easyenglishuzb.free.mockoapp.net/companies"));
      if (response.statusCode == 200) {
        List<CompanyItem> companies = (jsonDecode(response.body)['data'] as List?)
            ?.map((e) => CompanyItem.fromJson(e))
            .toList() ??
            [];
        return companies;
      } else {
        throw Exception();
      }
    } catch (error) {
      debugPrint(error.toString());
      throw Exception(error);
    }
  }

  /// GET SINGLE COMPANY
  Future<CompanyItem> getSingleCompany({required int companyId}) async {
    try {
      Response response = await h
          .get(Uri.parse("https://easyenglishuzb.free.mockoapp.net/companies/$companyId"));
      if (response.statusCode == 200) {
        return CompanyItem.fromJson(jsonDecode(response.body));
      } else {
        throw Exception();
      }
    } catch (e) {
      throw Exception(e);
    }
  }
}