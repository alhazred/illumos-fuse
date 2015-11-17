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
# Copyright 2008 Sun Microsystems, Inc.  All rights reserved.
# Use is subject to license terms.

CFLAGS = -m64
include ../Makefile.com

DIRSAMD64 = $(ROOT)/usr/bin/amd64 \
		 $(ROOT)/usr/lib/amd64

install:
	mkdir -p $(DIRSAMD64)
	$(INSTALL) -f $(ROOT)/usr/bin/amd64 ../fusermount
	$(INSTALL) -f $(ROOT)/usr/bin/amd64 fusermount.bin
	$(INSTALL) -f $(ROOT)/usr/lib/amd64 libfuse.so.2.7.1

