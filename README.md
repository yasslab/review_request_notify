# Review Request Notify

YassLab 社内で利用する PR レビュー依頼の Slack 通知 in GitHub Actions.

## 使い方

```yaml
- uses: yasulab/review_request_notify@main
  with:
    channel-id: 'YOUR_CHANNEL_ID'
    SLACK_BOT_TOKEN: ${{ secrets.SLACK_BOT_TOKEN }}
```

## 機能

- GitHubユーザー名 → Slackユーザー名の自動変換
- 営業時間外は @tasslab へメモとして通知 (営業時間になったら通知する)
- 日本の祝日対応

## テスト

```bash
./test/test_mapping.sh  # ユーザーマッピング確認
```
