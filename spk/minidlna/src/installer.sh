#!/bin/sh

# Package
PACKAGE="minidlna"
DNAME="miniDLNA"

# Others
INSTALL_DIR="/usr/local/${PACKAGE}"
SSS="/var/packages/${PACKAGE}/scripts/start-stop-status"
PATH="${INSTALL_DIR}/bin:/usr/local/bin:/bin:/usr/bin:/usr/syno/bin"
USER="minidlna"
GROUP="users"
CFG_FILE="${INSTALL_DIR}/etc/minidlna.conf"
TMP_DIR="${SYNOPKG_PKGDEST}/../../@tmp"


preinst ()
{
    exit 0
}

postinst ()
{
    # Link
    ln -s ${SYNOPKG_PKGDEST} ${INSTALL_DIR}

    # Create user
    adduser -h ${INSTALL_DIR}/var -g "${DNAME} daemon user" -G ${GROUP} -s /bin/csh -S -D ${USER}

    # Edit the configuration according to the wizard

    # Correct the files ownership
    chown -R ${USER} ${SYNOPKG_PKGDEST}

    # always generate default config for CFE original
    HOSTNAME=`hostname`
    echo "friendly_name=MiniDLNA [${HOSTNAME}]" >>${INSTALL_DIR}/etc/minidlna.conf
    echo "db_dir=${SYNOPKG_PKGDEST}/var/cache" >>${INSTALL_DIR}/etc/minidlna.conf
    echo "log_dir=${SYNOPKG_PKGDEST}/var/log" >>${INSTALL_DIR}/etc/minidlna.conf
    echo "#EOF." >>${INSTALL_DIR}/etc/minidlna.conf

    exit 0
}

preuninst ()
{
    # Stop the package
    ${SSS} stop > /dev/null

    # Remove the user (if not upgrading)
    if [ "${SYNOPKG_PKG_STATUS}" != "UPGRADE" ]; then
        delgroup ${USER} ${GROUP}
        deluser ${USER}
    fi

    exit 0
}

postuninst ()
{
    # Remove link
    rm -f ${INSTALL_DIR}

    exit 0
}

preupgrade ()
{
    # Stop the package
    ${SSS} stop > /dev/null

    # Save some stuff
    rm -fr ${TMP_DIR}/${PACKAGE}
    mkdir -p ${TMP_DIR}/${PACKAGE}
    mv ${INSTALL_DIR}/var ${TMP_DIR}/${PACKAGE}/
    mv ${INSTALL_DIR}/etc/minidlna.conf ${TMP_DIR}/${PACKAGE}/minidlna_tmp_upgrade

    exit 0
}

postupgrade ()
{
    # Restore some stuff
    rm -fr ${INSTALL_DIR}/var
    mv ${TMP_DIR}/${PACKAGE}/var ${INSTALL_DIR}/
    mv ${TMP_DIR}/${PACKAGE}/minidlna_tmp_upgrade ${INSTALL_DIR}/etc/
    rm -fr ${TMP_DIR}/${PACKAGE}

    exit 0
}
