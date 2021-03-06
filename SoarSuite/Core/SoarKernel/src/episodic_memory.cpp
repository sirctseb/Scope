#include <portability.h>

/*************************************************************************
 * PLEASE SEE THE FILE "COPYING" (INCLUDED WITH THIS SOFTWARE PACKAGE)
 * FOR LICENSE AND COPYRIGHT INFORMATION.
 *************************************************************************/

/*************************************************************************
 *
 *  file:  episodic_memory.cpp
 *
 * =======================================================================
 * Description  :  Various functions for Soar-EpMem
 * =======================================================================
 */

#include <cmath>
#include <algorithm>
#include <iterator>
#include <fstream>
#include <set>
#include <climits>

#include "episodic_memory.h"
#include "semantic_memory.h"

#include "agent.h"
#include "prefmem.h"
#include "symtab.h"
#include "wmem.h"
#include "print.h"
#include "xml.h"
#include "instantiations.h"
#include "decide.h"

#ifdef EPMEM_EXPERIMENT

uint64_t epmem_episodes_searched = 0;
uint64_t epmem_dc_interval_inserts = 0;
uint64_t epmem_dc_interval_removes = 0;
uint64_t epmem_dc_wme_adds = 0;
std::ofstream* epmem_exp_output = NULL;

enum epmem_exp_states
{
	exp_state_wm_adds,
	exp_state_wm_removes,
	exp_state_sqlite_mem,
};

int64_t epmem_exp_state[] = { 0, 0, 0 };

soar_module::timer* epmem_exp_timer = NULL;

#endif

//////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////
// Bookmark strings to help navigate the code
//////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////

// parameters	 				epmem::param
// stats 						epmem::stats
// timers 						epmem::timers
// statements					epmem::statements

// wme-related					epmem::wmes

// variable abstraction			epmem::var

// relational interval tree		epmem::rit

// cleaning up					epmem::clean
// initialization				epmem::init

// temporal hash				epmem::hash

// storing new episodes			epmem::storage
// non-cue-based queries		epmem::ncb
// cue-based queries			epmem::cbr

// vizualization				epmem::viz

// high-level api				epmem::api


//////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////
// Parameter Functions (epmem::params)
//////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////

epmem_param_container::epmem_param_container( agent *new_agent ): soar_module::param_container( new_agent )
{
	// learning
	learning = new soar_module::boolean_param( "learning", soar_module::off, new soar_module::f_predicate<soar_module::boolean>() );
	add( learning );

	////////////////////
	// Encoding
	////////////////////

	// phase
	phase = new soar_module::constant_param<phase_choices>( "phase", phase_output, new soar_module::f_predicate<phase_choices>() );
	phase->add_mapping( phase_output, "output" );
	phase->add_mapping( phase_selection, "selection" );
	add( phase );

	// trigger
	trigger = new soar_module::constant_param<trigger_choices>( "trigger", output, new soar_module::f_predicate<trigger_choices>() );
	trigger->add_mapping( none, "none" );
	trigger->add_mapping( output, "output" );
	trigger->add_mapping( dc, "dc" );
	add( trigger );

	// force
	force = new soar_module::constant_param<force_choices>( "force", force_off, new soar_module::f_predicate<force_choices>() );
	force->add_mapping( remember, "remember" );
	force->add_mapping( ignore, "ignore" );
	force->add_mapping( force_off, "off" );
	add( force );

	// exclusions - this is initialized with "epmem" directly after hash tables
	exclusions = new soar_module::sym_set_param( "exclusions", new soar_module::f_predicate<const char *>, my_agent );
	add( exclusions );


	////////////////////
	// Storage
	////////////////////

	// database
	database = new soar_module::constant_param<db_choices>( "database", memory, new epmem_db_predicate<db_choices>( my_agent ) );
	database->add_mapping( memory, "memory" );
	database->add_mapping( file, "file" );
	add( database );

	// path
	path = new epmem_path_param( "path", "", new soar_module::predicate<const char *>(), new epmem_db_predicate<const char *>( my_agent ), my_agent );
	add( path );

	// auto-commit
	lazy_commit = new soar_module::boolean_param( "lazy-commit", soar_module::on, new epmem_db_predicate<soar_module::boolean>( my_agent ) );
	add( lazy_commit );


	////////////////////
	// Retrieval
	////////////////////

	// graph-match
	graph_match = new soar_module::boolean_param( "graph-match", soar_module::on, new soar_module::f_predicate<soar_module::boolean>() );
	add( graph_match );

	// balance
	balance = new soar_module::decimal_param( "balance", 1, new soar_module::btw_predicate<double>( 0, 1, true ), new soar_module::f_predicate<double>() );
	add( balance );


	////////////////////
	// Performance
	////////////////////

	// timers
	timers = new soar_module::constant_param<soar_module::timer::timer_level>( "timers", soar_module::timer::zero, new soar_module::f_predicate<soar_module::timer::timer_level>() );
	timers->add_mapping( soar_module::timer::zero, "off" );
	timers->add_mapping( soar_module::timer::one, "one" );
	timers->add_mapping( soar_module::timer::two, "two" );
	timers->add_mapping( soar_module::timer::three, "three" );
	add( timers );

	// page_size
	page_size = new soar_module::constant_param<page_choices>( "page-size", page_8k, new epmem_db_predicate<page_choices>( my_agent ) );
	page_size->add_mapping( page_1k, "1k" );
	page_size->add_mapping( page_2k, "2k" );
	page_size->add_mapping( page_4k, "4k" );
	page_size->add_mapping( page_8k, "8k" );
	page_size->add_mapping( page_16k, "16k" );
	page_size->add_mapping( page_32k, "32k" );
	page_size->add_mapping( page_64k, "64k" );
	add( page_size );

	// cache_size
	cache_size = new soar_module::integer_param( "cache-size", 10000, new soar_module::gt_predicate<int64_t>( 1, true ), new epmem_db_predicate<int64_t>( my_agent ) );
	add( cache_size );

	// opt
	opt = new soar_module::constant_param<opt_choices>( "optimization", opt_speed, new epmem_db_predicate<opt_choices>( my_agent ) );
	opt->add_mapping( opt_safety, "safety" );
	opt->add_mapping( opt_speed, "performance" );
	add( opt );


	////////////////////
	// Experimental
	////////////////////

	gm_ordering = new soar_module::constant_param<gm_ordering_choices>( "graph-match-ordering", gm_order_undefined, new soar_module::f_predicate<gm_ordering_choices>() );
	gm_ordering->add_mapping( gm_order_undefined, "undefined" );
	gm_ordering->add_mapping( gm_order_dfs, "dfs" );
	gm_ordering->add_mapping( gm_order_mcv, "mcv" );
	add( gm_ordering );

	// merge
	merge = new soar_module::constant_param<merge_choices>( "merge", merge_none, new soar_module::f_predicate<merge_choices>() );
	merge->add_mapping( merge_none, "none" );
	merge->add_mapping( merge_add, "add" );
	add( merge );
}

//

epmem_path_param::epmem_path_param( const char *new_name, const char *new_value, soar_module::predicate<const char *> *new_val_pred, soar_module::predicate<const char *> *new_prot_pred, agent *new_agent ): soar_module::string_param( new_name, new_value, new_val_pred, new_prot_pred ), my_agent( new_agent ) {}

void epmem_path_param::set_value( const char *new_value )
{
	if ( my_agent->epmem_first_switch )
	{
		my_agent->epmem_first_switch = false;
		my_agent->epmem_params->database->set_value( epmem_param_container::file );

		const char *msg = "Database set to file";
		print( my_agent, const_cast<char *>( msg ) );
		xml_generate_message( my_agent, const_cast<char *>( msg ) );
	}

	value->assign( new_value );
}

//

template <typename T>
epmem_db_predicate<T>::epmem_db_predicate( agent *new_agent ): soar_module::agent_predicate<T>( new_agent ) {}

template <typename T>
bool epmem_db_predicate<T>::operator() ( T /*val*/ ) { return ( this->my_agent->epmem_db->get_status() == soar_module::connected ); }


/***************************************************************************
 * Function     : epmem_enabled
 * Author		: Nate Derbinsky
 * Notes		: Shortcut function to system parameter
 **************************************************************************/
bool epmem_enabled( agent *my_agent )
{
	return ( my_agent->epmem_params->learning->get_value() == soar_module::on );
}

//////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////
// Statistic Functions (epmem::stats)
//////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////

epmem_stat_container::epmem_stat_container( agent *new_agent ): soar_module::stat_container( new_agent )
{
	// time
	time = new epmem_time_id_stat( "time", 0, new epmem_db_predicate<epmem_time_id>( my_agent ) );
	add( time );

	// db-lib-version
	db_lib_version = new epmem_db_lib_version_stat( my_agent, "db-lib-version", NULL, new soar_module::predicate< const char* >() );
	add( db_lib_version );

	// mem-usage
	mem_usage = new epmem_mem_usage_stat( my_agent, "mem-usage", 0, new soar_module::predicate<int64_t>() );
	add( mem_usage );

	// mem-high
	mem_high = new epmem_mem_high_stat( my_agent, "mem-high", 0, new soar_module::predicate<int64_t>() );
	add( mem_high );

	// cue-based-retrievals
	cbr = new soar_module::integer_stat( "queries", 0, new soar_module::f_predicate<int64_t>() );
	add( cbr );

	// nexts
	nexts = new soar_module::integer_stat( "nexts", 0, new soar_module::f_predicate<int64_t>() );
	add( nexts );

	// prev's
	prevs = new soar_module::integer_stat( "prevs", 0, new soar_module::f_predicate<int64_t>() );
	add( prevs );

	// ncb-wmes
	ncb_wmes = new soar_module::integer_stat( "ncb-wmes", 0, new soar_module::f_predicate<int64_t>() );
	add( ncb_wmes );

	// qry-pos
	qry_pos = new soar_module::integer_stat( "qry-pos", 0, new soar_module::f_predicate<int64_t>() );
	add( qry_pos );

	// qry-neg
	qry_neg = new soar_module::integer_stat( "qry-neg", 0, new soar_module::f_predicate<int64_t>() );
	add( qry_neg );

	// qry-ret
	qry_ret = new epmem_time_id_stat( "qry-ret", 0, new soar_module::f_predicate<epmem_time_id>() );
	add( qry_ret );

	// qry-card
	qry_card = new soar_module::integer_stat( "qry-card", 0, new soar_module::f_predicate<int64_t>() );
	add( qry_card );

	// qry-lits
	qry_lits = new soar_module::integer_stat( "qry-lits", 0, new soar_module::f_predicate<int64_t>() );
	add( qry_lits );

	// next-id
	next_id = new epmem_node_id_stat( "next-id", 0, new epmem_db_predicate<epmem_node_id>( my_agent ) );
	add( next_id );

	// rit-offset-1
	rit_offset_1 = new soar_module::integer_stat( "rit-offset-1", 0, new epmem_db_predicate<int64_t>( my_agent ) );
	add( rit_offset_1 );

	// rit-left-root-1
	rit_left_root_1 = new soar_module::integer_stat( "rit-left-root-1", 0, new epmem_db_predicate<int64_t>( my_agent ) );
	add( rit_left_root_1 );

	// rit-right-root-1
	rit_right_root_1 = new soar_module::integer_stat( "rit-right-root-1", 0, new epmem_db_predicate<int64_t>( my_agent ) );
	add( rit_right_root_1 );

	// rit-min-step-1
	rit_min_step_1 = new soar_module::integer_stat( "rit-min-step-1", 0, new epmem_db_predicate<int64_t>( my_agent ) );
	add( rit_min_step_1 );

	// rit-offset-2
	rit_offset_2 = new soar_module::integer_stat( "rit-offset-2", 0, new epmem_db_predicate<int64_t>( my_agent ) );
	add( rit_offset_2 );

	// rit-left-root-2
	rit_left_root_2 = new soar_module::integer_stat( "rit-left-root-2", 0, new epmem_db_predicate<int64_t>( my_agent ) );
	add( rit_left_root_2 );

	// rit-right-root-2
	rit_right_root_2 = new soar_module::integer_stat( "rit-right-root-2", 0, new epmem_db_predicate<int64_t>( my_agent ) );
	add( rit_right_root_2 );

	// rit-min-step-2
	rit_min_step_2 = new soar_module::integer_stat( "rit-min-step-2", 0, new epmem_db_predicate<int64_t>( my_agent ) );
	add( rit_min_step_2 );


	/////////////////////////////
	// connect to rit state
	/////////////////////////////

	// graph
	my_agent->epmem_rit_state_graph[ EPMEM_RIT_STATE_NODE ].offset.stat = rit_offset_1;
	my_agent->epmem_rit_state_graph[ EPMEM_RIT_STATE_NODE ].offset.var_key = var_rit_offset_1;
	my_agent->epmem_rit_state_graph[ EPMEM_RIT_STATE_NODE ].leftroot.stat = rit_left_root_1;
	my_agent->epmem_rit_state_graph[ EPMEM_RIT_STATE_NODE ].leftroot.var_key = var_rit_leftroot_1;
	my_agent->epmem_rit_state_graph[ EPMEM_RIT_STATE_NODE ].rightroot.stat = rit_right_root_1;
	my_agent->epmem_rit_state_graph[ EPMEM_RIT_STATE_NODE ].rightroot.var_key = var_rit_rightroot_1;
	my_agent->epmem_rit_state_graph[ EPMEM_RIT_STATE_NODE ].minstep.stat = rit_min_step_1;
	my_agent->epmem_rit_state_graph[ EPMEM_RIT_STATE_NODE ].minstep.var_key = var_rit_minstep_1;

	my_agent->epmem_rit_state_graph[ EPMEM_RIT_STATE_EDGE ].offset.stat = rit_offset_2;
	my_agent->epmem_rit_state_graph[ EPMEM_RIT_STATE_EDGE ].offset.var_key = var_rit_offset_2;
	my_agent->epmem_rit_state_graph[ EPMEM_RIT_STATE_EDGE ].leftroot.stat = rit_left_root_2;
	my_agent->epmem_rit_state_graph[ EPMEM_RIT_STATE_EDGE ].leftroot.var_key = var_rit_leftroot_2;
	my_agent->epmem_rit_state_graph[ EPMEM_RIT_STATE_EDGE ].rightroot.stat = rit_right_root_2;
	my_agent->epmem_rit_state_graph[ EPMEM_RIT_STATE_EDGE ].rightroot.var_key = var_rit_rightroot_2;
	my_agent->epmem_rit_state_graph[ EPMEM_RIT_STATE_EDGE ].minstep.stat = rit_min_step_2;
	my_agent->epmem_rit_state_graph[ EPMEM_RIT_STATE_EDGE ].minstep.var_key = var_rit_minstep_2;
}

//

epmem_db_lib_version_stat::epmem_db_lib_version_stat( agent* new_agent, const char* new_name, const char* new_value, soar_module::predicate< const char* >* new_prot_pred ): soar_module::primitive_stat< const char* >( new_name, new_value, new_prot_pred ), my_agent( new_agent ) {}

const char* epmem_db_lib_version_stat::get_value()
{
	return my_agent->epmem_db->lib_version();
}

//

epmem_mem_usage_stat::epmem_mem_usage_stat( agent *new_agent, const char *new_name, int64_t new_value, soar_module::predicate<int64_t> *new_prot_pred ): soar_module::integer_stat( new_name, new_value, new_prot_pred ), my_agent( new_agent ) {}

int64_t epmem_mem_usage_stat::get_value()
{
	return my_agent->epmem_db->memory_usage();
}

//

epmem_mem_high_stat::epmem_mem_high_stat( agent *new_agent, const char *new_name, int64_t new_value, soar_module::predicate<int64_t> *new_prot_pred ): soar_module::integer_stat( new_name, new_value, new_prot_pred ), my_agent( new_agent ) {}

int64_t epmem_mem_high_stat::get_value()
{
	return my_agent->epmem_db->memory_highwater();
}


//////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////
// Timer Functions (epmem::timers)
//////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////

epmem_timer_container::epmem_timer_container( agent *new_agent ): soar_module::timer_container( new_agent )
{
	// one

	total = new epmem_timer( "_total", my_agent, soar_module::timer::one );
	add( total );

	// two

	storage = new epmem_timer( "epmem_storage", my_agent, soar_module::timer::two );
	add( storage );

	ncb_retrieval = new epmem_timer( "epmem_ncb_retrieval", my_agent, soar_module::timer::two );
	add( ncb_retrieval );

	query = new epmem_timer( "epmem_query", my_agent, soar_module::timer::two );
	add( query );

	api = new epmem_timer( "epmem_api", my_agent, soar_module::timer::two );
	add( api );

	trigger = new epmem_timer( "epmem_trigger", my_agent, soar_module::timer::two );
	add( trigger );

	init = new epmem_timer( "epmem_init", my_agent, soar_module::timer::two );
	add( init );

	next = new epmem_timer( "epmem_next", my_agent, soar_module::timer::two );
	add( next );

	prev = new epmem_timer( "epmem_prev", my_agent, soar_module::timer::two );
	add( prev );

	hash = new epmem_timer( "epmem_hash", my_agent, soar_module::timer::two );
	add( hash );

	wm_phase = new epmem_timer( "epmem_wm_phase", my_agent, soar_module::timer::two );
	add( wm_phase );

	// three

	ncb_edge = new epmem_timer( "ncb_edge", my_agent, soar_module::timer::three );
	add( ncb_edge );

	ncb_edge_rit = new epmem_timer( "ncb_edge_rit", my_agent, soar_module::timer::three );
	add( ncb_edge_rit );

	ncb_node = new epmem_timer( "ncb_node", my_agent, soar_module::timer::three );
	add( ncb_node );

	ncb_node_rit = new epmem_timer( "ncb_node_rit", my_agent, soar_module::timer::three );
	add( ncb_node_rit );

	query_dnf = new epmem_timer( "query_dnf", my_agent, soar_module::timer::three );
	add( query_dnf );

	query_graph_match = new epmem_timer( "query_graph_match", my_agent, soar_module::timer::three );
	add( query_graph_match );

	query_pos_start_ep = new epmem_timer( "query_pos_start_ep", my_agent, soar_module::timer::three );
	add( query_pos_start_ep );

	query_pos_start_now = new epmem_timer( "query_pos_start_now", my_agent, soar_module::timer::three );
	add( query_pos_start_now );

	query_pos_start_point = new epmem_timer( "query_pos_start_point", my_agent, soar_module::timer::three );
	add( query_pos_start_point );

	query_pos_end_ep = new epmem_timer( "query_pos_end_ep", my_agent, soar_module::timer::three );
	add( query_pos_end_ep );

	query_pos_end_now = new epmem_timer( "query_pos_end_now", my_agent, soar_module::timer::three );
	add( query_pos_end_now );

	query_pos_end_point = new epmem_timer( "query_pos_end_point", my_agent, soar_module::timer::three );
	add( query_pos_end_point );

	query_neg_start_ep = new epmem_timer( "query_neg_start_ep", my_agent, soar_module::timer::three );
	add( query_neg_start_ep );

	query_neg_start_now = new epmem_timer( "query_neg_start_now", my_agent, soar_module::timer::three );
	add( query_neg_start_now );

	query_neg_start_point = new epmem_timer( "query_neg_start_point", my_agent, soar_module::timer::three );
	add( query_neg_start_point );

	query_neg_end_ep = new epmem_timer( "query_neg_end_ep", my_agent, soar_module::timer::three );
	add( query_neg_end_ep );

	query_neg_end_now = new epmem_timer( "query_neg_end_now", my_agent, soar_module::timer::three );
	add( query_neg_end_now );

	query_neg_end_point = new epmem_timer( "query_neg_end_point", my_agent, soar_module::timer::three );
	add( query_neg_end_point );

	/////////////////////////////
	// connect to rit state
	/////////////////////////////

	// graph
	my_agent->epmem_rit_state_graph[ EPMEM_RIT_STATE_NODE ].timer = ncb_node_rit;
	my_agent->epmem_rit_state_graph[ EPMEM_RIT_STATE_EDGE ].timer = ncb_edge_rit;
}

//

epmem_timer_level_predicate::epmem_timer_level_predicate( agent *new_agent ): soar_module::agent_predicate<soar_module::timer::timer_level>( new_agent ) {}

bool epmem_timer_level_predicate::operator() ( soar_module::timer::timer_level val ) { return ( my_agent->epmem_params->timers->get_value() >= val ); }

//

epmem_timer::epmem_timer(const char *new_name, agent *new_agent, soar_module::timer::timer_level new_level): soar_module::timer( new_name, new_agent, new_level, new epmem_timer_level_predicate( new_agent ) ) {}


//////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////
// Statement Functions (epmem::statements)
//////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////

epmem_common_statement_container::epmem_common_statement_container( agent *new_agent ): soar_module::sqlite_statement_container( new_agent->epmem_db )
{
	soar_module::sqlite_database *new_db = new_agent->epmem_db;

	//

	add_structure( "CREATE TABLE IF NOT EXISTS vars (id INTEGER PRIMARY KEY,value NONE)" );
	add_structure( "CREATE TABLE IF NOT EXISTS rit_left_nodes (min INTEGER, max INTEGER)" );
	add_structure( "CREATE TABLE IF NOT EXISTS rit_right_nodes (node INTEGER)" );
	add_structure( "CREATE TABLE IF NOT EXISTS temporal_symbol_hash (id INTEGER PRIMARY KEY, sym_const NONE, sym_type INTEGER)" );
	add_structure( "CREATE UNIQUE INDEX IF NOT EXISTS temporal_symbol_hash_const_type ON temporal_symbol_hash (sym_type,sym_const)" );

	// workaround for tree: type 1 = IDENTIFIER_SYMBOL_TYPE
	add_structure( "INSERT OR IGNORE INTO temporal_symbol_hash (id,sym_const,sym_type) VALUES (0,NULL,1)" );

	// workaround for acceptable preference wmes: id 1 = "operator+"
	add_structure( "INSERT OR IGNORE INTO temporal_symbol_hash (id,sym_const,sym_type) VALUES (1,'operator*',2)" );

	//

	begin = new soar_module::sqlite_statement( new_db, "BEGIN" );
	add( begin );

	commit = new soar_module::sqlite_statement( new_db, "COMMIT" );
	add( commit );

	rollback = new soar_module::sqlite_statement( new_db, "ROLLBACK" );
	add( rollback );

	//

	var_get = new soar_module::sqlite_statement( new_db, "SELECT value FROM vars WHERE id=?" );
	add( var_get );

	var_set = new soar_module::sqlite_statement( new_db, "REPLACE INTO vars (id,value) VALUES (?,?)" );
	add( var_set );

	//

	rit_add_left = new soar_module::sqlite_statement( new_db, "INSERT INTO rit_left_nodes (min,max) VALUES (?,?)" );
	add( rit_add_left );

	rit_truncate_left = new soar_module::sqlite_statement( new_db, "DELETE FROM rit_left_nodes" );
	add( rit_truncate_left );

	rit_add_right = new soar_module::sqlite_statement( new_db, "INSERT INTO rit_right_nodes (node) VALUES (?)" );
	add( rit_add_right );

	rit_truncate_right = new soar_module::sqlite_statement( new_db, "DELETE FROM rit_right_nodes" );
	add( rit_truncate_right );

	//

	hash_get = new soar_module::sqlite_statement( new_db, "SELECT id FROM temporal_symbol_hash WHERE sym_type=? AND sym_const=?" );
	add( hash_get );

	hash_add = new soar_module::sqlite_statement( new_db, "INSERT INTO temporal_symbol_hash (sym_type,sym_const) VALUES (?,?)" );
	add( hash_add );
}

