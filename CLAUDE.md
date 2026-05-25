# CLAUDE.md

## プロジェクト概要

国土数値情報（KSJ）の駅別乗降客数データ（S12-25）に、国交省のホームドア設置状況Excelを突合し、ポイントGeoJSON・PMTiles・QMLおよびMapLibre Webマップを生成するプロジェクト。

---

## ディレクトリ構成

```
.
├── src/
│   └── convert_to_points_with_homedoor.py   # メイン処理スクリプト
├── data/
│   ├── 001472240.xlsx                        # 入力: ホームドア設置状況（令和6年度末）
│   └── S12-25_GML/                           # 入力: KSJ元データ（.gitignore済、約200MB）
│       └── UTF-8/
│           └── S12-25_NumberOfPassengers.geojson
├── output/
│   ├── S12-25_NumberOfPassengers_points.geojson
│   ├── S12-25_NumberOfPassengers_points.pmtiles
│   └── S12-25_NumberOfPassengers_points.qml
└── docs/                                     # GitHub Pages
    ├── index.html                            # MapLibre Webマップ
    ├── pale.json                             # ベースマップ（国土地理院最適化ベクトルタイル）
    └── S12-25_NumberOfPassengers_points.geojson  # output/ の自動同期コピー
```

---

## データパイプライン

```
data/001472240.xlsx  +  data/S12-25_GML/UTF-8/S12-25_NumberOfPassengers.geojson
        ↓  src/convert_to_points_with_homedoor.py
output/S12-25_NumberOfPassengers_points.geojson  （+ docs/ に自動同期）
        ↓  tippecanoe
output/S12-25_NumberOfPassengers_points.pmtiles
```

スクリプトは `pathlib` で `__file__` からルートを特定するため、**どのディレクトリから実行しても動作する**。

---

## 重要なデータ仕様

### キーフィールド

| フィールド | 内容 |
|------------|------|
| `S12_001` | 駅名 |
| `S12_002` | 事業者名 |
| `S12_003` | 路線名 |
| `S12_061` | 乗降客数・最新年度（人/日）|
| `platform_door` | 1=ホームドアあり、0=なし（追加フィールド） |

`S12_037`〜`S12_057` は4フィールド単位で過去年度の乗降客数。

### マッチングロジック

`事業者名（正規化） × 駅名（正規化）` でExcelとGeoJSONを突合。マッチング結果は未マッチ0件。

**判定の粒度:** Excelは番線（ホーム）単位のデータだが、KSJ GeoJSONは番線情報を持たないため突合は駅単位。`platform_door=1` = 「その駅の少なくとも1番線に設置あり」であり、全番線設置済みかは不明。

**正規化の内容（`normalize_station()`）:**
- NFKC正規化（半角カタカナ→全角、全角英数→半角）
- 漢字間の「ケ」→「ヶ」
- 括弧付き補足の除去
- 末尾「駅」の除去
- 異体字: 壷→壺、諌→諫、麴→麹
- ひらがな→漢字: あびこ→我孫子、なかもず→中百舌鳥、なんば→難波

**事業者名マッピング（`OPERATOR_MAP`）:**
JR各社・各市交通局など14社分。スクリプト冒頭に定義。

---

## Webマップ（`docs/index.html`）

### スタック
- MapLibre GL JS v4
- PMTiles v3（ベースマップ: 国土地理院最適化ベクトルタイル）
- データ: `./S12-25_NumberOfPassengers_points.geojson`（GeoJSON直読み）

### レイヤー構成

| レイヤーID | 種別 | 内容 |
|-----------|------|------|
| `stations-stroke` | circle | 白枠（視認性向上） |
| `stations-fill` | circle | 本体（`platform_door`で色分け） |
| `stations-label` | symbol | 乗降客数ラベル（10万人以上、zoom≥10） |

### 円サイズ（`S12_061`の平方根に比例）

```js
["interpolate", ["linear"],
  ["^", ["coalesce", ["get", "S12_061"], 1], 0.5],
  0, 1, 32, 3, 100, 6, 316, 10, 1330, 18
]
```

ズームレベル 4〜14 に応じて 0.4〜2.0 倍スケーリング。

### ラベルフィルター

```js
filter: [">=", ["coalesce", ["get", "S12_061"], 0], 100000]
```

---

## QML（`output/S12-25_NumberOfPassengers_points.qml`）

- 色分け: `platform_door`（青=#3b82f6 / 赤=#f87171）
- 円サイズ: `scale_linear(sqrt("S12_061"), 0, 1330, 1, 15)` mm
- ラベル: `"S12_061" >= 100000` のフィーチャのみ（data-defined show）
- 表示縮尺: 1:50,000〜1:500,000

---

## 再実行コマンド

```bash
# GeoJSON生成（output/ + docs/ に出力）
python src/convert_to_points_with_homedoor.py

# PMTiles生成
tippecanoe \
  -o output/S12-25_NumberOfPassengers_points.pmtiles \
  --name="station-homedoor" --layer="stations" \
  --minimum-zoom=4 --maximum-zoom=14 \
  --drop-densest-as-needed --extend-zooms-if-still-dropping \
  --force \
  output/S12-25_NumberOfPassengers_points.geojson

# ローカルサーバー起動
python -m http.server 8080 --directory docs
```

---

## 注意事項

- `docs/S12-25_NumberOfPassengers_points.geojson` は `output/` のコピー。スクリプト実行で自動同期されるため手動コピー不要。
- `data/S12-25_GML/` は約200MBのため `.gitignore` 済み。再利用時は国土数値情報からダウンロードして配置すること。
- `docs/pale.json` は国土地理院最適化ベクトルタイルの淡色スタイル定義。
