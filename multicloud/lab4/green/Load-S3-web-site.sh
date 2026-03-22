aws s3 cp ./index.html s3://lab3-vpc-staff-photos/index.html \
  --content-type "text/html" \
  --cache-control "no-cache"

  aws s3 sync ./green s3://lab3-vpc-staff-photos --delete

  aws s3 ls s3://lab3-vpc-staff-photos/ | head

  aws cloudfront create-invalidation \
  --distribution-id EAKWRCYA4B1UE \
  --paths "/*"

  aws iam put-role-policy \
  --role-name lab3-vpc-app-ssm-role \
  --policy-name lab3-s3-read-staff-photos \
  --policy-document file://lab3-s3-read-staff-photos.json

  aws s3 ls s3://lab3-vpc-staff-photos/ | head
sudo aws s3 sync s3://lab3-vpc-staff-photos/ /usr/share/nginx/html/ --delete
sudo nginx -t && sudo systemctl restart nginx
curl -I http://localhost/
#######################################################################

1) Laptop Bash Script: deploy_site_to_s3_and_invalidate.sh


#!/usr/bin/env bash
set -euo pipefail

########################
# CONFIG (edit these)
########################
BUCKET="lab3-vpc-staff-photos"
SITE_DIR="./green"                    # local folder containing index.html, img/, css/, js/, etc.
DISTRIBUTION_ID="EAKWRCYA4B1UE"
EC2_ROLE_NAME="lab3-vpc-app-ssm-role"  # the IAM role attached to the EC2 instance profile
APPLY_IAM_POLICY="yes"                # yes|no  (only needed once)

POLICY_NAME="lab3-s3-read-staff-photos"
POLICY_FILE="./lab3-s3-read-staff-photos.json"

########################
# Helpers
########################
die() { echo "ERROR: $*" >&2; exit 1; }

require_cmd() {
  command -v "$1" >/dev/null 2>&1 || die "Missing command: $1"
}

########################
# Pre-flight
########################
require_cmd aws

[[ -d "$SITE_DIR" ]] || die "SITE_DIR not found: $SITE_DIR"
[[ -f "$SITE_DIR/index.html" ]] || die "index.html not found inside SITE_DIR: $SITE_DIR/index.html"

echo "==> Using bucket: $BUCKET"
echo "==> Using site dir: $SITE_DIR"
echo "==> CloudFront distribution: $DISTRIBUTION_ID"

########################
# Optional: ensure EC2 role can read bucket
########################
if [[ "$APPLY_IAM_POLICY" == "yes" ]]; then
  if [[ ! -f "$POLICY_FILE" ]]; then
    echo "==> Creating IAM policy file: $POLICY_FILE"
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

  echo "==> Attaching/Updating inline policy on role: $EC2_ROLE_NAME"
  aws iam put-role-policy \
    --role-name "$EC2_ROLE_NAME" \
    --policy-name "$POLICY_NAME" \
    --policy-document "file://$POLICY_FILE"
else
  echo "==> Skipping IAM policy attach (APPLY_IAM_POLICY=no)"
fi

########################
# Upload site
########################
echo "==> Uploading site to S3 (sync): $SITE_DIR -> s3://$BUCKET/"
aws s3 sync "$SITE_DIR/" "s3://$BUCKET/" --delete

echo "==> Verifying S3 has index.html and img/ (first few)"
aws s3 ls "s3://$BUCKET/" | head || true
aws s3 ls "s3://$BUCKET/img/" | head || true

########################
# CloudFront invalidation
########################
echo "==> Creating CloudFront invalidation for /*"
aws cloudfront create-invalidation \
  --distribution-id "$DISTRIBUTION_ID" \
  --paths "/*" >/dev/null

echo "✅ Done. Site uploaded + CloudFront invalidated."

chmod +x deploy_site_to_s3_and_invalidate.sh
./deploy_site_to_s3_and_invalidate.sh

########################################################################

2) EC2 Script: pull_site_from_s3_to_nginx.sh

#!/usr/bin/env bash
set -euo pipefail

########################
# CONFIG (edit these)
########################
BUCKET="lab3-vpc-staff-photos"
WEB_ROOT="/usr/share/nginx/html"
TEST_IMAGE_PATH="/img/images1.jpeg"   # change to a real file that exists in your bucket

########################
# Helpers
########################
die() { echo "ERROR: $*" >&2; exit 1; }

require_cmd() {
  command -v "$1" >/dev/null 2>&1 || die "Missing command: $1"
}

echo "==> Starting S3 -> Nginx deploy"
require_cmd aws
require_cmd nginx
require_cmd systemctl
require_cmd curl

echo "==> Syncing s3://$BUCKET/ -> $WEB_ROOT/"
sudo aws s3 sync "s3://$BUCKET/" "$WEB_ROOT/" --delete

echo "==> Fixing permissions in $WEB_ROOT/"
sudo chown -R root:root "$WEB_ROOT"
sudo find "$WEB_ROOT" -type d -exec chmod 755 {} \;
sudo find "$WEB_ROOT" -type f -exec chmod 644 {} \;

echo "==> Testing nginx config and restarting"
sudo nginx -t
sudo systemctl restart nginx

echo "==> Local test: /"
curl -I "http://localhost/" | head -20

if [[ -n "$TEST_IMAGE_PATH" ]]; then
  echo "==> Local test image: $TEST_IMAGE_PATH"
  curl -I "http://localhost$TEST_IMAGE_PATH" | head -20 || true
fi

echo "✅ Done. Nginx is serving the latest content from S3."

Run it on EC2 (SSM shell):

chmod +x pull_site_from_s3_to_nginx.sh
./pull_site_from_s3_to_nginx.sh


