#!/usr/bin/env bash

# Copyright 2014 Alexander Fahlke
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

BUNDLE_FILTER=$1

if [ ! -f "${OOZIE_TOOL_CONF_DIR}/config.ini" ]; then
	echo "config.ini not found!"
	exit 2
fi
source "${OOZIE_TOOL_CONF_DIR}/config.ini"

# get all running bundles
OOZIE_RUNNING_BUNDLES=$(${OOZIE_BIN} jobs -oozie http://${OOZIE_HOSTNAME}:${OOZIE_PORT}/oozie -jobtype bundle -len 10000 -filter status=RUNNING | grep -vE "^------|^Job" | awk '{print $1}')

# run script for getting the coordinators for each bundle
for bid in ${OOZIE_RUNNING_BUNDLES[@]}
do
	${OOZIE_TOOL_LIBEXEC_DIR}/getCoordinatorsByBundleID.sh ${bid} ${BUNDLE_FILTER}
done
