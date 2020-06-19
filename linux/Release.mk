ProjectName            := plugin.tinyFileDialogs
ConfigurationName      := Release
IntermediateDirectory  := $(ConfigurationName)
OutDir                 := $(IntermediateDirectory)
Preprocessors          :=
SharedObjectLinkerName := g++ -shared -fPIC -s
CXXFLAGS               := -O2 -g3 -fPIC -std=c++11 -Wfatal-errors -Wno-narrowing $(Preprocessors)
CFLAGS                 := -O2 -g3 -fPIC -Wall $(Preprocessors)

export

all: 
	@"$(MAKE)" -f "TinyFileDialogs.mk" PreBuild && "$(MAKE)" -j4 -f "TinyFileDialogs.mk" && "$(MAKE)" -f "TinyFileDialogs.mk" PostBuild

clean:
	rm -f $(OutDir)/$(ProjectName)
	@"$(MAKE)" -f "TinyFileDialogs.mk" clean
