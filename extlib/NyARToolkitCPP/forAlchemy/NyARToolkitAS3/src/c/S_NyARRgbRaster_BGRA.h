#pragma once
#include "NyARRgbRaster_BGRA.h"

class S_NyARRgbRaster_BGRA : public AlchemyClassStub<NyARRgbRaster_BGRA>
{
private:
	//m_instに同期するリソース
	NyAR_BYTE_t* m_buf;
public:
	static AS3_Val createInstance(void* self, AS3_Val args)
	{
		S_NyARRgbRaster_BGRA* inst=new S_NyARRgbRaster_BGRA();
		int w,h;
		AS3_ArrayValue(args, "IntType,IntType",&w,&h);
		//初期化
		inst->initRelStub(new NyARRgbRaster_BGRA(w,h));
		inst->m_buf=new NyAR_BYTE_t[w*h*4*sizeof(NyAR_BYTE_t)];
		inst->m_inst->setBuffer(inst->m_buf);
		//AS3オブジェクト化
		return inst->toAS3Object();
	}
	static AS3_Val createReference(const NyARRgbRaster_BGRA* i_ref)
	{
		//参照生成はm_bufの参照もコピーすること！
		return NULL;
	}

	//自身のオブジェクトをAS3オブジェクトにする。
	void initAS3Object(AS3ObjectBuilder& i_builder)
	{
		AlchemyClassStub<NyARRgbRaster_BGRA>::initAS3Object(i_builder);
		i_builder.addFunction("setData",S_NyARRgbRaster_BGRA::setData);
		i_builder.addFunction("getWidth",S_NyARRgbRaster_BGRA::getWidth);
		i_builder.addFunction("getHeight",S_NyARRgbRaster_BGRA::getHeight);
		return;
	}
	~S_NyARRgbRaster_BGRA()
	{
		if(this->m_inst!=NULL){
			delete this->m_buf;
			this->m_buf=NULL;
		}
	}
private:
	static AS3_Val setData(void* self, AS3_Val args)
	{
		S_NyARRgbRaster_BGRA* inst;
		AS3_Val v;
		AS3_ArrayValue(args, "PtrType,AS3ValType", &inst,&v);
		//コピーサイズを決める(4*w*h)
		int w=inst->m_ref->getWidth();
		int h=inst->m_ref->getHeight();
		//BYTEデータをコピー
		AS3_ByteArray_readBytes(inst->m_buf,v,w*h*4*sizeof(NyAR_BYTE_t));
		//引数の参照カウント減算
		AS3_Release(v);
		return AS3_Null();
	}
	static AS3_Val getWidth(void* self, AS3_Val args)
	{
		S_NyARRgbRaster_BGRA* inst;
		AS3_ArrayValue(args, "PtrType", &inst);
		return AS3_Int(inst->m_ref->getWidth());
	}
	static AS3_Val getHeight(void* self, AS3_Val args)
	{
		S_NyARRgbRaster_BGRA* inst;
		AS3_ArrayValue(args, "PtrType", &inst);
		//コピーしてセット
		return AS3_Int(inst->m_ref->getHeight());
	}
};
