/* File:      psc_xsb.c
** Author(s): Xu, Warren, Sagonas, Swift
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
** $Id: psc_xsb.c,v 1.61 2013-05-06 21:10:25 dwarren Exp $
** 
*/


#include "xsb_config.h"
#include "xsb_debug.h"

#include <stdio.h>
#include <string.h>

#include "auxlry.h"
#include "context.h"
#include "cell_xsb.h"
#include "error_xsb.h"
#include "psc_xsb.h"
#include "tries.h"
#include "hash_xsb.h"
#include "tab_structs.h"
#include "loader_xsb.h"
#include "flags_xsb.h"
#include "sig_xsb.h"
#include "inst_xsb.h"
#include "memory_xsb.h"
#include "register.h"
#include "thread_xsb.h"
#include "cinterf.h"

extern Psc synint_proc(Psc, int);

/* === String Table manipulation ======================================	*/

/*
 * Looks up a string in the String Table.  If it is not found and the
 * insert flag is set, then inserts the string into the table.
 * If the string exists in the table, returns a pointer to the string
 * part of the corresponding table entry.
 *                      
 * String Table entries have the form:
 *           +--------------------------+
 *           | Ptr_to_Next | String ... |
 *           +--------------------------+
 */
/* TLS: use of NOERROR mutexes is ok (12/05) but if we put in error
   checking in mem_xxxoc() functions, we'll need to adjust these
   mutexes. */

extern size_t last_string_space_size;
extern size_t last_assert_space_size;
#define CHAR_PTR_SIZE  sizeof(char *)

DllExport char* call_conv string_find(const char *str, int insert) {

  char **ptr, *str0;
  char **sptr;
  UNUSED(sptr);

  //  printf("interning %s\n",str);
  SYS_MUTEX_LOCK_NOERROR( MUTEX_STRING ) ;
  sptr = ptr = (char **)string_table.table + hash(str, 0, string_table.size);
  while (*ptr) {
    str0 = *ptr + CHAR_PTR_SIZE;
    if (strcmp(str, str0) == 0)
      goto exit_string_find;
    ptr = (char **)(*ptr);
  }
  
  //  if (strcmp(str,"Batch: tuning_batch_2_0")==0) printf("string_find notfound tuningbat_2_0, %p\n",sptr);

  if (insert) {
    str0 = (char *)mem_alloc(CHAR_PTR_SIZE + strlen(str) + 1,STRING_SPACE);
    *ptr = str0;
    *(char **)str0 = NULL;
    str0 = str0 + CHAR_PTR_SIZE;
    strcpy(str0, str);
    string_table_increment_and_check_for_overflow;
    if ((pspacesize[STRING_SPACE] > 4*last_string_space_size) &&
	(pspacesize[ASSERT_SPACE] < 2*last_assert_space_size)) {
      force_string_gc = TRUE;
    }
  }
  else
    str0 = NULL ;

exit_string_find:
  SYS_MUTEX_UNLOCK_NOERROR( MUTEX_STRING ) ;
  //  if (strcmp(str,"Batch: tuning_batch_2_0")==0) printf("string_find tuningbat_2_0, %d, %p, %p, %p\n",insert,str,str0,sptr);
  return str0;
}

// TES: seems to be a poor name: this just finds the string if its
// there, but wont update the string table.  Also its not thread-safe.
char *string_find_safe(char *str) {

  char *ptr, *str0;

  ptr = (char *)((Integer)(*(string_table.table + hash(str, 0, string_table.size))) & ~1);
  while (ptr) {
    str0 = ptr + CHAR_PTR_SIZE;
    if (strcmp(str, str0) == 0)
      return str0;
    ptr = (char *)(((Integer)(*(void **)ptr)) & ~1);
  }
  //  printf("string_find_safe: not found '%s'\n",str);
  return NULL;
}

