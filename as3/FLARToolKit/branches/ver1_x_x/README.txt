======================================================================
FLARToolKit
 version 1.0.0
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
 * ARToolKit �� AS3 �łł��B
 * A�Ձ�(nyatla)���� Java �ɈڐA���� NyARToolkit ��
   ����� ActionScript3 �ɈڐA�������C�u�����ł��B
 * FLARToolKit �͓��͉摜����}�[�J�[��F�����āA3 ������Ԃł�
   �J�����ʒu���v�Z����Ƃ��܂ł�����Ă���܂��B
 * 3D �O���t�B�b�N�X�Ƃ̍����Ȃǂ͊e���Ŏ�������K�v������܂��B
 * �������ȒP�ɍ����ł���悤�Ƀw���p�[�I�Ȃ��̂͂��Ă܂��B
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
FLARToolKit�́uGPL�v�ƁuCommercial���C�Z���X�v��
�f���A�����C�Z���X�������̗p���Ă��܂��B
�܂��AFLARToolKit�͊֘A���邢�����̃��C�u�������܂߂Ĕz�z���Ă��܂��B
�܂܂�郉�C�u�����́A���ꂼ��̃��C�Z���X���K������܂��B

[GPL License]
���C�Z���X�̓��e�́ACOPYING.txt�����m�F��������
�܂��AGPL(the GNU General Public License v3)��I�������ꍇ�A
���p�E�񏤗p���킸�A�����Ŏg�p�\�ł��B
�������AGPL�ŉۂ���Ă�������ɏ]���AGPL��K�����Ă��邱�Ƃ̍��m�A
���тɃ��[�U�[�̗v���ɉ����ăA�v���P�[�V�����̃\�[�X�R�[�h�̒񋟁A
�������܂ދ`���𗚍s���Ă��������B

[Commercial License]
FLARToolKit��GPL���󂯓���邱�Ƃ��ł��Ȃ����[�U�[�̂��߂ɁA
Commercial License���L����ARToolworks Inc.���񋟂���Ă��܂��B
ARToolworks Inc.��苖�����󂯂邱�Ƃɂ��AGPL�̐��񂩂�
�������܂��B
�����⃉�C�Z���X��p�ɂ��ẮAARToolworks Inc.�ɖ⍇���Ă��������B

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
���̃o�[�W�����́A�ߋ��ɔz�z���ꂽStart-kit�Ȃǂ��畜�����ꂽ���̂ł��B
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
[Away3D, Away3D Lite]
 Realtime 3D engine for Flash
 URL     : http://away3d.com/
 License : Apache License, Version 2.0
 
[Sandy3D]
 Realtime 3D engine for Flash
 URL     : http://away3d.com/
 License : MOZILLA PUBLIC LICENSE, Version 1.1

[Alternativa3D]
 browser 3D-engine based on Adobe Flash
 URL     : http://www.flashsandy.org/
 License : Commercial licence / Free non-commercial licence

----------------------------------------------------------------------
 Change Log
----------------------------------------------------------------------
1.0.0 (2010-01-20)
 * implemented support for debugging display of thresholded and
   labeled BitmapData objects, via accessors in FLARMultiMarkerDetector
   and FLARSquareDetector.(ericsoco)
 * implemented option to skip internal thresholding process,
   to allow use of custom thresholding algorithms(ericsoco)
 * added variable marker border width to FLARMultiMarkerDetector,
   to match FLARSingleMarkerDetector.(ericsoco)
 * FLARParam : default camera values(makc)
 * Move 3d framework support classes into
   org.libspark.flartoolkit.support package.(saqoosha)
 * adding makc's sandy3D support.(ericsoco,makc)
 * adding makc's alternativa3D support.(ericsoco,makc)
 * corrected import statements in repackaged support (3d framework)
   classes.(ericsoco)
 * added away3d 3.3.3 support to support.away3d package.(ericsoco)
 * added away3dlite support(ericsoco)

0.9.1 (2010-01-17)
Re-packaging by rokubou. 

0.9.0 (2009-06-03)
packaging by saqoosha
 * Added stater sample(starter-kit)

