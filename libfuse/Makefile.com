#
# CDDL HEADER START
#
# The contents of this file are subject to the terms of the
# Common Development and Distribution License (the "License").
# You may not use this file except in compliance with the License.
#
# You can obtain a copy of the license at usr/src/OPENSOLARIS.LICENSE
# or http://www.opensolaris.org/os/licensing.
# See the License for the specific language governing permissions
# and limitations under the License.
#
# When distributing Covered Code, include this CDDL HEADER in each
# file and include the License file at usr/src/OPENSOLARIS.LICENSE.
# If applicable, add the following below this CDDL HEADER, with the
# fields enclosed by brackets "[]" replaced with your own identifying
# information: Portions Copyright [yyyy] [name of copyright owner]
#
# CDDL HEADER END

#
#
# Copyright 2009 Sun Microsystems, Inc.  All rights reserved.
# Use is subject to license terms.
# Copyright 2015 Nexenta Systems, Inc. All rights reserved.

INSTALL= /usr/sbin/install
CC = gcc
CCFLAGS = $(CFLAGS) -g -fPIC -std=gnu99 \
        -I../include \
        -D__SOLARIS__ \
        -D_XOPEN_SOURCE=600 \
        -D__EXTENSIONS__ \
        -D_FILE_OFFSET_BITS=64 \
        -DFUSE_USE_VERSION=26 \
        -DFUSERMOUNT_DIR=\"usr\"

LDFLAGS = $(CCFLAGS) -shared -lc -lxnet  -Wl,-zdefs
LDFLAGS_PROGS = $(CCFLAGS) -lxnet

OBJS =  fuse.o \
        fuse_kern_chan.o \
        fuse_loop.o \
        fuse_loop_mt.o \
        fuse_lowlevel.o \
        fuse_mt.o \
        fuse_opt.o \
        fuse_session.o \
        fuse_signals.o \
        helper.o \
        mount.o \
        daemon.o \
        mount_util.o \
	modules/iconv.o \
        modules/subdir.o

FUSERMOUNT_OBJS = mount_util.o fusermount.o

MOUNT_FUSE_OBJS = mount_fuse_solaris.o

HDRS =  config.h \
        fuse.h \
        fuse_common.h \
        fuse_common_compat.h \
        fuse_compat.h \
        fuse_kernel.h \
        fuse_lowlevel.h \
        fuse_lowlevel_compat.h \
        fuse_opt.h

INCHDRS = $(HDRS:%=../include/%)

FUSE_LIB = libfuse.so.2.7.1
FUSERMOUNT = fusermount.bin
MOUNT_FUSE = mount umount
SRC=$(OBJS:%.o=../%.c)

ROOT = ../proto

all: $(FUSE_LIB) $(FUSERMOUNT) $(MOUNT_FUSE)

$(FUSE_LIB): $(OBJS)
	$(CC) $(LDFLAGS) $(OBJS) -o $@

$(FUSERMOUNT): $(FUSERMOUNT_OBJS)
	$(CC) $(LDFLAGS_PROGS) $(FUSERMOUNT_OBJS) -o $@

$(MOUNT_FUSE): $(MOUNT_FUSE_OBJS)
	$(CC) $(LDFLAGS_PROGS) $(MOUNT_FUSE_OBJS) -o mount
	cp ../umount_fuse_solaris.sh umount

%.o: ../%.c $(INCHDRS)
	$(CC) $(CCFLAGS) -c ../$*.c -o $@

install_common:
	$(INSTALL) -f $(ROOT)/usr/bin/ ../fusermount
	$(INSTALL) -f $(ROOT)/usr/lib libfuse.so.2.7.1
	$(INSTALL) -f $(ROOT)/usr/lib/pkgconfig ../fuse.pc
	$(INSTALL) -f $(ROOT)/usr/lib/fs/fuse fusermount.bin
	$(INSTALL) -f $(ROOT)/usr/lib/fs/fuse mount
	$(INSTALL) -f $(ROOT)/usr/lib/fs/fuse umount
	$(INSTALL) -f $(ROOT)/usr/include/fuse ../include/fuse.h
	$(INSTALL) -f $(ROOT)/usr/include/fuse ../include/fuse_common.h
	$(INSTALL) -f $(ROOT)/usr/include/fuse ../include/fuse_common_compat.h
	$(INSTALL) -f $(ROOT)/usr/include/fuse ../include/fuse_compat.h
	$(INSTALL) -f $(ROOT)/usr/include/fuse ../include/fuse_lowlevel.h
	$(INSTALL) -f $(ROOT)/usr/include/fuse ../include/fuse_lowlevel_compat.h
	$(INSTALL) -f $(ROOT)/usr/include/fuse ../include/fuse_opt.h

clean:
	rm -f $(OBJS) $(FUSERMOUNT_OBJS) $(FUSERMOUNT) $(FUSE_LIB) $(MOUNT_FUSE) $(MOUNT_FUSE_OBJS)
