# Auth Sign-In Component for WeWeb

A beautiful, event-driven sign-in form component for WeWeb styled with shadcn/ui design principles. This component provides the UI and emits events for your WeWeb workflows to handle authentication.

## Design

This component matches the **shadcn/ui** design system, featuring:
- Clean, modern interface with proper spacing
- Email/password form fields
- GitHub and Google OAuth buttons
- "Keep me signed in" checkbox
- "Forgot password?" link
- "Sign up" link
- Responsive design with CSS variables for theming
- Loading states and error handling
- Figma design specifications

## Architecture: Event-Driven

This is a **UI-only component** that emits events. You handle the actual authentication logic in WeWeb workflows using:
- **Supabase Auth** (see detailed guide below)
- Clerk authentication
- Custom APIs
- Or any other authentication service

## Events Emitted

The component emits the following events for your WeWeb workflows:

| Event | Payload | Description |
|-------|---------|-------------|
| `email-signin` | `{ email, password, keepSignedIn }` | User submitted email/password form |
| `oauth-signin` | `{ provider }` | User clicked OAuth button (`'github'` or `'google'`) |
| `forgot-password` | `{ email }` | User clicked "Forgot password?" |
| `show-signup` | `{}` | User clicked "Sign up" link |

## Component Properties

Configure these in the WeWeb editor:

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| `showGithubLogin` | Boolean | `true` | Show/hide GitHub OAuth button |
| `showGoogleLogin` | Boolean | `true` | Show/hide Google OAuth button |

## Setup in WeWeb

### 1. Import the Component

1. Go to **Coded Components** in WeWeb
2. **Import from GitHub:**
   - Repository: `akraut1/create-component`
   - Branch: `fix-import-global-styles-95733`
   - Path: `sign-in`
3. Wait for the build to complete

### 2. Add to Your Page

1. Drag the **"Sign In Form"** component onto your page
2. Configure the properties (show/hide OAuth buttons)

### 3. Connect to Workflows

Click on the component and add event listeners in the WeWeb workflows panel:

#### Email/Password Sign In

**Event:** `email-signin`

**Example Workflow:**
```
1. Get event payload: email, password
2. Call Clerk API / Supabase Auth / Your API
3. On success: 
   - Save user session
   - Navigate to dashboard
4. On error:
   - Call component.setError("Invalid credentials")
```

#### OAuth Sign In

**Event:** `oauth-signin`

**Example Workflow:**
```
1. Get event payload: provider ("github" or "google")
2. Redirect to OAuth flow:
   - Clerk OAuth URL
   - Supabase OAuth URL
   - Custom OAuth endpoint
```

#### Forgot Password

**Event:** `forgot-password`

**Example Workflow:**
```
1. Get event payload: email
2. Call password reset API
3. Show success message
```

#### Show Sign Up

**Event:** `show-signup`

**Example Workflow:**
```
1. Navigate to sign-up page
```

## Public Methods

You can call these methods from WeWeb workflows:

| Method | Parameters | Description |
|--------|------------|-------------|
| `setError(message)` | `message: string` | Display an error message |
| `setLoading(isLoading)` | `isLoading: boolean` | Set loading state |
| `clearForm()` | - | Reset form fields and state |

### Example: Show Error After Failed Login

In your workflow after API call fails:
```
Component → Execute Action → setError → "Invalid email or password"
```

---

## 🔥 Supabase Auth Integration (Complete Guide)

This component works seamlessly with Supabase Auth. Here's the complete setup guide:

### Prerequisites

1. **Install Supabase Plugin in WeWeb**
   - Go to **Plugins** → **Add Plugin**
   - Install **Supabase**
   - Configure with your project URL and anon key

2. **Enable Auth Providers in Supabase Dashboard**
   - Go to **Authentication** → **Providers**
   - Enable **Email** provider
   - Enable **GitHub** and/or **Google** OAuth (optional)
   - Add OAuth credentials from provider dashboards

### Event Workflow Setup

#### 1. Email/Password Sign In

**Event:** `email-signin`

**WeWeb Workflow Steps:**

```
1. Supabase → Sign in with email
   - Email: event.email
   - Password: event.password

2. On Success:
   - Store user data: Set variable "user" = Supabase.user
   - Navigate to: /dashboard
   
3. On Error:
   - Component → Execute Action → setError
   - Message: error.message
```

**Code Example (if using custom JavaScript):**

