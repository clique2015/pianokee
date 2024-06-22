import QtQuick 2.15

Item {

    Rectangle {
        id:keyboard
        anchors.fill:parent

        ListView{
            anchors.fill:parent
            model:keyboard_model
            delegate:keyboard_del
            width:parent.width
            height:parent.height
            orientation: ListView.Horizontal
            clip:true
        }

        ListView{

            width:parent.width
            height:parent.height / 2
            anchors.left:parent.left
            anchors.leftMargin:parent.width / 56 + (parent.width / 28)* 0.15
            model:keyboard_model
            spacing: (parent.width / 28)* 0.2
            delegate:keyboard_minor_del
            orientation: ListView.Horizontal
            clip:true
        }
    }
    Component{
        id:keyboard_del
        Rectangle {
            width: keyboard.width / 28; height:keyboard.height
            border.width: 0.5
            gradient:_color

            Text{
                text:name
                font.pixelSize: 20
                anchors.bottom:parent.bottom
                anchors.horizontalCenter:parent.horizontalCenter
            }
            MouseArea {
                anchors.fill: parent
                onPressed: (mouse)=>
                {
                    keyboard_model.setProperty(index, "_color", "WinterNeva");
                    _pd.play_sound(1, index);
                }
                onReleased: (mouse)=>
                {
                    keyboard_model.setProperty(index, "_color", "CloudyKnoxville");
                }
            }
        }

    }
    Component{
        id:keyboard_minor_del
        Rectangle {
            visible:index == 2 || index == 6 || index == 9 || index == 13 || index == 16 || index == 20 || index == 23 ||  index == 27 ? false : true
            width: (keyboard.width / 28)* 0.8;
            height:keyboard.height
            gradient:_color_min


            MouseArea {
                anchors.fill: parent
                onPressed: (mouse)=>
                {
                    keyboard_model.setProperty(index, "_color_min", "NewYork");
                    _pd.play_sound(0, index);
                }
                onReleased: (mouse)=>
                {
                    keyboard_model.setProperty(index, "_color_min", "PremiumDark");
                }
            }
        }
    }
}
