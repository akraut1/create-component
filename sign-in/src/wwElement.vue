<template>
  <div class="signin-wrapper">
    <div class="signin-card">
      <!-- Header -->
      <div class="signin-header">
        <h1 class="signin-title">Sign in</h1>
        <p class="signin-description">
          Log in to your account with brrrr.com
        </p>
      </div>

      <!-- Social Logins -->
      <div class="social-buttons">
        <button
          v-if="content.showGithubLogin"
          @click="handleOAuthSignIn('github')"
          class="btn-social"
          type="button"
          :disabled="loading"
        >
          <svg class="social-icon" viewBox="0 0 24 24" fill="currentColor">
            <path d="M12 0c-6.626 0-12 5.373-12 12 0 5.302 3.438 9.8 8.207 11.387.599.111.793-.261.793-.577v-2.234c-3.338.726-4.033-1.416-4.033-1.416-.546-1.387-1.333-1.756-1.333-1.756-1.089-.745.083-.729.083-.729 1.205.084 1.839 1.237 1.839 1.237 1.07 1.834 2.807 1.304 3.492.997.107-.775.418-1.305.762-1.604-2.665-.305-5.467-1.334-5.467-5.931 0-1.311.469-2.381 1.236-3.221-.124-.303-.535-1.524.117-3.176 0 0 1.008-.322 3.301 1.23.957-.266 1.983-.399 3.003-.404 1.02.005 2.047.138 3.006.404 2.291-1.552 3.297-1.23 3.297-1.23.653 1.653.242 2.874.118 3.176.77.84 1.235 1.911 1.235 3.221 0 4.609-2.807 5.624-5.479 5.921.43.372.823 1.102.823 2.222v3.293c0 .319.192.694.801.576 4.765-1.589 8.199-6.086 8.199-11.386 0-6.627-5.373-12-12-12z"/>
          </svg>
          Sign in with GitHub
        </button>

        <button
          v-if="content.showGoogleLogin"
          @click="handleOAuthSignIn('google')"
          class="btn-social"
          type="button"
          :disabled="loading"
        >
          <svg class="social-icon" viewBox="0 0 24 24">
            <path fill="#4285F4" d="M22.56 12.25c0-.78-.07-1.53-.2-2.25H12v4.26h5.92c-.26 1.37-1.04 2.53-2.21 3.31v2.77h3.57c2.08-1.92 3.28-4.74 3.28-8.09z"/>
            <path fill="#34A853" d="M12 23c2.97 0 5.46-.98 7.28-2.66l-3.57-2.77c-.98.66-2.23 1.06-3.71 1.06-2.86 0-5.29-1.93-6.16-4.53H2.18v2.84C3.99 20.53 7.7 23 12 23z"/>
            <path fill="#FBBC05" d="M5.84 14.09c-.22-.66-.35-1.36-.35-2.09s.13-1.43.35-2.09V7.07H2.18C1.43 8.55 1 10.22 1 12s.43 3.45 1.18 4.93l2.85-2.22.81-.62z"/>
            <path fill="#EA4335" d="M12 5.38c1.62 0 3.06.56 4.21 1.64l3.15-3.15C17.45 2.09 14.97 1 12 1 7.7 1 3.99 3.47 2.18 7.07l3.66 2.84c.87-2.6 3.3-4.53 6.16-4.53z"/>
          </svg>
          Sign in with Google
        </button>
      </div>

      <!-- Divider -->
      <div class="divider">
        <span class="divider-text">OR</span>
      </div>

      <!-- Form -->
      <form @submit.prevent="handleEmailSignIn" class="signin-form">
        <div class="form-group">
          <input
            id="signin-email"
            name="email"
            v-model="email"
            type="email"
            placeholder="Email"
            class="form-input"
            required
            :disabled="loading"
            autocomplete="email"
          />
        </div>

        <div class="form-group">
          <input
            id="signin-password"
            name="password"
            v-model="password"
            type="password"
            placeholder="Password"
            class="form-input"
            required
            :disabled="loading"
            autocomplete="current-password"
          />
        </div>

        <div class="form-options">
          <label class="checkbox-wrapper">
            <input
              type="checkbox"
              v-model="keepSignedIn"
              class="checkbox-input"
            />
            <span class="checkbox-label">Keep me signed in</span>
          </label>
          <a href="#" @click.prevent="handleForgotPassword" class="forgot-link">
            Forgot password?
          </a>
        </div>

        <button type="submit" class="btn-primary" :disabled="loading">
          <span v-if="!loading">Sign in</span>
          <span v-else class="loading-spinner">Signing in...</span>
        </button>

        <div v-if="errorMessage" class="error-message">
          {{ errorMessage }}
        </div>
      </form>

      <!-- Sign Up Link -->
      <div class="signup-link">
        Don't have an account?
        <a href="#" @click.prevent="handleShowSignUp" class="link">Sign up</a>
      </div>
    </div>
  </div>
