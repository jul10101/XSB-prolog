/*  -*-c-*-  Make sure this file comes up in the C mode of emacs */ 
/* File:      desc_bv.i
** Author(s): Ernie Johnson
** Contact:   xsb-contact@cs.sunysb.edu
** 
** Copyright (C) The Research Foundation of SUNY, 1997-1998
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
** $Id: desc_bv.i,v 1.2 1999-04-22 06:49:31 kifer Exp $
** 
*/

/*
 * DESCRIBE the SQL Statement's Bind Variables
 * -------------------------------------------
 *  Initilizes the bind descriptor after examining the placeholders in
 *  the PREPAREd dynamic SQL statement to determine the name(s) and
 *  length(s) of the placeholders, as well as the data type of the
 *  associated input host variable(s).
 */

  switch (cursorHandle) {
  case 0:   EXEC SQL DESCRIBE BIND VARIABLES FOR S0 INTO descriptor;   break;
  case 1:   EXEC SQL DESCRIBE BIND VARIABLES FOR S1 INTO descriptor;   break;
  case 2:   EXEC SQL DESCRIBE BIND VARIABLES FOR S2 INTO descriptor;   break;
  case 3:   EXEC SQL DESCRIBE BIND VARIABLES FOR S3 INTO descriptor;   break;
  case 4:   EXEC SQL DESCRIBE BIND VARIABLES FOR S4 INTO descriptor;   break;
  case 5:   EXEC SQL DESCRIBE BIND VARIABLES FOR S5 INTO descriptor;   break;
  case 6:   EXEC SQL DESCRIBE BIND VARIABLES FOR S6 INTO descriptor;   break;
  case 7:   EXEC SQL DESCRIBE BIND VARIABLES FOR S7 INTO descriptor;   break;
  case 8:   EXEC SQL DESCRIBE BIND VARIABLES FOR S8 INTO descriptor;   break;
  case 9:   EXEC SQL DESCRIBE BIND VARIABLES FOR S9 INTO descriptor;   break;
  case 10:  EXEC SQL DESCRIBE BIND VARIABLES FOR S10 INTO descriptor;   break;
  case 11:  EXEC SQL DESCRIBE BIND VARIABLES FOR S11 INTO descriptor;   break;
  case 12:  EXEC SQL DESCRIBE BIND VARIABLES FOR S12 INTO descriptor;   break;
  case 13:  EXEC SQL DESCRIBE BIND VARIABLES FOR S13 INTO descriptor;   break;
  case 14:  EXEC SQL DESCRIBE BIND VARIABLES FOR S14 INTO descriptor;   break;
  case 15:  EXEC SQL DESCRIBE BIND VARIABLES FOR S15 INTO descriptor;   break;
  case 16:  EXEC SQL DESCRIBE BIND VARIABLES FOR S16 INTO descriptor;   break;
  case 17:  EXEC SQL DESCRIBE BIND VARIABLES FOR S17 INTO descriptor;   break;
  case 18:  EXEC SQL DESCRIBE BIND VARIABLES FOR S18 INTO descriptor;   break;
  case 19:  EXEC SQL DESCRIBE BIND VARIABLES FOR S19 INTO descriptor;   break;
  case 20:  EXEC SQL DESCRIBE BIND VARIABLES FOR S20 INTO descriptor;   break;
  }
