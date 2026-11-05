# Deployer EventRent dummy-siden til AWS (S3 + CloudFront). Kræver AWS CLI og `aws configure`.
# Brug:  .\infra\deploy.ps1
$ErrorActionPreference = 'Stop'
$stack  = 'eventrent-dummy'
$region = 'eu-north-1'   # Stockholm. CloudFront er global, S3-bucket ligger i denne region.

aws cloudformation deploy `
  --stack-name $stack `
  --template-file "$PSScriptRoot\s3-cloudfront.yaml" `
  --region $region

$bucket = aws cloudformation describe-stacks --stack-name $stack --region $region `
  --query "Stacks[0].Outputs[?OutputKey=='BucketName'].OutputValue" --output text
$url = aws cloudformation describe-stacks --stack-name $stack --region $region `
  --query "Stacks[0].Outputs[?OutputKey=='SiteUrl'].OutputValue" --output text

aws s3 cp "$PSScriptRoot\..\index.html" "s3://$bucket/index.html" --content-type "text/html; charset=utf-8" --region $region

Write-Host "Færdig: $url (kan tage et par minutter før CloudFront svarer)"
