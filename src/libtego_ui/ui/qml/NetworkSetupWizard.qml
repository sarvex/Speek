import QtQuick 2.2
import QtQuick.Controls 1.0
import QtQuick.Layouts 1.0

ApplicationWindow {
    id: window
    width: minimumWidth
    height: minimumHeight
    minimumWidth: 500
    maximumWidth: minimumWidth
    minimumHeight: visibleItem.height + 16
    maximumHeight: minimumHeight
    title: "Speek.Chat"

    signal networkReady
    signal closed

    onVisibleChanged: if (!visible) closed()

    property Item visibleItem: configPage.visible ? configPage : pageLoader.item

    function back() {
        if (pageLoader.visible) {
            pageLoader.visible = false
            configPage.visible = true
        } else {
            openBeginning()
        }
    }

    function openBeginning() {
        configPage.visible = false
        configPage.reset()
        pageLoader.sourceComponent = firstPage
        pageLoader.visible = true
    }

    function openConfig() {
        pageLoader.visible = false
        configPage.visible = true
    }

    function openBootstrap() {
        configPage.visible = false
        pageLoader.source = Qt.resolvedUrl("TorBootstrapStatus.qml")
        pageLoader.visible = true
    }

    Loader {
        id: pageLoader
        anchors {
            top: parent.top
            left: parent.left
            right: parent.right
            margins: 8
        }
        sourceComponent: firstPage
    }

    TorConfigurationPage {
        id: configPage
        anchors {
            top: parent.top
            left: parent.left
            right: parent.right
            margins: 8
        }
        visible: false
    }

    StartupStatusPage {
        id: statusPage
        anchors {
            top: parent.top
            left: parent.left
            right: parent.right
            margins: 8
        }
        visible: false

        onHasErrorChanged: {
            if (hasError) {
                if (visibleItem)
                    visibleItem.visible = false
                pageLoader.visible = false
                statusPage.visible = true
                visibleItem = statusPage
            }
        }
    }

    Component {
        id: firstPage

        Column {
            spacing: 8
            Image{
                source: "qrc:/icons/start.png"
                width: 150
                height: 150
                anchors.horizontalCenter: parent.horizontalCenter
            }

            Button {
                anchors.horizontalCenter: parent.horizontalCenter
                //: Label for button to connect to the Tor network
                text: qsTr("Launch Speek.Chat")
                isDefault: true
                onClicked: {
                    // Reset to defaults and proceed to bootstrap page
                    configPage.reset()
                    configPage.save()
                }
                Accessible.role: Accessible.Button
                Accessible.name: text
                Accessible.onPressAction: {
                    configPage.reset()
                    configPage.save()
                }
            }

            Rectangle {
                visible: !(Qt.platform.os == 'osx')
                height: 1
                width: parent.width
                color: palette.mid
            }

            Label {
                visible: !(Qt.platform.os == 'osx')
                width: parent.width
                //: A label with directions for when to use the 'Configure' button
                text: qsTr("This computer's Internet connection is censored, filtered, or proxied. I need to configure network settings.")
                wrapMode: Text.Wrap
                horizontalAlignment: Qt.AlignHCenter
                Accessible.role: Accessible.StaticText
                Accessible.name: text
            }

            Button {
                visible: !(Qt.platform.os == 'osx')
                anchors.horizontalCenter: parent.horizontalCenter
                //: Label for button to configure the Tor daemon beore connecting to the Tor network
                text: qsTr("Configure")
                onClicked: window.openConfig()

                Accessible.role: Accessible.Button
                Accessible.name: text
                Accessible.onPressAction: {
                    window.openConfig()
                }
            }
        }
    }

    Action {
        shortcut: StandardKey.Close
        onTriggered: window.close()
    }
}
