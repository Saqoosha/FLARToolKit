#pragma once
#include "T_INyARColorPatt.h"
#include "NyARColorPatt_Perspective_O2.h"
class S_NyARColorPatt_Perspective_O2 : public T_INyARColorPatt<NyARColorPatt_Perspective_O2>
{
public:
	static AS3_Val createInstance(void* self, AS3_Val args)
	{
		S_NyARColorPatt_Perspective_O2 class_builder;
		return class_builder.buildWithNativeInstance(self,args);
	}
protected:
	//自身のオブジェクトをAS3オブジェクトにする。
	virtual void initAS3Member(AS3ObjectBuilder& i_builder,NyARColorPatt_Perspective_O2* i_native_inst)
	{
		T_INyARColorPatt<NyARColorPatt_Perspective_O2>::initAS3Member(i_builder,i_native_inst);
		i_builder.addFunction("getData",S_NyARColorPatt_Perspective_O2::getData);
		return;
	}
	/*　AS3 Argument protocol
	 * 	w    : int
	 *  h    : int
	 *  res  : int
	 *  edge : int
	 */
	virtual NyARColorPatt_Perspective_O2* createNativeInstance(AS3_Val args)
	{
		int w,h,res,edge;
		AS3_ArrayValue(args, "IntType,IntType,IntType,IntType",&w,&h,&res,&edge);
		//初期化
		return new NyARColorPatt_Perspective_O2(w,h,res,edge);
	}
	/*　AS3 Argument protocol
	 * 	native    : NyARColorPatt_Perspective_O2*
	 *  h         : AS3_Val as ByteArray
	 */
	static AS3_Val getData(void* self, AS3_Val args)
	{
		NyARColorPatt_Perspective_O2* native;
		AS3_Val v;
		AS3_ArrayValue(args, "PtrType,AS3ValType", &native,&v);
		void* buf=(void*)(native->getBufferReader().getBuffer());
		const TNyARIntSize& size=native->getSize();
		AS3_ByteArray_writeBytes(v,buf,sizeof(int)*size.w*size.h);
		//引数の参照カウント減算
		AS3_Release(v);
		return AS3_Null();
	}
};
