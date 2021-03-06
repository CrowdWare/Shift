/****************************************************************************
* Copyright (C) 2021 CrowdWare
*
* This file is part of SHIFT.
*
*  SHIFT is free software: you can redistribute it and/or modify
*  it under the terms of the GNU General Public License as published by
*  the Free Software Foundation, either version 3 of the License, or
*  (at your option) any later version.
*
*  SHIFT is distributed in the hope that it will be useful,
*  but WITHOUT ANY WARRANTY; without even the implied warranty of
*  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
*  GNU General Public License for more details.
*
*  You should have received a copy of the GNU General Public License
*  along with SHIFT.  If not, see <http://www.gnu.org/licenses/>.
*
****************************************************************************/

import QtQuick 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12
import QtQuick.Controls.Material 2.12
import at.crowdware.backend 1.0
import com.lasconic 1.0

Page 
{
	id: page
	title: "HOME"

	ShareUtils 
	{
        id: shareUtils
    }

	Rectangle 
	{
    	id: display
    	height: page.height / 6
    	color: "#C0C0C0"
    	anchors.top: parent.top
    	anchors.right: parent.right
    	anchors.left: parent.left
    	anchors.margins: page.width / 10
    	Text 
		{
			font.pixelSize: page.width / 20
    		text: "Balance"
    	} 
    	Text 
		{
			id: balance
    		font.pixelSize: balancePixelSize(backend.balance)
    		text: formatBalance(backend.balance)
    		anchors.centerIn: parent
    	} 
    	Text 
		{
    		anchors.right: parent. right
    		anchors. bottom: parent.bottom
			font.pixelSize: page.width / 20
    		text: "THX"
    	} 

		Timer 
		{
			id: timer
        	interval: 1000
			running: backend.scooping == 0 ? false : true 
			repeat: true
        	onTriggered: balance.text =  formatBalance(backend.balance)
    	}
	}

	Button 
	{
        id: start
    	anchors.top: display.bottom
        font.pointSize: 20
        anchors.margins: page.width / 10
     	anchors.left: parent.left
        anchors.right: parent.right
		height: page.height / 8
        text: backend.scooping == 0 ? "Start Scooping" : "Scooping..."
		enabled: backend.scooping == 0
		Material.background: Material.Blue
		onClicked: 
		{
			timer.running = true;
			start.enabled = false;
			start.text = "Scooping...";
			backend.start();
		}
    }

	Text 
	{
		id: caption
		anchors.top: start.bottom
		anchors.left: start.left
		anchors.topMargin: page.height / 100
		text: "Latest Bookings"
	} 

	Rectangle 
	{
		id: list
		anchors.top: start.bottom
		anchors.bottom: invite.top
		anchors.bottomMargin: page.width / 20
		anchors.topMargin: page.width / 10
		anchors.leftMargin: page.width / 10
		anchors.rightMargin: page.width / 10
     	anchors.left: parent.left
        anchors.right: parent.right
	    color: "#EEEEEE"
	   	ListView 
		{
	   		clip: true
	    	anchors.fill: parent
	   		anchors.margins: page.width / 100
	   		spacing: page.width / 100
			model: backend.bookingModel
			delegate: listDelegate
	    	
	   		Component 
			{
	   			id: listDelegate

	   			Rectangle 
				{
	 				width: parent.width 
	   				height: page.height / 20
	   				Text 
					{
	   					id: date
						height: parent.height
	   					text: Qt.formatDate(model.date, "dd.MM.yyyy")
	   					font.pixelSize: page.height / 40
						verticalAlignment: Text.AlignVCenter
	   				} 
	   				Text 
					{
						height: parent.height
	   					anchors.left: date.right
	   					anchors.leftMargin: 15
	   					text: model.description
	   					font.pixelSize: page.height / 40
						verticalAlignment: Text.AlignVCenter
	 				} 
	 				Text 
					{
						height: parent.height
						anchors.right: parent.right
	 					text: model.amount + " THX"
	 					font.pixelSize: page.height / 40
						verticalAlignment: Text.AlignVCenter
	 				} 
	    		} 
	    	} 
        }
	}

	Button 
	{
        id: invite
    	anchors.bottom: parent.bottom
        font.pointSize: 20
		anchors.leftMargin: page.width / 10
		anchors.rightMargin: page.width / 10
		anchors.bottomMargin: page.width / 20
     	anchors.left: parent.left
        anchors.right: parent.right
		height: page.height / 8
        text: "Invite Friends"
		Material.background: Material.Blue
		onClicked: shareUtils.share("SHIFT is a new app to create worldwide universal basic income. Get your first THX now, by following this link http://www.shifting.site. Download the app, start it and use this id " + backend.uuid + " as invitation code.")
	}

	function formatBalance(balance)
	{
		return Number(balance / 1000.0).toLocaleString(Qt.locale("de_DE"), 'f', 3);
	}

	function balancePixelSize(balance)
	{
		var normalPixelSize = page.width / 5.5;
		var textLength = formatBalance(balance).length;
		if(textLength < 9)
			return normalPixelSize;
		else
			return normalPixelSize / (1 + (textLength - 8) * .16);	
	}
} 
