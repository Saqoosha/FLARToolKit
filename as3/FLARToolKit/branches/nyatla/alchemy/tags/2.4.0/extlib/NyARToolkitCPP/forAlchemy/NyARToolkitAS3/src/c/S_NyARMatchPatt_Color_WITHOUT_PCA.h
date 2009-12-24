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
#include "NyARMatchPatt_Color_WITHOUT_PCA.h"
#include "S_NyARCode.h"
class S_NyARMatchPatt_Color_WITHOUT_PCA : public AlchemyClassBuilder<NyARMatchPatt_Color_WITHOUT_PCA>
{
public:
	static AS3_Val createInstance(void* self, AS3_Val args)
	{
		S_NyARMatchPatt_Color_WITHOUT_PCA class_builder;
		return class_builder.buildWithNativeInstance(self,args);
	}
protected:
	//自身のオブジェクトをAS3オブジェクトにする。
	virtual void initAS3Member(AS3ObjectBuilder& i_builder,NyARMatchPatt_Color_WITHOUT_PCA* i_native_inst)
	{
		AlchemyClassBuilder<NyARMatchPatt_Color_WITHOUT_PCA>::initAS3Member(i_builder,i_native_inst);
		i_builder.addFunction("evaluate",S_NyARMatchPatt_Color_WITHOUT_PCA::evaluate);
		return;
	}
	/*　AS3 Argument protocol
	 * 	code    : NyARCode*
	 */
	virtual NyARMatchPatt_Color_WITHOUT_PCA* createNativeInstance(AS3_Val args)
	{
		NyARCode* code;
		AS3_ArrayValue(args, "PtrType",&code);
		//初期化
		return new NyARMatchPatt_Color_WITHOUT_PCA(code);
	}
private:
	/*　AS3 Argument protocol
	 * 	_native    : S_NyARMatchPatt_Color_WITHOUT_PCA*
	 *  data       : NyARMatchPattDeviationColorData*
	 *  result     : TNyARMatchPattResult*
	 *  return     : AS3_Val as Boolean
	 */
	static AS3_Val evaluate(void* self, AS3_Val args)
	{
		NyARMatchPatt_Color_WITHOUT_PCA* native;
		NyARMatchPattDeviationColorData* data;
		TNyARMatchPattResult* result;
		AS3_ArrayValue(args, "PtrType,PtrType,PtrType", &native,&data,&result);
		return native->evaluate(*data,*result)?AS3_True():AS3_False();
	}
};