```javascript
// Event payload: { email, password, keepSignedIn }

const { data, error } = await wwLib.supabase.auth.signInWithPassword({
  email: event.email,
  password: event.password
});

if (error) {
  // Show error in the form component
  wwLib.components[componentUid].setError(error.message);
} else {
  // Handle "Keep me signed in"
  if (event.keepSignedIn) {
    localStorage.setItem('keepSignedIn', 'true');
  }
  
  // Navigate to dashboard
  wwLib.goTo('/dashboard');
}
```

#### 2. OAuth Sign In (GitHub/Google)

**Event:** `oauth-signin`

**WeWeb Workflow Steps:**

```
1. Supabase → Sign in with OAuth
   - Provider: event.provider
   - Redirect URL: https://your-app.com/auth/callback
```

**Code Example:**

```javascript
// Event payload: { provider } - will be 'github' or 'google'

const { data, error } = await wwLib.supabase.auth.signInWithOAuth({
  provider: event.provider,
  options: {
    redirectTo: 'https://your-app.com/auth/callback'
  }
});

if (error) {
  console.error('OAuth error:', error);
  wwLib.components[componentUid].setError('OAuth sign in failed');
}
```

#### 3. Forgot Password

**Event:** `forgot-password`

**WeWeb Workflow Steps:**

```
1. Supabase → Send password reset email
   - Email: event.email
   - Redirect URL: https://your-app.com/reset-password
   
2. Show notification:
   - Message: "Password reset email sent! Check your inbox."
```

**Code Example:**

```javascript
// Event payload: { email }

const { error } = await wwLib.supabase.auth.resetPasswordForEmail(
  event.email,
  {
    redirectTo: 'https://your-app.com/reset-password'
  }
);

if (error) {
  wwLib.components[componentUid].setError(error.message);
} else {
  // Show success message
  wwLib.showNotification('Password reset email sent!');
}
```

#### 4. Show Sign Up

**Event:** `show-signup`

**WeWeb Workflow Steps:**

```
1. Navigate to: /signup
```

Simple navigation workflow - no Supabase call needed.

### Supabase Project Configuration

In your Supabase dashboard:

#### Email Authentication Setup

1. Go to **Authentication** → **Providers** → **Email**
2. Enable **Email provider**
3. Configure email templates (optional):
   - Confirmation email
   - Password reset email
   - Email change confirmation

#### OAuth Setup (GitHub Example)

1. **Create GitHub OAuth App:**
   - Go to GitHub Settings → Developer settings → OAuth Apps
   - Create new OAuth App
   - Homepage URL: `https://your-app.com`
   - Callback URL: `https://YOUR_PROJECT.supabase.co/auth/v1/callback`

2. **Configure in Supabase:**
   - Copy Client ID and Client Secret from GitHub
   - Paste into Supabase → Authentication → Providers → GitHub
   - Enable GitHub provider
   - Save

3. **Repeat for Google** (if needed):
   - Get OAuth credentials from Google Cloud Console
   - Add to Supabase → Authentication → Providers → Google

#### URL Configuration

1. Go to **Authentication** → **URL Configuration**
2. Add your **Site URL**: `https://your-app.com`
3. Add **Redirect URLs**:
   - `https://your-app.com/auth/callback`
   - `https://your-app.com/reset-password`
   - `http://localhost:3000/auth/callback` (for development)

### Complete Workflow Example

Here's a complete visual workflow setup in WeWeb:

```
Component: Auth Sign-In Form
├─ showGithubLogin: true
├─ showGoogleLogin: true
│
Events:
│
├─ ON email-signin:
│  ├─ 1. Supabase.signInWithPassword()
│  │     - email: event.email
│  │     - password: event.password
│  │
│  ├─ 2. IF success:
│  │     ├─ Set var: currentUser = Supabase.user
│  │     ├─ IF event.keepSignedIn:
│  │     │   └─ localStorage.set('keepSignedIn', true)
│  │     └─ Navigate: /dashboard
│  │
│  └─ 3. IF error:
│        └─ Component.setError(error.message)
│
├─ ON oauth-signin:
│  └─ Supabase.signInWithOAuth()
│        - provider: event.provider
│        - redirectTo: /auth/callback
│
├─ ON forgot-password:
│  ├─ Supabase.resetPasswordForEmail()
│  │     - email: event.email
│  │     - redirectTo: /reset-password
│  │
│  └─ Show notification: "Check your email!"
│
└─ ON show-signup:
   └─ Navigate: /signup
```

