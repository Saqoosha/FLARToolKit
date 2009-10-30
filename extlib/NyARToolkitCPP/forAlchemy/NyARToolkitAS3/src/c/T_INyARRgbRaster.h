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
#include "S_NyARBinRaster.h"
#include "S_NyARSquareStack.h"
template<class T> class T_INyARRgbRaster : public AlchemyClassBuilder<T>
{
public:
	virtual void initAS3Member(AS3ObjectBuilder& i_builder,T* i_native_inst)
	{
		AlchemyClassBuilder<T>::initAS3Member(i_builder,i_native_inst);
		i_builder.addFunction("getWidth",T_INyARRgbRaster<T>::getWidth);
		i_builder.addFunction("getHeight",T_INyARRgbRaster<T>::getHeight);
		return;
	}
protected:
	/*　AS3 Argument protocol
	 * 	_native    : T*
	 */
	static AS3_Val getWidth(void* self, AS3_Val args)
	{
		T* inst;
		AS3_ArrayValue(args, "PtrType", &inst);
		return AS3_Int(inst->getWidth());
	}
	/*　AS3 Argument protocol
	 * 	_native    : T*
	 */
	static AS3_Val getHeight(void* self, AS3_Val args)
	{
		T* inst;
		AS3_ArrayValue(args, "PtrType", &inst);
		//コピーしてセット
		return AS3_Int(inst->getHeight());
	}
};
