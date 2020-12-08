import QtQuick 2.4
import QtQuick.Controls 2.2
import QtQuick.Controls.Suru 2.2
import QtQuick.Layouts 1.3
import QtQml.Models 2.2
import Qt.labs.settings 1.0

import "./components/common" as CustomComponents
import "./constants.js" as Constants

Item {
  id: newProjectPage
  property string dirName
  property bool buildContainerReady: false
  property bool hasBuildContainer: false

  signal projectCreationRequested(string dirName, var options)

  ColumnLayout {
    anchors.fill: parent
    spacing: Suru.units.gu(1)

    CustomComponents.ToolBar {
      Layout.fillWidth: true

      hasLeadingButton: true
      onLeadingAction: pageStack.pop()
      title: i18n.tr("New Project")
      subtitle: i18n.tr("Enter details:")
    }

    ScrollView {
      Layout.fillWidth: true
      Layout.fillHeight: true

      Column {
        width: newProjectPage.width
        spacing: Suru.units.gu(1)

        GridLayout {
          id: grid
          columns: 2
          columnSpacing: Suru.units.gu(1)
          anchors.left: parent.left
          anchors.leftMargin: Suru.units.gu(1)
          anchors.rightMargin: Suru.units.gu(1)

          Label {
            text: i18n.tr("Template:")
          }
          ComboBox {
            id: template
            model: ListModel {
              id: templateModel
              Component.onCompleted: {
                append({ text: "QML Only", value: 'pure-qml-cmake' })
                append({ text: "C++", value: 'main-cpp' })
                append({ text: "Python", value: 'python-cmake' })
                append({ text: "HTML", value: 'html' })
              }
            }
            textRole: "text"
            Component.onCompleted: {
              currentIndex = 0
            }
          }


          Label {
            text: i18n.tr("Title:")
          }
          TextField {
            id: title
            placeholderText: 'App Title'
          }


          Label {
            text: i18n.tr("Package name:")
          }
          TextField {
            id: appName
            placeholderText: 'appname'
          }


          Label {
            text: i18n.tr("Package namespace:")
          }
          TextField {
            id: namespace
            placeholderText: 'yourname'
          }


          Label {
            text: i18n.tr("Description:")
          }
          TextField {
            id: description
            placeholderText: i18n.tr('A short description of your app')
          }


          Label {
            text: i18n.tr("Maintainer Name:")
          }
          TextField {
            id: name
            placeholderText: 'Your Full Name'
          }


          Label {
            text: i18n.tr("Maintainer Email:")
          }
          TextField {
            id: email
            placeholderText: 'email@domain.org'
          }


          Label {
            text: i18n.tr("License:")
          }
          ComboBox {
            id: license
            model: ListModel {
              id: licenseModel
              Component.onCompleted: {
                append({ text: "GNU GPL v3", value: 'gpl3' })
                append({ text: "MIT", value: 'mit' })
                append({ text: "BSD", value: 'bsd' })
                append({ text: "ISC", value: 'isc' })
                append({ text: "Apache 2.0", value: 'apache' })
                append({ text: "Proprietary", value: 'proprietary' })
              }
            }
            Component.onCompleted: {
              currentIndex = 0
            }
            textRole: "text"
          }


          Label {
            text: i18n.tr("Copyright year:")
          }
          TextField {
            id: copyright
            placeholderText: '2020'
          }


          Label {
            text: i18n.tr("Git tag versioning:")
          }
          Switch {
            id: gitTagVersioning
          }
        }

        Row {
          anchors.left: parent.left
          anchors.right: parent.right
          anchors.leftMargin: Suru.units.gu(1)
          anchors.rightMargin: Suru.units.gu(1)

          Button {
            text: i18n.tr("Create project")
            enabled: buildContainerReady
            onClicked: {
              var args = {
                title: title.text,
                name: appName.text,
                namespace: namespace.text,
                description: description.text,
                maintainer: name.text,
                mail: email.text,
                template: templateModel.get(template.currentIndex).value,
                license: licenseModel.get(license.currentIndex).value,
                'copyright-year': copyright.text,
                'git-tag-versioning': gitTagVersioning.checked
              }
              projectCreationRequested(dirName, args)
            }
          }
        }

        Row {
          height: Suru.units.gu(1)
          width: parent.width
        }
      }
    }
  }
}