epmem_graph_statement_container::epmem_graph_statement_container( agent *new_agent ): soar_module::sqlite_statement_container( new_agent->epmem_db )
{
	soar_module::sqlite_database *new_db = new_agent->epmem_db;

	//

	add_structure( "CREATE TABLE IF NOT EXISTS times (id INTEGER PRIMARY KEY)" );

	add_structure( "CREATE TABLE IF NOT EXISTS node_now (id INTEGER,start INTEGER)" );
	add_structure( "CREATE INDEX IF NOT EXISTS node_now_start ON node_now (start)" );
	add_structure( "CREATE UNIQUE INDEX IF NOT EXISTS node_now_id_start ON node_now (id,start DESC)" );

	add_structure( "CREATE TABLE IF NOT EXISTS edge_now (id INTEGER,start INTEGER)" );
	add_structure( "CREATE INDEX IF NOT EXISTS edge_now_start ON edge_now (start)" );
	add_structure( "CREATE UNIQUE INDEX IF NOT EXISTS edge_now_id_start ON edge_now (id,start DESC)" );

	add_structure( "CREATE TABLE IF NOT EXISTS node_point (id INTEGER,start INTEGER)" );
	add_structure( "CREATE UNIQUE INDEX IF NOT EXISTS node_point_id_start ON node_point (id,start DESC)" );
	add_structure( "CREATE INDEX IF NOT EXISTS node_point_start ON node_point (start)" );

	add_structure( "CREATE TABLE IF NOT EXISTS edge_point (id INTEGER,start INTEGER)" );
	add_structure( "CREATE UNIQUE INDEX IF NOT EXISTS edge_point_id_start ON edge_point (id,start DESC)" );
	add_structure( "CREATE INDEX IF NOT EXISTS edge_point_start ON edge_point (start)" );

	add_structure( "CREATE TABLE IF NOT EXISTS node_range (rit_node INTEGER,start INTEGER,end INTEGER,id INTEGER)" );
	add_structure( "CREATE INDEX IF NOT EXISTS node_range_lower ON node_range (rit_node,start)" );
	add_structure( "CREATE INDEX IF NOT EXISTS node_range_upper ON node_range (rit_node,end)" );
	add_structure( "CREATE UNIQUE INDEX IF NOT EXISTS node_range_id_start ON node_range (id,start DESC)" );
	add_structure( "CREATE UNIQUE INDEX IF NOT EXISTS node_range_id_end ON node_range (id,end DESC)" );

	add_structure( "CREATE TABLE IF NOT EXISTS edge_range (rit_node INTEGER,start INTEGER,end INTEGER,id INTEGER)" );
	add_structure( "CREATE INDEX IF NOT EXISTS edge_range_lower ON edge_range (rit_node,start)" );
	add_structure( "CREATE INDEX IF NOT EXISTS edge_range_upper ON edge_range (rit_node,end)" );
	add_structure( "CREATE UNIQUE INDEX IF NOT EXISTS edge_range_id_start ON edge_range (id,start DESC)" );
	add_structure( "CREATE UNIQUE INDEX IF NOT EXISTS edge_range_id_end ON edge_range (id,end DESC)" );

	add_structure( "CREATE TABLE IF NOT EXISTS node_unique (child_id INTEGER PRIMARY KEY AUTOINCREMENT,parent_id INTEGER,attrib INTEGER, value INTEGER)" );
	add_structure( "CREATE UNIQUE INDEX IF NOT EXISTS node_unique_parent_attrib_value ON node_unique (parent_id,attrib,value)" );

	add_structure( "CREATE TABLE IF NOT EXISTS edge_unique (parent_id INTEGER PRIMARY KEY AUTOINCREMENT,q0 INTEGER,w INTEGER,q1 INTEGER)" );
	add_structure( "CREATE INDEX IF NOT EXISTS edge_unique_q0_w_q1 ON edge_unique (q0,w,q1)" );

	add_structure( "CREATE TABLE IF NOT EXISTS lti (parent_id INTEGER PRIMARY KEY, letter INTEGER, num INTEGER, time_id INTEGER)" );
	add_structure( "CREATE UNIQUE INDEX IF NOT EXISTS lti_letter_num ON lti (letter,num)" );

	// adding an ascii table just to make lti queries easier when inspecting database
	add_structure( "CREATE TABLE IF NOT EXISTS ascii (ascii_num INTEGER PRIMARY KEY, ascii_chr TEXT)" );
	add_structure( "DELETE FROM ascii" );
	{
		add_structure( "INSERT INTO ascii (ascii_num, ascii_chr) VALUES (65,'A')" );
		add_structure( "INSERT INTO ascii (ascii_num, ascii_chr) VALUES (66,'B')" );
		add_structure( "INSERT INTO ascii (ascii_num, ascii_chr) VALUES (67,'C')" );
		add_structure( "INSERT INTO ascii (ascii_num, ascii_chr) VALUES (68,'D')" );
		add_structure( "INSERT INTO ascii (ascii_num, ascii_chr) VALUES (69,'E')" );
		add_structure( "INSERT INTO ascii (ascii_num, ascii_chr) VALUES (70,'F')" );
		add_structure( "INSERT INTO ascii (ascii_num, ascii_chr) VALUES (71,'G')" );
		add_structure( "INSERT INTO ascii (ascii_num, ascii_chr) VALUES (72,'H')" );
		add_structure( "INSERT INTO ascii (ascii_num, ascii_chr) VALUES (73,'I')" );
		add_structure( "INSERT INTO ascii (ascii_num, ascii_chr) VALUES (74,'J')" );
		add_structure( "INSERT INTO ascii (ascii_num, ascii_chr) VALUES (75,'K')" );
		add_structure( "INSERT INTO ascii (ascii_num, ascii_chr) VALUES (76,'L')" );
		add_structure( "INSERT INTO ascii (ascii_num, ascii_chr) VALUES (77,'M')" );
		add_structure( "INSERT INTO ascii (ascii_num, ascii_chr) VALUES (78,'N')" );
		add_structure( "INSERT INTO ascii (ascii_num, ascii_chr) VALUES (79,'O')" );
		add_structure( "INSERT INTO ascii (ascii_num, ascii_chr) VALUES (80,'P')" );
		add_structure( "INSERT INTO ascii (ascii_num, ascii_chr) VALUES (81,'Q')" );
		add_structure( "INSERT INTO ascii (ascii_num, ascii_chr) VALUES (82,'R')" );
		add_structure( "INSERT INTO ascii (ascii_num, ascii_chr) VALUES (83,'S')" );
		add_structure( "INSERT INTO ascii (ascii_num, ascii_chr) VALUES (84,'T')" );
		add_structure( "INSERT INTO ascii (ascii_num, ascii_chr) VALUES (85,'U')" );
		add_structure( "INSERT INTO ascii (ascii_num, ascii_chr) VALUES (86,'V')" );
		add_structure( "INSERT INTO ascii (ascii_num, ascii_chr) VALUES (87,'W')" );
		add_structure( "INSERT INTO ascii (ascii_num, ascii_chr) VALUES (88,'X')" );
		add_structure( "INSERT INTO ascii (ascii_num, ascii_chr) VALUES (89,'Y')" );
		add_structure( "INSERT INTO ascii (ascii_num, ascii_chr) VALUES (90,'Z')" );
	}

	//

	add_time = new soar_module::sqlite_statement( new_db, "INSERT INTO times (id) VALUES (?)" );
	add( add_time );

	//

	add_node_now = new soar_module::sqlite_statement( new_db, "INSERT INTO node_now (id,start) VALUES (?,?)" );
	add( add_node_now );

	delete_node_now = new soar_module::sqlite_statement( new_db, "DELETE FROM node_now WHERE id=?" );
	add( delete_node_now );

	add_node_point = new soar_module::sqlite_statement( new_db, "INSERT INTO node_point (id,start) VALUES (?,?)" );
	add( add_node_point );

	add_node_range = new soar_module::sqlite_statement( new_db, "INSERT INTO node_range (rit_node,start,end,id) VALUES (?,?,?,?)" );
	add( add_node_range );


	add_node_unique = new soar_module::sqlite_statement( new_db, "INSERT INTO node_unique (parent_id,attrib,value) VALUES (?,?,?)" );
	add( add_node_unique );

	find_node_unique = new soar_module::sqlite_statement( new_db, "SELECT child_id FROM node_unique WHERE parent_id=? AND attrib=? AND value=?" );
	add( find_node_unique );

	//

	add_edge_now = new soar_module::sqlite_statement( new_db, "INSERT INTO edge_now (id,start) VALUES (?,?)" );
	add( add_edge_now );

	delete_edge_now = new soar_module::sqlite_statement( new_db, "DELETE FROM edge_now WHERE id=?" );
	add( delete_edge_now );

	add_edge_point = new soar_module::sqlite_statement( new_db, "INSERT INTO edge_point (id,start) VALUES (?,?)" );
	add( add_edge_point );

	add_edge_range = new soar_module::sqlite_statement( new_db, "INSERT INTO edge_range (rit_node,start,end,id) VALUES (?,?,?,?)" );
	add( add_edge_range );


	add_edge_unique = new soar_module::sqlite_statement( new_db, "INSERT INTO edge_unique (q0,w,q1) VALUES (?,?,?)" );
	add( add_edge_unique );

	find_edge_unique = new soar_module::sqlite_statement( new_db, "SELECT parent_id, q1 FROM edge_unique WHERE q0=? AND w=?" );
	add( find_edge_unique );

	find_edge_unique_shared = new soar_module::sqlite_statement( new_db, "SELECT parent_id, q1 FROM edge_unique WHERE q0=? AND w=? AND q1=?" );
	add( find_edge_unique_shared );

	//

	valid_episode = new soar_module::sqlite_statement( new_db, "SELECT COUNT(*) AS ct FROM times WHERE id=?" );
	add( valid_episode );

	next_episode = new soar_module::sqlite_statement( new_db, "SELECT id FROM times WHERE id>? ORDER BY id ASC LIMIT 1" );
	add( next_episode );

	prev_episode = new soar_module::sqlite_statement( new_db, "SELECT id FROM times WHERE id<? ORDER BY id DESC LIMIT 1" );
	add( prev_episode );


	get_nodes = new soar_module::sqlite_statement( new_db, "SELECT f.child_id, f.parent_id, h1.sym_const, h2.sym_const, h1.sym_type, h2.sym_type FROM node_unique f, temporal_symbol_hash h1, temporal_symbol_hash h2 WHERE f.child_id IN (SELECT n.id FROM node_now n WHERE n.start<= ? UNION ALL SELECT p.id FROM node_point p WHERE p.start=? UNION ALL SELECT e1.id FROM node_range e1, rit_left_nodes lt WHERE e1.rit_node=lt.min AND e1.end >= ? UNION ALL SELECT e2.id FROM node_range e2, rit_right_nodes rt WHERE e2.rit_node = rt.node AND e2.start <= ?) AND f.attrib=h1.id AND f.value=h2.id ORDER BY f.child_id ASC", new_agent->epmem_timers->ncb_node );
	add( get_nodes );

	get_edges = new soar_module::sqlite_statement( new_db, "SELECT f.q0, h.sym_const, f.q1, h.sym_type, lti.letter, lti.num FROM edge_unique f INNER JOIN temporal_symbol_hash h ON f.w=h.id LEFT JOIN lti ON (f.q1=lti.parent_id AND lti.time_id <= ?) WHERE f.parent_id IN (SELECT n.id FROM edge_now n WHERE n.start<= ? UNION ALL SELECT p.id FROM edge_point p WHERE p.start = ? UNION ALL SELECT e1.id FROM edge_range e1, rit_left_nodes lt WHERE e1.rit_node=lt.min AND e1.end >= ? UNION ALL SELECT e2.id FROM edge_range e2, rit_right_nodes rt WHERE e2.rit_node = rt.node AND e2.start <= ?) ORDER BY f.q0 ASC, f.q1 ASC", new_agent->epmem_timers->ncb_edge );
	add( get_edges );

	//

	promote_id = new soar_module::sqlite_statement( new_db, "INSERT OR IGNORE INTO lti (parent_id,letter,num,time_id) VALUES (?,?,?,?)" );
	add( promote_id );

	find_lti = new soar_module::sqlite_statement( new_db, "SELECT parent_id FROM lti WHERE letter=? AND num=?" );
	add( find_lti );

	find_lti_promotion_time = new soar_module::sqlite_statement( new_db, "SELECT time_id FROM lti WHERE letter=? AND num=?" );
	add( find_lti_promotion_time );

	//
	//

	// init statement pools
	{
		int j, k, m;

		const char *epmem_range_queries[2][2][3] =
		{
			{
				{
					"SELECT e.start AS start FROM node_range e WHERE e.id=? ORDER BY e.start DESC",
					"SELECT e.start AS start FROM node_now e WHERE e.id=? ORDER BY e.start DESC",
					"SELECT e.start AS start FROM node_point e WHERE e.id=? ORDER BY e.start DESC"
				},
				{
					"SELECT e.end AS end FROM node_range e WHERE e.id=? ORDER BY e.end DESC",
					"SELECT ? AS end FROM node_now e WHERE e.id=?",
					"SELECT e.start AS end FROM node_point e WHERE e.id=? ORDER BY e.start DESC"
				}
			},
			{
				{
					"SELECT e.start AS start FROM edge_range e WHERE e.id=? ORDER BY e.start DESC",
					"SELECT e.start AS start FROM edge_now e WHERE e.id=? ORDER BY e.start DESC",
					"SELECT e.start AS start FROM edge_point e WHERE e.id=? ORDER BY e.start DESC"
				},
				{
					"SELECT e.end AS end FROM edge_range e WHERE e.id=? ORDER BY e.end DESC",
					"SELECT ? AS end FROM edge_now e WHERE e.id=?",
					"SELECT e.start AS end FROM edge_point e WHERE e.id=? ORDER BY e.start DESC"
				}
			},
		};

		for ( j=EPMEM_RIT_STATE_NODE; j<=EPMEM_RIT_STATE_EDGE; j++ )
		{
			for ( k=EPMEM_RANGE_START; k<=EPMEM_RANGE_END; k++ )
			{
				for( m=EPMEM_RANGE_EP; m<=EPMEM_RANGE_POINT; m++ )
				{
					pool_range_queries[ j ][ k ][ m ] = new soar_module::sqlite_statement_pool( new_agent, new_db, epmem_range_queries[ j ][ k ][ m ] );
				}
			}
		}

		//

		const char *epmem_range_lti_queries[2][3] =
		{
			{
				"SELECT e.start AS start FROM edge_range e WHERE e.start>? AND e.id=? ORDER BY e.start DESC",
				"SELECT e.start AS start FROM edge_now e WHERE e.start>? AND e.id=? ORDER BY e.start DESC",
				"SELECT e.start AS start FROM edge_point e WHERE e.start>? AND e.id=? ORDER BY e.start DESC"
			},
			{
				"SELECT e.end AS end FROM edge_range e WHERE e.end>=? AND e.id=? ORDER BY e.end DESC",
				"SELECT ? AS end FROM edge_now e WHERE e.id=?",
				"SELECT e.start AS end FROM edge_point e WHERE e.id=? ORDER BY e.start DESC"
			}
		};

		for ( k=EPMEM_RANGE_START; k<=EPMEM_RANGE_END; k++ )
		{
			for( m=EPMEM_RANGE_EP; m<=EPMEM_RANGE_POINT; m++ )
			{
				pool_range_lti_queries[ k ][ m ] = new soar_module::sqlite_statement_pool( new_agent, new_db, epmem_range_lti_queries[ k ][ m ] );
			}
		}

		//

		pool_range_lti_start = new soar_module::sqlite_statement_pool( new_agent, new_db, "SELECT ? as start" );
	}
}


//////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////
// WME Functions (epmem::wmes)
//////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////

/***************************************************************************
 * Function     : epmem_get_augs_of_id
 * Author		: Nate Derbinsky
 * Notes		: This routine gets all wmes rooted at an id.
 **************************************************************************/
epmem_wme_list *epmem_get_augs_of_id( Symbol * id, tc_number tc )
{
	slot *s;
	wme *w;
	epmem_wme_list *return_val = new epmem_wme_list;

	// augs only exist for identifiers
	if ( ( id->common.symbol_type == IDENTIFIER_SYMBOL_TYPE ) &&
			( id->id.tc_num != tc ) )
	{
		id->id.tc_num = tc;

		// impasse wmes
		for ( w=id->id.impasse_wmes; w!=NIL; w=w->next )
		{
			return_val->push_back( w );
		}

		// input wmes
		for ( w=id->id.input_wmes; w!=NIL; w=w->next )
		{
			return_val->push_back( w );
		}

		// regular wmes
		for ( s=id->id.slots; s!=NIL; s=s->next )
		{
			for ( w=s->wmes; w!=NIL; w=w->next )
			{
				return_val->push_back( w );
			}

			for ( w=s->acceptable_preference_wmes; w!=NIL; w=w->next )
			{
				return_val->push_back( w );
			}
		}
	}

	return return_val;
}

inline void _epmem_process_buffered_wme_list( agent* my_agent, Symbol* state, soar_module::wme_set& cue_wmes, soar_module::symbol_triple_list& my_list, bool meta )
{
	if ( my_list.empty() )
	{
		return;
	}

	instantiation* inst = soar_module::make_fake_instantiation( my_agent, state, &cue_wmes, &my_list );

	for ( preference* pref=inst->preferences_generated; pref; pref=pref->inst_next )
	{
		// add the preference to temporary memory
		if ( add_preference_to_tm( my_agent, pref ) )
		{
			// add to the list of preferences to be removed
			// when the goal is removed
			insert_at_head_of_dll( state->id.preferences_from_goal, pref, all_of_goal_next, all_of_goal_prev );
			pref->on_goal_list = true;

			if ( meta )
			{
				// if this is a meta wme, then it is completely local
				// to the state and thus we will manually remove it
				// (via preference removal) when the time comes
				state->id.epmem_info->epmem_wmes->push_back( pref );
			}
		}
		else
		{
			preference_add_ref( pref );
			preference_remove_ref( my_agent, pref );
		}
	}

	if ( !meta )
	{
		// otherwise, we submit the fake instantiation to backtracing
		// such as to potentially produce justifications that can follow
		// it to future adventures (potentially on new states)
		instantiation *my_justification_list = NIL;
		chunk_instantiation( my_agent, inst, false, &my_justification_list );

		// if any justifications are created, assert their preferences manually
		// (copied mainly from assert_new_preferences with respect to our circumstances)
		if ( my_justification_list != NIL )
		{
			preference *just_pref = NIL;
			instantiation *next_justification = NIL;

			for ( instantiation *my_justification=my_justification_list;
					my_justification!=NIL;
					my_justification=next_justification )
			{
				next_justification = my_justification->next;

				if ( my_justification->in_ms )
				{
					insert_at_head_of_dll( my_justification->prod->instantiations, my_justification, next, prev );
				}

				for ( just_pref=my_justification->preferences_generated; just_pref!=NIL; just_pref=just_pref->inst_next )
				{
					if ( add_preference_to_tm( my_agent, just_pref ) )
					{
						if ( wma_enabled( my_agent ) )
						{
							wma_activate_wmes_in_pref( my_agent, just_pref );
						}
					}
					else
					{
						preference_add_ref( just_pref );
						preference_remove_ref( my_agent, just_pref );
					}
				}
			}
		}
	}
}

inline void epmem_process_buffered_wmes( agent* my_agent, Symbol* state, soar_module::wme_set& cue_wmes, soar_module::symbol_triple_list& meta_wmes, soar_module::symbol_triple_list& retrieval_wmes )
{
	_epmem_process_buffered_wme_list( my_agent, state, cue_wmes, meta_wmes, true );
	_epmem_process_buffered_wme_list( my_agent, state, cue_wmes, retrieval_wmes, false );
}

inline void epmem_buffer_add_wme( soar_module::symbol_triple_list& my_list, Symbol* id, Symbol* attr, Symbol* value )
{
	my_list.push_back( new soar_module::symbol_triple( id, attr, value ) );

	symbol_add_ref( id );
	symbol_add_ref( attr );
	symbol_add_ref( value );
}


//////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////
// Variable Functions (epmem::var)
//
// Variables are key-value pairs stored in the database
// that are necessary to maintain a store between
// multiple runs of Soar.
//
//////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////

/***************************************************************************
 * Function     : epmem_get_variable
 * Author		: Nate Derbinsky
 * Notes		: Gets an EpMem variable from the database
 **************************************************************************/
bool epmem_get_variable( agent *my_agent, epmem_variable_key variable_id, int64_t *variable_value )
{
	soar_module::exec_result status;
	soar_module::sqlite_statement *var_get = my_agent->epmem_stmts_common->var_get;

	var_get->bind_int( 1, variable_id );
	status = var_get->execute();

	if ( status == soar_module::row )
	{
		(*variable_value) = var_get->column_int( 0 );
	}

	var_get->reinitialize();

	return ( status == soar_module::row );
}

/***************************************************************************
 * Function     : epmem_set_variable
 * Author		: Nate Derbinsky
 * Notes		: Sets an EpMem variable in the database
 **************************************************************************/
void epmem_set_variable( agent *my_agent, epmem_variable_key variable_id, int64_t variable_value )
{
	soar_module::sqlite_statement *var_set = my_agent->epmem_stmts_common->var_set;

	var_set->bind_int( 1, variable_id );
	var_set->bind_int( 2, variable_value );

	var_set->execute( soar_module::op_reinit );
}

//////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////
// RIT Functions (epmem::rit)
//////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////

/***************************************************************************
 * Function     : epmem_rit_fork_node
 * Author		: Nate Derbinsky
 * Notes		: Implements the forkNode function of RIT
 **************************************************************************/
int64_t epmem_rit_fork_node( int64_t lower, int64_t upper, bool /*bounds_offset*/, int64_t *step_return, epmem_rit_state *rit_state )
{
	// never called
	/*if ( !bounds_offset )
	  {
	  int64_t offset = rit_state->offset.stat->get_value();

	  lower = ( lower - offset );
	  upper = ( upper - offset );
	  }*/

	// descend the tree down to the fork node
	int64_t node = EPMEM_RIT_ROOT;
	if ( upper < EPMEM_RIT_ROOT )
	{
		node = rit_state->leftroot.stat->get_value();
	}
	else if ( lower > EPMEM_RIT_ROOT )
	{
		node = rit_state->rightroot.stat->get_value();
	}

	int64_t step;
	for ( step = ( ( ( node >= 0 )?( node ):( -1 * node ) ) / 2 ); step >= 1; step /= 2 )
	{
		if ( upper < node )
		{
			node -= step;
		}
		else if ( node < lower )
		{
			node += step;
		}
		else
		{
			break;
		}
	}

	// never used
	// if ( step_return != NULL )
	{
		(*step_return) = step;
	}

	return node;
}

/***************************************************************************
 * Function     : epmem_rit_clear_left_right
 * Author		: Nate Derbinsky
 * Notes		: Clears the left/right relations populated during prep
 **************************************************************************/
void epmem_rit_clear_left_right( agent *my_agent )
{
	my_agent->epmem_stmts_common->rit_truncate_left->execute( soar_module::op_reinit );
	my_agent->epmem_stmts_common->rit_truncate_right->execute( soar_module::op_reinit );
}

/***************************************************************************
 * Function     : epmem_rit_add_left
 * Author		: Nate Derbinsky
 * Notes		: Adds a range to the left relation
 **************************************************************************/
void epmem_rit_add_left( agent *my_agent, epmem_time_id min, epmem_time_id max )
{
	my_agent->epmem_stmts_common->rit_add_left->bind_int( 1, min );
	my_agent->epmem_stmts_common->rit_add_left->bind_int( 2, max );
	my_agent->epmem_stmts_common->rit_add_left->execute( soar_module::op_reinit );
}

/***************************************************************************
 * Function     : epmem_rit_add_right
 * Author		: Nate Derbinsky
 * Notes		: Adds a node to the to the right relation
 **************************************************************************/
void epmem_rit_add_right( agent *my_agent, epmem_time_id id )
{
	my_agent->epmem_stmts_common->rit_add_right->bind_int( 1, id );
	my_agent->epmem_stmts_common->rit_add_right->execute( soar_module::op_reinit );
}

/***************************************************************************
 * Function     : epmem_rit_prep_left_right
 * Author		: Nate Derbinsky
 * Notes		: Implements the computational components of the RIT
 * 				  query algorithm
 **************************************************************************/
void epmem_rit_prep_left_right( agent *my_agent, int64_t lower, int64_t upper, epmem_rit_state *rit_state )
{
	////////////////////////////////////////////////////////////////////////////
	rit_state->timer->start();
	////////////////////////////////////////////////////////////////////////////

	int64_t offset = rit_state->offset.stat->get_value();
	int64_t node, step;
	int64_t left_node, left_step;
	int64_t right_node, right_step;

	lower = ( lower - offset );
	upper = ( upper - offset );

	// auto add good range
	epmem_rit_add_left( my_agent, lower, upper );

	// go to fork
	node = EPMEM_RIT_ROOT;
	step = 0;
	if ( ( lower > node ) || (upper < node ) )
	{
		if ( lower > node )
		{
			node = rit_state->rightroot.stat->get_value();
			epmem_rit_add_left( my_agent, EPMEM_RIT_ROOT, EPMEM_RIT_ROOT );
		}
		else
		{
			node = rit_state->leftroot.stat->get_value();
			epmem_rit_add_right( my_agent, EPMEM_RIT_ROOT );
		}

		for ( step = ( ( ( node >= 0 )?( node ):( -1 * node ) ) / 2 ); step >= 1; step /= 2 )
		{
			if ( lower > node )
			{
				epmem_rit_add_left( my_agent, node, node );
				node += step;
			}
			else if ( upper < node )
			{
				epmem_rit_add_right( my_agent, node );
				node -= step;
			}
			else
			{
				break;
			}
		}
	}

	// go left
	left_node = node - step;
	for ( left_step = ( step / 2 ); left_step >= 1; left_step /= 2 )
	{
		if ( lower == left_node )
		{
			break;
		}
		else if ( lower > left_node )
		{
			epmem_rit_add_left( my_agent, left_node, left_node );
			left_node += left_step;
		}
		else
		{
			left_node -= left_step;
		}
	}

	// go right
	right_node = node + step;
	for ( right_step = ( step / 2 ); right_step >= 1; right_step /= 2 )
	{
		if ( upper == right_node )
		{
			break;
		}
		else if ( upper < right_node )
		{
			epmem_rit_add_right( my_agent, right_node );
			right_node -= right_step;
		}
		else
		{
			right_node += right_step;
		}
	}

	////////////////////////////////////////////////////////////////////////////
	rit_state->timer->stop();
	////////////////////////////////////////////////////////////////////////////
}

/***************************************************************************
 * Function     : epmem_rit_insert_interval
 * Author		: Nate Derbinsky
 * Notes		: Inserts an interval in the RIT
 **************************************************************************/
void epmem_rit_insert_interval( agent *my_agent, int64_t lower, int64_t upper, epmem_node_id id, epmem_rit_state *rit_state )
{
	// initialize offset
	int64_t offset = rit_state->offset.stat->get_value();
	if ( offset == EPMEM_RIT_OFFSET_INIT )
	{
		offset = lower;

		// update database
		epmem_set_variable( my_agent, rit_state->offset.var_key, offset );

		// update stat
		rit_state->offset.stat->set_value( offset );
	}

	// get node
	int64_t node;
	{
		int64_t left_root = rit_state->leftroot.stat->get_value();
		int64_t right_root = rit_state->rightroot.stat->get_value();
		int64_t min_step = rit_state->minstep.stat->get_value();

		// shift interval
		int64_t l = ( lower - offset );
		int64_t u = ( upper - offset );

		// update left_root
		if ( ( u < EPMEM_RIT_ROOT ) && ( l <= ( 2 * left_root ) ) )
		{
			left_root = static_cast<int64_t>( pow( -2.0, floor( log( static_cast<double>( -l ) ) / EPMEM_LN_2 ) ) );

			// update database
			epmem_set_variable( my_agent, rit_state->leftroot.var_key, left_root );

			// update stat
			rit_state->leftroot.stat->set_value( left_root );
		}

		// update right_root
		if ( ( l > EPMEM_RIT_ROOT ) && ( u >= ( 2 * right_root ) ) )
		{
			right_root = static_cast<int64_t>( pow( 2.0, floor( log( static_cast<double>( u ) ) / EPMEM_LN_2 ) ) );

			// update database
			epmem_set_variable( my_agent, rit_state->rightroot.var_key, right_root );

			// update stat
			rit_state->rightroot.stat->set_value( right_root );
		}

		// update min_step
		int64_t step;
		node = epmem_rit_fork_node( l, u, true, &step, rit_state );

		if ( ( node != EPMEM_RIT_ROOT ) && ( step < min_step ) )
		{
			min_step = step;

			// update database
			epmem_set_variable( my_agent, rit_state->minstep.var_key, min_step );

			// update stat
			rit_state->minstep.stat->set_value( min_step );
		}
	}

	// perform insert
	// ( node, start, end, id )
	rit_state->add_query->bind_int( 1, node );
	rit_state->add_query->bind_int( 2, lower );
	rit_state->add_query->bind_int( 3, upper );
	rit_state->add_query->bind_int( 4, id );
	rit_state->add_query->execute( soar_module::op_reinit );
}


//////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////
// Clean-Up Functions (epmem::clean)
//////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////

/***************************************************************************
 * Function     : epmem_close
 * Author		: Nate Derbinsky
 * Notes		: Performs cleanup operations when the database needs
 * 				  to be closed (end soar, manual close, etc)
 **************************************************************************/
void epmem_close( agent *my_agent )
{
	if ( my_agent->epmem_db->get_status() == soar_module::connected )
	{
		// if lazy, commit
		if ( my_agent->epmem_params->lazy_commit->get_value() == soar_module::on )
		{
			my_agent->epmem_stmts_common->commit->execute( soar_module::op_reinit );
		}

		// de-allocate statement pools
		{
			int j, k, m;

			for ( j=EPMEM_RIT_STATE_NODE; j<=EPMEM_RIT_STATE_EDGE; j++ )
			{
				for ( k=EPMEM_RANGE_START; k<=EPMEM_RANGE_END; k++ )
				{
					for( m=EPMEM_RANGE_EP; m<=EPMEM_RANGE_POINT; m++ )
					{
						delete my_agent->epmem_stmts_graph->pool_range_queries[ j ][ k ][ m ];
					}
				}
			}

			for ( k=EPMEM_RANGE_START; k<=EPMEM_RANGE_END; k++ )
			{
				for( m=EPMEM_RANGE_EP; m<=EPMEM_RANGE_POINT; m++ )
				{
					delete my_agent->epmem_stmts_graph->pool_range_lti_queries[ k ][ m ];
				}
			}

			delete my_agent->epmem_stmts_graph->pool_range_lti_start;
		}

		// de-allocate statements
		delete my_agent->epmem_stmts_common;
		delete my_agent->epmem_stmts_graph;

		// de-allocate local data structures
		{
			epmem_parent_id_pool::iterator p;
			epmem_hashed_id_pool::iterator p_p;

			for ( p=my_agent->epmem_id_repository->begin(); p!=my_agent->epmem_id_repository->end(); p++ )
			{
				for ( p_p=p->second->begin(); p_p!=p->second->end(); p_p++ )
				{
					delete p_p->second;
				}

				delete p->second;
			}

			my_agent->epmem_id_repository->clear();
			my_agent->epmem_id_replacement->clear();

			for ( epmem_id_ref_counter::iterator rf_it=my_agent->epmem_id_ref_counts->begin(); rf_it!=my_agent->epmem_id_ref_counts->end(); rf_it++ )
			{
				delete rf_it->second;
			}
			my_agent->epmem_id_ref_counts->clear();
		}

		// close the database
		my_agent->epmem_db->disconnect();
	}

#ifdef EPMEM_EXPERIMENT
	if ( epmem_exp_output )
	{
		epmem_exp_output->close();
		delete epmem_exp_output;
		epmem_exp_output = NULL;

		if ( epmem_exp_timer )
		{
			delete epmem_exp_timer;
		}
	}
#endif
}

/***************************************************************************
 * Function     : epmem_clear_result
 * Author		: Nate Derbinsky
 * Notes		: Removes any WMEs produced by EpMem resulting from
 * 				  a command
 **************************************************************************/
void epmem_clear_result( agent *my_agent, Symbol *state )
{
	preference *pref;

	while ( !state->id.epmem_info->epmem_wmes->empty() )
	{
		pref = state->id.epmem_info->epmem_wmes->back();
		state->id.epmem_info->epmem_wmes->pop_back();

		if ( pref->in_tm )
		{
			remove_preference_from_tm( my_agent, pref );
		}
	}
}

/***************************************************************************
 * Function     : epmem_reset
 * Author		: Nate Derbinsky
 * Notes		: Performs cleanup when a state is removed
 **************************************************************************/