/* === PSC and PSC-PAIR structure creation/initialization =============== */
void init_psc_ep_info(Psc psc) {
  psc_set_type(psc, 0);
  psc->env = 0;
  psc_set_incr(psc,0);
  psc_set_intern(psc,0);
  psc_set_data(psc, 0);
  psc_set_ep(psc,(byte *)&(psc->load_inst));
  cell_opcode(&(psc->load_inst)) = load_pred;
  psc->this_psc = psc;
}

/*
 *  Create a PSC record and initialize its fields.
 */
//static Psc make_psc_rec(char *name, char arity) {
static Psc make_psc_rec(char *name, int arity) {
  Psc temp;
  
  temp = (Psc)mem_alloc(sizeof(struct psc_rec),ATOM_SPACE);
  //  set_env(temp, 0);
  //  set_spy(temp, 0);
  //  set_shared(temp, 0);
  //  set_tabled(temp, 0);
  psc_set_name(temp, string_find(name, 1));
  psc_set_arity(temp, arity);
  init_psc_ep_info(temp);
  return temp;
}

void set_psc_ep_to_psc(CTXTdeclc Psc psc_to_set, Psc target_psc) {
  if (get_arity(psc_to_set) != get_arity(target_psc)) {
    xsb_abort("[IMPORT AS] Cannot import predicate as a predicate with a different arity: %s/%d\n",
	     get_name(psc_to_set),get_arity(psc_to_set));
  } else if (get_ep(psc_to_set) != (byte *)&(psc_to_set->load_inst) &&
	     get_ep(psc_to_set) != (byte *)&(target_psc->load_inst)) {
    xsb_warn(CTXTc "[IMPORT AS] Redefining entry to import-as predicate: %s/%d\n",
	    get_name(psc_to_set),get_arity(psc_to_set));
    psc_set_ep(psc_to_set,(byte *)&(target_psc->load_inst));
  } else {
    psc_set_ep(psc_to_set,(byte *)&(target_psc->load_inst));
  }
}


/*
 *  Create a PSC-PAIR record, set it to point to a PSC record, and place
 *  it at the head of a PSC-PAIR record chain.
 */
static Pair make_psc_pair(Psc psc_ptr, Pair *link_ptr) {

  Pair new_pair;
  
  new_pair = (Pair)mem_alloc(sizeof(struct psc_pair),ATOM_SPACE);
  //  printf("new_psc_pair %d, prev %d\n",(int)new_pair, (int)*link_ptr);
  pair_psc(new_pair) = psc_ptr;         /* set 1st to point to psc_rec */
  pair_next(new_pair) = *link_ptr;      /* set 2nd to old head */
  *link_ptr = new_pair;                 /* new symbol is in the head! */
  return new_pair;
}


/* === get_tip: get the TIP from a PSC record =========================	*/
extern CPtr dynpredep_to_prortb(CTXTdeclc void *pred_ep);

TIFptr *get_tip_or_tdisp(Psc temp)
{
    CPtr temp1 ;

    switch (get_type(temp)) {
      case T_DYNA:
      case T_PRED:
	temp1 = (CPtr)get_ep(temp);
	if (temp1 != 0) {
	  switch (*(pb)temp1) {
	    case tabletry:
	    case tabletrysinglenoanswers: /* incremental evaluation */
	    case tabletrysingle:
	      return (TIFptr *) (temp1+2) ;
	    case test_heap:
	      if (*(pb)(temp1+2) == tabletry ||
		  *(pb)(temp1+2) == tabletrysingle  ||
		  *(pb)(temp1+2) == tabletrysinglenoanswers  
		  )		
		return (TIFptr *) (temp1+4) ;
	      else return (TIFptr *)NULL;
	      break;
	    case switchon3bound:
	    case switchonbound:
	    case switchonterm:
	      if (  *(pb) (temp1+3) == tabletry 
	        ||  *(pb) (temp1+3) == tabletrysingle
		    ||  *(pb) (temp1+3) == tabletrysinglenoanswers
		    ) 
		return (TIFptr *) (temp1+5) ;
	      else return (TIFptr *) NULL;
	    default:
	      return (TIFptr *) NULL;
	  }
	}
	else return (TIFptr *) NULL;
      default: 
	return (TIFptr *) NULL;
    }
}

