#!/bin/bash
# AR: My version of disagg_plot_wrapper.sh for MareNostrum 5, the same as curve_plot_wrapper.bsc-mn5.sh.
# It uses the same opensha-cybershake-all.jar I built (Java 17, one jar with every dependency).
# The first argument is the path to the SQLite database, without the sqlite: prefix. The other
# arguments go to DisaggregationPlotter as they are, and -ef <ERF XML file> is required by it.

set -o errexit

#AR: (2026-07-03) The script loads its own module for the same reason as in
#AR: curve_plot_wrapper.bsc-mn5.sh, so I don't count on the caller, for example a COMPSs
#AR: worker, already having the right Java on PATH. It needs Java 17 or newer, like curve_calc.
source /etc/profile.d/01-module.sh 2>/dev/null || true
module load java-openjdk/17.0.11+9 2>/dev/null || true

OPENSHA_JAR='/gpfs/projects/bsc115/bsc203748/software/OpenSHA/opensha-cybershake/build/libs/opensha-cybershake-all.jar'

DB=$1
shift 1

java -Xms512M -Xmx8G -cp "$OPENSHA_JAR" \
    -Djava.awt.headless=true \
    -Dcybershake.db.host="$DB" \
    org.opensha.sha.cybershake.plot.DisaggregationPlotter "$@"
