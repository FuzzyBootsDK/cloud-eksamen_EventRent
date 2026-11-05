# Disposition – Cloud Computing (Ob3), EventRent A/S

## 1. Problemstilling
EventRent A/S (18 medarbejdere) kører hjemmeside og interne data på en ældre lokal server. Udfordringer: vedligeholdelse, adgang uden for kontoret, sæsonvarierende belastning, beskyttelse af kundedata, backup/genetablering og økonomi.
**Problemformulering:** Hvordan kan EventRent moderniseres med virtualisering, containere og cloudtjenester, så løsningen er sikker, tilgængelig, skalerbar og økonomisk realistisk?

## 2. Analyse og krav (udvalgte, prioriterede)
- Offentlig, tilgængelig hjemmeside + plads til fremtidig booking-app
- Beskyttelse af kundeoplysninger (GDPR) og forretningskritiske data
- Sikker fjernadgang for medarbejdere (MFA, mindst muligt privilegium)
- Elasticitet ved varierende belastning; defineret tilgængelighed
- Backup, genetablering (RPO/RTO) og pay-as-you-go økonomi

## 3. Praktisk produkt (implementeret prototype)
- Dummy-hjemmeside i **nginx-container** (Docker, `docker-compose`) – kører lokalt
- Samme side på **AWS**: privat **S3**-bucket + **CloudFront** (HTTPS, Origin Access Control), udrullet med **CloudFormation**; alternativt **Amplify Hosting**
- Verifikation af netværk: `Resolve-DnsName`, `Test-NetConnection -Port 443`, `curl -I`
- Repo: github.com/FuzzyBootsDK/cloud-eksamen_EventRent

**Kun designforslag (ikke bygget):** VPC med offentlige/private subnets, ALB, ECS Fargate/Lambda til booking-API, RDS/DynamoDB (multi-AZ), WAF, Route 53 + ACM, AWS Backup, IAM Identity Center/VPN, CloudWatch.

## 4. Arkitektur (diagram udleveres ved eksamen)
Bruger → DNS (Route 53) → CloudFront/WAF → S3 (statisk) / ALB → containere (API) → privat database-subnet. Medarbejdere → SSO + MFA / VPN → interne systemer. Backup → AWS Backup / S3 versionering.

## 5. Faglige emner
- **Netværk:** IP, CIDR/subnets, DNS (CNAME/A), porte (80/443), NAT, security groups vs. NACL, TCP/HTTP/TLS
- **Virtualisering og containere:** hypervisor/VM vs. container, image/Dockerfile, orkestrering, isolation
- **Cloudmodeller:** IaaS/PaaS/SaaS, delt ansvar, public/hybrid, region/AZ
- **Sikkerhed:** IAM, least privilege, kryptering (i hvile/transit), Block Public Access, GDPR (databehandler, datalokation, backup uden for region)
- **Drift:** backup, RPO/RTO, genetablering, høj tilgængelighed, autoskalering, overvågning, IaC
- **Økonomi:** CAPEX vs. OPEX, free tier, prismodeller, omkostningsstyring (slet ubrugte ressourcer)

## 6. Alternativ arkitektur
| | Valgt: serverless/PaaS (S3+CloudFront, senere Fargate/Lambda) | Alternativ: IaaS (EC2/Ubuntu-VM + Docker) |
|---|---|---|
| Fordele | Lav drift, auto-skalering, billig ved lav trafik | Fuld kontrol, kendt model, nem migrering fra lokal server |
| Ulemper | Mindre kontrol, leverandørbinding | Egen patching/sikkerhed, betaler også ved lav belastning |

## 7. Afgrænsning og refleksion
Prototypen viser statisk hosting, container og HTTPS – ikke database, login, backup eller autoskalering. Disse argumenteres for i designet.

## Litteraturliste
- Mell, P. & Grance, T. (2011). *The NIST Definition of Cloud Computing*, NIST SP 800-145.
- Amazon Web Services. *AWS Well-Architected Framework* (docs.aws.amazon.com/wellarchitected).
- Amazon Web Services. *Amazon S3*, *Amazon CloudFront* og *AWS Amplify Hosting* – brugervejledninger (docs.aws.amazon.com).
- Amazon Web Services. *Shared Responsibility Model* (aws.amazon.com/compliance/shared-responsibility-model).
- Docker Inc. *Docker Docs* (docs.docker.com).
- Europa-Parlamentets og Rådets forordning (EU) 2016/679 (GDPR).
- *Kursusmateriale fra Ob3 – Cloud Computing (tilføj konkrete bøger/slides fra Canvas).*