### Testing Your Integration

1. **Test Email Sign In:**
   - Enter valid credentials
   - Should navigate to /dashboard
   - Check Supabase dashboard → Authentication → Users

2. **Test OAuth:**
   - Click GitHub/Google button
   - Should redirect to provider
   - Should callback and create user

3. **Test Forgot Password:**
   - Enter email address
   - Check email inbox for reset link
   - Click link → should redirect to /reset-password

4. **Test Error Handling:**
   - Try wrong password → should show error in form
   - Try non-existent email → should show error

### Security Best Practices

1. **Enable RLS (Row Level Security)**
   ```sql
   ALTER TABLE your_table ENABLE ROW LEVEL SECURITY;
   
   CREATE POLICY "Users can read own data"
   ON your_table FOR SELECT
   USING (auth.uid() = user_id);
   ```

2. **Set Up Email Verification**
   - Supabase → Authentication → Email → Confirm email

3. **Configure Password Requirements**
   - Minimum password length
   - Complexity requirements

4. **Monitor Failed Attempts**
   - Check Supabase logs for suspicious activity

### Troubleshooting

**Issue: "Email not confirmed"**
- Solution: Check Supabase → Authentication → Email → Confirm email setting

**Issue: OAuth redirect fails**
- Solution: Verify callback URL matches in both provider and Supabase

**Issue: "Invalid login credentials"**
- Solution: Check if user exists in Supabase dashboard

**Issue: Password reset email not received**
- Solution: Check Supabase email templates and SMTP configuration

---

## Example: Clerk Integration

### Option 1: Using Clerk's Hosted UI (Recommended)

1. **On `oauth-signin` event:**
   ```
   - Navigate to: https://your-app.clerk.accounts.dev/sign-in/sso-callback?provider=[event.provider]
   ```

2. **On `email-signin` event:**
   ```
   - Use Clerk's API to authenticate
   - Or redirect to Clerk's hosted sign-in page
   ```

### Option 2: Using Clerk API Directly

Add Clerk scripts to your WeWeb project's **Custom Head Code**:

```html
<script src="https://cdn.jsdelivr.net/npm/@clerk/clerk-js@5/dist/clerk.browser.js"></script>
<script>
  // Initialize Clerk globally
  window.clerkInstance = new window.Clerk('YOUR_PUBLISHABLE_KEY');
  window.clerkInstance.load();
</script>
```

Then in your workflows, execute JavaScript:
```javascript
// On email-signin event
const { email, password } = event.payload;
const result = await window.clerkInstance.signIn.create({
  identifier: email,
  password: password
});

if (result.status === 'complete') {
  await window.clerkInstance.setActive({ session: result.createdSessionId });
  // Navigate to dashboard
}
```

## Example: Supabase Integration

### Setup

In WeWeb, connect your Supabase project via the Supabase plugin.

### Workflow

**On `email-signin` event:**
```
1. Supabase → Sign In with Email
   - Email: event.email
   - Password: event.password
2. On success:
   - Navigate to /dashboard
3. On error:
   - Component → setError → error.message
```

**On `oauth-signin` event:**
```
1. Supabase → Sign In with OAuth
   - Provider: event.provider
   - Redirect URL: /auth/callback
```

## Styling

The component uses scoped SCSS and follows shadcn/ui design tokens:

- **Colors**: Tailwind-inspired grays and blues
- **Spacing**: Consistent rem-based spacing
- **Typography**: Clean, readable font sizes
- **Dark Mode**: Automatic via `prefers-color-scheme`

To customize, fork the component and modify the `<style>` section.

## Development

To serve locally:
```bash
npm install
npm run serve
```

To build:
```bash
npm run build
```

## Benefits of This Approach

✅ **No external dependencies** - Builds successfully in WeWeb  
✅ **Security compliant** - No CSP violations  
✅ **Flexible** - Works with any auth provider  
✅ **Maintainable** - Separation of UI and logic  
✅ **Reusable** - Same component for Clerk, Supabase, Auth0, etc.  

## Resources

- [shadcn/ui Design System](https://ui.shadcn.com)
- [WeWeb Documentation](https://docs.weweb.io)
- [Clerk Documentation](https://clerk.com/docs)
- [Supabase Auth Documentation](https://supabase.com/docs/guides/auth)

## License

MIT