void epmem_reset( agent *my_agent, Symbol *state )
{
	if ( state == NULL )
	{
		state = my_agent->top_goal;
	}

	while( state )
	{
		epmem_data *data = state->id.epmem_info;

		data->last_ol_time = 0;

		data->last_cmd_time = 0;
		data->last_cmd_count = 0;

		data->last_memory = EPMEM_MEMID_NONE;

		// this will be called after prefs from goal are already removed,
		// so just clear out result stack
		data->epmem_wmes->clear();

		state = state->id.lower_goal;
	}
}


//////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////
// Initialization Functions (epmem::init)
//////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////

/***************************************************************************
 * Function     : epmem_init_db
 * Author		: Nate Derbinsky
 * Notes		: Opens the SQLite database and performs all
 * 				  initialization required for the current mode
 *
 *                The readonly param should only be used in
 *                experimentation where you don't want to alter
 *                previous database state.
 **************************************************************************/
void epmem_init_db( agent *my_agent, bool readonly = false )
{
	if ( my_agent->epmem_db->get_status() != soar_module::disconnected )
	{
		return;
	}

	////////////////////////////////////////////////////////////////////////////
	my_agent->epmem_timers->init->start();
	////////////////////////////////////////////////////////////////////////////

	const char *db_path;
	if ( my_agent->epmem_params->database->get_value() == epmem_param_container::memory )
	{
		db_path = ":memory:";
	}
	else
	{
		db_path = my_agent->epmem_params->path->get_value();
	}

	// attempt connection
	my_agent->epmem_db->connect( db_path );

	if ( my_agent->epmem_db->get_status() == soar_module::problem )
	{
		char buf[256];
		SNPRINTF( buf, 254, "DB ERROR: %s", my_agent->epmem_db->get_errmsg() );

		print( my_agent, buf );
		xml_generate_warning( my_agent, buf );
	}
	else
	{
		epmem_time_id time_max;
		soar_module::sqlite_statement *temp_q = NULL;
		soar_module::sqlite_statement *temp_q2 = NULL;

		// apply performance options
		{
			// page_size
			{
				switch ( my_agent->epmem_params->page_size->get_value() )
				{
					case ( epmem_param_container::page_1k ):
						temp_q = new soar_module::sqlite_statement( my_agent->epmem_db, "PRAGMA page_size = 1024" );
						break;

					case ( epmem_param_container::page_2k ):
						temp_q = new soar_module::sqlite_statement( my_agent->epmem_db, "PRAGMA page_size = 2048" );
						break;

					case ( epmem_param_container::page_4k ):
						temp_q = new soar_module::sqlite_statement( my_agent->epmem_db, "PRAGMA page_size = 4096" );
						break;

					case ( epmem_param_container::page_8k ):
						temp_q = new soar_module::sqlite_statement( my_agent->epmem_db, "PRAGMA page_size = 8192" );
						break;

					case ( epmem_param_container::page_16k ):
						temp_q = new soar_module::sqlite_statement( my_agent->epmem_db, "PRAGMA page_size = 16384" );
						break;

					case ( epmem_param_container::page_32k ):
						temp_q = new soar_module::sqlite_statement( my_agent->epmem_db, "PRAGMA page_size = 32768" );
						break;

					case ( epmem_param_container::page_64k ):
						temp_q = new soar_module::sqlite_statement( my_agent->epmem_db, "PRAGMA page_size = 65536" );
						break;
				}

				temp_q->prepare();
				temp_q->execute();
				delete temp_q;
				temp_q = NULL;
			}

			// cache_size
			{
				std::string cache_sql( "PRAGMA cache_size = " );
				char* str = my_agent->epmem_params->cache_size->get_string();
				cache_sql.append( str );
				free(str);
				str = NULL;

				temp_q = new soar_module::sqlite_statement( my_agent->epmem_db, cache_sql.c_str() );

				temp_q->prepare();
				temp_q->execute();
				delete temp_q;
				temp_q = NULL;
			}

			// optimization
			if ( my_agent->epmem_params->opt->get_value() == epmem_param_container::opt_speed )
			{
				// synchronous - don't wait for writes to complete (can corrupt the db in case unexpected crash during transaction)
				temp_q = new soar_module::sqlite_statement( my_agent->epmem_db, "PRAGMA synchronous = OFF" );
				temp_q->prepare();
				temp_q->execute();
				delete temp_q;
				temp_q = NULL;

				// journal_mode - no atomic transactions (can result in database corruption if crash during transaction)
				temp_q = new soar_module::sqlite_statement( my_agent->epmem_db, "PRAGMA journal_mode = OFF" );
				temp_q->prepare();
				temp_q->execute();
				delete temp_q;
				temp_q = NULL;

				// locking_mode - no one else can view the database after our first write
				temp_q = new soar_module::sqlite_statement( my_agent->epmem_db, "PRAGMA locking_mode = EXCLUSIVE" );
				temp_q->prepare();
				temp_q->execute();
				delete temp_q;
				temp_q = NULL;
			}
		}

		// point stuff
		epmem_time_id range_start;
		epmem_time_id time_last;

		// update validation count
		my_agent->epmem_validation++;

		// setup common structures/queries
		my_agent->epmem_stmts_common = new epmem_common_statement_container( my_agent );
		my_agent->epmem_stmts_common->structure();
		my_agent->epmem_stmts_common->prepare();

		{
			// setup graph structures/queries
			my_agent->epmem_stmts_graph = new epmem_graph_statement_container( my_agent );
			my_agent->epmem_stmts_graph->structure();
			my_agent->epmem_stmts_graph->prepare();

			// initialize range tracking
			my_agent->epmem_node_mins->clear();
			my_agent->epmem_node_maxes->clear();
			my_agent->epmem_node_removals->clear();

			my_agent->epmem_edge_mins->clear();
			my_agent->epmem_edge_maxes->clear();
			my_agent->epmem_edge_removals->clear();

			(*my_agent->epmem_id_repository)[ EPMEM_NODEID_ROOT ] = new epmem_hashed_id_pool;
			{
#ifdef USE_MEM_POOL_ALLOCATORS
				epmem_wme_set* wms_temp = new epmem_wme_set( std::less< wme* >(), soar_module::soar_memory_pool_allocator< wme* >( my_agent ) );
#else
				epmem_wme_set* wms_temp = new epmem_wme_set();
#endif

				// voigtjr: Cast to wme* is necessary for compilation in VS10
				// Without it, it picks insert(int) instead of insert(wme*) and does not compile.
				wms_temp->insert( static_cast<wme*>(NULL) );

				(*my_agent->epmem_id_ref_counts)[ EPMEM_NODEID_ROOT ] = wms_temp;
			}

			// initialize time
			my_agent->epmem_stats->time->set_value( 1 );

			// initialize next_id
			my_agent->epmem_stats->next_id->set_value( 1 );
			{
				int64_t stored_id = NIL;
				if ( epmem_get_variable( my_agent, var_next_id, &stored_id ) )
				{
					my_agent->epmem_stats->next_id->set_value( stored_id );
				}
				else
				{
					epmem_set_variable( my_agent, var_next_id, my_agent->epmem_stats->next_id->get_value() );
				}
			}

			// initialize rit state
			for ( int i=EPMEM_RIT_STATE_NODE; i<=EPMEM_RIT_STATE_EDGE; i++ )
			{
				my_agent->epmem_rit_state_graph[ i ].offset.stat->set_value( EPMEM_RIT_OFFSET_INIT );
				my_agent->epmem_rit_state_graph[ i ].leftroot.stat->set_value( 0 );
				my_agent->epmem_rit_state_graph[ i ].rightroot.stat->set_value( 1 );
				my_agent->epmem_rit_state_graph[ i ].minstep.stat->set_value( LONG_MAX );
			}
			my_agent->epmem_rit_state_graph[ EPMEM_RIT_STATE_NODE ].add_query = my_agent->epmem_stmts_graph->add_node_range;
			my_agent->epmem_rit_state_graph[ EPMEM_RIT_STATE_EDGE ].add_query = my_agent->epmem_stmts_graph->add_edge_range;

			////

			// get/set RIT variables
			{
				int64_t var_val = NIL;

				for ( int i=EPMEM_RIT_STATE_NODE; i<=EPMEM_RIT_STATE_EDGE; i++ )
				{
					// offset
					if ( epmem_get_variable( my_agent, my_agent->epmem_rit_state_graph[ i ].offset.var_key, &var_val ) )
					{
						my_agent->epmem_rit_state_graph[ i ].offset.stat->set_value( var_val );
					}
					else
					{
						epmem_set_variable( my_agent, my_agent->epmem_rit_state_graph[ i ].offset.var_key, my_agent->epmem_rit_state_graph[ i ].offset.stat->get_value() );
					}

					// leftroot
					if ( epmem_get_variable( my_agent, my_agent->epmem_rit_state_graph[ i ].leftroot.var_key, &var_val ) )
					{
						my_agent->epmem_rit_state_graph[ i ].leftroot.stat->set_value( var_val );
					}
					else
					{
						epmem_set_variable( my_agent, my_agent->epmem_rit_state_graph[ i ].leftroot.var_key, my_agent->epmem_rit_state_graph[ i ].leftroot.stat->get_value() );
					}

					// rightroot
					if ( epmem_get_variable( my_agent, my_agent->epmem_rit_state_graph[ i ].rightroot.var_key, &var_val ) )
					{
						my_agent->epmem_rit_state_graph[ i ].rightroot.stat->set_value( var_val );
					}
					else
					{
						epmem_set_variable( my_agent, my_agent->epmem_rit_state_graph[ i ].rightroot.var_key, my_agent->epmem_rit_state_graph[ i ].rightroot.stat->get_value() );
					}

					// minstep
					if ( epmem_get_variable( my_agent, my_agent->epmem_rit_state_graph[ i ].minstep.var_key, &var_val ) )
					{
						my_agent->epmem_rit_state_graph[ i ].minstep.stat->set_value( var_val );
					}
					else
					{
						epmem_set_variable( my_agent, my_agent->epmem_rit_state_graph[ i ].minstep.var_key, my_agent->epmem_rit_state_graph[ i ].minstep.stat->get_value() );
					}
				}
			}

			////

			// get max time
			{
				temp_q = new soar_module::sqlite_statement( my_agent->epmem_db, "SELECT MAX(id) FROM times" );
				temp_q->prepare();
				if ( temp_q->execute() == soar_module::row )
					my_agent->epmem_stats->time->set_value( temp_q->column_int( 0 ) + 1 );

				delete temp_q;
				temp_q = NULL;
			}
			time_max = my_agent->epmem_stats->time->get_value();

			// insert non-NOW intervals for all current NOW's
			// remove NOW's
			if ( !readonly )
			{
				time_last = ( time_max - 1 );

				const char *now_select[] = { "SELECT id,start FROM node_now", "SELECT id,start FROM edge_now" };
				soar_module::sqlite_statement *now_add[] = { my_agent->epmem_stmts_graph->add_node_point, my_agent->epmem_stmts_graph->add_edge_point };
				const char *now_delete[] = { "DELETE FROM node_now", "DELETE FROM edge_now" };

				for ( int i=EPMEM_RIT_STATE_NODE; i<=EPMEM_RIT_STATE_EDGE; i++ )
				{
					temp_q = now_add[i];
					temp_q->bind_int( 2, time_last );

					temp_q2 = new soar_module::sqlite_statement( my_agent->epmem_db, now_select[i] );
					temp_q2->prepare();
					while ( temp_q2->execute() == soar_module::row )
					{
						range_start = temp_q2->column_int( 1 );

						// point
						if ( range_start == time_last )
						{
							temp_q->bind_int( 1, temp_q2->column_int( 0 ) );
							temp_q->execute( soar_module::op_reinit );
						}
						else
						{
							epmem_rit_insert_interval( my_agent, range_start, time_last, temp_q2->column_int( 0 ), &( my_agent->epmem_rit_state_graph[i] ) );
						}
					}
					delete temp_q2;
					temp_q2 = NULL;
					temp_q = NULL;


					// remove all NOW intervals
					temp_q = new soar_module::sqlite_statement( my_agent->epmem_db, now_delete[i] );
					temp_q->prepare();
					temp_q->execute();
					delete temp_q;
					temp_q = NULL;
				}
			}

			// get max id + max list
			{
				const char *minmax_select[] = { "SELECT MAX(child_id) FROM node_unique", "SELECT MAX(parent_id) FROM edge_unique" };
				std::vector<bool> *minmax_max[] = { my_agent->epmem_node_maxes, my_agent->epmem_edge_maxes };
				std::vector<epmem_time_id> *minmax_min[] = { my_agent->epmem_node_mins, my_agent->epmem_edge_mins };

				for ( int i=EPMEM_RIT_STATE_NODE; i<=EPMEM_RIT_STATE_EDGE; i++ )
				{
					temp_q = new soar_module::sqlite_statement( my_agent->epmem_db, minmax_select[i] );
					temp_q->prepare();
					temp_q->execute();
					if ( temp_q->column_type( 0 ) != soar_module::null_t )
					{
						std::vector<bool>::size_type num_ids = temp_q->column_int( 0 );

						minmax_max[i]->resize( num_ids, true );
						minmax_min[i]->resize( num_ids, time_max );
					}

					delete temp_q;
					temp_q = NULL;
				}
			}

			// get id pools
			{
				epmem_node_id q0;
				int64_t w;
				epmem_node_id q1;
				epmem_node_id parent_id;

				epmem_hashed_id_pool **hp;
				epmem_id_pool **ip;

				temp_q = new soar_module::sqlite_statement( my_agent->epmem_db, "SELECT q0, w, q1, parent_id FROM edge_unique" );
				temp_q->prepare();

				while ( temp_q->execute() == soar_module::row )
				{
					q0 = temp_q->column_int( 0 );
					w = temp_q->column_int( 1 );
					q1 = temp_q->column_int( 2 );
					parent_id = temp_q->column_int( 3 );

					hp =& (*my_agent->epmem_id_repository)[ q0 ];
					if ( !(*hp) )
						(*hp) = new epmem_hashed_id_pool;

					ip =& (*(*hp))[ w ];
					if ( !(*ip) )
						(*ip) = new epmem_id_pool;

					(*(*ip))[ q1 ] = parent_id;

					hp =& (*my_agent->epmem_id_repository)[ q1 ];
					if ( !(*hp) )
						(*hp) = new epmem_hashed_id_pool;
				}

				delete temp_q;
				temp_q = NULL;
			}
		}

		// if lazy commit, then we encapsulate the entire lifetime of the agent in a single transaction
		if ( my_agent->epmem_params->lazy_commit->get_value() == soar_module::on )
		{
			my_agent->epmem_stmts_common->begin->execute( soar_module::op_reinit );
		}
	}

	////////////////////////////////////////////////////////////////////////////
	my_agent->epmem_timers->init->stop();
	////////////////////////////////////////////////////////////////////////////
}


//////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////
// Temporal Hash Functions (epmem::hash)
//
// The rete has symbol hashing, but the values are
// reliable only for the lifetime of a symbol.  This
// isn't good for EpMem.  Hence, we implement a simple
// lookup table, relying upon SQLite to deal with
// efficiency issues.
//
//////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////

/***************************************************************************
 * Function     : epmem_temporal_hash
 * Author		: Nate Derbinsky
 * Notes		: Returns a temporally unique integer representing
 *                a symbol constant.
 **************************************************************************/
epmem_hash_id epmem_temporal_hash( agent *my_agent, Symbol *sym, bool add_on_fail = true )
{
	epmem_hash_id return_val = NIL;

	////////////////////////////////////////////////////////////////////////////
	my_agent->epmem_timers->hash->start();
	////////////////////////////////////////////////////////////////////////////

	if ( ( sym->common.symbol_type == SYM_CONSTANT_SYMBOL_TYPE ) ||
			( sym->common.symbol_type == INT_CONSTANT_SYMBOL_TYPE ) ||
			( sym->common.symbol_type == FLOAT_CONSTANT_SYMBOL_TYPE ) )
	{
		if ( ( !sym->common.epmem_hash ) || ( sym->common.epmem_valid != my_agent->epmem_validation ) )
		{
			sym->common.epmem_hash = NIL;
			sym->common.epmem_valid = my_agent->epmem_validation;

			// basic process:
			// - search
			// - if found, return
			// - else, add

			my_agent->epmem_stmts_common->hash_get->bind_int( 1, sym->common.symbol_type );
			switch ( sym->common.symbol_type )
			{
				case SYM_CONSTANT_SYMBOL_TYPE:
					my_agent->epmem_stmts_common->hash_get->bind_text( 2, static_cast<const char *>( sym->sc.name ) );
					break;

				case INT_CONSTANT_SYMBOL_TYPE:
					my_agent->epmem_stmts_common->hash_get->bind_int( 2, sym->ic.value );
					break;

				case FLOAT_CONSTANT_SYMBOL_TYPE:
					my_agent->epmem_stmts_common->hash_get->bind_double( 2, sym->fc.value );
					break;
			}

			if ( my_agent->epmem_stmts_common->hash_get->execute() == soar_module::row )
			{
				return_val = static_cast<epmem_hash_id>( my_agent->epmem_stmts_common->hash_get->column_int( 0 ) );
			}

			my_agent->epmem_stmts_common->hash_get->reinitialize();

			//

			if ( !return_val && add_on_fail )
			{
				my_agent->epmem_stmts_common->hash_add->bind_int( 1, sym->common.symbol_type );
				switch ( sym->common.symbol_type )
				{
					case SYM_CONSTANT_SYMBOL_TYPE:
						my_agent->epmem_stmts_common->hash_add->bind_text( 2, static_cast<const char *>( sym->sc.name ) );
						break;

					case INT_CONSTANT_SYMBOL_TYPE:
						my_agent->epmem_stmts_common->hash_add->bind_int( 2, sym->ic.value );
						break;

					case FLOAT_CONSTANT_SYMBOL_TYPE:
						my_agent->epmem_stmts_common->hash_add->bind_double( 2, sym->fc.value );
						break;
				}

				my_agent->epmem_stmts_common->hash_add->execute( soar_module::op_reinit );
				return_val = static_cast<epmem_hash_id>( my_agent->epmem_db->last_insert_rowid() );
			}

			// cache results for later re-use
			sym->common.epmem_hash = return_val;
			sym->common.epmem_valid = my_agent->epmem_validation;
		}

		return_val = sym->common.epmem_hash;
	}

	////////////////////////////////////////////////////////////////////////////
	my_agent->epmem_timers->hash->stop();
	////////////////////////////////////////////////////////////////////////////

	return return_val;
}


//////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////
// Storage Functions (epmem::storage)
//////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////

/***************************************************************************
 * Function     : epmem_new_episode
 * Author		: Nate Derbinsky
 * Notes		: Big picture: only process changes!
 *
 * 				  Episode storage entails recursively traversing
 * 				  working memory.  If we encounter a WME we've
 * 				  seen before (because it has an associated id),
 * 				  ignore it.  If we encounter something new, try
 * 				  to identify it (add to unique if not seen before)
 * 				  and note the start of something new.  When WMEs
 * 				  are removed from the rete (see rete.cpp)
 * 				  their loss is noted and recorded here
 * 				  (if the WME didn't re-appear).
 **************************************************************************/
