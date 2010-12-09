/* Setting grabbed allows sharing of completed tables.
   If the subgoal frame is not new, and the table is being generated by
   a different thread, wait for it to complete.
 */
  grabbed = FALSE ;
  if (TABLE_IS_SHARED() && !IsNULL(producer_sf)) 
  {
     if( !is_completed(producer_sf) && subg_grabbed(producer_sf) 
				    && th->is_deadlock_leader )
     {
	grabbed = TRUE;
        subg_grabbed(producer_sf) = FALSE ;
	goto seq_table_try;
     }
     if( !is_completed(producer_sf) && subg_tid(producer_sf) != xsb_thread_id )
     {
	th->reset_thread = FALSE;
     	pthread_mutex_lock(&completing_mut);
     	SYS_MUTEX_INCR( MUTEX_COMPL );
     	while( !is_completed(producer_sf))
     	{  
	   table_tid = subg_tid(producer_sf) ;
	   waiting_for_thread = find_context(table_tid) ;
	   if( would_deadlock( table_tid, xsb_thread_id ) )
           {       /* code for leader */
                   reset_other_threads( th, waiting_for_thread, producer_sf );
                   /* unlocks completing_mut asap */
		   th->is_deadlock_leader = TRUE ;
		   grabbed = TRUE;
                   subg_grabbed(producer_sf) = FALSE ;
		   goto seq_table_try;
           }
           th->waiting_for_subgoal = producer_sf ;
           th->waiting_for_tid = table_tid ;
	   th->is_deadlock_leader = FALSE ;
	   pthread_cond_wait(&TIF_ComplCond(tip),&completing_mut);
           SYS_MUTEX_INCR( MUTEX_COMPL );
        }
        /* The thread has been reset and we should restart a tabletry instr */
        th->waiting_for_tid = -1 ;
        th->waiting_for_subgoal = NULL ;
        pthread_mutex_unlock(&completing_mut);
	if( th->reset_thread )
	{
        	lpcreg = pcreg ;
	        XSB_Next_Instr() ;
	}
     } 
  }

seq_table_try:
  if ( IsNULL(producer_sf) || grabbed ) {

    /* New Producer
       ------------ */
    CPtr producer_cpf;
    if( !grabbed )
    {
      producer_sf = NewProducerSF(CTXTc CallLUR_Leaf(lookupResults),
				   CallInfo_TableInfo(callInfo));
      subg_tid(producer_sf) = xsb_thread_id;
      subg_grabbed(producer_sf) = FALSE;
      UNLOCK_CALL_TRIE() ;
    }
    else
    {	subg_compl_stack_ptr(producer_sf) = openreg - COMPLFRAMESIZE;
    }
