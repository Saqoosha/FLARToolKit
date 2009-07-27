#pragma once
#include "NyARPerspectiveProjectionMatrix.h"

class S_NyARPerspectiveProjectionMatrix : public T_NyARDoubleMatrix34<NyARPerspectiveProjectionMatrix>
{
public:
	//標準的なインスタンス生成関数です。
	static AS3_Val createInstance(void* self, AS3_Val args)
	{
		S_NyARPerspectiveProjectionMatrix* inst=new S_NyARPerspectiveProjectionMatrix();
		//初期化
		inst->initRelStub(new NyARPerspectiveProjectionMatrix());
		//AS3オブジェクト化
		return inst->toAS3Object();
	}
	static AS3_Val createReference(const NyARPerspectiveProjectionMatrix* i_ref)
	{
		S_NyARPerspectiveProjectionMatrix* inst=new S_NyARPerspectiveProjectionMatrix();
		//初期化
		inst->initRefStub(i_ref);
		//AS3オブジェクト化
		return inst->toAS3Object();
	}

	void initAS3Object(AS3ObjectBuilder& i_builder)
	{
		T_NyARDoubleMatrix34<NyARPerspectiveProjectionMatrix>::initAS3Object(i_builder);
		i_builder.addFunction("decompMat",S_NyARPerspectiveProjectionMatrix::decompMat);
	}

	static AS3_Val decompMat(void* self, AS3_Val args)
	{
		//本来はNyARMatで転送すべきだけど、ByteArrayに配列突っ込んで転送する。
		//フォーマットは、o_cpara[3][4]o_trans[3][4]
		S_NyARPerspectiveProjectionMatrix* inst;
		AS3_Val marshal;
		AS3_ArrayValue(args, "PtrType,AS3ValType", &inst,&marshal);
		NyARMat c(3,4);
		NyARMat t(3,4);
		//数値計算
		inst->m_ref->decompMat(c,t);
		//byteArrayにコピー(cpara[12],trans[12]で格納)
		AS3_ByteArray_writeBytes(marshal,c.getArray(),sizeof(double)*12);
		AS3_ByteArray_writeBytes(marshal,t.getArray(),sizeof(double)*12);
		//引数の参照カウント減算
		AS3_Release(marshal);
		return AS3_Null();
	}


};
