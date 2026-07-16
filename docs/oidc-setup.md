# Setting up GitHub → Azure OIDC (no stored secrets)

Run these with the Azure CLI, logged in as yourself (`az login`).

```bash
# Variables
GH_ORG="ja-me-ry"
GH_REPO="sift"
APP_NAME="gh-oidc-sift"

# 1. Create the app registration + service principal
az ad app create --display-name "$APP_NAME"
APP_ID=$(az ad app list --display-name "$APP_NAME" --query "[0].appId" -o tsv)
az ad sp create --id "$APP_ID"

# 2. Give it Contributor on the resource group (scope tightly — not subscription-wide)
SUBSCRIPTION_ID=$(az account show --query id -o tsv)
az role assignment create \
  --assignee "$APP_ID" \
  --role "Contributor" \
  --scope "/subscriptions/$SUBSCRIPTION_ID/resourceGroups/rg-sift"

# 3. Federated credential — scoped to a specific branch/environment, not "*"
#    GitHub's OIDC token for THIS repo, on THIS ref, is the only thing that
#    can assume this identity. No client secret exists anywhere.
az ad app federated-credential create \
  --id "$APP_ID" \
  --parameters '{
    "name": "gh-sift-main",
    "issuer": "https://token.actions.githubusercontent.com",
    "subject": "repo:'"$GH_ORG"'/'"$GH_REPO"':ref:refs/heads/main",
    "audiences": ["api://AzureADTokenExchange"]
  }'

# Optional second credential scoped to a GitHub Environment (recommended for the deploy job)
az ad app federated-credential create \
  --id "$APP_ID" \
  --parameters '{
    "name": "gh-sift-prod-environment",
    "issuer": "https://token.actions.githubusercontent.com",
    "subject": "repo:'"$GH_ORG"'/'"$GH_REPO"':environment:production",
    "audiences": ["api://AzureADTokenExchange"]
  }'

echo "APP_ID (client ID):      $APP_ID"
echo "TENANT_ID:               $(az account show --query tenantId -o tsv)"
echo "SUBSCRIPTION_ID:         $SUBSCRIPTION_ID"
```

Save the three printed values as **GitHub Actions repo variables** (not secrets — they're not
sensitive on their own, since nothing works without the OIDC token exchange):

- Settings → Secrets and variables → Actions → Variables tab
- `AZURE_CLIENT_ID`, `AZURE_TENANT_ID`, `AZURE_SUBSCRIPTION_ID`

## Verifying it works — the hello-world workflow

Push `.github/workflows/verify-oidc.yml`, then check the Actions tab (trigger it manually —
it's set to `workflow_dispatch`). If `az account show` succeeds with zero stored secrets
referenced, the trust relationship is wired correctly. Delete this workflow once Phase 1's
real pipeline supersedes it — or leave it as a manual smoke test, your call.

Note: create `rg-sift` (the resource group) before running these commands — see the
budget-alert step in the project plan, which creates it.
