#pragma once
#include "NyARSingleDetectMarker.h"

class S_NyARSingleDetectMarker : public AlchemyClassStub<NyARSingleDetectMarker>
{
public:
	static AS3_Val createInstance(void* self, AS3_Val args)
	{
		//この関数は引数codeからNyARCodeインスタンスをデタッチするので注意。
		//関数呼び出し後は、AS側で引数に渡したcodeインスタンスを確実にdisposeすること！
		S_NyARSingleDetectMarker* inst=new S_NyARSingleDetectMarker();
		S_NyARParam* param;
		S_NyARCode* code;
		double width;
		int raster_type;

		AS3_ArrayValue(args, "PtrType,PtrType,DoubleType,IntType",&param,&code,&width,&raster_type);

		inst->initRelStub(new NyARSingleDetectMarker(param->getRef(),code->getRef(),width,raster_type));
		//AS3オブジェクト化
		return inst->toAS3Object();
	}

	void initAS3Object(AS3ObjectBuilder& i_builder)
	{
		AlchemyClassStub<NyARSingleDetectMarker>::initAS3Object(i_builder);
		i_builder.addFunction("detectMarkerLite",S_NyARSingleDetectMarker::detectMarkerLite);
		i_builder.addFunction("getTransmationMatrix",S_NyARSingleDetectMarker::getTransmationMatrix);
		i_builder.addFunction("getConfidence",S_NyARSingleDetectMarker::getConfidence);
		i_builder.addFunction("getDirection",S_NyARSingleDetectMarker::getDirection);
		i_builder.addFunction("setContinueMode",S_NyARSingleDetectMarker::setContinueMode);
		return;
	}
private:
	static AS3_Val detectMarkerLite(void* self, AS3_Val args)
	{
		S_NyARSingleDetectMarker* inst;
		AlchemyClassStub<void*>* stub;
		int th;
		AS3_ArrayValue(args, "PtrType,PtrType,IntType", &inst,&stub,&th);
		const INyARRgbRaster* raster=(const INyARRgbRaster*)(stub->getRef());

		bool ret=((NyARSingleDetectMarker*)(inst->m_ref))->detectMarkerLite(*raster,th);
		return ret?AS3_True():AS3_False();
	}
	static AS3_Val getConfidence(void* self, AS3_Val args)
	{
		S_NyARSingleDetectMarker* inst;
		AS3_ArrayValue(args, "PtrType", &inst);
		return AS3_Number(inst->m_ref->getConfidence());
	}
	static AS3_Val getDirection(void* self, AS3_Val args)
	{
		S_NyARSingleDetectMarker* inst;
		AS3_ArrayValue(args, "PtrType", &inst);
		return AS3_Int(inst->m_ref->getDirection());
	}
	static AS3_Val getTransmationMatrix(void* self, AS3_Val args)
	{
		S_NyARSingleDetectMarker* inst;
		S_NyARTransMatResult* v;
		AS3_ArrayValue(args, "PtrType,PtrType", &inst,&v);
		((NyARSingleDetectMarker*)(inst->m_ref))->getTransmationMatrix(*((NyARTransMatResult*)(v->m_ref)));
		return AS3_Null();
	}
	static AS3_Val setContinueMode(void* self, AS3_Val args)
	{
		S_NyARSingleDetectMarker* inst;
		int v;
		AS3_ArrayValue(args, "PtrType,IntType", &inst,&v);
		((NyARSingleDetectMarker*)(inst->m_ref))->setContinueMode(v!=0?true:false);
		return AS3_Null();
	}
};
