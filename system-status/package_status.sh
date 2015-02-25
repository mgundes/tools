
DEB_ARCHIVE_DIR=/var/cache/apt/archives/


f_blueprint() {
    [ $# -eq 0 ] && return
    
    echo -e "$(tput setaf 4) $@ $(tput sgr0)"
}

f_package_installed() {
    f_blueprint "\ninstalled package number: "
    echo -e "`dpkg -l | wc -l`\n"
}

f_package_state_anomaly() {
    f_blueprint "\nCheck if there is any package in anormal state..\n"
    show="false"
    dpkg -l | grep -v ^ii | while read line;
                            do
                                 if [ "$show" = "true" -a "${line:2:1}" = " " ]; then
                                     echo $line
                                 fi
                                 state=${line:0:2}
                                 if [ "$state" == "++" ]; then
                                     show="true"
                                 fi
                            done
    echo
}

f_package_state_notconfigured() {
    f_blueprint "\nCheck if there is any package not configured properly..\n"
    show="false"
    dpkg -l | grep -v ^ii | while read line;
                            do
                                 state=${line:0:2}
                                 if test "$show" = "true" && `grep "c" <<< "$state" &> /dev/null`; then
                                     echo $line
                                 fi
                                 if [ "$state" == "++" ]; then
                                     show="true"
                                 fi
                            done
    echo
}

f_package_downloaded_deb_size() {
    f_blueprint "\nCalculate downloaded deb file size.."
    du -sh ${DEB_ARCHIVE_DIR} | awk -F " " '{print $1}'
    echo
}

f_package_status() {

    f_package_installed
    f_package_state_anomaly
    f_package_state_notconfigured
    f_package_downloaded_deb_size
}


