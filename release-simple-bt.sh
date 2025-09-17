#!/bin/bash
set -e

# Zet je token hier of exporteer als GH_TOKEN
GH_TOKEN="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"
REPO="renemoeijes/simple-bt"
DEB_FILE="simple-bt_1.1.0_all.deb"  # pas aan indien nodig

# Push lokale wijzigingen naar GitHub
git add .
git commit -m "Nieuwe release"
git push

# Bouw de .deb
./Build-simple-bt.sh

# Haal de laatste tag of maak een nieuwe
TAG="v$(date +%Y%m%d%H%M%S)"
RELEASE_NAME="Release $TAG"
RELEASE_BODY="Automatisch gegenereerde release"

# Maak een nieuwe release (draft=false, prerelease=false)
RELEASE_JSON=$(curl -s -X POST \
  -H "Authorization: token $GH_TOKEN" \
  -H "Content-Type: application/json" \
  -d "{\"tag_name\":\"$TAG\",\"name\":\"$RELEASE_NAME\",\"body\":\"$RELEASE_BODY\",\"draft\":false,\"prerelease\":false}" \
  "https://api.github.com/repos/$REPO/releases")

UPLOAD_URL=$(echo "$RELEASE_JSON" | jq -r .upload_url | sed -e "s/{?name,label}//")

# Upload de .deb als asset
curl -s -X POST \
  -H "Authorization: token $GH_TOKEN" \
  -H "Content-Type: application/vnd.debian.binary-package" \
  --data-binary @"pkg/$DEB_FILE" \
  "$UPLOAD_URL?name=$(basename $DEB_FILE)"

echo "Release en upload voltooid!"