void epmem_new_episode( agent *my_agent )
{
	// if this is the first episode, initialize db components
	if ( my_agent->epmem_db->get_status() == soar_module::disconnected )
	{
		epmem_init_db( my_agent );
	}

	// add the episode only if db is properly initialized
	if ( my_agent->epmem_db->get_status() != soar_module::connected )
	{
		return;
	}

	////////////////////////////////////////////////////////////////////////////
	my_agent->epmem_timers->storage->start();
	////////////////////////////////////////////////////////////////////////////

	epmem_time_id time_counter = my_agent->epmem_stats->time->get_value();

	// provide trace output
	if ( my_agent->sysparams[ TRACE_EPMEM_SYSPARAM ] )
	{
		char buf[256];

		SNPRINTF( buf, 254, "NEW EPISODE: %ld", static_cast<long int>(time_counter) );

		print( my_agent, buf );
		xml_generate_warning( my_agent, buf );
	}

	// perform storage
	{
		// prevents infinite loops
		tc_number tc = get_new_tc_number( my_agent );
		std::map<epmem_node_id, bool> seen_ids;
		std::map<epmem_node_id, bool>::iterator seen_p;

		// breadth first search state
		std::queue<Symbol *> parent_syms;
		Symbol *parent_sym;
		std::queue<epmem_node_id> parent_ids;
		epmem_node_id parent_id;

		// seen nodes (non-identifiers) and edges (identifiers)
		std::queue<epmem_node_id> epmem_node;
		std::queue<epmem_node_id> epmem_edge;

		// temporal hash
		epmem_hash_id my_hash;	// attribute
		epmem_hash_id my_hash2;	// value

		// id repository
		epmem_id_pool **my_id_repo;
		epmem_id_pool *my_id_repo2;
		epmem_id_pool::iterator pool_p;
		std::map<wme *, epmem_id_reservation *> id_reservations;
		std::map<wme *, epmem_id_reservation *>::iterator r_p;
		epmem_id_reservation *new_id_reservation;
		std::set<Symbol *> new_identifiers;

		// children of the current identifier
		epmem_wme_list *wmes;
		epmem_wme_list::iterator w_p;

		// initialize BFS
		my_agent->top_goal->id.epmem_id = EPMEM_NODEID_ROOT;
		my_agent->top_goal->id.epmem_valid = my_agent->epmem_validation;
		parent_syms.push( my_agent->top_goal );
		parent_ids.push( EPMEM_NODEID_ROOT );

		// three cases for sharing ids amongst identifiers in two passes:
		// 1. value known in phase one (try reservation)
		// 2. value unknown in phase one, but known at phase two (try assignment adhering to constraint)
		// 3. value unknown in phase one/two (if anything is left, unconstrained assignment)

		while ( !parent_syms.empty() )
		{
			parent_sym = parent_syms.front();
			parent_syms.pop();

			parent_id = parent_ids.front();
			parent_ids.pop();

			// get children WMEs
			wmes = epmem_get_augs_of_id( parent_sym, tc );

			{
				// pre-assign unknown identifiers with known children (prevents ordering issues with unknown children)
				for ( w_p=wmes->begin(); w_p!=wmes->end(); w_p++ )
				{
					if ( ( (*w_p)->value->common.symbol_type == IDENTIFIER_SYMBOL_TYPE ) &&
							( ( (*w_p)->epmem_id == EPMEM_NODEID_BAD ) || ( (*w_p)->epmem_valid != my_agent->epmem_validation ) ) &&
							( ( (*w_p)->value->id.epmem_id != EPMEM_NODEID_BAD ) && ( (*w_p)->value->id.epmem_valid == my_agent->epmem_validation ) ) &&
							( !(*w_p)->value->id.smem_lti ) )
					{
						// prevent exclusions from being recorded
						if ( my_agent->epmem_params->exclusions->in_set( (*w_p)->attr ) )
						{
							continue;
						}

						// if still here, create reservation (case 1)
						new_id_reservation = new epmem_id_reservation;
						new_id_reservation->my_id = EPMEM_NODEID_BAD;
						new_id_reservation->my_pool = NULL;

						if ( (*w_p)->acceptable )
						{
							new_id_reservation->my_hash = EPMEM_HASH_ACCEPTABLE;
						}
						else
						{
							new_id_reservation->my_hash = epmem_temporal_hash( my_agent, (*w_p)->attr );
						}

						// try to find appropriate reservation
						my_id_repo =& (*(*my_agent->epmem_id_repository)[ parent_id ])[ new_id_reservation->my_hash ];
						if ( (*my_id_repo) )
						{
							if ( !(*my_id_repo)->empty() )
							{
								pool_p = (*my_id_repo)->find( (*w_p)->value->id.epmem_id );
								if ( pool_p != (*my_id_repo)->end() )
								{
									new_id_reservation->my_id = pool_p->second;

									(*my_id_repo)->erase( pool_p );
								}
							}
						}
						else
						{
							// add repository
							(*my_id_repo) = new epmem_id_pool;
						}

						new_id_reservation->my_pool = (*my_id_repo);
						id_reservations[ (*w_p) ] = new_id_reservation;
						new_id_reservation = NULL;
					}
				}

				for ( w_p=wmes->begin(); w_p!=wmes->end(); w_p++ )
				{
					// prevent exclusions from being recorded
					if ( my_agent->epmem_params->exclusions->in_set( (*w_p)->attr ) )
					{
						continue;
					}

					if ( (*w_p)->value->common.symbol_type == IDENTIFIER_SYMBOL_TYPE )
					{
						// have we seen this WME during this database?
						if ( ( (*w_p)->epmem_id == EPMEM_NODEID_BAD ) || ( (*w_p)->epmem_valid != my_agent->epmem_validation ) )
						{
							(*w_p)->epmem_valid = my_agent->epmem_validation;
							(*w_p)->epmem_id = EPMEM_NODEID_BAD;

							my_hash = NIL;
							my_id_repo2 = NIL;

							// if long-term identifier as value, special processing (we may need to promote, we don't add to/take from any pools)
							if ( (*w_p)->value->id.smem_lti )
							{
								// find the lti or add new one
								if ( ( (*w_p)->value->id.epmem_id == EPMEM_NODEID_BAD ) || ( (*w_p)->value->id.epmem_valid != my_agent->epmem_validation ) )
								{
									(*w_p)->value->id.epmem_id = EPMEM_NODEID_BAD;
									(*w_p)->value->id.epmem_valid = my_agent->epmem_validation;

									// try to find
									{
										my_agent->epmem_stmts_graph->find_lti->bind_int( 1, static_cast<uint64_t>( (*w_p)->value->id.name_letter ) );
										my_agent->epmem_stmts_graph->find_lti->bind_int( 2, static_cast<uint64_t>( (*w_p)->value->id.name_number ) );

										if ( my_agent->epmem_stmts_graph->find_lti->execute() == soar_module::row )
										{
											(*w_p)->value->id.epmem_id = static_cast<epmem_node_id>( my_agent->epmem_stmts_graph->find_lti->column_int( 0 ) );
										}

										my_agent->epmem_stmts_graph->find_lti->reinitialize();
									}

									// add if necessary
									if ( (*w_p)->value->id.epmem_id == EPMEM_NODEID_BAD )
									{
										(*w_p)->value->id.epmem_id = my_agent->epmem_stats->next_id->get_value();
										my_agent->epmem_stats->next_id->set_value( (*w_p)->value->id.epmem_id + 1 );
										epmem_set_variable( my_agent, var_next_id, (*w_p)->value->id.epmem_id + 1 );

										// add repository
										(*my_agent->epmem_id_repository)[ (*w_p)->value->id.epmem_id ] = new epmem_hashed_id_pool;

										// parent_id,letter,num,time_id
										my_agent->epmem_stmts_graph->promote_id->bind_int( 1, (*w_p)->value->id.epmem_id );
										my_agent->epmem_stmts_graph->promote_id->bind_int( 2, static_cast<uint64_t>( (*w_p)->value->id.name_letter ) );
										my_agent->epmem_stmts_graph->promote_id->bind_int( 3, static_cast<uint64_t>( (*w_p)->value->id.name_number ) );
										my_agent->epmem_stmts_graph->promote_id->bind_int( 4, time_counter );
										my_agent->epmem_stmts_graph->promote_id->execute( soar_module::op_reinit );
									}
								}

								// now perform deliberate edge search
								// ltis don't use the pools, so we make a direct search in the edge_unique table
								// if failure, drop below and use standard channels
								{
									// get temporal hash
									if ( (*w_p)->acceptable )
									{
										my_hash = EPMEM_HASH_ACCEPTABLE;
									}
									else
									{
										my_hash = epmem_temporal_hash( my_agent, (*w_p)->attr );
									}

									// q0, w, q1
									my_agent->epmem_stmts_graph->find_edge_unique_shared->bind_int( 1, parent_id );
									my_agent->epmem_stmts_graph->find_edge_unique_shared->bind_int( 2, my_hash );
									my_agent->epmem_stmts_graph->find_edge_unique_shared->bind_int( 3, (*w_p)->value->id.epmem_id );

									if ( my_agent->epmem_stmts_graph->find_edge_unique_shared->execute() == soar_module::row )
									{
										(*w_p)->epmem_id = my_agent->epmem_stmts_graph->find_edge_unique_shared->column_int( 0 );
									}

									my_agent->epmem_stmts_graph->find_edge_unique_shared->reinitialize();
								}
							}
							else
							{
								// in the case of a known child, we already have a reservation (case 1)
								if ( ( (*w_p)->value->id.epmem_id != EPMEM_NODEID_BAD ) && ( (*w_p)->value->id.epmem_valid == my_agent->epmem_validation ) )
								{
									r_p = id_reservations.find( (*w_p) );

									if ( r_p != id_reservations.end() )
									{
										// restore reservation info
										my_hash = r_p->second->my_hash;
										my_id_repo2 = r_p->second->my_pool;

										if ( r_p->second->my_id != EPMEM_NODEID_BAD )
										{
											(*w_p)->epmem_id = r_p->second->my_id;
											(*my_agent->epmem_id_replacement)[ (*w_p)->epmem_id ] = my_id_repo2;
										}

										// delete reservation and map entry
										delete r_p->second;
										id_reservations.erase( r_p );
									}
									// OR a shared identifier at the same level, in which case we need an exact match (case 2)
									else
									{
										// get temporal hash
										if ( (*w_p)->acceptable )
										{
											my_hash = EPMEM_HASH_ACCEPTABLE;
										}
										else
										{
											my_hash = epmem_temporal_hash( my_agent, (*w_p)->attr );
										}

										// try to get an id that matches new information
										my_id_repo =& (*(*my_agent->epmem_id_repository)[ parent_id ])[ my_hash ];
										if ( (*my_id_repo) )
										{
											if ( !(*my_id_repo)->empty() )
											{
												pool_p = (*my_id_repo)->find( (*w_p)->value->id.epmem_id );
												if ( pool_p != (*my_id_repo)->end() )
												{
													(*w_p)->epmem_id = pool_p->second;
													(*my_id_repo)->erase( pool_p );

													(*my_agent->epmem_id_replacement)[ (*w_p)->epmem_id ] = (*my_id_repo);
												}
											}
										}
										else
										{
											// add repository
											(*my_id_repo) = new epmem_id_pool;
										}

										// keep the address for later use
										my_id_repo2 = (*my_id_repo);
									}
								}
								// case 3
								else
								{
									// UNKNOWN identifier
									new_identifiers.insert( (*w_p)->value );

									// get temporal hash
									if ( (*w_p)->acceptable )
									{
										my_hash = EPMEM_HASH_ACCEPTABLE;
									}
									else
									{
										my_hash = epmem_temporal_hash( my_agent, (*w_p)->attr );
									}

									// try to find node
									my_id_repo =& (*(*my_agent->epmem_id_repository)[ parent_id ])[ my_hash ];
									if ( (*my_id_repo) )
									{
										// if something leftover, try to use it
										if ( !(*my_id_repo)->empty() )
										{
											pool_p = (*my_id_repo)->begin();

											do
											{
												// the ref set for this epmem_id may not be there if the pools were regenerated from a previous DB
												// a non-existant ref set is the equivalent of a ref count of 0 (ie. an empty ref set)
												// so we allow the identifier from the pool to be used
												if ( ( my_agent->epmem_id_ref_counts->count(pool_p->first) == 0 ) ||
														( (*my_agent->epmem_id_ref_counts)[ pool_p->first ]->empty() ) )
												{
													(*w_p)->epmem_id = pool_p->second;
													(*w_p)->value->id.epmem_id = pool_p->first;
													(*w_p)->value->id.epmem_valid = my_agent->epmem_validation;
													(*my_id_repo)->erase( pool_p );
													(*my_agent->epmem_id_replacement)[ (*w_p)->epmem_id ] = (*my_id_repo);

													pool_p = (*my_id_repo)->end();
												}
												else
												{
													pool_p++;
												}
											} while ( pool_p != (*my_id_repo)->end() );
										}
									}
									else
									{
										// add repository
										(*my_id_repo) = new epmem_id_pool;
									}

									// keep the address for later use
									my_id_repo2 = (*my_id_repo);
								}
							}

							// add path if no success above
							if ( (*w_p)->epmem_id == EPMEM_NODEID_BAD )
							{
								if ( ( (*w_p)->value->id.epmem_id == EPMEM_NODEID_BAD ) || ( (*w_p)->value->id.epmem_valid != my_agent->epmem_validation ) )
								{
									// update next id
									(*w_p)->value->id.epmem_id = my_agent->epmem_stats->next_id->get_value();
									(*w_p)->value->id.epmem_valid = my_agent->epmem_validation;
									my_agent->epmem_stats->next_id->set_value( (*w_p)->value->id.epmem_id + 1 );
									epmem_set_variable( my_agent, var_next_id, (*w_p)->value->id.epmem_id + 1 );

									// add repository
									(*my_agent->epmem_id_repository)[ (*w_p)->value->id.epmem_id ] = new epmem_hashed_id_pool;

									// add ref set
#ifdef USE_MEM_POOL_ALLOCATORS
									(*my_agent->epmem_id_ref_counts)[ (*w_p)->value->id.epmem_id ] = new epmem_wme_set( std::less< wme* >(), soar_module::soar_memory_pool_allocator< wme* >( my_agent ) );
#else
									(*my_agent->epmem_id_ref_counts)[ (*w_p)->value->id.epmem_id ] = new epmem_wme_set;
#endif
								}

								// insert (q0,w,q1)
								my_agent->epmem_stmts_graph->add_edge_unique->bind_int( 1, parent_id );
								my_agent->epmem_stmts_graph->add_edge_unique->bind_int( 2, my_hash );
								my_agent->epmem_stmts_graph->add_edge_unique->bind_int( 3, (*w_p)->value->id.epmem_id );
								my_agent->epmem_stmts_graph->add_edge_unique->execute( soar_module::op_reinit );

								(*w_p)->epmem_id = static_cast<epmem_node_id>( my_agent->epmem_db->last_insert_rowid() );

								if ( !(*w_p)->value->id.smem_lti )
								{
									(*my_agent->epmem_id_replacement)[ (*w_p)->epmem_id ] = my_id_repo2;
								}

								// new nodes definitely start
								epmem_edge.push( (*w_p)->epmem_id );
								my_agent->epmem_edge_mins->push_back( time_counter );
								my_agent->epmem_edge_maxes->push_back( false );
							}
							else
							{
								// definitely don't remove
								(*my_agent->epmem_edge_removals)[ (*w_p)->epmem_id ] = false;

								// we add ONLY if the last thing we did was remove
								if ( (*my_agent->epmem_edge_maxes)[ (*w_p)->epmem_id - 1 ] )
								{
									epmem_edge.push( (*w_p)->epmem_id );
									(*my_agent->epmem_edge_maxes)[ (*w_p)->epmem_id - 1 ] = false;
								}
							}

							// at this point we have successfully added a new wme
							// whose value was an identifier.  If the identifier was
							// unknown at the beginning of this episode, then we need
							// to update its ref count for each WME added.
							if ( new_identifiers.find( (*w_p)->value ) != new_identifiers.end() )
							{
								// because we could have bypassed the ref set before, we need to create it here
								if ( my_agent->epmem_id_ref_counts->count( (*w_p)->value->id.epmem_id ) == 0 )
								{
#ifdef USE_MEM_POOL_ALLOCATORS
									(*my_agent->epmem_id_ref_counts)[ (*w_p)->value->id.epmem_id ] = new epmem_wme_set( std::less< wme* >(), soar_module::soar_memory_pool_allocator< wme* >( my_agent ) );
#else
									(*my_agent->epmem_id_ref_counts)[ (*w_p)->value->id.epmem_id ] = new epmem_wme_set;
#endif
								}
								(*my_agent->epmem_id_ref_counts)[ (*w_p)->value->id.epmem_id ]->insert( (*w_p) );
							}
						}
						else
						{
							if ( (*w_p)->value->id.smem_lti )
							{
								if ( ( (*w_p)->value->id.smem_time_id == time_counter ) && ( (*w_p)->value->id.smem_valid == my_agent->epmem_validation ) )
								{
									// parent_id,letter,num,time_id
									my_agent->epmem_stmts_graph->promote_id->bind_int( 1, (*w_p)->value->id.epmem_id );
									my_agent->epmem_stmts_graph->promote_id->bind_int( 2, static_cast<uint64_t>( (*w_p)->value->id.name_letter ) );
									my_agent->epmem_stmts_graph->promote_id->bind_int( 3, static_cast<uint64_t>( (*w_p)->value->id.name_number ) );
									my_agent->epmem_stmts_graph->promote_id->bind_int( 4, time_counter );
									my_agent->epmem_stmts_graph->promote_id->execute( soar_module::op_reinit );
								}
							}
						}

						// continue to children?
						if ( (*w_p)->value->id.tc_num != tc )
						{
							// future exploration
							parent_syms.push( (*w_p)->value );
							parent_ids.push( (*w_p)->value->id.epmem_id );
						}
					}
					else
					{
						// have we seen this node in this database?
						if ( ( (*w_p)->epmem_id == EPMEM_NODEID_BAD ) || ( (*w_p)->epmem_valid != my_agent->epmem_validation ) )
						{
							(*w_p)->epmem_id = EPMEM_NODEID_BAD;
							(*w_p)->epmem_valid = my_agent->epmem_validation;

							my_hash = epmem_temporal_hash( my_agent, (*w_p)->attr );
							my_hash2 = epmem_temporal_hash( my_agent, (*w_p)->value );

							// try to get node id
							{
								// parent_id=? AND attr=? AND value=?
								my_agent->epmem_stmts_graph->find_node_unique->bind_int( 1, parent_id );
								my_agent->epmem_stmts_graph->find_node_unique->bind_int( 2, my_hash );
								my_agent->epmem_stmts_graph->find_node_unique->bind_int( 3, my_hash2 );

								if ( my_agent->epmem_stmts_graph->find_node_unique->execute() == soar_module::row )
								{
									(*w_p)->epmem_id = my_agent->epmem_stmts_graph->find_node_unique->column_int( 0 );
								}

								my_agent->epmem_stmts_graph->find_node_unique->reinitialize();
							}

							// act depending on new/existing feature
							if ( (*w_p)->epmem_id == EPMEM_NODEID_BAD )
							{
								// insert (parent_id,attr,value)
								my_agent->epmem_stmts_graph->add_node_unique->bind_int( 1, parent_id );
								my_agent->epmem_stmts_graph->add_node_unique->bind_int( 2, my_hash );
								my_agent->epmem_stmts_graph->add_node_unique->bind_int( 3, my_hash2 );
								my_agent->epmem_stmts_graph->add_node_unique->execute( soar_module::op_reinit );

								(*w_p)->epmem_id = (epmem_node_id) my_agent->epmem_db->last_insert_rowid();

								// new nodes definitely start
								epmem_node.push( (*w_p)->epmem_id );
								my_agent->epmem_node_mins->push_back( time_counter );
								my_agent->epmem_node_maxes->push_back( false );
							}
							else
							{
								// definitely don't remove
								(*my_agent->epmem_node_removals)[ (*w_p)->epmem_id ] = false;

								// add ONLY if the last thing we did was remove
								if ( (*my_agent->epmem_node_maxes)[ (*w_p)->epmem_id - 1 ] )
								{
									epmem_node.push( (*w_p)->epmem_id );
									(*my_agent->epmem_node_maxes)[ (*w_p)->epmem_id - 1 ] = false;
								}
							}
						}
					}
				}

				// free space from aug list
				delete wmes;
			}
		}

		// all inserts
		{
			epmem_node_id *temp_node;

#ifdef EPMEM_EXPERIMENT
			epmem_dc_interval_inserts = epmem_node.size() + epmem_edge.size();
#endif

			// nodes
			while ( !epmem_node.empty() )
			{
				temp_node =& epmem_node.front();

				// add NOW entry
				// id = ?, start = ?
				my_agent->epmem_stmts_graph->add_node_now->bind_int( 1, (*temp_node) );
				my_agent->epmem_stmts_graph->add_node_now->bind_int( 2, time_counter );
				my_agent->epmem_stmts_graph->add_node_now->execute( soar_module::op_reinit );

				// update min
				(*my_agent->epmem_node_mins)[ (*temp_node) - 1 ] = time_counter;

				epmem_node.pop();
			}

			// edges
			while ( !epmem_edge.empty() )
			{
				temp_node =& epmem_edge.front();

				// add NOW entry
				// id = ?, start = ?
				my_agent->epmem_stmts_graph->add_edge_now->bind_int( 1, (*temp_node) );
				my_agent->epmem_stmts_graph->add_edge_now->bind_int( 2, time_counter );
				my_agent->epmem_stmts_graph->add_edge_now->execute( soar_module::op_reinit );

				// update min
				(*my_agent->epmem_edge_mins)[ (*temp_node) - 1 ] = time_counter;

				epmem_edge.pop();
			}
		}

		// all removals
		{
			std::map<epmem_node_id, bool>::iterator r;
			epmem_time_id range_start;
			epmem_time_id range_end;

#ifdef EPMEM_EXPERIMENT
			epmem_dc_interval_removes = 0;
#endif

			// nodes
			r = my_agent->epmem_node_removals->begin();
			while ( r != my_agent->epmem_node_removals->end() )
			{
				if ( r->second )
				{
#ifdef EPMEM_EXPERIMENT
					epmem_dc_interval_removes++;
#endif

					// remove NOW entry
					// id = ?
					my_agent->epmem_stmts_graph->delete_node_now->bind_int( 1, r->first );
					my_agent->epmem_stmts_graph->delete_node_now->execute( soar_module::op_reinit );

					range_start = (*my_agent->epmem_node_mins)[ r->first - 1 ];
					range_end = ( time_counter - 1 );

					// point (id, start)
					if ( range_start == range_end )
					{
						my_agent->epmem_stmts_graph->add_node_point->bind_int( 1, r->first );
						my_agent->epmem_stmts_graph->add_node_point->bind_int( 2, range_start );
						my_agent->epmem_stmts_graph->add_node_point->execute( soar_module::op_reinit );
					}
					// node
					else
					{
						epmem_rit_insert_interval( my_agent, range_start, range_end, r->first, &( my_agent->epmem_rit_state_graph[ EPMEM_RIT_STATE_NODE ] ) );
					}

					// update max
					(*my_agent->epmem_node_maxes)[ r->first - 1 ] = true;
				}

				r++;
			}
			my_agent->epmem_node_removals->clear();

			// edges
			r = my_agent->epmem_edge_removals->begin();
			while ( r != my_agent->epmem_edge_removals->end() )
			{
				if ( r->second )
				{
#ifdef EPMEM_EXPERIMENT
					epmem_dc_interval_removes++;
#endif

					// remove NOW entry
					// id = ?
					my_agent->epmem_stmts_graph->delete_edge_now->bind_int( 1, r->first );
					my_agent->epmem_stmts_graph->delete_edge_now->execute( soar_module::op_reinit );

					range_start = (*my_agent->epmem_edge_mins)[ r->first - 1 ];
					range_end = ( time_counter - 1 );

					// point (id, start)
					if ( range_start == range_end )
					{
						my_agent->epmem_stmts_graph->add_edge_point->bind_int( 1, r->first );
						my_agent->epmem_stmts_graph->add_edge_point->bind_int( 2, range_start );
						my_agent->epmem_stmts_graph->add_edge_point->execute( soar_module::op_reinit );
					}
					// node
					else
					{
						epmem_rit_insert_interval( my_agent, range_start, range_end, r->first, &( my_agent->epmem_rit_state_graph[ EPMEM_RIT_STATE_EDGE ] ) );
					}

					// update max
					(*my_agent->epmem_edge_maxes)[ r->first - 1 ] = true;
				}

				r++;
			}
			my_agent->epmem_edge_removals->clear();
		}

		// add the time id to the times table
		my_agent->epmem_stmts_graph->add_time->bind_int( 1, time_counter );
		my_agent->epmem_stmts_graph->add_time->execute( soar_module::op_reinit );

		my_agent->epmem_stats->time->set_value( time_counter + 1 );

		// update time wme on all states
		{
			Symbol* state = my_agent->bottom_goal;
			Symbol* my_time_sym = make_int_constant( my_agent, time_counter + 1 );

			while ( state != NULL )
			{
				if ( state->id.epmem_time_wme != NIL )
				{
					soar_module::remove_module_wme( my_agent, state->id.epmem_time_wme );
				}

				state->id.epmem_time_wme = soar_module::add_module_wme( my_agent, state->id.epmem_header, my_agent->epmem_sym_present_id, my_time_sym );

				state = state->id.higher_goal;
			}

			symbol_remove_ref( my_agent, my_time_sym );
		}
	}

	////////////////////////////////////////////////////////////////////////////
	my_agent->epmem_timers->storage->stop();
	////////////////////////////////////////////////////////////////////////////
}

//////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////
// Non-Cue-Based Retrieval Functions (epmem::ncb)
//
// NCB retrievals occur when you know the episode you
// want to retrieve.  It is the process of converting
// the database representation to WMEs in working
// memory.
//
// This occurs at the end of a cue-based query, or
// in response to a retrieve/next/previous command.
//
//////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////

/***************************************************************************
 * Function     : epmem_valid_episode
 * Author		: Nate Derbinsky
 * Notes		: Returns true if the temporal id is valid
 **************************************************************************/
bool epmem_valid_episode( agent *my_agent, epmem_time_id memory_id )
{
	bool return_val = false;

	{
		soar_module::sqlite_statement *my_q = my_agent->epmem_stmts_graph->valid_episode;

		my_q->bind_int( 1, memory_id );
		my_q->execute();
		return_val = ( my_q->column_int( 0 ) > 0 );
		my_q->reinitialize();
	}

	return return_val;
}

inline void _epmem_install_id_wme( agent* my_agent, Symbol* parent, Symbol* attr, std::map< epmem_node_id, std::pair< Symbol*, bool > >* ids, epmem_node_id q1, bool val_is_short_term, char val_letter, uint64_t val_num, epmem_id_mapping* id_record, soar_module::symbol_triple_list& retrieval_wmes )
{
	std::map< epmem_node_id, std::pair< Symbol*, bool > >::iterator id_p = ids->find( q1 );
	bool existing_identifier = ( id_p != ids->end() );

	if ( val_is_short_term )
	{
		if ( !existing_identifier )
		{
			id_p = ids->insert( std::make_pair< epmem_node_id, std::pair< Symbol*, bool > >( q1, std::make_pair< Symbol*, bool >( make_new_identifier( my_agent, ( ( attr->common.symbol_type == SYM_CONSTANT_SYMBOL_TYPE )?( attr->sc.name[0] ):('E') ), parent->id.level ), true ) ) ).first;
			if ( id_record )
			{
				epmem_id_mapping::iterator rec_p = id_record->find( q1 );
				if ( rec_p != id_record->end() )
				{
					rec_p->second = id_p->second.first;
				}
			}
		}

		epmem_buffer_add_wme( retrieval_wmes, parent, attr, id_p->second.first );

		if ( !existing_identifier )
		{
			symbol_remove_ref( my_agent, id_p->second.first );
		}
	}
	else
	{
		if ( existing_identifier )
		{
			epmem_buffer_add_wme( retrieval_wmes, parent, attr, id_p->second.first );
		}
		else
		{
			Symbol* value = smem_lti_soar_make( my_agent, smem_lti_get_id( my_agent, val_letter, val_num ), val_letter, val_num, parent->id.level );

			if ( id_record )
			{
				epmem_id_mapping::iterator rec_p = id_record->find( q1 );
				if ( rec_p != id_record->end() )
				{
					rec_p->second = value;
				}
			}

			epmem_buffer_add_wme( retrieval_wmes, parent, attr, value );
			symbol_remove_ref( my_agent, value );

			ids->insert( std::make_pair< epmem_node_id, std::pair< Symbol*, bool > >( q1, std::make_pair< Symbol*, bool >( value, !( ( value->id.impasse_wmes ) || ( value->id.input_wmes ) || ( value->id.slots ) ) ) ) );
		}
	}
}

/***************************************************************************
 * Function     : epmem_install_memory
 * Author		: Nate Derbinsky
 * Notes		: Reconstructs an episode in working memory.
 *
 * 				  Use RIT to collect appropriate ranges.  Then
 * 				  combine with NOW and POINT.  Merge with unique
 * 				  to get all the data necessary to create WMEs.
 *
 * 				  The id_record parameter is only used in the case
 * 				  that the graph-match has a match and creates
 * 				  a mapping of identifiers that should be recorded
 * 				  during reconstruction.
 **************************************************************************/
void epmem_install_memory( agent *my_agent, Symbol *state, epmem_time_id memory_id, soar_module::symbol_triple_list& meta_wmes, soar_module::symbol_triple_list& retrieval_wmes, epmem_id_mapping *id_record = NULL )
{
	////////////////////////////////////////////////////////////////////////////
	my_agent->epmem_timers->ncb_retrieval->start();
	////////////////////////////////////////////////////////////////////////////

	// get the ^result header for this state
	Symbol *result_header = state->id.epmem_result_header;

	// initialize stat
	int64_t num_wmes = 0;
	my_agent->epmem_stats->ncb_wmes->set_value( num_wmes );

	// if no memory, say so
	if ( ( memory_id == EPMEM_MEMID_NONE ) ||
			!epmem_valid_episode( my_agent, memory_id ) )
	{
		epmem_buffer_add_wme( meta_wmes, result_header, my_agent->epmem_sym_retrieved, my_agent->epmem_sym_no_memory );
		state->id.epmem_info->last_memory = EPMEM_MEMID_NONE;

		////////////////////////////////////////////////////////////////////////////
		my_agent->epmem_timers->ncb_retrieval->stop();
		////////////////////////////////////////////////////////////////////////////

		return;
	}

	// remember this as the last memory installed
	state->id.epmem_info->last_memory = memory_id;

	// create a new ^retrieved header for this result
	Symbol *retrieved_header;
	retrieved_header = make_new_identifier( my_agent, 'R', result_header->id.level );
	if ( id_record )
	{
		(*id_record)[ EPMEM_NODEID_ROOT ] = retrieved_header;
	}

	epmem_buffer_add_wme( meta_wmes, result_header, my_agent->epmem_sym_retrieved, retrieved_header );
	symbol_remove_ref( my_agent, retrieved_header );

	// add *-id wme's
	{
		Symbol *my_meta;

		my_meta = make_int_constant( my_agent, static_cast<int64_t>( memory_id ) );
		epmem_buffer_add_wme( meta_wmes, result_header, my_agent->epmem_sym_memory_id, my_meta );
		symbol_remove_ref( my_agent, my_meta );

		my_meta = make_int_constant( my_agent, static_cast<int64_t>( my_agent->epmem_stats->time->get_value() ) );
		epmem_buffer_add_wme( meta_wmes, result_header, my_agent->epmem_sym_present_id, my_meta );
		symbol_remove_ref( my_agent, my_meta );
	}

	// install memory
	{
		// Big picture: create identifier skeleton, then hang non-identifers
		//
		// Because of shared WMEs at different levels of the storage breadth-first search,
		// there is the possibility that the unique database id of an identifier can be
		// greater than that of its parent.  Because the retrieval query sorts by
		// unique id ascending, it is thus possible to have an "orphan" - a child with
		// no current parent.  We keep track of orphans and add them later, hoping their
		// parents have shown up.  I *suppose* there could be a really evil case in which
		// the ordering of the unique ids is exactly opposite of their insertion order.
		// I just hope this isn't a common case...

		// shared identifier lookup table
		std::map< epmem_node_id, std::pair< Symbol*, bool > > ids;
		bool dont_abide_by_ids_second = ( my_agent->epmem_params->merge->get_value() == epmem_param_container::merge_add );

		// symbols used to create WMEs
		Symbol *attr = NULL;

		// lookup query
		soar_module::sqlite_statement *my_q;

		// initialize the lookup table
		ids[ EPMEM_NODEID_ROOT ] = std::make_pair< Symbol*, bool >( retrieved_header, true );

		// first identifiers (i.e. reconstruct)
		my_q = my_agent->epmem_stmts_graph->get_edges;
		{
			// relates to finite automata: q1 = d(q0, w)
			epmem_node_id q0; // id
			epmem_node_id q1; // attribute
			int64_t w_type; // we support any constant attribute symbol

			bool val_is_short_term = false;
			char val_letter = NIL;
			int64_t val_num = NIL;

			// used to lookup shared identifiers
			// the bool in the pair refers to if children are allowed on this id (re: lti)
			std::map< epmem_node_id, std::pair< Symbol*, bool> >::iterator id_p;

			// orphaned children
			std::queue< epmem_edge* > orphans;
			epmem_edge *orphan;

			epmem_rit_prep_left_right( my_agent, memory_id, memory_id, &( my_agent->epmem_rit_state_graph[ EPMEM_RIT_STATE_EDGE ] ) );

			my_q->bind_int( 1, memory_id );
			my_q->bind_int( 2, memory_id );
			my_q->bind_int( 3, memory_id );
			my_q->bind_int( 4, memory_id );
			my_q->bind_int( 5, memory_id );
			while ( my_q->execute() == soar_module::row )
			{
				// q0, w, q1, w_type
				q0 = my_q->column_int( 0 );
				q1 = my_q->column_int( 2 );
				w_type = my_q->column_int( 3 );

				switch ( w_type )
				{
					case INT_CONSTANT_SYMBOL_TYPE:
						attr = make_int_constant( my_agent,my_q->column_int( 1 ) );
						break;

					case FLOAT_CONSTANT_SYMBOL_TYPE:
						attr = make_float_constant( my_agent, my_q->column_double( 1 ) );
						break;

					case SYM_CONSTANT_SYMBOL_TYPE:
						attr = make_sym_constant( my_agent, const_cast<char *>( reinterpret_cast<const char *>( my_q->column_text( 1 ) ) ) );
						break;
				}

				// short vs. long-term
				val_is_short_term = ( my_q->column_type( 4 ) == soar_module::null_t );
				if ( !val_is_short_term )
				{
					val_letter = static_cast<char>( my_q->column_int( 4 ) );
					val_num = static_cast<uint64_t>( my_q->column_int( 5 ) );
				}

				// get a reference to the parent
				id_p = ids.find( q0 );
				if ( id_p != ids.end() )
				{
					// if existing lti with kids don't touch
					if ( dont_abide_by_ids_second || id_p->second.second )
					{
						_epmem_install_id_wme( my_agent, id_p->second.first, attr, &( ids ), q1, val_is_short_term, val_letter, val_num, id_record, retrieval_wmes );
						num_wmes++;
					}

					symbol_remove_ref( my_agent, attr );
				}
				else
				{
					// out of order
					orphan = new epmem_edge;
					orphan->q0 = q0;
					orphan->w = attr;
					orphan->q1 = q1;

					orphan->val_letter = NIL;
					orphan->val_num = NIL;

					orphan->val_is_short_term = val_is_short_term;
					if ( !val_is_short_term )
					{
						orphan->val_letter = val_letter;
						orphan->val_num = val_num;
					}

					orphans.push( orphan );
				}
			}
			my_q->reinitialize();
			epmem_rit_clear_left_right( my_agent );

			// take care of any orphans
			if ( !orphans.empty() )
			{
				std::queue<epmem_edge *>::size_type orphans_left;
				std::queue<epmem_edge *> still_orphans;

				do
				{
					orphans_left = orphans.size();

					while ( !orphans.empty() )
					{
						orphan = orphans.front();
						orphans.pop();

						// get a reference to the parent
						id_p = ids.find( orphan->q0 );
						if ( id_p != ids.end() )
						{
							if ( dont_abide_by_ids_second || id_p->second.second )
							{
								_epmem_install_id_wme( my_agent, id_p->second.first, orphan->w, &( ids ), orphan->q1, orphan->val_is_short_term, orphan->val_letter, orphan->val_num, id_record, retrieval_wmes );
								num_wmes++;
							}

							symbol_remove_ref( my_agent, orphan->w );

							delete orphan;
						}
						else
						{
							still_orphans.push( orphan );
						}
					}

					orphans = still_orphans;
					while ( !still_orphans.empty() )
					{
						still_orphans.pop();
					}

				} while ( ( !orphans.empty() ) && ( orphans_left != orphans.size() ) );

				while ( !orphans.empty() )
				{
					orphan = orphans.front();
					orphans.pop();

					symbol_remove_ref( my_agent, orphan->w );

					delete orphan;
				}
			}
		}

		// then node_unique
		my_q = my_agent->epmem_stmts_graph->get_nodes;
		{
			epmem_node_id child_id;
			epmem_node_id parent_id;
			int64_t attr_type;
			int64_t value_type;

			std::pair< Symbol*, bool > parent;
			Symbol *value = NULL;

			epmem_rit_prep_left_right( my_agent, memory_id, memory_id, &( my_agent->epmem_rit_state_graph[ EPMEM_RIT_STATE_NODE ] ) );

			my_q->bind_int( 1, memory_id );
			my_q->bind_int( 2, memory_id );
			my_q->bind_int( 3, memory_id );
			my_q->bind_int( 4, memory_id );
			while ( my_q->execute() == soar_module::row )
			{
				// f.child_id, f.parent_id, f.name, f.value, f.attr_type, f.value_type
				child_id = my_q->column_int( 0 );
				parent_id = my_q->column_int( 1 );
				attr_type = my_q->column_int( 4 );
				value_type = my_q->column_int( 5 );

				// get a reference to the parent
				parent = ids[ parent_id ];

				if ( dont_abide_by_ids_second || parent.second )
				{
					// make a symbol to represent the attribute
					switch ( attr_type )
					{
						case INT_CONSTANT_SYMBOL_TYPE:
							attr = make_int_constant( my_agent, my_q->column_int( 2 ) );
							break;

						case FLOAT_CONSTANT_SYMBOL_TYPE:
							attr = make_float_constant( my_agent, my_q->column_double( 2 ) );
							break;

						case SYM_CONSTANT_SYMBOL_TYPE:
							attr = make_sym_constant( my_agent, const_cast<char *>( reinterpret_cast<const char *>( my_q->column_text( 2 ) ) ) );
							break;
					}

					// make a symbol to represent the value
					switch ( value_type )
					{
						case INT_CONSTANT_SYMBOL_TYPE:
							value = make_int_constant( my_agent,my_q->column_int( 3 ) );
							break;

						case FLOAT_CONSTANT_SYMBOL_TYPE:
							value = make_float_constant( my_agent, my_q->column_double( 3 ) );
							break;

						case SYM_CONSTANT_SYMBOL_TYPE:
							value = make_sym_constant( my_agent, const_cast<char *>( (const char *) my_q->column_text( 3 ) ) );
							break;
					}

					epmem_buffer_add_wme( retrieval_wmes, parent.first, attr, value );
					num_wmes++;

					symbol_remove_ref( my_agent, attr );
					symbol_remove_ref( my_agent, value );
				}
			}
			my_q->reinitialize();
			epmem_rit_clear_left_right( my_agent );
		}
	}

	// adjust stat
	my_agent->epmem_stats->ncb_wmes->set_value( num_wmes );

	////////////////////////////////////////////////////////////////////////////
	my_agent->epmem_timers->ncb_retrieval->stop();
	////////////////////////////////////////////////////////////////////////////
}

