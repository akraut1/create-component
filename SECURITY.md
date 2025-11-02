# Repository Security Guide

This document explains the security configuration applied to all published WeWeb component repositories.

## 🔒 Automatic Security Configuration

When you publish a component using `./gh-publish-component.sh <component> --create-repo`, the following security settings are **automatically applied**:

### Repository Settings

- ✅ **Merge commits**: Enabled
- ✅ **Squash merging**: Enabled  
- ✅ **Rebase merging**: Enabled
- ✅ **Auto-delete merged branches**: Enabled

### Branch Protection (main branch)

- ❌ **Force pushes**: **DISABLED**
- ❌ **Branch deletion**: **DISABLED**
- ✅ **Fork syncing**: Enabled

### Access Control

- ✅ **Public visibility**: Anyone can view and fork
- ❌ **Write access**: Only repository owner (you)
- ✅ **Pull requests**: Anyone can submit from their fork
- ❌ **Direct commits**: Only you (repository owner)

---

## 🛡️ What This Means

### ✅ You CAN:
- Push commits directly to main branch
- Merge pull requests
- Delete branches (except main)
- Modify repository settings
- Manage collaborators (if you choose to add any)

### ✅ Others CAN:
- View your public repository
- Clone your repository
- Fork your repository to their account
- Submit pull requests from their fork
- Open issues (if enabled)

### ❌ Others CANNOT:
- Push commits to your repository
- Merge pull requests
- Delete branches
- Force push to rewrite history
- Modify repository settings
- Add collaborators

---

## 🔧 Manual Security Configuration

If you already have a repository and want to apply these security settings:

```bash
./gh-protect-repo.sh weweb-component-name
```

**Example:**
```bash
./gh-protect-repo.sh weweb-auth-sign-in
```

This will apply the same security rules to an existing repository.

---

## 📋 Security Rules Template

The security configuration is defined in `.github-protection-rules.json`:

```json
{
  "allow_force_pushes": false,      // Prevent history rewriting
  "allow_deletions": false,          // Prevent branch deletion
  "allow_fork_syncing": true,        // Allow forks to sync
  "required_linear_history": false,  // Allow merge commits
  "enforce_admins": false            // Owner can override (you)
}
```

You can modify this file to customize protection rules for all future published components.

---

## 🚨 Additional Security Recommendations

### 1. Enable Two-Factor Authentication (2FA)

Protect your GitHub account:
1. Go to: https://github.com/settings/security
2. Enable 2FA with authenticator app or security key

### 2. Use SSH Keys for Git Operations

More secure than HTTPS:
```bash
# Generate SSH key
ssh-keygen -t ed25519 -C "your_email@example.com"

# Add to GitHub
cat ~/.ssh/id_ed25519.pub
# Copy output and add to: https://github.com/settings/keys
```

### 3. Review Access Logs

Periodically check who accessed your repositories:
- Go to repository → **Insights** → **Traffic**
- Check for unexpected clones or views

### 4. Enable Dependabot Alerts

Get notified of security vulnerabilities in dependencies:
1. Go to repository → **Settings** → **Security & analysis**
2. Enable:
   - ✅ Dependabot alerts
   - ✅ Dependabot security updates

---

## 🔍 Verifying Security Settings

### Check Branch Protection

```bash
gh api repos/YOUR_USERNAME/weweb-component-name/branches/main/protection
```

### Check Repository Settings

```bash
gh repo view YOUR_USERNAME/weweb-component-name
```

### Manual Verification

Visit: `https://github.com/YOUR_USERNAME/weweb-component-name/settings/branches`

You should see:
- ✅ Branch protection rule for `main`
- ❌ Allow force pushes: **Unchecked**
- ❌ Allow deletions: **Unchecked**

---

## ⚠️ Important Notes

### Force Push Protection

Even though force pushes are disabled, this primarily protects against:
- Accidental force pushes from collaborators
- Malicious force pushes from compromised accounts

**Note**: As the repository owner, you can still disable protection rules temporarily if needed. Use this power responsibly!

### Pull Request Workflow

When someone wants to contribute:

1. They **fork** your repository
2. They make changes in **their fork**
3. They submit a **pull request** to your repository
4. **You review** and merge (or reject)

This ensures you maintain full control over what goes into your components.

---

## 📞 Security Issues

If you discover a security vulnerability in any published component:

1. **Do NOT** open a public issue
2. Contact the repository owner directly
3. Allow time for a fix before public disclosure

---

## 🔄 Updating Security Settings

If you need to modify security rules for all future components:

1. Edit `.github-protection-rules.json`
2. Commit changes
3. Future published components will use new rules
4. Apply to existing repos with: `./gh-protect-repo.sh <repo-name>`

---

## ✅ Security Checklist

Before publishing a component to production:

- [ ] Security settings applied automatically (if using `--create-repo`)
- [ ] Branch protection verified on GitHub
- [ ] No collaborators added (unless intended)
- [ ] Repository is public (for WeWeb import)
- [ ] 2FA enabled on your GitHub account
- [ ] Dependencies reviewed for vulnerabilities
- [ ] No secrets/credentials in code

---

Last Updated: November 2025

