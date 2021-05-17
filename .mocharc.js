const npm = process.env.npm_lifecycle_script

const config = {
  diff: true,
  extension: ['sepc.js'],
  'check-leaks': true,
  recursive: true,
  exit: true,
  package: './package.json',
  reporter: 'spec',
  slow: 75,
  timeout: 5000000,
  ui: 'bdd',
  require: './test/helpers/setup.js'
}

// Running as NPM Script || without no args
if (npm || process.argv.length < 3) {
  config.spec = './test/**/*.spec.js'
}

module.exports = config