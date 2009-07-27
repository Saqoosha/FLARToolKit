#pragma once
#include "NyARCode.h"
class S_NyARCode : public AlchemyClassStub<NyARCode>
{
public:
	static AS3_Val createInstance(void* self, AS3_Val args)
	{
		S_NyARCode* inst=new S_NyARCode();
		int w,h;
		AS3_ArrayValue(args, "IntType,IntType",&w,&h);
		//初期化
		inst->initRelStub(new NyARCode(w,h));
		//AS3オブジェクト化
		return inst->toAS3Object();
	}
	//自身のオブジェクトをAS3オブジェクトにする。
	void initAS3Object(AS3ObjectBuilder& i_builder)
	{
		AlchemyClassStub<NyARCode>::initAS3Object(i_builder);
		i_builder.addFunction("loadARPatt",S_NyARCode::loadARPatt);
		i_builder.addFunction("getWidth",S_NyARCode::getWidth);
		i_builder.addFunction("getHeight",S_NyARCode::getHeight);
		return;
	}
private:
	static AS3_Val loadARPatt(void* self, AS3_Val args)
	{
		S_NyARCode* inst;
		AS3_Val v;
		AS3_ArrayValue(args, "PtrType,AS3ValType", &inst,&v);
		//配列のサイズを決定
		int w=inst->m_ref->getWidth();
		int h=inst->m_ref->getHeight();
		//Intで送信されてくるので、unsigned charに変換
		unsigned char* work=new unsigned char[4*w*h*3];
		int temp[12];
		for(int i=0;i<w*h;i++){
			AS3_ByteArray_readBytes(temp,v,12*sizeof(int));
			for(int i2=0;i2<12;i2++){
				work[(12*i)+i2]=(unsigned char)temp[i2];
			}
		}
		//Cのアクセス制御を強引に突破する。
		((NyARCode*)inst->m_ref)->loadARPatt(work);
		delete work;
		//引数の参照カウント減算
		AS3_Release(v);
		return AS3_Null();
	}
	static AS3_Val getWidth(void* self, AS3_Val args)
	{
		S_NyARCode* inst;
		AS3_ArrayValue(args, "PtrType", &inst);
		return AS3_Int(inst->m_ref->getWidth());
	}
	static AS3_Val getHeight(void* self, AS3_Val args)
	{
		S_NyARCode* inst;
		AS3_ArrayValue(args, "PtrType", &inst);
		//コピーしてセット
		return AS3_Int(inst->m_ref->getHeight());
	}
};
