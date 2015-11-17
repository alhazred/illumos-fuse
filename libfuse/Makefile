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
# Copyright 2007 Sun Microsystems, Inc.  All rights reserved.
# Use is subject to license terms.
# Copyright 2015 Nexenta Systems, Inc. All rights reserved.

MACH:sh =uname -p

MACH64 = amd64

ROOT = proto
DIRS =	$(ROOT)/usr \
		$(ROOT)/usr/bin \
		$(ROOT)/usr/lib \
		$(ROOT)/usr/lib/fs \
		$(ROOT)/usr/lib/fs/fuse \
		$(ROOT)/usr/lib/pkgconfig \
		$(ROOT)/usr/include \
		$(ROOT)/usr/include/fuse

all := TARGET = all
clean := TARGET = clean
install:= TARGET = install

all: $(MACH) $(MACH64)

clean: $(MACH) $(MACH64)
	rm -fr $(DIRS) $(ROOT)

install: preinstall $(MACH) $(MACH64)

preinstall:
	mkdir -p $(ROOT) $(DIRS)

$(MACH) $(MACH64) : FRC
	@cd $@; pwd; $(MAKE) $(TARGET)

FRC:
