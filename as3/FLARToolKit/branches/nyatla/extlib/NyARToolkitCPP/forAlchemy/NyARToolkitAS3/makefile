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
NYA_INC=$(addprefix ../../, inc inc/core inc/core2 inc/utils)

SRC_NYA_CORE= $(shell ls ../../src/core/*.cpp)
OBJ_NYA_CORE=$(patsubst ../../src/core/%.cpp,obj/alc/%.o,$(SRC_NYA_CORE))

SRC_NYA_CORE2= $(shell ls ../../src/core2/*.cpp)
OBJ_NYA_CORE2=$(patsubst ../../src/core2/%.cpp,obj/alc/%.o,$(SRC_NYA_CORE2))

SRC_NYA_UTILS= $(shell ls ../../src/utils/*.cpp)
OBJ_NYA_UTILS=$(patsubst ../../src/utils/%.cpp,obj/alc/%.o,$(SRC_NYA_UTILS))




#command

AS3_SAMPLE=sample/rawtest.as


all:rawtest.swf
obj:$(OBJ_ALC) $(OBJ_NYA_CORE) $(OBJ_NYA_CORE2) $(OBJ_NYA_UTILS)
swc:lib/$(NAME_TARGET_SWC).swc
	

clean:
	cd obj/alc;rm -f *.o
	cd obj/nya;rm -f *.o
	cd lib;rm -f *.swc







rawtest.swf:lib/$(NAME_TARGET_SWC).swc
	mxmlc -library-path+=lib/$(NAME_TARGET_SWC).swc $(addprefix -source-path+=,$(AS3_INC)) --target-player=10.0.0 $(AS3_SAMPLE)





lib/$(NAME_TARGET_SWC).swc:$(OBJ_ALC) $(OBJ_NYA_CORE) $(OBJ_NYA_CORE2) $(OBJ_NYA_UTILS)
	$(ALC_ON);cd lib;g++ -swc $(addprefix ../,$^) -o $(notdir $@);cd ..;$(ALC_OFF)


obj/nya/%.o:src/c/%.cpp
	$(ALC_ON);g++ $(addprefix -I,$(NYA_INC) $(ALC_INC)) $(CFLAGS) -c $< -o $@ ;$(ALC_OFF)

obj/alc/%.o:../../src/core/%.cpp
	$(ALC_ON);g++ $(addprefix -I,$(NYA_INC)) $(CFLAGS) -c $< -o $@ ;$(ALC_OFF)
	
obj/alc/%.o:../../src/utils/%.cpp
	$(ALC_ON);g++ $(addprefix -I,$(NYA_INC)) $(CFLAGS) -c $< -o $@ ;$(ALC_OFF)

obj/alc/%.o:../../src/core2/%.cpp
	$(ALC_ON);g++ $(addprefix -I,$(NYA_INC)) $(CFLAGS) -c $< -o $@ ;$(ALC_OFF)
