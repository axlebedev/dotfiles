#!/bin/bash
STATUS="$(nmcli con | grep OfficeKiev)";

if [[ $STATUS = *"--"* ]];
then
  echo 0
else
  echo 1
fi
