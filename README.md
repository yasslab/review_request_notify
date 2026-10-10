# Review Request Notify for YassLab team

YassLab チーム用の、PR レビュー依頼を Slack に通知するカスタムアクションです。

[&raquo; デフォルト設定を見る](https://github.com/yasslab/review_request_notify/blob/main/action.yml)<br>
[&raquo; 通知の実例を見る](https://github.com/yasslab/review_request_notify/pull/3)<br>
[&raquo; 関連リポジトリを見る](https://github.com/yasslab/claude_review_action)

<br>

## カスタムアクションの設定例

```bash
.github/workflows/review.yml
```

```yaml
name: Review Request Notify

on:
  pull_request:
    types: [review_requested]
  # 疎通確認用。レビュー依頼を出さずに手動で動かせる (requestee は yasulab にフォールバック)
  workflow_dispatch:

jobs:
  event:
    runs-on: ubuntu-latest

    # 推奨: 権限を渡さない
    permissions: {} # GITHUB_TOKEN を使わない (Slack への投稿と外部 JSON の取得だけ)
                    # 同じ job で checkout するなら contents: read を足す

    steps:
      - name: 🔔 Review Request Notify
        uses: yasslab/review_request_notify@main
        with:
          channel-id: 'YOUR_CHANNEL_ID'
          SLACK_BOT_TOKEN: ${{ secrets.SLACK_BOT_TOKEN }}
```

`channel-id` にはチャンネル名をそのまま書けます。`SLACK_BOT_TOKEN` は
Slack アプリのボットトークンで、`chat:write` のスコープが要ります。

<br>

## 通知の内容

レビュー依頼を押した人と、依頼された人を Slack の表示名に変換して通知します。

```
@tasslab memo tasslab :yasulab: yasulab さんからレビュー依頼が来てるよ (◍˃̶ᗜ˂̶◍)ﾉ
> :github: yasslab/review_request_notify#3 - chore: slack-github-action を v4 に上げる（本文の "引用" | 記号 # と : の確認）
```

- GitHub ユーザー名 → Slack ユーザー名の変換は [`yasslab.jp/members.json`](https://yasslab.jp/members.json) を参照します
- 名簿に無いユーザーは、GitHub のユーザー名をそのまま使います
- **fork からの PR では通知されません。** secrets が渡らないため、ジョブが失敗します

<br>

## 通知するタイミング

**平日の 10:00〜18:00（日本時間）だけ、依頼された本人を直接メンションします。**

それ以外（早朝・深夜・土日・祝日）は `@tasslab` 宛のメモとして送り、営業時間になってから
本人に届きます。祝日の判定には [`yasslab.jp/holidays.json`](https://yasslab.jp/holidays.json) を使います。

夜中にレビュー依頼を出しても、相手を起こさずに済みます。

<br>

## 疎通確認のしかた

設定例に `workflow_dispatch` を入れてあるのは、**レビュー依頼を出さずに動作を確認する**ためです。
`requestee` は `yasulab` にフォールバックするので、**通知はそこへ届きます**。

```bash
gh workflow run review.yml --ref main
```

レビュー依頼が無い状態で走るので、`requestee` は `yasulab` に、リンク先は Actions のページに
フォールバックします。Slack に届けば、トークンとチャンネルの設定は正しいと分かります。

実際のレビュー依頼で通る経路（PR のタイトルと URL が本文に入る版）まで確かめたいときは、
**PR を作ってレビュアーに `tasslab` を指名**してください。本番と同じ経路を通せます。

<br>

## テスト

```bash
./test/test_mapping.sh  # ユーザーマッピング確認
```

-----

Copyright &copy; [YassLab](http://github.com/yasslab).
