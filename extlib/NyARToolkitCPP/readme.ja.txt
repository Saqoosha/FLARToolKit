ARToolkit C++ class library NyARToolkitCPP.
Copyright (C)2008-2009 R.Iizuka

version 2.4.0

http://nyatla.jp/
airmail(at)ebony.plala.or.jp
--------------------------------------------------


・NyARToolkitCPP

NyARToolkitCPPは、NyARToolkit for Java 2.4系をベースにした、C++
によるNyARToolkit互換のクラスライブラリです。

処理性能は、オリジナルARToolKit比で、約400%程度高速です。
NyARToolkitと同様に、検出数が多くなるほど高速になります。


※現在は計算用クラスのみの実装となっています。
　カメラ入力・3D出力部のコードはまだ実装されていません。

※マーカ検出クラスは、SingleMarkerDetectorのみ（単一マーカ検出クラス）
　が使用可能です。MarkerDetector（複数マーカ検出クラス）は未実装です。

※サンプルプログラムには、BGRA静止画からマーカ検出
　処理を行い、その処理時間を計測するRawTestのみがあります。




ARToolkitは加藤博一先生とHuman Interface Technology Labにより
開発されたAugmented Reality (AR) ライブラリです。
詳しくはこちらをご覧下さい。
http://www.hitl.washington.edu/artoolkit/

NyARToolkitはARToolkit 2.72.1をベースに開発された、ARToolKit互換の
演算結果を持つ、Javaクラスライブラリです。
詳しくはこちらをご覧下さい。
http://nyatla.jp/nyartoolkit/


・動作/開発環境

forWindows
 Visual Stadio 2008　Express Editionのコンパイル環境があります。

forLinux
 gccでコンパイルできるmakefileがあります。

forAlchemy
 Adobe alchemy用のswcを作成するmakefileがあります。
 コンパイル方法は、NyARToolkitAS3以下にあるhow_to_compile.txtを見てください。

 
・ディレクトリ構成

./data
  マーカーファイル/カメラ設定ファイルがあります。

./forLinux
　Linux/cygwin向けのmakefileがあります。

./forWindows
　Win32向けの、VisualStadio2008用solutionファイルがあります。

./forAlchemy
　Adobe alchemy向けのmakefile、ActionScriptバインドクラスがあります。

./inc
　NyARToolkitCPPのIncludeファイルがあります。

./src
　NyARToolkitCPPのソースファイルがあります。

./extlib
　外部ライブラリを置く予定地です。



・・モジュール構成

現在は、マーカー検出・座標変換を行う計算クラス群のみの実装です。
DirectX、OpenGLとの接続クラス、カメラ画像のキャプチャクラスは
別途実装する必要があります。

ARToolKitと置換するときには、ARToolKit変換行列→OpenGL行列
の変換関数を流用してください。



・NyARToolkitとの差分

クラス構造は、一部C++の記法に合わせて変更されていますが、基本的には
NyARToolkitと同一です。
演算結果には完全な互換性があります。


・ライセンス
後述するモジュールを除いたNyARToolkitCPP主要コンポーネントは、商用ライセンス
とGPLv3以降のデュアルライセンスを採用しています。
(Version/2.4.0より、GPLv3ライセンスになりました。)


以下のディレクトリ配下にあるものについては、各モジュールのライセンスに従ってください。
forAlchemy/AlchemyMaster
forAlchemy/NyARToolkitAS3


 -GPL
 GPLについては、LICENCE.txtをお読みください。

 -商用ライセンス
 商用ライセンスについては、ARToolWorks社に管理を委託しております。
 http://www.artoolworks.com/Home.html

 日本国内での販売については、下記にお問い合わせ下さい。
 http://www.msoft.co.jp/pressrelease/press090928-1.html




