#!/bin/bash
#編譯aria2一鍵腳本
#可以修改成128線程

######變數
aria2_version=$(wget --no-check-certificate -qO- https://api.github.com/repos/aria2/aria2/releases | grep -o '"tag_name": ".*"' |head -n 1| sed 's/"//g;s/v//g'| sed 's/tag_name: //g' | sed 's/release-//g')

######
build_libs ()
{
linux_build_libs="aria2-x86_64-gnu-linux-build-libs"
linux_config="aria2-x86_64-gnu-linux-config"

arm_rbpi_libs="aria2-arm-rbpi-gnu-linux-cross-build-libs"
arm_rbpi_tools="aria2-arm-rbpi-gnu-linux-cross-tools"
arm_rbpi_config="aria2-arm-rbpi-gnu-linux-cross-config"

windows_build_lib="aria2-x86_64-w64-mingw-build-libs"
windows_config="aria2-x86_64-w64-mingw-config"
}
initializeANSI()
{
  esc=""

  blackf="${esc}[30m";   redf="${esc}[31m";    greenf="${esc}[32m"
  yellowf="${esc}[33m"   bluef="${esc}[34m";   purplef="${esc}[35m"
  cyanf="${esc}[36m";    whitef="${esc}[37m"
  
  blackb="${esc}[40m";   redb="${esc}[41m";    greenb="${esc}[42m"
  yellowb="${esc}[43m"   blueb="${esc}[44m";   purpleb="${esc}[45m"
  cyanb="${esc}[46m";    whiteb="${esc}[47m"

  boldon="${esc}[1m";    boldoff="${esc}[22m"
  italicson="${esc}[3m"; italicsoff="${esc}[23m"
  ulon="${esc}[4m";      uloff="${esc}[24m"
  invon="${esc}[7m";     invoff="${esc}[27m"

  reset="${esc}[0m"
}
download_aria2 ()
{
	wget https://github.com/aria2/aria2/releases/download/release-${aria2_version}/aria2-${aria2_version}.tar.gz
	tar -zxvf aria2-${aria2_version}.tar.gz
	rm -rf aria2-${aria2_version}.tar.gz
}
Thread_128 ()
{
	cd aria2-${aria2_version}
	sed -i 's/"1", 1, 16/"128", 1, -1/g' ./src/OptionHandlerFactory.cc
	sed -i 's/"20M", 1_m, 1_g/"4K", 1_k, 1_g/g' ./src/OptionHandlerFactory.cc
	sed -i 's/PREF_CONNECT_TIMEOUT, TEXT_CONNECT_TIMEOUT, "60", 1, 600/PREF_CONNECT_TIMEOUT, TEXT_CONNECT_TIMEOUT, "30", 1, 600/g' ./src/OptionHandlerFactory.cc
	sed -i 's/PREF_PIECE_LENGTH, TEXT_PIECE_LENGTH, "1M", 1_m, 1_g/PREF_PIECE_LENGTH, TEXT_PIECE_LENGTH, "4k", 1_k, 1_g/g' ./src/OptionHandlerFactory.cc
	sed -i 's/new NumberOptionHandler(PREF_RETRY_WAIT, TEXT_RETRY_WAIT, "0", 0, 600/new NumberOptionHandler(PREF_RETRY_WAIT, TEXT_RETRY_WAIT, "2", 0, 600/g' ./src/OptionHandlerFactory.cc
	sed -i 's/new NumberOptionHandler(PREF_SPLIT, TEXT_SPLIT, "5", 1, -1,/new NumberOptionHandler(PREF_SPLIT, TEXT_SPLIT, "8", 1, -1,/g' ./src/OptionHandlerFactory.cc
}
set_env ()
{
echo "請選擇編譯平台"
echo "(1).Linux"
echo "(2).Arm Raspberry"
echo "(3).Windows"
read -p "請輸入選項(1-3):" platform
case ${platform} in
   1)
		echo "安裝相關依賴"
		apt-get install -y libgnutls28-dev nettle-dev libgmp-dev libssh2-1-dev libc-ares-dev libxml2-dev zlib1g-dev libsqlite3-dev pkg-config libcppunit-dev autoconf automake autotools-dev autopoint libtool git gcc g++ libxml2-dev make quilt
		apt-get install -y libcurl4-openssl-dev libevent-dev ca-certificates libssl-dev  build-essential intltool libgcrypt-dev libssl-dev 
		apt install -y python-pip
		pip install --upgrade pip
		pip install sphinx
		wget --no-check-certificate -qO- https://raw.githubusercontent.com/q3aql/aria2-static-builds/master/build-scripts/gnu-linux-config/${linux_build_libs} > ${linux_build_libs}
		chmod +x ${linux_build_libs}
		./${linux_build_libs}
		wait
		rm -rf ${linux_build_libs}
		echo -n ${greenf}"\n配置成功\n"${reset}
		echo "配置編譯環境"
		cd aria2-${aria2_version}
		wget --no-check-certificate -qO- https://raw.githubusercontent.com/q3aql/aria2-static-builds/master/build-scripts/gnu-linux-config/${linux_config} > ${linux_config}
		chmod +x ${linux_config}
		./${linux_config}
		rm -rf ${linux_config}
		echo -n ${greenf}"\n配置成功\n"${reset}
     ;;
   2)
		echo "安裝相關依賴"
		apt-get install -y gcc-arm-linux-gnueabihf g++-arm-linux-gnueabihf gcc-arm-linux-gnueabi 
		apt-get install -y libgnutls28-dev nettle-dev libgmp-dev libssh2-1-dev libc-ares-dev libxml2-dev zlib1g-dev libsqlite3-dev pkg-config libcppunit-dev autoconf automake autotools-dev autopoint libtool git gcc g++ libxml2-dev make quilt
		apt-get install -y libcurl4-openssl-dev libevent-dev ca-certificates libssl-dev  build-essential intltool libgcrypt-dev libssl-dev 
		apt install -y python-pip
		pip install --upgrade pip
		pip install sphinx
		wget --no-check-certificate -qO- https://raw.githubusercontent.com/q3aql/aria2-static-builds/master/build-scripts/gnu-linux-arm-rbpi-config/${arm_rbpi_tools} > ${arm_rbpi_tools}
		chmod +x ${arm_rbpi_tools}
		./${arm_rbpi_tools}
		wait
		rm -rf ${arm_rbpi_tools}
		wget --no-check-certificate -qO- https://raw.githubusercontent.com/q3aql/aria2-static-builds/master/build-scripts/gnu-linux-arm-rbpi-config/${arm_rbpi_libs} > ${arm_rbpi_libs} 
		chmod +x ${arm_rbpi_libs} 
		./${arm_rbpi_libs} 
		wait
		rm -rf ${arm_rbpi_libs} 
		echo -n ${greenf}"\n配置成功\n"${reset}
		echo "配置編譯環境"
		cd aria2-${aria2_version}
		wget --no-check-certificate -qO- https://raw.githubusercontent.com/q3aql/aria2-static-builds/master/build-scripts/gnu-linux-arm-rbpi-config/${arm_rbpi_config} > ${arm_rbpi_config}
		chmod +x ${arm_rbpi_config}
		./${arm_rbpi_config}
		rm -rf ${arm_rbpi_config}
		echo -n ${greenf}"\n配置成功\n"${reset}
     ;;
   3)
		echo "安裝相關依賴"
		apt-get install -y gcc-mingw-w64-x86-64 g++-mingw-w64-x86-64 libgnutls28-dev nettle-dev libgmp-dev libssh2-1-dev libc-ares-dev libxml2-dev zlib1g-dev libsqlite3-dev pkg-config libcppunit-dev autoconf automake autotools-dev autopoint libtool git gcc g++ libxml2-dev make quilt libcurl4-openssl-dev libevent-dev ca-certificates libssl-dev  build-essential intltool libgcrypt-dev libssl-dev python-pip
		pip install --upgrade pip
		pip install sphinx
		wget --no-check-certificate -qO- https://raw.githubusercontent.com/q3aql/aria2-static-builds/master/build-scripts/mingw-config/${windows_build_lib} > ${windows_build_lib}
		chmod +x ${windows_build_lib}
		./${windows_build_lib}
		wait
		rm -rf ${windows_build_lib}
		echo -n ${greenf}"\n配置成功\n"${reset}
		echo "配置編譯環境"
		cd aria2-${aria2_version}
		wget --no-check-certificate -qO- https://raw.githubusercontent.com/q3aql/aria2-static-builds/master/build-scripts/mingw-config/${windows_config} > ${windows_config}
		chmod +x ${windows_config}
		./${windows_config}
		rm -rf ${windows_config}
		echo -n ${greenf}"\n配置成功\n"${reset}
     ;;
   *)
		echo "輸入錯誤"
     ;;
