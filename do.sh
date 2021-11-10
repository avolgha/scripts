#!/usr/bin/env bash

##
## This script was created with purpose on testing, so it will not have any
## high rated features and speed improvements in it
## Feel free to edit this script and do whatever you want to do with it, except
## giving it out as YOUR content
##
## ~ avolgha (Marius), 10 Nov 2021
##

# **Syntax**:
# <do>
# - info
# - update
# - upgrade (+ update)
# - generate
#   - cpp, c
#   - js
#   - ts

color_reset="$(tput sgr0)"
color_info="$(tput setaf 2)"
color_error="$(tput setaf 1)"
color_prompt="$(tput setaf 6)"
color_white="$(tput setaf 7)"

info() { echo "${color_info}info:${color_white}  ${1}${color_reset}"
}

error() { echo "${color_error}error:${color_white} ${1}${color_reset}" 
}

fatal() { echo "${color_error}fatal:${color_white} ${1} ${color_reset}" && exit 1
}

acceptFunction() {
	while true; do
		read -p "${color_prompt}prompt:${color_white} $* ${color_white}[${color_info}y${color_white}/${color_error}n${color_white}]: " yn
		case "$yn" in
			[YyJj]*) return 0 ;;
			[Nn]*) return 1 ;;
		esac
	done
}

update() {
	msg="$(sudo pacman -Syy)"
	ret="$?"

	if [ ! $ret -eq 0 ]; then
		echo "${color_error}fatal: exited program with status code '$(ret)'. This might helps you to find the error:"
		echo "$msg"
		exit 1
	fi
}

upgrade() {
	update

	msg="$(sudo pacman -Syyu)"
	ret="$?"

	if [ ! $ret -eq 0 ]; then
		echo "${color_error}fatal: exited program with status code '$(ret)'. This might helps you to find the error:"
		echo "$msg"
		exit 1
	fi
}

parse_arguments() {
	update=0
	upgrade=0
	generate=0
	for arg in "$@"; do
		case "$arg" in
		"--update")
			if [ $update -eq 1 ]; then
				error "cannot set argument '$arg' twice"
			else
				update=1
			fi ;;
		"--upgrade" | "-u")
			if [ $upgrade -eq 1 ]; then
				error "cannot set argument '$arg' twice"
			else
				upgrade=1 
			fi ;;
		"--info" | "-i")
			neofetch
			exit 0 ;;
		"--generate" | "-g")
			if [ $generate -eq 1 ]; then
				error "cannot set argument '$arg' twice"
			else
				generate=1
			fi ;;
		*)
			error "unknown argument: '$arg'" ;;
		esac
	done

	if [ $update -eq 1 ]; then
		update
		info "successfull system repository update"
	elif [ $upgrade -eq 1 ]; then
		upgrade
		info "successfull system upgrade"

		if $(acceptFunction "do you want to do a system reboot?"); then
			reboot
		fi
	elif [ $generate -eq 1 ]; then
		echo "still in progress lol..."
	else
		echo "${color_error}fatal:${color_white} please provide any of these arguments:"
		echo "${color_error}fatal:${color_white}        '--update'"
		echo "${color_error}fatal:${color_white} '-u' | '--upgrade'"
		echo "${color_error}fatal:${color_white} '-i' | '--info'"
		echo "${color_error}fatal:${color_white} '-g' | '--generate'"
		exit 1
	fi
}

parse_arguments $@ && exit 0
