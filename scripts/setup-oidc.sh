GH_ORG="ja-me-ry"
GH_OWNER_ID="192547426"
GH_REPO="sift"
GH_REPO_ID="1303152829"
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
#    Uses the immutable subject format (owner ID + repo ID) required for this repo.
#    GitHub's OIDC token for THIS repo, on THIS ref, is the only thing that
#    can assume this identity. No client secret exists anywhere.
az ad app federated-credential create \
  --id "$APP_ID" \
  --parameters '{
    "name": "gh-sift-main",
    "issuer": "https://token.actions.githubusercontent.com",
    "subject": "repo:'"$GH_ORG"'@'"$GH_OWNER_ID"'/'"$GH_REPO"'@'"$GH_REPO_ID"':ref:refs/heads/main",
    "audiences": ["api://AzureADTokenExchange"]
  }'

# Optional second credential scoped to a GitHub Environment (recommended for the deploy job)
az ad app federated-credential create \
  --id "$APP_ID" \
  --parameters '{
    "name": "gh-sift-prod-environment",
    "issuer": "https://token.actions.githubusercontent.com",
    "subject": "repo:'"$GH_ORG"'@'"$GH_OWNER_ID"'/'"$GH_REPO"'@'"$GH_REPO_ID"':environment:production",
    "audiences": ["api://AzureADTokenExchange"]
  }'

echo "APP_ID (client ID):      $APP_ID"
echo "TENANT_ID:               $(az account show --query tenantId -o tsv)"
echo "SUBSCRIPTION_ID:         $SUBSCRIPTION_ID"