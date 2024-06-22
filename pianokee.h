#ifndef PIANOKEE_H
#define PIANOKEE_H

#include <QMainWindow>
#include <QtConcurrent>
#include <QMultiMap>
#include <QSound>
#include <QTimer>
#include <QList>
#include <QSoundEffect>
#include <QDateTime>
#include <QFile>
#include <QDir>
//#include <filesystem>
#include <iostream>
#include <fstream>

QT_BEGIN_NAMESPACE
namespace Ui { class pianokee; }
QT_END_NAMESPACE

class pianokee : public QMainWindow
{
    Q_OBJECT

public:
    pianokee(QWidget *parent = nullptr);

    Q_INVOKABLE void    add_note(int index, int key, int musicnote, int minor_keys);
    Q_INVOKABLE void    batch_delete(int index);
    Q_INVOKABLE bool    check_empty();
    Q_INVOKABLE void    clear_note();
    Q_INVOKABLE QString copy_music(int index);
    Q_INVOKABLE void    delete_song(int index);
    Q_INVOKABLE bool    generate(QString name, int beats, int level, bool bass, bool treble, bool sharp, bool flat);
    Q_INVOKABLE QString get_date(int index);
    Q_INVOKABLE QString get_name(int index);
    Q_INVOKABLE int     get_playlist();
    Q_INVOKABLE double  get_speed();
    Q_INVOKABLE bool    keypad_empty();
    Q_INVOKABLE int     keypad_sel0(int index, int counter);
    Q_INVOKABLE int     keypad0(int index, int counter);
    Q_INVOKABLE bool    load_music(int index);
    Q_INVOKABLE int     play(int counter);
    Q_INVOKABLE void    play_sound(int i, int x);
    Q_INVOKABLE int     playend(int count);
    Q_INVOKABLE QString playkey(int x);
    Q_INVOKABLE double  playkey(int x, int y);
    Q_INVOKABLE int     random_value();
    Q_INVOKABLE void    remove_note(int index, int key, int musicnote, int minor_keys);
    Q_INVOKABLE int     return_count(int i);
    Q_INVOKABLE int     return_lastkey();
    Q_INVOKABLE int     return_value(int index,int i, int x);
    Q_INVOKABLE bool    save_notes(QString name);
    Q_INVOKABLE void    set_speed(double _speed);
    Q_INVOKABLE void    start(int _timer, double keyboard_height);

    void scan_directory(QDir dire);

    ~pianokee();
public slots:
    void soundPlayingChanged();
private:
    Ui::pianokee *ui;
    QMultiMap<int, QString> allnotes;
    bool scanned = false;
    double speed;
    int total_files = 0;
    QList<QString> files;

    int _timer;
    int keyb_height;
    QMultiMap<int, int> keypad;
    QMultiMap<int, int> keypad_sel;
    QList<QString> keynotes_list = {"C", "D", "E", "F", "G", "A", "B"};
    QList<int> no_minor_keys = {2,6,9,13,16,20,23,27};
};
#endif // PIANOKEE_H
