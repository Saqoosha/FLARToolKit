#pragma once
#include "NyIdMarkerDataEncoder_RawBit.h"
#include "T_INyIdMarkerData.h"
class S_NyIdMarkerData_RawBit : public T_INyIdMarkerData<NyIdMarkerData_RawBit>
{
public:
	static AS3_Val createInstance(void* self, AS3_Val args)
	{
		S_NyIdMarkerData_RawBit class_builder;
		return class_builder.buildWithNativeInstance(self,args);
	}
protected:
	//自身のオブジェクトをAS3オブジェクトにする。
	virtual void initAS3Member(AS3ObjectBuilder& i_builder,NyIdMarkerData_RawBit* i_native_inst)
	{
		T_INyIdMarkerData<NyIdMarkerData_RawBit>::initAS3Member(i_builder,i_native_inst);
		i_builder.addFunction("getValue",S_NyIdMarkerData_RawBit::getValue);
		return;
	}
	/*　AS3 Argument protocol
	 */
	virtual NyIdMarkerData_RawBit* createNativeInstance(AS3_Val args)
	{
		return new NyIdMarkerData_RawBit();
	}

public:
	/*　AS3 Argument protocol
	 * 	_native    : T*
	 *  v          : AS3_ByteArray as len:int ,int[len]
	 */
	static AS3_Val getValue(void* self, AS3_Val args)
	{
		NyIdMarkerData_RawBit* native;
		AS3_Val v;
		AS3_ArrayValue(args, "PtrType, AS3ValType", &native,&v);
		//コピーしてセット
		AS3_ByteArray_writeBytes(v,(void*)&(native->length),sizeof(int));
		AS3_ByteArray_writeBytes(v,(void*)(native->packet),sizeof(int)*native->length);
		//引数の参照カウント減算
		AS3_Release(v);
		return AS3_Null();
	}



};
