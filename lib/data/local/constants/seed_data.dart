import "package:ak_azm_flutter/data/local/constants/db_constants.dart";
import "package:sqflite/sqflite.dart";

class SeedData {
  SeedData._();

  static const teams = [
    {
      "TeamCD": "000",
      "Name": "中央消防署第1救急隊",
      "Abbreviation": "中央救急隊",
      "TEL": "0438-64-0165",
      "FireStationCD": "001"
    },
    {
      "TeamCD": "001",
      "Name": "中央消防署第2救急隊",
      "Abbreviation": "中央救急隊",
      "TEL": "0438-64-0165",
      "FireStationCD": "001"
    },
    {
      "TeamCD": "002",
      "Name": "長浦消防署第1救急隊",
      "Abbreviation": "長浦救急隊",
      "TEL": "0438-62-9728",
      "FireStationCD": "002"
    },
    {
      "TeamCD": "003",
      "Name": "長浦消防署第2救急隊",
      "Abbreviation": "長浦救急隊",
      "TEL": "0438-62-9728",
      "FireStationCD": "002"
    },
    {
      "TeamCD": "004",
      "Name": "平川消防署第1救急隊",
      "Abbreviation": "平川救急隊",
      "TEL": "0438-75-3116",
      "FireStationCD": "003"
    },
    {
      "TeamCD": "005",
      "Name": "平川消防署第2救急隊",
      "Abbreviation": "平川救急隊",
      "TEL": "0438-75-3116",
      "FireStationCD": "003"
    },
    {
      "TeamCD": "1--------01--------0",
      "Name": "フル桁検証用チーム名１２３４５６７８９０",
      "Abbreviation": "フル桁隊略名１２３４",
      "TEL": "12345678901234567890",
      "FireStationCD": "1--------01--------0"
    }
  ];

  static const fireStations = [
    {
      "FireStationCD": "001",
      "Name": "袖ケ浦市中央消防署",
      "Address": "千葉県袖ケ浦市福王台4丁目10番地7",
      "TEL": "0438-64-XXX5"
    },
    {
      "FireStationCD": "002",
      "Name": "袖ケ浦市長浦消防署",
      "Address": "千葉県袖ケ浦市長浦580番地146",
      "TEL": "0438-62-XXX5"
    },
    {
      "FireStationCD": "003",
      "Name": "袖ケ浦市平川消防署",
      "Address": "千葉県袖ケ浦市横田213番地",
      "TEL": "0438-75-XXX6"
    },
    {
      "FireStationCD": "1--------01--------0",
      "Name": "フル桁消防署名８９０１２３４５６７８９０",
      "Address": "フル桁住所６７８９０１２３４５６７８９０１２３４５６７８９０１２３４５６７８９０１２３４５６７８９０１２３４５６７８９０",
      "TEL": "XXXXX-XXXXX-XXXXXXXXXX"
    }
  ];

