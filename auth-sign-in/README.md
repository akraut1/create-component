# Sign In Form Component for WeWeb

A beautiful, event-driven sign-in form component for WeWeb styled with shadcn/ui design principles. This component provides the UI and emits events for your WeWeb workflows to handle authentication.

## Design

This component matches the **shadcn/ui "sign-in-2"** design system, featuring:
- Clean, modern interface with proper spacing
- Email/password form fields
- GitHub and Google OAuth buttons
- "Forgot password?" link
- "Sign up" link
- Responsive design with dark mode support
- Loading states and error handling

## Architecture: Event-Driven

This is a **UI-only component** that emits events. You handle the actual authentication logic in WeWeb workflows using:
- Clerk authentication
- Supabase Auth
- Custom APIs
- Or any other authentication service

## Events Emitted

The component emits the following events for your WeWeb workflows:

| Event | Payload | Description |
|-------|---------|-------------|
| `email-signin` | `{ email, password }` | User submitted email/password form |
| `oauth-signin` | `{ provider }` | User clicked OAuth button (`'github'` or `'google'`) |
| `forgot-password` | `{ email }` | User clicked "Forgot password?" |
| `show-signup` | - | User clicked "Sign up" link |

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
