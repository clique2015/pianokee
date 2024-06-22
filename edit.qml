import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.2

Item {
    id:edit_window
    anchors.fill: parent
    property string pitch_note: radioGroup.checkedButton.text == "F" ?"flat": radioGroup.checkedButton.text == "S" ? "sharp" : "none"
    Rectangle{
        id: title
        width:mainWindow.width
        height:40
        anchors.top: mainWindow.top
        gradient: "CloudyKnoxville"

        Rectangle{
            id:logo
            color:"transparent"
            width:100
            height:title.height
            anchors.right: title.right
            Image{
                id: logo_png
                anchors.fill:parent
                fillMode: Image.PreserveAspectFit
                source:"/icons/logo"+_pd.random_value()%11;
                MouseArea{
                    anchors.fill:parent
                    onClicked:{
                        mainWindow.source = "main.qml";
                    }
                }

            }
            NumberAnimation {
                id:img_slide;
              running : true;
              target : logo_png; property:"opacity"; from: 0.5; to : 1; duration : 4000
            }
        }
        Rectangle{
            id: _menu_item
            width:mainWindow.width / 2
            height:title.height
            anchors.left:title.left
            anchors.leftMargin: 10
            anchors.top:parent.top
            anchors.topMargin: 5
            color:"transparent"
            ListView{
                orientation: ListView.Horizontal
                anchors.right: parent.right
                 anchors.rightMargin: 5
                width:parent.width
                height:parent.height
                model: _menu
                spacing: 5
                delegate:
                    Image{
                        source: "icons/menu"+index
                        visible: (index == 5) ? false : true;
                        width:30
                        height:30
                        MouseArea{
                            anchors.fill:parent
                            onClicked:{
                                if (name == "new"){
                                    _pd.clear_note();
                                   mainWindow.source = "edit.qml";
                                    }
                                   if (name == "edit"){
                                      mainWindow.source = "edit.qml" ;
                                       }
                                if (name == "playlist"){
                                      mainWindow.source =  "playlist.qml" ;
                                    }
                               if (name == "generate"){
                                      mainWindow.source = "generate.qml";
                                   }
                               if (name == "help"){
                                      mainWindow.source = "help.qml" ;
                                   }
                               if(name == "add"){
                                   for (var i = 0; i <= 3; i++)  {
                                       staff_model.append({});
                                   }
                                }
                               if(name == "remove" && staff_model.count >= 4){
                                    _pd.batch_delete(staff_model.count);
                                   staff_model.remove(staff_model.count - 4, 4);
                               }
                               if (name == "download" && !_pd.check_empty()){
                                   popup.open();
                               }
                            }
                        }
                    }
            }
        }
        Rectangle{
            width:title.width - (_menu_item.width + logo.width)
            height:title.height
            anchors.left:_menu_item.right
            anchors.leftMargin: 10
            anchors.top:parent.top
            color:"transparent"
            ButtonGroup { id: radioGroup }
            Row{
                spacing:5
                RadioButton{
                    text: qsTr("F")
                    ButtonGroup.group:radioGroup
                }
                RadioButton {
                    text: qsTr("N")
                    checked: true
                    ButtonGroup.group: radioGroup
                }
                RadioButton{
                    text: qsTr("S")
                    ButtonGroup.group:radioGroup
                }
            }
        }

    }

    Rectangle {
        id:window
        width:mainWindow.width
        height: mainWindow.height - title.height
        anchors.bottom:parent.bottom

        Rectangle{
            id: musicnotes_loader
            width:50
            height:window.height
            anchors.left:window.left
            anchors.top:window.top
            gradient: "NewYork"

            ListView{
                id: musicnotes_lv
                anchors.fill: musicnotes_loader
                width:parent.width
                height:parent.height
                model:musicnotes_model
                spacing:12
                delegate:musicnotes_del
                clip:true
            }
        }
        Rectangle {
            id:mainarea
            width:window.width - musicnotes_loader.width
            height:window.height * 0.8
            anchors.left:musicnotes_loader.right
            anchors.top:window.top
            gradient:"NewYork"
            Rectangle {
                id:treble_space
                width:mainarea.width
                height:mainarea.height * (2 / 7)
                anchors.left:parent.left
                anchors.top:parent.top
                anchors.topMargin: mainarea.height / 7
                gradient:"SnowAgain"
            }
            Rectangle{
                id: bass_space
                width:mainarea.width
                height:mainarea.height * (2/7)
                anchors.left:parent.left
                anchors.bottom:parent.bottom
                anchors.bottomMargin: mainarea.height / 7
                gradient:"SnowAgain"
            }
            Image {
                id:treble
                anchors.top:parent.top
                anchors.topMargin:parent.height /6
                anchors.left:mainarea.left
                source: "/musicnotes/6.png"
                height:parent.height / 3.7
                width:parent.height / 3.7
            }
            Image {
                id:bass
                anchors.bottom:parent.bottom
                anchors.bottomMargin:parent.height /6.5
                anchors.left:mainarea.left
                source: "/musicnotes/4.png"
                height:parent.height / 4
                width:parent.height / 4
            }
            Repeater {
                model: 15
                Rectangle {
                    width:mainarea.width
                    anchors.top:mainarea.top;
                    anchors.topMargin:(mainarea.height/14)*index;
                    height: 1
                    color: index == 7 ? "blue" : "brown"
                    visible:(index == 0 || index == 14) ? false : true
                }
            }
            ListView{
                id:staff_lv
                clip:true
                width:parent.width
                height:parent.height
                spacing:mainarea.width/25
                model: staff_model
                delegate: staff_del
                orientation:Qt.Horizontal
            }
        }




        Loader{
            id: keyboard_loader
            width:mainarea.width
            height:window.height - mainarea.height
            anchors.left:musicnotes_loader.right
            anchors.top:mainarea.bottom
            source:"keyboard.qml"
        }
    }


    Popup{
        id: popup
        x: edit_window.width / 4
        y: edit_window.height / 4

        modal: true
        focus: true
        padding: 10
        Row{
            TextField{
                id:_text
                placeholderText: qsTr("Enter name")
            }
            Button {
                id:_save
                text: "save"
                visible:_text.length < 2 ? false : true
                onClicked:{
                    if(_pd.save_notes(_text.text)){
                        mainWindow.source = "playlist.qml";
                        popup.close();
                    }
                }
            }
        }
            closePolicy:popup.CloseOnPressOutsideParent
    }
    Component{
        id:staff_del
        Rectangle {
            id:staff_comp
            height:mainarea.height
            color:index % 4 != 0 ?"burlywood":"crimson"
            width: 1
            visible:index < 4 ? false : true
            MouseArea {
                anchors.fill:parent
                hoverEnabled:true
                onEntered:{
                    staff_comp.width = 8
                    if(index % 4 != 0 ){
                    staff_comp.color = "crimson"
                }}
                onExited: {
                    staff_comp.width = 1
                    if(index % 4 != 0 ){
                        staff_comp.color = "burlywood"
                }}
                onPressed: (mouse)=>
                {
                   if(radioGroup.checkedButton.text == "N")
                        {keyboard_model.setProperty(28 - Math.round((mouseY * 28) / mainarea.height),
                                                    "_color", "WinterNeva");}
                    else   if(radioGroup.checkedButton.text == "F")
                            {keyboard_model.setProperty(28 - Math.round((mouseY * 28) / mainarea.height) - 1,
                                                        "_color_min", "NewYork");}
                   else   if(radioGroup.checkedButton.text == "S")
                           {keyboard_model.setProperty(28 - Math.round((mouseY * 28) / mainarea.height),
                                                       "_color_min", "NewYork");}
                }
                onReleased: (mouse)=>
                {
                    if(radioGroup.checkedButton.text == "N")
                         {keyboard_model.setProperty(28 - Math.round((mouseY * 28) / mainarea.height),
                                                     "_color", "CloudyKnoxville");}
                     else   if(radioGroup.checkedButton.text == "F")
                             {keyboard_model.setProperty(28 - Math.round((mouseY * 28) / mainarea.height) - 1,
                                                         "_color_min", "PremiumDark");}
                    else   if(radioGroup.checkedButton.text == "S")
                            {keyboard_model.setProperty(28 - Math.round((mouseY * 28) / mainarea.height),
                                                        "_color_min", "PremiumDark");}
                }
                onClicked: (mouse)=>
                {
                    var component = Qt.createComponent("key_comp.qml");
                    var object = component.createObject(staff_comp);
                    object._minor_keys = pitch_note == "flat" ? 2 : pitch_note == "sharp" ? 1 : 0;
                    object.note =  Math.round((mouseY * 28) / mainarea.height);
                    object.y_pos = (mainarea.height * object.note) / 28;
                    object.music_note = musicnotes_lv.currentIndex

                    object._source =  "/musicnotes/ncolor/"+pitch_note+"/"+object.music_note;
                   _pd.add_note(index, Math.round((mouseY * 28) / mainarea.height),
                                musicnotes_lv.currentIndex, object._minor_keys);
                }
            }
            Component.onCompleted: {
                for (var x = 0; x < _pd.return_count(index); x++)
                 {
                    var component = Qt.createComponent("key_comp.qml");
                    var object = component.createObject(staff_comp);
                    object.y_pos = (_pd.return_value(index, x, 0) * mainarea.height)/28;
                    object._minor_keys = _pd.return_value(index, x, 2);
                    object.note =  _pd.return_value(index, x, 0);
                    object.music_note = _pd.return_value(index, x, 1);
                    var pitch_note1 = object._minor_keys  == 2 ? "flat" : pitch_note == 1 ? "sharp" : "none";
                    object._source =  "/musicnotes/ncolor/"+pitch_note1+"/"+object.music_note;
                 }
            }
        }

    }
    Component.onCompleted: {
        staff_model.clear();
        for (var i = 0; i <= _pd.return_lastkey(); i++)  {
            staff_model.append({});
        }
    }
    Component {
        id:musicnotes_del
        Image{
            fillMode: Image.PreserveAspectFit
            source:"/musicnotes/"+_color+"/"+pitch_note+"/"+index
            width:32
            height:40
            MouseArea{
                anchors.fill:parent
                onClicked:{
                    musicnotes_model.setProperty(musicnotes_lv.currentIndex, "_color", "ncolor");
                    musicnotes_model.setProperty(index, "_color", "color");
                    musicnotes_lv.currentIndex = index
                }
            }
        }
    }
    ListModel{
        id: _menu
        ListElement {name: "new"}
        ListElement {name: "edit"}
        ListElement {name: "playlist"}
        ListElement {name: "generate"}
        ListElement {name: "help"}

        ListElement {name: "space"}
        ListElement {name: "remove"}
        ListElement {name: "add"}
        ListElement {name: "download"}
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
        id:staff_model
    }
    ListModel {
        id: musicnotes_model

        ListElement {_color:"ncolor";}
        ListElement {_color:"ncolor";}
        ListElement {_color:"ncolor";}
        ListElement {_color:"ncolor";}
        ListElement {_color:"ncolor";}
        ListElement {_color:"ncolor";}
        ListElement {_color:"ncolor";}
        ListElement {_color:"ncolor";}
        ListElement {_color:"ncolor";}
        ListElement {_color:"ncolor";}
        ListElement {_color:"ncolor";}
        ListElement {_color:"ncolor";}

    }
    ListModel {
        id: keyboard_model

        ListElement {name:"c"; _color: "CloudyKnoxville";_color_min: "PremiumDark"}
        ListElement {name:"d"; _color: "CloudyKnoxville";_color_min: "PremiumDark"}
        ListElement {name:"e"; _color: "CloudyKnoxville";_color_min: "PremiumDark"}
        ListElement {name:"f"; _color: "CloudyKnoxville";_color_min: "PremiumDark"}
        ListElement {name:"g"; _color: "CloudyKnoxville";_color_min: "PremiumDark"}
        ListElement {name:"a"; _color: "CloudyKnoxville";_color_min: "PremiumDark"}
        ListElement {name:"b"; _color: "CloudyKnoxville";_color_min: "PremiumDark"}

        ListElement {name:"c"; _color: "CloudyKnoxville";_color_min: "PremiumDark"}
        ListElement {name:"d"; _color: "CloudyKnoxville";_color_min: "PremiumDark"}
        ListElement {name:"e"; _color: "CloudyKnoxville";_color_min: "PremiumDark"}
        ListElement {name:"f"; _color: "CloudyKnoxville";_color_min: "PremiumDark"}
        ListElement {name:"g"; _color: "CloudyKnoxville";_color_min: "PremiumDark"}
        ListElement {name:"a"; _color: "CloudyKnoxville";_color_min: "PremiumDark"}
        ListElement {name:"b"; _color: "CloudyKnoxville";_color_min: "PremiumDark"}

        ListElement {name:"c"; _color: "CloudyKnoxville";_color_min: "PremiumDark"}
        ListElement {name:"d"; _color: "CloudyKnoxville";_color_min: "PremiumDark"}
        ListElement {name:"e"; _color: "CloudyKnoxville";_color_min: "PremiumDark"}
        ListElement {name:"f"; _color: "CloudyKnoxville";_color_min: "PremiumDark"}
        ListElement {name:"g"; _color: "CloudyKnoxville";_color_min: "PremiumDark"}
        ListElement {name:"a"; _color: "CloudyKnoxville";_color_min: "PremiumDark"}
        ListElement {name:"b"; _color: "CloudyKnoxville";_color_min: "PremiumDark"}

        ListElement {name:"c"; _color: "CloudyKnoxville";_color_min: "PremiumDark"}
        ListElement {name:"d"; _color: "CloudyKnoxville";_color_min: "PremiumDark"}
        ListElement {name:"e"; _color: "CloudyKnoxville";_color_min: "PremiumDark"}
        ListElement {name:"f"; _color: "CloudyKnoxville";_color_min: "PremiumDark"}
        ListElement {name:"g"; _color: "CloudyKnoxville";_color_min: "PremiumDark"}
        ListElement {name:"a"; _color: "CloudyKnoxville";_color_min: "PremiumDark"}
        ListElement {name:"b"; _color: "CloudyKnoxville";_color_min: "PremiumDark"}

    }
}
