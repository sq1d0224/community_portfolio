const { environment } = require('@rails/webpacker')

environment.config.set('node', {
  __dirname: false,
  __filename: false,
  global: true
});

module.exports = environment
