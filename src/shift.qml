/****************************************************************************
# Copyright (C) 2021 CrowdWare
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
import at.crowdware.backend 1.0

ApplicationWindow 
{
    id: window
    width: 360
    height: 520
    visible: true
    title: "SHIFT"

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
                ListElement { title: "Mates"; source: "qrc:/gui/Friends.qml" }
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
                width: pane.availableWidth / 3
                height: pane.availableHeight / 3
                anchors.centerIn: parent
                anchors.verticalCenterOffset: -200
                fillMode: Image.PreserveAspectFit
                source: "images/logo.png"

                MouseArea
                {
                    enabled: backend.uuid != ""
                    anchors.fill: parent
                    onClicked:
                    {
                        stackView.replace("qrc:/gui/Home.qml")
                        drawerButton.visible = true
                    }
                }
            }

            Text 
            {
                id: label
                text: backend.message
                textFormat: Text.RichText
                anchors.margins: 0
                anchors.top: logo.bottom
                anchors.left: parent.left
                anchors.right: parent.right
                horizontalAlignment: Label.AlignHCenter
                verticalAlignment: Label.AlignVCenter
                wrapMode: Label.Wrap
                onLinkActivated: Qt.openUrlExternally(link)
            }

            TextField 
            {
                id: name
                anchors.margins: 10
                font.pointSize: 20
                visible: backend.uuid == ""
                anchors.top: label.bottom
                anchors.left: parent.left
                anchors.right: parent.right
                placeholderText: "enter your name or nickname"
            }
            
            Label 
            {
                id: labelRuuid
                text: "Enter the referer id"
                visible: backend.uuid == ""
                anchors.margins: 10
                anchors.top: name.bottom
                anchors.left: parent.left
                anchors.right: parent.right
                horizontalAlignment: Label.AlignHCenter
                verticalAlignment: Label.AlignVCenter
                wrapMode: Label.Wrap
            }

            TextField 
            {
                id: ruuid
                anchors.margins: 10
                font.pointSize: 20
                visible: backend.uuid == ""
                anchors.top: labelRuuid.bottom
                anchors.left: parent.left
                anchors.right: parent.right
                placeholderText: "enter the referer id"
            }

            Label 
            {
                id: labelCountry
                text: "Select your country"
                visible: backend.uuid == ""
                anchors.margins: 10
                anchors.top: ruuid.bottom
                anchors.left: parent.left
                anchors.right: parent.right
                horizontalAlignment: Label.AlignHCenter
                verticalAlignment: Label.AlignVCenter
                wrapMode: Label.Wrap
            }
            ComboBox 
            {
                id: country
                width: 200
                visible: backend.uuid == ""
                anchors.top: labelCountry.bottom
                anchors.left: parent.left
                anchors.right: parent.right
                model: ['',
                    'Afghanistan',
                    'Albania',
                    'Algeria',
                    'Andorra',
                    'Angola',
                    'Antigua & Deps',
                    'Argentina',
                    'Armenia',
                    'Australia',
                    'Austria',
                    'Azerbaijan',
                    'Bahamas',
                    'Bahrain',
                    'Bangladesh',
                    'Barbados',
                    'Belarus',
                    'Belgium',
                    'Belize',
                    'Benin',
                    'Bhutan',
                    'Bolivia',
                    'Bosnia Herzegovina',
                    'Botswana',
                    'Brazil',
                    'Brunei',
                    'Bulgaria',
                    'Burkina',
                    'Burundi',
                    'Cambodia',
                    'Cameroon',
                    'Canada',
                    'Cape Verde',
                    'Central African Rep',
                    'Chad',
                    'Chile',
                    'China',
                    'Colombia',
                    'Comoros',
                    'Congo',
                    'Costa Rica',
                    'Croatia',
                    'Cuba',
                    'Cyprus',
                    'Czech Republic',
                    'Denmark',
                    'Djibouti',
                    'Dominica',
                    'Dominican Republic',
                    'East Timor',
                    'Ecuador',
                    'Egypt',
                    'El Salvador',
                    'Equatorial Guinea',
                    'Eritrea',
                    'Estonia',
                    'Ethiopia',
                    'Fiji',
                    'Finland',
                    'France',
                    'Gabon',
                    'Gambia',
                    'Georgia',
                    'Germany',
                    'Ghana',
                    'Greece',
                    'Grenada',
                    'Guatemala',
                    'Guinea',
                    'Guinea-Bissau',
                    'Guyana',
                    'Haiti',
                    'Honduras',
                    'Hungary',
                    'Iceland',
                    'India',
                    'Indonesia',
                    'Iran',
                    'Iraq',
                    'Ireland',
                    'Israel',
                    'Italy',
                    'Ivory Coast',
                    'Jamaica',
                    'Japan',
                    'Jordan',
                    'Kazakhstan',
                    'Kenya',
                    'Kiribati',
                    'Korea North',
                    'Korea South',
                    'Kosovo',
                    'Kuwait',
                    'Kyrgyzstan',
                    'Laos',
                    'Latvia',
                    'Lebanon',
                    'Lesotho',
                    'Liberia',
                    'Libya',
                    'Liechtenstein',
                    'Lithuania',
                    'Luxembourg',
                    'Macedonia',
                    'Madagascar',
                    'Malawi',
                    'Malaysia',
                    'Maldives',
                    'Mali',
                    'Malta',
                    'Marshall Islands',
                    'Mauritania',
                    'Mauritius',
                    'Mexico',
                    'Micronesia',
                    'Moldova',
                    'Monaco',
                    'Mongolia',
                    'Montenegro',
                    'Morocco',
                    'Mozambique',
                    'Myanmar',
                    'Namibia',
                    'Nauru',
                    'Nepal',
                    'Netherlands',
                    'New Zealand',
                    'Nicaragua',
                    'Niger',
                    'Nigeria',
                    'Norway',
                    'Oman',
                    'Pakistan',
                    'Palau',
                    'Panama',
                    'Papua New Guinea',
                    'Paraguay',
                    'Peru',
                    'Philippines',
                    'Poland',
                    'Portugal',
                    'Qatar',
                    'Romania',
                    'Russian Federation',
                    'Rwanda',
                    'St Kitts & Nevis',
                    'St Lucia',
                    'Saint Vincent & the Grenadines',
                    'Samoa',
                    'San Marino',
                    'Sao Tome & Principe',
                    'Saudi Arabia',
                    'Senegal',
                    'Serbia',
                    'Seychelles',
                    'Sierra Leone',
                    'Singapore',
                    'Slovakia',
                    'Slovenia',
                    'Solomon Islands',
                    'Somalia',
                    'South Africa',
                    'South Sudan',
                    'Spain',
                    'Sri Lanka',
                    'Sudan',
                    'Suriname',
                    'Swaziland',
                    'Sweden',
                    'Switzerland',
                    'Syria',
                    'Taiwan',
                    'Tajikistan',
                    'Tanzania',
                    'Thailand',
                    'Togo',
                    'Tonga',
                    'Trinidad & Tobago',
                    'Tunisia',
                    'Turkey',
                    'Turkmenistan',
                    'Tuvalu',
                    'Uganda',
                    'Ukraine',
                    'United Arab Emirates',
                    'United Kingdom',
                    'United States',
                    'Uruguay',
                    'Uzbekistan',
                    'Vanuatu',
                    'Vatican City',
                    'Venezuela',
                    'Vietnam',
                    'Yemen',
                    'Zambia',
                    'Zimbabwe'
                ] 
            }

            Label 
            {
                id: labelLanguage
                text: "Select preferred language"
                visible: backend.uuid == ""
                anchors.margins: 10
                anchors.top: country.bottom
                anchors.left: parent.left
                anchors.right: parent.right
                horizontalAlignment: Label.AlignHCenter
                verticalAlignment: Label.AlignVCenter
                wrapMode: Label.Wrap
            }

            ComboBox 
            {
                id: language
                width: 200
                visible: backend.uuid == ""
                anchors.top: labelLanguage.bottom
                anchors.left: parent.left
                anchors.right: parent.right
                model: ['', 'English', 'Deutsch', 'Español', 'Português']
            }

            Button
            {
                visible: backend.uuid == ""
                enabled: (ruuid.text != "" && name.text != "" && country.currentText != "" && language.currentText != "")
                anchors.top: language.bottom
                font.pointSize: 20
                anchors.margins: 10
     	        anchors.left: parent.left
                anchors.right: parent.right
		        height: 50
                text: "Create Account"
                Material.background: Material.Blue
		        onClicked: backend.createAccount(name.text, ruuid.text, country.currentText, language.currentText);
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
                text: "SHIFT will be decentral and is not running on servers."
                    + " Your SHIFT account is anonymous, only your real friends know who is behind your account."
                    + " No registration needed."
                    + " No server means, also no censorship. No ads."
                    + " SHIFT also creates a universal basic income and can be used to show gratitude to other members."
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
        title: "Last Errors"
        x: (window.width - width) / 2
        y: window.height / 6
        width: Math.min(window.width, window.height) / 3 * 2
        contentHeight: Math.min(window.width, window.height) / 3 * 2

        ScrollView 
        {
            width: parent.width
            anchors.fill: parent
            clip: true
            
            Text
            {
                anchors.fill: parent
                text: backend.lastError
                font.pixelSize: 15
                wrapMode: Text.Wrap
            }
        }
    }
}