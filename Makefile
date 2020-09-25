ifeq ($(IPP_DIR),)
export IPP_DIR=$(shell while true; do if [ -f IPP_TOPDIR.flag ]; then pwd;exit; else cd ..;fi;done;)
endif

include $(IPP_DIR)/ebuild.mk

RPCAPD_FOLDER= $(IPP_DIR)/src/opensource/rpcapd
RPCAPD_DIR = $(IPP_DIR)/src/opensource/rpcapd

# source code didn't use NOLOG definition. it is only for

#---------------------- core ---------------------------------
BASE_LIB_NAME=libpcap
LIB_NAME=lib$(BASE_LIB_NAME).a
#libs-$(CONFIG_OPENSOURCE_RPCAPD)=$(LIB_NAME)

$(LIB_NAME)-objs=pcap-linux.o \
	fad-gifc.o \
	pcap.o \
	inet.o \
	gencode.o \
	optimize.o \
	nametoaddr.o \
	etherent.o \
	savefile.o \
	bpf/net/bpf_filter.o \
	bpf_image.o \
	bpf_dump.o \
	scanner.o \
	grammar.o \
	version.o \
	pcap-new.o \
	pcap-remote.o \
	sockutils.o

$(LIB_NAME)-stage = $(STAGE_DIR)/lib/$(LIB_NAME)

ifeq ($(HW_TYPE), C450HD)
	EXTRA_CFLAGS  = -pthread -DHAVE_REMOTE -DHAVE_SNPRINTF -Dlint -DHAVE_SOCKLEN_T -DHAVE_VSNPRINTF -DHAVE_STRERROR
else ifeq ($(HW_TYPE), 445HD)
	EXTRA_CFLAGS  = -pthread -DHAVE_REMOTE -DHAVE_SNPRINTF -Dlint -DHAVE_SOCKLEN_T -DHAVE_VSNPRINTF -DHAVE_STRERROR
else
	EXTRA_CFLAGS  = -pthread -DHAVE_REMOTE -DHAVE_SNPRINTF -Dlint -DHAVE_SOCKLEN_T -DHAVE_VSNPRINTF -DHAVE_STRERROR -DHAVE_STRLCPY
endif

EXTRA_CFLAGS += -I$(RPCAPD_DIR)

#---------------------- rpcapd ----------------------------

OBJ_RPCAPD = pcap-linux.o \
	fad-gifc.o \
	pcap.o \
	inet.o \
	gencode.o \
	optimize.o \
	nametoaddr.o \
	etherent.o \
	savefile.o \
	bpf/net/bpf_filter.o \
	bpf_image.o \
	bpf_dump.o \
	scanner.o \
	grammar.o \
	version.o \
	sockutils.o \
	pcap-new.o \
	rpcapd/rpcapd.o rpcapd/daemon.o rpcapd/thread_cancel_linux.o rpcapd/utils.o rpcapd/fileconf.o pcap-remote.o \

OBJS +=	$(OBJ_RPCAPD)

BIN = rpcapd_srv
progs-$(CONFIG_OPENSOURCE_RPCAPD) := $(BIN)
$(BIN)-objs := $(OBJS)
$(BIN)-cxxobjs := $(CPP_OBJS)
$(BIN)-instdir = $(ROOTFS_DIR)/usr/sbin

INCLUDEFLAGS += -I$(RPCAPD_DIR)/rpcapd
INCLUDEFLAGS += -I$(RPCAPD_DIR)
EXTRA_CFLAGS += -I$(RPCAPD_DIR)
EXTRA_LDFLAGS += -lcrypt -lpthread

#LDFLAGS_$(BIN) += -l$(BASE_LIB_NAME)
#EXTRA_LDFLAGS +=  -L $(OPENSOURCE_DIR)/../../build/obj/opensource/rpcapd