/***************************************************************************
 * Function     : epmem_next_episode
 * Author		: Nate Derbinsky
 * Notes		: Returns the next valid temporal id.  This is really
 * 				  only an issue if you implement episode dynamics like
 * 				  forgetting.
 **************************************************************************/
epmem_time_id epmem_next_episode( agent *my_agent, epmem_time_id memory_id )
{
	////////////////////////////////////////////////////////////////////////////
	my_agent->epmem_timers->next->start();
	////////////////////////////////////////////////////////////////////////////

	epmem_time_id return_val = EPMEM_MEMID_NONE;

	if ( memory_id != EPMEM_MEMID_NONE )
	{
		soar_module::sqlite_statement *my_q = my_agent->epmem_stmts_graph->next_episode;
		my_q->bind_int( 1, memory_id );
		if ( my_q->execute() == soar_module::row )
		{
			return_val = (epmem_time_id) my_q->column_int( 0 );
		}

		my_q->reinitialize();
	}

	////////////////////////////////////////////////////////////////////////////
	my_agent->epmem_timers->next->stop();
	////////////////////////////////////////////////////////////////////////////

	return return_val;
}

/***************************************************************************
 * Function     : epmem_previous_episode
 * Author		: Nate Derbinsky
 * Notes		: Returns the last valid temporal id.  This is really
 * 				  only an issue if you implement episode dynamics like
 * 				  forgetting.
 **************************************************************************/
epmem_time_id epmem_previous_episode( agent *my_agent, epmem_time_id memory_id )
{
	////////////////////////////////////////////////////////////////////////////
	my_agent->epmem_timers->prev->start();
	////////////////////////////////////////////////////////////////////////////

	epmem_time_id return_val = EPMEM_MEMID_NONE;

	if ( memory_id != EPMEM_MEMID_NONE )
	{
		soar_module::sqlite_statement *my_q = my_agent->epmem_stmts_graph->prev_episode;
		my_q->bind_int( 1, memory_id );
		if ( my_q->execute() == soar_module::row )
		{
			return_val = (epmem_time_id) my_q->column_int( 0 );
		}

		my_q->reinitialize();
	}

	////////////////////////////////////////////////////////////////////////////
	my_agent->epmem_timers->prev->stop();
	////////////////////////////////////////////////////////////////////////////

	return return_val;
}


//////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////
// Cue-Based Retrieval (epmem::cbr)
//
// Cue-based retrievals are searches in response to
// queries and/or neg-queries.
//
// All functions below implement John/Andy's range search
// algorithm (see Andy's thesis).  The primary insight
// is to only deal with changes.  In this case, change
// occurs at the end points of ranges of node occurrence.
//
// The implementations below share a common theme:
// 1) identify wmes in the cue
// 2) get pointers to ALL b-tree leaves
//    associated with sorted occurrence-endpoints
//    of these wmes (ranges, points, now)
// 3) step through the leaves according to the range
//    search algorithm
//
// In the Working Memory Tree, the occurrence of a leaf
// node is tantamount to the occurrence of the path to
// the leaf node (since there are no shared identifiers).
// However, when we add graph functionality, path is
// important.  Moreover, identifiers that "blink" have
// ambiguous identities over time.  Thus I introduced
// the Disjunctive Normal Form (DNF) graph.
//
// The primary insight of the DNF graph is that paths to
// leaf nodes can be written as the disjunction of the
// conjunction of paths.
//
// Metaphor: consider that a human child's lineage is
// in question (perhaps for purposes of estate).  We
// are unsure as to the child's grandfather.  The grand-
// father can be either gA or gB.  If it is gA, then the
// father is absolutely fA (otherwise fB).  So the child
// could exist as (where cX is child with lineage X):
//
// (gA ^ fA ^ cA) \/ (gB ^ fB ^ cB)
//
// Note that due to family... irregularities
// (i.e. men sleeping around), a parent might contribute
// to multiple family lines.  Thus gX could exist in
// multiple clauses.  However, due to well-enforced
// incest laws (i.e. we only support acyclic graph cues),
// an individual can only occur once within a lineage/clause.
//
// We have a "match" (i.e. identify the child's lineage)
// only if all literals are "on" in a path of
// lineage.  Thus, our task is to efficiently track DNF
// satisfaction while flipping on/off a single literal
// (which may exist in multiple clauses).
//
// The DNF graph implements this intuition efficiently by
// (say it with me) only processing changes!  First we
// construct the graph by creating "literals" (gA, fA, etc)
// and maintaining parent-child relationships (gA connects
// to fA which connects to cA).  Leaf literals have no
// children, but are associated with a "match."  Each match
// has a cardinality count (positive/negative 1 depending on
// query vs. neg-query) and a WMA value (weighting).
//
// We then connect the b-tree pointers from above with
// each of the literals.  It is possible that a query
// can serve multiple literals, so we gain from sharing.
//
// Nodes within the DNF Graph need only save a "count":
// zero means neither it nor its lineage to date is
// satisfied, one means either its lineage or it is
// satisfied, two means it and its lineage is satisfied.
//
// The range search algorithm is simply walking (in-order)
// the parallel b-tree pointers.  When we get to an endpoint,
// we appropriately turn on/off all directly associated
// literals.  Based upon the current state of the literals,
// we may need to propagate changes to children.
//
// If propogation reaches and changes a match, we alter the
// current episode's cardinality/score.  Thus we achieve
// the Soar mantra of only processing changes!
//
//////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////

/***************************************************************************
 * Function     : epmem_create_leaf_node
 * Author		: Nate Derbinsky
 * Notes		: Just a quicky constructor
 **************************************************************************/
inline epmem_leaf_node *epmem_create_leaf_node( epmem_node_id leaf_id, double leaf_weight )
{
	epmem_leaf_node *newbie = new epmem_leaf_node;

	newbie->leaf_id = leaf_id;
	newbie->leaf_weight = leaf_weight;

	return newbie;
}

/***************************************************************************
 * Function     : epmem_shared_flip
 * Author		: Nate Derbinsky
 * Notes		: Implements flipping a literal in the DNF Graph
 * 				  (see above description).
 **************************************************************************/
void epmem_shared_flip( epmem_shared_literal_pair *flip, const unsigned int list, int64_t &ct, double &v, int64_t &updown )
{
	int64_t ct_change = ( ( list == EPMEM_RANGE_START )?( -1 ):( 1 ) );

	// if recursive propogation, count change
	// is dependent upon wme count
	bool alter_ct = true;
	if ( flip->lit->incoming )
	{
		alter_ct = false;

		// find the map with respect to the parent identity
		epmem_shared_incoming_wme_map** id_map =& (*flip->lit->incoming->book)[ flip->q0 ];
		if ( !(*id_map) )
		{
			(*id_map) = new epmem_shared_incoming_wme_map;

			// initialize counts below
			{
				bool rooted = ( flip->q0 == EPMEM_NODEID_ROOT );

				epmem_shared_incoming_ids_book::iterator id_p;
				epmem_wme_list::iterator w_p;
				epmem_shared_incoming_identity_counter* new_identity_counter;

				for ( id_p=flip->lit->incoming->parents->begin(); id_p!=flip->lit->incoming->parents->end(); id_p++ )
				{
					new_identity_counter = new epmem_shared_incoming_identity_counter;

					new_identity_counter->ct = 0;

					new_identity_counter->cts = new epmem_shared_incoming_wme_counter_map;
					for ( w_p=id_p->second->outgoing->begin(); w_p!=id_p->second->outgoing->end(); w_p++ )
					{
						new_identity_counter->cts->insert( std::make_pair( (*w_p), ( ( rooted )?( 1 ):( 0 ) ) ) );
					}

					(*id_map)->insert( std::make_pair( id_p->first, new_identity_counter ) );
				}
			}
		}

		// find the wme map, get the literal count
		epmem_shared_incoming_identity_counter* sym_ct = (*(*id_map))[ flip->wme->id ];
		uint64_t *lit_ct =& (*(sym_ct->cts))[ flip->wme ];

		// update the count
		(*lit_ct) += ct_change;

		// if appropriate, change the id count
		if ( (*lit_ct) == ( static_cast<uint64_t>( ( list == EPMEM_RANGE_START )?( EPMEM_DNF - 1 ):( EPMEM_DNF ) ) ) )
		{
			sym_ct->ct += ct_change;

			// if appropriate modify the parent set and possibly children
			{
				epmem_shared_incoming_id_book* book_p;

				if ( list == EPMEM_RANGE_START )
				{
					if ( sym_ct->ct == ( sym_ct->cts->size() - 1 ) )
					{
						book_p = (*flip->lit->incoming->parents)[ flip->wme->id ];

						book_p->satisfactory->erase( flip->q0 );
						alter_ct = ( book_p->satisfactory->empty() );
					}
				}
				else
				{
					if ( sym_ct->ct == sym_ct->cts->size() )
					{
						book_p = (*flip->lit->incoming->parents)[ flip->wme->id ];

						book_p->satisfactory->insert( flip->q0 );
						alter_ct = ( book_p->satisfactory->size() == 1 );
					}
				}
			}
		}
	}

	if ( alter_ct )
	{
		uint64_t max_compare = ( ( list == EPMEM_RANGE_START )?( flip->lit->max - 1 ):( flip->lit->max ) );

		flip->lit->ct += ct_change;
		if ( flip->lit->ct == max_compare )
		{
			if ( flip->lit->children )
			{
				epmem_shared_literal_group::iterator wme_p;
				epmem_shared_literal_map::iterator lit_p;

				for ( wme_p=flip->lit->children->begin(); wme_p!= flip->lit->children->end(); wme_p++ )
				{
					for ( lit_p=wme_p->second->begin(); lit_p!=wme_p->second->end(); lit_p++ )
					{
						epmem_shared_flip( lit_p->second, list, ct, v, updown );
					}
				}
			}
			else if ( flip->lit->match )
			{
				uint64_t match_compare = ( ( list == EPMEM_RANGE_START )?( 0 ):( 1 ) );
				flip->lit->match->ct += ct_change;

				if ( flip->lit->match->ct == match_compare )
				{
					ct += flip->lit->match->value_ct;
					v += flip->lit->match->value_weight;

					updown++;
				}
			}
		}
	}
}

/***************************************************************************
 * Function     : epmem_shared_increment
 * Author		: Nate Derbinsky
 * Notes		: Implements a step in the range search algorithm for
 * 				  WM Graph (see above description).
 **************************************************************************/
void epmem_shared_increment( epmem_shared_query_list *queries, epmem_time_id &id, int64_t &ct, double &v, int64_t &updown, const unsigned int list )
{
	// initialize variables
	id = queries[ list ].top()->val;
	ct = 0;
	v = 0;
	updown = 0;

	bool more_data;
	epmem_shared_query *temp_query;
	epmem_shared_literal_pair_list::iterator literal_p;

	// a step continues until we run out
	// of endpoints or we get to a new
	// endpoint
	do
	{
		// get the next range endpoint
		temp_query = queries[ list ].top();
		queries[ list ].pop();

		// update current state by flipping all associated literals
		for ( literal_p=temp_query->triggers->begin(); literal_p!=temp_query->triggers->end(); literal_p++ )
			epmem_shared_flip( (*literal_p), list, ct, v, updown );

		// check if more endpoints exist for this wme
		more_data = ( temp_query->stmt->execute() == soar_module::row );
		if ( more_data )
		{
			// if so, add back to the priority queue
			temp_query->val = temp_query->stmt->column_int( 0 );
			queries[ list ].push( temp_query );
		}
		else
		{
			// away with ye
			delete temp_query->stmt;
			delete temp_query;
		}
	} while ( ( !queries[ list ].empty() ) && ( queries[ list ].top()->val == id ) );

	if ( list == EPMEM_RANGE_START )
		updown = -updown;
}

//////////////////////////////////////////////////////////
// Graph Match
//////////////////////////////////////////////////////////

bool _epmem_gm_compare_mcv( const epmem_shared_literal_pair_pair& a, const epmem_shared_literal_pair_pair& b )
{
	return ( a.second->size() < b.second->size() );
}

void _epmem_gm_sort_wmes_dfs( Symbol* id, tc_number tc, std::list< wme* >& ordered_wmes )
{
	slot* s;
	wme* w;
	Symbol* val;

	for ( s=id->id.slots; s; s=s->next )
	{
		for ( w=s->wmes; w; w=w->next )
		{
			ordered_wmes.push_back( w );
			val = w->value;

			if ( ( val->var.common_symbol_info.symbol_type == IDENTIFIER_SYMBOL_TYPE ) && ( val->id.tc_num != tc ) )
			{
				val->id.tc_num = tc;
				if ( !val->id.smem_lti )
				{
					_epmem_gm_sort_wmes_dfs( val, tc, ordered_wmes );
				}
			}
		}
	}
}

// finds a shared id for a symbol in a symbol->shared id map, or returns constant
inline epmem_node_id epmem_gm_find_assignment( Symbol* needle, epmem_gm_assignment_map* haystack )
{
	epmem_node_id return_val = EPMEM_NODEID_BAD;

	if ( needle->common.symbol_type == IDENTIFIER_SYMBOL_TYPE )
	{
		epmem_gm_assignment_map::iterator p = haystack->find( needle );
		if ( p != haystack->end() )
		{
			return_val = p->second;
		}
	}

	return return_val;
}

// returns true if a shared id has been used
inline bool epmem_gm_identity_used( epmem_node_id needle, epmem_shared_literal_set* haystack )
{
	return ( haystack->find( needle ) != haystack->end() );
}

// does a quick check on literal ct vs. max on id and value
inline bool epmem_gm_pair_satisfiable( epmem_shared_literal_pair* pair )
{
	return ( ( ( !pair->parent_lit ) || ( pair->parent_lit->ct == pair->parent_lit->max ) ) && ( pair->lit->ct == pair->lit->max ) );
}

inline bool epmem_gm_assign_identifier( epmem_shared_literal* lit, epmem_gm_assignment_map* id_assignments, epmem_shared_literal_set* used_ids, epmem_gm_sym_constraints* sym_constraints )
{
	bool return_val = false;

	Symbol* id = lit->shared_sym;
	epmem_node_id assignment = lit->shared_id;

	{
		// find if the value has already been assigned
		epmem_node_id existing_assignment = epmem_gm_find_assignment( id, id_assignments );

		// if so, satisfied only if this literal agrees
		if ( existing_assignment != EPMEM_NODEID_BAD )
		{
			return_val = ( existing_assignment == assignment );
		}
		else
		{
			// we know the value of the wme is not assigned,
			// so for consistency our shared_id cannot have
			// already been given out
			if ( !epmem_gm_identity_used( assignment, used_ids ) )
			{
				bool good_state = true;
				epmem_gm_sym_constraints::iterator existing_constraint;

				// and we can't violate constraints on the symbol
				existing_constraint = sym_constraints->find( id );
				if ( existing_constraint != sym_constraints->end() )
				{
					good_state = ( existing_constraint->second.find( assignment ) != existing_constraint->second.end() );
				}

				// and no parents can violate constraints
				if ( good_state )
				{
					epmem_shared_literal_set constraint_intersection;
					epmem_shared_incoming_ids_book::iterator incoming_p = lit->incoming->parents->begin();

					while ( good_state && ( incoming_p != lit->incoming->parents->end() ) )
					{
						// see if the id of the incoming wme has already been assigned
						existing_assignment = epmem_gm_find_assignment( incoming_p->first, id_assignments );
						if ( existing_assignment != EPMEM_NODEID_BAD )
						{
							// if so, it must be in the satisfied set
							good_state = ( incoming_p->second->satisfactory->find( existing_assignment ) != incoming_p->second->satisfactory->end() );
						}
						else
						{
							// make sure the added constraint will allow for a valid parent identifier (i.e. intersection is not null)
							existing_constraint = sym_constraints->find( incoming_p->first );
							if ( existing_constraint != sym_constraints->end() )
							{
								constraint_intersection.clear();
								set_intersection( existing_constraint->second.begin(), existing_constraint->second.end(), incoming_p->second->satisfactory->begin(), incoming_p->second->satisfactory->end(), inserter( constraint_intersection, constraint_intersection.begin() ) );

								if ( !constraint_intersection.empty() )
								{
									// if the intersection is non-null, propogate the intersection to future assignments
									existing_constraint->second = constraint_intersection;
								}
								else
								{
									good_state = false;
								}
							}
							else
							{
								// if there are no existing constraints, just copy this literal's satisfying set for the edge
								sym_constraints->insert( std::make_pair( incoming_p->first, (*incoming_p->second->satisfactory) ) );
							}
						}

						if ( good_state )
						{
							incoming_p++;
						}
					}

					// all constraints are satisfied!
					// add assignment, add used id, (constraints are added above)
					if ( good_state )
					{
						id_assignments->insert( std::make_pair( id, assignment ) );
						used_ids->insert( assignment );

						return_val = true;
					}
				}
			}
		}
	}

	return return_val;
}

inline bool epmem_gm_pair_satisfied( epmem_shared_literal_pair* pair, epmem_gm_assignment_map* id_assignments, epmem_shared_literal_set* used_ids, epmem_gm_sym_constraints* sym_constraints )
{
	if ( pair->wme->value->common.symbol_type == IDENTIFIER_SYMBOL_TYPE )
	{
		return ( ( ( !pair->parent_lit ) || epmem_gm_assign_identifier( pair->parent_lit, id_assignments, used_ids, sym_constraints ) ) &&
				epmem_gm_assign_identifier( pair->lit, id_assignments, used_ids, sym_constraints ) );
	}
	else
	{
		return ( ( !pair->parent_lit ) || epmem_gm_assign_identifier( pair->parent_lit, id_assignments, used_ids, sym_constraints ) );
	}
}

// a wme is satisfied if:
// - it is the end of the list of wmes OR
// - a pair in the WME is satisfied AND the rest of the list is satisfied
bool epmem_gm_wme_satisfied( epmem_shared_literal_pair_pair_vector::iterator wme_p, epmem_shared_literal_pair_pair_vector::iterator end_wme_p, epmem_gm_assignment_map* id_assignments, epmem_shared_literal_set* used_ids, epmem_gm_sym_constraints* sym_constraints )
{
	bool return_val = false;

	if ( wme_p == end_wme_p )
	{
		return_val = true;
	}
	else
	{
		epmem_shared_literal_pair_list* pairs = wme_p->second;
		epmem_shared_literal_pair_list::iterator pair_p = pairs->begin();

		epmem_shared_literal_pair_pair_vector::iterator next_wme_p = wme_p;
		next_wme_p++;

		// the pair call can modify these
		// note: we only propogate if the rest of the wmes are satisfied
		epmem_gm_assignment_map temp_id_assignments;
		epmem_shared_literal_set temp_used_ids;
		epmem_gm_sym_constraints temp_sym_constraints;

		while ( ( !return_val ) && ( pair_p != pairs->end() ) )
		{
			if ( epmem_gm_pair_satisfiable( (*pair_p) ) )
			{
				temp_id_assignments = (*id_assignments);
				temp_used_ids = (*used_ids);
				temp_sym_constraints = (*sym_constraints);

				return_val = ( epmem_gm_pair_satisfied( (*pair_p), &( temp_id_assignments ), &( temp_used_ids ), &( temp_sym_constraints ) ) && epmem_gm_wme_satisfied( next_wme_p, end_wme_p, &( temp_id_assignments ) , &( temp_used_ids ), &( temp_sym_constraints ) ) );

				if ( !return_val )
				{
					pair_p++;
				}
			}
			else
			{
				// a small optimization to prevent unnecessary copying
				// and function calls
				pair_p++;
			}
		}

		// if all went well, pass back the constraints
		if ( return_val )
		{
			(*id_assignments) = temp_id_assignments;
			(*used_ids) = temp_used_ids;
			(*sym_constraints) = temp_sym_constraints;
		}
	}

	return return_val;
}

// graph match is achieved if we can develop a set of assignments/constraints
// that satisfies the entire list of wmes
inline bool epmem_graph_match( epmem_shared_literal_pair_pair_vector* pairs, epmem_gm_assignment_map* id_assignments, epmem_shared_literal_set* used_ids, epmem_gm_sym_constraints* sym_constraints )
{
	return epmem_gm_wme_satisfied( pairs->begin(), pairs->end(), id_assignments, used_ids, sym_constraints );
}

//////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////


inline void epmem_clear_literal_group( epmem_shared_literal_group *del_group )
{
	for ( epmem_shared_literal_group::iterator p=del_group->begin(); p!=del_group->end(); p++ )
	{
		delete p->second;
	}
}

inline void epmem_add_literal_to_group( epmem_shared_literal_group *dest_group, epmem_shared_literal_pair *literal_pair )
{
	// refer to appropriate literal map (keyed by cue wme)
	epmem_shared_literal_map **dest_map =& (*dest_group)[ literal_pair->wme ];

	// if literal map doesn't exist, create it
	if ( !(*dest_map) )
	{
		(*dest_map) = new epmem_shared_literal_map;
	}

	// add literal to the map (if id doesn't already exist here)
	(*dest_map)->insert( std::make_pair( literal_pair->unique_id, literal_pair ) );
}

/***************************************************************************
 * Function     : epmem_process_query
 * Author		: Nate Derbinsky
 * Notes		: Performs cue-based query (see section description above).
 *
 * 				  The level parameter should be used only for profiling
 * 				  in experimentation:
 * 				  - level 3 (default): full query processing
 * 				  - level 2: no installing of found memory
 * 				  - level 1: no interval search
 **************************************************************************/
