======================================================================
FLARToolKit
 version 0.9.1(Temporary version)
======================================================================

The FLARToolKit is ActionScript 3.0 version ARToolkit class library.
Copyright (C)2008 Saqoosha

This program is free software; you can redistribute it and/or
modify it under the terms of the GNU General Public License
as published by the Free Software Foundation; either version 2
of the License, or (at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this framework; if not, write to the Free Software
Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA

For further information please contact.
 http://www.libspark.org/wiki/saqoosha/FLARToolKit
 <saq(at)saqoosha.net>

This work is based on the NyARToolKit developed by
  R.Iizuka (nyatla)
  http://nyatla.jp/nyatoolkit/

----------------------------------------------------------------------
 About FLARToolKit
----------------------------------------------------------------------
 * ARToolKit の AS3 版です。
 * A虎＠(nyatla)氏が Java に移植した NyARToolkit を
   さらに ActionScript3 に移植したライブラリです。
 * FLARToolKit は入力画像からマーカーを認識して、3 次元空間での
   カメラ位置を計算するとこまでをやってくれます。
 * 3D グラフィックスとの合成などは各自で実装する必要があります。
 * ただし簡単に合成できるようにヘルパー的なものはついてます。
   (Papervision3D, Away3D)

 # AS3 ported version of ARToolKit.
 # Actually, FLARToolKit is based on NyARToolkit,
   Java ported version of ARToolKit.
 # FLARToolKit recognize the marker from input image.
   and calculate its orientation and position in 3D world.
 # You should draw 3D graphics by your own.
 # But helper classes for major flash 3D engines
   (Papervision3D, Away3D)

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
mailto : sales@artoolworks.com


FLARToolKit is available for download and use under two licenses:

GPL License: FLARToolKit can be used for free under GPL v3
(the GNU General Public License, v3). Source code of applications using
FLARToolKit under the GPL must be provided free of charge on request.

Commercial License: Source code of FLARToolKit applications can be
protected with a commercial license, offered exclusively by ARToolworks.
Applications using the commercial license do not have to provide
source code, but must pay a licensing fee.
Contact ARToolworks at sales@artoolworks.com for more information.

ARToolworks Inc.
http://www.artoolworks.com/

Moreover, FLARToolKit is distributed including some relating libraries. 
Each license adjusts to the included library. 

----------------------------------------------------------------------
 Attention
----------------------------------------------------------------------
このバージョンは、過去に配布されたStart-kitなどから復元されたものです。
This version is the one restored from Start-kit etc. distributed in the past.

----------------------------------------------------------------------
 Include External library
----------------------------------------------------------------------
[papervision3d Public Beta 2.0]
 Open Source realtime 3D engine for Flash
 URL     : http://code.google.com/p/papervision3d/
 License : MIT License

----------------------------------------------------------------------
 External library
----------------------------------------------------------------------
[Away3D]
 Realtime 3D engine for Flash
 URL     : http://away3d.com/
 License : Apache License, Version 2.0
 
 
