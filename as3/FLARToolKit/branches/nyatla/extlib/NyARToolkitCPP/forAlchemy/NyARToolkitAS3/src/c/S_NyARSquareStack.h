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
#include "S_NyARSquare.h"
#include "NyARSquareStack.h"
class S_NyARSquareStack : public AlchemyClassBuilder<NyARSquareStack>
{
public:
	static AS3_Val createInstance(void* self, AS3_Val args)
	{
		S_NyARSquareStack class_builder;
		return class_builder.buildWithNativeInstance(self,args);
	}
protected:
	//自身のオブジェクトをAS3オブジェクトにする。
	virtual void initAS3Member(AS3ObjectBuilder& i_builder,NyARSquareStack* i_native_inst)
	{
		AlchemyClassBuilder<NyARSquareStack>::initAS3Member(i_builder,i_native_inst);
		i_builder.addFunction("getLength",S_NyARSquareStack::getLength);
		i_builder.addFunction("getItem",S_NyARSquareStack::getItem);
		return;
	}
	/*　AS3 Argument protocol
	 * length	:int
	 */
	virtual NyARSquareStack* createNativeInstance(AS3_Val args)
	{
		int len;
		AS3_ArrayValue(args, "IntType",&len);
		return new NyARSquareStack(len);
	}

public:
	/*　AS3 Argument protocol
	 * _native	:NyARSquareStack*
	 * return   :int
	 */
	static AS3_Val getLength(void* self, AS3_Val args)
	{
		NyARSquareStack* native;
		AS3_ArrayValue(args, "PtrType", &native);
		return AS3_Int(native->getLength());
	}
	/*　AS3 Argument protocol
	 * _native	:NyARSquareStack
	 * index	:int
	 * return   :AS3_Val as NyARStack
	 */
	static AS3_Val getItem(void* self, AS3_Val args)
	{
		NyARSquareStack* native;
		int index;
		AS3_ArrayValue(args, "PtrType,IntType", &native,&index);
		S_NyARSquare class_builder;
		return class_builder.buildWithOutNativeInstance(native->getItem(index));
	}
};