  static const hospitals = [
    {
      "HospitalCD": "0000001",
      "Name": "袖ケ浦さつき台病院",
      "Address": "千葉県袖ケ浦市長浦駅5-21",
      "TEL": "0438-62-XXX3",
      "EmergencyMedicineLevel": 2,
    },
    {
      "HospitalCD": "0000002",
      "Name": "Ｋｅｎクリニック",
      "Address": "千葉県袖ケ浦市蔵波6-19-1",
      "TEL": "0438-64-XXX1",
      "EmergencyMedicineLevel": 1,
    },
    {
      "HospitalCD": "0000003",
      "Name": "袖ケ浦医院",
      "Address": "千葉県袖ケ浦市奈良輪1-8-8",
      "TEL": "0438-62-XXX1",
      "EmergencyMedicineLevel": 1,
    },
    {
      "HospitalCD": "0000004",
      "Name": "福王台外科内科",
      "Address": "千葉県袖ケ浦市福王台1-10-9",
      "TEL": "0438-62-XXX1",
      "EmergencyMedicineLevel": 1,
    },
    {
      "HospitalCD": "0000005",
      "Name": "山口医院",
      "Address": "千葉県袖ケ浦市奈良輪535-1",
      "TEL": "0438-62-XXX6",
      "EmergencyMedicineLevel": 2,
    },
    {
      "HospitalCD": "0000006",
      "Name": "佐野医院",
      "Address": "千葉県袖ケ浦市奈良輪1-9-8",
      "TEL": "0438-62-XXX8",
      "EmergencyMedicineLevel": 1,
    },
    {
      "HospitalCD": "0000007",
      "Name": "田中医院",
      "Address": "千葉県袖ケ浦市神納2-10-7",
      "TEL": "0438-62-XXX0",
      "EmergencyMedicineLevel": 1,
    },
    {
      "HospitalCD": "0000008",
      "Name": "石井内科小児科医院",
      "Address": "千葉県袖ケ浦市蔵波4-13-8",
      "TEL": "0438-62-XXX0",
      "EmergencyMedicineLevel": 1,
    },
    {
      "HospitalCD": "0000009",
      "Name": "田部整形外科",
      "Address": "千葉県袖ケ浦市蔵波5-19-7",
      "TEL": "0438-62-XXX5",
      "EmergencyMedicineLevel": 1,
    },
    {
      "HospitalCD": "0000010",
      "Name": "犬丸内科皮膚科クリニック",
      "Address": "千葉県袖ケ浦市蔵波2-28-5",
      "TEL": "0438-64-XXX1",
      "EmergencyMedicineLevel": 1,
    },
    {
      "HospitalCD": "0000011",
      "Name": "菱沼医院",
      "Address": "千葉県袖ケ浦市福王台3-1-1",
      "TEL": "0438-62-XXX2",
      "EmergencyMedicineLevel": 1,
    },
    {
      "HospitalCD": "0000013",
      "Name": "井出医院",
      "Address": "千葉県袖ケ浦市横田3669",
      "TEL": "0438-75-XXX0",
      "EmergencyMedicineLevel": 1,
    },
    {
      "HospitalCD": "0000015",
      "Name": "高橋医院",
      "Address": "千葉県袖ケ浦市横田2624",
      "TEL": "0438-75-XXX7",
      "EmergencyMedicineLevel": 1,
    },
    {
      "HospitalCD": "0000019",
      "Name": "わたなべ皮フ科形成外科クリニック",
      "Address": "千葉県袖ケ浦市神納707-1",
      "TEL": "0438-60-XXX1",
      "EmergencyMedicineLevel": 1,
    },
    {
      "HospitalCD": "0000022",
      "Name": "平岡医院",
      "Address": "千葉県袖ケ浦市野里1773-1",
      "TEL": "0438-60-XXX7",
      "EmergencyMedicineLevel": 1,
    },
    {
      "HospitalCD": "0000025",
      "Name": "袖ケ浦クリニック",
      "Address": "千葉県袖ケ浦市奈良輪2-2-4",
      "TEL": "0438-60-XXX1",
      "EmergencyMedicineLevel": 1,
    },
    {
      "HospitalCD": "0000026",
      "Name": "さくま耳鼻咽喉科医院",
      "Address": "千葉県袖ケ浦市神納617-1",
      "TEL": "0438-60-XXX7",
      "EmergencyMedicineLevel": 1,
    },
    {
      "HospitalCD": "0000027",
      "Name": "蔵波台ハートクリニック",
      "Address": "千葉県袖ケ浦市蔵波5-17-2",
      "TEL": "0438-63-XXX0",
      "EmergencyMedicineLevel": 1,
    },
    {
      "HospitalCD": "0000029",
      "Name": "かんのう整形外科",
      "Address": "千葉県袖ケ浦市神納689-1",
      "TEL": "0438-60-XXX7",
      "EmergencyMedicineLevel": 1,
    },
    {
      "HospitalCD": "0000033",
      "Name": "長浦泌尿器科クリニック",
      "Address": "千葉県袖ケ浦市久保田2863-1",
      "TEL": "0438-63-XXX2",
      "EmergencyMedicineLevel": 1,
    },
    {
      "HospitalCD": "0000034",
      "Name": "袖ヶ浦どんぐりクリニック",
      "Address": "千葉県袖ケ浦市袖ケ浦1-39-2",
      "TEL": "0438-63-XXX7",
      "EmergencyMedicineLevel": 1,
    },
    {
      "HospitalCD": "0000037",
      "Name": "よしだ胃腸内科クリニック",
      "Address": "千葉県袖ケ浦市蔵波6-1-5",
      "TEL": "0438-60-XXX1",
      "EmergencyMedicineLevel": 1,
    },
    {
      "HospitalCD": "0000038",
      "Name": "袖ケ浦メディカルクリニック",
      "Address": "千葉県袖ケ浦市蔵波4-20-9",
      "TEL": "0438-38-XXX5",
      "EmergencyMedicineLevel": 1,
    },
    {
      "HospitalCD": "0010001",
      "Name": "君津中央病院",
      "Address": "",
      "TEL": "",
      "EmergencyMedicineLevel": 3,
    },
    {
      "HospitalCD": "0010002",
      "Name": "木更津東邦病院",
      "Address": "",
      "TEL": "",
      "EmergencyMedicineLevel": 2,
    },
    {
      "HospitalCD": "0010003",
      "Name": "はぎわら病院",
      "Address": "",
      "TEL": "",
      "EmergencyMedicineLevel": 2,
    },
    {
      "HospitalCD": "0010004",
      "Name": "薬丸病院",
      "Address": "",
      "TEL": "",
      "EmergencyMedicineLevel": 2,
    },
    {
      "HospitalCD": "0010005",
      "Name": "重城病院",
      "Address": "",
      "TEL": "",
      "EmergencyMedicineLevel": 2,
    },
    {
      "HospitalCD": "0010006",
      "Name": "上総記念病院",
      "Address": "",
      "TEL": "",
      "EmergencyMedicineLevel": 2,
    },
    {
      "HospitalCD": "0010009",
      "Name": "石井病院",
      "Address": "",
      "TEL": "",
      "EmergencyMedicineLevel": 2,
    },
    {
      "HospitalCD": "0010010",
      "Name": "木更津病院",
      "Address": "",
      "TEL": "",
      "EmergencyMedicineLevel": 1,
    },
    {
      "HospitalCD": "0010024",
      "Name": "君津郡市夜間急病診療所",
      "Address": "",
      "TEL": "",
      "EmergencyMedicineLevel": 1,
    },
    {
      "HospitalCD": "0010052",
      "Name": "森田医院",
      "Address": "",
      "TEL": "",
      "EmergencyMedicineLevel": 2,
    },
    {
      "HospitalCD": "0010071",
      "Name": "房総メディカルクリニック",
      "Address": "",
      "TEL": "",
      "EmergencyMedicineLevel": 1,
    },
    {
      "HospitalCD": "0010080",
      "Name": "内房整形外科クリニック",
      "Address": "",
      "TEL": "",
      "EmergencyMedicineLevel": 1,
    },
    {
      "HospitalCD": "0020001",
      "Name": "玄々堂君津病院",
      "Address": "",
      "TEL": "",
      "EmergencyMedicineLevel": 2,
    },
    {
      "HospitalCD": "0020002",
      "Name": "鈴木病院",
      "Address": "",
      "TEL": "",
      "EmergencyMedicineLevel": 2,
    },
    {
      "HospitalCD": "0030001",
      "Name": "君津中央病院大佐和分院",
      "Address": "",
      "TEL": "",
      "EmergencyMedicineLevel": 2,
    },
    {
      "HospitalCD": "0030003",
      "Name": "東病院",
      "Address": "",
      "TEL": "",
      "EmergencyMedicineLevel": 2,
    },
    {
      "HospitalCD": "0040001",
      "Name": "帝京大学ちば総合医療センター",
      "Address": "",
      "TEL": "",
      "EmergencyMedicineLevel": 2,
    },
    {
      "HospitalCD": "0040002",
      "Name": "千葉県循環器病センター",
      "Address": "",
      "TEL": "",
      "EmergencyMedicineLevel": 2,
    },
    {
      "HospitalCD": "0040003",
      "Name": "鎗田病院",
      "Address": "",
      "TEL": "",
      "EmergencyMedicineLevel": 2,
    },
    {
      "HospitalCD": "0040004",
      "Name": "五井病院",
      "Address": "",
      "TEL": "",
      "EmergencyMedicineLevel": 2,
    },
    {
      "HospitalCD": "0040007",
      "Name": "辰巳病院",
      "Address": "",
      "TEL": "",
      "EmergencyMedicineLevel": 2,
    },
    {
      "HospitalCD": "0040011",
      "Name": "千葉ろうさい病院",
      "Address": "",
      "TEL": "",
      "EmergencyMedicineLevel": 2,
    },
    {
      "HospitalCD": "0040012",
      "Name": "長谷川病院",
      "Address": "",
      "TEL": "",
      "EmergencyMedicineLevel": 2,
    },
    {
      "HospitalCD": "0040043",
      "Name": "白金整形外科クリニック",
      "Address": "",
      "TEL": "",
      "EmergencyMedicineLevel": 2,
    },
    {
      "HospitalCD": "0050004",
      "Name": "千葉大学医学部附属病院",
      "Address": "",
      "TEL": "",
      "EmergencyMedicineLevel": 3,
    },
    {
      "HospitalCD": "0050005",
      "Name": "千葉県がんセンター",
      "Address": "",
      "TEL": "",
      "EmergencyMedicineLevel": 2,
    },
    {
      "HospitalCD": "0050006",
      "Name": "千葉県救急医療センター",
      "Address": "",
      "TEL": "",
      "EmergencyMedicineLevel": 3,
    },
    {
      "HospitalCD": "0060014",
      "Name": "亀田総合病院",
      "Address": "",
      "TEL": "",
      "EmergencyMedicineLevel": 3,
    },
    {
      "HospitalCD": "0070061",
      "Name": "ＡＯＩ国際病院",
      "Address": "",
      "TEL": "",
      "EmergencyMedicineLevel": 3,
    },
    {
      "HospitalCD": "1--------01--------0",
      "Name": "フル桁病院名７８９０１２３４５６７８９０",
      "Address": "フル桁住所６７８９０１２３４５６７８９０１２３４５６７８９０１２３４５６７８９０１２３４５６７８９０１２３４５６７８９０",
      "TEL": "XXXXX-XXXXX-XXXXXXXXXX",
      "EmergencyMedicineLevel": 3,
    }
  ];