/* get_tip takes a psc record and returns the tip (or null).  If
   multithreaded, it must go through the dispatch table to get the
   tip. 

TES: Added a few lines below to return NULL if the psc is non-tabled.
Calling routines can then report the appropriate error.  */

TIFptr get_tip(CTXTdeclc Psc psc) {
  TIFptr *tip = get_tip_or_tdisp(psc);
  //  printf("get tip %s/%d tip %p\n",get_name(psc),get_arity(psc),tip);
#ifndef MULTI_THREAD
  return tip?(*tip):NULL;
#else
  if (!tip) { /* get it out of dispatch table */
    CPtr temp1 = (CPtr) get_ep(psc);
    if ((get_type(psc) == T_DYNA) &&
	(*(pb)(temp1) ==  switchonthread)) {
      temp1 = dynpredep_to_prortb(CTXTc temp1);
      if (temp1 && ( (*(pb)temp1 == tabletrysingle) || (*(pb)temp1 == tabletrysinglenoanswers)))
	return *(TIFptr *)(temp1+2);
      else return (TIFptr) NULL;
    } 
    // TES: commented out error notification 09/16.  To make the MT engine work in
    //the case of an executed tabling directive with no code, we need
    //to return NULL
    //    else { if (get_tabled(psc)) { xsb_error("Internal Error in table dispatch\n"); }
    else { return NULL; }
  }
  if (tip && TIF_EvalMethod(*tip) != DISPATCH_BLOCK) return *tip;
  /* *tip points to 3rd word in TDispBlk, so get addr of TDispBlk */
  { struct TDispBlk_t *tdispblk = (struct TDispBlk_t *) (*tip);
    TIFptr rtip = (TIFptr)((&(tdispblk->Thread0))[xsb_thread_entry]);
    if (!rtip) {
      rtip = New_TIF(CTXTc psc);
      (&(tdispblk->Thread0))[xsb_thread_entry] = rtip;
    }
    return rtip; 
  }
#endif
}

/* === is_globalmod: Is a global module ===============================	*/

static int is_globalmod(Psc mod_psc)
{
/* 
 * The modules considered global are the ones that have the value 1 in
 * their data field of the module's psc record.  The modules I
 * know that have this property are the modules "global" and "usermod".
 */
    if (mod_psc)
      return (((Cell)get_data(mod_psc) == USERMOD_PSC));
    /** dsw need a better check here!!?! **/
    else
      return 1;
}


/* === search: search in a given chain ================================	*/

/*
 *  Returns a pointer to the PSC-PAIR structure which points to the
 *  PSC record of the desired symbol.
 */
Pair search_psc_in_module(int arity, char *name, Pair *search_ptr)
{
    Psc psc_ptr;
    /*    Pair *init_search_ptr = search_ptr; */
    /*    Pair found_pair; */

    while (*search_ptr) {
      psc_ptr = (*search_ptr)->psc_ptr;
      if (strcmp(name, get_name(psc_ptr)) == 0
	  && arity == get_arity(psc_ptr) )
	return (*search_ptr);
      else 
	search_ptr  = &((*search_ptr)->next);
    }
    return NULL;
} /* search */

Pair search_in_usermod(int arity, char *name) {
  Pair *search_ptr;
  search_ptr = (Pair *)(symbol_table.table +
			hash(name, arity, symbol_table.size));
  return search_psc_in_module(arity,name,search_ptr);
}

/* === search_insert_psc_1: search/insert to a given chain ========================	*/

