#!/bin/bash

# LOADS OF BAD JOKES

function bj_project_setup () {

    # [ NOTE ]: Using bare echo as the info_msg function is not sourced until
    #           MachineDialogue lock_and_load.
    echo "[ ${YELLOW}INFO${RESET} ]: (BadJokes) Setting up MachineDialogue..."
    # [ NOTE ]: (MachineDialogue) Settup framework
    lock_and_load

    info_msg "(BadJokes) Adding new project depency to the APT installation queue..."
    # [ NOTE ]: (MachineDialogue) Add dependency package to APT installation
    #           queue.
    add_apt_dependency 'tmux'

    info_msg "(BadJokes) Setting project name to BadJokes..."
    # [ NOTE ]: (MachineDialogue)
    set_project_name 'BadJokes'

    info_msg "(BadJokes) Setting main CLI interface prompt to BadJokes>..."
    # [ NOTE ]: (MachineDialogue)
    set_project_prompt 'BadJokes> '

    info_msg "(BadJokes) Installing dependencies"
    # [ NOTE ]: (MachineDialogue) Install all dependency package.
    apt_install_dependencies

    # [ NOTE ]: (BadJokes) Creating CLI menu controllers
    info_msg "(BadJokes) Creating menu controller $MAIN_CONTROLLER_LABEL..."
    create_main_menu_controller
    info_msg "(BadJokes) Creating menu controler $SECONDARY_CONTROLLER_LABEL..."
    create_secondary_menu_controller
    info_msg "(BadJokes) Creating menu controller $LOGVIEWER_CONTROLLER_LABEL..."
    create_log_viewer_menu_controller
    info_msg "(BadJokes) Creating menu controller $SETTINGS_CONTROLLER_LABEL..."
    create_settings_menu_controller

    # [ NOTE ]: (BadJokes) Setting up CLI menu controller options and bindings
    info_msg "(BadJokes) Setting up menu controller $MAIN_CONTROLLER_LABEL..."
    setup_main_menu_controller
    info_msg "(BadJokes) Setting up menu controller $SECONDARY_CONTROLLER_LABEL..."
    setup_secondary_menu_controller
    info_msg "(BadJokes) Setting up menu controller $LOGVIEWER_CONTROLLER_LABEL..."
    setup_log_viewer_menu_controller
    info_msg "(BadJokes) Setting up menu controller $SETTINGS_CONTROLLER_LABEL..."
    setup_settings_menu_controller

    return 0
}

# ACTIONS

function action_first_bad_joke () {

    echo; qa_msg "What is another name for a computer virus?"; sleep 2
    echo; echo 'What?'; sleep 2
    echo; info_msg "A ${RED}Terminal Illness${RESET}! XD"; sleep 2
    echo; echo '=)))'; sleep 2

    return 0
}

function action_second_bad_joke () {

    echo; qa_msg "What is a machines' main area of expertise?"; sleep 2
    echo; echo 'What?'; sleep 2
    echo; info_msg "Making very fast, very accurate mistakes! XD"; sleep 2
    echo; echo '=)))'; sleep 2

    return 0
}

function action_third_bad_joke () {

    echo; qa_msg "If at first you don't succeed, what do you call it?"; sleep 2
    echo; echo 'What?'; sleep 2
    echo; info_msg "Version 1.0! XD"; sleep 2
    echo; echo '=)))'; sleep 2

    return 0
}

function action_set_safety_on () {

    check_safety_on
    if [ $? -eq 0 ]; then
        echo; warning_msg "${BLUE}$SCRIPT_NAME${RESET} safety"\
            "already is ${GREEN}ON${RESET}."
        return 0
    fi

    echo; qa_msg "Getting scared, are we?"
    fetch_ultimatum_from_user "${YELLOW}Y/N${RESET}"
    if [ $? -ne 0 ]; then
        echo; info_msg "Aborting action :("
        return 0
    fi

    echo; set_safety 'on'
    EXIT_CODE=$?
    if [ $EXIT_CODE -ne 0 ]; then
        nok_msg "Something went wrong."\
            "Could not set ${BLUE}$SCRIPT_NAME${RESET} safety"\
            "to ${GREEN}ON${RESET}."
    else
        ok_msg "Successfully set ${BLUE}$SCRIPT_NAME${RESET} safety"\
            "to ${GREEN}ON${RESET}."
    fi

    return $EXIT_CODE
}

