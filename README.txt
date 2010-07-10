======================================================================
FLARToolKit
 version 2.5.4
======================================================================

The FLARToolKit is ActionScript 3.0 version ARToolkit class library.
Copyright (C)2010 Saqoosha, R.Iizuka(nyatla)

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.

For further information please contact.
 http://www.libspark.org/wiki/saqoosha/FLARToolKit
 <wm(at)nyatla.jp> or <saq(at)saqoosha.net>

This work is based on the NyARToolKit developed by
  R.Iizuka (nyatla)
  http://nyatla.jp/nyatoolkit/

contributors
 eric socolofsky
 makc
 taro - tarotaro.org
 rokubou - sixwish.jp

----------------------------------------------------------------------
 About FLARToolKit
----------------------------------------------------------------------
 * ARToolKit の AS3 版です。
 * Flash player 10 用
 * A虎＠(nyatla)氏の NyARToolkit for AS3 を基盤にFLARToolKit v1.xの
   インターフェースを引き継いだライブラリ集です。
 * FLARToolKit は入力画像からマーカーを認識して、3 次元空間での
   カメラ位置を計算するとこまでをやってくれます。
 * 3D グラフィックスとの合成などは各自で実装する必要があります。
 * ただし簡単に合成できるようにヘルパー的なものはついてます。
   (Papervision3D, Away3D, Away3D Lite, Sandy3D, Alternativa3D)

 # AS3 ported version of ARToolKit.
 # Flash player 10 only
 # This is a library collection that succeeded the interface of
   FLARToolKit v1.x based on NyARToolkit for AS3(NOT Alchemy version).
 # FLARToolKit recognize the marker from input image.
   and calculate its orientation and position in 3D world.
 # You should draw 3D graphics by your own.
 # But helper classes for major flash 3D engines
   (Papervision3D, Away3D, Sandy3D, Alternativa3D)

----------------------------------------------------------------------
 FLARToolKit License
----------------------------------------------------------------------
FLARToolKitは「GPL」と「Commercialライセンス」の
デュアルライセンス方式を採用しています。
また、FLARToolKitは関連するいくつかのライブラリも含めて配布しています。
含まれるライブラリは、それぞれのライセンスが適応されます。

[GPL License]
ライセンスの内容は、COPYING.txtをご確認ください
また、GPL(the GNU General Public License v3)を選択した場合、
商用・非商用を問わず、無料で使用可能です。
ただし、GPLで課されている条件に従い、GPLを適応していることの告知、
並びにユーザーの要求に応じてアプリケーションのソースコードの提供、
これらを含む義務を履行してください。

[Commercial License]
FLARToolKitはGPLを受け入れることができないユーザーのために、
Commercial Licenseが有償でARToolworks Inc.より提供されています。
ARToolworks Inc.より許諾を受けることにより、GPLの制約から
解放されます。
条件やライセンス費用については、ARToolworks Inc.に問合せてください。

ARToolworks Inc. http://www.artoolworks.com/
mailto : sales(at)artoolworks.com


FLARToolKit is available for download and use under two licenses:

GPL License: FLARToolKit can be used for free under GPL v3
(the GNU General Public License, v3). Source code of applications using
FLARToolKit under the GPL must be provided free of charge on request.

Commercial License: Source code of FLARToolKit applications can be
protected with a commercial license, offered exclusively by ARToolworks.
Applications using the commercial license do not have to provide
source code, but must pay a licensing fee.
Contact ARToolworks at sales(at)artoolworks.com for more information.

ARToolworks Inc.
http://www.artoolworks.com/

Moreover, FLARToolKit is distributed including some relating libraries. 
Each license adjusts to the included library. 

----------------------------------------------------------------------
 Include External library
----------------------------------------------------------------------
[papervision3d 2.1.920]
 Open Source realtime 3D engine for Flash
 URL     : http://code.google.com/p/papervision3d/
 License : MIT License

[Away3D 3.4.0]
 Realtime 3D engine for Flash
 URL     : http://away3d.com/
 License : Apache License, Version 2.0

[Away3D Lite 1.0.0]
 Realtime 3D engine for Flash
 URL     : http://away3d.com/
 License : Apache License, Version 2.0

----------------------------------------------------------------------
 External library
----------------------------------------------------------------------
[Sandy3D]
 Realtime 3D engine for Flash
 URL     : http://away3d.com/
 License : MOZILLA PUBLIC LICENSE, Version 1.1

