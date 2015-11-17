/*
 * CDDL HEADER START
 *
 * The contents of this file are subject to the terms of the
 * Common Development and Distribution License (the "License").
 * You may not use this file except in compliance with the License.
 *
 * You can obtain a copy of the license at usr/src/OPENSOLARIS.LICENSE
 * or http://www.opensolaris.org/os/licensing.
 * See the License for the specific language governing permissions
 * and limitations under the License.
 *
 * When distributing Covered Code, include this CDDL HEADER in each
 * file and include the License file at usr/src/OPENSOLARIS.LICENSE.
 * If applicable, add the following below this CDDL HEADER, with the
 * fields enclosed by brackets "[]" replaced with your own identifying
 * information: Portions Copyright [yyyy] [name of copyright owner]
 *
 * CDDL HEADER END
 */

/*
 * Copyright 2009 Sun Microsystems, Inc.  All rights reserved.
 * Use is subject to license terms.
 */

#include <errno.h>
#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <unistd.h>
#include <alloca.h>
#include <libintl.h>
#include <locale.h>
#include <err.h>
#include "config.h"


#define	EXIT_OK		0
#define	EXIT_USAGE	1
#define	EXIT_ERROR	2

#define	SUBTYPE_OPTION	"subtype"

static void usage(void);


int
main(int argc, char **argv)
{
	char *optstr, *optstr_save, *sep, *soptval, *fspgm;
	char *sopt[2];
	int opt, i;

	(void) setlocale(LC_ALL, "");
#if !defined(TEXT_DOMAIN)
#define	TEXT_DOMAIN	"SYS_TEST"
#endif
	(void) textdomain(TEXT_DOMAIN);

	if (argc == 2) {
		if (strcmp(argv[1], "-h") == 0 ||
		    strcmp(argv[1], "-?") == 0 ||
		    strcmp(argv[1], "--help") == 0) {
			usage();
		} else if (strcmp(argv[1], "--version") == 0) {
			errx(EXIT_OK, gettext("FUSE version %s"), VERSION);
		} else if (argv[1][0] == '-') {
			fprintf(stderr, gettext("invalid option %s\n"),
			    argv[1]);
		}
	}
	if (argc < 3)
		usage();

	/* Look for "-o subtype=fspgm" syntax */
	fspgm = NULL;
	opterr = 0;
	while ((opt = getopt(argc, argv, ":o:")) != -1) {

		/* We're not validating options, just looking for subtype */
		if (opt != 'o')
			continue;
		if (optarg != NULL) {
			sopt[0] = SUBTYPE_OPTION;
			sopt[1] = NULL;
			if ((optstr = optstr_save = strdup(optarg)) == NULL)
				err(EXIT_ERROR, NULL);
			while (*optstr != '\0') {
				if (getsubopt(&optstr, sopt, &soptval) != -1 &&
				    soptval != NULL && strlen(soptval) > 0) {
					fspgm = alloca(strlen(soptval) + 1);
					if (fspgm == NULL) {
						free(optstr_save);
						err(EXIT_ERROR, NULL);
					}
					strcpy(fspgm, soptval);
					break;
				}
			}
			free(optstr_save);
		}
	}

	/*
	 * Look for "fspgm#special" syntax. If found, but the fspgm
	 * was already specified with the subtype option, exit with
	 * an error message.
	 * Note that if the "fspgm#special" syntax is found, the
	 * arguments are operated on in-place to parse 'fspgm'
	 * and strip it from 'special.'
	 */
	soptval = argv[argc - 2];
	sep = strchr(soptval, '#');
	if (sep != NULL && sep + 1 != NULL && strlen(sep + 1) > 0) {
		if (fspgm == NULL) {
			*sep = '\0';
			fspgm = soptval;
			argv[argc - 2] = sep + 1;
		} else {
			errx(EXIT_ERROR, gettext("file system subtype must "
			    "be specified only once"));
		}
	}

	if (fspgm == NULL) {
		errx(EXIT_ERROR, gettext("a FUSE file system subtype must "
		    "be specified"));
	}

	argv[0] = fspgm;
	execvp(fspgm, argv);
	err(EXIT_ERROR, gettext("failed to execute %s"), fspgm);
}


/*
 * usage
 *
 * Output program usage and exit
 *
 */
static void
usage()
{

	fprintf(stderr, gettext("usage:\n"
	    "mount [generic options] -o subtype=filesystem[,option] "
	    "special mount_point\n"
	    "mount [generic options] [-o option[,option]] "
	    "filesystem#special mount_point\n"));

	exit(EXIT_USAGE);
}
