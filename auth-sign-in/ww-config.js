export default {
  editor: {
    label: {
      en: "Sign In Form",
    },
  },
  properties: {
    showGithubLogin: {
      label: {
        en: "Show GitHub Login",
      },
      type: "OnOff",
      defaultValue: true,
      section: "settings",
    },
    showGoogleLogin: {
      label: {
        en: "Show Google Login",
      },
      type: "OnOff",
      defaultValue: true,
      section: "settings",
    },
  },
  triggerEvents: [
    {
      name: 'email-signin',
      label: { en: 'Email sign in' },
      event: {
        email: '',
        password: '',
        keepSignedIn: false,
      },
    },
    {
      name: 'oauth-signin',
      label: { en: 'OAuth sign in' },
      event: {
        provider: '',
      },
    },
    {
      name: 'forgot-password',
      label: { en: 'Forgot password' },
      event: {
        email: '',
      },
    },
    {
      name: 'show-signup',
      label: { en: 'Show sign up' },
      event: {},
    },
  ],
};
