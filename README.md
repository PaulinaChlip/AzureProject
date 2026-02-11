# Terraform + Python EventHub CI/CD
Ten projekt zawiera:
- Infrastruktura jako kod (Terraform) w katalogu `iac/`
- Skrypt Python do wysyłania zdarzeń do Azure Event Hub (`scripts/send_events.py`)
- CIw GitHub Actions sprawdzający poprawność Terraform i Pythona

## Struktura repozytorium

root/
├─ scripts/
│  ├─ send_events.py       
│  └─ requirements.txt
├─ notebooks/
│  ├─ aggregateData.py       
│  └─ dailytasktrigger.py 
└─ iac/
   ├─ main.tf
   ├─ variables.tf
   └─ terraform.tfvars

## Wymagania
- GitHub Actions do CI
- Python 3.11
- Terraform >= 1.6.0
- Konto Azure z dostępem do Event Hub

## Instalacja
1. Sklonuj repozytorium:
   ```bash
   git clone <repo-url>
   cd <repo-folder>
   ```
2. Zainstaluj zależnści Pythona
  pip install -r scripts/requirements.txt

3. Uruchom skrypt
  python scripts/send_events.py

4. W katalogu iac/ możesz testować Terraform:
  cd iac
  terraform init
  terraform validate
  terraform plan -var-file="terraform.tfvars"

## Dalszy przebieg projektu
W dalszych krokach można skonfigurować analizowanie przeysłanego przez skrypt potoku danych, np. poprzez Databricks (w repozytorium załączony jest gotowy notatnik wykonujący agregację w Databricks).

