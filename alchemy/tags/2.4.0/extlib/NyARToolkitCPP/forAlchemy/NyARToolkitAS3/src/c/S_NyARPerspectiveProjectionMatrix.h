#pragma once
#include "T_NyARDoubleMatrix34.h"
#include "NyARPerspectiveProjectionMatrix.h"

class S_NyARPerspectiveProjectionMatrix : public T_NyARDoubleMatrix34<NyARPerspectiveProjectionMatrix>
{
public:
	static AS3_Val createInstance(void* self, AS3_Val args)
	{
		S_NyARPerspectiveProjectionMatrix class_builder;
		return class_builder.buildWithNativeInstance(self,args);
	}
protected:
	//自身のオブジェクトをAS3オブジェクトにする。
	virtual void initAS3Member(AS3ObjectBuilder& i_builder,NyARPerspectiveProjectionMatrix* i_native_inst)
	{
		T_NyARDoubleMatrix34<NyARPerspectiveProjectionMatrix>::initAS3Member(i_builder,i_native_inst);
		i_builder.addFunction("decompMat",S_NyARPerspectiveProjectionMatrix::decompMat);
		return;
	}
	/*　AS3 Argument protocol
	 */
	virtual NyARPerspectiveProjectionMatrix* createNativeInstance(AS3_Val args)
	{
		return new NyARPerspectiveProjectionMatrix();
	}

public:
	/*　AS3 Argument protocol
	 * 	_native    : AlchemyClassStub<T>*
	 *  v          : AS3_ByteArray
	 */
	static AS3_Val decompMat(void* self, AS3_Val args)
	{
		//本来はNyARMatで転送すべきだけど、ByteArrayに配列突っ込んで転送する。
		//フォーマットは、o_cpara[3][4]o_trans[3][4]
		NyARPerspectiveProjectionMatrix* native;
		AS3_Val marshal;
		AS3_ArrayValue(args, "PtrType,AS3ValType", &native,&marshal);
		NyARMat c(3,4);
		NyARMat t(3,4);
		//数値計算
		native->decompMat(c,t);
		//byteArrayにコピー(cpara[12],trans[12]で格納)
		AS3_ByteArray_writeBytes(marshal,c.getArray(),sizeof(double)*12);
		AS3_ByteArray_writeBytes(marshal,t.getArray(),sizeof(double)*12);
		//引数の参照カウント減算
		AS3_Release(marshal);
		return AS3_Null();
	}


};
