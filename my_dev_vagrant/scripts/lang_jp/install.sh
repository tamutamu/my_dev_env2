#sudo apt -y install language-pack-ja

#sudo apt -y install fcitx-mozc fcitx-config-gtk

sudo update-locale LANG=ja_JP.UTF-8
sudo apt -y install language-selector-common
sudo apt -y install fcitx-config-gtk
sudo apt -y install $(check-language-support -l ja)
sudo im-config -n fcitx

sudo apt install -y fonts-roboto fonts-noto fonts-ricty-diminished


#pkill fcitx
#sed -i "s/mozc:False/mozc:True/" .config/fcitx/profile #mozcを追加にする。
#sed -i "s/^#TriggerKey=.*/TriggerKey=ZENKAKUHANKAKU/" .config/fcitx/config #変換キーを半角/全角キーに変更
#sudo pkill X