//
//  newcharacter-overrtide.cpp
//  CDDA
//
//  Created by Аполлов Юрий Андреевич on 09.10.2021.
//  Copyright © 2021 Аполлов Юрий Андреевич. All rights reserved.
//

#include "newcharacter.cpp"

#undef set_scenario
#define set_scenario set_scenario_override


tab_direction set_scenario_override( avatar &u, points_left &points,
                           const tab_direction direction )
{
    int cur_id = 0;
    tab_direction retval = tab_direction::NONE;
    int iContentHeight = 0;
    int iStartPos = 0;
    
    ui_adaptor ui;
    catacurses::window w;
    catacurses::window w_description;
    catacurses::window w_sorting;
    catacurses::window w_profession;
    catacurses::window w_location;
    catacurses::window w_vehicle;
    catacurses::window w_flags;
    const auto init_windows = [&]( ui_adaptor & ui ) {
        iContentHeight = TERMY - 10;
        w = catacurses::newwin( TERMY, TERMX, point_zero );
        w_description = catacurses::newwin( 4, TERMX - 2, point( 1, TERMY - 5 ) );
        w_sorting = catacurses::newwin( 2, ( TERMX / 2 ) - 1, point( TERMX / 2, 5 ) );
        w_profession = catacurses::newwin( 4, ( TERMX / 2 ) - 1, point( TERMX / 2, 7 ) );
        w_location = catacurses::newwin( 3, ( TERMX / 2 ) - 1, point( TERMX / 2, 11 ) );
        w_vehicle = catacurses::newwin( 3, ( TERMX / 2 ) - 1, point( TERMX / 2, 14 ) );
        // 9 = 2 + 4 + 3, so we use rest of space for flags
        w_flags = catacurses::newwin( iContentHeight - 9, ( TERMX / 2 ) - 1,
                                     point( TERMX / 2, 17 ) );
        ui.position_from_window( w );
    };
    init_windows( ui );
    ui.on_screen_resize( init_windows );
    
    input_context ctxt( "NEW_CHAR_SCENARIOS" );
    ctxt.register_cardinal();
    ctxt.register_action( "CONFIRM" );
    ctxt.register_action( "PREV_TAB" );
    ctxt.register_action( "NEXT_TAB" );
    ctxt.register_action( "SORT" );
    ctxt.register_action( "HELP_KEYBINDINGS" );
    ctxt.register_action( "FILTER" );
    ctxt.register_action( "QUIT" );
    
    bool recalc_scens = true;
    int scens_length = 0;
    std::string filterstring;
    std::vector<const scenario *> sorted_scens;
    
    if( direction == tab_direction::BACKWARD ) {
        points.skill_points += u.prof->point_cost();
    }
    
    ui.on_redraw( [&]( const ui_adaptor & ) {
        werase( w );
        draw_character_tabs( w, _( "SCENARIO" ) );
        
        // Draw filter indicator
        for( int i = 1; i < getmaxx( w ) - 1; i++ ) {
            mvwputch( w, point( i, getmaxy( w ) - 1 ), BORDER_COLOR, LINE_OXOX );
        }
        const auto filter_indicator = filterstring.empty() ? _( "no filter" )
        : filterstring;
        mvwprintz( w, point( 2, getmaxy( w ) - 1 ), c_light_gray, "<%s>", filter_indicator );
        
        const bool cur_id_is_valid = cur_id >= 0 && static_cast<size_t>( cur_id ) < sorted_scens.size();
        
        werase( w_description );
        if( cur_id_is_valid ) {
            int netPointCost = sorted_scens[cur_id]->point_cost() - g->scen->point_cost();
            bool can_pick = sorted_scens[cur_id]->can_pick( *g->scen, points.skill_points_left() );
            const std::string clear_line( getmaxx( w_description ), ' ' );
            
            // Clear the bottom of the screen and header.
            mvwprintz( w, point( 1, 3 ), c_light_gray, clear_line );
            
            int pointsForScen = sorted_scens[cur_id]->point_cost();
            bool negativeScen = pointsForScen < 0;
            if( negativeScen ) {
                pointsForScen *= -1;
            }
            
            // Draw header.
            draw_points( w, points, netPointCost );
            
            std::string scen_msg_temp;
            if( negativeScen ) {
                //~ 1s - scenario name, 2d - current character points.
                scen_msg_temp = vgettext( "Scenario %1$s earns %2$d point",
                                         "Scenario %1$s earns %2$d points",
                                         pointsForScen );
            } else {
                //~ 1s - scenario name, 2d - current character points.
                scen_msg_temp = vgettext( "Scenario %1$s costs %2$d point",
                                         "Scenario %1$s cost %2$d points",
                                         pointsForScen );
            }
            
            int pMsg_length = utf8_width( remove_color_tags( points.to_string() ) );
            mvwprintz( w, point( pMsg_length + 9, 3 ), can_pick ? c_green : c_light_red, scen_msg_temp.c_str(),
                      sorted_scens[cur_id]->gender_appropriate_name( u.male ),
                      pointsForScen );
            
            const std::string scenDesc = sorted_scens[cur_id]->description( u.male );
            
            if( sorted_scens[cur_id]->has_flag( "CITY_START" ) && !scenario_sorter.cities_enabled ) {
                const std::string scenUnavailable =
                _( "This scenario is not available in this world due to city size settings." );
                fold_and_print( w_description, point_zero, TERMX - 2, c_red, scenUnavailable );
                // NOLINTNEXTLINE(cata-use-named-point-constants)
                fold_and_print( w_description, point( 0, 1 ), TERMX - 2, c_green, scenDesc );
            } else {
                fold_and_print( w_description, point_zero, TERMX - 2, c_green, scenDesc );
            }
        }
        
        //Draw options
        calcStartPos( iStartPos, cur_id, iContentHeight, scens_length );
        const int end_pos = iStartPos + ( ( iContentHeight > scens_length ) ?
                                         scens_length : iContentHeight );
        int i;
        for( i = iStartPos; i < end_pos; i++ ) {
            mvwprintz( w, point( 2, 5 + i - iStartPos ), c_light_gray,
                      "                                             " );
            nc_color col;
            if( g->scen != sorted_scens[i] ) {
                if( cur_id_is_valid && sorted_scens[i] == sorted_scens[cur_id] &&
                   sorted_scens[i]->has_flag( "CITY_START" ) && !scenario_sorter.cities_enabled ) {
                    col = h_dark_gray;
                } else if( cur_id_is_valid && sorted_scens[i] != sorted_scens[cur_id] &&
                          sorted_scens[i]->has_flag( "CITY_START" ) && !scenario_sorter.cities_enabled ) {
                    col = c_dark_gray;
                } else {
                    col = ( cur_id_is_valid && sorted_scens[i] == sorted_scens[cur_id] ? h_light_gray : c_light_gray );
                }
            } else {
                col = ( cur_id_is_valid &&
                       sorted_scens[i] == sorted_scens[cur_id] ? hilite( COL_SKILL_USED ) : COL_SKILL_USED );
            }
            mvwprintz( w, point( 2, 5 + i - iStartPos ), col,
                      sorted_scens[i]->gender_appropriate_name( u.male ) );
            
        }
        //Clear rest of space in case stuff got filtered out
        for( ; i < iStartPos + iContentHeight; ++i ) {
            mvwprintz( w, point( 2, 5 + i - iStartPos ), c_light_gray,
                      "                                             " ); // Clear the line
        }
        
        werase( w_sorting );
        werase( w_profession );
        werase( w_location );
        werase( w_vehicle );
        werase( w_flags );
        
        if( cur_id_is_valid ) {
            draw_sorting_indicator( w_sorting, ctxt, scenario_sorter );
            
            mvwprintz( w_profession, point_zero, COL_HEADER, _( "Professions:" ) );
            wprintz( w_profession, c_light_gray,
                    string_format( _( "\n%s" ), sorted_scens[cur_id]->prof_count_str() ) );
            wprintz( w_profession, c_light_gray, _( ", default:\n" ) );
            
            auto psorter = profession_sorter;
            psorter.sort_by_points = true;
            const auto permitted = sorted_scens[cur_id]->permitted_professions();
            const auto default_prof = *std::min_element( permitted.begin(), permitted.end(), psorter );
            const int prof_points = default_prof->point_cost();
            wprintz( w_profession, c_light_gray,
                    default_prof->gender_appropriate_name( u.male ) );
            if( prof_points > 0 ) {
                wprintz( w_profession, c_red, " (-%d)", prof_points );
            } else if( prof_points < 0 ) {
                wprintz( w_profession, c_green, " (+%d)", -prof_points );
            }
            
            mvwprintz( w_location, point_zero, COL_HEADER, _( "Scenario Location:" ) );
            wprintz( w_location, c_light_gray, ( "\n" ) );
            wprintz( w_location, c_light_gray,
                    string_format( _( "%s (%d locations, %d variants)" ),
                                  sorted_scens[cur_id]->start_name(),
                                  sorted_scens[cur_id]->start_location_count(),
                                  sorted_scens[cur_id]->start_location_targets_count() ) );
            
            mvwprintz( w_vehicle, point_zero, COL_HEADER, _( "Scenario Vehicle:" ) );
            wprintz( w_vehicle, c_light_gray, ( "\n" ) );
            if( sorted_scens[cur_id]->vehicle() ) {
                wprintz( w_vehicle, c_light_gray, sorted_scens[cur_id]->vehicle()->name );
            }
            
            mvwprintz( w_flags, point_zero, COL_HEADER, _( "Scenario Flags:" ) );
            wprintz( w_flags, c_light_gray, ( "\n" ) );
            
            if( sorted_scens[cur_id]->has_flag( "SPR_START" ) ) {
                wprintz( w_flags, c_light_gray, _( "Spring start" ) );
                wprintz( w_flags, c_light_gray, ( "\n" ) );
            } else if( sorted_scens[cur_id]->has_flag( "SUM_START" ) ) {
                wprintz( w_flags, c_light_gray, _( "Summer start" ) );
                wprintz( w_flags, c_light_gray, ( "\n" ) );
            } else if( sorted_scens[cur_id]->has_flag( "AUT_START" ) ) {
                wprintz( w_flags, c_light_gray, _( "Autumn start" ) );
                wprintz( w_flags, c_light_gray, ( "\n" ) );
            } else if( sorted_scens[cur_id]->has_flag( "WIN_START" ) ) {
                wprintz( w_flags, c_light_gray, _( "Winter start" ) );
                wprintz( w_flags, c_light_gray, ( "\n" ) );
            } else if( sorted_scens[cur_id]->has_flag( "SUM_ADV_START" ) ) {
                wprintz( w_flags, c_light_gray, _( "Next summer start" ) );
                wprintz( w_flags, c_light_gray, ( "\n" ) );
            }
            
            if( sorted_scens[cur_id]->has_flag( "INFECTED" ) ) {
                wprintz( w_flags, c_light_gray, _( "Infected player" ) );
                wprintz( w_flags, c_light_gray, ( "\n" ) );
            }
            if( sorted_scens[cur_id]->has_flag( "BAD_DAY" ) ) {
                wprintz( w_flags, c_light_gray, _( "Drunk and sick player" ) );
                wprintz( w_flags, c_light_gray, ( "\n" ) );
            }
            if( sorted_scens[cur_id]->has_flag( "FIRE_START" ) ) {
                wprintz( w_flags, c_light_gray, _( "Fire nearby" ) );
                wprintz( w_flags, c_light_gray, ( "\n" ) );
            }
            if( sorted_scens[cur_id]->has_flag( "SUR_START" ) ) {
                wprintz( w_flags, c_light_gray, _( "Zombies nearby" ) );
                wprintz( w_flags, c_light_gray, ( "\n" ) );
            }
            if( sorted_scens[cur_id]->has_flag( "HELI_CRASH" ) ) {
                wprintz( w_flags, c_light_gray, _( "Various limb wounds" ) );
                wprintz( w_flags, c_light_gray, ( "\n" ) );
            }
            if( get_option<std::string>( "STARTING_NPC" ) == "scenario" &&
               sorted_scens[cur_id]->has_flag( "LONE_START" ) ) {
                wprintz( w_flags, c_light_gray, _( "No starting NPC" ) );
                wprintz( w_flags, c_light_gray, ( "\n" ) );
            }
            if( sorted_scens[cur_id]->has_flag( "BORDERED" ) ) {
                wprintz( w_flags, c_light_gray, _( "Starting location is bordered by an immense wall" ) );
                wprintz( w_flags, c_light_gray, ( "\n" ) );
            }
        }
        
        draw_scrollbar( w, cur_id, iContentHeight, scens_length, point( 0, 5 ) );
        wnoutrefresh( w );
        wnoutrefresh( w_description );
        wnoutrefresh( w_sorting );
        wnoutrefresh( w_profession );
        wnoutrefresh( w_location );
        wnoutrefresh( w_vehicle );
        wnoutrefresh( w_flags );
    } );
    
    do {
        if( recalc_scens ) {
            sorted_scens.clear();
            auto &wopts = world_generator->active_world->WORLD_OPTIONS;
            for( const auto &scen : scenario::get_all() ) {
                if( scen.scen_is_blacklisted() ) {
                    continue;
                }
                if( !lcmatch( scen.gender_appropriate_name( u.male ), filterstring ) ) {
                    continue;
                }
                sorted_scens.push_back( &scen );
            }
            scens_length = sorted_scens.size();
            if( scens_length == 0 ) {
                popup( _( "Nothing found." ) ); // another case of black box in tiles
                filterstring.clear();
                continue;
            }
            
            // Sort scenarios by points.
            // scenario_display_sort() keeps "Evacuee" at the top.
            scenario_sorter.male = u.male;
            scenario_sorter.cities_enabled = wopts["CITY_SIZE"].getValue() != "0";
            std::stable_sort( sorted_scens.begin(), sorted_scens.end(), scenario_sorter );
            
            // If city size is 0 but the current scenario requires cities reset the scenario
            if( !scenario_sorter.cities_enabled && g->scen->has_flag( "CITY_START" ) ) {
                reset_scenario( u, sorted_scens[0] );
                points.init_from_options();
                points.skill_points -= sorted_scens[cur_id]->point_cost();
            }
            
            // Select the current scenario, if possible.
            for( int i = 0; i < scens_length; ++i ) {
                if( sorted_scens[i]->ident() == g->scen->ident() ) {
                    cur_id = i;
                    break;
                }
            }
            if( cur_id > scens_length - 1 ) {
                cur_id = 0;
            }
            
            recalc_scens = false;
        }
        
        ui_manager::redraw();
        const std::string action = ctxt.handle_input();
        if( action == "DOWN" ) {
            cur_id++;
            if( cur_id > scens_length - 1 ) {
                cur_id = 0;
            }
        } else if( action == "UP" ) {
            cur_id--;
            if( cur_id < 0 ) {
                cur_id = scens_length - 1;
            }
        } else if( action == "CONFIRM" ) {
            if( sorted_scens[cur_id]->has_flag( "CITY_START" ) && !scenario_sorter.cities_enabled ) {
                continue;
            }
            reset_scenario( u, sorted_scens[cur_id] );
            points.init_from_options();
            points.skill_points -= sorted_scens[cur_id]->point_cost();
        } else if( action == "PREV_TAB" ) {
            retval = tab_direction::BACKWARD;
        } else if( action == "NEXT_TAB" ) {
            retval = tab_direction::FORWARD;
        } else if( action == "SORT" ) {
            scenario_sorter.sort_by_points = !scenario_sorter.sort_by_points;
            recalc_scens = true;
        } else if( action == "FILTER" ) {
            string_input_popup()
            .title( _( "Search:" ) )
            .width( 60 )
            .description( _( "Search by scenario name." ) )
            .edit( filterstring );
            recalc_scens = true;
        } else if( action == "QUIT" && query_yn( _( "Return to main menu?" ) ) ) {
            retval = tab_direction::QUIT;
        }
    } while( retval == tab_direction::NONE );
    
    return retval;
}