</template>

<script>
export default {
  props: {
    content: { type: Object, required: true },
  },
  data() {
    return {
      email: '',
      password: '',
      loading: false,
      errorMessage: '',
      keepSignedIn: false,
    };
  },
  methods: {
    handleEmailSignIn() {
      // Validate form
      if (!this.email || !this.password) {
        this.errorMessage = 'Please enter both email and password';
        return;
      }

      // Clear previous errors
      this.errorMessage = '';
      this.loading = true;

      // Emit event for WeWeb workflows to handle
      this.$emit('email-signin', {
        email: this.email,
        password: this.password,
        keepSignedIn: this.keepSignedIn,
      });

      // Note: Parent workflow should set loading back to false
      // For now, auto-reset after 500ms to prevent stuck state
      setTimeout(() => {
        this.loading = false;
      }, 500);
    },

    handleOAuthSignIn(provider) {
      this.errorMessage = '';
      this.loading = true;

      // Emit event for WeWeb workflows to handle
      this.$emit('oauth-signin', {
        provider: provider, // 'github' or 'google'
      });

      // Auto-reset loading state
      setTimeout(() => {
        this.loading = false;
      }, 500);
    },

    handleForgotPassword() {
      // Emit event for WeWeb workflows to handle
      this.$emit('forgot-password', {
        email: this.email,
      });
    },

    handleShowSignUp() {
      // Emit event for WeWeb workflows/navigation to handle
      this.$emit('show-signup');
    },

    // Public method that can be called from WeWeb workflows
    setError(message) {
      this.errorMessage = message;
      this.loading = false;
    },

    // Public method to clear the form
    clearForm() {
      this.email = '';
      this.password = '';
      this.errorMessage = '';
      this.loading = false;
      this.keepSignedIn = false;
    },

    // Public method to set loading state
    setLoading(isLoading) {
      this.loading = isLoading;
    },
  },
};
</script>

<style src="./styles/globals.css"></style>

<style lang="scss" scoped>
/* Using shadcn/ui CSS variables from globals.css for consistent theming */

.signin-wrapper {
  display: flex;
  align-items: center;
  justify-content: center;
  min-height: 100vh;
  padding: 1rem;
  background-color: var(--muted);
}

.signin-card {
  width: 100%;
  max-width: 22.5rem;
  padding: 1.5rem;
  background: var(--card);
  border-radius: var(--radius);
  border: 0px solid var(--border);
  box-shadow: 0 1px 3px 0 rgba(0, 0, 0, 0.1), 0 1px 2px 0 rgba(0, 0, 0, 0.06);
}

.signin-header {
  text-align: center;
  margin-bottom: 2rem;
}

.signin-title {
  font-size: 1.875rem;
  font-weight: 700;
  color: var(--card-foreground);
  margin: 0 0 0.5rem 0;
  line-height: 1.2;
}

.signin-description {
  font-size: 0.875rem;
  font-weight: 400;
  color: var(--muted-foreground);
  margin: 0;
}

.signin-form {
  margin-bottom: 1.5rem;
}

.form-group {
  margin-bottom: 1rem;
}

.form-label {
  display: block;
  font-size: 0.875rem;
  font-weight: 500;
  color: var(--card-foreground);
  margin-bottom: 0.375rem;
}

.form-options {
  display: flex;
  justify-content: flex-start;
  align-items: center;
  margin-bottom: 1.25rem;
  margin-top: 0.75rem;
  margin-left: 0;
  margin-right: 0;
  padding: 0;
  gap: 1rem;
  width: 100%;
  box-sizing: border-box;
}

.checkbox-wrapper {
  display: flex;
  align-items: center;
  gap: 0.625rem;
  cursor: pointer;
  flex-shrink: 0;
}

