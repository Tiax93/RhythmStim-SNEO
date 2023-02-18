#ifndef PROBEPLOT_H
#define PROBEPLOT_H

#include <QWidget>

class ProbePlot : public QWidget
{
    Q_OBJECT
public:
    explicit ProbePlot(QWidget *parent = nullptr);
    void run(bool run);
    void updateFiring(int ch);
    void updateStim(int ch);
    void setTimescale(int t);

signals:

public slots:

private slots:
    void draw();

protected:
    void paintEvent(QPaintEvent *event);
    void closeEvent(QCloseEvent *event);

private:
    void drawAxis();

    int width;
    int height;
    int dx;

    QPixmap pixmap;
    QPixmap cleanPixmap;
    QTimer *timer;
    int spikes[32];
    int stim[32];
};

#endif // PROBEPLOT_H
