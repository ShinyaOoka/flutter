import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

enum LoadingState { LOADING, DONE, ERROR, EMPTY }

enum SizeStyle { SMALL, NORMAL, LARGE, SUPER }

const LocaleType localeTypeJP = LocaleType.jp;
const Locale localeJP = Locale('ja', 'JP');
const String comma = ',';
const String slash = '/';
const String space = ' ';


//get image url
String getImageUrl(String path) => path;

//Date time
const String yyyyMMdd = 'yyyy/MM/dd';
const String yyyy_MM_dd_ = 'yyyy年MM月dd日';
const String hh_mm_ = 'hh時mm分';
const String hh_space_mm = 'hh: mm';
const String pdfFileName = 'report';
//css style
const  String uncheckIcon = '<span class="square"></span>';
const  String checkIcon = '<span class="square-black"></span>';
const  String textCircle = '<span class="square-black"></span>';
const  String styleCSSMore = '.square {display: inline-block;width: 12px;height: 12px;margin-left: 2px;margin-right: 2px;border: 1px black solid;}.square-black {display: inline-block;width: 12px;height: 12px;margin-left: 2px;margin-right: 2px;border: 1px black solid;background: black;}.text-circle {border-radius: 100%;padding: 2px;background: #fff;border: 1px solid #000;text-align: center}';
const uncheckYes = '$uncheckIcon有';
const checkedYes = '$checkIcon有';
const uncheckNo = '$uncheckIcon無';
const checkedNo = '$checkIcon無';



//Report file
const String assetInjuredPersonTransportCertificate = 'assets/report/injured_person_transport_certificate.html';




const String APP_NAME = 'AK AZM';






