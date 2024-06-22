import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.2

Rectangle {
    clip:true
    gradient:"EternalConstance"
    property string _id_
    anchors.fill:parent

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
                       // visible: (index < 5 || index == 9) ? true : false;
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
        Rectangle{
            id:_slide
            color:"transparent"
            width:250
            height:parent.height
            anchors.left:_menu_item.right
            Image{
                id:slide_img
                source: "icons/menu9"
                anchors.left: parent.left
                width:30
                height:30
            }
            Slider{
                id:_slider
                anchors.right: parent.right
                from:0
                value:_pd.get_speed() * 100
                to: 100
            }
            Text {
                anchors.left: slide_img.right
                text:Math.round(_slider.position * 100)
                color: "black"
                font.pixelSize: 20
                anchors.verticalCenter: parent.verticalCenter
            }
        }
    }
    Rectangle{
        anchors.top: parent.top
        anchors.topMargin: parent.height / 5
       anchors.left:parent.left
       anchors.leftMargin:25
       width:parent.width
       height:280
       color:"transparent"

       ListView
       {id:playlist_lv
         clip:true
         orientation: ListView.Horizontal
         width:parent.width
         height:parent.height
         model:playlist_model
         spacing: 25
         delegate:playlist_del
       }

    }

    Component.onCompleted: {
        var  _get_note = _pd.get_playlist();
        for (var i = 0; i < _get_note; i++)  {
            playlist_model.append({"text_str": _pd.get_name(i), "date_str":_pd.get_date(i)});
        }
    }



    Component{
        id: playlist_del
        Rectangle {
            id: playlist_rec
            gradient:"NewYork"
            width: 150
            height: (width * 4 ) / 3 + 10
            radius: 5
            property int _index: index
                Image {
                    id: _image_logo
                    width: 140
                    height:130
                    anchors.left:parent.left
                    anchors.leftMargin: 5
                    anchors.top:parent.top
                    anchors.topMargin: 5
                    source: index == 0 ?  "wallpaper/a0" : "wallpaper/a"+index%30;
                }
                Text {
                    id:text_id
                    text:text_str
                    color: "black"
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.top:_image_logo.bottom
                    anchors.topMargin: 5
                    font.pixelSize: 14
                }
                Text {
                    id:date_id
                    text:date_str
                    color: "black"
                    anchors.top: text_id.bottom
                    anchors.topMargin:5
                    anchors.horizontalCenter: parent.horizontalCenter
                    font.pixelSize: 12
                }
                ListView {
                    id:play_lv
                    property int _index: index
                    orientation: ListView.Horizontal
                    anchors.top: date_id.bottom
                    anchors.topMargin:5
                    anchors.horizontalCenter: parent.horizontalCenter
                    width:parent.width
                    height:20
                    model: _option
                    spacing: 10
                    delegate:
                        Image
                        {
                            anchors.top: parent.top
                            width: 20; height: 20
                            source: "icons/play"+index

                           MouseArea {
                               anchors.fill: parent
                               onClicked: (mouse)=> {
                                    if (name == "delete"){
                                        _pd.delete_song(playlist_rec._index);
                                        playlist_model.remove(playlist_rec._index);
                                      }
                                    if (name == "copy"){
                                       playlist_model.append({"text_str":playlist_model.get(playlist_rec._index).text_str,
                                                                 "date_str":_pd.copy_music(playlist_rec._index)});
                                      }
                                    if(name == "edit" && _pd.load_music(playlist_rec._index)){
                                          mainWindow.source = "edit.qml";
                                      }
                                    if(name == "play" && _pd.load_music(playlist_rec._index)){
                                          _pd.set_speed(_slider.position);
                                          mainWindow.source = "play_fall.qml";
                                      }
                                      if(name == "playin" && _pd.load_music(playlist_rec._index)){
                                          _pd.set_speed(_slider.position);
                                          mainWindow.source = "play_clef.qml";
                                      }
                                }
                            }
                        }
                }
        }
    }
    ListModel{
        id:_option
        ListElement {name: "play"}
        ListElement {name: "playin"}
        ListElement {name: "edit"}
        ListElement {name: "copy"}
        ListElement {name: "delete"}

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
                img_slide.running = false
                logo_png.source = "/icons/logo"+_pd.random_value()%11;
                img_slide.running = true
            }
        }
    }
    Loader {
        id: keyboardmainWindow
        width:mainWindow.width
        height:mainWindow.height * 0.2
        anchors.bottom:parent.bottom
        source: "keyboard.qml"
    }
    ListModel {
        id: playlist_model

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
