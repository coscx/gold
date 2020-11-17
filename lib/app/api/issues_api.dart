import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_unit/model/github/issue_comment.dart';
import 'package:flutter_unit/model/github/issue.dart';
import 'package:flutter_unit/model/github/repository.dart';


const kBaseUrl = 'http://as.gugu2019.com';

class IssuesApi {
  static Dio dio = Dio(BaseOptions(baseUrl: kBaseUrl));

  static Future<Map<String,dynamic>> login( String username, String password) async {
    String repoStr;
    var data={'username':username,'password':password};
    Response<dynamic> rep = await dio.post('/admin/auth/applogin.html',queryParameters:data );
     var datas = json.decode(rep.data);

    return datas;
  }

  static Future<Repository> getRepoFlutterUnit() async {
    Response<dynamic> rep = await dio.get('/repository/name/FlutterUnit');
    dynamic repoStr = rep.data['data']['repositoryData'];
    return Repository.fromJson(json.decode(repoStr));
  }

  static Future<List<Issue>> getIssues(
      {int page = 1, int pageSize = 100}) async {
    List<dynamic> res = (await dio.get('/point',
            queryParameters: {"page": page, "pageSize": pageSize}))
        .data['data'] as List;
    return res.map((e) => Issue.fromJson(json.decode(e['pointData']))).toList();
  }

  static Future<List<IssueComment>> getIssuesComment(int pointId) async {
    List<dynamic> res = (await dio.get('/pointComment/$pointId')).data['data'] as List;
    return res
        .map((e) => IssueComment.fromJson(json.decode(e['pointCommentData'])))
        .toList();
  }




}