[Alternativa3D]
 browser 3D-engine based on Adobe Flash
 URL     : http://www.flashsandy.org/
 License : Commercial licence / Free non-commercial licence

----------------------------------------------------------------------
 Development environment
----------------------------------------------------------------------
 * Adobe FLASH CS4 Professional (version 10.0.2)
 * Adobe Flex Builder 3 Standard (build 3.0.2)
   (Eclipse Version: 3.4.2 + Flex Builder 3.0 + Flex SDK 3.4, 3.5)
 * Adobe Flash Builder 4 Standard (Version 4.0 : build 272416)
   (Flex SDK 4.0)
 * FlashDevelop + Flex SDK 3.4, 3.5
 
----------------------------------------------------------------------
 Special thanks
----------------------------------------------------------------------
加藤博一先生 (Hirokazu Kato, Ph. D.)
 http://www.hitl.washington.edu/artoolkit/

Prof. Mark Billinghurst
 http://www.hitlabnz.org/

----------------------------------------------------------------------
 Change Log
----------------------------------------------------------------------
2.5.4 (2010-Jul-10)
 * Add NyID Marker Detector
   + Single Id Marker Detector
   + Multiple Id Marker Detector
 * Add analytical size restriction function
 * Add,Modify Samples
   + Single/Multiple IDMarker sample
   + Single/Multiple Marker PV3D sample
   + Single Marker Away3D Lite sample

2.5.3 (2010-May-15)
 * Modify FLARMultiMarkerDetector
   + Corresponds to markerPercentWidth, markerPercentHeight
 * Modify FLARSingleMarkerDetector
   + Delete debug trace()
 * Update : NyARToolKit AS3(v2.5.2 alpha to v2.5.2)
 * Add Wide display(16:9) sample

2.5.2 (2010-Apr-25)
 * Fixed bug(NyARToolKit)
   + NyARPerspectiveParamGenerator
     (markers with a rotation of exactly 0, 90, 180, and 270 are detected,
      but at a very low confidence)
   + NyARDoubleMatrix22::inverse

2.5.2 alpha (2010-Apr-14)
 * Modify FLARCode
   + add constructor params
   + add function markerPercentWidth, markerPercentHeight
 * Modify FLARParam
   + add initial parameter value
 * Add Camera parameter file(16x9)
 * Corrected that publish can be done with FLASH CS4.
 * An initial value of default camera value that Mackc wrote in FLARParam is added.
 * The regulating function of the threshold of the raster image is added to PV3DARApp.
 * Construct of FLARRgbRaster_BitmapData is corrected.
 * Added method to FLARMultiMarkerDetector,FLARSingleMarkerDetector
   + getDirection(i_index:int):int, getSquare(i_index:int):NyARSquare
 * Add Away3D, Away3D Lite library.
 * Add support.away3d_lite.FLARBaseNode.(experiment)
 * Corrected sample
 * Add NyIDMarker sample
 * Add Single Marker Manager sample
 * Add Single Marker PV3D sample
 * Add Single Marker Away3D sample
 * Add Single Marker Away3D Lite sample(experiment)

2.5.1 (2010-Feb-20)
 * Bug fix: spell miss, interface, extends error and more.
 
2.5.0
 * Merge NyARToolKit for AS3
 * Flash player 10 or above.

1.0.0 (2010-Jan-20)
 * implemented support for debugging display of thresholded and
   labeled BitmapData objects, via accessors in FLARMultiMarkerDetector
   and FLARSquareDetector.(Eric Socolofsky)
 * implemented option to skip internal thresholding process,
   to allow use of custom thresholding algorithms(Eric Socolofsky)
 * added variable marker border width to FLARMultiMarkerDetector,
   to match FLARSingleMarkerDetector.(Eric Socolofsky)
 * FLARParam : default camera values(makc)
 * Move 3d framework support classes into
   org.libspark.flartoolkit.support package.(saqoosha)
 * adding makc's sandy3D support.(Eric Socolofsky,makc)
 * adding makc's alternativa3D support.(Eric Socolofsky,makc)
 * corrected import statements in repackaged support (3d framework)
   classes.(Eric Socolofsky)
 * added away3d 3.3.3 support to support.away3d package.(Eric Socolofsky)
 * added away3dlite support(Eric Socolofsky)

0.9.1 (2010-Jan-17)
Re-packaging by rokubou. 

0.9.0 (2009-Jun-03)
packaging by saqoosha
 * Added stater sample(starter-kit)