  static const classifications = [
    {
      "ClassificationCD": "001",
      "ClassificationSubCD": "000",
      "Value": "男",
      "Description": "性別"
    },
    {
      "ClassificationCD": "001",
      "ClassificationSubCD": "001",
      "Value": "女",
      "Description": "性別"
    },
    {
      "ClassificationCD": "002",
      "ClassificationSubCD": "000",
      "Value": "火災",
      "Description": "事故種別"
    },
    {
      "ClassificationCD": "002",
      "ClassificationSubCD": "001",
      "Value": "自然災害",
      "Description": "事故種別"
    },
    {
      "ClassificationCD": "002",
      "ClassificationSubCD": "002",
      "Value": "水難事故",
      "Description": "事故種別"
    },
    {
      "ClassificationCD": "002",
      "ClassificationSubCD": "003",
      "Value": "交通事故",
      "Description": "事故種別"
    },
    {
      "ClassificationCD": "002",
      "ClassificationSubCD": "004",
      "Value": "労働災害",
      "Description": "事故種別"
    },
    {
      "ClassificationCD": "002",
      "ClassificationSubCD": "005",
      "Value": "運動競技",
      "Description": "事故種別"
    },
    {
      "ClassificationCD": "002",
      "ClassificationSubCD": "006",
      "Value": "一般負傷",
      "Description": "事故種別"
    },
    {
      "ClassificationCD": "002",
      "ClassificationSubCD": "007",
      "Value": "加害",
      "Description": "事故種別"
    },
    {
      "ClassificationCD": "002",
      "ClassificationSubCD": "008",
      "Value": "自損行為",
      "Description": "事故種別"
    },
    {
      "ClassificationCD": "002",
      "ClassificationSubCD": "009",
      "Value": "急病",
      "Description": "事故種別"
    },
    {
      "ClassificationCD": "002",
      "ClassificationSubCD": "010",
      "Value": "転院搬送",
      "Description": "事故種別"
    },
    {
      "ClassificationCD": "002",
      "ClassificationSubCD": "099",
      "Value": "その他",
      "Description": "事故種別"
    },
    {
      "ClassificationCD": "003",
      "ClassificationSubCD": "000",
      "Value": "自立",
      "Description": "ADL"
    },
    {
      "ClassificationCD": "003",
      "ClassificationSubCD": "001",
      "Value": "全介助",
      "Description": "ADL"
    },
    {
      "ClassificationCD": "003",
      "ClassificationSubCD": "002",
      "Value": "部分介助",
      "Description": "ADL"
    },
    {
      "ClassificationCD": "004",
      "ClassificationSubCD": "000",
      "Value": "シートベルト",
      "Description": "交通事故"
    },
    {
      "ClassificationCD": "004",
      "ClassificationSubCD": "001",
      "Value": "エアバック",
      "Description": "交通事故"
    },
    {
      "ClassificationCD": "004",
      "ClassificationSubCD": "002",
      "Value": "シートベルト＋エアバック",
      "Description": "交通事故"
    },
    {
      "ClassificationCD": "004",
      "ClassificationSubCD": "003",
      "Value": "チャイルドシート",
      "Description": "交通事故"
    },
    {
      "ClassificationCD": "004",
      "ClassificationSubCD": "004",
      "Value": "ヘルメット",
      "Description": "交通事故"
    },
    {
      "ClassificationCD": "004",
      "ClassificationSubCD": "005",
      "Value": "不明",
      "Description": "交通事故"
    },
    {
      "ClassificationCD": "005",
      "ClassificationSubCD": "000",
      "Value": "正常",
      "Description": "顔貌"
    },
    {
      "ClassificationCD": "005",
      "ClassificationSubCD": "001",
      "Value": "紅潮",
      "Description": "顔貌"
    },
    {
      "ClassificationCD": "005",
      "ClassificationSubCD": "002",
      "Value": "蒼白",
      "Description": "顔貌"
    },
    {
      "ClassificationCD": "005",
      "ClassificationSubCD": "003",
      "Value": "チアノーゼ",
      "Description": "顔貌"
    },
    {
      "ClassificationCD": "005",
      "ClassificationSubCD": "004",
      "Value": "発汗",
      "Description": "顔貌"
    },
    {
      "ClassificationCD": "005",
      "ClassificationSubCD": "005",
      "Value": "苦悶",
      "Description": "顔貌"
    },
    {
      "ClassificationCD": "006",
      "ClassificationSubCD": "000",
      "Value": "無",
      "Description": "失禁"
    },
    {
      "ClassificationCD": "006",
      "ClassificationSubCD": "001",
      "Value": "尿",
      "Description": "失禁"
    },
    {
      "ClassificationCD": "006",
      "ClassificationSubCD": "002",
      "Value": "便",
      "Description": "失禁"
    },
    {
      "ClassificationCD": "006",
      "ClassificationSubCD": "003",
      "Value": "尿＋便",
      "Description": "失禁"
    },
    {
      "ClassificationCD": "007",
      "ClassificationSubCD": "000",
      "Value": "用手",
      "Description": "気道確保"
    },
    {
      "ClassificationCD": "007",
      "ClassificationSubCD": "001",
      "Value": "エアウェイ",
      "Description": "気道確保"
    },
    {
      "ClassificationCD": "008",
      "ClassificationSubCD": "000",
      "Value": "頸椎のみ",
      "Description": "脊髄運動制限"
    },
    {
      "ClassificationCD": "008",
      "ClassificationSubCD": "001",
      "Value": "バックボード",
      "Description": "脊髄運動制限"
    },
    {
      "ClassificationCD": "009",
      "ClassificationSubCD": "1",
      "Value": "119固定",
      "Description": "覚知種別"
    },
    {
      "ClassificationCD": "009",
      "ClassificationSubCD": "2",
      "Value": "119携帯",
      "Description": "覚知種別"
    },
    {
      "ClassificationCD": "009",
      "ClassificationSubCD": "3",
      "Value": "119IP",
      "Description": "覚知種別"
    },
    {
      "ClassificationCD": "009",
      "ClassificationSubCD": "4",
      "Value": "加入固定",
      "Description": "覚知種別"
    },
    {
      "ClassificationCD": "009",
      "ClassificationSubCD": "5",
      "Value": "加入携帯",
      "Description": "覚知種別"
    },
    {
      "ClassificationCD": "009",
      "ClassificationSubCD": "6",
      "Value": "加入IP ",
      "Description": "覚知種別"
    },
    {
      "ClassificationCD": "009",
      "ClassificationSubCD": "7",
      "Value": "警察電話",
      "Description": "覚知種別"
    },
    {
      "ClassificationCD": "009",
      "ClassificationSubCD": "8",
      "Value": "駆け付け電話",
      "Description": "覚知種別"
    },
    {
      "ClassificationCD": "009",
      "ClassificationSubCD": "9",
      "Value": "事後聞知",
      "Description": "覚知種別"
    },
    {
      "ClassificationCD": "009",
      "ClassificationSubCD": "A",
      "Value": "事故覚知",
      "Description": "覚知種別"
    },
    {
      "ClassificationCD": "009",
      "ClassificationSubCD": "B",
      "Value": "火災報知",
      "Description": "覚知種別"
    },
    {
      "ClassificationCD": "009",
      "ClassificationSubCD": "D",
      "Value": "専用",
      "Description": "覚知種別"
    },
    {
      "ClassificationCD": "009",
      "ClassificationSubCD": "C",
      "Value": "発信地",
      "Description": "覚知種別"
    },
    {
      "ClassificationCD": "009",
      "ClassificationSubCD": "E",
      "Value": "消防無線",
      "Description": "覚知種別"
    },
    {
      "ClassificationCD": "009",
      "ClassificationSubCD": "Z",
      "Value": "その他",
      "Description": "覚知種別"
    },
    {
      "ClassificationCD": "010",
      "ClassificationSubCD": "000",
      "Value": "投薬無",
      "Description": "投薬"
    },
    {
      "ClassificationCD": "010",
      "ClassificationSubCD": "001",
      "Value": "投薬有・手帳無",
      "Description": "投薬"
    },
    {
      "ClassificationCD": "010",
      "ClassificationSubCD": "002",
      "Value": "投薬有・手帳有",
      "Description": "投薬"
    },
    {
      "ClassificationCD": "011",
      "ClassificationSubCD": "000",
      "Value": "0",
      "Description": "JCS"
    },
    {
      "ClassificationCD": "011",
      "ClassificationSubCD": "001",
      "Value": "1",
      "Description": "JCS"
    },
    {
      "ClassificationCD": "011",
      "ClassificationSubCD": "002",
      "Value": "2",
      "Description": "JCS"
    },
    {
      "ClassificationCD": "011",
      "ClassificationSubCD": "003",
      "Value": "3",
      "Description": "JCS"
    },
    {
      "ClassificationCD": "011",
      "ClassificationSubCD": "004",
      "Value": "10",
      "Description": "JCS"
    },
    {
      "ClassificationCD": "011",
      "ClassificationSubCD": "005",
      "Value": "20",
      "Description": "JCS"
    },
    {
      "ClassificationCD": "011",
      "ClassificationSubCD": "006",
      "Value": "30",
      "Description": "JCS"
    },
    {
      "ClassificationCD": "011",
      "ClassificationSubCD": "007",
      "Value": "100",
      "Description": "JCS"
    },
    {
      "ClassificationCD": "011",
      "ClassificationSubCD": "008",
      "Value": "200",
      "Description": "JCS"
    },
    {
      "ClassificationCD": "011",
      "ClassificationSubCD": "009",
      "Value": "300",
      "Description": "JCS"
    },
    {
      "ClassificationCD": "012",
      "ClassificationSubCD": "000",
      "Value": "1",
      "Description": "GCS-E"
    },
    {
      "ClassificationCD": "012",
      "ClassificationSubCD": "001",
      "Value": "2",
      "Description": "GCS-E"
    },
    {
      "ClassificationCD": "012",
      "ClassificationSubCD": "002",
      "Value": "3",
      "Description": "GCS-E"
    },
    {
      "ClassificationCD": "012",
      "ClassificationSubCD": "003",
      "Value": "4",
      "Description": "GCS-E"
    },
    {
      "ClassificationCD": "013",
      "ClassificationSubCD": "000",
      "Value": "1",
      "Description": "GCS-V"
    },
    {
      "ClassificationCD": "013",
      "ClassificationSubCD": "001",
      "Value": "2",
      "Description": "GCS-V"
    },
    {
      "ClassificationCD": "013",
      "ClassificationSubCD": "002",
      "Value": "3",
      "Description": "GCS-V"
    },
    {
      "ClassificationCD": "013",
      "ClassificationSubCD": "003",
      "Value": "4",
      "Description": "GCS-V"
    },
    {
      "ClassificationCD": "013",
      "ClassificationSubCD": "004",
      "Value": "5",
      "Description": "GCS-V"
    },
    {
      "ClassificationCD": "014",
      "ClassificationSubCD": "000",
      "Value": "1",
      "Description": "GCS-M"
    },
    {
      "ClassificationCD": "014",
      "ClassificationSubCD": "001",
      "Value": "2",
      "Description": "GCS-M"
    },
    {
      "ClassificationCD": "014",
      "ClassificationSubCD": "002",
      "Value": "3",
      "Description": "GCS-M"
    },
    {
      "ClassificationCD": "014",
      "ClassificationSubCD": "003",
      "Value": "4",
      "Description": "GCS-M"
    },
    {
      "ClassificationCD": "014",
      "ClassificationSubCD": "004",
      "Value": "5",
      "Description": "GCS-M"
    },
    {
      "ClassificationCD": "014",
      "ClassificationSubCD": "005",
      "Value": "6",
      "Description": "GCS-M"
    },
    {
      "ClassificationCD": "015",
      "ClassificationSubCD": "000",
      "Value": "現場到着時",
      "Description": "観察時間説明"
    },
    {
      "ClassificationCD": "015",
      "ClassificationSubCD": "001",
      "Value": "接触時",
      "Description": "観察時間説明"
    },
    {
      "ClassificationCD": "015",
      "ClassificationSubCD": "002",
      "Value": "車内収容時",
      "Description": "観察時間説明"
    },
    {
      "ClassificationCD": "015",
      "ClassificationSubCD": "003",
      "Value": "搬送途上時",
      "Description": "観察時間説明"
    },
    {
      "ClassificationCD": "015",
      "ClassificationSubCD": "004",
      "Value": "容態変化時",
      "Description": "観察時間説明"
    },
    {
      "ClassificationCD": "016",
      "ClassificationSubCD": "000",
      "Value": "軽症",
      "Description": "程度"
    },
    {
      "ClassificationCD": "016",
      "ClassificationSubCD": "001",
      "Value": "中等症",
      "Description": "程度"
    },
    {
      "ClassificationCD": "016",
      "ClassificationSubCD": "002",
      "Value": "重症",
      "Description": "程度"
    },
    {
      "ClassificationCD": "016",
      "ClassificationSubCD": "003",
      "Value": "死亡",
      "Description": "程度"
    },
    {
      "ClassificationCD": "017",
      "ClassificationSubCD": "000",
      "Value": "消防副士長",
      "Description": "階級"
    },
    {
      "ClassificationCD": "017",
      "ClassificationSubCD": "001",
      "Value": "消防士長",
      "Description": "階級"
    },
    {
      "ClassificationCD": "017",
      "ClassificationSubCD": "002",
      "Value": "消防司令補",
      "Description": "階級"
    },
    {
      "ClassificationCD": "017",
      "ClassificationSubCD": "003",
      "Value": "消防司令",
      "Description": "階級"
    }
  ];

