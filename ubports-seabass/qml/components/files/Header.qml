import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Controls.Suru 2.2
import QtQuick.Layouts 1.3

import '../common' as CustomComponents

CustomComponents.ToolBar {
  property bool treeMode: false

  signal closed()
  signal fileCreationInitialized()
  signal projectCreationInitialized()
  signal reloaded()

  CustomComponents.ToolButton {
    icon: "contextual-menu"
    onClicked: menu.open()

    Menu {
      id: menu
      y: parent.height
      modal: true
      CustomComponents.MenuItem {
        icon: "add"
        text: i18n.tr("New file...")
        onTriggered: fileCreationInitialized()
      }
      CustomComponents.MenuItem {
        icon: "add"
        text: i18n.tr("New project...")
        onTriggered: projectCreationInitialized()
      }
      CustomComponents.MenuItem {
        icon: treeMode ? "select" : "select-none"
        text: i18n.tr("Tree mode")
        onTriggered: treeMode = !treeMode
      }
      CustomComponents.MenuItem {
        icon: "reload"
        text: i18n.tr("Reload")
        onTriggered: reloaded()
      }
      CustomComponents.MenuItem {
        icon: "close"
        text: i18n.tr("Close")
        onTriggered: closed()
        visible: !hasLeadingButton
      }
    }
  }
}
