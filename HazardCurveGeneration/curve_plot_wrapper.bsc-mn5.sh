#!/bin/bash
# AR: My version of curve_plot_wrapper.sh for MareNostrum 5.
# It uses the opensha-cybershake-all.jar I built (Java 17, one jar with every dependency, nshmp-gmm too).
# The first argument is the path to the SQLite database, without the sqlite: prefix. The other
# arguments go to HazardCurvePlotter as they are.

set -o errexit

#AR: (2026-07-03) The script loads its own module, so it works whatever environment calls it,
#AR: for example a COMPSs worker. I don't count on java already being on PATH. It needs Java 17
#AR: or newer, because Gradle 9.5 builds the jar with it, while check_db and insert_dir use
#AR: Java 11. Loading a module that is already loaded does nothing.
source /etc/profile.d/01-module.sh 2>/dev/null || true
module load java-openjdk/17.0.11+9 2>/dev/null || true

OPENSHA_JAR='/gpfs/projects/bsc115/bsc203748/software/OpenSHA/opensha-cybershake/build/libs/opensha-cybershake-all.jar'

DB=$1
shift 1

java -Xms512M -Xmx8G -cp "$OPENSHA_JAR" \
    -Djava.awt.headless=true \
    -Dcybershake.db.host="$DB" \
    org.opensha.sha.cybershake.plot.HazardCurvePlotter "$@"
