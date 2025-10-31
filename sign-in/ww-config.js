export default {
  editor: {
    label: {
      en: "Clerk Sign In",
    },
  },
  properties: {
    clerkPublishableKey: {
      label: {
        en: "Clerk Publishable Key",
      },
      type: "Text",
      defaultValue: "",
      section: "settings",
    },
    supabaseUrl: {
      label: {
        en: "Supabase URL",
      },
      type: "Text",
      defaultValue: "",
      section: "settings",
    },
    supabaseAnonKey: {
      label: {
        en: "Supabase Anon Key",
      },
      type: "Text",
      defaultValue: "",
      section: "settings",
    },
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
    redirectAfterSignIn: {
      label: {
        en: "Redirect After Sign In",
      },
      type: "Text",
      defaultValue: "/dashboard",
      section: "settings",
    },
  },
};
