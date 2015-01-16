#!/bin/sh

# @version	2011-12-29
# @see		http://pvr.unzureichende.info/synology
# @env		run by DSM, SYNOPKG_PKGDEST example "/volume1/@appstore/minidlna"

[ ${SYNOPKG_PKGDEST} ] || SYNOPKG_PKGDEST=`ls -l /var/packages/minidlna/target | cut -d\> -f2 | cut -d\  -f2`
MINIDLNA_VOLUME=`echo ${SYNOPKG_PKGDEST} | cut -d/ -f2`
MINIDLNA_PIDF=/usr/local/var/run/minidlna.pid
MINIDLNA_CONF=/usr/local/etc/minidlna.conf
. /usr/local/bin/import-environment
export LD_LIBRARY_PATH=${SYNOPKG_PKGDEST}/lib:${LD_LIBRARY_PATH}

checkShares() {
	grep '^media_dir=' ${MINIDLNA_CONF} >/dev/null 2>&1
	if [ $? -eq 1 ]; then
		echo "Edit minidlna.conf (Menu) and add shares before starting." >${SYNOPKG_PKGDEST}/synology.out
		if [ $1 -eq 1 ]; then
			echo "Edit minidlna.conf (refresh DSM, top menu icon) and add shares before starting." >${SYNOPKG_TEMP_LOGFILE}
			exit 1
		fi
		if [ $1 -eq 2 ]; then
			echo "ERROR: add shares first, edit ${SYNOPKG_PKGDEST}/etc/minidlna.conf or use integrated CFE"
			exit 1
		fi
		return 0
	fi
	return 1
}

runminidlna() {
	su minidlna -s /bin/sh -c "${SYNOPKG_PKGDEST}/bin/minidlnad -f ${MINIDLNA_CONF} -P ${MINIDLNA_PIDF} $1"
}

case $1 in
	start)	checkShares 1
			if [ ! -e ${MINIDLNA_PIDF} ]; then
				echo "starting MiniDLNA"
				runminidlna ''
			fi
			;;
	stop)	echo "stopping MiniDLNA"
			if [ -e ${MINIDLNA_PIDF} ]; then
				kill `cat ${MINIDLNA_PIDF}`
				rm ${MINIDLNA_PIDF}
				sleep 2
			fi
			killall -q -9 minidlnad
			;;
	status)	exit 0
			;;
	debug)	checkShares 2 
			echo "starting MiniDLNA in foreground (debug mode -d)"
			runminidlna -d
			;;
	rescan)	checkShares 2
			echo "starting MiniDLNA -R (ful rescan)"
			runminidlna -R
			;;
	log)	if [ ! checkShares 0 ]; then
				if [ -s "${SYNOPKG_PKGDEST}/var/log/minidlna.log" ]; then
					echo "<html><body><pre>" >${SYNOPKG_PKGDEST}/synology.out
					cat "${SYNOPKG_PKGDEST}/var/log/minidlna.log" >>${SYNOPKG_PKGDEST}/synology.out
					echo "</pre></body></html>" >>${SYNOPKG_PKGDEST}/synology.out
				else
					echo "MiniDLNA is correctly installed, see more at ${SYNOPKG_PKGDEST}/var/log/" >${SYNOPKG_PKGDEST}/synology.out
				fi
			fi
			echo "${SYNOPKG_PKGDEST}/synology.out"                                                
			;;
	*)		echo -e "MiniDLNA .spk\nusage:\n\t$0 (start|stop|status|log|debug|rescan)\n"
			;;
esac
exit 0