void epmem_process_query( agent *my_agent, Symbol *state, Symbol *query, Symbol *neg_query, epmem_time_list& prohibit, epmem_time_id before, epmem_time_id after, soar_module::wme_set& cue_wmes, soar_module::symbol_triple_list& meta_wmes, soar_module::symbol_triple_list& retrieval_wmes, int level=3 )
{
	////////////////////////////////////////////////////////////////////////////
	my_agent->epmem_timers->query->start();
	////////////////////////////////////////////////////////////////////////////

	epmem_wme_list *wmes_query = NULL;
	if ( query != NULL )
	{
		wmes_query = epmem_get_augs_of_id( query, get_new_tc_number( my_agent ) );
	}

	epmem_wme_list *wmes_neg_query = NULL;
	if ( neg_query != NULL )
	{
		wmes_neg_query = epmem_get_augs_of_id( neg_query, get_new_tc_number( my_agent ) );
	}

	// make sure that before and after, if set, are valid
	bool before_after_valid = true;
	if ( ( before != EPMEM_MEMID_NONE ) && ( after != EPMEM_MEMID_NONE ) && ( before < after ) )
	{
		before_after_valid = false;
	}

	// only perform a query if there potentially valid cue(s)
	if ( ( before_after_valid ) && ( wmes_query || wmes_neg_query ) )
	{
		if ( !prohibit.empty() )
		{
			std::sort( prohibit.begin(), prohibit.end() );
		}

		// perform query
		{
			// queries
			epmem_shared_query_list *queries = new epmem_shared_query_list[2];
			std::list<epmem_shared_literal_pair_list *> trigger_lists;

			// match counters
			std::list<epmem_shared_match *> matches;

			// literals
			std::list<epmem_shared_literal *> literals;

			// pairs
			epmem_shared_literal_pair_list pairs;

			// graph match
			bool graph_match = ( my_agent->epmem_params->graph_match->get_value() ==  soar_module::on );
			epmem_shared_literal_pair_map* gm_pairs = NULL;
			epmem_shared_literal_pair_pair_vector* gm_ordered = NULL;
			if ( graph_match )
			{
				gm_pairs = new epmem_shared_literal_pair_map;
				gm_ordered = new epmem_shared_literal_pair_pair_vector;
			}

			uint64_t leaf_ids[2] = { 0, 0 };

			epmem_time_id time_now = my_agent->epmem_stats->time->get_value() - 1;

			double balance = my_agent->epmem_params->balance->get_value();
			bool balance_approximately_1 = ( ( balance > ( 1.0 - 1.0e-8 ) ) && ( balance < ( 1.0 + 1.0e-8 ) ) );

			////////////////////////////////////////////////////////////////////////////
			my_agent->epmem_timers->query_dnf->start();
			////////////////////////////////////////////////////////////////////////////

			// simultaneously process cue, construct DNF graph, and add queries to priority cue
			// (i.e. prep for range search query)
			{
				// wme cache
				tc_number tc = get_new_tc_number( my_agent );
				std::map<Symbol *, epmem_wme_cache_element *> wme_cache;
				epmem_wme_cache_element *current_cache_element;
				epmem_wme_cache_element **cache_hit;

				// literal mapping
				epmem_literal_mapping::iterator lit_map_p;
				bool shared_cue_id;

				// parent info
				std::queue< wme* > parent_wmes;
				std::queue<Symbol *> parent_syms;
				std::queue<epmem_node_id> parent_ids;
				std::queue<epmem_shared_literal *> parent_literals;

				Symbol *parent_sym;
				wme* parent_wme;
				epmem_node_id parent_id;
				epmem_shared_literal *parent_literal;

				// misc query
				int position;

				// misc
				int i, k, m;
				epmem_wme_list::iterator w_p, w_p2;

				// special variables for LTIs
				epmem_time_id promotion_time = 0;
				soar_module::pooled_sqlite_statement *lti_start_stmt = NULL;

				// associate common literals with a query
				std::map<epmem_node_id, epmem_shared_literal_pair_list *> literal_to_node_query;
				std::map<epmem_node_id, epmem_shared_literal_pair_list *> literal_to_edge_query;
				epmem_shared_literal_pair_list **query_triggers;

				// associate common WMEs with a match
				std::map<wme *, epmem_shared_match *> wme_to_match;
				epmem_shared_match **wme_match;

				// temp new things
				epmem_shared_literal *new_literal = NULL;
				epmem_shared_match *new_match = NULL;
				epmem_shared_query *new_query = NULL;
				epmem_wme_cache_element *new_cache_element = NULL;
				epmem_shared_literal_pair_list *new_trigger_list = NULL;
				soar_module::timer *new_timer = NULL;
				soar_module::pooled_sqlite_statement *new_stmt = NULL;
				epmem_shared_literal_pair *new_literal_pair;
				epmem_shared_incoming_book* new_incoming;
				epmem_shared_incoming_id_book** new_incoming_wme_book;

				// identity (i.e. database id)
				epmem_node_id unique_identity;
				epmem_node_id shared_identity;

				// temporal hashing
				epmem_hash_id my_hash;	// attribute
				epmem_hash_id my_hash2;	// value

				// short- vs. long-term identifiers
				soar_module::sqlite_statement* my_q;
				bool good_q;

				// fully populate wme cache (we need to know parent info a priori)
				{
					epmem_wme_list *starter_wmes = NULL;

					// query
					new_cache_element = new epmem_wme_cache_element;
					new_cache_element->wmes = wmes_query;
					new_cache_element->parents = new epmem_wme_list;
					new_cache_element->lits = new epmem_literal_mapping;
					wme_cache[ query ] = new_cache_element;
					new_cache_element = NULL;

					// negative query
					new_cache_element = new epmem_wme_cache_element;
					new_cache_element->wmes = wmes_neg_query;
					new_cache_element->parents = new epmem_wme_list;
					new_cache_element->lits = new epmem_literal_mapping;
					wme_cache[ neg_query ] = new_cache_element;
					new_cache_element = NULL;

					for ( i=EPMEM_NODE_POS; i<=EPMEM_NODE_NEG; i++ )
					{
						switch ( i )
						{
							case EPMEM_NODE_POS:
								starter_wmes = wmes_query;
								break;

							case EPMEM_NODE_NEG:
								starter_wmes = wmes_neg_query;
								break;
						}

						if ( starter_wmes )
						{
							for ( w_p=starter_wmes->begin(); w_p!=starter_wmes->end(); w_p++ )
							{
								if ( (*w_p)->value->common.symbol_type == IDENTIFIER_SYMBOL_TYPE )
								{
									parent_wmes.push( (*w_p) );
								}
								else
								{
									leaf_ids[i]++;
								}
							}

							while ( !parent_wmes.empty() )
							{
								parent_wme = parent_wmes.front();
								parent_wmes.pop();

								parent_sym = parent_wme->value;

								cache_hit =& wme_cache[ parent_sym ];
								if ( (*cache_hit) )
								{
									(*cache_hit)->parents->push_back( parent_wme );
								}
								else
								{
									new_cache_element = new epmem_wme_cache_element;
									new_cache_element->lits = new epmem_literal_mapping;

									// look at children, if not lti
									if ( !parent_sym->id.smem_lti )
									{
										new_cache_element->wmes = epmem_get_augs_of_id( parent_sym, tc );
									}
									else
									{
										new_cache_element->wmes = new epmem_wme_list;
									}

									// incoming
									{
										new_cache_element->parents = new epmem_wme_list;
										new_cache_element->parents->push_back( parent_wme );
									}

									// add to cache
									wme_cache[ parent_sym ] = new_cache_element;


									if ( new_cache_element->wmes->size() )
									{
										for ( w_p=new_cache_element->wmes->begin(); w_p!=new_cache_element->wmes->end(); w_p++ )
										{
											if ( (*w_p)->value->common.symbol_type == IDENTIFIER_SYMBOL_TYPE )
											{
												parent_wmes.push( (*w_p) );
											}
											else
											{
												leaf_ids[i]++;
											}
										}
									}
									else
									{
										leaf_ids[i]++;
									}

									new_cache_element = NULL;
								}

								cache_hit = NULL;
							}

							parent_sym = NULL;
							parent_wme = NULL;
						}
					}
				}

				// initialize pos/neg lists
				for ( i=EPMEM_NODE_POS; i<=EPMEM_NODE_NEG; i++ )
				{
					switch ( i )
					{
						case EPMEM_NODE_POS:
							parent_syms.push( query );
							parent_ids.push( EPMEM_NODEID_ROOT );
							parent_literals.push( NULL );
							break;

						case EPMEM_NODE_NEG:
							parent_syms.push( neg_query );
							parent_ids.push( EPMEM_NODEID_ROOT );
							parent_literals.push( NULL );
							break;
					}

					while ( !parent_syms.empty() )
					{
						parent_sym = parent_syms.front();
						parent_syms.pop();

						parent_id = parent_ids.front();
						parent_ids.pop();

						parent_literal = parent_literals.front();
						parent_literals.pop();

						current_cache_element = wme_cache[ parent_sym ];

						if ( current_cache_element->wmes )
						{
							for ( w_p=current_cache_element->wmes->begin(); w_p!=current_cache_element->wmes->end(); w_p++ )
							{
								// add to cue list
								cue_wmes.insert( (*w_p) );

								if ( (*w_p)->value->common.symbol_type == IDENTIFIER_SYMBOL_TYPE )
								{
									my_hash = epmem_temporal_hash( my_agent, (*w_p)->attr );
									good_q = false;
									my_q = NULL;

									if ( (*w_p)->value->id.smem_lti )
									{
										my_agent->epmem_stmts_graph->find_lti->bind_int( 1, static_cast<uint64_t>( (*w_p)->value->id.name_letter ) );
										my_agent->epmem_stmts_graph->find_lti->bind_int( 2, static_cast<uint64_t>( (*w_p)->value->id.name_number ) );

										if ( my_agent->epmem_stmts_graph->find_lti->execute() == soar_module::row )
										{
											my_q = my_agent->epmem_stmts_graph->find_edge_unique_shared;
											my_q->bind_int( 3, my_agent->epmem_stmts_graph->find_lti->column_int( 0 ) );

											good_q = true;
										}

										my_agent->epmem_stmts_graph->find_lti->reinitialize();
									}
									else
									{
										my_q = my_agent->epmem_stmts_graph->find_edge_unique;
										good_q = true;
									}

									if ( good_q )
									{
										// q0=? AND w=?
										my_q->bind_int( 1, parent_id );
										my_q->bind_int( 2, my_hash );

										while ( my_q->execute() == soar_module::row )
										{
											// get identity
											unique_identity = my_q->column_int( 0 );
											shared_identity = my_q->column_int( 1 );

											// have we seen this identifier before?
											shared_cue_id = false;
											cache_hit =& wme_cache[ (*w_p)->value ];
											lit_map_p = (*cache_hit)->lits->find( shared_identity );
											shared_cue_id = ( lit_map_p != (*cache_hit)->lits->end() );

											if ( shared_cue_id )
											{
												new_literal = lit_map_p->second;
											}
											else
											{
												// create new literal
												new_literal = new epmem_shared_literal;

												// incoming edges
												{
													new_incoming = new epmem_shared_incoming_book;

													// parents
													{
														new_incoming->parents = new epmem_shared_incoming_ids_book;
														for ( w_p2=(*cache_hit)->parents->begin(); w_p2!=(*cache_hit)->parents->end(); w_p2++ )
														{
															new_incoming_wme_book =& (*new_incoming->parents)[ (*w_p2)->id ];

															if ( !(*new_incoming_wme_book) )
															{
																(*new_incoming_wme_book) = new epmem_shared_incoming_id_book;

																(*new_incoming_wme_book)->outgoing = new epmem_wme_list;
																(*new_incoming_wme_book)->satisfactory = new epmem_shared_literal_set;
															}

															(*new_incoming_wme_book)->outgoing->push_back( (*w_p2) );
														}
													}

													// book
													{
														new_incoming->book = new epmem_shared_incoming_book_map;
													}

													new_literal->incoming = new_incoming;
												}

												new_literal->ct = 0;
												new_literal->max = static_cast<uint64_t>( new_literal->incoming->parents->size() );

												new_literal->shared_id = shared_identity;
												new_literal->shared_sym = (*w_p)->value;

												new_literal->wme_kids = ( (*cache_hit)->wmes->size() != 0 );
												new_literal->children = NULL;

												new_literal->match = NULL;

												literals.push_back( new_literal );
												(*(*cache_hit)->lits)[ shared_identity ] = new_literal;
											}
											cache_hit = NULL;

											new_literal_pair = new epmem_shared_literal_pair;
											new_literal_pair->lit = new_literal;
											new_literal_pair->parent_lit = parent_literal;
											new_literal_pair->unique_id = unique_identity;
											new_literal_pair->q0 = parent_id;
											new_literal_pair->q1 = shared_identity;
											new_literal_pair->wme = (*w_p);
											pairs.push_back( new_literal_pair );

											// add literal to appropriate group
											{
												if ( parent_id != EPMEM_NODEID_ROOT )
												{
													// if this is parent's first child, init
													if ( !parent_literal->children )
													{
														parent_literal->children = new epmem_shared_literal_group;
													}

													epmem_add_literal_to_group( parent_literal->children, new_literal_pair );
												}
											}

											// create queries if necessary
											query_triggers =& literal_to_edge_query[ unique_identity ];
											if ( !(*query_triggers) )
											{
												new_trigger_list = new epmem_shared_literal_pair_list;
												trigger_lists.push_back( new_trigger_list );

												// find the promotion time for an LTI
												promotion_time = 0;
												if ( (*w_p)->value->id.smem_lti )
												{
													// get the promotion time of the LTI
													my_agent->epmem_stmts_graph->find_lti_promotion_time->bind_int( 1, static_cast<uint64_t>( (*w_p)->value->id.name_letter ) );
													my_agent->epmem_stmts_graph->find_lti_promotion_time->bind_int( 2, static_cast<uint64_t>( (*w_p)->value->id.name_number ) );
													my_agent->epmem_stmts_graph->find_lti_promotion_time->execute();
													promotion_time = my_agent->epmem_stmts_graph->find_lti_promotion_time->column_int( 0 );
													my_agent->epmem_stmts_graph->find_lti_promotion_time->reinitialize();
												}

												// add all respective queries
												for ( k=EPMEM_RANGE_START; k<=EPMEM_RANGE_END; k++ )
												{
													for( m=EPMEM_RANGE_EP; m<=EPMEM_RANGE_POINT; m++ )
													{
														// assign timer
														switch ( m )
														{
															case EPMEM_RANGE_EP:
																new_timer = ( ( i == EPMEM_NODE_POS )?( ( k == EPMEM_RANGE_START )?( my_agent->epmem_timers->query_pos_start_ep ):( my_agent->epmem_timers->query_pos_end_ep ) ):( ( k == EPMEM_RANGE_START )?( my_agent->epmem_timers->query_neg_start_ep ):( my_agent->epmem_timers->query_neg_end_ep ) ) );
																break;

															case EPMEM_RANGE_NOW:
																new_timer = ( ( i == EPMEM_NODE_POS )?( ( k == EPMEM_RANGE_START )?( my_agent->epmem_timers->query_pos_start_now ):( my_agent->epmem_timers->query_pos_end_now ) ):( ( k == EPMEM_RANGE_START )?( my_agent->epmem_timers->query_neg_start_now ):( my_agent->epmem_timers->query_neg_end_now ) ) );
																break;

															case EPMEM_RANGE_POINT:
																new_timer = ( ( i == EPMEM_NODE_POS )?( ( k == EPMEM_RANGE_START )?( my_agent->epmem_timers->query_pos_start_point ):( my_agent->epmem_timers->query_pos_end_point ) ):( ( k == EPMEM_RANGE_START )?( my_agent->epmem_timers->query_neg_start_point ):( my_agent->epmem_timers->query_neg_end_point ) ) );
																break;
														}

														// bind values
														position = 1;

														// assign sql
														// check for LTI and use special SQL commands
														if ( promotion_time > 0 )
														{
															new_stmt = my_agent->epmem_stmts_graph->pool_range_lti_queries[ k ][ m ]->request( new_timer );
															new_stmt->prepare();

															// add special query for promotion start point to query list (if start)
															if ( k == EPMEM_RANGE_START )
															{
																lti_start_stmt = my_agent->epmem_stmts_graph->pool_range_lti_start->request( new_timer );
																lti_start_stmt->prepare();
																assert( lti_start_stmt->get_status() == soar_module::ready );
																lti_start_stmt->bind_int( 1, promotion_time );
																lti_start_stmt->execute();
																new_query = new epmem_shared_query;
																new_query->val = lti_start_stmt->column_int( 0 );
																new_query->stmt = lti_start_stmt;
																new_query->unique_id = unique_identity;
																new_query->triggers = new_trigger_list;
																queries[ k ].push( new_query );
																new_query = NULL;
																lti_start_stmt = NULL;
															}
														}
														else
														{
															new_stmt = my_agent->epmem_stmts_graph->pool_range_queries[ EPMEM_RIT_STATE_EDGE ][ k ][ m ]->request( new_timer );
															new_stmt->prepare();
														}
														assert( new_stmt->get_status() == soar_module::ready );

														if ( ( m == EPMEM_RANGE_NOW ) && ( k == EPMEM_RANGE_END ) )
														{
															new_stmt->bind_int( position++, time_now );
														}
														if ( (promotion_time > 0) && ( ( k != EPMEM_RANGE_END ) || ( m == EPMEM_RANGE_EP ) ) )
														{
															new_stmt->bind_int( position++, promotion_time );
														}
														new_stmt->bind_int( position, unique_identity );

														// take first step
														if ( new_stmt->execute() == soar_module::row )
														{
															new_query = new epmem_shared_query;
															new_query->val = new_stmt->column_int( 0 );
															new_query->stmt = new_stmt;

															new_query->unique_id = unique_identity;

															new_query->triggers = new_trigger_list;

															// add to query list
															queries[ k ].push( new_query );
															new_query = NULL;
														}
														else
														{
															new_stmt->get_pool()->release( new_stmt );
														}

														new_stmt = NULL;
														new_timer = NULL;
													}
												}

												(*query_triggers) = new_trigger_list;
												new_trigger_list = NULL;
											}
											(*query_triggers)->push_back( new_literal_pair );

											if ( !shared_cue_id )
											{
												if ( new_literal->wme_kids )
												{
													parent_syms.push( (*w_p)->value );
													parent_ids.push( shared_identity );
													parent_literals.push( new_literal );
												}
												else
												{
													// create match if necessary
													wme_match =& wme_to_match[ (*w_p) ];
													if ( !(*wme_match) )
													{
														new_match = new epmem_shared_match;
														matches.push_back( new_match );
														new_match->ct = 0;
														new_match->value_ct = ( ( i == EPMEM_NODE_POS )?( 1 ):( -1 ) );
														new_match->value_weight = ( ( i == EPMEM_NODE_POS )?( 1 ):( -1 ) ) * ( ( balance_approximately_1 )?( WMA_ACTIVATION_NONE ):( wma_get_wme_activation( my_agent, (*w_p), true ) ) );

														(*wme_match) = new_match;
														new_match = NULL;
													}
													new_literal->match = (*wme_match);
												}
											}

											new_literal = NULL;
										}
										my_q->reinitialize();
									}
								}
								else
								{
									my_hash = epmem_temporal_hash( my_agent, (*w_p)->attr );
									my_hash2 = epmem_temporal_hash( my_agent, (*w_p)->value );

									// parent_id=? AND attr=? AND value=?
									my_agent->epmem_stmts_graph->find_node_unique->bind_int( 1, parent_id );
									my_agent->epmem_stmts_graph->find_node_unique->bind_int( 2, my_hash );
									my_agent->epmem_stmts_graph->find_node_unique->bind_int( 3, my_hash2 );

									if ( my_agent->epmem_stmts_graph->find_node_unique->execute() == soar_module::row )
									{
										// get identity
										unique_identity = my_agent->epmem_stmts_graph->find_node_unique->column_int( 0 );

										// create new literal
										new_literal = new epmem_shared_literal;

										new_literal->ct = 0;
										new_literal->max = EPMEM_DNF;
										new_literal->incoming = NULL;

										new_literal->shared_id = EPMEM_NODEID_ROOT;
										new_literal->shared_sym = NULL;

										new_literal->wme_kids = 0;
										new_literal->children = NULL;

										literals.push_back( new_literal );

										new_literal_pair = new epmem_shared_literal_pair;
										new_literal_pair->lit = new_literal;
										new_literal_pair->parent_lit = parent_literal;
										new_literal_pair->unique_id = unique_identity;
										new_literal_pair->q0 = parent_id;
										new_literal_pair->q1 = 0;
										new_literal_pair->wme = (*w_p);
										pairs.push_back( new_literal_pair );

										// add to appropriate group
										{
											if ( parent_id == EPMEM_NODEID_ROOT )
											{
												new_literal->ct++;
											}
											else
											{
												// if this is parent's first child, init
												if ( !parent_literal->children )
												{
													parent_literal->children = new epmem_shared_literal_group;
												}

												epmem_add_literal_to_group( parent_literal->children, new_literal_pair );
											}
										}

										// create match if necessary
										wme_match =& wme_to_match[ (*w_p) ];
										if ( !(*wme_match) )
										{
											new_match = new epmem_shared_match;
											matches.push_back( new_match );
											new_match->ct = 0;
											new_match->value_ct = ( ( i == EPMEM_NODE_POS )?( 1 ):( -1 ) );
											new_match->value_weight = ( ( i == EPMEM_NODE_POS )?( 1 ):( -1 ) ) * ( ( balance_approximately_1 )?( WMA_ACTIVATION_NONE ):( wma_get_wme_activation( my_agent, (*w_p), true ) ) );

											(*wme_match) = new_match;
											new_match = NULL;
										}
										new_literal->match = (*wme_match);

										// create queries if necessary
										query_triggers =& literal_to_node_query[ unique_identity ];
										if ( !(*query_triggers) )
										{
											new_trigger_list = new epmem_shared_literal_pair_list;
											trigger_lists.push_back( new_trigger_list );

											// add all respective queries
											for ( k=EPMEM_RANGE_START; k<=EPMEM_RANGE_END; k++ )
											{
												for( m=EPMEM_RANGE_EP; m<=EPMEM_RANGE_POINT; m++ )
												{
													// assign timer
													switch ( m )
													{
														case EPMEM_RANGE_EP:
															new_timer = ( ( i == EPMEM_NODE_POS )?( ( k == EPMEM_RANGE_START )?( my_agent->epmem_timers->query_pos_start_ep ):( my_agent->epmem_timers->query_pos_end_ep ) ):( ( k == EPMEM_RANGE_START )?( my_agent->epmem_timers->query_neg_start_ep ):( my_agent->epmem_timers->query_neg_end_ep ) ) );
															break;

														case EPMEM_RANGE_NOW:
															new_timer = ( ( i == EPMEM_NODE_POS )?( ( k == EPMEM_RANGE_START )?( my_agent->epmem_timers->query_pos_start_now ):( my_agent->epmem_timers->query_pos_end_now ) ):( ( k == EPMEM_RANGE_START )?( my_agent->epmem_timers->query_neg_start_now ):( my_agent->epmem_timers->query_neg_end_now ) ) );
															break;

														case EPMEM_RANGE_POINT:
															new_timer = ( ( i == EPMEM_NODE_POS )?( ( k == EPMEM_RANGE_START )?( my_agent->epmem_timers->query_pos_start_point ):( my_agent->epmem_timers->query_pos_end_point ) ):( ( k == EPMEM_RANGE_START )?( my_agent->epmem_timers->query_neg_start_point ):( my_agent->epmem_timers->query_neg_end_point ) ) );
															break;
													}

													// assign sql
													new_stmt = my_agent->epmem_stmts_graph->pool_range_queries[ EPMEM_RIT_STATE_NODE ][ k ][ m ]->request( new_timer );
													new_stmt->prepare();

													// bind values
													position = 1;

													if ( ( m == EPMEM_RANGE_NOW ) && ( k == EPMEM_RANGE_END ) )
													{
														new_stmt->bind_int( position++, time_now );
													}
													new_stmt->bind_int( position, unique_identity );

													// take first step
													if ( new_stmt->execute() == soar_module::row )
													{
														new_query = new epmem_shared_query;
														new_query->val = new_stmt->column_int( 0 );
														new_query->stmt = new_stmt;

														new_query->unique_id = unique_identity;

														new_query->triggers = new_trigger_list;

														// add to query list
														queries[ k ].push( new_query );
														new_query = NULL;
													}
													else
													{
														new_stmt->get_pool()->release( new_stmt );
													}

													new_stmt = NULL;
													new_timer = NULL;
												}
											}

											(*query_triggers) = new_trigger_list;
											new_trigger_list = NULL;
										}
										(*query_triggers)->push_back( new_literal_pair );

										new_literal = NULL;
									}
									my_agent->epmem_stmts_graph->find_node_unique->reinitialize();
								}
							}
						}
					}

					if ( i == EPMEM_NODE_POS )
					{
						if ( graph_match )
						{
							epmem_shared_literal_pair_list::iterator pairs_p;
							epmem_shared_literal_pair_list** new_pair_list;

							for ( pairs_p=pairs.begin(); pairs_p!=pairs.end(); pairs_p++ )
							{
								new_pair_list =& (*gm_pairs)[ (*pairs_p)->wme ];

								if ( !(*new_pair_list) )
								{
									(*new_pair_list) = new epmem_shared_literal_pair_list;
								}

								(*new_pair_list)->push_back( (*pairs_p) );
							}
						}
					}
				}

				// clean up wme cache
				{
					std::map<Symbol *, epmem_wme_cache_element *>::iterator cache_p;
					for ( cache_p=wme_cache.begin(); cache_p!=wme_cache.end(); cache_p++ )
					{
						if ( cache_p->second->wmes )
						{
							delete cache_p->second->wmes;
						}

						delete cache_p->second->lits;
						delete cache_p->second->parents;

						delete cache_p->second;
					}
				}
			}

			////////////////////////////////////////////////////////////////////////////
			my_agent->epmem_timers->query_dnf->stop();
			////////////////////////////////////////////////////////////////////////////

			my_agent->epmem_stats->qry_pos->set_value( leaf_ids[ EPMEM_NODE_POS ] );
			my_agent->epmem_stats->qry_neg->set_value( leaf_ids[ EPMEM_NODE_NEG ] );
			my_agent->epmem_stats->qry_ret->set_value( 0 );
			my_agent->epmem_stats->qry_card->set_value( 0 );
			my_agent->epmem_stats->qry_lits->set_value( static_cast<int64_t>( literals.size() ) );

			// useful statistics
			int64_t cue_size = static_cast<int64_t>( leaf_ids[ EPMEM_NODE_POS ] + leaf_ids[ EPMEM_NODE_NEG ] );
			uint64_t perfect_match = leaf_ids[ EPMEM_NODE_POS ];

			// vars to set in range search
			epmem_time_id king_id = EPMEM_MEMID_NONE;
			double king_score = -1000;
			uint64_t king_cardinality = 0;
			bool king_graph_match = false;
			epmem_gm_assignment_map king_assignments;

#ifdef EPMEM_EXPERIMENT
			epmem_episodes_searched = 0;
#endif

			// perform range search if any leaf wmes
			if ( ( level > 1 ) && cue_size && !matches.empty() )
			{
				double balance_inv = 1 - balance;

				// dynamic programming stuff
				int64_t sum_ct = 0;
				double sum_v = 0;
				int64_t sum_updown = 0;

				// current pointer
				epmem_time_id current_id = EPMEM_MEMID_NONE;
				int64_t current_ct = 0;
				double current_v = 0;
				int64_t current_updown = 0;
				epmem_time_id current_end;
				epmem_time_id current_valid_end;
				double current_score;

				// next pointers
				epmem_time_id start_id = EPMEM_MEMID_NONE;
				epmem_time_id end_id = EPMEM_MEMID_NONE;
				epmem_time_id *next_id;
				unsigned int next_list = NIL;

				// prohibit pointer
				epmem_time_list::size_type current_prohibit = ( prohibit.size() - 1 );

				// completion (allows for smart cut-offs later)
				bool done = false;

				// graph match
				bool graph_match_result = false;
				epmem_gm_assignment_map current_assignments;
				epmem_shared_literal_set current_used_ids;
				epmem_gm_sym_constraints current_sym_constraints;

				// initialize current as last end
				// initialize next end
				epmem_shared_increment( queries, current_id, current_ct, current_v, current_updown, EPMEM_RANGE_END );
				end_id = ( ( queries[ EPMEM_RANGE_END ].empty() )?( EPMEM_MEMID_NONE ):( queries[ EPMEM_RANGE_END ].top()->val ) );

				// initialize next start
				start_id = ( ( queries[ EPMEM_RANGE_START ].empty() )?( EPMEM_MEMID_NONE ):( queries[ EPMEM_RANGE_START ].top()->val ) );

				do
				{
					// if both lists are finished, we are done
					if ( ( start_id == EPMEM_MEMID_NONE ) && ( end_id == EPMEM_MEMID_NONE ) )
					{
						done = true;
					}
					// if we are beyond a specified after, we are done
					else if ( ( after != EPMEM_MEMID_NONE ) && ( current_id <= after ) )
					{
						done = true;
					}
					// if one list finished, go to the other
					else if ( ( start_id == EPMEM_MEMID_NONE ) || ( end_id == EPMEM_MEMID_NONE ) )
					{
						next_list = ( ( start_id == EPMEM_MEMID_NONE )?( EPMEM_RANGE_END ):( EPMEM_RANGE_START ) );
					}
					// if neither list finished, we prefer the higher id (end in case of tie)
					else
					{
						next_list = ( ( start_id > end_id )?( EPMEM_RANGE_START ):( EPMEM_RANGE_END ) );
					}

					if ( !done )
					{
						// update sums
						sum_ct += current_ct;
						sum_v += current_v;
						sum_updown += current_updown;

						// update end
						current_end = ( ( next_list == EPMEM_RANGE_END )?( end_id + 1 ):( start_id ) );
						if ( before == EPMEM_MEMID_NONE )
						{
							current_valid_end = current_id;
						}
						else
						{
							current_valid_end = ( ( current_id < before )?( current_id ):( before - 1 ) );
						}

						while ( ( current_prohibit < prohibit.size() ) && ( current_valid_end >= current_end ) && ( current_valid_end <= prohibit[ current_prohibit ] ) )
						{
							if ( current_valid_end == prohibit[ current_prohibit ] )
							{
								current_valid_end--;
							}

							current_prohibit--;
						}

						// if we are beyond before AND
						// we are in a range, compute score
						// for possible new king
						if ( ( current_valid_end >= current_end ) && ( sum_updown != 0 ) )
						{
							current_score = ( balance * sum_ct ) + ( balance_inv * sum_v );

							// provide trace output
							if ( my_agent->sysparams[ TRACE_EPMEM_SYSPARAM ] )
							{
								char buf[256];

								SNPRINTF( buf, 254, "CONSIDERING EPISODE (time, cardinality, score): (%lld, %ld, %f)", static_cast<long long int>(current_valid_end), static_cast<long int>(sum_ct), current_score );

								print( my_agent, buf );
								xml_generate_warning( my_agent, buf );
							}

#ifdef EPMEM_EXPERIMENT
							epmem_episodes_searched++;
#endif

							if ( graph_match )
							{
								// policy:
								// - king candidate MUST have AT LEAST king score
								// - perform graph match ONLY if cardinality is perfect
								// - ONLY stop if graph match is perfect

								if ( ( king_id == EPMEM_MEMID_NONE ) || ( current_score >= king_score ) )
								{
									if ( sum_ct == static_cast<int64_t>( perfect_match ) )
									{
										current_assignments.clear();
										current_assignments.insert( std::make_pair( query, EPMEM_NODEID_ROOT ) );

										current_used_ids.clear();
										current_used_ids.insert( EPMEM_NODEID_ROOT );

										current_sym_constraints.clear();

										////////////////////////////////////////////////////////////////////////////
										my_agent->epmem_timers->query_graph_match->start();
										////////////////////////////////////////////////////////////////////////////

										if ( gm_ordered->size() != gm_pairs->size() )
										{
											epmem_param_container::gm_ordering_choices gm_ordering = my_agent->epmem_params->gm_ordering->get_value();
											epmem_shared_literal_pair_map::iterator it;

											if ( ( gm_ordering == epmem_param_container::gm_order_undefined ) ||
													( gm_ordering == epmem_param_container::gm_order_mcv ) )
											{
												for ( it=gm_pairs->begin(); it!=gm_pairs->end(); it++ )
												{
													gm_ordered->push_back( (*it) );
												}

												if ( gm_ordering == epmem_param_container::gm_order_mcv )
												{
													std::sort( gm_ordered->begin(), gm_ordered->end(), _epmem_gm_compare_mcv );
												}
											}
											else if ( gm_ordering == epmem_param_container::gm_order_dfs )
											{
												// sort wmes
												std::list< wme* > ordered_cue;
												_epmem_gm_sort_wmes_dfs( query, get_new_tc_number( my_agent ), ordered_cue );

												// add the pairs in order
												epmem_shared_literal_pair_map::iterator pair_it;
												for ( std::list< wme* >::iterator oc_it=ordered_cue.begin(); oc_it!=ordered_cue.end(); oc_it++ )
												{
													pair_it = gm_pairs->find( (*oc_it) );
													assert( pair_it != gm_pairs->end() );

													gm_ordered->push_back( (*pair_it) );
												}
											}
										}

										graph_match_result = epmem_graph_match( gm_ordered, &( current_assignments ), &( current_used_ids ), &( current_sym_constraints ) );

										////////////////////////////////////////////////////////////////////////////
										my_agent->epmem_timers->query_graph_match->stop();
										////////////////////////////////////////////////////////////////////////////

										if ( ( king_id == EPMEM_MEMID_NONE ) ||
												( current_score > king_score ) ||
												( graph_match_result ) )
										{
											king_id = current_valid_end;
											king_score = current_score;
											king_cardinality = sum_ct;
											king_assignments = current_assignments;

											if ( graph_match_result )
											{
												king_graph_match = true;
												done = true;
											}

											// provide trace output
											if ( my_agent->sysparams[ TRACE_EPMEM_SYSPARAM ] )
											{
												char buf[256];
												SNPRINTF( buf, 254, "NEW KING (perfect, graph-match): (true, %s)", ( ( king_graph_match )?("true"):("false") ) );

												print( my_agent, buf );
												xml_generate_warning( my_agent, buf );
											}
										}
									}
									else
									{
										if ( ( king_id == EPMEM_MEMID_NONE ) || ( current_score > king_score ) )
										{
											king_id = current_valid_end;
											king_score = current_score;
											king_cardinality = sum_ct;

											// provide trace output
											if ( my_agent->sysparams[ TRACE_EPMEM_SYSPARAM ] )
											{
												char buf[256];
												SNPRINTF( buf, 254, "NEW KING (perfect, graph-match): (false, false)" );

												print( my_agent, buf );
												xml_generate_warning( my_agent, buf );
											}
										}
									}
								}
							}
							else
							{
								// new king if no old king OR better score
								if ( ( king_id == EPMEM_MEMID_NONE ) || ( current_score > king_score ) )
								{
									king_id = current_valid_end;
									king_score = current_score;
									king_cardinality = sum_ct;

									// provide trace output
									if ( my_agent->sysparams[ TRACE_EPMEM_SYSPARAM ] )
									{
										char buf[256];
										SNPRINTF( buf, 254, "NEW KING (perfect): (%s)", ( ( king_cardinality == perfect_match )?("true"):("false") ) );

										print( my_agent, buf );
										xml_generate_warning( my_agent, buf );
									}

									if ( king_cardinality == perfect_match )
									{
										done = true;
									}
								}
							}
						}

						if ( !done )
						{
							// based upon choice, update variables
							epmem_shared_increment( queries, current_id, current_ct, current_v, current_updown, next_list );
							current_id = current_end - 1;
							current_ct *= ( ( next_list == EPMEM_RANGE_START )?( -1 ):( 1 ) );
							current_v *= ( ( next_list == EPMEM_RANGE_START )?( -1 ):( 1 ) );

							next_id = ( ( next_list == EPMEM_RANGE_START )?( &start_id ):( &end_id ) );
							(*next_id) = ( ( queries[ next_list ].empty() )?( EPMEM_MEMID_NONE ):( queries[ next_list ].top()->val ) );
						}
					}

				} while ( !done );
			}

			// clean up
			{
				int i;

				// pairs
				epmem_shared_literal_pair_list::iterator pair_p;
				for ( pair_p=pairs.begin(); pair_p!=pairs.end(); pair_p++ )
				{
					delete (*pair_p);
				}

				// literals
				std::list<epmem_shared_literal *>::iterator literal_p;
				epmem_shared_incoming_ids_book::iterator incoming_id_p;
				epmem_shared_incoming_book_map::iterator incoming_book_p;
				epmem_shared_incoming_wme_map::iterator incoming_wme_p;
				for ( literal_p=literals.begin(); literal_p!=literals.end(); literal_p++ )
				{
					if ( (*literal_p)->children )
					{
						epmem_clear_literal_group( (*literal_p)->children );

						delete (*literal_p)->children;
					}

					if ( (*literal_p)->incoming )
					{
						// parents
						{
							for ( incoming_id_p=(*literal_p)->incoming->parents->begin(); incoming_id_p!=(*literal_p)->incoming->parents->end(); incoming_id_p++ )
							{
								delete incoming_id_p->second->outgoing;
								delete incoming_id_p->second->satisfactory;

								delete incoming_id_p->second;
							}
							delete (*literal_p)->incoming->parents;
						}

						// book
						{
							for ( incoming_book_p=(*literal_p)->incoming->book->begin(); incoming_book_p!=(*literal_p)->incoming->book->end(); incoming_book_p++ )
							{
								for ( incoming_wme_p=incoming_book_p->second->begin(); incoming_wme_p!=incoming_book_p->second->end(); incoming_wme_p++ )
								{
									delete incoming_wme_p->second->cts;

									delete incoming_wme_p->second;
								}

								delete incoming_book_p->second;
							}
							delete (*literal_p)->incoming->book;
						}

						delete (*literal_p)->incoming;
					}

					delete (*literal_p);
				}

				// matches
				std::list<epmem_shared_match *>::iterator match_p;
				for ( match_p=matches.begin(); match_p!=matches.end(); match_p++ )
				{
					delete (*match_p);
				}

				// trigger lists
				std::list<epmem_shared_literal_pair_list *>::iterator trigger_list_p;
				for ( trigger_list_p=trigger_lists.begin(); trigger_list_p!=trigger_lists.end(); trigger_list_p++ )
				{
					delete (*trigger_list_p);
				}

				// queries
				epmem_shared_query *del_query;
				for ( i=EPMEM_NODE_POS; i<=EPMEM_NODE_NEG; i++ )
				{
					while ( !queries[ i ].empty() )
					{
						del_query = queries[ i ].top();
						queries[ i ].pop();

						del_query->stmt->get_pool()->release( del_query->stmt );

						delete del_query;
					}
				}
				delete [] queries;

				// graph match
				if ( graph_match )
				{
					for ( epmem_shared_literal_pair_map::iterator gm_p=gm_pairs->begin(); gm_p!=gm_pairs->end(); gm_p++ )
					{
						delete gm_p->second;
						gm_p->second = NULL;
					}
					gm_pairs->clear();
					delete gm_pairs;

					delete gm_ordered;
				}
			}

			// place results in WM
			if ( king_id != EPMEM_MEMID_NONE )
			{
				Symbol *my_meta;
				epmem_id_mapping *my_mapping = NULL;
				epmem_id_mapping *my_mapping_nodes = NULL;

				my_agent->epmem_stats->qry_ret->set_value( king_id );
				my_agent->epmem_stats->qry_card->set_value( king_cardinality );

				// status
				epmem_buffer_add_wme( meta_wmes, state->id.epmem_result_header, my_agent->epmem_sym_success, query );

				if ( neg_query )
				{
					epmem_buffer_add_wme( meta_wmes, state->id.epmem_result_header, my_agent->epmem_sym_success, neg_query );
				}

				// match score
				my_meta = make_float_constant( my_agent, king_score );
				epmem_buffer_add_wme( meta_wmes, state->id.epmem_result_header, my_agent->epmem_sym_match_score, my_meta );
				symbol_remove_ref( my_agent, my_meta );

				// cue-size
				my_meta = make_int_constant( my_agent, cue_size );
				epmem_buffer_add_wme( meta_wmes, state->id.epmem_result_header, my_agent->epmem_sym_cue_size, my_meta );
				symbol_remove_ref( my_agent, my_meta );

				// normalized-match-score
				my_meta = make_float_constant( my_agent, ( king_score / perfect_match ) );
				epmem_buffer_add_wme( meta_wmes, state->id.epmem_result_header, my_agent->epmem_sym_normalized_match_score, my_meta );
				symbol_remove_ref( my_agent, my_meta );

				// match-cardinality
				my_meta = make_int_constant( my_agent, king_cardinality );
				epmem_buffer_add_wme( meta_wmes, state->id.epmem_result_header, my_agent->epmem_sym_match_cardinality, my_meta );
				symbol_remove_ref( my_agent, my_meta );

				// graph match
				if ( graph_match )
				{
					// graph-match 0/1
					my_meta = make_int_constant( my_agent, ( ( king_graph_match )?(1):(0) ) );
					epmem_buffer_add_wme( meta_wmes, state->id.epmem_result_header, my_agent->epmem_sym_graph_match, my_meta );
					symbol_remove_ref( my_agent, my_meta );

					// full mapping if appropriate
					if ( king_graph_match )
					{
						Symbol *my_meta2;
						epmem_id_mapping::iterator idm_p;

						my_meta = make_new_identifier( my_agent, 'M', state->id.epmem_result_header->id.level );
						epmem_buffer_add_wme( meta_wmes, state->id.epmem_result_header, my_agent->epmem_sym_graph_match_mapping, my_meta );
						symbol_remove_ref( my_agent, my_meta );

						my_mapping = new epmem_id_mapping;
						my_mapping_nodes = new epmem_id_mapping;
						for ( epmem_gm_assignment_map::iterator c_p=king_assignments.begin(); c_p!=king_assignments.end(); c_p++ )
						{
							// create the node
							my_meta2 = make_new_identifier( my_agent, 'N', my_meta->id.level );
							epmem_buffer_add_wme( meta_wmes, my_meta, my_agent->epmem_sym_graph_match_mapping_node, my_meta2 );
							symbol_remove_ref( my_agent, my_meta2 );

							// point to the cue identifier
							epmem_buffer_add_wme( meta_wmes, my_meta2, my_agent->epmem_sym_graph_match_mapping_cue, c_p->first );

							// keep a reference to the node
							(*my_mapping_nodes)[ c_p->second ] = my_meta2;

							// make a spot for the retrieved identifier
							(*my_mapping)[ c_p->second ] = NULL;
						}
					}
				}

				////////////////////////////////////////////////////////////////////////////
				my_agent->epmem_timers->query->stop();
				////////////////////////////////////////////////////////////////////////////

				// actual memory
				if ( level > 2 )
				{
					epmem_install_memory( my_agent, state, king_id, meta_wmes, retrieval_wmes, my_mapping );
				}

				if ( my_mapping )
				{
					epmem_id_mapping::iterator id_p, node_p;

					for ( id_p=my_mapping->begin(); id_p!=my_mapping->end(); id_p++ )
					{
						if ( id_p->second )
						{
							node_p = my_mapping_nodes->find( id_p->first );
							if ( node_p != my_mapping_nodes->end() )
							{
								epmem_buffer_add_wme( meta_wmes, node_p->second, my_agent->epmem_sym_retrieved, id_p->second );
							}
						}
					}

					delete my_mapping;
					delete my_mapping_nodes;
				}
			}
			else
			{
				epmem_buffer_add_wme( meta_wmes, state->id.epmem_result_header, my_agent->epmem_sym_failure, query );

				if ( neg_query )
				{
					epmem_buffer_add_wme( meta_wmes, state->id.epmem_result_header, my_agent->epmem_sym_failure, neg_query );
				}

				////////////////////////////////////////////////////////////////////////////
				my_agent->epmem_timers->query->stop();
				////////////////////////////////////////////////////////////////////////////
			}
		}
	}
	else
	{
		epmem_buffer_add_wme( meta_wmes, state->id.epmem_result_header, my_agent->epmem_sym_status, my_agent->epmem_sym_bad_cmd );

		//

		if ( wmes_query )
		{
			delete wmes_query;
		}

		if ( wmes_neg_query )
		{
			delete wmes_neg_query;
		}

		////////////////////////////////////////////////////////////////////////////
		my_agent->epmem_timers->query->stop();
		////////////////////////////////////////////////////////////////////////////
	}
}


