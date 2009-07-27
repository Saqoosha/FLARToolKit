#pragma once
#include "INyIdMarkerDataEncoder.h"
#include "S_INyIdMarkerData.h"
class S_INyIdMarkerDataEncoder : public AlchemyClassStub<INyIdMarkerDataEncoder>
{
public:
	void initAS3Object(AS3ObjectBuilder& i_builder)
	{
		AlchemyClassStub<INyIdMarkerDataEncoder>::initAS3Object(i_builder);
	}
	virtual S_INyIdMarkerData* createDataInstance()const=0;
};