.checkbox-input {
  display: flex;
  width: 1rem;
  height: 1rem;
  padding: 0.0625rem;
  justify-content: center;
  align-items: center;
  border-radius: 0.25rem;
  border: 1px solid var(--base-primary, #171717);
  background: var(--base-primary, #171717);
  box-shadow: 0 1px 2px 0 rgba(0, 0, 0, 0.05);
  cursor: pointer;
  accent-color: #171717;
  flex-shrink: 0;
  margin: 0;
}

.checkbox-label {
  color: #0A0A0A;
  font-family: Geist, var(--font-font-sans, sans-serif);
  font-size: 0.875rem;
  font-style: normal;
  font-weight: 500;
  line-height: 100%;
  user-select: none;
  white-space: nowrap;
}

.forgot-link {
  display: inline-block;
  color: var(--base-muted-foreground, #737373);
  text-overflow: ellipsis;
  font-family: Geist, var(--font-font-sans, sans-serif);
  font-size: 0.875rem;
  font-style: normal;
  font-weight: 400;
  line-height: 1.25rem;
  text-decoration-line: underline;
  text-decoration-style: solid;
  text-decoration-skip-ink: none;
  text-decoration-thickness: auto;
  text-underline-offset: auto;
  text-underline-position: from-font;
  white-space: nowrap;
  flex-shrink: 0;

  &:hover {
    color: var(--foreground);
  }
}

.form-input {
  width: 100%;
  padding: 0.625rem 0.875rem;
  font-size: 0.875rem;
  background: var(--background);
  color: var(--foreground);
  border: 1px solid var(--input);
  border-radius: var(--radius);
  transition: all 0.15s;
  box-sizing: border-box;

  &:focus {
    outline: none;
    border-color: var(--ring);
    box-shadow: 0 0 0 3px oklch(from var(--ring) l c h / 0.1);
  }

  &:disabled {
    background-color: var(--muted);
    cursor: not-allowed;
    opacity: 0.6;
  }

  &::placeholder {
    color: var(--muted-foreground);
    font-weight: 400;
  }
}

.btn-primary {
  width: 100%;
  padding: 0.625rem 1rem;
  font-size: 0.875rem;
  font-weight: 500;
  color: var(--primary-foreground);
  background-color: var(--primary);
  border: none;
  border-radius: var(--radius);
  cursor: pointer;
  transition: opacity 0.15s;
  margin-top: 0.5rem;
  display: flex;
  align-items: center;
  justify-content: center;

  &:hover:not(:disabled) {
    opacity: 0.9;
  }

  &:disabled {
    opacity: 0.6;
    cursor: not-allowed;
  }
}

.loading-spinner {
  display: inline-block;
  text-align: center;
}

.error-message {
  margin-top: 0.75rem;
  padding: 0.75rem;
  font-size: 0.875rem;
  color: var(--destructive);
  background-color: oklch(from var(--destructive) l c h / 0.1);
  border: 1px solid oklch(from var(--destructive) l c h / 0.3);
  border-radius: var(--radius);
}

.divider {
  position: relative;
  text-align: center;
  margin: 1.5rem 0;

  &::before {
    content: '';
    position: absolute;
    left: 0;
    top: 50%;
    width: 100%;
    height: 1px;
    background-color: var(--border);
  }
}

.divider-text {
  position: relative;
  display: inline-block;
  padding: 0 1rem;
  font-size: 0.75rem;
  font-weight: 500;
  color: var(--muted-foreground);
  background-color: var(--card);
  text-transform: uppercase;
  letter-spacing: 0.05em;
}

.social-buttons {
  display: flex;
  flex-direction: column;
  gap: 0.75rem;
  margin-bottom: 1.5rem;
}

.btn-social {
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 0.5rem;
  width: 100%;
  padding: 0.625rem 1rem;
  font-size: 0.875rem;
  font-weight: 500;
  color: var(--card-foreground);
  background-color: var(--card);
  border: 1px solid var(--input);
  border-radius: var(--radius);
  cursor: pointer;
  transition: all 0.15s;

  &:hover:not(:disabled) {
    background-color: var(--accent);
    border-color: var(--ring);
  }

  &:disabled {
    opacity: 0.6;
    cursor: not-allowed;
  }
}

.social-icon {
  width: 1.25rem;
  height: 1.25rem;
}

.signup-link {
  text-align: center;
  font-size: 0.875rem;
  color: var(--muted-foreground);
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 0.25rem;
  white-space: nowrap;
}

.link {
  color: var(--foreground);
  text-decoration: underline;
  font-weight: 400;
  white-space: nowrap;

  &:hover {
    opacity: 0.8;
  }
}
</style>