//////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////
// Visualization (epmem::viz)
//////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////

inline std::string _epmem_print_sti( epmem_node_id id )
{
	std::string t1, t2;

	t1.assign( "<id" );

	to_string( id, t2 );
	t1.append( t2 );
	t1.append( ">" );

	return t1;
}

void epmem_print_episode( agent* my_agent, epmem_time_id memory_id, std::string* buf )
{
	// if this is before the first episode, initialize db components
	if ( my_agent->epmem_db->get_status() == soar_module::disconnected )
	{
		epmem_init_db( my_agent );
	}

	// if bad memory, bail
	buf->clear();
	if ( ( memory_id == EPMEM_MEMID_NONE ) ||
			!epmem_valid_episode( my_agent, memory_id ) )
	{
		return;
	}

	// fill episode map
	std::map< epmem_node_id, std::string > ltis;
	std::map< epmem_node_id, std::map< std::string, std::list< std::string > > > ep;
	{
		soar_module::sqlite_statement *my_q;
		std::string temp_s, temp_s2, temp_s3;
		double temp_d;
		int64_t temp_i;

		my_q = my_agent->epmem_stmts_graph->get_edges;
		{
			epmem_node_id q0;
			epmem_node_id q1;
			int64_t w_type;
			bool val_is_short_term;

			epmem_rit_prep_left_right( my_agent, memory_id, memory_id, &( my_agent->epmem_rit_state_graph[ EPMEM_RIT_STATE_EDGE ] ) );

			// query for edges
			my_q->bind_int( 1, memory_id );
			my_q->bind_int( 2, memory_id );
			my_q->bind_int( 3, memory_id );
			my_q->bind_int( 4, memory_id );
			my_q->bind_int( 5, memory_id );
			while ( my_q->execute() == soar_module::row )
			{
				q0 = my_q->column_int( 0 );
				q1 = my_q->column_int( 2 );
				w_type = my_q->column_int( 3 );
				val_is_short_term = ( my_q->column_type( 4 ) == soar_module::null_t );

				switch ( w_type )
				{
					case INT_CONSTANT_SYMBOL_TYPE:
						temp_i = static_cast<int64_t>( my_q->column_int( 1 ) );
						to_string( temp_i, temp_s );
						break;

					case FLOAT_CONSTANT_SYMBOL_TYPE:
						temp_d = my_q->column_double( 1 );
						to_string( temp_d, temp_s );
						break;

					case SYM_CONSTANT_SYMBOL_TYPE:
						temp_s.assign( const_cast<char *>( reinterpret_cast<const char *>( my_q->column_text( 1 ) ) ) );
						break;
				}

				if ( val_is_short_term )
				{
					temp_s2 = _epmem_print_sti( q1 );
				}
				else
				{
					temp_s2.assign( "@" );
					temp_s2.push_back( static_cast< char >( my_q->column_int( 4 ) ) );

					temp_i = static_cast< uint64_t >( my_q->column_int( 5 ) );
					to_string( temp_i, temp_s3 );
					temp_s2.append( temp_s3 );

					ltis[ q1 ] = temp_s2;
				}

				ep[ q0 ][ temp_s ].push_back( temp_s2 );
			}
			my_q->reinitialize();
			epmem_rit_clear_left_right( my_agent );
		}

		my_q = my_agent->epmem_stmts_graph->get_nodes;
		{
			epmem_node_id parent_id;
			int64_t attr_type, value_type;

			epmem_rit_prep_left_right( my_agent, memory_id, memory_id, &( my_agent->epmem_rit_state_graph[ EPMEM_RIT_STATE_NODE ] ) );

			my_q->bind_int( 1, memory_id );
			my_q->bind_int( 2, memory_id );
			my_q->bind_int( 3, memory_id );
			my_q->bind_int( 4, memory_id );
			while ( my_q->execute() == soar_module::row )
			{
				parent_id = my_q->column_int( 1 );
				attr_type = my_q->column_int( 4 );
				value_type = my_q->column_int( 5 );

				switch ( attr_type )
				{
					case INT_CONSTANT_SYMBOL_TYPE:
						temp_i = static_cast<int64_t>( my_q->column_int( 2 ) );
						to_string( temp_i, temp_s );
						break;

					case FLOAT_CONSTANT_SYMBOL_TYPE:
						temp_d = my_q->column_double( 2 );
						to_string( temp_d, temp_s );
						break;

					case SYM_CONSTANT_SYMBOL_TYPE:
						temp_s.assign( const_cast<char *>( reinterpret_cast<const char *>( my_q->column_text( 2 ) ) ) );
						break;
				}

				switch ( value_type )
				{
					case INT_CONSTANT_SYMBOL_TYPE:
						temp_i = static_cast<int64_t>( my_q->column_int( 3 ) );
						to_string( temp_i, temp_s2 );
						break;

					case FLOAT_CONSTANT_SYMBOL_TYPE:
						temp_d = my_q->column_double( 3 );
						to_string( temp_d, temp_s2 );
						break;

					case SYM_CONSTANT_SYMBOL_TYPE:
						temp_s2.assign( const_cast<char *>( reinterpret_cast<const char *>( my_q->column_text( 3 ) ) ) );
						break;
				}

				ep[ parent_id ][ temp_s ].push_back( temp_s2 );
			}
			my_q->reinitialize();
			epmem_rit_clear_left_right( my_agent );
		}
	}

	// output
	{
		std::map< epmem_node_id, std::string >::iterator lti_it;
		std::map< epmem_node_id, std::map< std::string, std::list< std::string > > >::iterator ep_it;
		std::map< std::string, std::list< std::string > >::iterator slot_it;
		std::list< std::string >::iterator val_it;

		for ( ep_it=ep.begin(); ep_it!=ep.end(); ep_it++ )
		{
			buf->append( "(" );

			// id
			lti_it = ltis.find( ep_it->first );
			if ( lti_it == ltis.end() )
			{
				buf->append( _epmem_print_sti( ep_it->first ) );
			}
			else
			{
				buf->append( lti_it->second );
			}

			// attr
			for ( slot_it=ep_it->second.begin(); slot_it!=ep_it->second.end(); slot_it++ )
			{
				buf->append( " ^" );
				buf->append( slot_it->first );

				for ( val_it=slot_it->second.begin(); val_it!=slot_it->second.end(); val_it++ )
				{
					buf->append( " " );
					buf->append( *val_it );
				}
			}

			buf->append( ")\n" );
		}
	}
}

void epmem_visualize_episode( agent* my_agent, epmem_time_id memory_id, std::string* buf )
{
	// if this is before the first episode, initialize db components
	if ( my_agent->epmem_db->get_status() == soar_module::disconnected )
	{
		epmem_init_db( my_agent );
	}

	// if bad memory, bail
	buf->clear();
	if ( ( memory_id == EPMEM_MEMID_NONE ) ||
			!epmem_valid_episode( my_agent, memory_id ) )
	{
		return;
	}

	// init
	{
		buf->append( "digraph epmem {\n" );
	}

	// taken heavily from install
	{
		soar_module::sqlite_statement *my_q;

		// first identifiers (i.e. reconstruct)
		my_q = my_agent->epmem_stmts_graph->get_edges;
		{
			// for printing
			std::map< epmem_node_id, std::string > stis;
			std::map< epmem_node_id, std::pair< std::string, std::string > > ltis;
			std::list< std::string > edges;
			std::map< epmem_node_id, std::string >::iterator sti_p;
			std::map< epmem_node_id, std::pair< std::string, std::string > >::iterator lti_p;

			// relates to finite automata: q1 = d(q0, w)
			epmem_node_id q0; // id
			epmem_node_id q1; // attribute
			int64_t w_type; // we support any constant attribute symbol
			std::string temp, temp2, temp3, temp4;
			double temp_d;
			int64_t temp_i;

			bool val_is_short_term;
			char val_letter;
			uint64_t val_num;

			// 0 is magic
			temp.assign( "ID_0" );
			stis.insert( std::make_pair< epmem_node_id, std::string >( 0, temp ) );

			// prep rit
			epmem_rit_prep_left_right( my_agent, memory_id, memory_id, &( my_agent->epmem_rit_state_graph[ EPMEM_RIT_STATE_EDGE ] ) );

			// query for edges
			my_q->bind_int( 1, memory_id );
			my_q->bind_int( 2, memory_id );
			my_q->bind_int( 3, memory_id );
			my_q->bind_int( 4, memory_id );
			my_q->bind_int( 5, memory_id );
			while ( my_q->execute() == soar_module::row )
			{
				// q0, w, q1, w_type, letter, num
				q0 = my_q->column_int( 0 );
				q1 = my_q->column_int( 2 );
				w_type = my_q->column_int( 3 );

				// "ID_Q0"
				temp.assign( "ID_" );
				to_string( q0, temp2 );
				temp.append( temp2 );

				// "ID_Q1"
				temp3.assign( "ID_" );
				to_string( q1, temp2 );
				temp3.append( temp2 );

				val_is_short_term = ( my_q->column_type( 4 ) == soar_module::null_t );
				if ( val_is_short_term )
				{
					sti_p = stis.find( q1 );
					if ( sti_p == stis.end() )
					{
						stis.insert( std::make_pair< epmem_node_id, std::string >( q1, temp3 ) );
					}
				}
				else
				{
					lti_p = ltis.find( q1 );

					if ( lti_p == ltis.end() )
					{
						// "L#"
						val_letter = static_cast<char>( my_q->column_int( 4 ) );
						to_string( val_letter, temp4 );
						val_num = static_cast<uint64_t>( my_q->column_int( 5 ) );
						to_string( val_num, temp2 );
						temp4.append( temp2 );

						ltis.insert( std::make_pair< epmem_node_id, std::pair< std::string, std::string > >( q1, std::make_pair< std::string, std::string >( temp3, temp4 ) ) );
					}
				}

				// " -> ID_Q1"
				temp.append( " -> " );
				temp.append( temp3 );

				// " [ label="w" ];\n"
				temp.append( " [ label=\"" );
				switch ( w_type )
				{
					case INT_CONSTANT_SYMBOL_TYPE:
						temp_i = static_cast<int64_t>( my_q->column_int( 1 ) );
						to_string( temp_i, temp2 );
						break;

					case FLOAT_CONSTANT_SYMBOL_TYPE:
						temp_d = my_q->column_double( 1 );
						to_string( temp_d, temp2 );
						break;

					case SYM_CONSTANT_SYMBOL_TYPE:
						temp2.assign( const_cast<char *>( reinterpret_cast<const char *>( my_q->column_text( 1 ) ) ) );
						break;
				}
				temp.append( temp2 );
				temp.append( "\" ];\n" );

				edges.push_back( temp );
			}
			my_q->reinitialize();
			epmem_rit_clear_left_right( my_agent );

			// identifiers
			{
				// short-term
				{
					buf->append( "node [ shape = circle ];\n" );

					for ( sti_p=stis.begin(); sti_p!=stis.end(); sti_p++ )
					{
						buf->append( sti_p->second );
						buf->append( " " );
					}

					buf->append( ";\n" );
				}

				// long-term
				{
					buf->append( "node [ shape = doublecircle ];\n" );

					for ( lti_p=ltis.begin(); lti_p!=ltis.end(); lti_p++ )
					{
						buf->append( lti_p->second.first );
						buf->append( " [ label=\"" );
						buf->append( lti_p->second.second );
						buf->append( "\" ];\n" );
					}

					buf->append( "\n" );
				}
			}

			// edges
			{
				std::list< std::string >::iterator e_p;

				for ( e_p=edges.begin(); e_p!=edges.end(); e_p++ )
				{
					buf->append( (*e_p) );
				}
			}
		}

		// then node_unique
		my_q = my_agent->epmem_stmts_graph->get_nodes;
		{
			epmem_node_id child_id;
			epmem_node_id parent_id;
			int64_t attr_type;
			int64_t value_type;

			std::list< std::string > edges;
			std::list< std::string > consts;

			std::string temp, temp2;
			double temp_d;
			int64_t temp_i;

			epmem_rit_prep_left_right( my_agent, memory_id, memory_id, &( my_agent->epmem_rit_state_graph[ EPMEM_RIT_STATE_NODE ] ) );

			my_q->bind_int( 1, memory_id );
			my_q->bind_int( 2, memory_id );
			my_q->bind_int( 3, memory_id );
			my_q->bind_int( 4, memory_id );
			while ( my_q->execute() == soar_module::row )
			{
				// f.child_id, f.parent_id, f.name, f.value, f.attr_type, f.value_type
				child_id = my_q->column_int( 0 );
				parent_id = my_q->column_int( 1 );
				attr_type = my_q->column_int( 4 );
				value_type = my_q->column_int( 5 );

				temp.assign( "ID_" );
				to_string( parent_id, temp2 );
				temp.append( temp2 );
				temp.append( " -> C_" );
				to_string( child_id, temp2 );
				temp.append( temp2 );
				temp.append( " [ label=\"" );

				// make a symbol to represent the attribute
				switch ( attr_type )
				{
					case INT_CONSTANT_SYMBOL_TYPE:
						temp_i = static_cast<int64_t>( my_q->column_int( 2 ) );
						to_string( temp_i, temp2 );
						break;

					case FLOAT_CONSTANT_SYMBOL_TYPE:
						temp_d = my_q->column_double( 2 );
						to_string( temp_d, temp2 );
						break;

					case SYM_CONSTANT_SYMBOL_TYPE:
						temp2.assign( const_cast<char *>( reinterpret_cast<const char *>( my_q->column_text( 2 ) ) ) );
						break;
				}

				temp.append( temp2 );
				temp.append( "\" ];\n" );
				edges.push_back( temp );

				temp.assign( "C_" );
				to_string( child_id, temp2 );
				temp.append( temp2 );
				temp.append( " [ label=\"" );

				// make a symbol to represent the value
				switch ( value_type )
				{
					case INT_CONSTANT_SYMBOL_TYPE:
						temp_i = static_cast<int64_t>( my_q->column_int( 3 ) );
						to_string( temp_i, temp2 );
						break;

					case FLOAT_CONSTANT_SYMBOL_TYPE:
						temp_d = my_q->column_double( 3 );
						to_string( temp_d, temp2 );
						break;

					case SYM_CONSTANT_SYMBOL_TYPE:
						temp2.assign( const_cast<char *>( reinterpret_cast<const char *>( my_q->column_text( 3 ) ) ) );
						break;
				}

				temp.append( temp2 );
				temp.append( "\" ];\n" );

				consts.push_back( temp );

			}
			my_q->reinitialize();
			epmem_rit_clear_left_right( my_agent );

			// constant nodes
			{
				std::list< std::string >::iterator e_p;

				buf->append( "node [ shape = plaintext ];\n" );

				for ( e_p=consts.begin(); e_p!=consts.end(); e_p++ )
				{
					buf->append( (*e_p) );
				}
			}

			// edges
			{
				std::list< std::string >::iterator e_p;

				for ( e_p=edges.begin(); e_p!=edges.end(); e_p++ )
				{
					buf->append( (*e_p) );
				}
			}
		}
	}

	// close
	{
		buf->append( "\n}\n" );
	}
}

//////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////
// API Implementation (epmem::api)
//////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////

/***************************************************************************
 * Function     : epmem_consider_new_episode
 * Author		: Nate Derbinsky
 * Notes		: Based upon trigger/force parameter settings, potentially
 * 				  records a new episode
 **************************************************************************/
