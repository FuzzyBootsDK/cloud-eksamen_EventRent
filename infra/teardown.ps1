# Fjerner alt igen (undgå omkostninger). Tømmer bucket inkl. versioner før stacken slettes.
$ErrorActionPreference = 'Stop'
$stack  = 'eventrent-dummy'
$region = 'eu-north-1'
$bucket = aws cloudformation describe-stacks --stack-name $stack --region $region `
  --query "Stacks[0].Outputs[?OutputKey=='BucketName'].OutputValue" --output text

# Versioneret bucket: slet alle versioner og delete markers
$v = aws s3api list-object-versions --bucket $bucket --region $region --output json | ConvertFrom-Json
$objs = @()
if ($v.Versions)      { $objs += $v.Versions      | ForEach-Object { @{Key=$_.Key; VersionId=$_.VersionId} } }
if ($v.DeleteMarkers) { $objs += $v.DeleteMarkers | ForEach-Object { @{Key=$_.Key; VersionId=$_.VersionId} } }
if ($objs.Count -gt 0) {
  $json = @{Objects=$objs; Quiet=$true} | ConvertTo-Json -Depth 5 -Compress
  $tmp = New-TemporaryFile; Set-Content $tmp $json
  aws s3api delete-objects --bucket $bucket --delete "file://$tmp" --region $region | Out-Null
}
aws cloudformation delete-stack --stack-name $stack --region $region
aws cloudformation wait stack-delete-complete --stack-name $stack --region $region
Write-Host "Stack slettet."