//static Pair search_insert_psc_1(char *name, byte arity, Pair *search_ptr, int *is_new)
static Pair search_insert_psc_1(char *name, int arity, Pair *search_ptr, int *is_new)
{
    Pair pair;
    
    pair = search_psc_in_module(arity, name, search_ptr);
    if (pair==NULL) {
      *is_new = 1;
      pair = make_psc_pair(make_psc_rec(name,arity), search_ptr);
    }
    else
      *is_new = 0;
    return pair;
} /* search_insert_psc_1 */


/* === search/insert psc to a module, or module to global chain ======================== */

Pair insert_psc(char *name, int arity, Psc mod_psc, int *is_new) {
    Pair *search_ptr, temp;

    SYS_MUTEX_LOCK_NOERROR( MUTEX_SYMBOL ) ;

    if (is_globalmod(mod_psc)) {
      search_ptr = (Pair *)(symbol_table.table +
	           hash(name, arity, symbol_table.size));
      temp = search_insert_psc_1(name, arity, search_ptr, is_new);
      if (*is_new)
	symbol_table_increment_and_check_for_overflow;
    }
    else {
      search_ptr = (Pair *)&(get_data(mod_psc));
      temp = search_insert_psc_1(name, arity, search_ptr, is_new);
    }
    SYS_MUTEX_UNLOCK_NOERROR( MUTEX_SYMBOL ) ;
    return temp ;
} /* insert */

Pair insert(char *name, int arity, Psc mod_psc, int *is_new) {
    Pair *search_ptr, temp;

    SYS_MUTEX_LOCK_NOERROR( MUTEX_SYMBOL ) ;

    if (is_globalmod(mod_psc)) {
      search_ptr = (Pair *)(symbol_table.table +
	           hash(name, arity, symbol_table.size));
      temp = search_insert_psc_1(name, arity, search_ptr, is_new);
      if (*is_new)
	symbol_table_increment_and_check_for_overflow;
    }
    else {
      search_ptr = (Pair *)&(get_data(mod_psc));
      temp = search_insert_psc_1(name, arity, search_ptr, is_new);
    }
    SYS_MUTEX_UNLOCK_NOERROR( MUTEX_SYMBOL ) ;
    return temp ;
} /* insert */

/* === insert_module: search for/insert a given module ================	*/

DllExport Pair insert_module(int type, char *name)
{
    Pair new_pair;
    int is_new;

    SYS_MUTEX_LOCK_NOERROR( MUTEX_SYMBOL ) ;
    new_pair = search_insert_psc_1(name, 0, (Pair *)&flags[MOD_LIST], &is_new);
    if (is_new) {
	psc_set_type(new_pair->psc_ptr, type);
	new_pair->psc_ptr->env = 0;
	//	new_pair->psc_ptr->incr = 0;
	psc_set_incr(new_pair->psc_ptr,0);
	psc_set_intern(new_pair->psc_ptr,0);
	psc_set_data(new_pair->psc_ptr,0);
	psc_set_ep(new_pair->psc_ptr,(byte *)makestring(get_name(new_pair->psc_ptr)));
	new_pair->psc_ptr->this_psc = 0;
	psc_set_immutable(new_pair->psc_ptr,0);
	psc_set_modloaded(new_pair->psc_ptr,0);
    } else {	/* set loading bit: T_MODU - loaded; 0 - unloaded */
      psc_set_type(new_pair->psc_ptr, get_type(new_pair->psc_ptr) | type);
    }
    SYS_MUTEX_UNLOCK_NOERROR( MUTEX_SYMBOL ) ;
    return new_pair;
} /* insert_module */


/* === link_sym: link a symbol into a given module ==================== */

/*
 *  Given a PSC record 'psc' for a particular symbol, check to see if
 *  that symbol already exists in the module 'mod_psc'.
 *  Does NOT exist => insert it and return a ptr to its PSC-PAIR record.
 *  DOES exist => check if the found PSC record is the same as 'psc'.
 *    YES => return a ptr to its PSC-PAIR record.
 *     NO => replace the old PSC record with 'psc'; return a ptr to the
 *           PSC-PAIR record.
 *  TES: now outputting the current module in the message.
 */

