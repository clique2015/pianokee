

import QtQuick 2.0

Image {
    id: rects
    property var note
    property var music_note
    property var y_pos
    property var _minor_keys
    property var _index1
    property var _source
    property var _nsource
    width: (mainarea.width/50)*1.3
    height: (mainarea.height/28)*1.3
    y:  music_note < 2 ? y_pos -  height / 2 : y_pos -  (height * 3) / 4;
    anchors.left:parent.left
    anchors.leftMargin:music_note < 6 ? -rects.width/2 : -rects.width/4
    source: staff_lv.x + _index1 <= mainarea.width / 7 ? _source : _nsource;
}
