#!/bin/bash

# WeWeb Component Publisher
# Copies a component from monorepo to a standalone repository

set -e

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${BLUE}==================================${NC}"
echo -e "${BLUE}  WeWeb Component Publisher${NC}"
echo -e "${BLUE}==================================${NC}\n"

# Parse arguments
CREATE_REPO=false
COMPONENT_NAME=""

while [[ $# -gt 0 ]]; do
    case $1 in
        --create-repo)
            CREATE_REPO=true
            shift
            ;;
        *)
            COMPONENT_NAME=$1
            shift
            ;;
    esac
done

# Check if component name is provided
if [ -z "$COMPONENT_NAME" ]; then
    echo -e "${YELLOW}Usage: ./gh-publish-component.sh <component-folder-name> [--create-repo]${NC}"
    echo ""
    echo "Options:"
    echo "  --create-repo    Automatically create GitHub repository and push"
    echo ""
    echo "Available components:"
    ls -d */ 2>/dev/null | grep -v "node_modules\|_templates\|_scaffolding\|.git\|.cursor\|src" | sed 's|/||'
    exit 1
fi

SOURCE_DIR="./${COMPONENT_NAME}"
DEST_DIR="../weweb-${COMPONENT_NAME}"

# Check if source component exists
if [ ! -d "$SOURCE_DIR" ]; then
    echo -e "${YELLOW}Error: Component '${COMPONENT_NAME}' not found${NC}"
    echo "Make sure the folder exists in: $(pwd)"
    exit 1
fi

# Check if destination already exists
if [ -d "$DEST_DIR" ]; then
    echo -e "${YELLOW}Warning: Destination ${DEST_DIR} already exists${NC}"
    read -p "Do you want to overwrite it? (y/N): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo "Cancelled."
        exit 1
    fi
    rm -rf "$DEST_DIR"
fi

# Create destination directory
echo -e "${GREEN}✓${NC} Creating standalone repository: ${DEST_DIR}"
mkdir -p "$DEST_DIR"

# Copy component files
echo -e "${GREEN}✓${NC} Copying component files..."
cp -r "${SOURCE_DIR}"/* "${DEST_DIR}/"
if [ -f "${SOURCE_DIR}/.gitignore" ]; then
    cp "${SOURCE_DIR}/.gitignore" "${DEST_DIR}/"
fi

# Initialize git repository
echo -e "${GREEN}✓${NC} Initializing git repository..."
cd "$DEST_DIR"
git init
git add -A
git commit -m "Initial commit: ${COMPONENT_NAME} WeWeb component"

# Create GitHub repository if requested
if [ "$CREATE_REPO" = true ]; then
    echo -e "${GREEN}✓${NC} Creating GitHub repository..."
    
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
    REPO_NAME="weweb-${COMPONENT_NAME}"
    
    # Create repository and push
    echo -e "${BLUE}Creating repository: ${GH_USERNAME}/${REPO_NAME}${NC}"
    
    if gh repo create "${GH_USERNAME}/${REPO_NAME}" \
        --public \
        --source=. \
        --remote=origin \
        --description="WeWeb custom component: ${COMPONENT_NAME}" \
        --push; then
        
        # Rename branch to main
        git branch -M main
        git push -u origin main
        
        echo -e "${GREEN}✓${NC} Repository created and code pushed"
        
        # Configure repository security settings
        echo -e "${GREEN}✓${NC} Configuring repository security..."
        
        # Enable repository settings
        gh repo edit "${GH_USERNAME}/${REPO_NAME}" \
            --enable-merge-commit \
            --enable-squash-merge \
            --enable-rebase-merge \
            --delete-branch-on-merge \
            2>/dev/null || echo -e "${YELLOW}  Note: Some repo settings may require manual configuration${NC}"
        
        # Apply branch protection rules
        echo -e "${GREEN}✓${NC} Applying branch protection rules..."
        
        # Check if protection rules file exists
        SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
        PROTECTION_RULES="${SCRIPT_DIR}/.github-protection-rules.json"
        
        if [ -f "$PROTECTION_RULES" ]; then
            if gh api "repos/${GH_USERNAME}/${REPO_NAME}/branches/main/protection" \
                --method PUT \
                --input "$PROTECTION_RULES" > /dev/null 2>&1; then
                echo -e "${GREEN}✓${NC} Branch protection enabled (main branch)"
            else
                echo -e "${YELLOW}  Note: Branch protection rules may require manual setup${NC}"
                echo -e "${YELLOW}  Visit: https://github.com/${GH_USERNAME}/${REPO_NAME}/settings/branches${NC}"
            fi
        else
            echo -e "${YELLOW}  Warning: Protection rules file not found${NC}"
        fi
        
        echo ""
        echo -e "${GREEN}==================================${NC}"
        echo -e "${GREEN}  Component Published!${NC}"
        echo -e "${GREEN}==================================${NC}"
        echo ""
        echo -e "${GREEN}✓${NC} Repository: ${BLUE}https://github.com/${GH_USERNAME}/${REPO_NAME}${NC}"
        echo -e "${GREEN}✓${NC} Code pushed to GitHub"
        echo -e "${GREEN}✓${NC} Security settings applied"
        echo ""
        echo -e "${BLUE}Repository Protection:${NC}"
        echo -e "  • Force pushes: ${RED}Disabled${NC}"
        echo -e "  • Branch deletion: ${RED}Disabled${NC}"
        echo -e "  • Auto-delete merged branches: ${GREEN}Enabled${NC}"
        echo ""
        echo -e "${YELLOW}Import into WeWeb:${NC}"
        echo -e "   ${BLUE}https://github.com/${GH_USERNAME}/${REPO_NAME}.git${NC}"
        echo ""
    else
        echo -e "${RED}✗${NC} Failed to create GitHub repository"
        echo "You can create it manually and push later."
        exit 1
    fi
else
    # Manual instructions
    echo ""
    echo -e "${GREEN}==================================${NC}"
    echo -e "${GREEN}  Component Ready to Publish!${NC}"
    echo -e "${GREEN}==================================${NC}"
    echo ""
    echo -e "Repository created at: ${BLUE}${DEST_DIR}${NC}"
    echo ""
    echo -e "${YELLOW}Next steps:${NC}"
    echo ""
    echo "1. Create a new GitHub repository:"
    echo -e "   ${BLUE}https://github.com/new${NC}"
    echo ""
    echo "2. Repository name: ${BLUE}weweb-${COMPONENT_NAME}${NC}"
    echo "   ❌ DO NOT initialize with README, .gitignore, or license"
    echo ""
    echo "3. Run these commands:"
    echo -e "   ${BLUE}cd ${DEST_DIR}${NC}"
    echo -e "   ${BLUE}git remote add origin https://github.com/YOUR_USERNAME/weweb-${COMPONENT_NAME}.git${NC}"
    echo -e "   ${BLUE}git branch -M main${NC}"
    echo -e "   ${BLUE}git push -u origin main${NC}"
    echo ""
    echo -e "${BLUE}Or re-run with --create-repo flag to automate this!${NC}"
    echo ""
    echo "4. Import into WeWeb:"
    echo -e "   ${BLUE}https://github.com/YOUR_USERNAME/weweb-${COMPONENT_NAME}.git${NC}"
    echo ""
fi