Pair link_sym(CTXTdeclc Psc psc, Psc curmod_psc)
{
    Pair *search_ptr, found_pair;
    char *name;
    byte arity, global_flag, umtype, mtype;

    SYS_MUTEX_LOCK_NOERROR( MUTEX_SYMBOL ) ;
    name = get_name(psc);
    arity = get_arity(psc);
    if ( (global_flag = is_globalmod(curmod_psc)) ) {
      search_ptr = (Pair *)symbol_table.table +
	           hash(name, arity, symbol_table.size);
    } else
      search_ptr = (Pair *)&get_data(curmod_psc);
    if ((found_pair = search_psc_in_module(arity, name, search_ptr))) {
      if (pair_psc(found_pair) != psc) {
	/*  Invalidate the old name!! It is no longer accessible
	 *  through the global chain.
	 */
	umtype = get_type(pair_psc(found_pair));
	mtype = get_type(psc);
	if ( umtype != T_ORDI && mtype != T_ORDI ) {
	  char message[450], modmsg[200], curmodmsg[200];
	  if (curmod_psc == 0) snprintf(curmodmsg,200,"%s","usermod");
	  else if (isstring(curmod_psc)) snprintf(curmodmsg,200,"usermod from file: %s",string_val(curmod_psc));
	  else snprintf(curmodmsg,200,"module: %s",get_name(curmod_psc));
	  if (umtype == T_DYNA || umtype == T_PRED) {
	    Psc mod_psc;
	    mod_psc = (Psc) get_data(pair_psc(found_pair));
	    if (mod_psc == 0) snprintf(modmsg,200,"%s","usermod");
	    else if (isstring(mod_psc)) snprintf(modmsg,200,"usermod from file: %s",string_val(mod_psc));
	    else snprintf(modmsg,200,"module: %s",get_name(mod_psc));
	    snprintf(message,450,
		     "%s/%d (%s) had been defined in %s; those clauses lost in the context of %s.",
		     name, arity, ((umtype==T_PRED)?"static predicate":"dynamic predicate"),modmsg,curmodmsg);
		     //		    "%s/%d (umtype %d) had been defined in %s; those clauses lost.",
	  } else 
	    snprintf(message,450,
		    "%s/%d (%s) had been defined in another module. Those clauses lost in the context of %s.",
		    name, arity,  ((umtype==T_PRED)?"static predicate":"dynamic predicate"),curmodmsg);
	  xsb_warn(CTXTc message);
	} else {
	  if (umtype != T_ORDI) {
	    psc_set_ep(psc,get_ep(pair_psc(found_pair)));
	    psc_set_type(psc,get_type(pair_psc(found_pair)));
	    psc_set_env(psc,get_env(pair_psc(found_pair)));
	  } else if (mtype != T_ORDI) {
	    psc_set_ep(pair_psc(found_pair),get_ep(psc));
	    psc_set_type(pair_psc(found_pair),get_type(psc));
	    psc_set_env(pair_psc(found_pair),get_env(psc));
	  } else {
	    set_psc_ep_to_psc(CTXTc pair_psc(found_pair),psc);
	  }
	}
	pair_psc(found_pair) = psc;
      }
    } else {
      found_pair = make_psc_pair(psc, search_ptr);
      if (global_flag)
	symbol_table_increment_and_check_for_overflow;
    }
    SYS_MUTEX_UNLOCK_NOERROR( MUTEX_SYMBOL ) ;
    return found_pair;
} /* link_sym */


/*
 * Get the PSC for ret/n.  If it already exists, just return it.  Or
 * create one and save it in ret_psc[n].
 */