  static const messages = [
    {
      "CD": "001",
      "MessageType": "Warning",
      "MessageContent": "入力内容を保存せずに戻ります。よろしいですか？",
      "Button": "はい,」「キャンセル",
      "Purpose": "未登録終了確認"
    },
    {
      "CD": "002",
      "MessageType": "Question",
      "MessageContent": "入力内容を登録しますか？",
      "Button": "はい,キャンセル",
      "Purpose": "登録前確認"
    },
    {
      "CD": "003",
      "MessageType": "Information",
      "MessageContent": "登録処理を完了しました。",
      "Button": "OK",
      "Purpose": "登録後確認"
    },
    {
      "CD": "004",
      "MessageType": "Question",
      "MessageContent": "入力内容で更新しますか？",
      "Button": "はい,キャンセル",
      "Purpose": "更新前確認"
    },
    {
      "CD": "005",
      "MessageType": "Information",
      "MessageContent": "更新処理を完了しました。",
      "Button": "OK",
      "Purpose": "更新後確認"
    },
    {
      "CD": "006",
      "MessageType": "Error",
      "MessageContent": "入力項目]が未入力です。",
      "Button": "OK",
      "Purpose": "未入力エラー"
    }
  ];

  static void seedTeams(Batch batch) {
    for (final data in SeedData.teams) {
      batch.insert(DBConstants.teamTable, data,
          conflictAlgorithm: ConflictAlgorithm.replace);
    }
  }

  static void seedFireStations(Batch batch) {
    for (final data in SeedData.fireStations) {
      batch.insert(DBConstants.fireStationTable, data,
          conflictAlgorithm: ConflictAlgorithm.replace);
    }
  }

  static void seedHospitals(Batch batch) {
    for (final data in SeedData.hospitals) {
      batch.insert(DBConstants.hospitalTable, data,
          conflictAlgorithm: ConflictAlgorithm.replace);
    }
  }

  static void seedClassifications(Batch batch) {
    for (final data in SeedData.classifications) {
      batch.insert(DBConstants.classificationTable, data,
          conflictAlgorithm: ConflictAlgorithm.replace);
    }
  }
}
