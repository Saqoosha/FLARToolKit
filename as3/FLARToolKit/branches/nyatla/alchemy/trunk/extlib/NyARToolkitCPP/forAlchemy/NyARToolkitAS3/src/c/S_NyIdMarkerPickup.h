#pragma once
#include "NyIdMarkerPickup.h"
#include "NyIdMarkerPattern.h"
#include "NyIdMarkerParam.h"
class S_NyIdMarkerPickup: public AlchemyClassBuilder<NyIdMarkerPickup>
{
public:
	static AS3_Val createInstance(void* self, AS3_Val args)
	{
		S_NyIdMarkerPickup class_builder;
		return class_builder.buildWithNativeInstance(self,args);
	}
protected:
	//自身のオブジェクトをAS3オブジェクトにする。
	virtual void initAS3Member(AS3ObjectBuilder& i_builder,NyIdMarkerPickup* i_native_inst)
	{
		AlchemyClassBuilder<NyIdMarkerPickup>::initAS3Member(i_builder,i_native_inst);
		i_builder.addFunction("pickFromRaster",S_NyIdMarkerPickup::pickFromRaster);
		return;
	}
	/*　AS3 Argument protocol
	 */
	virtual NyIdMarkerPickup* createNativeInstance(AS3_Val args)
	{
		return new NyIdMarkerPickup();
	}

private:
	/*　AS3 Argument protocol
	 * 	_native    : S_NyARMatchPatt_Color_WITHOUT_PCA*
	 *  image      : NyARMatchPattDeviationColorData*
	 *  i_square   : TNyARMatchPattResult*
	 *  o_data     : NyIdMarkerPattern
	 *  o_param    : NyIdMarkerParam
	 *  return     : AS3_Val as Boolean
	 */
	static AS3_Val pickFromRaster(void* self, AS3_Val args)
	{
		NyIdMarkerPickup* native;
		INyARRgbRaster* image;
		NyARSquare* i_square;
		TNyIdMarkerPattern* o_data;
		TNyIdMarkerParam* o_param;
		AS3_ArrayValue(args, "PtrType,PtrType,PtrType,PtrType,PtrType", &native,&image,&i_square,&o_data,&o_param);
		bool ret=native->pickFromRaster(*image,*i_square,*o_data,*o_param);
		return ret?AS3_True():AS3_False();
	}

};
