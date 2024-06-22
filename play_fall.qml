import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.2


Rectangle {
    id:window
    clip:true
    gradient:"SolidStone"
    anchors.fill:parent

    property int counter                   : 0
    property int lastKey                   : _pd.return_lastkey();
    property bool _pause                   : false
    property double  height_of_mainarea    : main_area.height
    property double  interval_length       : 100
    property double  speed                 :_pd.get_speed();
    property double  dotted_breve_height   : speed * 3333 * 1.5
    property double  total_length          :(lastKey * interval_length) + dotted_breve_height;
    property double  total_duration        :total_length / speed
    property double  singleshot_timer      :(height_of_mainarea / speed) - timer
    property double  timer                 :(interval_length / speed)

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
                    source:(_fall.paused && index == 12) ?  "icons/menu12a" : (!_fall.paused && index == 12) ?  "icons/menu12b" : "icons/menu"+index
                    visible: (index < 5 || index > 9) ? true : false;
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
                               if (name == "stop"){
                                    mainWindow.source = "playlist.qml";
                                   }
                                   if(name == "play_pause") {
                                       _pause = true;
                                      if(_fall.paused && _pause)
                                      {    _pause = !_pause;
                                           _timer.start();
                                          _fall.paused = !_fall.paused;
                                      }
                                    }

                            }
                        }
                    }
            }
        }

    }

    Rectangle {
        id:main_area
        anchors.top:title.bottom
        clip:true
        width:window.width
        height:window.height - (title.height + keyboardmainWindow.height)
        gradient:"SolidStone"

        Rectangle {
            id:mainarea
            width:window.width
            height:main_area.height
            color:"transparent"

            SequentialAnimation {
                id:_fall
                NumberAnimation {
                    target: mainarea; properties: "y"
                    from: 0; to: total_length; duration: total_duration

                }
                running: true
            }
        }
    }

    Item{
        Timer{id: _timer
            interval: timer; running: false; repeat: true; //triggeredOnStart :true;
            onTriggered:{
                if(!_fall.paused && _pause)
                {
                    _pause = !_pause;
                    _timer.stop();
                     _fall.paused = !_fall.paused;
                }
                if (_pd.keypad_empty() && counter > lastKey)
                {
                    _pause = !_pause;
                    _timer.stop();
                     _fall.paused = !_fall.paused;
                }
                var num3 = counter;
                var num = _pd.play(num3);
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
                counter++;
            }
        }
        Timer {id:_timer1
            interval: singleshot_timer; running: false; repeat: false
            onTriggered:{
                counter = 0;
                _timer.start();
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
        ListElement {name: "space"}
        ListElement {name: "space"}
        ListElement {name: "space"}
        ListElement {name: "space"}
        ListElement {name: "space"}

        ListElement {name: "stop"}
        ListElement {name: "play_pause"}
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
        width:window.width
        height:window.height * 0.2
        anchors.bottom:parent.bottom
        source: "keyboard.qml"
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

    Component.onCompleted: {
        for (var i = 0; i < _pd.playkey(0,0); i++)  {
            var component = Qt.createComponent("falling_rect.qml");
            var object = component.createObject(mainarea);
            object.y       = -(_pd.playkey(3,i) * interval_length + (_pd.playkey(2,i)));
            object.width   = _pd.playkey(1,i) ? (main_area.width/ 28)* 0.8: main_area.width/ 28;
            object.height  = _pd.playkey(2,i) ;
            object._text   =  _pd.playkey(i);
            object._color   =  _pd.playkey(1,i) ?"DesertHump":"NewYork";
            object.anchors.leftMargin =_pd.playkey(5,i) * (main_area.width / 28);
            object._index    = (_pd.playkey(3,i) * interval_length) + main_area.height;
        }
        _timer1.start();
        _pd.start(timer, keyboardmainWindow.height);
    }
}
