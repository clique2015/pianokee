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

    Rectangle{

        width: parent.width * 2 / 3
        clip:true
        height: parent.height
        anchors.top:title.bottom
        anchors.topMargin: 15
        color:"transparent"
        anchors.horizontalCenter: parent.horizontalCenter

        Flickable {
            contentHeight: 6000
            width: parent.width
            id: form_1
            height: parent.height

            Rectangle {
                id:_stop0
                width: parent.width
                color:"#a51d2d"
                anchors.top: parent.top
                anchors.topMargin: 2
                height: 160

                Label{
                    id:_text
                    text: "PianoKee"
                    font.family: "Helvetica"
                    color:"white"
                    font.pixelSize: 60
                    font.weight :Font.ExtraBold
                    anchors.centerIn: parent
                }
            }

            Rectangle{
                id:_stop1
                width: parent.width
                height:parent.width * 9 / 16
                anchors.top: _stop0.bottom
                anchors.topMargin: 15
            Image {
                anchors.fill: parent
                source: "icons/help0";
            }}


            Item{
                id: _stop2
                width: parent.width
                height:60
                anchors.top: _stop1.bottom
                anchors.topMargin: 15
                clip:true
                Text {
                    lineHeight : 2;text: "<b>PianoKee</b> music composer, is an all in one music creator app for creating songs on the Clef.
                        <br/>The homepage contains the menu bar(1 , 2) and a flash slide (3) shown above.
                        For contact or support : <b>ezeuko.arinze@pianokee.com.</b> "

                }}


            GridLayout {
                id: _stop3
                columns: 2
                anchors.top: _stop2.bottom
                anchors.topMargin: 10
                width: parent.width
                rowSpacing:15
                columnSpacing:15


                Rectangle{
                    width: 30
                    height:30


                Image {
                    anchors.fill: parent
                    source: "icons/menu0";
                }}
                Label {
                    lineHeight : 2;text: "<b>New:</b>  clears the music recorder and creates a blank music sheet.<br/>
                            Use the Edit button instead, if you do not want to clear the music recorder."
                }


                Rectangle{
                    width: 30
                    height:30


                Image {
                    anchors.fill: parent
                    source: "icons/menu1";
                }}
                Label {
                    lineHeight : 2;text: "<b>Edit:</b>    Opens the music sheet, and sets keys from the music recorder.<br/>
                        Select this option if you have a curently selected song in the music recorder, and
                        you want to modify it.<br/> Use the 'New' menu if you want a blank sheet."
                }



                Rectangle{
                    width: 30
                    height:30


                Image {
                    anchors.fill: parent
                    source: "icons/menu2";
                }}
                Label {
                    lineHeight : 2;text: "<b>Playlist:</b>   Opens the list of saved songs."
                }

                Rectangle{
                    width: 30
                    height:30


                Image {
                    anchors.fill: parent
                    source: "icons/menu3";
                }}
                Label {
                    lineHeight : 2;text: "<b>Wand:</b>   Use this menu to autogenerate songs."
                }

                Rectangle{
                    width: 30
                    height:30


                Image {
                    anchors.fill: parent
                    source: "icons/menu4";
                }}
                Label {
                    lineHeight : 2;text: "<b>Help:</b>   Get help to navigate the composer."
                }


                Rectangle{
                    width: 30
                    height:30


                Image {
                    anchors.fill: parent
                    source: "icons/logo5";
                }}
                Label {
                    lineHeight : 2;text: "<b>Home:</b>   Takes you to the homepage."
                }

            }



            Rectangle{
                id:_stop4
                width: parent.width
                height:parent.width * 9 / 16
                anchors.top: _stop3.bottom
                anchors.topMargin: 15
                Image {
                    anchors.fill: parent
                    source: "icons/help1";
                }
            }


            Item{
                id: _stop5
                width: parent.width
                height:300
                anchors.top: _stop4.bottom
                anchors.topMargin: 15
                Label {
                    lineHeight : 2;text: "<p><b>Clef:</b> use the 'New' or 'Edit' menu to navigate to the Clef bar.
                         The clef contains the current music sheet in the music recorder.<br/>
                        Here, you can create new songs or edit already saved songs.The clef consists of the Menu(1), the clef menu(2),
                        minor keys(3),<br/> key selector (4), keyboard (5), music sheet(6). We already discussed the menu above.The clef menu consist of the
                        add, remove and save buttons. <br/>They are used to add vertical lines to the music sheet, delete last four vertical lines in the music sheet
                           and to save a song after composing. <br/>The minor keys are used to add flats and sharp to the key selector bar. The key selector is used
                        to select a key to be placed on the clef. <br/>The keyboard can be played and it also indicates what key is being placed or removed from the clef.
                        <br/>Finally, the music sheet, keys are placed on the vertical lines.<br/> drag your mouse over the particular line and it
                         will be highlighted as shown in (7).
                       <br/> Then click on it to place the selected key at that position.
                        </p><br/> "
                }}

            GridLayout {
                id: _stop6
                columns: 2
                anchors.top: _stop5.bottom
                anchors.topMargin: 15
                width: parent.width
                rowSpacing:15
                columnSpacing:15

                Item{
                    width: 30
                    height:30


                Image {
                    anchors.fill: parent
                    source: "icons/menu7";
                }}
                Label {
                    lineHeight : 2;text: "<b>Add:</b>   To create music on the copose board, you need to place keys on the music sheet.<br/>
                            keys can only be placed on vertical lines(time signature). Use this menu to add a set of 4 new lines."
                }


                Rectangle{
                    width: 30
                    height:30


                Image {
                    anchors.fill: parent
                    source: "icons/menu6";
                }}
                Label {
                    lineHeight : 2;text: "<b>Remove:</b>   Use this menu to remove the last set of 4 vertical lines. Note that any music key on the line are likewise deleted."
                }


                Rectangle{
                    width: 30
                    height:30


                Image {
                    anchors.fill: parent
                    source: "icons/menu8";
                }}
                Label {
                    lineHeight : 2;text: "<b>Save:</b>   save the sheet. Note that you cannot save a blank sheet, and also the length of the name of the song must be more than two."
                }

            }



            Rectangle{
                id:_stop7
                width: parent.width
                height:parent.width * 9 / 16
                anchors.top: _stop6.bottom
                anchors.topMargin: 15
            Image {
                anchors.fill: parent
                source: "icons/help2";
            }}


            Item{
                id: _stop8
                width: parent.width
                height:160
                anchors.top: _stop7.bottom
                anchors.topMargin: 15
                Label {
                    lineHeight : 2;text: "<p>The playlist menu leads you to the playlist. Here list of all saved songs are displayed. It also offers the option
                        to modify each of them in a unique way.<br/> The playlist consist of the menu bar (1), paylist menu (2), keyboard (3), playlist (4).
                        We have previously discussed the keyboard and menu bar.<br/> The playlist menu is used to adjust the pitch or how fast/slow the songs will play.
                        Use the slider to adjust this frequency.<br/> The playlist contains all saved songs with options discussed below.
                        </p> "
                }}



            GridLayout {
                id: _stop9
                columns: 2
                anchors.top: _stop8.bottom
                width: parent.width
                rowSpacing:15
                columnSpacing:15

                Rectangle{
                    width: 30
                    height:30


                Image {
                    anchors.fill: parent
                    source: "icons/play0";
                }}
                Label {
                   text: "<p><b>play on keyboard:</b> This option is used to play the song falling on the keyboard. Adjust the speed before using this option.</p>"
                }


                Rectangle{
                    width: 30
                    height:30


                Image {
                    anchors.fill: parent
                    source: "icons/play1";
                }}
                Label {
                    text:  "<p><b>play on Clef:</b> This option is used to play the song on the clef. Adjust the speed before using this option.</p>"
                }


                Rectangle{
                    width: 30
                    height:30


                Image {
                    anchors.fill: parent
                    source: "icons/play2";
                }}
                Label {
                    lineHeight : 2;text: "<p><b>Edit:</b> This option clears the music recorder <br/>and loads the selected song
                            into the music recorder for editing and redirects to the Edit page.</p>"
                }


                Rectangle{
                    width: 30
                    height:30


                Image {
                    anchors.fill: parent
                    source: "icons/play3";
                }}
                Label {
                   text: "<p><b>Copy:</b> Use this menu to copy the selected song, the new copy is added at the end of the playlist.</p>"
                }


                Rectangle{
                    width: 30
                    height:30


                Image {
                    anchors.fill: parent
                    source: "icons/play4";
                }}
                Label {
                    text: "<p><b>Delete:</b> Deletes the selected song.</p>"
                }
            }



            Rectangle{
                id:_stop10
                width: parent.width
                height:parent.width * 9 / 16
                anchors.top: _stop9.bottom
                anchors.topMargin: 15
            Image {
                anchors.fill: parent
                source: "icons/help3";
            }}


            Item{
                id: _stop11
                width: parent.width
                height:200
                anchors.top: _stop10.bottom
                anchors.topMargin: 15
                Label {
                    lineHeight : 2;text: "<p>The Wand is used to autogenerate new songs. Use the form to customize the final output.<br/>
                        the CREATE button will only appear if the form is filled correctly. <br/>The DURATION is the length
                        of the music, equal to the number of vertical lines. <br/>fill the name of the song without spaces.
                        Either of the BASS or TREBLE clef or both must be selected. The minor keys are not compulsory.<br/>
                        </p> "
                }

            }


            Rectangle{
                id:_stop12
                width: parent.width
                height:parent.width * 9 / 16
                anchors.top: _stop11.bottom
                anchors.topMargin: 15
                Image {
                    anchors.fill: parent
                    source: "icons/help4";
                }
            }

            Rectangle{
                id:_stop13
                width: parent.width
                height:parent.width * 9 / 16
                anchors.top: _stop12.bottom
                anchors.topMargin: 15
                Image {
                    anchors.fill: parent
                    source: "icons/help5";
                }
            }

        }
    }
}
