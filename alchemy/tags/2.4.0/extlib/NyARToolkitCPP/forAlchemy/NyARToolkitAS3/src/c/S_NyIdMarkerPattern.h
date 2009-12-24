#pragma once
#include "NyIdMarkerPattern.h"

class S_NyIdMarkerPattern: public AlchemyClassBuilder<TNyIdMarkerPattern>
{
public:
	static AS3_Val createInstance(void* self, AS3_Val args)
	{
		S_NyIdMarkerPattern class_builder;
		return class_builder.buildWithNativeInstance(self,args);
	}
protected:
	//自身のオブジェクトをAS3オブジェクトにする。
	virtual void initAS3Member(AS3ObjectBuilder& i_builder,TNyIdMarkerPattern* i_native_inst)
	{
		AlchemyClassBuilder<TNyIdMarkerPattern>::initAS3Member(i_builder,i_native_inst);
		return;
	}
	/*　AS3 Argument protocol
	 */
	virtual TNyIdMarkerPattern* createNativeInstance(AS3_Val args)
	{
		return new TNyIdMarkerPattern();
	}
};
