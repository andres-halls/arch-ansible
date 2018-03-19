#!/bin/bash

/run.bash & # run original entrypoint in background
run=$! # save PID

# wait until original entrypoint finishes setup
while [ ! -f /._container_setup ]; do sleep 10; done

# if PNP4Nagios setup not already done
if grep -q 'process_performance_data=0' etc/naemon/naemon.cfg; then

echo "Started PNP4Nagios setup"
sed -i 's|process_performance_data=0|process_performance_data=1|' /etc/naemon/naemon.cfg

cat <<'EOT' >> /etc/naemon/naemon.cfg

#
# service performance data
#
service_perfdata_file=/usr/local/pnp4nagios/var/service-perfdata
service_perfdata_file_template=DATATYPE::SERVICEPERFDATA\tTIMET::$TIMET$\tHOSTNAME::$HOSTNAME$\tSERVICEDESC::$SERVICEDESC$\tSERVICEPERFDATA::$SERVICEPERFDATA$\tSERVICECHECKCOMMAND::$SERVICECHECKCOMMAND$\tHOSTSTATE::$HOSTSTATE$\tHOSTSTATETYPE::$HOSTSTATETYPE$\tSERVICESTATE::$SERVICESTATE$\tSERVICESTATETYPE::$SERVICESTATETYPE$
service_perfdata_file_mode=a
service_perfdata_file_processing_interval=15
service_perfdata_file_processing_command=process-service-perfdata-file

#
#
#
host_perfdata_file=/usr/local/pnp4nagios/var/host-perfdata
host_perfdata_file_template=DATATYPE::HOSTPERFDATA\tTIMET::$TIMET$\tHOSTNAME::$HOSTNAME$\tHOSTPERFDATA::$HOSTPERFDATA$\tHOSTCHECKCOMMAND::$HOSTCHECKCOMMAND$\tHOSTSTATE::$HOSTSTATE$\tHOSTSTATETYPE::$HOSTSTATETYPE$
host_perfdata_file_mode=a
host_perfdata_file_processing_interval=15
host_perfdata_file_processing_command=process-host-perfdata-file
EOT

cat <<'EOT' > /etc/naemon/conf.d/pnp4nagios_commands.cfg
define command{
       command_name    process-service-perfdata-file
       command_line    /bin/mv /usr/local/pnp4nagios/var/service-perfdata /usr/local/pnp4nagios/var/spool/service-perfdata.$TIMET$
}

define command{
       command_name    process-host-perfdata-file
       command_line    /bin/mv /usr/local/pnp4nagios/var/host-perfdata /usr/local/pnp4nagios/var/spool/host-perfdata.$TIMET$
}
EOT

cat <<'EOT' >> /etc/naemon/conf.d/templates/hosts.cfg

define host {
   name host-pnp
   process_perf_data 1
   action_url /pnp4nagios/index.php/graph?host=$HOSTNAME$&srv=_HOST_' class='tips' rel='/pnp4nagios/index.php/popup?host=$HOSTNAME$&srv=_HOST_
   register 0
}
EOT

cat <<'EOT' >> /etc/naemon/conf.d/templates/services.cfg

define service {
   name service-pnp
   process_perf_data 1
   action_url /pnp4nagios/index.php/graph?host=$HOSTNAME$&srv=$SERVICEDESC$' class='tips' rel='/pnp4nagios/index.php/popup?host=$HOSTNAME$&srv=$SERVICEDESC$
   register 0
}
EOT

echo 'cookie_path = /' >> /etc/thruk/thruk_local.conf

# enable popups in Thruk
mv /etc/thruk/ssi/status-header.ssi.example /etc/thruk/ssi/status-header.ssi

fi

# ensure pnp4nagios var dir has consistent ownership
chown -R naemon:naemon /usr/local/pnp4nagios/var

service npcd start
wait $run # wait for original entrypoint to exit