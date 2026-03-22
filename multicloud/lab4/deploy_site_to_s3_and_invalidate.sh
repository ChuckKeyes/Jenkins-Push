#!/usr/bin/env bash
set -euo pipefail

BUCKET="lab3-vpc-staff-photos-557690581423"
SITE_DIR="./green"
DISTRIBUTION_ID="EAKWRCYA4B1UE"
EC2_ROLE_NAME="lab3-vpc-app-ssm-role"
APPLY_IAM_POLICY="yes"

POLICY_NAME="lab3-s3-read-staff-photos"
POLICY_FILE="./lab3-s3-read-staff-photos.json"

die() { echo "ERROR: $*" >&2; exit 1; }

require_cmd() {
  command -v "$1" >/dev/null 2>&1 || die "Missing command: $1"
}

require_cmd aws

[[ -d "$SITE_DIR" ]] || die "SITE_DIR not found: $SITE_DIR"
[[ -f "$SITE_DIR/index.html" ]] || die "index.html not found inside SITE_DIR: $SITE_DIR/index.html"

echo "==> Using bucket: $BUCKET"
echo "==> Using site dir: $SITE_DIR"
echo "==> CloudFront distribution: $DISTRIBUTION_ID"

if [[ "$APPLY_IAM_POLICY" == "yes" ]]; then
  if [[ ! -f "$POLICY_FILE" ]]; then
    cat > "$POLICY_FILE" <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "ListBucket",
      "Effect": "Allow",
      "Action": "s3:ListBucket",
      "Resource": "arn:aws:s3:::$BUCKET"
    },
    {
      "Sid": "GetObjects",
      "Effect": "Allow",
      "Action": "s3:GetObject",
      "Resource": "arn:aws:s3:::$BUCKET/*"
    }
  ]
}
EOF
  fi

  echo "==> Attaching inline policy to role: $EC2_ROLE_NAME"
  aws iam put-role-policy \
    --role-name "$EC2_ROLE_NAME" \
    --policy-name "$POLICY_NAME" \
    --policy-document "file://$POLICY_FILE"
fi

echo "==> Uploading site to S3"
aws s3 sync "$SITE_DIR/" "s3://$BUCKET/" --delete

echo "==> Verifying objects"
aws s3 ls "s3://$BUCKET/" | head || true

echo "==> Creating CloudFront invalidation"
aws cloudfront create-invalidation \
  --distribution-id "$DISTRIBUTION_ID" \
  --paths "/*"

echo "Done."