const { environment } = require('@rails/webpacker')

// Remove invalid node properties
environment.config.set('node', {
  __dirname: false,
  __filename: false,
  global: true
});

module.exports = environment
