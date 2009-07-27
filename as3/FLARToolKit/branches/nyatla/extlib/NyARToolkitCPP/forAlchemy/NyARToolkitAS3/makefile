.SUFFIXES: .cpp .c .o

NAME_TARGET_SWC=nyartoolkit
ALC_ON=source ../script/alc-on.sh
ALC_OFF=source ../script/alc-off.sh


#wrapper

SRC_ALC= src/c/NyARToolkitAS3.cpp
OBJ_ALC=$(addprefix obj/nya/,$(patsubst %.cpp,%.o,$(notdir $(SRC_ALC))))



AS3_INC=src/as3 ../AlchemyMaster/as3




#nyartoolkit

ALC_INC=../AlchemyMaster/c
NYA_INC=$(addprefix ../../, inc inc/core inc/core2 inc/utils inc/nyidmarker inc/processor)

SRC_NYA_CORE= $(shell ls ../../src/core/*.cpp)
OBJ_NYA_CORE=$(patsubst ../../src/core/%.cpp,obj/alc/%.o,$(SRC_NYA_CORE))

SRC_NYA_CORE2= $(shell ls ../../src/core2/*.cpp)
OBJ_NYA_CORE2=$(patsubst ../../src/core2/%.cpp,obj/alc/%.o,$(SRC_NYA_CORE2))

SRC_NYA_UTILS= $(shell ls ../../src/utils/*.cpp)
OBJ_NYA_UTILS=$(patsubst ../../src/utils/%.cpp,obj/alc/%.o,$(SRC_NYA_UTILS))

SRC_NYA_PROC= $(shell ls ../../src/processor/*.cpp)
OBJ_NYA_PROC=$(patsubst ../../src/processor/%.cpp,obj/alc/%.o,$(SRC_NYA_PROC))

SRC_NYA_IDMK= $(shell ls ../../src/nyidmarker/*.cpp)
OBJ_NYA_IDMK=$(patsubst ../../src/nyidmarker/%.cpp,obj/alc/%.o,$(SRC_NYA_IDMK))


OBJ_SWC=$(OBJ_ALC) $(OBJ_NYA_CORE) $(OBJ_NYA_CORE2) $(OBJ_NYA_UTILS) $(OBJ_NYA_PROC) $(OBJ_NYA_IDMK)
#command




all:rawtest.swf idtest.swf
obj:$(OBJ_SWC)
swc:lib/$(NAME_TARGET_SWC).swc
	

clean:
	cd obj/alc;rm -f *.o
	cd obj/nya;rm -f *.o
	cd lib;rm -f *.swc







rawtest.swf:lib/$(NAME_TARGET_SWC).swc
	mxmlc -library-path+=lib/$(NAME_TARGET_SWC).swc $(addprefix -source-path+=,$(AS3_INC)) --target-player=10.0.0 sample/rawtest.as

idtest.swf:lib/$(NAME_TARGET_SWC).swc
	mxmlc -library-path+=lib/$(NAME_TARGET_SWC).swc $(addprefix -source-path+=,$(AS3_INC)) --target-player=10.0.0 sample/idtest.as




lib/$(NAME_TARGET_SWC).swc:$(OBJ_SWC)
	$(ALC_ON);cd lib;g++ -swc -O3 $(addprefix ../,$^) -o $(notdir $@);cd ..;$(ALC_OFF)


obj/nya/%.o:src/c/%.cpp
	$(ALC_ON);g++ -O3 $(addprefix -I,$(NYA_INC) $(ALC_INC)) $(CFLAGS) -c $< -o $@ ;$(ALC_OFF)

obj/alc/%.o:../../src/core/%.cpp
	$(ALC_ON);g++ -O3 $(addprefix -I,$(NYA_INC)) $(CFLAGS) -c $< -o $@ ;$(ALC_OFF)
	
obj/alc/%.o:../../src/utils/%.cpp
	$(ALC_ON);g++ -O3 $(addprefix -I,$(NYA_INC)) $(CFLAGS) -c $< -o $@ ;$(ALC_OFF)

obj/alc/%.o:../../src/core2/%.cpp
	$(ALC_ON);g++ -O3 $(addprefix -I,$(NYA_INC)) $(CFLAGS) -c $< -o $@ ;$(ALC_OFF)

obj/alc/%.o:../../src/processor/%.cpp
	$(ALC_ON);g++ -O3 $(addprefix -I,$(NYA_INC)) $(CFLAGS) -c $< -o $@ ;$(ALC_OFF)

obj/alc/%.o:../../src/nyidmarker/%.cpp
	$(ALC_ON);g++ -O3 $(addprefix -I,$(NYA_INC)) $(CFLAGS) -c $< -o $@ ;$(ALC_OFF)