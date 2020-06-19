ProjectName            := plugin.tinyFileDialogs
ConfigurationName      := Debug
IntermediateDirectory  := $(ConfigurationName)
OutDir                 := $(IntermediateDirectory)
Preprocessors          :=
SharedObjectLinkerName := g++ -shared -fPIC
CXXFLAGS               := -O0 -g3 -fPIC -std=c++11 -Wfatal-errors -Wno-narrowing $(Preprocessors)
CFLAGS                 := -O0 -g3 -fPIC -Wall $(Preprocessors)

export

all: 
	@"$(MAKE)" -f "TinyFileDialogs.mk" PreBuild && "$(MAKE)" -j4 -f "TinyFileDialogs.mk" && "$(MAKE)" -f "TinyFileDialogs.mk" PostBuild

clean:
	rm -f $(OutDir)/$(ProjectName)
	@"$(MAKE)" -f "TinyFileDialogs.mk" clean
