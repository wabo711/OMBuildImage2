#
# ICOREビルド用イメージ作成 
#

# Ubuntu 18.04をベースとする
FROM ubuntu:18.04 AS builder

# タイムゾーンを日本に設定する（タイムゾーン選択回避）
RUN apt-get update && apt-get install -y tzdata
ENV TZ=Asia/Tokyo

# ビルドに必要なパッケージをインストールする
RUN dpkg --add-architecture i386 && apt-get update && apt-get install -y \
	build-essential \
	cabextract \
	dos2unix \
	g++-9 \
	gdb \
	libboost-system1.65-dev:i386 \
	libboost-filesystem1.65-dev:i386 \
	libcppunit-doc \
	libcppunit-dev:i386 \
	make \
	pkg-config \
	python \
	ruby \
	software-properties-common \
	&& add-apt-repository ppa:ubuntu-toolchain-r/test \
	&& apt update && apt install -y g++-9-multilib \
	&& apt-get clean -y \
	&& update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-9 30 \
	&& update-alternatives --install /usr/bin/g++ g++ /usr/bin/g++-9 30

# QT Framework のインストール
RUN apt-get update && apt-get install -y \
	qtcreator \
	qt5-default \
	qtbase5-dev:i386 \
	qtdeclarative5-dev \
	qtdeclarative5-dev:i386 \
	libqt4-dev:i386 \
	qtquickcontrols2-5-dev:i386 \
	qml-module-qtquick-controls2:i386 \
	qml-module-qtquick-controls:i386 \
	qml-module-qtquick-dialogs:i386 \
	&& apt-get clean -y

# mono のインストール
RUN apt-get update && apt-get install -y gnupg ca-certificates \
	&& apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 3FA7E0328081BFF6A14DA29AA6A19B38D3D831EF \
	&& echo ""deb https://download.mono-project.com/repo/ubuntu stable-bionic main"" | tee /etc/apt/sources.list.d/mono-official-stable.l \
	&& apt-get install -y \
	gtk-sharp3 \
	libcanberra-gtk-module \
	mono-complete \
	mono-vbnc \
	&& apt-get clean -y

# lib11 のインストール
RUN apt-get update && apt-get install -y \
	libx11-dev \
	x11-utils \
	&& apt-get clean -y

# パッケージのupgradeおよびキャッシュファイルの削除
RUN apt-get upgrade -y && apt-get clean -y

