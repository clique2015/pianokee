import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.2


Item {
    id:window
    anchors.fill: parent

    Rectangle {
        id: title
        width:window.width
        height:40
        anchors.top:window.top
        gradient:"SnowAgain"

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
                source:"icons/logo"+_pd.random_value()%11;
               MouseArea {
                   anchors.fill: parent
                   acceptedButtons: Qt.LeftButton | Qt.RightButton
                   onClicked: (mouse)=> {
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
            width:700
            height:title.height
            anchors.left:title.left
            anchors.leftMargin: 10
            anchors.top:parent.top
            color:"transparent"

            ListView {
                orientation: ListView.Horizontal
                anchors.right: parent.right
                 anchors.rightMargin: 10
                 anchors.top:parent.top
                 anchors.topMargin: 5
                width:parent.width
                height:parent.height
                model: _menu
                spacing: 10
                delegate:
                    Image {

                        source:(_lr.paused && index == 12) ?  "icons/menu12a" : (!_lr.paused && index == 12) ?  "icons/menu12b" : "icons/menu"+index
                        visible: (index < 5 || index > 9) ? true : false;
                        width:30
                        height:30
                    MouseArea {
                        anchors.fill: parent
                        hoverEnabled: true
                        acceptedButtons: Qt.LeftButton | Qt.RightButton
                        onClicked: (mouse)=> {
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

                                       if (name == "stop"){
                                          mainWindow.source = "playlist.qml";

                                           }
                                       if (name == "refresh"){
                               if(_pd.get_page() == "refresh")
                                 {_pd.set_page("play_clef");
                                 }else{_pd.set_page("refresh");}
                      mainWindow.source = _pd.get_page() == "refresh" ? "play_clef.qml":  "refresh.qml" ;

                                           }
                                           if(name == "play_pause") {
                                               _pause = true;
                                              if(_lr.paused && _pause)
                                              {   _pause = !_pause;
                                                   _timer.start();
                                                   _lr.paused = !_lr.paused;
                                              }
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
            ListElement {name: "shutdown"}
            ListElement {name: "remove"}
            ListElement {name: "add"}
            ListElement {name: "download"}
            ListElement {name: "pitch"}
            ListElement {name: "refresh"}
            ListElement {name: "stop"}
            ListElement {name: "play_pause"}
        }

    }

    Loader {
        id: keyboardmainWindow
        width:window.width
        height: (window.height * 0.2) - 40
        anchors.bottom:parent.bottom
        source: "keyboard.qml"
    }

              Component {
                id: staff_del

                Rectangle {
                    id:staff_comp
                    height:mainarea.height
                    color: "burlywood";
                    width: 1
                    property int _index : index
                    visible : _pd.return_count(_index) > 0 ? true : false
            Component.onCompleted: {

                for (var x = 0; x < _pd.return_count(_index); x++)
                 {
                    var component = Qt.createComponent("movingstar.qml");
                    var object = component.createObject(staff_comp);
                    object.y_pos = (_pd.return_value(_index, x, 0) * mainarea.height)/28;
                    object._minor_keys = _pd.return_value(_index, x, 2);
                    object.note =  _pd.return_value(_index, x, 0);
                    object.music_note = _pd.return_value(_index, x, 1);
                    var pitch_note = object._minor_keys  == 2 ? "flat" : object._minor_keys == 1 ? "sharp" : "none";
                    object._nsource =   "/musicnotes/ncolor/"+pitch_note+"/"+object.music_note;
                    object._source =   "/musicnotes/color/"+pitch_note+"/"+object.music_note;
                    object._index1    = index * interval_length;
                 }
            }
        }
    }


    Rectangle {
        id:mainarea
        width:parent.width
        height:window.height * 0.8
        anchors.top:title.bottom
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
        Rectangle {
            id:bass_space
            width:mainarea.width
            height:mainarea.height * (2 / 7)
            anchors.left:parent.left
            anchors.bottom:parent.bottom
            anchors.bottomMargin:mainarea.height / 7
            gradient:"SnowAgain"
        }

        Rectangle {
            id:_transform
            color:"red"
            width:2
            height:mainarea.height
            x:mainarea.width / 7
        }

        Image {
            id:treble
            anchors.top:parent.top
            anchors.topMargin:parent.height /6
            anchors.left:mainarea.left
            source: "/icons/treble.png"
            height:parent.height / 3.7
            width:parent.height / 3.7

        }
        Image {
            id:bass
            anchors.bottom:parent.bottom
            anchors.bottomMargin:parent.height /6.5
            anchors.left:mainarea.left
            source: "/icons/bass.png"
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
        Rectangle {clip:true
            id:staff
            color:"transparent"
            width:window.width
            height:mainarea.height
            anchors.top:mainarea.top


            ListView {
                id:staff_lv

                width:mtotal_length
                height:parent.height
                spacing:interval_length
                model: staff_model
                delegate: staff_del
                orientation: Qt.Horizontal
                SequentialAnimation {
                    id:_lr
                    NumberAnimation {
                        target: staff_lv; properties: "x"
                        from: staff.width; to: -mtotal_length; duration: total_duration
                    }

                    running: play_st
                }
            }
    }
}

    property int counter                   : 0
    property int count                     : 0
    property int lastKey                   : _pd.return_lastkey();
    property bool _pause                   : false
    property bool play_st                  : false
    property double  width_of_mainarea     :(staff.width * 6) / 7
    property double  interval_length       : 100
    property double  total_length          : (lastKey * interval_length) + (2 * staff.width)
    property double  mtotal_length          : total_length - staff.width
    property double  speed                 :_pd.get_speed();
    property double  total_duration        :total_length / speed
    property double  singleshot_timer      :width_of_mainarea  / speed
    property double  timer                 :(interval_length / speed)

Item {id: _timers
    Timer {id:_timer
        interval: timer; running: false; repeat: true; //triggeredOnStart :true;

        onTriggered:{
            if(_pause)
            {
                _lr.paused = true;

            }else
            {
                _lr.paused = false;
                var num3 = counter;
                var num = _pd.play(num3);

                counter++;
            }

            for(var i = 0; i < num; i++){
                if(_pd.keypad_sel0(i, num3) % 2 == 1)
                {
                    keyboard_model.setProperty((_pd.keypad_sel0(i, num3) - 1 ) / 2, "_color", "WinterNeva");
                }
                else
                {
                    keyboard_model.setProperty(_pd.keypad_sel0(i, num3) / 2, "_color_min", "NewYork");
                }
            }
            var num2 = _pd.playend(num3);
            for(i = 0; i < num2; i++){
                if(_pd.keypad0(i, num3) % 2 == 1)
                {
                    keyboard_model.setProperty((_pd.keypad0(i, num3) - 1 ) / 2, "_color", "CloudyKnoxville");
                }
                else
                {
                    keyboard_model.setProperty(_pd.keypad0(i, num3) / 2, "_color_min", "PremiumDark");
                }
            }
        }
    }
    Timer {id:_timer1
        interval: singleshot_timer; running: true; repeat: false
        onTriggered:{
            counter = 0;
            _timer.start();

        }
    }
}



Component.onCompleted: {

    staff_model.clear();
    for (var i = 0; i <= lastKey; i++)  {
        staff_model.append({});
    }
    _timer1.start();
    play_st = !play_st;


  _pd.start(singleshot_timer, timer, keyboardmainWindow, speed);

}


ListModel
{
    id: staff_model
}




    ListModel {
        id: keyboard_model

        ListElement {name:"c"; _color: "SnowAgain";_color_min: "PremiumDark"}
        ListElement {name:"d"; _color: "SnowAgain";_color_min: "PremiumDark"}
        ListElement {name:"e"; _color: "SnowAgain";_color_min: "PremiumDark"}
        ListElement {name:"f"; _color: "SnowAgain";_color_min: "PremiumDark"}
        ListElement {name:"g"; _color: "SnowAgain";_color_min: "PremiumDark"}
        ListElement {name:"a"; _color: "SnowAgain";_color_min: "PremiumDark"}
        ListElement {name:"b"; _color: "SnowAgain";_color_min: "PremiumDark"}

        ListElement {name:"c"; _color: "SnowAgain";_color_min: "PremiumDark"}
        ListElement {name:"d"; _color: "SnowAgain";_color_min: "PremiumDark"}
        ListElement {name:"e"; _color: "SnowAgain";_color_min: "PremiumDark"}
        ListElement {name:"f"; _color: "SnowAgain";_color_min: "PremiumDark"}
        ListElement {name:"g"; _color: "SnowAgain";_color_min: "PremiumDark"}
        ListElement {name:"a"; _color: "SnowAgain";_color_min: "PremiumDark"}
        ListElement {name:"b"; _color: "SnowAgain";_color_min: "PremiumDark"}

        ListElement {name:"c"; _color: "SnowAgain";_color_min: "PremiumDark"}
        ListElement {name:"d"; _color: "SnowAgain";_color_min: "PremiumDark"}
        ListElement {name:"e"; _color: "SnowAgain";_color_min: "PremiumDark"}
        ListElement {name:"f"; _color: "SnowAgain";_color_min: "PremiumDark"}
        ListElement {name:"g"; _color: "SnowAgain";_color_min: "PremiumDark"}
        ListElement {name:"a"; _color: "SnowAgain";_color_min: "PremiumDark"}
        ListElement {name:"b"; _color: "SnowAgain";_color_min: "PremiumDark"}

        ListElement {name:"c"; _color: "SnowAgain";_color_min: "PremiumDark"}
        ListElement {name:"d"; _color: "SnowAgain";_color_min: "PremiumDark"}
        ListElement {name:"e"; _color: "SnowAgain";_color_min: "PremiumDark"}
        ListElement {name:"f"; _color: "SnowAgain";_color_min: "PremiumDark"}
        ListElement {name:"g"; _color: "SnowAgain";_color_min: "PremiumDark"}
        ListElement {name:"a"; _color: "SnowAgain";_color_min: "PremiumDark"}
        ListElement {name:"b"; _color: "SnowAgain";_color_min: "PremiumDark"}

    }
}
