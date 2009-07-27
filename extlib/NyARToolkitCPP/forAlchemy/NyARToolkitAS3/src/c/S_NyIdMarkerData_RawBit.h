#pragma once
#include "NyIdMarkerDataEncoder_RawBit.h"
#include "S_INyIdMarkerData.h"
class S_NyIdMarkerData_RawBit : public S_INyIdMarkerData
{
public:
	//標準的なインスタンス生成関数です。
	static AS3_Val createInstance(void* self, AS3_Val args)
	{
		S_NyIdMarkerData_RawBit* inst=new S_NyIdMarkerData_RawBit();
		//初期化
		inst->initRelStub(new NyIdMarkerData_RawBit());
		//AS3オブジェクト化
		return inst->toAS3Object();
	}

	void initAS3Object(AS3ObjectBuilder& i_builder)
	{
		S_INyIdMarkerData::initAS3Object(i_builder);
		i_builder.addFunction("getPacket",S_NyIdMarkerData_RawBit::getPacket);
	}

	static AS3_Val getPacket(void* self, AS3_Val args)
	{
		S_NyIdMarkerData_RawBit* inst;
		AS3_Val v;
		AS3_ArrayValue(args, "PtrType, AS3ValType", &inst,&v);
		const NyIdMarkerData_RawBit* data=(NyIdMarkerData_RawBit*)inst->m_ref;
		//コピーしてセット
		AS3_ByteArray_writeBytes(v,(void*)&(data->length),sizeof(int));
		AS3_ByteArray_writeBytes(v,(void*)(data->packet),sizeof(int)*data->length);
		//引数の参照カウント減算
		AS3_Release(v);
		return AS3_Null();
	}



};
