ARCH = $(shell uname)

# user-configuration section

EXRINCLUDE=-I/usr/local/include/OpenEXR -I/usr/include/OpenEXR
EXRLIBDIR=-L/usr/local/lib
DEFS_DEFAULT= -DPBRT_HAS_PTHREADS -DPBRT_HAS_OPENEXR  #-DPBRT_STATS_NONE -DPBRT_HAS_PTHREADS -DPBRT_HAS_OPENEXR
DEFS=$(DEFS_DEFAULT) -DPBRT_STATS_COUNTERS -DDEBUG_OUTPUT #-DGPU_PROFILE -DDEBUG -DSTAT_RAY_TRIANGLE

# 32 bit
DEFS+=-DPBRT_POINTER_SIZE=4
MARCH=-m32

# 64 bit
#DEFS+=-DPBRT_POINTER_SIZE=8 -DPBRT_HAS_64_BIT_ATOMICS
#MARCH=-m64

#########################################################################

LEX=flex
YACC=bison -d -v -t
LEXLIB = -lfl

ATISTREAMSDKROOT=/home/hanci/ati-stream-sdk-v2.2-lnx32/
OPENCLINCLUDE=-I$(ATISTREAMSDKROOT)include
OPENCLLIBS=-L$(ATISTREAMSDKROOT)lib/x86 -lOpenCL

#OPENCLINCLUDE=-I$(HOME)/NVIDIA_GPU_Computing_SDK/sdk/shared/inc -I$(HOME)/NVIDIA_GPU_Computing_SDK/OpenCL/common/inc
#OPENCLLIBS=-L$(HOME)/NVIDIA_GPU_Computing_SDK/OpenCL/common/lib -L$(HOME)/NVIDIA_GPU_Computing_SDK/sdk/shared/lib -L$(HOME)/NVIDIA_GPU_Computing_SDK/OpenCL/common/lib -L/home/hanci/NVIDIA_GPU_Computing_SDK/shared/lib -loclUtil -lOpenCL  -lshrutil

EXRLIBS=$(EXRLIBDIR) -Bstatic -lIex -lIlmImf -lIlmThread -lImath -lIex -lHalf -Bdynamic
ifeq ($(ARCH),Linux)
  EXRLIBS += -lpthread
endif
ifeq ($(ARCH),OpenBSD)
  EXRLIBS += -lpthread
endif
ifeq ($(ARCH),Darwin)
  EXRLIBS += -lz
endif

CC=gcc
CXX=g++
LD=$(CXX) $(OPT)
#-O2
OPT=$(MARCH) -msse2 -mfpmath=sse
INCLUDE=-I. -Icore $(EXRINCLUDE) $(OPENCLINCLUDE)
WARN=-Wall
CWD=$(shell pwd)
CXXFLAGS=$(OPT) $(INCLUDE) $(WARN) $(DEFS) -g #-pg -g
CCFLAGS=$(CXXFLAGS)
LIBS=$(LEXLIB) $(EXRLIBDIR) $(EXRLIBS) -lm $(OPENCLLIBS)
LIBSRCS=$(wildcard core/*.cpp) core/pbrtlex.cpp core/pbrtparse.cpp
LIBSRCS += $(wildcard accelerators/*.cpp cameras/*.cpp film/*.cpp filters/*.cpp )
LIBSRCS += $(wildcard integrators/*.cpp lights/*.cpp materials/*.cpp renderers/*.cpp )
LIBSRCS += $(wildcard samplers/*.cpp shapes/*.cpp textures/*.cpp volumes/*.cpp )
LIBSRCS += $(wildcard cl/cmd_arg_reader.cpp cl/oclUtils.cpp cl/shrUtils.cpp cl/stopwatch.cpp cl/stopwatch_linux.cpp)

LIBOBJS=$(addprefix objs/, $(subst /,_,$(LIBSRCS:.cpp=.o)))

HEADERS = $(wildcard */*.h)

default: bin/pbrt #tools

pbrt: bin/pbrt

dirs:
	/bin/mkdir -p bin objs

$(LIBOBJS): $(HEADERS)

.PHONY: dirs tools exrcheck

objs/libpbrt.a: $(LIBOBJS)
	@echo "Building the core rendering library (libpbrt.a)"
	@ar rcs $@ $(LIBOBJS)

