/****************************************************************************
# Copyright (C) 2020 Olaf Japp
#
# This file is part of SHIFT.
#
#  SHIFT is free software: you can redistribute it and/or modify
#  it under the terms of the GNU General Public License as published by
#  the Free Software Foundation, either version 3 of the License, or
#  (at your option) any later version.
#
#  SHIFT is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#  GNU General Public License for more details.
#
#  You should have received a copy of the GNU General Public License
#  along with SHIFT.  If not, see <http://www.gnu.org/licenses/>.
#
****************************************************************************/

import QtQuick 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12
import QtQuick.Controls.Material 2.12
import Qt.labs.settings 1.0
import at.crowdware.backend 1.0

ApplicationWindow 
{
    id: window
    width: 360
    height: 520
    visible: true
    title: "SHIFT"

    Settings 
    {
        id: settings
        property string style: "Default"
    }

    Shortcut 
    {
        sequences: ["Esc", "Back"]
        enabled: stackView.depth > 1
        onActivated: 
        {
            stackView.pop()
            listView.currentIndex = -1
        }
    }

    Shortcut 
    {
        sequence: "Menu"
        onActivated: optionsMenu.open()
    }

    header: ToolBar 
    {
        Material.foreground: "white"

        RowLayout 
        {
            spacing: 20
            anchors.fill: parent

            ToolButton 
            {
                id: drawerButton
                visible: false
                icon.name: stackView.depth > 1 ? "back" : "drawer"
                onClicked: 
                {
                    if (stackView.depth > 1) 
                    {
                        stackView.pop()
                        listView.currentIndex = -1
                    } 
                    else 
                    {
                        drawer.open()
                    }
                }
            }

            Label 
            {
                id: titleLabel
                text: listView.currentItem ? listView.currentItem.text : "SHIFT"
                font.pixelSize: 20
                elide: Label.ElideRight
                horizontalAlignment: Qt.AlignHCenter
                verticalAlignment: Qt.AlignVCenter
                Layout.fillWidth: true
            }

            ToolButton 
            {
                icon.name: "menu"
                onClicked: optionsMenu.open()

                Menu 
                {
                    id: optionsMenu
                    x: parent.width - width
                    transformOrigin: Menu.TopRight

                    MenuItem 
                    {
                        text: "About"
                        onTriggered: aboutDialog.open()
                    }
                    MenuItem 
                    {
                        text: "Last Error"
                        onTriggered: errorDialog.open()
                    }
                }
            }
        }
    }

    Drawer 
    {
        id: drawer
        width: Math.min(window.width, window.height) / 3 * 2
        height: window.height
        interactive: stackView.depth === 1

        ListView 
        {
            id: listView

            focus: true
            currentIndex: -1
            anchors.fill: parent

            delegate: ItemDelegate 
            {
                width: parent.width
                text: model.title
                highlighted: ListView.isCurrentItem
                onClicked: 
                {
                    if (model.title != "Home")
                    {
                        listView.currentIndex = index
                        stackView.push(model.source)
                    }
                    drawer.close()
                }
            }

            model: ListModel 
            {
                ListElement { title: "Home"; source: "qrc:/gui/Home.qml" }
                ListElement { title: "Friends"; source: "qrc:/gui/Friends.qml" }
            }

            ScrollIndicator.vertical: ScrollIndicator { }
        }
    }

    StackView 
    {
        id: stackView
        anchors.fill: parent
        initialItem: Pane 
        {
            id: pane

            Image 
            {
                id: logo
                width: pane.availableWidth / 2
                height: pane.availableHeight / 2
                anchors.centerIn: parent
                anchors.verticalCenterOffset: -50
                fillMode: Image.PreserveAspectFit
                source: "images/logo.png"
            }

            Label 
            {
                text: "THANK YOU FOR BEING AN EARLY ADOPTER !"
                anchors.margins: 20
                anchors.top: logo.bottom
                anchors.left: parent.left
                anchors.right: parent.right
                horizontalAlignment: Label.AlignHCenter
                verticalAlignment: Label.AlignVCenter
                wrapMode: Label.Wrap
            }

            MouseArea
            {
                anchors.fill: parent
                onClicked:
                {
                    stackView.replace("qrc:/gui/Home.qml")
                    drawerButton.visible = true
                }
            }
        }
    }

    Dialog 
    {
        id: aboutDialog
        modal: true
        focus: true
        title: "About"
        x: (window.width - width) / 2
        y: window.height / 6
        width: Math.min(window.width, window.height) / 3 * 2
        contentHeight: aboutColumn.height

        Column 
        {
            id: aboutColumn
            spacing: 20

            Label 
            {
                width: aboutDialog.availableWidth
                text: "SHIFT CONNECTS US ALL"
                wrapMode: Label.Wrap
                font.pixelSize: 15
            }

            Label 
            {
                width: aboutDialog.availableWidth
                text: "SHIFT will be decentral and is not using a single server only."
                    + " SHIFT is anonymous, only your real friends you connect with know your account."
                    + " No registration needed."
                    + " No server means, also no censorship. No ads."
                    + " SHIFT also creates a universal basic income and can be used to show gratitude."
                wrapMode: Label.Wrap
                font.pixelSize: 15
            }
        }
    }
    
    Dialog 
    {
        id: errorDialog
        modal: true
        focus: true
        title: "Last Error"
        x: (window.width - width) / 2
        y: window.height / 6
        width: Math.min(window.width, window.height) / 3 * 2
        contentHeight: errorColumn.height

        Column 
        {
            id: errorColumn
            spacing: 20

            Label 
            {
                width: aboutDialog.availableWidth
                text: backend.lastError
                wrapMode: Label.Wrap
                font.pixelSize: 15
            }
        }
    }
}