Psc get_ret_psc(int n)
{
  Pair temp;
  int new_indicator;

  if (n > MAX_ARITY) {
    xsb_abort("Trying to get a ret_psc with too large an arity; too many variables");
    return NULL;
  }
  else if (ret_psc[n]) {
    return ret_psc[n];
  } else {
    //    temp = (Pair) insert("ret", (byte) n, global_mod, &new_indicator);
    temp = (Pair) insert("ret", n, global_mod, &new_indicator);
    return pair_psc(temp);
  }
}
  //  if (!ret_psc[n]) {
  //    temp = (Pair) insert("ret", (byte) n, global_mod, &new_indicator);
  //    ret_psc[n] = pair_psc(temp);
  //  }
  //  return ret_psc[n];


/*
 * Get the PSC for intern/1, a generic functor for storing in the roots
 * of interned tries.
 */
Psc get_intern_psc() {

  Pair intern_handle;
  int new_indicator;

  intern_handle = insert("intern", 1, global_mod, &new_indicator);
  return (pair_psc(intern_handle));
}


/* Used for PRISM port */
void insert_cpred(char * name,int arity,int (*pfunc)(void) ) {
    int dummy_flag;
    Psc psc;

    psc = insert(name,arity, global_mod, &dummy_flag)->psc_ptr;
    set_forn(psc,pfunc);
    psc_set_type(psc,T_FORN);

}

void strip_quotes(char *string) {
  // must be no quotes in filenames!!
  size_t len;
  if (string) {
    len = strlen(string);
    if (string[0] == '\'' && string[len-1] == '\'') {
      memmove(string,string+1,len-2);
      string[len-2] = '\0';
    }
  }
}

#define strmove(target,source,length) \
  do {memmove(target,source,length); \
    target[length] = '\0';		      \
  } while (0)

/* Used for parameterized modules and explicit filenames in mod specs */
/* all 3 returned paramters (last) must have space to hold results */

void split_modspec(char *modspec, char *modonly, char *modwpars, char *filename) {
  size_t modspeclen = strlen(modspec);
  size_t i;
  char *oploc;

  i = modspeclen;

  if (!strncmp(modspec,FILEQUALPAR,4) &&
      strncmp(modspec,FILEQUALPAR "usermod,",strlen(FILEQUALPAR "usermod,"))) { // explicit filename
    while (modspec[i] != ',') i--;  // No commas in filenames!
    if (filename) strmove(filename,modspec+i+1,modspeclen-i-2);
    if (modwpars) strmove(modwpars,modspec+FILEQUALPARLEN,
			  i-FILEQUALPARLEN);
    if (modonly) {
      oploc = strchr(modspec,'(');
      if (oploc) strmove(modonly,modspec+FILEQUALPARLEN,
			 (oploc-modspec-FILEQUALPARLEN));
      else strmove(modonly,modspec+FILEQUALPARLEN,
		   modspeclen-i-FILEQUALPARLEN);
    }
  } else if (!strncmp(modspec,"usermod(",strlen("usermod("))) {
    if (filename) strmove(filename,modspec+strlen("usermod("),
			  modspeclen-strlen("usermod(")-1);
    if (modonly) strcpy(modonly,"usermod");
    if (modwpars) strcpy(modwpars,"usermod");
  } else if (!strncmp(modspec,FILEQUALPAR "usermod,",
		      strlen(FILEQUALPAR "usermod,"))) {
    if (filename)
      strmove(filename,modspec+strlen(FILEQUALPAR "usermod,"),
	      modspeclen-strlen(FILEQUALPAR "usermod,")-1);
    if (modonly) strcpy(modonly,"usermod");
    if (modwpars) strcpy(modwpars,"usermod");
  } else {
    if (modwpars)strmove(modwpars,modspec,modspeclen);
    if (modonly || filename) {
      oploc = strchr(modspec,'(');
      if (oploc) {
	if (modonly) strmove(modonly,modspec,(oploc-modspec));
	if (filename) strmove(filename,modspec,(oploc-modspec));
      } else {
	if (modonly) strmove(modonly,modspec,modspeclen);
	if (filename) strmove(filename,modspec,modspeclen);
      }
    }
  }
  strip_quotes(modonly);
  strip_quotes(modwpars);
  strip_quotes(filename);
}
