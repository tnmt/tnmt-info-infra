# CLAUDE.md

## コマンド

```sh
AWS_PROFILE=tnmt-info-infra terraform plan
AWS_PROFILE=tnmt-info-infra terraform apply
```

## 注意事項

- サイト本体は self-hosted nginx 配信に移行済 (2026-06-10)。CloudFront / サイト用 S3 / ACM 証明書 / サイトデプロイ用 IAM ロールは削除済。
- `/images/*` は `tnmt-info-assets` バケットを残し、nginx から S3 へ直接 reverse proxy で配信。
- 旧 Free プラン distribution `E1QY925HPOX8ZS` は 2026-06-10 に削除済み。
- 旧 Free プラン Web ACL `CreatedByCloudFront-2ee1e91b` は 2026-06-10 に削除済み。
- サイト本体は別リポジトリ [tnmt/tnmt.info](https://github.com/tnmt/tnmt.info)。

## TODO

- [ ] 2026年3月以降: 旧 CloudFront ディストリビューション `E3CO5VDV5CAN87` (`static.tnmt.info`) を削除する。Free プランは2月末に解除済みの想定。削除コマンド:
  ```sh
  ETAG=$(AWS_PROFILE=tnmt-info-infra aws cloudfront get-distribution --id E3CO5VDV5CAN87 --query 'ETag' --output text)
  AWS_PROFILE=tnmt-info-infra aws cloudfront delete-distribution --id E3CO5VDV5CAN87 --if-match "$ETAG"
  ```
