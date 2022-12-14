/* File:      setof.H
** Author(s): Kostis Sagonas, David S. Warren, Bart Demoen
** Contact:   xsb-contact@cs.sunysb.edu
** 
** Copyright (C) The Research Foundation of SUNY, 1993-1998
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
** $Id: setof.H,v 1.10 2010/01/23 18:48:11 tswift Exp $
** 
*/



:- export setof/3, bagof/3, findall/3, findall/4,
	  tsetof/3, tbagof/3,
	  sort/2, sort/3, keysort/2, '^'/2, pick/3,
	  excess_vars/4.
:- export bounded_bagof/4.
:- export find_n/4, n_times/2, find_n_m/5, n_m_times/3.
:- export term_variables/2.
:- export forall/3, forall/4.
:- export forall/2.
:- export parse_options/4.

:- import tfindall/3 from tables.
:- import (=..)/2, functor/3,
       call/1  from standard.
:- import '$$findall_init'/2, '$$findall_add'/3, 
    '$$findall_get_solutions'/4,
    parsort/5
   from machine.
:- import variant/2 from subsumes.
:- import gensym/2, conset/2, coninc/2 from gensym.
:- import numbervars/1 from num_vars.
:- import domain_error/4, misc_error/1, instantiation_error/3 from error_handler.
:- import concat_atom/2 from string.
