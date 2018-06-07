# Aria2-static-build-128-thread

## 一鍵編譯aria2腳本

### 腳本內容

1. 自動下載最新aria2原碼
2. 自動配置編譯環境
3. 修改16線程的限制為128線程
4. 以四線程開始編譯

### 使用方法

	git clone https://github.com/king567/Aria2-static-build-128-thread.git
	cd Aria2-static-build-128-thread
	chmod +x Compiler-Aria2.sh
	sh Compiler-Aria2.sh

*注意：下載完aria2原碼後，就不要更動腳本存放位置。*