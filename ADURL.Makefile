#
#  Copyright (c) 2018 - Present  European Spallation Source ERIC
#
#  The program is free software: you can redistribute
#  it and/or modify it under the terms of the GNU General Public License
#  as published by the Free Software Foundation, either version 2 of the
#  License, or any newer version.
#
#  This program is distributed in the hope that it will be useful, but WITHOUT
#  ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
#  FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
#  more details.
#
#  You should have received a copy of the GNU General Public License along with
#  this program. If not, see https://www.gnu.org/licenses/gpl-2.0.txt
#
# 
# Author  : waynelewis
# email   : wayne.lewis@esss.se
# Date    : generated by 2018Oct02-0837-58PDT
# version : 0.0.0 
#
# template file is generated by e3TemplateGenerator.bash with 47608e8
# Please look at many other _module_.Makefile in e3-* repository
# 

## The following lines are mandatory, please don't change them.
where_am_I := $(dir $(abspath $(lastword $(MAKEFILE_LIST))))
include $(E3_REQUIRE_TOOLS)/driver.makefile
include $(where_am_I)/../configure/DECOUPLE_FLAGS




# If one would like to use the module dependency restrictly,
# one should look at other modules makefile to add more
# In most case, one should ignore the following lines:

ifneq ($(strip $(ASYN_DEP_VERSION)),)
asyn_VERSION=$(ASYN_DEP_VERSION)
endif

ifneq ($(strip $(ADCORE_DEP_VERSION)),)
ADCore_VERSION=$(ADCORE_DEP_VERSION)
endif

ifneq ($(strip $(ADSUPPORT_DEP_VERSION)),)
ADSupport_VERSION=$(ADSUPPORT_DEP_VERSION)
endif

## Exclude linux-ppc64e6500
EXCLUDE_ARCHS = linux-ppc64e6500

APP:=urlApp
APPDB:=$(APP)/Db
APPSRC:=$(APP)/src

USR_INCLUDES += -I/usr/include/libxml2
LIB_SYS_LIBS += xml2
LIB_SYS_LIBS += jpeg
#USR_INCLUDES += -I/usr/local/include/GraphicsMagick
USR_INCLUDES += -I/usr/include/GraphicsMagick
LIB_SYS_LIBS += GraphicsMagick
LIB_SYS_LIBS += GraphicsMagick++

# USR_CFLAGS   += -Wno-unused-variable
# USR_CFLAGS   += -Wno-unused-function
# USR_CFLAGS   += -Wno-unused-but-set-variable
# USR_CPPFLAGS += -Wno-unused-variable
# USR_CPPFLAGS += -Wno-unused-function
# USR_CPPFLAGS += -Wno-unused-but-set-variable

