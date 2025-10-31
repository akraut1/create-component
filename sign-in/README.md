# Clerk Sign In Component for WeWeb

A beautiful, production-ready sign-in component for WeWeb that integrates Clerk authentication with Supabase using the official third-party auth integration.

## Design

This component is styled to match the **shadcn/ui "sign-in-2"** design system, featuring:
- Clean, modern interface with proper spacing
- Email/password authentication
- GitHub and Google OAuth buttons
- "Forgot password?" functionality
- Responsive design with dark mode support
- Loading states and error handling

## Features

✅ **Clerk Authentication**
- Email/password sign-in
- GitHub OAuth (replacing Apple)
- Google OAuth
- Session management

✅ **Supabase Integration**
- Automatic JWT token integration
- Works with Supabase RLS policies
- Compatible with Clerk third-party auth

✅ **WeWeb Compatible**
- Configurable properties
- Event emission for WeWeb workflows
- Responsive design

## Installation

1. Install dependencies:
```bash
npm install
```

2. Build the component:
```bash
npm run build
```

## Configuration

### Required Properties

Set these in WeWeb's component properties panel:

| Property | Description | Example |
|----------|-------------|---------|
| `clerkPublishableKey` | Your Clerk publishable key | `pk_test_...` |
| `supabaseUrl` | Your Supabase project URL | `https://xxx.supabase.co` |
| `supabaseAnonKey` | Your Supabase anon key | `eyJhbGciOiJIUzI1...` |

### Optional Properties

| Property | Description | Default |
|----------|-------------|---------|
| `showGithubLogin` | Show GitHub login button | `true` |
| `showGoogleLogin` | Show Google login button | `true` |
| `redirectAfterSignIn` | Where to redirect after sign in | `/dashboard` |

## Setup Guide

### 1. Configure Clerk

1. Go to [Clerk Dashboard](https://dashboard.clerk.com)
2. Enable GitHub and/or Google OAuth providers
3. Visit [Clerk's Connect with Supabase page](https://clerk.com/docs/integrations/databases/supabase)
4. Follow the setup to add the `role` claim to your JWT tokens

### 2. Configure Supabase

1. Go to your Supabase project dashboard
2. Navigate to **Authentication** → **Providers** → **Third Party Auth**
3. Click "Add provider" and select **Clerk**
4. Enter your Clerk domain (e.g., `your-app.clerk.accounts.dev`)
5. Enable the integration

### 3. Add Component to WeWeb

1. Upload this component to your WeWeb project
2. Drag it onto your sign-in page
3. Configure the properties (Clerk key, Supabase URL, etc.)

### 4. Use RLS Policies

Now you can use Clerk JWT claims in your Supabase RLS policies:

```sql
-- Example: Allow access based on Clerk organization
create policy "Users can access their org data"
on your_table
for select
to authenticated
using (
  organization_id = (select coalesce(auth.jwt()->>'org_id', auth.jwt()->'o'->>'id'))
);
```

## Events

The component emits the following events for WeWeb workflows:

| Event | Payload | Description |
|-------|---------|-------------|
| `signin-success` | `{ user, session }` | Fired when sign-in succeeds |
| `forgot-password` | - | Fired when "Forgot password?" is clicked |
| `show-signup` | - | Fired when "Sign up" link is clicked |

## How It Works

1. **User signs in** via Clerk (email/password or OAuth)
2. **Clerk generates JWT** with proper claims including `role: 'authenticated'`
3. **Supabase validates** the Clerk JWT as a third-party token
4. **Component configures** Supabase client to use Clerk session token
5. **RLS policies work** using Clerk JWT claims

## Architecture

```
┌─────────┐      ┌────────┐      ┌──────────┐
│  WeWeb  │─────▶│  Clerk │─────▶│ Supabase │
│Component│      │  Auth  │      │    DB    │
└─────────┘      └────────┘      └──────────┘
     │               │                  │
     │               ├─ JWT Token ─────▶│
     │               │                  │
     └─────────── RLS Checks ──────────┘
```

## Benefits of This Approach

✅ **No data syncing needed** - Clerk tokens work directly with Supabase  
✅ **No foreign tables** - Use Clerk's JWT claims in RLS policies  
✅ **Secure** - Tokens validated by Supabase  
✅ **Real-time** - Clerk session state updates immediately  
✅ **Scalable** - No middleware or sync services required

## Development

To serve locally:
```bash
npm run serve --port=[PORT]
```

Then go to WeWeb editor, open developer popup and add your custom element.

Before release, check build errors:
```bash
npm run build --name=sign-in
```

## Customization

### Styling

The component uses scoped SCSS. To customize:

1. Modify colors in the `<style>` section
2. Adjust spacing, fonts, and borders
3. Customize dark mode theme

### Behavior

- Modify OAuth providers in `handleOAuthSignIn()`
- Add custom validation in `handleEmailSignIn()`
- Extend with additional Clerk features (MFA, etc.)

## Troubleshooting

### "Authentication not initialized"
- Verify your Clerk publishable key is correct
- Check browser console for initialization errors

### "Failed to sign in"
- Ensure Clerk JWT contains `role` claim
- Verify Supabase third-party auth is enabled for Clerk

### OAuth redirect issues
- Check your Clerk OAuth redirect URLs
- Verify `redirectAfterSignIn` property is set correctly

## Resources

- [Supabase + Clerk Documentation](https://supabase.com/docs/guides/auth/third-party/clerk)
- [Clerk Documentation](https://clerk.com/docs)
- [shadcn/ui Design System](https://ui.shadcn.com)

## License

MIT
