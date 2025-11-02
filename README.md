# Auth Sign In - WeWeb Custom Component

A customizable authentication sign-in form component for WeWeb.

## Features

- Email/password sign-in form
- OAuth provider buttons (GitHub, Google)
- "Keep me signed in" checkbox
- Forgot password link
- Sign up link
- Fully customizable via WeWeb editor

## Installation

### Import from GitHub

1. Go to your WeWeb project
2. Navigate to **Components** → **Custom Components**
3. Click **Import from GitHub**
4. Enter repository URL: `https://github.com/akraut1/create-component.git`
5. Click **Import**

### Local Development

```bash
# Install dependencies
npm install

# Serve locally (replace PORT with your desired port number)
npm run serve --port=3000

# Build for production
npm run build
```

## Component Configuration

### Properties

- **Show GitHub Login** (OnOff): Toggle GitHub OAuth button visibility
- **Show Google Login** (OnOff): Toggle Google OAuth button visibility

### Trigger Events

1. **Email sign in**: Triggered when user submits email/password
   - `email`: User's email address
   - `password`: User's password
   - `keepSignedIn`: Boolean for "keep me signed in" checkbox

2. **OAuth sign in**: Triggered when user clicks an OAuth provider button
   - `provider`: Provider name (e.g., "github", "google")

3. **Forgot password**: Triggered when user clicks forgot password link
   - `email`: User's email address (if entered)

4. **Show sign up**: Triggered when user clicks sign up link

## Usage in WeWeb

1. Add the **Sign In Form** component to your page
2. Configure which OAuth providers to show in the component settings
3. Set up workflows for each trigger event:
   - Connect email sign-in to your authentication backend
   - Handle OAuth flows for GitHub/Google
   - Implement password reset flow
   - Navigate to sign-up page

## Repository Structure

```
/
├── src/                      # Component source code
│   ├── wwElement.vue        # Main Vue component
│   └── styles/              # Component styles
├── ww-config.js             # WeWeb component configuration
├── package.json             # Dependencies and scripts
├── _templates/              # WeWeb component templates (archived)
└── _scaffolding/            # Component scaffolding tool (archived)
```

## Creating Additional Components

If you want to create additional WeWeb components, use the scaffolding tool:

```bash
cd _scaffolding
npm install
node index.js
```

Or create a new repository for each component (recommended approach).

## License

MIT

## Support

For issues or questions, please open an issue on GitHub.
