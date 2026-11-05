# EventRent A/S – Eksamensprototype (Cloud Computing, A.7)

> **Dummy-side.** Alle data er fiktive. Intet kan bestilles.

Dette repo indeholder det praktiske produkt til eksamen: en simpel EventRent-hjemmeside, der kan køre lokalt i Docker og i AWS.

## Hvad er implementeret (prototype)

| Del | Teknologi |
|---|---|
| Statisk hjemmeside | `index.html` |
| Container | `Dockerfile` (nginx:alpine), `docker-compose.yml` |
| Cloud-hosting | AWS S3 (privat bucket) + CloudFront (HTTPS, OAC) via `infra/s3-cloudfront.yaml` |
| Alternativ hosting | AWS Amplify Hosting (se nedenfor) |

## Hvad er kun designforslag (produktion)

Bookingdatabase (RDS/DynamoDB), API (API Gateway + Lambda eller ECS Fargate), Route 53 + eget domæne/ACM-certifikat, WAF, AWS Backup, VPN/SSO for medarbejdere (IAM Identity Center), CloudWatch-alarmer, multi-AZ. Disse er **ikke** bygget – de skal vises i arkitekturdiagrammet og forklares mundtligt.

## Kør lokalt (container)

```bash
docker compose up --build
# åbn http://localhost:8080
```

## Deploy til AWS (S3 + CloudFront)

Forudsætninger: AWS-konto, AWS CLI installeret, `aws configure` kørt (brug en IAM-bruger/SSO, ikke root).

```powershell
.\infra\deploy.ps1      # opretter stack + uploader index.html, udskriver URL
.\infra\teardown.ps1    # sletter alt igen
```

## Alternativ: AWS Amplify Hosting (nemmest, PaaS)

1. AWS Console → Amplify → *Host web app* → GitHub → vælg dette repo, branch `main`.
2. Bekræft standard-build (statisk side) → *Save and deploy*.
3. URL: `https://main.<id>.amplifyapp.com` (HTTPS automatisk).

## Verifikation (netværk)

```powershell
Resolve-DnsName <host>
Test-NetConnection <host> -Port 443
curl.exe -I https://<host>
```

## Sikkerhed og drift i prototypen

- S3-bucket er privat (Block Public Access) – kun CloudFront kan læse via Origin Access Control.
- HTTPS gennemtvinges (redirect-to-https), kryptering i hvile (SSE-S3), versionering aktiveret (simpel genetablering).
- Ingen persondata gemmes i prototypen.
- Omkostning: stort set 0 kr. ved lav trafik (free tier); slet stacken efter brug.

## Diagrammer

- [Prototype (implementeret)](diagrams/arkitektur-prototype.svg)
- [Produktion (designforslag)](diagrams/arkitektur-produktion.svg)
- [Disposition](DISPOSITION.md)
