#pragma once
#include "INyIdMarkerDataEncoder.h"
#include "NyIdMarkerPattern.h"
#include "S_INyIdMarkerData.h"
template<class T,class TSData,class TData> class T_INyIdMarkerDataEncoder : public AlchemyClassBuilder<T>
{
public:
	virtual void initAS3Member(AS3ObjectBuilder& i_builder,T* i_native_inst)
	{
		AlchemyClassBuilder<T>::initAS3Member(i_builder,i_native_inst);
		i_builder.addFunction("encode",T_INyIdMarkerDataEncoder<T,TSData,TData>::encode);
		i_builder.addFunction("createDataInstance",T_INyIdMarkerDataEncoder<T,TSData,TData>::createDataInstance);
		return;
	}

	/*　AS3 Argument protocol
	 * 	_native    : T*
	 *  i_data     : NyIdMarkerPattern*
	 *  o_dest     : INyIdMarkerData*
	 *  return     : AS_Val al Boolean
	 */
	static AS3_Val encode(void* self, AS3_Val args)
	{
		T* native;
		TNyIdMarkerPattern* i_data;
		INyIdMarkerData* o_dest;

		AS3_ArrayValue(args, "PtrType,PtrType,PtrType", &native,&i_data,&o_dest);
		//APIコール
		return native->encode(*i_data,*o_dest)?AS3_True():AS3_False();
	}
	/*　AS3 Argument protocol
	 * 	_native    : T*
	 */
	static AS3_Val createDataInstance(void* self, AS3_Val args)
	{
		T* native;
		AS3_ArrayValue(args, "PtrType", &native);

		//APIコール
		TSData class_builder;
		return class_builder.buildWithOutNativeInstance((TData*)native->createDataInstance());
	}
};