TEMPLATES += $(wildcard $(APPDB)/*.db)

# DBDINC_SRCS += $(APPSRC)/transformRecord.c

# DBDINC_DBDS = $(subst .c,.dbd,   $(DBDINC_SRCS:$(APPSRC)/%=%))
# DBDINC_HDRS = $(subst .c,.h,     $(DBDINC_SRCS:$(APPSRC)/%=%))
# DBDINC_DEPS = $(subst .c,$(DEP), $(DBDINC_SRCS:$(APPSRC)/%=%))

# HEADERS += $(DBDINC_HDRS)

SOURCES += $(APPSRC)/URLDriver.cpp
# # DBDINC_SRCS should be last of the series of SOURCES
# SOURCES += $(DBDINC_SRCS)

DBDS += $(APPSRC)/URLDriverSupport.dbd

#
# $(DBDINC_DEPS): $(DBDINC_HDRS)
#
# .dbd.h:
# 	$(DBTORECORDTYPEH)  $(USR_DBDFLAGS) -o $@ $<
#
# .PHONY: $(DBDINC_DEPS) .dbd.h
#
#
# The following lines could be useful if one uses the external lib
#
# Examples...
# 
# USR_CFLAGS += -fPIC
# USR_CFLAGS   += -DDEBUG_PRINT
# USR_CPPFLAGS += -DDEBUG_PRINT
# USR_CPPFLAGS += -DUSE_TYPED_RSET
# USR_INCLUDES += -I/usr/include/libusb-1.0
# USR_LDFLAGS += -lusb-1.0
# USR_LDFLAGS += -L /opt/etherlab/lib
# USR_LDFLAGS += -lethercat
# USR_LDFLAGS += -Wl,-rpath=/opt/etherlab/lib
#USR_LDFLAGS += -lGraphicsMagick
#USR_LDFLAGS += -L/usr/local/lib

## SYSTEM LIBS 
##
# USR_LIBS += boost_regex
# USR_LIBS += readline

#

# # We don't have LIB_INSTALLS, so will tackle later
# ifeq ($(T_A),linux-x86_64)
# USR_LDFLAGS += -Wl,--enable-new-dtags
# USR_LDFLAGS += -Wl,-rpath=$(E3_MODULES_VENDOR_LIBS_LOCATION)
# USR_LDFLAGS += -L$(E3_MODULES_VENDOR_LIBS_LOCATION)
# USR_LDFLAGS += -lflycapture
# endif

# According to its makefile
# VENDOR_LIBS += $(SUPPORT)/os/linux-x86_64/libflycapture.so.2.8.3.1
# VENDOR_LIBS += $(SUPPORT)/os/linux-x86_64/libflycapture.so.2
# VENDOR_LIBS += $(SUPPORT)/os/linux-x86_64/libflycapture.so




## This RULE should be used in case of inflating DB files 
## db rule is the default in RULES_DB, so add the empty one
## Please look at e3-mrfioc2 for example.

#db: 
#.PHONY: db 

EPICS_BASE_HOST_BIN = $(EPICS_BASE)/bin/$(EPICS_HOST_ARCH)
MSI = $(EPICS_BASE_HOST_BIN)/msi

USR_DBFLAGS += -I . -I ..
USR_DBFLAGS += -I $(EPICS_BASE)/db
USR_DBFLAGS += -I $(APPDB)
# URLDriver.template includes ADBase.template
USR_DBFLAGS += -I $(E3_SITELIBS_PATH)/ADCore_$(ADCORE_DEP_VERSION)_db

SUBS=$(wildcard $(APPDB)/*.substitutions)
TMPS=$(wildcard $(APPDB)/*.template)

db: $(SUBS) $(TMPS)

$(SUBS):
	@printf "Inflating database ... %44s >>> %40s \n" "$@" "$(basename $(@)).db"
	@rm -f  $(basename $(@)).db.d  $(basename $(@)).db
	@$(MSI) -D $(USR_DBFLAGS) -o $(basename $(@)).db -S $@  > $(basename $(@)).db.d
	@$(MSI)    $(USR_DBFLAGS) -o $(basename $(@)).db -S $@

$(TMPS):
	@printf "Inflating database ... %44s >>> %40s \n" "$@" "$(basename $(@)).db"
	@rm -f  $(basename $(@)).db.d  $(basename $(@)).db
	@$(MSI) -D $(USR_DBFLAGS) -o $(basename $(@)).db $@  > $(basename $(@)).db.d
	@$(MSI)    $(USR_DBFLAGS) -o $(basename $(@)).db $@

#
.PHONY: db $(SUBS) $(TMPS)

vlibs:

.PHONY: vlibs

# vlibs: $(VENDOR_LIBS)

# $(VENDOR_LIBS):
# 	$(QUIET)$(SUDO) install -m 555 -d $(E3_MODULES_VENDOR_LIBS_LOCATION)/
# 	$(QUIET)$(SUDO) install -m 555 $@ $(E3_MODULES_VENDOR_LIBS_LOCATION)/

# .PHONY: $(VENDOR_LIBS) vlibs



