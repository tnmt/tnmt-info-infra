# CLAUDE.md

## コマンド

```sh
AWS_PROFILE=tnmt-info-infra terraform plan
AWS_PROFILE=tnmt-info-infra terraform apply
```

## 注意事項

- CloudFront の Free プランは Terraform 未対応。プラン変更は AWS コンソールから行う。
- Free プランは legacy cache settings (`forwarded_values`) を使えない。`cache_policy_id` を使う。
- サイト本体は別リポジトリ [tnmt/tnmt.info](https://github.com/tnmt/tnmt.info)。

## TODO

- [ ] 2026年3月以降: 旧 CloudFront ディストリビューション `E3CO5VDV5CAN87` (`static.tnmt.info`) を削除する。Free プランは2月末に解除済みの想定。削除コマンド:
  ```sh
  ETAG=$(AWS_PROFILE=tnmt-info-infra aws cloudfront get-distribution --id E3CO5VDV5CAN87 --query 'ETag' --output text)
  AWS_PROFILE=tnmt-info-infra aws cloudfront delete-distribution --id E3CO5VDV5CAN87 --if-match "$ETAG"
  ```