esac
}
Extract_aria2 ()
{
mkdir -p ~/aria2_${aria2_version}_128thread
if [ -f "./src/aria2c" ]; then
cp ./src/aria2c  ~/aria2_${aria2_version}_128thread
strip -s ~/aria2_${aria2_version}_128thread/aria2c || arm-linux-gnueabihf-strip -s ~/aria2_${aria2_version}_128thread/aria2c
echo -n ${greenf}"\n aria2c 放置在 aria2_${aria2_version}_128thread 目錄底下\n"${reset}
elif [ -f "./src/aria2c.exe" ]; then
cp ./src/aria2c.exe  ~/aria2_${aria2_version}_128thread
strip -s ~/aria2_${aria2_version}_128thread/aria2c.exe
echo -n ${greenf}"\n aria2c.exe 放置在該使用者的home aria2_${aria2_version}_128thread 目錄底下\n"${reset}
else
echo -n ${redf}"\n檔案不存在\n"${reset}
fi
}
build_libs
initializeANSI
echo "(1).下載aria2原碼"
echo "(2).配置aria2編譯環境"
echo "(3).修改成128線程"
echo "(4).開始編譯"
read -p "請輸入選項(1-4) :" choose
case ${choose} in
   1)
		download_aria2
		echo -n ${greenf}"\n下載成功\n"${reset}
     ;;
   2)
		set_env
     ;;
   3)
		Thread_128
		echo -n ${greenf}"\n修改成功\n"${reset}
     ;;
   4)
		cd aria2-${aria2_version}
		make -j 4
		echo -n ${greenf}"\n編譯成功\n"${reset}
		Extract_aria2
     ;;
   *)
     echo "輸入錯誤選項"
     ;;
esac