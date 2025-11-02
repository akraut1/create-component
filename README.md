# WeWeb Components Monorepo

Development workspace for creating WeWeb custom components. This monorepo structure allows you to develop multiple components locally, then publish them as separate repositories when ready.

## 📁 Repository Structure

```
weweb-components/
├── auth-sign-in/              # Component: Authentication sign-in form
├── _templates/                # Component templates
│   ├── template-element/      # Vue element template
│   ├── template-element-react/# React element template
│   ├── template-section/      # Vue section template
│   └── template-section-react/# React section template
├── gh-publish-component.sh    # Script to publish components
└── index.js                   # Component scaffolding tool
```

## 🚀 Workflow

### 1. **Develop Locally** (in this monorepo)

All components live here during development. Benefits:
- All components in one place
- Shared tooling and templates
- Easy code reuse and reference
- Fast iteration

### 2. **Publish When Ready** (to separate GitHub repo)

When a component is production-ready, publish it to its own repository:

```bash
# Automatically create standalone repository
./gh-publish-component.sh auth-sign-in
```

This creates a separate git repository at `../weweb-auth-sign-in/` ready to push to GitHub.

### 3. **Push to GitHub**

Follow the instructions from the publish script to push to a new GitHub repository.

### 4. **Import into WeWeb**

Use the GitHub import feature in WeWeb to add your component:
```
https://github.com/YOUR_USERNAME/weweb-component-name.git
```

---

## 📦 Publishing a Component

### Quick Publish (Manual)

```bash
./gh-publish-component.sh <component-name>
```

**Example:**
```bash
./gh-publish-component.sh auth-sign-in
```

This will:
1. ✅ Create `../weweb-auth-sign-in/` directory
2. ✅ Copy all component files
3. ✅ Initialize git repository
4. ✅ Create initial commit
5. ✅ Show next steps for GitHub

### Automated Publish (Recommended)

```bash
./gh-publish-component.sh <component-name> --create-repo
```

**Example:**
```bash
./gh-publish-component.sh auth-sign-in --create-repo
```

This will:
1. ✅ Create standalone repository
2. ✅ Initialize git
3. ✅ **Automatically create GitHub repository**
4. ✅ **Push code to GitHub**
5. ✅ **Apply security settings** (branch protection, force push prevention)
6. ✅ Show WeWeb import URL

**Security features automatically applied:**
- 🔒 Force pushes disabled
- 🔒 Branch deletion disabled
- 🔒 Only you can push changes
- ✅ Others can fork and submit PRs

### Manual Publish Process

If you prefer to do it manually:

1. **Create destination directory:**
   ```bash
   mkdir -p ../weweb-component-name
   ```

2. **Copy component files:**
   ```bash
   cp -r ./component-name/* ../weweb-component-name/
   cp ./component-name/.gitignore ../weweb-component-name/
   ```

3. **Initialize git:**
   ```bash
   cd ../weweb-component-name
   git init
   git add -A
   git commit -m "Initial commit: component-name WeWeb component"
   ```

4. **Push to GitHub** (after creating empty repo on GitHub):
   ```bash
   git remote add origin https://github.com/YOUR_USERNAME/weweb-component-name.git
   git branch -M main
   git push -u origin main
   ```

---

## 🛠️ Creating New Components

### Using the Scaffolding Tool

```bash
npm init @weweb/component my-component --type element
```

Or interactively:
```bash
node index.js
```

### From Templates

Copy one of the template directories from `_templates/`:
- `_templates/template-element/` - Vue element
- `_templates/template-element-react/` - React element
- `_templates/template-section/` - Vue section
- `_templates/template-section-react/` - React section

---

## 💻 Development Commands

Each component has these npm scripts:

```bash
# Navigate to component folder
cd auth-sign-in/

# Install dependencies
npm install

# Serve locally (replace PORT with desired port number)
npm run serve --port=3000

# Build for production
npm run build
```

---

## 📋 Component Naming Convention

When publishing to GitHub, use this naming pattern:
```
weweb-<component-name>
```

**Examples:**
- `weweb-auth-sign-in`
- `weweb-calendar`
- `weweb-data-table`
- `weweb-form-builder`

This keeps all your WeWeb components grouped together on GitHub.

---

## 🏢 Alternative: GitHub Organization

For better organization, consider creating a GitHub organization:

1. Create organization: https://github.com/organizations/plan
2. Name it: `your-company-components` or `akraut-weweb`
3. Publish components there: `github.com/your-org/auth-sign-in`

Benefits:
- Cleaner URLs
- Professional appearance
- Team collaboration
- Separate from personal repos

---

## 📚 Available Components

### auth-sign-in
Authentication sign-in form with email/password and OAuth providers (GitHub, Google).

**Features:**
- Email/password sign-in
- OAuth provider buttons
- "Keep me signed in" option
- Forgot password flow
- Sign-up link

---

## 🔧 Maintenance

### Updating Published Components

After making changes to a component in this monorepo:

1. **Re-publish the component:**
   ```bash
   ./gh-publish-component.sh component-name
   ```

2. **Navigate to published repo:**
   ```bash
   cd ../weweb-component-name
   ```

3. **Push updates:**
   ```bash
   git add -A
   git commit -m "Update: description of changes"
   git push
   ```

WeWeb will automatically pull the latest version on next sync.

### Applying Security Settings to Existing Repos

If you have existing repositories that need security configuration:

```bash
./gh-protect-repo.sh weweb-component-name
```

This applies:
- Branch protection rules
- Force push prevention
- Auto-delete merged branches

See [SECURITY.md](SECURITY.md) for details.

---

## 📖 Documentation

For WeWeb component development guidelines, see:
- `.cursor/rules/weweb-component-guidelines.mdc`

---

## 📄 License

MIT
