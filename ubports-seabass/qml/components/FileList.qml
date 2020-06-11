import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3

import Ubuntu.Components 1.3
import Ubuntu.Components.Themes 1.3

import Qt.labs.folderlistmodel 2.1
import "../generic/utils.js" as QmlJs
import "./files" as FilesComponents

import io.thp.pyotherside 1.4

ListView {
  id: root
  property bool isPage: false
  property bool showHidden: false
  property string homeDir
  property real rowHeight: units.gu(4.5)

  readonly property string backgroundColor: theme.palette.normal.background
  readonly property string textColor: theme.palette.normal.backgroundText

  signal closed()
  signal fileCreationInitialised(string dirPath)
  signal fileSelected(string filePath)

  model: folderModel
  header: FilesComponents.Header {
    title: i18n.tr("Files")
    subtitle: folderModel.getPrintableDirPath()
    onClosed: root.closed()
    onFileCreationInitialised: root.fileCreationInitialised(folderModel.getDirPath())
  }
  delegate: ListItem {
    visible: isVisible()
    height: isVisible() ? rowHeight : 0
    color: backgroundColor

    onClicked: {
      if (fileIsDir) {
        return folderModel.folder = filePath
      }

      fileSelected(filePath)
    }

    RowLayout {
      anchors.left: parent.left
      anchors.right: parent.right
      anchors.leftMargin: units.gu(2)
      anchors.rightMargin: units.gu(2)
      anchors.verticalCenter: parent.verticalCenter
      spacing: units.gu(1)

      Icon {
        height: parent.height
        name: fileIsDir ? 'folder-symbolic' : getIcon(fileName)
        color: textColor
      }
      Label {
        Layout.fillWidth: true
        Layout.fillHeight: true
        elide: Text.ElideRight
        text: fileName
        color: textColor
      }
    }

    function isVisible() {
      return fileName !== '.'
    }
  }

  ScrollBar.vertical: ScrollBar {}

  FolderListModel {
    id: folderModel
    rootFolder: homeDir
    folder: homeDir

    showDirsFirst: true
    showDotAndDotDot: true
    showHidden: true
    showOnlyReadable: true

    function getDirPath() {
      return folder.toString().replace('file://', '')
    }
    function getPrintableDirPath() {
      return QmlJs.getPrintableDirPath(folder.toString(), homeDir)
    }
  }
  
  Python {
    id: py
    Component.onCompleted: {
      // Print version of plugin and Python interpreter
      console.log('PyOtherSide version: ' + pluginVersion());
      console.log('Python version: ' + pythonVersion());
      
      addImportPath(Qt.resolvedUrl('.'));
      // importModule('applogic', function() {});
      console.log('after importModule');
    }
  }

  function getIcon(fileName) {
    var match = fileName.match(/\.([A-Za-z]+)$/)
    var ext = match && match[1]
    switch(ext) {
      case 'html':
        return 'text-html-symbolic'
      case 'css':
        return 'text-css-symbolic'
      case 'xml':
        return 'text-xml-symbolic'
      default:
        return 'text-x-generic-symbolic'
    }
  }
}
