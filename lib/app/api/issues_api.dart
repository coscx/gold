import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_unit/model/github/issue_comment.dart';
import 'package:flutter_unit/model/github/issue.dart';
import 'package:flutter_unit/model/github/repository.dart';


const kBaseUrl = 'http://119.45.173.197:8080/api/v1';

class IssuesApi {
  static Dio dio = Dio(BaseOptions(baseUrl: kBaseUrl));

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
