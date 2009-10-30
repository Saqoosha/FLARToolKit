#pragma once
#include "INyARRasterThresholdAnalyzer.h"
#include "INyARRgbRaster.h"
template<class T> class T_INyARRasterThresholdAnalyzer : public AlchemyClassBuilder<T>
{
public:
	virtual void initAS3Member(AS3ObjectBuilder& i_builder,T* i_native_inst)
	{
		AlchemyClassBuilder<T>::initAS3Member(i_builder,i_native_inst);
		i_builder.addFunction("analyzeRaster",T_INyARRasterThresholdAnalyzer<T>::analyzeRaster);
		i_builder.addFunction("getThreshold",T_INyARRasterThresholdAnalyzer<T>::getThreshold);
		return;
	}
protected:
	/*　AS3 Argument protocol
	 * 	_native    : T*
	 *  in_raster  : INyARRaster*
	 */
	static AS3_Val analyzeRaster(void* self, AS3_Val args)
	{
		T* native;
		INyARRaster* input;
		AS3_ArrayValue(args, "PtrType", &native,&input);
		native->analyzeRaster(*input);
		return AS3_Null();
	}
	/*　AS3 Argument protocol
	 * 	_native    : T*
	 */
	static AS3_Val getThreshold(void* self, AS3_Val args)
	{
		T* native;
		AS3_ArrayValue(args, "PtrType", &native);		
		return AS3_Int(native->getThreshold());
	}
};
