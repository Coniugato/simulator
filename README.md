# シミュレータパッケージの使い方
`simulator`、`assembler`、`displayer`、`test_binaries`、`utilities`からなります。
## 仕様　　　　
- `simulator`  
シミュレータです。`make`すると`sim`という名前の実行ファイルが生成されます。 
実行の様式は
```
./sim バイナリファイル
``` 
です。  
使い方は以下の表を参考にしてください。  
```
Help For Debug Console:
n           次の命令を実行
s XXX       XXXクロック後の命令まで実行
e           最後の命令まで実行
r           出力抑制して最後まで実行
j XXX       出力抑制してXXXクロック後の命令まで実行
i       出力抑制して次の命令まで実行
q           シミュレータを中断
m XXX       メモリのXXX番地の内容を表示(キャッシュ含む)
m XXX-YYY   メモリのXXX番地からYYY番地まで(YYY番地を含まない)の内容を表示(キャッシュ含む)
c dXXX      データキャッシュのインデックスXXXのラインを表示
c iXXX      命令キャッシュのインデックスXXXのラインを表示
d           キャッシュ統計を表示
```
- `assembler` 
アセンブラです。`make`すると`asm`という名前の実行ファイルが生成されます。 
実行の様式は
```
./asm アセンブリファイル名 バイナリファイル名
``` 
です。この際、同時に`バイナリファイル名.0x`という名前でバイナリを`16`進表記した文字列のファイルが生成されます。  
また、`.mid_expression`、`.mid_binary`が生成されますが、これらは中間ファイルです。後者は多分何にも使えませんが、前者はアセンブリをパースしたものなので、うまくアセンブルされないときは確認するとよいかもしれません。   
- `displayer`
バイナリの内容を説明するプログラムです。`make`すると`disp`という名前の実行ファイルが生成されます。 
実行の様式は
```
./disp バイナリファイル名
``` 
です。    
- `test_binaries`  
テストバイナリチャンネルに投げたバイナリ、アセンブリ、`0x`ファイルがすべて入っています。    
- `utilities`  
現状`linker`スクリプトが入っています。これは複数のアセンブリをまとめて一つにするスクリプトです。  
```
./linker linked.s main.s lib1.s lib2.s ... libn.s
```
のような形で、最初に出力アセンブリファイル名を、次に最初に実行する命令を含むアセンブリを、次にライブラリ関数アセンブリ群をおけばよいです。このとき、アセンブラの形式に合うように全体が調整されます。詳しくは以下のコードを見てください。`end`フラグを使うので、もしコンパイラでこのフラグを使いたい場合は適切なフラグ名に変更してください。  
```bash
if [ "$1" = "" ]
then
    echo "No target file specified." >&2
    exit 255
fi
target=$1
shift
if [ "$1" = "" ]
then
    echo "Main source file not specified." >&2
    exit 255
fi
cat $1 > $target
echo "    j end" >> $target
shift
while [ "$1" != "" ]
do
  cat $1 >> $target
  shift
done
echo "end:nop" >> $target
```
`allclean`スクリプトを追加しました。これは実行ファイルおよび`.mid...`ファイルを消します。

