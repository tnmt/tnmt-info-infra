# CLAUDE.md

## コマンド

```sh
AWS_PROFILE=tnmt-info-infra terraform plan
AWS_PROFILE=tnmt-info-infra terraform apply
```

## 注意事項

- CloudFront は pay-as-you-go で運用する。WAF は関連付けない。
- 旧 Free プラン distribution `E1QY925HPOX8ZS` は無効化済み。pricing plan を AWS コンソールでキャンセル後、月次請求サイクル終了後に削除する。
- サイト本体は別リポジトリ [tnmt/tnmt.info](https://github.com/tnmt/tnmt.info)。

## TODO

- [ ] 2026年3月以降: 旧 CloudFront ディストリビューション `E3CO5VDV5CAN87` (`static.tnmt.info`) を削除する。Free プランは2月末に解除済みの想定。削除コマンド:
  ```sh
  ETAG=$(AWS_PROFILE=tnmt-info-infra aws cloudfront get-distribution --id E3CO5VDV5CAN87 --query 'ETag' --output text)
  AWS_PROFILE=tnmt-info-infra aws cloudfront delete-distribution --id E3CO5VDV5CAN87 --if-match "$ETAG"
  ```
- [ ] 旧 Free プラン CloudFront ディストリビューション `E1QY925HPOX8ZS` を削除する。2026-06-02 に無効化済み。AWS コンソールで pricing plan をキャンセルし、月次請求サイクル終了後に削除する。
