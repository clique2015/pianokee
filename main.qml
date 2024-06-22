import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.2


Loader{
    id:mainWindow
    width: parent.width
    height: parent.height

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
            width:mainWindow.width / 3
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
                spacing: 10
                delegate:
                    Image{
                        source: "icons/menu"+index
                        visible: (index < 5) ? true : false;
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
                            }
                        }
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
    }
    Item {
        Timer {
            interval: 4500; running: true; repeat: true;

            onTriggered:{
                img_wp.running = false
                img_slide.running = false
                _image_logo.source = "/wallpaper/a"+_pd.random_value()%35;
                logo_png.source = "/icons/logo"+_pd.random_value()%11;
                img_wp.running = true
                img_slide.running = true
            }
        }

    }

    Rectangle{
        id: _loader
        width:mainWindow.width
        height:mainWindow.height - title.height
        color:"transparent"
        anchors.bottom:parent.bottom
        Image {
            id: _image_logo
            anchors.fill: parent
            anchors.margins: 5
            source: "/wallpaper/a"+_pd.random_value()%35;
            Rectangle {
                width: _text.width + 100
                color:"#a51d2d"
                height: width * (9 / 16)
                anchors.centerIn: parent
                Text {
                    id:_text
                    text: "PianoKee"
                    font.family:"Helvetica"
                    color:"white"
                    font.pixelSize: 72
                    font.weight: Font.ExtraBold
                    anchors.centerIn: parent
                }
            }
        }
        NumberAnimation {
            id:img_wp;
          running : true;
          target : _image_logo; property:"opacity"; from: 0.5; to : 1;duration: 4000
        }
    }


}
