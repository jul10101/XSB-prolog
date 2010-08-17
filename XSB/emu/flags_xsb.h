/* File:      flags_xsb.h
** Author(s): Jiyang Xu, Kostis F. Sagonas, Ernie Johnson
** Contact:   xsb-contact@cs.sunysb.edu
** 
** Copyright (C) The Research Foundation of SUNY, 1986, 1993-1998
** Copyright (C) ECRC, Germany, 1990
** 
** XSB is free software; you can redistribute it and/or modify it under the
** terms of the GNU Library General Public License as published by the Free
** Software Foundation; either version 2 of the License, or (at your option)
** any later version.
** 
** XSB is distributed in the hope that it will be useful, but WITHOUT ANY
** WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
** FOR A PARTICULAR PURPOSE.  See the GNU Library General Public License for
** more details.
** 
** You should have received a copy of the GNU Library General Public License
** along with XSB; if not, write to the Free Software Foundation,
** Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
**
** $Id: flags_xsb.h,v 1.8 2010-08-17 20:48:36 spyrosh Exp $
** 
*/


#ifndef SYSTEM_FLAGS

#define SYSTEM_FLAGS

#include "cell_xsb.h"

extern Cell flags[];		/* System flags + user flags */
#ifndef MULTI_THREAD
extern Cell pflags[];		/* Thread private flags */
#endif

#include "flag_defs_xsb.h"

#endif
