import json
import re
import unicodedata
from pathlib import Path
import openpyxl

ROOT = Path(__file__).parent.parent
EXCEL_PATH        = ROOT / "data" / "001472240.xlsx"
INPUT_GEOJSON     = ROOT / "data" / "S12-25_GML" / "UTF-8" / "S12-25_NumberOfPassengers.geojson"
OUTPUT_GEOJSON    = ROOT / "output" / "S12-25_NumberOfPassengers_points.geojson"
OUTPUT_DOCS       = ROOT / "docs"   / "S12-25_NumberOfPassengers_points.geojson"

# Excel事業者名 → GeoJSON事業者名 のマッピング
OPERATOR_MAP = {
    "JR九州":         "九州旅客鉄道",
    "JR北海道":       "北海道旅客鉄道",
    "JR東日本":       "東日本旅客鉄道",
    "JR東海":         "東海旅客鉄道",
    "JR西日本":       "西日本旅客鉄道",
    "京都市交通局":   "京都市",
    "仙台市交通局":   "仙台市",
    "北大阪急行":     "北大阪急行電鉄",
    "名古屋市交通局": "名古屋市",
    "札幌市交通局":   "札幌市",
    "東京都交通局":   "東京都",
    "横浜市交通局":   "横浜市",
    "神戸市交通局":   "神戸市",
    "福岡市交通局":   "福岡市",
}

def normalize_station(name):
    if not name:
        return name
    name = name.replace("\n", "").replace("\r", "").strip()
    name = unicodedata.normalize("NFKC", name)
    name = re.sub(r"(?<=[一-龯])ケ(?=[一-龯])", "ヶ", name)
    name = re.sub(r"[（(][^）)]*[）)]", "", name).strip()
    name = name.rstrip("駅")
    name = name.replace("壷", "壺").replace("諌", "諫").replace("麴", "麹")
    STATION_NAME_MAP = {
        "あびこ":     "我孫子",
        "なかもず":   "中百舌鳥",
        "なんば":     "難波",
        "赤土小学校": "赤土小学校前",
    }
    return STATION_NAME_MAP.get(name, name)

def normalize_operator(name):
    return OPERATOR_MAP.get(name, name)

def linestring_centroid(coordinates):
    xs = [c[0] for c in coordinates]
    ys = [c[1] for c in coordinates]
    return [sum(xs) / len(xs), sum(ys) / len(ys)]

def multilinestring_centroid(coordinates):
    all_coords = [c for line in coordinates for c in line]
    xs = [c[0] for c in all_coords]
    ys = [c[1] for c in all_coords]
    return [sum(xs) / len(xs), sum(ys) / len(ys)]

# Excelからホームドア設置駅セットを作成
wb = openpyxl.load_workbook(EXCEL_PATH)
ws = wb.active

homedoor_stations = set()
for row in ws.iter_rows(min_row=8, values_only=True):
    op_raw, station_raw = row[2], row[3]
    if op_raw and station_raw:
        op = normalize_operator(op_raw.strip())
        st = normalize_station(station_raw)
        homedoor_stations.add((op, st))

print(f"ホームドア設置駅数（正規化後）: {len(homedoor_stations)}")

# GeoJSONを読み込み
with open(INPUT_GEOJSON, encoding="utf-8") as f:
    gj = json.load(f)

# ラインを重心ポイントに変換し、ホームドア設置有無を付加
matched = 0
new_features = []
unmatched_xl_check = []

for feat in gj["features"]:
    geom = feat["geometry"]
    props = feat["properties"]

    if geom["type"] == "LineString":
        centroid = linestring_centroid(geom["coordinates"])
    elif geom["type"] == "MultiLineString":
        centroid = multilinestring_centroid(geom["coordinates"])
    else:
        continue

    operator = (props.get("S12_002") or "").strip()
    station_norm = normalize_station(props.get("S12_001") or "")
    has_door = 1 if (operator, station_norm) in homedoor_stations else 0

    if has_door:
        matched += 1
    else:
        unmatched_xl_check.append((operator, station_norm))

    new_props = dict(props)
    new_props["platform_door"] = has_door

    new_features.append({
        "type": "Feature",
        "geometry": {"type": "Point", "coordinates": centroid},
        "properties": new_props,
    })

print(f"総フィーチャ数: {len(new_features)}")
print(f"ホームドア設置あり: {matched}")
print(f"ホームドア設置なし: {len(new_features) - matched}")

# ExcelにあってGeoJSONにマッチしなかった駅を報告
gj_door_set = {(normalize_station(f["properties"].get("S12_001") or ""), f["properties"].get("S12_002") or "")
               for f in new_features if f["properties"]["platform_door"] == 1}
unmatched_from_xl = [(op, st) for op, st in homedoor_stations
                     if (st, op) not in gj_door_set]
print(f"\nExcel設置駅でGeoJSONに未マッチ: {len(unmatched_from_xl)}件")
for op, st in sorted(unmatched_from_xl):
    print(f"  ({op}, {st})")

# output/ に書き出し
OUTPUT_GEOJSON.parent.mkdir(parents=True, exist_ok=True)
with open(OUTPUT_GEOJSON, "w", encoding="utf-8") as f:
    json.dump({"type": "FeatureCollection", "features": new_features}, f, ensure_ascii=False)
print(f"\n出力完了: {OUTPUT_GEOJSON}")

# docs/ にも同期コピー
with open(OUTPUT_DOCS, "w", encoding="utf-8") as f:
    json.dump({"type": "FeatureCollection", "features": new_features}, f, ensure_ascii=False)
print(f"docs/ に同期: {OUTPUT_DOCS}")
