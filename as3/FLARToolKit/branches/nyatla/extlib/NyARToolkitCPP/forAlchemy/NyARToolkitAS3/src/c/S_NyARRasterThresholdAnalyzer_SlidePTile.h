/*
 * PROJECT: NyARToolkitCPP Alchemy bind
 * --------------------------------------------------------------------------------
 * The NyARToolkitCPP Alchemy bind is stub/proxy classes for NyARToolkitCPP and Adobe Alchemy.
 *
 * Copyright (C)2009 Ryo Iizuka
 *
* This program is free software: you can redistribute it and/or modify
* it under the terms of the GNU General Public License as published by
* the Free Software Foundation, either version 3 of the License, or
* (at your option) any later version.
*
* This program is distributed in the hope that it will be useful,
* but WITHOUT ANY WARRANTY; without even the implied warranty of
* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
* GNU General Public License for more details.
*
* You should have received a copy of the GNU General Public License
* along with this program.  If not, see <http://www.gnu.org/licenses/>.
*
* For further information please contact.
*	http://nyatla.jp/nyatoolkit/
*	<airmail(at)ebony.plala.or.jp> or <nyatla(at)nyatla.jp>
*
*/
#pragma once
#include "T_INyARRasterThresholdAnalyzer.h"
#include "NyARRasterThresholdAnalyzer_SlidePTile.h"
class S_NyARRasterThresholdAnalyzer_SlidePTile : public T_INyARRasterThresholdAnalyzer<NyARRasterThresholdAnalyzer_SlidePTile>
{
public:
	static AS3_Val createInstance(void* self, AS3_Val args)
	{
		S_NyARRasterThresholdAnalyzer_SlidePTile class_builder;
		return class_builder.buildWithNativeInstance(self,args);
	}
protected:
	//自身のオブジェクトをAS3オブジェクトにする。
	virtual void initAS3Member(AS3ObjectBuilder& i_builder,NyARRasterThresholdAnalyzer_SlidePTile* i_native_inst)
	{
		T_INyARRasterThresholdAnalyzer<NyARRasterThresholdAnalyzer_SlidePTile>::initAS3Member(i_builder,i_native_inst);
		return;
	}
	/*　AS3 Argument protocol
	 * i_persentage       :int
	 * i_raster_format    :int
	 * i_vertical_interval:int
	 */
	virtual NyARRasterThresholdAnalyzer_SlidePTile* createNativeInstance(AS3_Val args)
	{
		int persentage,raster_format,vertical_interval;
		AS3_ArrayValue(args, "IntType,IntType,IntType", &persentage,&raster_format,&vertical_interval);
		return new NyARRasterThresholdAnalyzer_SlidePTile(persentage,raster_format,vertical_interval);
	}
};
