
import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';

final dioOtions = BaseOptions(
baseUrl:'http://192.168.16.84:8000',
);

final dio = Dio(dioOtions);

Future postFile(File file) async{
  try {
final response = await dio.post("/uploadfile/",
  data: FormData.fromMap({
'file': await MultipartFile.fromFile(file.path, filename: "image.jpg"),
  })
);
log(response.data.toString());
return response.data.toString();
  }on Exception catch(e){
    log(e.toString());
  }
}