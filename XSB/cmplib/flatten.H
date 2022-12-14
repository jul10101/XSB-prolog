/* File:      flatten.H
** Author(s): Kostis F. Sagonas
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
** $Id: flatten.H,v 1.8 2010-08-19 15:03:35 spyrosh Exp $
** 
*/


:- export flatten/2.
:- export force_flatten_loaded/0.

:- import gennum/1 from gensym.
:- import arithrelop/1 from tp_eval.
:- import length/2 from basics.
:- import functor/3 from standard.
:- import check_atom/3 from error_handler.
