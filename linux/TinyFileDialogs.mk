##
## Auto Generated makefile by CodeLite IDE
## any manual changes will be erased      
##
## Debug
LinkerName             := g++
ObjectSuffix           := .o
DependSuffix           := .o.d
PreprocessSuffix       := .o.i
DebugSwitch            := -gstab
IncludeSwitch          := -I
LibrarySwitch          := -l
OutputSwitch           := -o 
LibraryPathSwitch      := -L
PreprocessorSwitch     := -D
SourceSwitch           := -c 
OutputFile             := $(IntermediateDirectory)/$(ProjectName).so
ObjectSwitch           := -o 
ArchiveOutputSwitch    := 
PreprocessOnlySwitch   := -E 
ObjectsFileList        := "tinyFileDialogs.txt"
PCHCompileFlags        :=
MakeDirCommand         := mkdir -p
LinkOptions            :=  
IncludePath            := $(IncludeSwitch). $(IncludeSwitch)/opt/Solar2D/Resources/PluginDependencies/shared/include/corona/lua $(IncludeSwitch)/opt/Solar2D/Resources/PluginDependencies/shared/include/corona/
IncludePCH             := 
RcIncludePath          := 
Libs                   := 
ArLibs                 :=  
LibPath                := $(LibraryPathSwitch). 

##
## Common variables
## AR, CXX, CC, AS, CXXFLAGS and CFLAGS can be overriden using an environment variables
##
AR       := ar rcus
CXX      := g++
CC       := gcc
ASFLAGS  := 
AS       := as


##
## User defined environment variables
##
Objects0=$(IntermediateDirectory)/up_shared_tinyfiledialogs.c$(ObjectSuffix) $(IntermediateDirectory)/up_shared_plugin.tinyFileDialogs.cpp$(ObjectSuffix) 
Objects=$(Objects0) 

##
## Main Build Targets 
##
.PHONY: all clean PreBuild PrePreBuild PostBuild MakeIntermediateDirs
all: $(OutputFile)

$(OutputFile): $(IntermediateDirectory)/.d $(Objects) 
	@$(MakeDirCommand) $(@D)
	@echo "" > $(IntermediateDirectory)/.d
	@echo $(Objects0)  > $(ObjectsFileList)
	$(SharedObjectLinkerName) $(OutputSwitch)$(OutputFile) @$(ObjectsFileList) $(LibPath) $(Libs) $(LinkOptions)
	@$(MakeDirCommand) "./.build-debug"
	@echo rebuilt > "./tinyFileDialogs"

MakeIntermediateDirs:
	@test -d $(ConfigurationName) || $(MakeDirCommand) $(ConfigurationName)


$(IntermediateDirectory)/.d:
	@test -d $(ConfigurationName) || $(MakeDirCommand) $(ConfigurationName)

PreBuild:


##
## Objects
##
$(IntermediateDirectory)/up_shared_tinyfiledialogs.c$(ObjectSuffix): ../shared/tinyfiledialogs.c
	@$(CC) $(CFLAGS) $(IncludePath) -MG -MP -MT$(IntermediateDirectory)/up_shared_tinyfiledialogs.c$(ObjectSuffix) -MF$(IntermediateDirectory)/up_shared_tinyfiledialogs.c$(DependSuffix) -MM ../shared/tinyfiledialogs.c
	$(CC) $(SourceSwitch) "../shared/tinyfiledialogs.c" $(CFLAGS) $(ObjectSwitch)$(IntermediateDirectory)/up_shared_tinyfiledialogs.c$(ObjectSuffix) $(IncludePath)
$(IntermediateDirectory)/up_shared_tinyfiledialogs.c$(PreprocessSuffix): ../shared/tinyfiledialogs.c
	$(CC) $(CFLAGS) $(IncludePath) $(PreprocessOnlySwitch) $(OutputSwitch) $(IntermediateDirectory)/up_shared_tinyfiledialogs.c$(PreprocessSuffix) ../shared/tinyfiledialogs.c

$(IntermediateDirectory)/up_shared_plugin.tinyFileDialogs.cpp$(ObjectSuffix): ../shared/plugin.tinyFileDialogs.cpp
	@$(CXX) $(CXXFLAGS) $(IncludePCH) $(IncludePath) -MG -MP -MT$(IntermediateDirectory)/up_shared_plugin.tinyFileDialogs.cpp$(ObjectSuffix) -MF$(IntermediateDirectory)/up_shared_plugin.tinyFileDialogs.cpp$(DependSuffix) -MM ../shared/plugin.tinyFileDialogs.cpp
	$(CXX) $(IncludePCH) $(SourceSwitch) "../shared/plugin.tinyFileDialogs.cpp" $(CXXFLAGS) $(ObjectSwitch)$(IntermediateDirectory)/up_shared_plugin.tinyFileDialogs.cpp$(ObjectSuffix) $(IncludePath)
$(IntermediateDirectory)/up_shared_plugin.tinyFileDialogs.cpp$(PreprocessSuffix): ../shared/plugin.tinyFileDialogs.cpp
	$(CXX) $(CXXFLAGS) $(IncludePCH) $(IncludePath) $(PreprocessOnlySwitch) $(OutputSwitch) $(IntermediateDirectory)/up_shared_plugin.tinyFileDialogs.cpp$(PreprocessSuffix) ../shared/plugin.tinyFileDialogs.cpp


-include $(IntermediateDirectory)/*$(DependSuffix)
##
## Clean
##
clean:
	$(RM) -r $(ConfigurationName)/


