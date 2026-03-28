PROJECTM_PREFIX ?= ../../../../../mxe/usr/x86_64-w64-mingw32.shared

CXX ?= g++
CXXFLAGS ?= -O2 -g
CPPFLAGS ?=
LDFLAGS ?=

INCLUDES = -I. -I$(PROJECTM_PREFIX)/include -I$(PROJECTM_PREFIX)/include/libprojectM
LIBDIR = $(PROJECTM_PREFIX)/lib
PROJECTM_LIBDIR ?= $(PROJECTM_PREFIX)/bin
PROJECTM_LIBNAME ?= projectM

TARGET = projectM-cwrapper.dll
OBJECTS = projectM-cwrapper.o

.PHONY: all clean

all: $(TARGET)

$(TARGET): $(OBJECTS)
	$(CXX) -shared \
		$(LDFLAGS) -L$(LIBDIR) -L$(PROJECTM_LIBDIR) -o $@ $^ -l$(PROJECTM_LIBNAME)

%.o: %.cpp
	$(CXX) $(CPPFLAGS) $(CXXFLAGS) $(INCLUDES) -c $< -o $@

clean:
	rm -f $(TARGET) $(OBJECTS)