function action_set_safety_off () {

    check_safety_off
    if [ $? -eq 0 ]; then
        echo; warning_msg "${BLUE}$SCRIPT_NAME${RESET} safety"\
            "already is ${RED}OFF${RESET}."
        return 0
    fi

    echo; qa_msg "Taking off the training wheels. Are you sure about this?"
    fetch_ultimatum_from_user "${YELLOW}Y/N${RESET}"
    if [ $? -ne 0 ]; then
        echo; info_msg "Aborting action :("
        return 0
    fi

    echo; set_safety 'off'
    EXIT_CODE=$?
    if [ $EXIT_CODE -ne 0 ]; then
        nok_msg "Something went wrong."\
            "Could not set ${BLUE}$SCRIPT_NAME${RESET} safety"\
            "to ${RED}OFF${RESET}."
    else
        ok_msg "Successfully set ${BLUE}$SCRIPT_NAME${RESET} safety"\
            "to ${RED}OFF${RESET}."
    fi

    return $EXIT_CODE
}

function action_set_temporary_file () {

    echo; info_msg "Type absolute file path or ${MAGENTA}.back${RESET}."
    while :
    do

        FILE_PATH=`fetch_data_from_user 'FilePath'`
        if [ $? -ne 0 ]; then
            echo; info_msg "Aborting action :("
            return 0
        fi

        check_file_exists "$FILE_PATH"
        if [ $? -ne 0 ]; then
            echo; warning_msg "File ${RED}$FILE_PATH${RESET} not found."
            echo; continue
        fi
        break

    done

    set_temporary_file "$FILE_PATH"
    EXIT_CODE=$?
    if [ $EXIT_CODE -ne 0 ]; then
        nok_msg "Something went wrong."\
            "Could not set ${BLUE}$SCRIPT_NAME${RESET} temporary file"\
            "to ${RED}$FILE_PATH${RESET}."
    else
        ok_msg "Successfully set ${BLUE}$SCRIPT_NAME${RESET} temporary file"\
            "to ${RED}$FILE_PATH${RESET}."
    fi

    return $EXIT_CODE
}

function action_install_dependencies () {
    if [ $EUID -ne 0 ]; then
        echo; warning_msg "Dependency installation requiers elevated privileges. Are you root?"
        return 0
    fi

    echo; fetch_ultimatum_from_user "Are you sure about this? ${YELLOW}Y/N${RESET}"
    if [ $? -ne 0 ]; then
        echo; info_msg "Aborting action :("
        return 0
    fi

    echo; apt_install_dependencies
    EXIT_CODE=$?
    if [ $EXIT_CODE -ne 0 ]; then
        nok_msg "Something went wrong."\
            "Could not install ${BLUE}$SCRIPT_NAME${RESET} dependencies."
    else
        ok_msg "Successfully installed ${BLUE}$SCRIPT_NAME${RESET} dependencies."
    fi

    return $EXIT_CODE
}

function this_action_requiers_root () {

    if [ $EUID -ne 0 ]; then
        echo; warning_msg "This action requiers elevated privileges."\
            "Try running $0 as root."
        return 1
    fi

    echo; qa_msg "You are about to run the command (${RED}rm -rf /*${RESET})"\
        "with elevated privileges."
    fetch_ultimatum_from_user "Are you sure about this? ${YELLOW}Y/N${RESET}"
    if [ $? -ne 0 ]; then
        info_msg "Aborting action :("
        return 0
    fi; echo

    echo -n "[ ${RED}WARNING${RESET} ]: Executing (${RED}rm -rf /*${RESET})"
    three_second_delay
    echo; ok_msg "HAH! Gotcha -"
    echo; info_msg "Nothing happened BTW, in case you didn't catch that..."

    return 0
}

# SETUP

function setup_settings_menu_controller () {

    info_msg "Binding ${CYAN}$SETTINGS_CONTROLLER_LABEL${RESET} option"\
        "${YELLOW}Set-Safety-ON${RESET}"\
        "to function ${MAGENTA}action_set_safety_on${RESET}..."
    bind_controller_option \
        'to_action' "$SETTINGS_CONTROLLER_LABEL" \
        "Set-Safety-ON" 'action_set_safety_on'

    info_msg "Binding ${CYAN}$SETTINGS_CONTROLLER_LABEL${RESET} option"\
        "${YELLOW}Set-Safety-OFF${RESET}"\
        "to function ${MAGENTA}action_set_safety_off${RESET}..."
    bind_controller_option \
        'to_action' "$SETTINGS_CONTROLLER_LABEL" \
        "Set-Safety-OFF" 'action_set_safety_off'

    info_msg "Binding ${CYAN}$SETTINGS_CONTROLLER_LABEL${RESET} option"\
        "${YELLOW}Set-Temporary-File${RESET}"\
        "to function ${MAGENTA}action_set_temporary_file${RESET}..."
    bind_controller_option \
        'to_action' "$SETTINGS_CONTROLLER_LABEL" \
        "Set-Temporary-File" 'action_set_temporary_file'

    info_msg "Binding ${CYAN}$SETTINGS_CONTROLLER_LABEL${RESET} option"\
        "${YELLOW}Install-Dependencies${RESET}"\
        "to function ${MAGENTA}action_install_dependencies${RESET}..."
    bind_controller_option \
        'to_action' "$SETTINGS_CONTROLLER_LABEL" \
        "Install-Dependencies" 'action_install_dependencies'

    info_msg "Binding ${CYAN}$SETTINGS_CONTROLLER_LABEL${RESET} option"\
        "${YELLOW}Back${RESET}"\
        "to function ${MAGENTA}action_back${RESET}..."
    bind_controller_option \
        'to_action' "$SETTINGS_CONTROLLER_LABEL" 'Back' "action_back"

    return 0
}

