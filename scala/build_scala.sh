#!/bin/bash

ver=2.11.4

rpm_file=scala-$ver.rpm
[ -f $rpm_file ] || wget http://downloads.typesafe.com/scala/$ver/$rpmxs

rpm2cpio $rpm_file | cpio -idmv
