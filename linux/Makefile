.PHONY: clean All

debug: 
	@echo "----------Building project:[ TinyFileDialogs (Debug) ]----------"
	@"$(MAKE)" -j4 -f "Debug.mk"

release: 
	@echo "----------Building project:[ TinyFileDialogs (Release) ]----------"
	@"$(MAKE)" -j4 -f "Release.mk"

clean:
	@echo "----------Cleaning project:[ TinyFileDialogs ]----------"
	@"$(MAKE)" -f "Debug.mk" clean
	@"$(MAKE)" -f "Release.mk" clean
