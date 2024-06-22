import QtQuick 2.2
import QtQuick.Window 2.0
import QtQuick.Controls 1.1
import QtQuick.Layouts 1.1

Rectangle {
    id:edit_window
    anchors.fill: parent
     gradient:"NewYork"

    Rectangle {
        id: title
        width:edit_window.width
        height:40
        anchors.top:edit_window.top
        gradient:"CloudyKnoxville"

        Rectangle {
            id:logo
            color:"transparent"
            width:100
            height:title.height
            anchors.right: title.right
            Image {
                id:logo_png
                anchors.fill: parent
                fillMode: Image.PreserveAspectFit
                source:"/icons/logo"+_pd.random_value()%11;
               MouseArea {
                   anchors.fill: parent
                   acceptedButtons: Qt.LeftButton | Qt.RightButton
                   onClicked: (mouse)=> {
                          _pd.set_page("home");
                          mainWindow.source = "main.qml";
                   }
               }
            }
            NumberAnimation {
                id:img_slide;
              running : true;
              target : logo_png; property:"opacity"; from: 0.5; to : 1; duration : 4000 }
        }

        Rectangle {
            id:menu_item
            width:(title.width - logo.width) / 2
            height:title.height
            anchors.left:title.left
            anchors.leftMargin: 10
            anchors.top:parent.top
            anchors.topMargin: 5
            color:"transparent"

            ListView {
                orientation: ListView.Horizontal
                anchors.right: parent.right
                 anchors.rightMargin: 10
                width:parent.width
                height:parent.height
                model: _menu
                spacing: 10
                delegate:
                    Image {

                        source:"/icons/menu"+index
                        visible: (index < 5) || (_pd.get_page1() == "edit" && index < 9  && index > 5 ) ? true : false;
                        width:30
                        height:30
                    MouseArea {
                        anchors.fill: parent
                        hoverEnabled: true
                        acceptedButtons: Qt.LeftButton | Qt.RightButton
                        onClicked: (mouse)=> {
                            if (name == "new"){
                              _pd.clear_note();
                               mainWindow.source =  "edit.qml";
                                }
                                       if (name == "edit"){
                                             mainWindow.source ="edit.qml";
                                           }
                            if (name == "playlist"){
                                  mainWindow.source ="playlist.qml";
                                }
                           if (name == "generate"){
                                  mainWindow.source = "generate.qml";
                               }
                           if (name == "help"){
                                  mainWindow.source =  "help.qml" ;
                               }

                        }

                    }
                }
            }

        }
        Item {
            Timer {
                interval: 4500; running: true; repeat: true;

                onTriggered:{
                    img_slide.running = false
                    logo_png.source = "/icons/logo"+_pd.random_value()%11;
                    img_slide.running = true
                }
            }
        }

        ListModel {
            id: _menu
            ListElement {name: "new"}
            ListElement {name: "edit"}
            ListElement {name: "playlist"}
            ListElement {name: "generate"}
            ListElement {name: "help"}
        }

    }
    property int _index : _level.get(currentIndex).level;

    Rectangle{
        id: form_1
        clip:true
        width: parent.width / 3
        color:"transparent"
        height: parent.height * (3/ 4)
        anchors.top:title.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        GridLayout {
            clip:true
            columns: 2
            anchors.fill: parent
            anchors.margins: 0
            rowSpacing: 0
            columnSpacing:4

            Label {
                text: "Name"
            }
            TextField {
                id: name
               maximumLength :  400
                placeholderText: "my_song"
                Layout.fillWidth: true
            }
            Label {
                text: "Duration"
            }
            TextField {
                id: beats
                maximumLength :  400

                placeholderText: "30"
                Layout.fillWidth: true
            }

            Label {
                text: "Level"
            }

            ComboBox {
                currentIndex: 2
                model: ListModel {
                    id: _level
                    ListElement { text: "Novice"; level: 0 }
                    ListElement { text: "Beginner"; level: 1}
                    ListElement { text: "Normal"; level: 2 }
                    ListElement { text: "Professional"; level: 3}
                    ListElement { text: "Expert"; level: 4}
                }
                width: 400
                onCurrentIndexChanged:_index = _level.get(currentIndex).level;
            }/**
            Label {
                text: "time signature"
            }
            ComboBox {
                currentIndex: 2
                model: ListModel {
                    id: _level1
                    ListElement { text: "2/2"; level: 0 }
                    ListElement { text: "2/4"; level: 1}
                    ListElement { text: "3/4"; level: 2 }
                    ListElement { text: "4/4"; level: 3}
                    ListElement { text: "3/8"; level: 4}

                    ListElement { text: "4/8"; level: 5 }
                    ListElement { text: "6/8"; level: 6}
                    ListElement { text: "8/8"; level: 7 }
                    ListElement { text: "8/16"; level: 8}
                    ListElement { text: "12/16"; level: 9}
                    ListElement { text: "16/16"; level: 10}

                }
                width: 400
                onCurrentIndexChanged:_index = _level1.get(currentIndex).level;
            }**/
            Label {
                text: "Bass clef"
            }
            CheckBox {
                id: bass
            }
            Label {
                text: "Treble clef"
            }
            CheckBox {
                id: treble
            }
            Label {
                text: "Sharp"
            }
            CheckBox {
                id: sharp
            }
            Label {
                text: "Flat"
            }
            CheckBox {
                id: flat
            }

            Item {
                Layout.columnSpan: 2
                Layout.fillWidth: true
                implicitHeight: button.height

                Button {
                    id: button
                    anchors.centerIn: parent
                    text: "Create"
                    visible: name.length < 2 ||  beats.length == 0 || (bass.checked == false && treble.checked == false)? false : true
                    onClicked: {
                        if( _pd.generate(name.text, beats.text, _index, bass.checked, treble.checked, sharp.checked, flat.checked));
                         mainWindow.source = "playlist.qml";
                    }
                }
            }
        }
    }



}