bool epmem_consider_new_episode( agent *my_agent )
{
	////////////////////////////////////////////////////////////////////////////
	my_agent->epmem_timers->trigger->start();
	////////////////////////////////////////////////////////////////////////////

	const int64_t force = my_agent->epmem_params->force->get_value();
	bool new_memory = false;

	if ( force == epmem_param_container::force_off )
	{
		const int64_t trigger = my_agent->epmem_params->trigger->get_value();

		if ( trigger == epmem_param_container::output )
		{
			slot *s;
			wme *w;
			Symbol *ol = my_agent->io_header_output;

			// examine all commands on the output-link for any
			// that appeared since last memory was recorded
			for ( s = ol->id.slots; s != NIL; s = s->next )
			{
				for ( w = s->wmes; w != NIL; w = w->next )
				{
					if ( w->timetag > my_agent->top_goal->id.epmem_info->last_ol_time )
					{
						new_memory = true;
						my_agent->top_goal->id.epmem_info->last_ol_time = w->timetag;
					}
				}
			}
		}
		else if ( trigger == epmem_param_container::dc )
		{
			new_memory = true;
		}
		else if ( trigger == epmem_param_container::none )
		{
			new_memory = false;
		}
	}
	else
	{
		new_memory = ( force == epmem_param_container::remember );

		my_agent->epmem_params->force->set_value( epmem_param_container::force_off );
	}

	////////////////////////////////////////////////////////////////////////////
	my_agent->epmem_timers->trigger->stop();
	////////////////////////////////////////////////////////////////////////////

	if ( new_memory )
	{
		epmem_new_episode( my_agent );
	}

	return new_memory;
}

void inline _epmem_respond_to_cmd_parse( agent* my_agent, epmem_wme_list* cmds, bool& good_cue, int& path, epmem_time_id& retrieve, Symbol*& next, Symbol*& previous, Symbol*& query, Symbol*& neg_query, epmem_time_list& prohibit, epmem_time_id& before, epmem_time_id& after, soar_module::wme_set& cue_wmes )
{
	cue_wmes.clear();

	retrieve = EPMEM_MEMID_NONE;
	next = NULL;
	previous = NULL;
	query = NULL;
	neg_query = NULL;
	prohibit.clear();
	before = EPMEM_MEMID_NONE;
	after = EPMEM_MEMID_NONE;
	good_cue = true;
	path = 0;

	for ( epmem_wme_list::iterator w_p=cmds->begin(); w_p!=cmds->end(); w_p++ )
	{
		cue_wmes.insert( (*w_p) );

		if ( good_cue )
		{
			// collect information about known commands
			if ( (*w_p)->attr == my_agent->epmem_sym_retrieve )
			{
				if ( ( (*w_p)->value->ic.common_symbol_info.symbol_type == INT_CONSTANT_SYMBOL_TYPE ) &&
						( path == 0 ) &&
						( (*w_p)->value->ic.value > 0 ) )
				{
					retrieve = (*w_p)->value->ic.value;
					path = 1;
				}
				else
				{
					good_cue = false;
				}
			}
			else if ( (*w_p)->attr == my_agent->epmem_sym_next )
			{
				if ( ( (*w_p)->value->id.common_symbol_info.symbol_type == IDENTIFIER_SYMBOL_TYPE ) &&
						( path == 0 ) )
				{
					next = (*w_p)->value;
					path = 2;
				}
				else
				{
					good_cue = false;
				}
			}
			else if ( (*w_p)->attr == my_agent->epmem_sym_prev )
			{
				if ( ( (*w_p)->value->id.common_symbol_info.symbol_type == IDENTIFIER_SYMBOL_TYPE ) &&
						( path == 0 ) )
				{
					previous = (*w_p)->value;
					path = 2;
				}
				else
				{
					good_cue = false;
				}
			}
			else if ( (*w_p)->attr == my_agent->epmem_sym_query )
			{
				if ( ( (*w_p)->value->id.common_symbol_info.symbol_type == IDENTIFIER_SYMBOL_TYPE ) &&
						( ( path == 0 ) || ( path == 3 ) ) &&
						( query == NULL ) )

				{
					query = (*w_p)->value;
					path = 3;
				}
				else
				{
					good_cue = false;
				}
			}
			else if ( (*w_p)->attr == my_agent->epmem_sym_negquery )
			{
				if ( ( (*w_p)->value->id.common_symbol_info.symbol_type == IDENTIFIER_SYMBOL_TYPE ) &&
						( ( path == 0 ) || ( path == 3 ) ) &&
						( neg_query == NULL ) )

				{
					neg_query = (*w_p)->value;
					path = 3;
				}
				else
				{
					good_cue = false;
				}
			}
			else if ( (*w_p)->attr == my_agent->epmem_sym_before )
			{
				if ( ( (*w_p)->value->ic.common_symbol_info.symbol_type == INT_CONSTANT_SYMBOL_TYPE ) &&
						( ( path == 0 ) || ( path == 3 ) ) )
				{
					before = (*w_p)->value->ic.value;
					path = 3;
				}
				else
				{
					good_cue = false;
				}
			}
			else if ( (*w_p)->attr == my_agent->epmem_sym_after )
			{
				if ( ( (*w_p)->value->ic.common_symbol_info.symbol_type == INT_CONSTANT_SYMBOL_TYPE ) &&
						( ( path == 0 ) || ( path == 3 ) ) )
				{
					after = (*w_p)->value->ic.value;
					path = 3;
				}
				else
				{
					good_cue = false;
				}
			}
			else if ( (*w_p)->attr == my_agent->epmem_sym_prohibit )
			{
				if ( ( (*w_p)->value->ic.common_symbol_info.symbol_type == INT_CONSTANT_SYMBOL_TYPE ) &&
						( ( path == 0 ) || ( path == 3 ) ) )
				{
					prohibit.push_back( (*w_p)->value->ic.value );
					path = 3;
				}
				else
				{
					good_cue = false;
				}
			}
			else
			{
				good_cue = false;
			}
		}
	}

	// if on path 3 must have query
	if ( ( path == 3 ) && ( query == NULL ) )
	{
		good_cue = false;
	}

	// must be on a path
	if ( path == 0 )
	{
		good_cue = false;
	}
}

/***************************************************************************
 * Function     : epmem_respond_to_cmd
 * Author		: Nate Derbinsky
 * Notes		: Implements the Soar-EpMem API
 **************************************************************************/
void epmem_respond_to_cmd( agent *my_agent )
{
	// if this is before the first episode, initialize db components
	if ( my_agent->epmem_db->get_status() == soar_module::disconnected )
	{
		epmem_init_db( my_agent );
	}

	// respond to query only if db is properly initialized
	if ( my_agent->epmem_db->get_status() != soar_module::connected )
	{
		return;
	}

	// start at the bottom and work our way up
	// (could go in the opposite direction as well)
	Symbol *state = my_agent->bottom_goal;

	epmem_wme_list *wmes;
	epmem_wme_list *cmds;
	epmem_wme_list::iterator w_p;

	soar_module::wme_set cue_wmes;
	soar_module::symbol_triple_list meta_wmes;
	soar_module::symbol_triple_list retrieval_wmes;

	epmem_time_id retrieve;
	Symbol *next;
	Symbol *previous;
	Symbol *query;
	Symbol *neg_query;
	epmem_time_list prohibit;
	epmem_time_id before, after;
	bool good_cue;
	int path;

	uint64_t wme_count;
	bool new_cue;

	bool do_wm_phase = false;

	while ( state != NULL )
	{
		////////////////////////////////////////////////////////////////////////////
		my_agent->epmem_timers->api->start();
		////////////////////////////////////////////////////////////////////////////

		// make sure this state has had some sort of change to the cmd
		new_cue = false;
		wme_count = 0;
		cmds = NULL;
		{
			tc_number tc = get_new_tc_number( my_agent );
			std::queue<Symbol *> syms;
			Symbol *parent_sym;

			// initialize BFS at command
			syms.push( state->id.epmem_cmd_header );

			while ( !syms.empty() )
			{
				// get state
				parent_sym = syms.front();
				syms.pop();

				// get children of the current identifier
				wmes = epmem_get_augs_of_id( parent_sym, tc );
				{
					for ( w_p=wmes->begin(); w_p!=wmes->end(); w_p++ )
					{
						wme_count++;

						if ( (*w_p)->timetag > state->id.epmem_info->last_cmd_time )
						{
							new_cue = true;
							state->id.epmem_info->last_cmd_time = (*w_p)->timetag;
						}

						if ( (*w_p)->value->common.symbol_type == IDENTIFIER_SYMBOL_TYPE )
						{
							syms.push( (*w_p)->value );
						}
					}

					// free space from aug list
					if ( cmds == NIL )
					{
						cmds = wmes;
					}
					else
					{
						delete wmes;
					}
				}
			}

			// see if any WMEs were removed
			if ( state->id.epmem_info->last_cmd_count != wme_count )
			{
				new_cue = true;
				state->id.epmem_info->last_cmd_count = wme_count;
			}

			if ( new_cue )
			{
				// clear old results
				epmem_clear_result( my_agent, state );

				do_wm_phase = true;
			}
		}

		// a command is issued if the cue is new
		// and there is something on the cue
		if ( new_cue && wme_count )
		{
			_epmem_respond_to_cmd_parse( my_agent, cmds, good_cue, path, retrieve, next, previous, query, neg_query, prohibit, before, after, cue_wmes );

			////////////////////////////////////////////////////////////////////////////
			my_agent->epmem_timers->api->stop();
			////////////////////////////////////////////////////////////////////////////

			retrieval_wmes.clear();
			meta_wmes.clear();

			// process command
			if ( good_cue )
			{
				// retrieve
				if ( path == 1 )
				{
					epmem_install_memory( my_agent, state, retrieve, meta_wmes, retrieval_wmes );
				}
				// previous or next
				else if ( path == 2 )
				{
					if ( next )
					{
						epmem_install_memory( my_agent, state, epmem_next_episode( my_agent, state->id.epmem_info->last_memory ), meta_wmes, retrieval_wmes );

						// add one to the next stat
						my_agent->epmem_stats->nexts->set_value( my_agent->epmem_stats->nexts->get_value() + 1 );
					}
					else
					{
						epmem_install_memory( my_agent, state, epmem_previous_episode( my_agent, state->id.epmem_info->last_memory ), meta_wmes, retrieval_wmes );

						// add one to the prev stat
						my_agent->epmem_stats->prevs->set_value( my_agent->epmem_stats->prevs->get_value() + 1 );
					}

					if ( state->id.epmem_info->last_memory == EPMEM_MEMID_NONE )
					{
						epmem_buffer_add_wme( meta_wmes, state->id.epmem_result_header, my_agent->epmem_sym_failure, ( ( next )?( next ):( previous ) ) );
					}
					else
					{
						epmem_buffer_add_wme( meta_wmes, state->id.epmem_result_header, my_agent->epmem_sym_success, ( ( next )?( next ):( previous ) ) );
					}
				}
				// query
				else if ( path == 3 )
				{
					epmem_process_query( my_agent, state, query, neg_query, prohibit, before, after, cue_wmes, meta_wmes, retrieval_wmes );

					// add one to the cbr stat
					my_agent->epmem_stats->cbr->set_value( my_agent->epmem_stats->cbr->get_value() + 1 );
				}
			}
			else
			{
				epmem_buffer_add_wme( meta_wmes, state->id.epmem_result_header, my_agent->epmem_sym_status, my_agent->epmem_sym_bad_cmd );
			}

			// clear prohibit list
			prohibit.clear();

			if ( !retrieval_wmes.empty() || !meta_wmes.empty() )
			{
				// process preference assertion en masse
				epmem_process_buffered_wmes( my_agent, state, cue_wmes, meta_wmes, retrieval_wmes );

				// clear cache
				{
					soar_module::symbol_triple_list::iterator mw_it;

					for ( mw_it=retrieval_wmes.begin(); mw_it!=retrieval_wmes.end(); mw_it++ )
					{
						symbol_remove_ref( my_agent, (*mw_it)->id );
						symbol_remove_ref( my_agent, (*mw_it)->attr );
						symbol_remove_ref( my_agent, (*mw_it)->value );

						delete (*mw_it);
					}
					retrieval_wmes.clear();

					for ( mw_it=meta_wmes.begin(); mw_it!=meta_wmes.end(); mw_it++ )
					{
						symbol_remove_ref( my_agent, (*mw_it)->id );
						symbol_remove_ref( my_agent, (*mw_it)->attr );
						symbol_remove_ref( my_agent, (*mw_it)->value );

						delete (*mw_it);
					}
					meta_wmes.clear();
				}

				// process wm changes on this state
				do_wm_phase = true;
			}

			// clear cue wmes
			cue_wmes.clear();
		}
		else
		{
			////////////////////////////////////////////////////////////////////////////
			my_agent->epmem_timers->api->stop();
			////////////////////////////////////////////////////////////////////////////
		}

		// free space from command aug list
		if ( cmds )
		{
			delete cmds;
		}

		state = state->id.higher_goal;
	}

	if ( do_wm_phase )
	{
		////////////////////////////////////////////////////////////////////////////
		my_agent->epmem_timers->wm_phase->start();
		////////////////////////////////////////////////////////////////////////////

		do_working_memory_phase( my_agent );

		////////////////////////////////////////////////////////////////////////////
		my_agent->epmem_timers->wm_phase->stop();
		////////////////////////////////////////////////////////////////////////////
	}
}

#ifdef EPMEM_EXPERIMENT
void inline _epmem_exp( agent* my_agent )
{
	// hopefully generally useful code for evaluating
	// query speed as number of episodes increases
	// usage: top-state.epmem.queries <q>
	//        <q> ^reps #
	//            ^mod # (optional, defaults to 1)
	//            ^output |filename|
	//            ^format << csv speedy >>
	//            ^features <fs>
	//               <fs> ^|key| |value| # note: value must be a string, not int or float; wrap it in pipes (eg. |0|)
	//            ^commands <cmds>
	//               <cmds> ^|label| <cmd>

	if ( !epmem_exp_timer )
	{
		epmem_exp_timer = new soar_module::timer( "exp", my_agent, soar_module::timer::zero, new soar_module::predicate<soar_module::timer::timer_level>(), false );
	}

	double c1;

	epmem_exp_timer->reset();
	epmem_exp_timer->start();
	epmem_dc_wme_adds = -1;
	bool new_episode = epmem_consider_new_episode( my_agent );
	epmem_exp_timer->stop();
	c1 = epmem_exp_timer->value();

	if ( new_episode )
	{
		Symbol* queries = make_sym_constant( my_agent, "queries" );
		Symbol* reps = make_sym_constant( my_agent, "reps" );
		Symbol* mod = make_sym_constant( my_agent, "mod" );
		Symbol* output = make_sym_constant( my_agent, "output" );
		Symbol* format = make_sym_constant( my_agent, "format" );
		Symbol* features = make_sym_constant( my_agent, "features" );
		Symbol* cmds = make_sym_constant( my_agent, "commands" );
		Symbol* csv = make_sym_constant( my_agent, "csv" );

		slot* queries_slot = find_slot( my_agent->top_goal->id.epmem_header, queries );
		if ( queries_slot )
		{
			wme* queries_wme = queries_slot->wmes;

			if ( queries_wme->value->common.symbol_type == IDENTIFIER_SYMBOL_TYPE )
			{
				Symbol* queries_id = queries_wme->value;
				slot* reps_slot = find_slot( queries_id, reps );
				slot* mod_slot = find_slot( queries_id, mod );
				slot* output_slot = find_slot( queries_id, output );
				slot* format_slot = find_slot( queries_id, format );
				slot* features_slot = find_slot( queries_id, features );
				slot* commands_slot = find_slot( queries_id, cmds );

				if ( reps_slot && output_slot && format_slot && commands_slot )
				{
					wme* reps_wme = reps_slot->wmes;
					wme* mod_wme = ( ( mod_slot )?( mod_slot->wmes ):( NULL ) );
					wme* output_wme = output_slot->wmes;
					wme* format_wme = format_slot->wmes;
					wme* features_wme = ( ( features_slot )?( features_slot->wmes ):( NULL ) );
					wme* commands_wme = commands_slot->wmes;

					if ( ( reps_wme->value->common.symbol_type == INT_CONSTANT_SYMBOL_TYPE ) &&
							( output_wme->value->common.symbol_type == SYM_CONSTANT_SYMBOL_TYPE ) &&
							( format_wme->value->common.symbol_type == SYM_CONSTANT_SYMBOL_TYPE ) &&
							( commands_wme->value->common.symbol_type == IDENTIFIER_SYMBOL_TYPE ) )
					{
						int64_t reps = reps_wme->value->ic.value;
						int64_t mod = ( ( mod_wme && ( mod_wme->value->common.symbol_type == INT_CONSTANT_SYMBOL_TYPE ) )?( mod_wme->value->ic.value ):(1) );
						const char* output_fname = output_wme->value->sc.name;
						bool format_csv = ( format_wme->value == csv );
						std::list< std::pair< std::string, std::string > > output_contents;
						std::string temp_str, temp_str2;
						std::set< std::string > cmd_names;

						std::map< std::string, std::string > features;
						if ( features_wme && features_wme->value->common.symbol_type == IDENTIFIER_SYMBOL_TYPE )
						{
							for ( slot* s=features_wme->value->id.slots; s; s=s->next )
							{
								for ( wme* w=s->wmes; w; w=w->next )
								{
									if ( ( w->attr->common.symbol_type == SYM_CONSTANT_SYMBOL_TYPE ) &&
											( w->value->common.symbol_type == SYM_CONSTANT_SYMBOL_TYPE ) )
									{
										features[ w->attr->sc.name ] = w->value->sc.name;
									}
								}
							}
						}

						if ( ( mod == 1 ) || ( ( ( my_agent->epmem_stats->time->get_value()-1 ) % mod ) == 1 ) )
						{

							// all fields (used to produce csv header), possibly stub values at this point
							{
								// features
								for ( std::map< std::string, std::string >::iterator f_it=features.begin(); f_it!=features.end(); f_it++ )
								{
									output_contents.push_back( std::make_pair< std::string, std::string >( f_it->first, f_it->second ) );
								}

								// decision
								{
									to_string( my_agent->d_cycle_count, temp_str );
									output_contents.push_back( std::make_pair< std::string, std::string >( "dc", temp_str ) );
								}

								// episode number
								{
									to_string( my_agent->epmem_stats->time->get_value()-1, temp_str );
									output_contents.push_back( std::make_pair< std::string, std::string >( "episodes", temp_str ) );
								}

								// reps
								{
									to_string( reps, temp_str );
									output_contents.push_back( std::make_pair< std::string, std::string >( "reps", temp_str ) );
								}

								// current wm size
								{
									to_string( my_agent->num_wmes_in_rete, temp_str );
									output_contents.push_back( std::make_pair< std::string, std::string >( "wmcurrent", temp_str ) );
								}

								// wm adds/removes
								{
									to_string( ( my_agent->wme_addition_count - epmem_exp_state[ exp_state_wm_adds ] ), temp_str );
									output_contents.push_back( std::make_pair< std::string, std::string >( "wmadds", temp_str ) );
									epmem_exp_state[ exp_state_wm_adds ] = static_cast< int64_t >( my_agent->wme_addition_count );

									to_string( ( my_agent->wme_removal_count - epmem_exp_state[ exp_state_wm_removes ] ), temp_str );
									output_contents.push_back( std::make_pair< std::string, std::string >( "wmremoves", temp_str ) );
									epmem_exp_state[ exp_state_wm_removes ] = static_cast< int64_t >( my_agent->wme_removal_count );
								}

								// dc interval add/removes
								{
									to_string( epmem_dc_interval_inserts, temp_str );
									output_contents.push_back( std::make_pair< std::string, std::string >( "dcintervalinserts", temp_str ) );

									to_string( epmem_dc_interval_removes, temp_str );
									output_contents.push_back( std::make_pair< std::string, std::string >( "dcintervalremoves", temp_str ) );
								}

								// dc wme adds
								{
									to_string( epmem_dc_wme_adds, temp_str );
									output_contents.push_back( std::make_pair< std::string, std::string >( "dcwmeadds", temp_str ) );
								}

								// sqlite memory
								{
									int64_t sqlite_mem = my_agent->epmem_stats->mem_usage->get_value();

									to_string( ( sqlite_mem - epmem_exp_state[ exp_state_sqlite_mem ] ), temp_str );
									output_contents.push_back( std::make_pair< std::string, std::string >( "sqlitememadd", temp_str ) );
									epmem_exp_state[ exp_state_sqlite_mem ] = sqlite_mem;

									to_string( sqlite_mem, temp_str );
									output_contents.push_back( std::make_pair< std::string, std::string >( "sqlitememcurrent", temp_str ) );
								}

								// storage time in seconds
								{
									to_string( c1, temp_str );

									output_contents.push_back( std::make_pair< std::string, std::string >( "storage", temp_str ) );
									cmd_names.insert( "storage" );
								}

								// commands
								for ( slot* s=commands_wme->value->id.slots; s; s=s->next )
								{
									output_contents.push_back( std::make_pair< std::string, std::string >( s->attr->sc.name, "" ) );
									std::string searched = "numsearched";
									searched.append(s->attr->sc.name);
									output_contents.push_back( std::make_pair< std::string, std::string >( searched , "" ) );
								}
							}

							// open file, write header
							if ( !epmem_exp_output )
							{
								epmem_exp_output = new std::ofstream( output_fname );

								if ( format_csv )
								{
									for ( std::list< std::pair< std::string, std::string > >::iterator it=output_contents.begin(); it!=output_contents.end(); it++ )
									{
										if ( it != output_contents.begin() )
										{
											(*epmem_exp_output) << ",";
										}

										(*epmem_exp_output) << "\"" << it->first << "\"";
									}

									(*epmem_exp_output) << std::endl;
								}
							}

							// collect timing data
							{
								epmem_wme_list* cmds = NULL;
								soar_module::wme_set cue_wmes;
								soar_module::symbol_triple_list meta_wmes;
								soar_module::symbol_triple_list retrieval_wmes;

								epmem_time_id retrieve;
								Symbol* next;
								Symbol* previous;
								Symbol* query;
								Symbol* neg_query;
								epmem_time_list prohibit;
								epmem_time_id before, after;
								bool good_cue;
								int path;

								//

								for ( slot* s=commands_wme->value->id.slots; s; s=s->next )
								{
									if ( s->wmes->value->common.symbol_type == IDENTIFIER_SYMBOL_TYPE )
									{
										// parse command once
										{
											cmds = epmem_get_augs_of_id( s->wmes->value, get_new_tc_number( my_agent ) );
											_epmem_respond_to_cmd_parse( my_agent, cmds, good_cue, path, retrieve, next, previous, query, neg_query, prohibit, before, after, cue_wmes );
										}

										if ( good_cue && ( path == 3 ) )
										{
											// execute lots of times
											double c_total = 0;
											{
												epmem_exp_timer->reset();
												epmem_exp_timer->start();
												for ( int64_t i=1; i<=reps; i++ )
												{
													epmem_process_query( my_agent, my_agent->top_goal, query, neg_query, prohibit, before, after, cue_wmes, meta_wmes, retrieval_wmes, 2 );

													if ( !retrieval_wmes.empty() || !meta_wmes.empty() )
													{
														soar_module::symbol_triple_list::iterator mw_it;

														for ( mw_it=retrieval_wmes.begin(); mw_it!=retrieval_wmes.end(); mw_it++ )
														{
															symbol_remove_ref( my_agent, (*mw_it)->id );
															symbol_remove_ref( my_agent, (*mw_it)->attr );
															symbol_remove_ref( my_agent, (*mw_it)->value );

															delete (*mw_it);
														}
														retrieval_wmes.clear();

														for ( mw_it=meta_wmes.begin(); mw_it!=meta_wmes.end(); mw_it++ )
														{
															symbol_remove_ref( my_agent, (*mw_it)->id );
															symbol_remove_ref( my_agent, (*mw_it)->attr );
															symbol_remove_ref( my_agent, (*mw_it)->value );

															delete (*mw_it);
														}
														meta_wmes.clear();
													}
												}
												epmem_exp_timer->stop();
												c_total = epmem_exp_timer->value();
											}

											// update results
											{
												to_string( c_total, temp_str );

												for ( std::list< std::pair< std::string, std::string > >::iterator oc_it=output_contents.begin(); oc_it!=output_contents.end(); oc_it++ )
												{
													if ( oc_it->first.compare( s->attr->sc.name ) == 0 )
													{
														oc_it->second.assign( temp_str );
														oc_it++;
														to_string( epmem_episodes_searched , temp_str );
														oc_it->second.assign( temp_str );
													}
												}

												cmd_names.insert( s->attr->sc.name );
											}
										}

										// clean
										{
											delete cmds;
										}
									}
								}
							}

							// output data
							if ( format_csv )
							{
								for ( std::list< std::pair< std::string, std::string > >::iterator it=output_contents.begin(); it!=output_contents.end(); it++ )
								{
									if ( it != output_contents.begin() )
									{
										(*epmem_exp_output) << ",";
									}

									(*epmem_exp_output) << "\"" << it->second << "\"";
								}

								(*epmem_exp_output) << std::endl;
							}
							else
							{
								for ( std::set< std::string >::iterator c_it=cmd_names.begin(); c_it!=cmd_names.end(); c_it++ )
								{
									for ( std::list< std::pair< std::string, std::string > >::iterator it=output_contents.begin(); it!=output_contents.end(); it++ )
									{
										if ( cmd_names.find( it->first ) == cmd_names.end() )
										{
											if ( it->first.substr( 0, 11 ).compare( "numsearched" ) == 0 )
											{
												continue;
											}

											if ( it != output_contents.begin() )
											{
												(*epmem_exp_output) << " ";
											}
											if ( ( it->first.compare( "reps" ) == 0 ) && ( c_it->compare( "storage" ) == 0 ) )
											{
												(*epmem_exp_output) << it->first << "=" << "1";
											}
											else
											{
												(*epmem_exp_output) << it->first << "=" << it->second;
											}
										}
										else if ( c_it->compare( it->first ) == 0 )
										{
											(*epmem_exp_output) << " command=" << it->first << " totalsec=" << it->second;
											if ( it->first.compare( "storage" ) == 0 ) {
												(*epmem_exp_output) << " numsearched=0";
												break;
											} else {
												it++;
												(*epmem_exp_output) << " numsearched=" << it->second;
												break;
											}
										}
									}

									(*epmem_exp_output) << std::endl;
								}
							}
						}
					}
				}
			}
		}

		symbol_remove_ref( my_agent, queries );
		symbol_remove_ref( my_agent, reps );
		symbol_remove_ref( my_agent, mod );
		symbol_remove_ref( my_agent, output );
		symbol_remove_ref( my_agent, format );
		symbol_remove_ref( my_agent, features );
		symbol_remove_ref( my_agent, cmds );
		symbol_remove_ref( my_agent, csv );
	}
}
#endif

/***************************************************************************
 * Function     : epmem_go
 * Author		: Nate Derbinsky
 * Notes		: The kernel calls this function to implement Soar-EpMem:
 * 				  consider new storage and respond to any commands
 **************************************************************************/
void epmem_go( agent *my_agent )
{

	my_agent->epmem_timers->total->start();

#ifndef EPMEM_EXPERIMENT

	epmem_consider_new_episode( my_agent );
	epmem_respond_to_cmd( my_agent );

#else // EPMEM_EXPERIMENT

	_epmem_exp( my_agent );
	epmem_respond_to_cmd( my_agent );

#endif // EPMEM_EXPERIMENT

	my_agent->epmem_timers->total->stop();

}

bool epmem_backup_db( agent* my_agent, const char* file_name, std::string *err )
{
	bool return_val = false;

	if ( my_agent->epmem_db->get_status() == soar_module::connected )
	{
		if ( my_agent->epmem_params->lazy_commit->get_value() == soar_module::on )
		{
			my_agent->epmem_stmts_common->commit->execute( soar_module::op_reinit );
		}

		return_val = my_agent->epmem_db->backup( file_name, err );

		if ( my_agent->epmem_params->lazy_commit->get_value() == soar_module::on )
		{
			my_agent->epmem_stmts_common->begin->execute( soar_module::op_reinit );
		}
	}
	else
	{
		err->assign( "Episodic database is not currently connected." );
	}

	return return_val;
}
