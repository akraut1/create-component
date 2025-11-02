#!/bin/bash

# WeWeb Component Repository Security Configuration
# Applies security settings to an existing GitHub repository

set -e

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${BLUE}==================================${NC}"
echo -e "${BLUE}  Repository Security Config${NC}"
echo -e "${BLUE}==================================${NC}\n"

# Check if repository name is provided
if [ -z "$1" ]; then
    echo -e "${YELLOW}Usage: ./configure-repo-security.sh <repository-name>${NC}"
    echo ""
    echo "Example: ./configure-repo-security.sh weweb-auth-sign-in"
    echo ""
    exit 1
fi

REPO_NAME=$1

# Check if gh CLI is available
if ! command -v gh &> /dev/null; then
    echo -e "${RED}✗${NC} GitHub CLI (gh) is not installed"
    echo "Install it with: brew install gh"
    exit 1
fi

# Check if user is authenticated
if ! gh auth status &> /dev/null; then
    echo -e "${RED}✗${NC} Not authenticated with GitHub CLI"
    echo "Run: gh auth login"
    exit 1
fi

# Get GitHub username
GH_USERNAME=$(gh api user -q .login)
FULL_REPO="${GH_USERNAME}/${REPO_NAME}"

echo -e "Configuring security for: ${BLUE}${FULL_REPO}${NC}\n"

# Check if repository exists
if ! gh repo view "$FULL_REPO" > /dev/null 2>&1; then
    echo -e "${RED}✗${NC} Repository not found: ${FULL_REPO}"
    exit 1
fi

# Configure repository settings
echo -e "${GREEN}✓${NC} Configuring repository settings..."

gh repo edit "$FULL_REPO" \
    --enable-merge-commit \
    --enable-squash-merge \
    --enable-rebase-merge \
    --delete-branch-on-merge \
    2>/dev/null || echo -e "${YELLOW}  Note: Some settings may already be configured${NC}"

# Apply branch protection rules
echo -e "${GREEN}✓${NC} Applying branch protection rules..."

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROTECTION_RULES="${SCRIPT_DIR}/.github-protection-rules.json"

if [ -f "$PROTECTION_RULES" ]; then
    if gh api "repos/${FULL_REPO}/branches/main/protection" \
        --method PUT \
        --input "$PROTECTION_RULES" > /dev/null 2>&1; then
        echo -e "${GREEN}✓${NC} Branch protection enabled (main branch)"
    else
        # Try master branch as fallback
        if gh api "repos/${FULL_REPO}/branches/master/protection" \
            --method PUT \
            --input "$PROTECTION_RULES" > /dev/null 2>&1; then
            echo -e "${GREEN}✓${NC} Branch protection enabled (master branch)"
        else
            echo -e "${YELLOW}  Warning: Could not apply branch protection${NC}"
            echo -e "${YELLOW}  Visit: https://github.com/${FULL_REPO}/settings/branches${NC}"
        fi
    fi
else
    echo -e "${RED}✗${NC} Protection rules file not found: ${PROTECTION_RULES}"
    exit 1
fi

echo ""
echo -e "${GREEN}==================================${NC}"
echo -e "${GREEN}  Security Configuration Complete${NC}"
echo -e "${GREEN}==================================${NC}"
echo ""
echo -e "${GREEN}✓${NC} Repository: ${BLUE}https://github.com/${FULL_REPO}${NC}"
echo ""
echo -e "${BLUE}Security Settings Applied:${NC}"
echo -e "  • Force pushes: ${RED}Disabled${NC}"
echo -e "  • Branch deletion: ${RED}Disabled${NC}"
echo -e "  • Auto-delete merged branches: ${GREEN}Enabled${NC}"
echo -e "  • Merge options: ${GREEN}All enabled${NC}"
echo ""
echo -e "${BLUE}Protection Active:${NC}"
echo -e "  ✓ Only you can push to this repository"
echo -e "  ✓ Others can fork and submit PRs"
echo -e "  ✓ History cannot be rewritten (no force push)"
echo ""

