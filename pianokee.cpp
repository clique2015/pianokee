#include "pianokee.h"
#include "ui_pianokee.h"



pianokee::pianokee(QWidget *parent)
    : QMainWindow(parent)
    , ui(new Ui::pianokee)
{
    ui->setupUi(this);
}

void pianokee::soundPlayingChanged() {
    QSoundEffect *s = qobject_cast<QSoundEffect *> (sender());
    // Will also be called when playing was started, so check if really finished
    if (!s->isPlaying()) {
        s->deleteLater();

        // Do what you need to do when playing finished
    }
}
void pianokee::scan_directory(QDir dire)
{
    files.clear();
    dire.setNameFilters(QStringList("*.kl"));
    dire.setFilter(QDir::Files | QDir::NoDotAndDotDot | QDir::NoSymLinks);
    dire.setSorting(QDir::Name | QDir::IgnoreCase);
    QStringList fileList = dire.entryList();
    for(int i = 0; i < fileList.count(); i++){
        files << fileList[i];
    }
}
void pianokee::add_note(int index, int _key, int musicnote, int minor_keys)
{
    int playlist_;
    QString music_file = "";
    QString keyvalue = QString::number(_key)+","+QString::number(musicnote)+","+QString::number(minor_keys);
    if(!allnotes.contains(index, keyvalue))
    {
        allnotes.insert(index, keyvalue);
    }
    if(musicnote % 2 == 0 || musicnote == 0)
    {
        playlist_ = 2222/ pow(2,(musicnote / 2));
    }else{
        playlist_ = (2222* 1.5 ) / pow(2,  (musicnote / 2));
    }

    if(minor_keys > 1)
    {
        music_file = QString::number(_key)+"b.wav";
    }else
    if(minor_keys > 0)
    {
        music_file= QString::number(_key + 1)+"b.wav";
    }else
    {
        music_file = QString::number(_key)+".wav";
    }
    QSoundEffect *s = new QSoundEffect(this);
    connect(s, SIGNAL(playingChanged()), this, SLOT(soundPlayingChanged()));
    s->setSource(QUrl("qrc:/wav_notes/"+music_file));
    s->play();
    QTimer::singleShot(playlist_, s, SLOT(stop()));
}
void pianokee::batch_delete(int index)
{
    for(int i=index-1; i >= index- 4; i--)
    {
        allnotes.remove(i);
    }
}
bool pianokee::check_empty()
{
    return allnotes.empty();
}
void pianokee::clear_note()
{
    allnotes.clear();
}
QString pianokee::copy_music(int i)
{   QString current_date = QDateTime::currentDateTime().toString("yyyy~MM~dd~H~m~s");
    QStringList fileNames = files[i].split(".");
    QStringList fileName = fileNames[0].split("`");
    files.append(current_date+"`"+fileName[1]+".kl");
    QFile::copy("playlist/"+files[i],"playlist/"+current_date+"`"+fileName[1]+".kl");
    return current_date;

}
void pianokee::delete_song(int i)
{
    if(files.size() >= i)
    {
        QString path = "playlist/"+files.at(i);
        QFile::remove(path);
        files.removeAt(i);
    }
}
QString pianokee::get_date(int i)
{
    QStringList fileNames = files[i].split(".");
    QStringList fileName = fileNames[0].split("`");
    QStringList fileDate = fileName[0].split("~");
    return (fileDate[3]+":"+fileDate[4]+":"+fileDate[5]+" "+fileDate[2]+"."+fileDate[1]+"."+fileDate[0]);
}
QString pianokee::get_name(int i)
{
    QStringList fileNames = files[i].split(".");
    QStringList fileName  = fileNames[0].split("`");
    return fileName[1];
}
int pianokee::get_playlist()
{
    int total_files = 0;
    if(!scanned)
    {
        QString path("playlist/");
        QDir dire(path);
        if (dire.exists()){
            dire.setFilter( QDir::AllEntries | QDir::NoDotAndDotDot );
            total_files = dire.count();
            if(total_files > 0)
                scan_directory(dire);
            return total_files;
        }
        scanned = true;
    }
    return total_files;
}
double pianokee::get_speed()
{
    return speed;
}
bool pianokee::keypad_empty()
{
    return keypad.empty();
}
int pianokee::keypad_sel0(int index, int count)
{
    QList<int> value = keypad_sel.values(count);
    return value.at(index);
}
int pianokee::keypad0(int index, int count)
{
    QList<int> value = keypad.values(count);
    return value.at(index);
}
bool pianokee::load_music(int i)
{
    allnotes.clear();
    QString _key;
    QFile file("playlist/"+files[i]);
    if(file.open(QIODevice::ReadOnly|QIODevice::Text))
    {
        QTextStream in(&file);
        while(!in.atEnd())
        {
            QString line = in.readLine();
            QStringList fields = line.split(",");
            _key = fields[1]+","+fields[2]+","+fields[3];
            allnotes.insert(fields[0].toInt(), _key);
        }
    }
    file.close();
    return true;
}
int pianokee::play(int count)
{
    double playlist_ = 0;
    int _key, musicnote, key_index, temp = 0;
    QString _music;
    QList<QString> value = allnotes.values(count);
    for (int i = 0; i < value.size(); ++i)
    {
        QStringList list_values =  value.at(i).split(',');
        musicnote = (list_values.at(1)).toInt();
        _key = 27 - (list_values.at(0)).toInt();

        if(musicnote % 2 == 0 || musicnote == 0)
        {
            playlist_ = 2222/ pow(2, musicnote / 2);
        }else
        {
            playlist_ = (2222* 1.5) / pow(2, musicnote / 2);
        }

        if(list_values.last() == "1")
        {
            if(no_minor_keys.contains(_key))
            {
                key_index = ((_key+1) * 2) + 1;
            }
            else
            {
                key_index = (_key) * 2;
            }
            _music = QString::number(_key+1)+"b.wav";
        }else
        if(list_values.last() == "2")
        {
            if(no_minor_keys.contains(_key - 1))
            {
                key_index = ((_key - 1) * 2) + 1;
            }
            else
            {
                key_index = (_key - 1) * 2;
            }
            _music = QString::number(_key+1)+"b.wav";
        }else
        {
            key_index = (_key * 2) + 1;
            _music = QString::number(_key)+".wav";
        }
        keypad_sel.insert(count, key_index);
        temp = count + (playlist_ / _timer);
        keypad.insert(temp, key_index);

        QSoundEffect *s = new QSoundEffect(this);
        connect(s, SIGNAL(playingChanged()), this, SLOT(soundPlayingChanged()));
        s->setSource(QUrl("qrc:/wav_notes/"+_music));
        s->play();
        QTimer::singleShot(playlist_, s, SLOT(stop()));
    }
    return value.size();
}
void pianokee::play_sound(int i, int x)
{
    QString music_file = "";
    if(i == 0)
    {music_file = "qrc:/wav_notes/"+QString::number(x + 1)+"b.wav";}
    else
    {music_file = "qrc:/wav_notes/"+QString::number(x)+".wav";}

    QSound bells("");
    bells.play(music_file);
}
int pianokee::playend(int count)
{
    return keypad.count(count);
}
QString pianokee::playkey(int x)
{
    int z = 0;
    for (QMultiMap<int, QString>::iterator itr = allnotes.begin(); itr != allnotes.end(); itr += x) {
        if(z == x)
        {
            QStringList list =  itr.value().split(',');
            int note = (27 - list.at(0).toInt()) % 7;
            if(list.last() == "1")
            {
                return (keynotes_list.at(note) + "#");
            }else
            if(list.last() == "2"){
                return (keynotes_list.at(note) + "b");
            }else
            {
                return (keynotes_list.at(note));
            }
        }
        z += x;
    }
    return NULL;
}
double pianokee::playkey(int x, int y)
{
    if(x == 0)
    {
        return allnotes.count();
    }else
    if(x == 1)
    {
        int i = 0;
        QMultiMap<int, QString>::iterator itr;
        for (itr = allnotes.begin(); itr != allnotes.end(); itr += y) {
            if(i == y)
            {
                QStringList list =  itr.value().split(',');
                if(
                    (list.last() == "1" && (!no_minor_keys.contains(27 - list.at(0).toInt())))
                    ||
                    (list.last() == "2" && (!no_minor_keys.contains(26 - list.at(0).toInt())))
                    )
                    return 1;
                else
                    return 0;
            }
            i += y;
        }
    }else
        if(x == 2)
        {
            int i = 0;
            QMultiMap<int, QString>::iterator itr;
            for (itr = allnotes.begin(); itr != allnotes.end(); itr += y) {
                if(i == y)
                {
                    QStringList list1 =  itr.value().split(',');
                if((list1.at(1)).toInt() % 2 == 0  || (list1.at(1)).toInt() == 0){
                    return ((2222 * speed) / pow(2, (list1.at(1)).toInt() / 2));}
                    else{
                    return ((2222 * 1.5 * speed) / pow(2, (list1.at(1)).toInt() / 2));}
                }
                i += y;
            }
        }else
            if(x == 3)
    {
            int i = 0;
            int c;
            QMultiMap<int, QString>::iterator itr;
            for (itr = allnotes.begin(); itr != allnotes.end(); itr += y) {
                if(i == y)
                {
                    c = itr.key();
                    return c;
                }
                i += y;
            }
    }else
    if(x == 5)
    {
        int i = 0;
        for (QMultiMap<int, QString>::iterator itr = allnotes.begin(); itr != allnotes.end();itr += y) {
            if(i == y)
            {
                QStringList list =  itr.value().split(',');
                int index = 27 - list.at(0).toInt();
                if(list.last() == "1")
                {
                    if(no_minor_keys.contains(index))
                        return (index + 1);
                    return (index + 1 - 0.4);
                }else
                    if(list.last() == "2"){
                        if(no_minor_keys.contains(index - 1))
                            return (index - 1);
                        return (index - 0.4);
                    }else
                        return index;
            }
            i += y;
        }
    }
    return 0;
}
int pianokee::random_value()
{
    return (QRandomGenerator::global()->bounded(0,100));
}
void pianokee::remove_note(int index, int _key, int musicnote, int minor_keys)
{
    int playlist_;
    QString music_file = "";
    QString keyvalue = QString::number(_key)+","+QString::number(musicnote)+","+QString::number(minor_keys);
    if(allnotes.contains(index, keyvalue))
    {
        allnotes.remove(index, keyvalue);
    }
    if(musicnote % 2 == 0 || musicnote == 0)
    {
        playlist_ = 2222/ pow(2,(musicnote / 2));
    }else
    {
        playlist_ = (2222* 1.5 ) / pow(2,  (musicnote / 2));
    }

    if(minor_keys > 1)
    {
        music_file = QString::number(_key)+"b.wav";
    }else
        if(minor_keys > 0)
        {
            music_file= QString::number(_key + 1)+"b.wav";
        }else
        {
            music_file = QString::number(_key)+".wav";
        }
    QSoundEffect *s = new QSoundEffect(this);
    connect(s, SIGNAL(playingChanged()), this, SLOT(soundPlayingChanged()));
    s->setSource(QUrl("qrc:/wav_notes/"+music_file));
    s->play();
    QTimer::singleShot(playlist_, s, SLOT(stop()));
}
int pianokee::return_count(int i)
{
    return allnotes.count(i);
}
int pianokee::return_lastkey()
{
    if(!allnotes.empty())
    {
        return allnotes.lastKey();
    }
    return 0;
}
int pianokee::return_value(int index, int count, int val)
{
    if(allnotes.contains(index))
    {
            QList<QString> value = allnotes.values(index);
            QStringList list = value.at(count).split(',');
            if(val == 2)
                return list.last().toInt();
            else
                return list.at(val).toInt();
    }
    return 0;
}
bool pianokee::save_notes(QString name)
{
    get_playlist();
    QDir dir;
    QString new_file = "";
    QString filename = QDateTime::currentDateTime().toString("yyyy~MM~dd~H~m~s")+"`"+name;
    QString path("playlist/");
    // We create the directory if needed
    if(!dir.exists(path))
        dir.mkpath(path);
    QFile file(path + filename + ".kl");
    if(file.open(QIODevice::WriteOnly|QIODevice::Text))
    {
        QTextStream out(&file);
        QMap<int, QString>::const_iterator i = allnotes.constBegin();
        while (i != allnotes.constEnd()) {
                out<<i.key() << "," << i.value() << Qt::endl;
                ++i;
        }
        files.append(filename);
    }
    file.close();
    if(file.exists())
        return true;
    return false;
}
void pianokee::set_speed(double _speed)
{
    if(_speed > 0){
        speed = _speed;
    }
}
void pianokee::start(int timer, double keyboard_height)
{
    keyb_height = keyboard_height;
    _timer = timer;
    keypad.clear();
}
bool pianokee::generate(QString name, int beats, int level, bool bass, bool treble, bool sharp, bool flat)
{
    allnotes.clear();
    QMultiMap<int, int> temp;
    QList<int> values;
    int index = 2;
    int key = 0;
    int musicnote = 0;
    int minor_keys = 0;

    int notes = level== 0 ? beats / 6 : level == 1 ? beats / 5 : level == 2 ? beats / 4 : level == 3 ? beats / 3 : beats / 2;
    int  index_min = level== 0 ? 4 : level == 1 ? 3 : level == 2 ? 2 : level == 3 ? 1 : 0;
    int  index_max = level== 0 ? 5 : level == 1 ? 4 : level == 2 ? 3 : level == 3 ? 2 : 1;
    int key_min = treble == false ? 14 : 0;
    int key_max = bass == false ? 14 : 27;
    int min_d = level== 0 ? 0 : level == 1 ? 1 : level == 2 ? 1 : 2;
    int max_d = level== 0 ? 2 : level == 1 ? 3 : level == 2 ? 5 : level == 3 ? 6 : 11;
    int max_note = level== 0 ? 1 : level == 1 ? 2 : level == 2 ? 2 : 4;

    for(int i = 0; i <= notes; i++)
    {
        index       = (index + QRandomGenerator::global()->bounded(index_min , index_max) ) % beats;
        key         = QRandomGenerator::global()->bounded(key_min , key_max);
        musicnote   = QRandomGenerator::global()->bounded(min_d, max_d);
        minor_keys  = QRandomGenerator::global()->bounded(0, 10) < 2 ? 2 : QRandomGenerator::global()->bounded(0, 10) < 2 ? 1 : 0;
        minor_keys  = flat == false && sharp == false ? 0 :
                         flat == true  && sharp == true  ? minor_keys :
                         flat == true  && minor_keys == 2? 2:
                         sharp == true && minor_keys == 1? 1:0;                                    ;
        values.clear();
        values = temp.values(index);

        if(values.size() > max_note)
        {
                i--;
                continue;
        }
        if(!temp.contains(index, key))
        {
                temp.insert(index, key);
                add_note(index, key, musicnote, minor_keys);
        }
    }
    save_notes(name);
    temp.clear();
    return true;
}
pianokee::~pianokee()
{
    delete ui;
}

