#!/bin/bash -xe

export CINDER_DIR=./cinder
export CINDER_REPO_URL=https://git.openstack.org/openstack/cinder
export CINDER_TEST_DIR=cinder/tests/unit
export INFORTREND_DRIVER_DIR=cinder/volume/drivers/infortrend

if [ -d "$CINDER_DIR" ]; then
    rm -rf $CINDER_DIR
fi

git clone $CINDER_REPO_URL --depth=1

if [ ! -d "$CINDER_DIR/$INFORTREND_DRIVER_DIR" ]; then
    mkdir $CINDER_DIR/$INFORTREND_DRIVER_DIR
fi

cp ./src/* $CINDER_DIR/$INFORTREND_DRIVER_DIR/ -r
cp ./test/* $CINDER_DIR/$CINDER_TEST_DIR/ -r

cd $CINDER_DIR

tox -v -epy34 -- cinder.tests.unit.InfortrendCLITestCase.test_cli_all_command_execute
tox -v -epy34 -- cinder.tests.unit.InfortrendCLITestCase

./run_tests.sh -p -N

cd ..
