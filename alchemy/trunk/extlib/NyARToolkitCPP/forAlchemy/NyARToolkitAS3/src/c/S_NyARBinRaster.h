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
#include "NyARBinRaster.h"
class S_NyARBinRaster : public AlchemyClassBuilder<NyARBinRaster>
{
public:
	static AS3_Val createInstance(void* self, AS3_Val args)
	{
		S_NyARBinRaster class_builder;
		return class_builder.buildWithNativeInstance(self,args);
	}
protected:
	//自身のオブジェクトをAS3オブジェクトにする。
	virtual void initAS3Member(AS3ObjectBuilder& i_builder,NyARBinRaster* i_native_inst)
	{
		AlchemyClassBuilder<NyARBinRaster>::initAS3Member(i_builder,i_native_inst);
		i_builder.addFunction("getSum",S_NyARBinRaster::getSum);
		return;
	}
	/*　AS3 Argument protocol
	 * w	:int
	 * h	:int
	 */
	virtual NyARBinRaster* createNativeInstance(AS3_Val args)
	{
		int w,h;
		AS3_ArrayValue(args, "IntType,IntType",&w,&h);
		return new NyARBinRaster(w,h);
	}
public:
	/*　This is Debug function
	 * AS3 Argument protocol
	 * native  :S_NyARBinRaster*
	 */
	static AS3_Val getSum(void* self, AS3_Val args)
	{
		NyARBinRaster* inst;
		AS3_ArrayValue(args, "PtrType", &inst);
		int* p=(int*)(inst->getBufferReader().getBuffer());
		int len=inst->getSize().w*inst->getSize().h;
		int sum=0;
		for(int i=0;i<len;i++){
			sum+=*(i+p);
		}
		return AS3_Int(sum);
	}
};