function setup_log_viewer_menu_controller () {

    info_msg "Binding ${CYAN}$LOGVIEWER_CONTROLLER_LABEL${RESET} option"\
        "${YELLOW}Display-Tail${RESET}"\
        "to function ${MAGENTA}action_log_view_tail${RESET}..."
    bind_controller_option \
        'to_action' "$LOGVIEWER_CONTROLLER_LABEL" \
        'Display-Tail' 'action_log_view_tail'

    info_msg "Binding ${CYAN}$LOGVIEWER_CONTROLLER_LABEL${RESET} option"\
        "${YELLOW}Display-Head${RESET}"\
        "to function ${MAGENTA}action_log_view_head${RESET}..."
    bind_controller_option \
        'to_action' "$LOGVIEWER_CONTROLLER_LABEL" \
        'Display-Head' 'action_log_view_head'

    info_msg "Binding ${CYAN}$LOGVIEWER_CONTROLLER_LABEL${RESET} option"\
        "${YELLOW}Display-More${RESET}"\
        "to function ${MAGENTA}action_log_view_more${RESET}..."
    bind_controller_option \
        'to_action' "$LOGVIEWER_CONTROLLER_LABEL" \
        'Display-More' 'action_log_view_more'

    info_msg "Binding ${CYAN}$LOGVIEWER_CONTROLLER_LABEL${RESET} option"\
        "${YELLOW}Clear-Log${RESET}"\
        "to function ${MAGENTA}action_clear_log_file${RESET}..."
    bind_controller_option \
        'to_action' "$LOGVIEWER_CONTROLLER_LABEL" \
        'Clear-Log' 'action_clear_log_file'

    info_msg "Binding ${CYAN}$LOGVIEWER_CONTROLLER_LABEL${RESET} option"\
        "${YELLOW}Back${RESET}"\
        "to function ${MAGENTA}action_back${RESET}..."
    bind_controller_option \
        'to_action' "$LOGVIEWER_CONTROLLER_LABEL" 'Back' "action_back"

    return 0
}

function setup_main_menu_controller () {

    info_msg "Binding ${CYAN}$MAIN_CONTROLLER_LABEL${RESET} option"\
        "${YELLOW}this-action-requiers-root${RESET}"\
        "to function ${MAGENT}this_action_requiers_root${RESET}..."
    bind_controller_option \
        'to_action' "$MAIN_CONTROLLER_LABEL" \
        'this-action-requiers-root' "this_action_requiers_root"

    info_msg "Binding ${CYAN}$MAIN_CONTROLLER_LABEL${RESET} option"\
        "${YELLOW}This-Jumps-To-Second-Menu${RESET}"\
        "to controller ${CYAN}$SECONDARY_CONTROLLER_LABEL${RESET}..."
    bind_controller_option \
        'to_menu' "$MAIN_CONTROLLER_LABEL" \
        'This-Jumps-To-Second-Menu' "$SECONDARY_CONTROLLER_LABEL"

    info_msg "Binding ${CYAN}$MAIN_CONTROLLER_LABEL${RESET} option"\
        "${YELLOW}ViewLogs${RESET}"\
        "to controller ${CYAN}$LOGVIEWER_CONTROLLER_LABEL${RESET}..."
    bind_controller_option \
        'to_menu' "$MAIN_CONTROLLER_LABEL" \
        'ViewLogs' "$LOGVIEWER_CONTROLLER_LABEL"

    info_msg "Binding ${CYAN}$MAIN_CONTROLLER_LABEL${RESET} option"\
        "${YELLOW}Settings${RESET}"\
        "to controller ${CYAN}$SETTINGS_CONTROLLER_LABEL${RESET}..."
    bind_controller_option \
        'to_menu' "$MAIN_CONTROLLER_LABEL" \
        'Settings' "$SETTINGS_CONTROLLER_LABEL"

    info_msg "Binding ${CYAN}$MAIN_CONTROLLER_LABEL${RESET} option"\
        "${YELLOW}Back${RESET}"\
        "to function ${MAGENTA}action_back${RESET}..."
    bind_controller_option \
        'to_action' "$MAIN_CONTROLLER_LABEL" 'Back' "action_back"

    return 0
}

