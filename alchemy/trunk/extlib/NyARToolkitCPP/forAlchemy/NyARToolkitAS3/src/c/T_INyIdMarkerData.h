#pragma once
#include "INyIdMarkerData.h"
template<class T> class T_INyIdMarkerData : public AlchemyClassBuilder<T>
{
public:

	virtual void initAS3Member(AS3ObjectBuilder& i_builder,T* i_native_inst)
	{
		AlchemyClassBuilder<T>::initAS3Member(i_builder,i_native_inst);
		i_builder.addFunction("isEqual",T_INyIdMarkerData<T>::isEqual);
		i_builder.addFunction("copyFrom",T_INyIdMarkerData<T>::copyFrom);
		return;
	}
private:
	/*　AS3 Argument protocol
	 * 	_native    : T*
	 *  i_target   : INyIdMarkerData*
	 *  return     : AS3_Val as Boolean
	 */
	static AS3_Val isEqual(void* self, AS3_Val args)
	{
		T* native;
		T* i_target;

		AS3_ArrayValue(args, "PtrType,PtrType", &native,&i_target);
		//APIコール
		return native->isEqual(*i_target)?AS3_True():AS3_False();
	}
	/*　AS3 Argument protocol
	 * 	_native    : T*
	 *  i_target   : INyIdMarkerData*
	 */
	static AS3_Val copyFrom(void* self, AS3_Val args)
	{
		T* native;
		T* i_target;

		AS3_ArrayValue(args, "PtrType,PtrType", &native,&i_target);
		//APIコール
		native->copyFrom(*i_target);
		return AS3_Null();
	}
};