objs/cl_%.o: cl/%.cpp
	@echo "Building object $@"
	@$(CXX) $(CXXFLAGS) -o $@ -c $<

objs/accelerators_%.o: accelerators/%.cpp
	@echo "Building object $@"
	@$(CXX) $(CXXFLAGS) -o $@ -c $<

objs/cameras_%.o: cameras/%.cpp
	@echo "Building object $@"
	@$(CXX) $(CXXFLAGS) -o $@ -c $<

objs/core_%.o: core/%.cpp
	@echo "Building object $@"
	@$(CXX) $(CXXFLAGS) -o $@ -c $<

objs/film_%.o: film/%.cpp
	@echo "Building object $@"
	@$(CXX) $(CXXFLAGS) -o $@ -c $<

objs/filters_%.o: filters/%.cpp
	@echo "Building object $@"
	@$(CXX) $(CXXFLAGS) -o $@ -c $<

objs/integrators_%.o: integrators/%.cpp
	@echo "Building object $@"
	@$(CXX) $(CXXFLAGS) -o $@ -c $<

objs/lights_%.o: lights/%.cpp
	@echo "Building object $@"
	@$(CXX) $(CXXFLAGS) -o $@ -c $<

objs/main_%.o: main/%.cpp
	@echo "Building object $@"
	@$(CXX) $(CXXFLAGS) -o $@ -c $<

objs/materials_%.o: materials/%.cpp
	@echo "Building object $@"
	@$(CXX) $(CXXFLAGS) -o $@ -c $<

objs/renderers_%.o: renderers/%.cpp
	@echo "Building object $@"
	@$(CXX) $(CXXFLAGS) -o $@ -c $<

objs/samplers_%.o: samplers/%.cpp
	@echo "Building object $@"
	@$(CXX) $(CXXFLAGS) -o $@ -c $<

objs/shapes_%.o: shapes/%.cpp
	@echo "Building object $@"
	@$(CXX) $(CXXFLAGS) -o $@ -c $<

objs/textures_%.o: textures/%.cpp
	@echo "Building object $@"
	@$(CXX) $(CXXFLAGS) -o $@ -c $<

objs/volumes_%.o: volumes/%.cpp
	@echo "Building object $@"
	@$(CXX) $(CXXFLAGS) -o $@ -c $<

objs/pbrt.o: main/pbrt.cpp
	@echo "Building object $@"
	@$(CXX) $(CXXFLAGS) -o $@ -c $<

bin/pbrt: dirs objs/libpbrt.a objs/pbrt.o
	@echo "Linking $@"
	@$(CXX) $(CXXFLAGS) -o $@ objs/pbrt.o objs/libpbrt.a $(LIBS)

core/pbrtlex.cpp: core/pbrtlex.ll core/pbrtparse.cpp
	@echo "Lex'ing pbrtlex.ll"
	@$(LEX) -o$@ core/pbrtlex.ll

core/pbrtparse.cpp: core/pbrtparse.yy
	@echo "YACC'ing pbrtparse.yy"
	@$(YACC) -o $@ core/pbrtparse.yy
	@if [ -e core/pbrtparse.cpp.h ]; then /bin/mv core/pbrtparse.cpp.h core/pbrtparse.hh; fi
	@if [ -e core/pbrtparse.hpp ]; then /bin/mv core/pbrtparse.hpp core/pbrtparse.hh; fi

$(RENDERER_BINARY): $(RENDERER_OBJS) $(CORE_LIB)

myclean:
	rm -f objs/accelerators_rayhierarchy.o objs/core_GPUparallel.o

clean:
	rm -f objs/* bin/* core/pbrtlex.[ch]* core/pbrtparse.[ch]*
	#(cd tools && $(MAKE) clean)

cleandefault:
	rm -f objs/* bin/* core/pbrtlex.[ch]* core/pbrtparse.[ch]*
	#(cd tools && $(MAKE) clean)

objs/exrio.o: exrcheck

exrcheck:
	@echo -n Checking for EXR installation...
	@$(CXX) $(CXXFLAGS) -o exrcheck exrcheck.cpp $(LIBS) || \
		(cat exrinstall.txt; exit 1)
