const path = require('path')
const CopyPlugin = require('copy-webpack-plugin')
const { CleanWebpackPlugin } = require('clean-webpack-plugin')

const commonConfig = {
  entry: './editor/src/index.ts',
  module: {
    rules: [
      {
        test: [/\.js$/, /\.ts$/],
        exclude: /node_modules/,
        use: ['babel-loader']
      },
      {
        test: /\.css$/i,
        use: ['style-loader', 'css-loader']
      }
    ]
  },
  plugins: [
    new CleanWebpackPlugin()
  ],
  resolve: {
    extensions: ['.ts', '.js']
  },
  mode: 'production'
}

const sailfishConfig = {
  ...commonConfig,
  output: {
    path: path.resolve(__dirname, 'harbour-seabass/qml/html'),
    // publicPath: '/usr/share/harbour-seabass/qml/html/',
    filename: 'bundle.js'
  },
  plugins: [
    ...commonConfig.plugins,
    new CopyPlugin({
      patterns: [
        {
          from: './harbour-seabass/html'
        },
        {
          from: './generic/qml',
          to: path.resolve(__dirname, 'harbour-seabass/qml/generic')
        },
        {
          from: './generic/py-backend',
          to: path.resolve(__dirname, 'harbour-seabass/qml/py-backend')
        },
        {
          from: './generic/py-libs/inotify_simple/inotify_simple.py',
          to: path.resolve(__dirname, 'harbour-seabass/qml/py-backend/inotify_simple'),
          globOptions: {
            ignore: '**/.git'
          }
        },
        {
          from: './generic/py-libs/editorconfig-core-py/editorconfig',
          to: path.resolve(__dirname, 'harbour-seabass/qml/py-backend/editorconfig'),
          globOptions: {
            ignore: '**/.git'
          }
        }
      ]
    })
  ],
  name: 'sfos'
}

const ubportsConfig = {
  ...commonConfig,
  output: {
    path: path.resolve(__dirname, 'ubports-seabass/html/dist'),
    publicPath: 'dist/',
    filename: 'bundle.js'
  },
  name: 'ubports'
}

module.exports = [sailfishConfig, ubportsConfig]
