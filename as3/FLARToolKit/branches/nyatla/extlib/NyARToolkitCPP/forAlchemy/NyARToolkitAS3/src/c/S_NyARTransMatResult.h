#pragma once
#include "NyARTransMatResult.h"
class S_NyARTransMatResult : public T_NyARDoubleMatrix34<NyARTransMatResult>
{
public:
	//標準的なインスタンス生成関数です。
	static AS3_Val createInstance(void* self, AS3_Val args)
	{
		S_NyARTransMatResult* inst=new S_NyARTransMatResult();
		//初期化
		inst->initRelStub(new NyARTransMatResult());
		//AS3オブジェクト化
		return inst->toAS3Object();
	}
	void initAS3Object(AS3ObjectBuilder& i_builder)
	{
		T_NyARDoubleMatrix34<NyARTransMatResult>::initAS3Object(i_builder);
		i_builder.addFunction("getHasValue",S_NyARTransMatResult::getHasValue);
		i_builder.addFunction("getAngle",S_NyARTransMatResult::getAngle);
	}
	static AS3_Val getHasValue(void* self, AS3_Val args)
	{
		S_NyARTransMatResult* inst;
		AS3_ArrayValue(args, "PtrType", &inst);
		return inst->m_ref->has_value?AS3_True():AS3_False();
	}
	static AS3_Val getAngle(void* self, AS3_Val args)
	{
		S_NyARTransMatResult* inst;
		AS3_Val v;
		AS3_ArrayValue(args, "PtrType, AS3ValType", &inst,&v);
		//コピーしてセット
		AS3_ByteArray_writeBytes(v,(void*)&(inst->m_ref->angle),sizeof(double)*3);
		//引数の参照カウント減算
		AS3_Release(v);
		return AS3_Null();
	}
};
