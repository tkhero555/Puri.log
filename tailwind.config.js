module.exports = {
  content: [
    './app/views/**/*.html.erb',
    './app/helpers/**/*.rb',
    './app/assets/stylesheets/**/*.css',
    './app/javascript/**/*.js'
  ],
  theme: {
    extend: {
      gridTemplateColumns: {
        '2-minmax': 'repeat(2, minmax(24rem, 1fr))',
        '3-minmax': 'repeat(3, minmax(24rem, 1fr))',
      },
      height: {
        '192': '48rem',
        '280': '70rem',
      }
    }
  },
  plugins: [require("daisyui")],
  daisyui: {
    themes: [
      "winter"
    ],
  },
}
