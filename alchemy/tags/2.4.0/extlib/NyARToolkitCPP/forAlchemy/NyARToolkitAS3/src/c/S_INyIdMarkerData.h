#pragma once
#include "INyIdMarkerData.h"
#include "T_INyIdMarkerData.h"
class S_INyIdMarkerData : public T_INyIdMarkerData<INyIdMarkerData>
{
public:
	static AS3_Val createInstance(void* self, AS3_Val args)
	{
		S_NyIdMarkerData_RawBit class_builder;
		return class_builder.buildWithNativeInstance(self,args);
	}
protected:
	//自身のオブジェクトをAS3オブジェクトにする。
	virtual void initAS3Member(AS3ObjectBuilder& i_builder,INyIdMarkerData* i_native_inst)
	{
		T_INyIdMarkerData<INyIdMarkerData>::initAS3Member(i_builder,i_native_inst);
		return;
	}
	/*　AS3 Argument protocol
	 */
	virtual INyIdMarkerData* createNativeInstance(AS3_Val args)
	{
		//このクラスはインスタンス化出来ない。
		return NULL;
	}



};
