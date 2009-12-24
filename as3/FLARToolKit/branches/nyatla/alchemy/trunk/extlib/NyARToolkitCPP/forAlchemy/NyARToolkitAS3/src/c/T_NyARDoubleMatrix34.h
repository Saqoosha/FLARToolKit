/*
 * PROJECT: NyARToolkitCPP Alchemy bind
 * --------------------------------------------------------------------------------
 * The NyARToolkitCPP Alchemy bind is stub/proxy classes for NyARToolkitCPP and Adobe Alchemy.
 *
 * Copyright (C)2009 Ryo Iizuka
 *
 * This program is free software; you can redistribute it and/or
 * modify it under the terms of the GNU General Public License
 * as published by the Free Software Foundation; either version 2
 * of the License, or (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this framework; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
 *
 * For further information please contact.
 *	http://nyatla.jp/nyatoolkit/
 *	<airmail(at)ebony.plala.or.jp>
 *
 */
#pragma once


template<class T> class T_NyARDoubleMatrix34 : public AlchemyClassBuilder<T>
{
public:
	virtual void initAS3Member(AS3ObjectBuilder& i_builder,T* i_native_inst)
	{
		AlchemyClassBuilder<T>::initAS3Member(i_builder,i_native_inst);
		i_builder.addFunction("setValue",T_NyARDoubleMatrix34<T>::setValue);
		i_builder.addFunction("getValue",T_NyARDoubleMatrix34<T>::getValue);
		return;
	}
protected:
	/*　AS3 Argument protocol
	 * 	_native    : T*
	 *  v          : AS3_ByteArray
	 */
	static AS3_Val setValue(void* self, AS3_Val args)
	{
		T* native;
		AS3_Val v;
		AS3_ArrayValue(args, "PtrType, AS3ValType", &native,&v);
		//
		double work[12];
		AS3_ByteArray_readBytes(work,v,sizeof(double)*12);
		native->setValue(work);
		//引数の参照カウント減算
		AS3_Release(v);
		return AS3_Null();
	}
	/*　AS3 Argument protocol
	 * 	_native    : T*
	 *  v          : AS3_ByteArray as diuble[12]
	 */
	static AS3_Val getValue(void* self, AS3_Val args)
	{
		T* native;
		AS3_Val v;
		AS3_ArrayValue(args, "PtrType, AS3ValType", &native,&v);
		//コピーしてセット
		double work[12];
		native->getValue(work);
		AS3_ByteArray_writeBytes(v,work,sizeof(double)*12);
		//引数の参照カウント減算
		AS3_Release(v);
		return AS3_Null();
	}
};
