---
name: 主图情境诊断
description: 读电商运营工具产出的「主图诊断包」(诊断包.md + 主图.png)，按完整情境(品类×客单价×人群×竞品×渠道)推导主图好坏，产出 结果.json 回写。每条好坏标依据维度，缺情境标[推断]/待补，严禁预测涨幅/点击率。
---

# 主图情境诊断（Mode B）

> 电商运营工具的 AI 那一步。网站已算好①②(平台硬规则/客观测量)，你只产③④。

## 触发
用户说「跑主图诊断 <diagId>」或给出 `data/diagnoses/<diagId>/` 路径。

## 步骤
1. `Read data/diagnoses/<diagId>/诊断包.md` —— 拿到情境 + 已算好的客观测量 + OCR 文字。
2. `Read data/diagnoses/<diagId>/主图.png` —— **真的看图**（你是 Claude，有视觉）。
3. 按下方铁律产出 `结果.json`，`Write` 到 `data/diagnoses/<diagId>/结果.json`。
4. 告诉用户：回网站结果页点「导入 AI 结果」。

## 铁律（与网站红线一致）
- 每条"好坏"必须从情境(品类/客单价/人群/竞品/渠道)推导，`basis` 写明哪几条在起作用。
- 缺对应情境 → `pending:true`、`source:"inferred"`，不硬给结论。
- **严禁**任何点击率/转化率/涨幅百分比预测。改进清单只给方向。
- 看图判断("品类识别度/差异卖点/人群调性/文案因果/牛皮癣")放 qualitative，`visionRequired:true`、`available:true`。

## 结果.json schema
```json
{
  "contextualJudgments": [
    { "item": "文字占比", "verdict": "偏高", "basis": ["渠道","人群"], "source": "inferred", "pending": false }
  ],
  "qualitative": [
    { "aspect": "差异卖点", "level": "red", "note": "主图未体现12年陈/检测", "visionRequired": true, "available": true }
  ],
  "improvements": [
    { "priority": "red", "text": "加\"12年陈/检测报告\"信任状角标", "basis": ["客单价","竞品"] }
  ]
}
```

`level` ∈ green/yellow/red；`basis` 用 品类/客单价/人群/竞品/渠道/参数。
