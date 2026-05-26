# 駅別乗降客数 × ホームドア設置状況

国土数値情報の駅別乗降客数データにホームドア設置有無を付加し、ラインデータを重心ポイントに変換。GeoJSON・PMTiles・QMLおよびMapLibreによるWebマップを提供します。

**デモ**: `docs/index.html`（GitHub Pages）

---

## ファイル構成

```
.
├── README.md
├── CLAUDE.md
├── .gitignore
├── src/
│   └── convert_to_points_with_homedoor.py   # 処理スクリプト
├── data/
│   ├── 001472240.xlsx                        # ホームドア設置状況（入力）
│   └── S12-25_GML/                           # 国土数値情報元データ（.gitignore済）
├── output/
│   ├── S12-25_NumberOfPassengers_points.geojson
│   ├── S12-25_NumberOfPassengers_points.pmtiles
│   └── S12-25_NumberOfPassengers_points.qml
└── docs/                                     # GitHub Pages
    ├── index.html                            # MapLibre Webマップ
    ├── pale.json                             # ベースマップスタイル
    └── S12-25_NumberOfPassengers_points.pmtiles  # output/ から手動コピー
```

> `data/S12-25_GML/`（約200MB）は `.gitignore` で除外しています。

---

## 使用データ（出典）

### 駅別乗降客数データ
- **データ名**: 国土数値情報 駅別乗降客数データ（S12-25）
- **提供元**: 国土交通省
- **URL**: https://nlftp.mlit.go.jp/ksj/gml/datalist/KsjTmplt-S12-2024.html
- **ライセンス**: [国土数値情報ダウンロードサービス利用規約](https://nlftp.mlit.go.jp/ksj/other/agreement.html)
- **収録内容**: 全国の駅ごとの年度別乗降客数（路線単位のラインデータ）

### ホームドア設置状況データ
- **データ名**: ホームドアの設置状況（令和6年度末）
- **提供元**: 国土交通省
- **URL**: https://www.mlit.go.jp/tetudo/tetudo_tk6_000022.html
- **収録内容**: ホームドア設置駅・番線一覧（1,190駅、2,830番線）

---

## 処理内容（`src/convert_to_points_with_homedoor.py`）

### 1. ラインデータ → 重心ポイント変換
国土数値情報の駅別乗降客数データは路線を表すLineString/MultiLineStringで格納されています。各フィーチャの全座標の算術平均を重心として、ポイントデータに変換しています。

### 2. 事業者名の正規化

| Excel（ホームドアデータ） | GeoJSON（国土数値情報） |
|--------------------------|---------------------|
| JR北海道 | 北海道旅客鉄道 |
| JR東日本 | 東日本旅客鉄道 |
| JR東海 | 東海旅客鉄道 |
| JR西日本 | 西日本旅客鉄道 |
| JR九州 | 九州旅客鉄道 |
| 京都市交通局 | 京都市 |
| 仙台市交通局 | 仙台市 |
| 北大阪急行 | 北大阪急行電鉄 |
| 名古屋市交通局 | 名古屋市 |
| 札幌市交通局 | 札幌市 |
| 東京都交通局 | 東京都 |
| 横浜市交通局 | 横浜市 |
| 神戸市交通局 | 神戸市 |
| 福岡市交通局 | 福岡市 |

### 3. 駅名の正規化

1. **NFKC正規化**: 半角カタカナ→全角、全角英数→半角、半角中黒→全角
2. **ケ/ヶ統一**: 漢字に挟まれた「ケ」→「ヶ」（例: 市ケ谷→市ヶ谷）
3. **括弧除去**: 例: 押上（京成）→ 押上
4. **末尾「駅」除去**: 例: 中央大学・明星大学駅→中央大学・明星大学
5. **異体字統一**: 壷→壺、諌→諫、麴→麹
6. **ひらがな→漢字**: あびこ→我孫子、なかもず→中百舌鳥、なんば→難波

**マッチング結果**: Excel記載1,189駅すべてGeoJSONに対応付け済み（未マッチ0件）

> **注意**: Excelのホームドアデータは番線（ホーム）単位で記録されていますが、国土数値情報のGeoJSONは駅×路線単位のため番線情報を持ちません。そのため突合は**駅単位**で行っており、`platform_door=1` は「その駅の少なくとも1番線にホームドアが設置されている」ことを意味します。全番線への設置完了かどうかは判定していません。

---

## 出力データ仕様

| 項目 | 内容 |
|------|------|
| 座標系 | WGS84 (EPSG:4326) |
| ジオメトリ | Point（ラインの重心） |
| フィーチャ数 | 10,534 |

### 主要フィールド

| フィールド | 内容 |
|------------|------|
| `S12_001` | 駅名 |
| `S12_002` | 事業者名 |
| `S12_003` | 路線名 |
| `S12_061` | 乗降客数・最新年度（人/日） |
| `platform_door` | ホームドア設置有無（**1=あり、0=なし**） |

### ファイルサイズ

| ファイル | サイズ |
|----------|--------|
| GeoJSON | 12 MB |
| PMTiles（zoom 4〜14） | 15 MB |

---

## 再実行手順

### GeoJSON生成

```bash
pip install openpyxl
python src/convert_to_points_with_homedoor.py
```

`output/` に GeoJSON を出力します。その後 tippecanoe で PMTiles を生成し `docs/` にコピーしてください。

### PMTiles生成

```bash
tippecanoe \
  -o output/S12-25_NumberOfPassengers_points.pmtiles \
  --name="station-homedoor" --layer="stations" \
  --minimum-zoom=4 --maximum-zoom=14 \
  -r1 --force \
  output/S12-25_NumberOfPassengers_points.geojson
```

### ローカルでWebマップを確認

```bash
python -m http.server 8080 --directory docs
```

`http://localhost:8080` をブラウザで開く。

---

## 更新履歴

| 日付 | 内容 |
|------|------|
| 2026-05-26 | 東京地下鉄の15駅（東西線千葉延伸部・他社乗り入れターミナル等）がExcelデータに欠落していたため `platform_door=0` と誤判定されていた問題を修正。東京メトロ公式情報（南砂町1番線を除き全番線整備済み）に基づき、東京地下鉄でExcel未マッチの駅を `platform_door=1` にオーバーライドする補完処理を追加。 |
| 2026-05-26 | WebマップのデータソースをGeoJSON直読みからPMTilesに変更。tippecanoeオプションを `-r1`（間引きなし）に変更し全駅を常時表示。`docs/` からGeoJSONを削除しPMTilesを配置。 |
| 2026-05-26 | ラベルレイヤーのフォント指定を `NotoSansCJKjp-Regular` → `NotoSansJP-Regular` に修正（zoom 10以上で円が消える問題の解消）。 |

---

## QGISスタイル（`output/S12-25_NumberOfPassengers_points.qml`）

- **色分け**: `platform_door`（青=ホームドアあり、赤=なし）
- **円の大きさ**: `S12_061`（乗降客数）の平方根に比例（1〜15mm）
- **ラベル**: 乗降客数10万人以上の駅のみ表示（縮尺1:50,000〜1:500,000）
