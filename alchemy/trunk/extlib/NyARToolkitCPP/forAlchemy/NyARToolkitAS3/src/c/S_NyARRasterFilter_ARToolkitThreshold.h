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
#include "T_INyARRasterFilter_RgbToBin.h"
#include "NyARRasterFilter_ARToolkitThreshold.h"
class S_NyARRasterFilter_ARToolkitThreshold : public T_INyARRasterFilter_RgbToBin<NyARRasterFilter_ARToolkitThreshold>
{
public:
	static AS3_Val createInstance(void* self, AS3_Val args)
	{
		S_NyARRasterFilter_ARToolkitThreshold class_builder;
		return class_builder.buildWithNativeInstance(self,args);
	}
protected:
	//自身のオブジェクトをAS3オブジェクトにする。
	virtual void initAS3Member(AS3ObjectBuilder& i_builder,NyARRasterFilter_ARToolkitThreshold* i_native_inst)
	{
		T_INyARRasterFilter_RgbToBin<NyARRasterFilter_ARToolkitThreshold>::initAS3Member(i_builder,i_native_inst);
		i_builder.addFunction("setThreshold",S_NyARRasterFilter_ARToolkitThreshold::setThreshold);
		return;
	}
	/*　AS3 Argument protocol
	 * th                :int
	 * input_raster_type :int
	 */
	virtual NyARRasterFilter_ARToolkitThreshold* createNativeInstance(AS3_Val args)
	{
		int input_raster_type,th;
		AS3_ArrayValue(args, "IntType,IntType", &th,&input_raster_type);
		return new NyARRasterFilter_ARToolkitThreshold(th,input_raster_type);
	}
protected:
	/*　AS3 Argument protocol
	 * _native	:NyARTransMat*
	 * th       :int
	 */
	static AS3_Val setThreshold(void* self, AS3_Val args)
	{
		NyARRasterFilter_ARToolkitThreshold* native;
		int th;
		AS3_ArrayValue(args,
				"PtrType,IntType",
				&native,&th);
		native->setThreshold(th);
		return AS3_Null();
	}
};

