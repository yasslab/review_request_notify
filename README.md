# Review Request Notify

GitHub ActionsでPRレビュー依頼をSlackに通知

## 使い方

```yaml
- uses: yasulab/review_request_notify@main
  with:
    channel-id: 'YOUR_CHANNEL_ID'
    SLACK_BOT_TOKEN: ${{ secrets.SLACK_BOT_TOKEN }}
```

## 機能

- GitHubユーザー名 → Slackユーザー名の自動変換（[members.json](https://yasslab.jp/members.json)）
- 営業時間外は@tasslabへメモとして通知
- 日本の祝日対応

## テスト

```bash
./test/test_mapping.sh  # ユーザーマッピング確認
```