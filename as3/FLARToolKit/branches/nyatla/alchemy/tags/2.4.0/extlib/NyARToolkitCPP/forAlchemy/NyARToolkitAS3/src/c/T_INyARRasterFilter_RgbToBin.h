#pragma once
#include "NyARBinRaster.h"
#include "INyARRgbRaster.h"
template<class T> class T_INyARRasterFilter_RgbToBin : public AlchemyClassBuilder<T>
{
public:
	virtual void initAS3Member(AS3ObjectBuilder& i_builder,T* i_native_inst)
	{
		AlchemyClassBuilder<T>::initAS3Member(i_builder,i_native_inst);
		i_builder.addFunction("doFilter",T_INyARRasterFilter_RgbToBin<T>::doFilter);
		return;
	}
protected:
	/*　AS3 Argument protocol
	 * 	_native    : T*
	 *  in_raster  : INyARRgbRaster*
	 *  out_raster : NyARBinRaster*
	 */
	static AS3_Val doFilter(void* self, AS3_Val args)
	{
		T* native;
		INyARRgbRaster* in_raster;
		NyARBinRaster* out_raster;
		AS3_ArrayValue(args, "PtrType,PtrType,PtrType", &native,&in_raster,&out_raster);
		native->doFilter(*in_raster,*out_raster);
		return AS3_Null();
	}
};
