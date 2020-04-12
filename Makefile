# ------------------------------------------------------------------------------
# Editable variables
# ------------------------------------------------------------------------------

APP_AUTHOR=Your Name
APP_NAME=App Name
BINARY_NAME=app_executable_filename
BUNDLE_IDENTIFIER=com.your.bundle.name
ICON_FILE=Your_Icon_File.icns
APP_VERSION=1
APP_SHORT_VERSION=1.0
MINIMUM_MACOS_VERSION=`sw_vers -productVersion | cut -d '.' -f 1,2`
COPYRIGHT_STRING=Copyright © `date +'%Y'` $(APP_AUTHOR). All rights reserved.

# ------------------------------------------------------------------------------
# Build variables
# ------------------------------------------------------------------------------

CC = clang
SOURCES=ApplicationController.m main.m
FRAMEWORKS:= -framework Foundation -framework Cocoa -framework AppKit
LIBRARIES:= -lobjc
CFLAGS=-Wall -Werror -arch x86_64 -DAPP_MENU_STRING="@\"$(APP_NAME)\"" -g -v $(SOURCES)
LDFLAGS=$(LIBRARIES) $(FRAMEWORKS)
PLIST_BUILD_MACHINE_OS_BUILD_STRING=`sw_vers -buildVersion`
PLIST_BUNDLE_EXECUTABLE_STRING=$(BINARY_NAME)
PLIST_BUNDLE_ICON_FILE_STRING=$(ICON_FILE)
PLIST_BUNDLE_IDENTIFIER_STRING=$(BUNDLE_IDENTIFIER)
PLIST_BUNDLE_NAME_STRING=$(APP_NAME)
PLIST_BUNDLE_PACKAGE_TYPE_STRING=APPL
PLIST_BUNDLE_SHORT_VERSION_STRING=$(APP_SHORT_VERSION)
PLIST_BUNDLE_VERSION_STRING=$(APP_VERSION)
PLIST_MINIMUM_SYSTEM_VERSION_STRING=$(MINIMUM_MACOS_VERSION)
PLIST_HUMAN_READABLE_COPYRIGHT_STRING=$(COPYRIGHT_STRING)
PLIST_BUNDLE_SIGNATURE_STRING=????
OUT=-o "$(BINARY_NAME)"

all: $(SOURCES) $(OUT) build_app

$(OUT): $(OBJECTS)
	$(CC) -o $(OBJECTS) $@ $(CFLAGS) $(LDFLAGS) $(OUT)

.m.o: 
	$(CC) -c -Wall $< -o $@

build_app:
	mkdir -p "$(APP_NAME).app"/Contents/{MacOS,Resources}
	cp Info.plist "$(APP_NAME).app/Contents"
	sed -e "s/BUILD_MACHINE_OS_BUILD_STRING/$(PLIST_BUILD_MACHINE_OS_BUILD_STRING)/" -i "" "$(APP_NAME).app/Contents/Info.plist"
	sed -e "s/BUNDLE_EXECUTABLE_STRING/$(PLIST_BUNDLE_EXECUTABLE_STRING)/" -i "" "$(APP_NAME).app/Contents/Info.plist"
	sed -e "s/BUNDLE_ICON_FILE_STRING/$(PLIST_BUNDLE_ICON_FILE_STRING)/" -i "" "$(APP_NAME).app/Contents/Info.plist"
	sed -e "s/BUNDLE_IDENTIFIER_STRING/$(PLIST_BUNDLE_IDENTIFIER_STRING)/" -i "" "$(APP_NAME).app/Contents/Info.plist"
	sed -e "s/BUNDLE_NAME_STRING/$(PLIST_BUNDLE_NAME_STRING)/" -i "" "$(APP_NAME).app/Contents/Info.plist"
	sed -e "s/BUNDLE_PACKAGE_TYPE_STRING/$(PLIST_BUNDLE_PACKAGE_TYPE_STRING)/" -i "" "$(APP_NAME).app/Contents/Info.plist"
	sed -e "s/BUNDLE_SHORT_VERSION_STRING/$(PLIST_BUNDLE_SHORT_VERSION_STRING)/" -i "" "$(APP_NAME).app/Contents/Info.plist"
	sed -e "s/BUNDLE_VERSION_STRING/$(PLIST_BUNDLE_VERSION_STRING)/" -i "" "$(APP_NAME).app/Contents/Info.plist"
	sed -e "s/MINIMUM_SYSTEM_VERSION_STRING/$(PLIST_MINIMUM_SYSTEM_VERSION_STRING)/" -i "" "$(APP_NAME).app/Contents/Info.plist"
	sed -e "s/HUMAN_READABLE_COPYRIGHT_STRING/$(PLIST_HUMAN_READABLE_COPYRIGHT_STRING)/" -i "" "$(APP_NAME).app/Contents/Info.plist"
	sed -e "s/BUNDLE_SIGNATURE_STRING/$(PLIST_BUNDLE_SIGNATURE_STRING)/" -i "" "$(APP_NAME).app/Contents/Info.plist"
	cp "./$(BINARY_NAME)" "$(APP_NAME).app/Contents/MacOS/$(BINARY_NAME)"
	cp "$(ICON_FILE)" "$(APP_NAME).app/Contents/Resources/$(ICON_FILE)"
	mkdir ./build_artifacts
	mkdir ./build_output
	mv "$(BINARY_NAME).dSYM" ./build_artifacts
	mv "$(BINARY_NAME)" ./build_artifacts
	mv "$(APP_NAME).app" ./build_output

clean:
	rm -rf "$(BINARY_NAME).dSYM"
	rm -f "$(BINARY_NAME)"
	rm -rf "$(APP_NAME).app"
	rm -rf ./build_artifacts
	rm -rf ./build_output
