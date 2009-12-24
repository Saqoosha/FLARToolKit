#pragma once
#include "NyARTransMatResult.h"
class S_NyARTransMatResult : public T_NyARDoubleMatrix34<NyARTransMatResult>
{
public:
	static AS3_Val createInstance(void* self, AS3_Val args)
	{
		S_NyARTransMatResult class_builder;
		return class_builder.buildWithNativeInstance(self,args);
	}
protected:
	//自身のオブジェクトをAS3オブジェクトにする。
	virtual void initAS3Member(AS3ObjectBuilder& i_builder,NyARTransMatResult* i_native_inst)
	{
		T_NyARDoubleMatrix34<NyARTransMatResult>::initAS3Member(i_builder,i_native_inst);
		i_builder.addFunction("getZXYAngle",S_NyARTransMatResult::getZXYAngle);
		return;
	}
	/*　AS3 Argument protocol
	 * _param : NyARParam*
	 */
	virtual NyARTransMatResult* createNativeInstance(AS3_Val args)
	{
		return new NyARTransMatResult();
	}
public:
	/*　AS3 Argument protocol
	 * _native	:NyARSquareStack
	 * index	:int
	 * return   :AS3_Val as double x,y,z
	 */
	static AS3_Val getZXYAngle(void* self, AS3_Val args)
	{
		NyARTransMatResult* native;
		AS3_Val v;
		AS3_ArrayValue(args, "PtrType, AS3ValType", &native,&v);
		TNyARDoublePoint3d ang;
		native->getZXYAngle(ang);
		double work[3];
		work[0]=ang.x;
		work[1]=ang.y;
		work[2]=ang.z;
		AS3_ByteArray_writeBytes(v,work,sizeof(double)*3);
		return AS3_Null();
	}

};
