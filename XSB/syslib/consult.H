/* File:      consult.H
** Author(s): Kostis F. Sagonas, David S. Warren
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
** $Id: consult.H,v 1.50 2009/10/12 20:36:34 dwarren Exp $
** 
*/

:- export 
        add_lib_dir/1, add_lib_dir/2,
        remove_lib_dir/1, removeall_lib_dir/1, has_lib_dir/1,
	compile/1, compile/2, compile_opt_checked/3, search_module/6, compile0/4,
        consult/1, consult/2, '.'/2, reconsult/1, reconsult/2,
        current_loaded_file/1, is_loaded/1, add_this_lib_dir/0,
        engine_mode_magic_num/3,
        ensure_dyn_loaded/1, ensure_dync_loaded/1,
        ensure_dyn_loaded/3, ensure_dync_loaded/3,
        ensure_loaded/1, ensure_loaded/2, ensure_loaded/3,
        get_magic_num/2,
	load_dyn/1, load_dyn/2, load_dyn/3, 
        load_dyn_module/1,load_dyn_gen/2,
	load_dync/1, load_dync/2, load_dync/3, load_dync/4, load_dynca/1, load_dynca/2,
        read_canonical/1,read_canonical/2,
        if_file_loaded/1,
        needs_recompile/3,
        (thread_shared)/1,
        (thread_private)/1,
        cvt_canonical/2.
:- export load_dyna/1.
:- export load_dynca/2.
:- export
        record_file_consultloaded/1,
        remove_file_consultloaded/1,
        file_is_consultloaded/1,
	consult_file_loaded/1,
	push_loaded_file/2,
	pop_loaded_file/1.
:- export
	xsb_filename/2.

:- local load_dyn_retracted/5,
         load_dyn_trie_retracted/1,
	 load_dyn_file_loaded/2,
         load_dyn_pred_loaded/4,
         load_dyn_file/2.

:- import check_one_thread/3,
   domain_error/4, existence_error/4,instantiation_error/2, permission_error/4,syntax_error/2,type_error/4,
   check_nonvar/3, check_atom/3, check_ground/3, check_integer/3 from error_handler.
:- import domain_error/5,misc_error/1 from error_handler.
:- import asserta/1, (dynamic)/1, retractall/1, assert/1, retract/1, t_assert/2
     from assert.
:- import check_file_compiler_options/1, setoptions1/1, valid_charset/1 from auxlry.
:- import warning/1, time_message/2, '_$compiler_option_dynamic'/1 from auxlry.
:- import xpp_is_off/0 from parse.
:- import banner_control/1 from banner.
:- import append/3, memberchk/2, member/2 from basics.
:- import compile/6, check_compile_options/1 from compile.
   :- import predicate_property/2, current_input_port/1,current_prolog_flag/2 from curr_sym.
:- import default_assert_size/1 from config.
:- import check_open_stream_or_alias/5, 
	path_sysop/3,
   file_close/1,file_get/2, file_open/3, file_time/2, file_set_character_set/2 from file_io.
:- import '_$index'/3, '_$trie_asserted'/1, mpa_to_skel/2 from file_op.
:- import compile_cH/7 from foreign.
:- import conset/2, conget/2, coninc/1, coninc/2, gensym/2  from gensym.
:- import add_hilog_symbol/1 from hilogsym.
:- import libpath/1, load_object_file/3, rename_private_obj_file/2, private_obj_filename/2
   from loader.
:- import %%code_load/4, code_call/3,
	  file_read_canonical/3,
	  expand_filename/2, %%unload_seg/1, 
	  assert_code_to_buff/1, assert_buff_to_clref/6,
	  conpsc/2, psc_type/2, slash/1, psc_arity/2, 
	  existing_file_extension/2, almost_search_module/5, db_get_prref/2,
	  term_psc/2, psc_set_shared/2, psc_set_private/2, stat_flag/2,
	  term_new/2, term_new_mod/3, stat_set_flag/2, psc_import_as/2,
	  psc_set_type/2, psc_set_ep/2, psc_insertmod/3
     from machine.
:- import
	check_xpp_process_status/3,
	get_p_mod/3, open_or_xpp_file/2
   from parse.
:- import
	rm/1, sys_link/3, sys_filecopy/3, cwd/1, cd/1, is_directory/1
   from shell.
:- import exec_table_option/2 from standard.
:- import (multifile)/1, '_$multifile'/1, '_$multifile_comp'/2 from standard.
:- import abort/1, call/1, file_exists/1, atom/1, repeat/0,
	  seeing/1, see/1, seen/0, call/1, goal_cut_trans/3,
	  expand_term/2, read/1, op/3, (table)/1, (index)/3, (index)/2,
	  (=..)/2, writeln/1, write_canonical/1, tell/1,
	  told/0, telling/1, functor/3, functor/4, cputime/1, %%(import)/1,
	  catch/3, throw/1, is_list/1, warning/2
     from standard.
:- import '->'/2, ';'/2 from standard.
:- import str_cat/3, str_sub/2, concat_atom/2 from string.
:- import xsb_configuration/2 from xsb_configuration.
%%:- import file_write0/2, file_nl/1 from xsb_writ.
:- import library_directory/1 from usermod.
:- import parse_filename/4 from machine.
:- import standard_symbol/3, standard_metapredicate/3 from std_xsb.
:- import atom_codes/2 from standard.
%%:- import fmt_write/3 from file_io.
:- import parse_options/4 from setof.	   