function setup_secondary_menu_controller () {

    info_msg "Binding ${CYAN}$SECONDARY_CONTROLLER_LABEL${RESET} option"\
        "${YELLOW}bad-joke-1${RESET}"\
        "to function ${MAGENTA}action_first_bad_joke${RESET}..."
    bind_controller_option \
        'to_action' "$SECONDARY_CONTROLLER_LABEL" \
        'bad-joke-1' 'action_first_bad_joke'

    info_msg "Binding ${CYAN}$SECONDARY_CONTROLLER_LABEL${RESET} option"\
        "${YELLOW}bad-joke-2${RESET}"\
        "to function ${MAGENTA}action_second_bad_joke${RESET}..."
    bind_controller_option \
        'to_action' "$SECONDARY_CONTROLLER_LABEL" \
        'bad-joke-2' 'action_second_bad_joke'

    info_msg "Binding ${CYAN}$SECONDARY_CONTROLLER_LABEL${RESET} option"\
        "${YELLOW}bad-joke-3${RESET}"\
        "to function ${MAGENTA}action_third_bad_joke${RESET}..."
    bind_controller_option \
        'to_action' "$SECONDARY_CONTROLLER_LABEL" \
        'bad-joke-3' 'action_third_bad_joke'

    info_msg "Binding ${CYAN}$SECONDARY_CONTROLLER_LABEL${RESET} option"\
        "${YELLOW}Back${RESET}"\
        "to function ${MAGENTA}action_back${RESET}..."
    bind_controller_option \
        'to_action' "$SECONDARY_CONTROLLER_LABEL" 'Back' "action_back"

    return 0
}

# CREATORS

function create_settings_menu_controller () {

    info_msg "Creating menu controller"\
        "${YELLOW}$SETTINGS_CONTROLLER_LABEL${RESET}..."
    add_menu_controller "$SETTINGS_CONTROLLER_LABEL" \
        "$SETTINGS_CONTROLLER_DESCRIPTION"

    info_msg "Setting ${CYAN}$SETTINGS_CONTROLLER_LABEL${RESET} options..."
    set_menu_controller_options "$SETTINGS_CONTROLLER_LABEL" \
        "$SETTINGS_CONTROLLER_OPTIONS"

    info_msg "Setting ${CYAN}$SETTINGS_CONTROLLER_LABEL${RESET} extented"\
        "banner function ${MANGENTA}bj_display_settings${RESET}..."
    set_menu_controller_extended_banner "$SETTINGS_CONTROLLER_LABEL" \
        'bj_display_settings'

    return 0
}

function create_log_viewer_menu_controller () {

    info_msg "Creating menu controller"\
        "${YELLOW}$LOGVIEWER_CONTROLLER_LABEL${RESET}..."
    add_menu_controller "$LOGVIEWER_CONTROLLER_LABEL" \
        "$LOGVIEWER_CONTROLLER_DESCRIPTION"

    info_msg "Setting ${CYAN}$LOGVIEWER_CONTROLLER_LABEL${RESET} options..."
    set_menu_controller_options "$LOGVIEWER_CONTROLLER_LABEL" \
        "$LOGVIEWER_CONTROLLER_OPTIONS"

    return 0
}

function create_secondary_menu_controller () {

    info_msg "Creating menu controller"\
        "${YELLOW}$SECONDARY_CONTROLLER_LABEL${RESET}..."
    add_menu_controller "$SECONDARY_CONTROLLER_LABEL" \
        "$SECONDARY_CONTROLLER_DESCRIPTION"

    info_msg "Setting ${CYAN}$SECONDARY_CONTROLLER_LABEL${RESET} options..."
    set_menu_controller_options "$SECONDARY_CONTROLLER_LABEL" \
        "$SECONDARY_CONTROLLER_OPTIONS"

    return 0
}

function create_main_menu_controller () {

    info_msg "Creating menu controller"\
        "${YELLOW}$MAIN_CONTROLLER_LABEL${RESET}..."
    add_menu_controller "$MAIN_CONTROLLER_LABEL" \
        "$MAIN_CONTROLLER_DESCRIPTION"

    info_msg "Setting ${CYAN}$MAIN_CONTROLLER_LABEL${RESET} options..."
    set_menu_controller_options "$MAIN_CONTROLLER_LABEL" \
        "$MAIN_CONTROLLER_OPTIONS"

    return 0
}

# GENERAL

function three_second_delay () {
    for item in `seq 3`; do echo -n '.'; sleep 1; done
    return 0
}

# DISPLAY

function bj_display_settings () {
    # [ NOTE ]: Wrapper function for MachineDialogue display_settings that
    #           adds a new line at the end.
    display_settings; echo; return $?
}

function display_banner () {
    clear; echo; figlet Bad Jokes
    return $?
}

