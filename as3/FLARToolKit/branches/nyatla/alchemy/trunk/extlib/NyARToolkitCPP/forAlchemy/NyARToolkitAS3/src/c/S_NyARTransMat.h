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
#include "NyARTransMat.h"
class S_NyARTransMat : public AlchemyClassBuilder<NyARTransMat>
{
public:
	static AS3_Val createInstance(void* self, AS3_Val args)
	{
		S_NyARTransMat class_builder;
		return class_builder.buildWithNativeInstance(self,args);
	}
protected:
	//自身のオブジェクトをAS3オブジェクトにする。
	virtual void initAS3Member(AS3ObjectBuilder& i_builder,NyARTransMat* i_native_inst)
	{
		AlchemyClassBuilder<NyARTransMat>::initAS3Member(i_builder,i_native_inst);
		i_builder.addFunction("transMat",S_NyARTransMat::transMat);
		return;
	}
	/*　AS3 Argument protocol
	 * _param : NyARTransMat*
	 */
	virtual NyARTransMat* createNativeInstance(AS3_Val args)
	{
		NyARParam* param;
		AS3_ArrayValue(args, "PtrType",&param);
		return new NyARTransMat(param);
	}
public:
	/*　AS3 Argument protocol
	 * _native	:NyARTransMat*
	 * square   :NyARSquare*
	 * direction:int
	 * width:double
	 * result:NyARTransMatResult*
	 */
	static AS3_Val transMat(void* self, AS3_Val args)
	{
		NyARTransMat* native;
		NyARSquare* square;
		int direction;
		double width;
		NyARTransMatResult* result;
		AS3_ArrayValue(args,
				"PtrType,PtrType,IntType,DoubleType,PtrType",
				&native,&square,&direction,&width,&result);

		native->transMat(*square,direction,width,*result);
		return AS3_Null();
	}
	/*　AS3 Argument protocol
	 * _native	:NyARSquareStack*
	 * square   :NyARSquare*
	 * direction:int
	 * width:double
	 * height:double
	 * result:NyARTransMatResult*
	 */
	static AS3_Val transMatContinue(void* self, AS3_Val args)
	{
		NyARTransMat* native;
		NyARSquare* square;
		int direction;
		double width;
		NyARTransMatResult* result;
		AS3_ArrayValue(args,
				"PtrType,PtrType,IntType,DoubleType,PtrType",
				&native,&square,&direction,&width,&result);
		native->transMatContinue(*square,direction,width,*result);
		return AS3_Null();
	}
};
