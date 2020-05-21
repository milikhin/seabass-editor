const path = require('path')
const CopyPlugin = require('copy-webpack-plugin')

const commonConfig = {
  entry: './editor/src/index.js',
  module: {
    rules: [
      {
        test: /\.js$/,
        exclude: /node_modules/,
        use: ['babel-loader']
      },
      {
        test: /\.css$/i,
        use: ['style-loader', 'css-loader']
      }
    ]
  },
  mode: 'production',
  plugins: [
    new CopyPlugin([
      {
        from: './harbour-seabass/html'
      }
    ])
  ]
}

const sailfishConfig = {
  ...commonConfig,
  output: {
    path: path.resolve(__dirname, 'harbour-seabass/qml/html'),
    filename: 'bundle.js'
  },
  plugins: [
    new CopyPlugin([
      {
        from: './harbour-seabass/html'
      }
    ])
  ]
}

const ubportsConfig = {
  ...commonConfig,
  output: {
    path: path.resolve(__dirname, 'ubports-seabass/qml/html'),
    filename: 'bundle.js'
  },
  plugins: [
    new CopyPlugin([
      {
        from: './ubports-seabass/html'
      }
    ])
  ]
}

module.exports = [sailfishConfig, ubportsConfig]
