import QtQuick 2.15

Rectangle {
    id:relay
    property string _text
    property int _index
    property string _color
    gradient: mainarea.y < _index ?_color: "HealthyWater"
    anchors.left:parent.left
    radius: 5
  //  anchors.leftMargin: key_note
    Text {
        text: _text
        font.family: "Helvetica"
        font.pointSize: 14
        color: "black"
        anchors.bottom:parent.bottom
        anchors.horizontalCenter:parent.horizontalCenter
    }
    MouseArea {
        anchors.fill: parent
    }


}
