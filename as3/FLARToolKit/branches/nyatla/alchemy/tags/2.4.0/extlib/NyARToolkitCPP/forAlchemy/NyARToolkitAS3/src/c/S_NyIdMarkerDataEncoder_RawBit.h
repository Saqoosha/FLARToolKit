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
#include "S_NyIdMarkerData_RawBit.h"
#include "T_INyIdMarkerDataEncoder.h"
class S_NyIdMarkerDataEncoder_RawBit : public T_INyIdMarkerDataEncoder<NyIdMarkerDataEncoder_RawBit,S_NyIdMarkerData_RawBit,NyIdMarkerData_RawBit>
{
public:
	static AS3_Val createInstance(void* self, AS3_Val args)
	{
		S_NyIdMarkerDataEncoder_RawBit class_builder;
		return class_builder.buildWithNativeInstance(self,args);
	}
protected:
	//自身のオブジェクトをAS3オブジェクトにする。
	virtual void initAS3Member(AS3ObjectBuilder& i_builder,NyIdMarkerDataEncoder_RawBit* i_native_inst)
	{
		T_INyIdMarkerDataEncoder<NyIdMarkerDataEncoder_RawBit,S_NyIdMarkerData_RawBit,NyIdMarkerData_RawBit>::initAS3Member(i_builder,i_native_inst);
		return;
	}
	/*　AS3 Argument protocol
	 */
	virtual NyIdMarkerDataEncoder_RawBit* createNativeInstance(AS3_Val args)
	{
		return new NyIdMarkerDataEncoder_RawBit();
	}
};
