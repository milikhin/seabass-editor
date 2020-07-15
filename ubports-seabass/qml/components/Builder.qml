
import QtQuick 2.9
import io.thp.pyotherside 1.4

import "../generic/utils.js" as QmlJs

Item {
  id: root
  property bool ready: false
  property string tabId: '__seabass2_build_output'
  property string title: 'Build output'
  property string subTitle: 'Terminal'

  signal stdout(string lines)
  signal started()
  signal completed()
  signal unhandledError(string message)

  onStarted: {
    ready = false
  }
  onCompleted: {
    ready = true
  }

  ConfirmDialog {
    id: confirmDialog
    title: i18n.tr("Creating build container")
  }

  Python {
    id: py
    Component.onCompleted: {
      addImportPath(Qt.resolvedUrl('../../py-backend'))
      importModule('build_utils', function() {
        ready = true
      })
    }
    onReceived: function(evtArgs) {
      if (evtArgs[0] !== 'stdout') {
        return
      }

      stdout(evtArgs[1])
    }
    onError: function(pyErrorMessage) {
      unhandledError(pyErrorMessage)
    }
  }

  function build(config, callback) {
    _exec('build_utils.build', [config], callback)
  }

  function _exec(fn, args, callback) {
    _ensureContainer(function(err) {
      if (err) {
        return callback(err)
      }

      started()
      py.call(fn, args, function(res) {
        completed()
        callback(res.error, res.result)
      })
    })
  }

  function _ensureContainer(callback) {
    builder._testContainer(function(err, containerExists) {
      if (err) {
        return callback(err)
      }

      if (containerExists) {
        return callback(null)
      }

      confirmDialog.show({
        text: i18n.tr("A Libertine container is going to be created in order to execute build commands. " +
          "The process might take a while, but you can continue using the Seabass " +
          "while the container is being created. " +
          "Your network connection will be used to fetch required packages."),
        onOk: callback,
        onCancel: function() {}
      })
    })
  }

  function _testContainer(callback) {
    py.call('build_utils.test_container_exists', [], function(res) {
      callback(res.error, res.result)
    })
  }
}


