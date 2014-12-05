#!/bin/bash

ver=3.4.2
install_dir=$PWD/$ver

source ../gen_modules.sh

print_header rabbitmq $ver
print_modline "prepend-path PATH $install_dir/sbin"
print_modline "prepend-path MANPATH $install_dir/share/man"
print_modline "setenv RABBITMQ_HOME $install_dir"
print_modline "setenv RABBITMQ_MNESIA_BASE $install_dir/var/lib/rabbitmq/mnesia"
print_modline "setenv RABBITMQ_LOG_BASE $install_dir/var/log/rabbitmq"
