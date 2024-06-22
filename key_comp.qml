import QtQuick 2.15

Image{
    id: rects
    property var note
    property var music_note
    property var y_pos
    property var _minor_keys
    property var _index
    property var _source
    source:  _source
    width: (mainarea.width/50)*1.3
    height: (mainarea.height/28)*1.3
    y:  music_note < 2 ? y_pos -  height / 2 : y_pos -  (height * 3) / 4;
    anchors.left:parent.left
    anchors.leftMargin:music_note < 6 ? -rects.width/2 : -rects.width/4

    MouseArea{
        anchors.fill:parent
        hoverEnabled: true
        onClicked:{
            _pd.remove_note(index, rects.note, rects.music_note, rects.minor_keys)
            _rem.running = true;

        }
    }
    NumberAnimation on opacity{
        id: _rem
        from:0
        to:1
        duration:1000
        running:false
        onRunningChanged:{
            if(!running){rects.destroy();}
        }
    }
}
