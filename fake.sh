#!/bin/bash
if test "$OS" = "Windows_NT"
then
  # use .Net
  [ ! -f .paket/paket.exe ] && .paket/paket.bootstrapper.exe
  .paket/paket.exe restore
  packages/FAKE/tools/FAKE.exe fsblog.fsx $@
else
  # use mono
  [ ! -f .paket/paket.exe ] && mono --runtime=v4.0 .paket/paket.bootstrapper.exe
  mono --runtime=v4.0 .paket/paket.exe restore
  mono --runtime=v4.0 packages/FAKE/tools/FAKE.exe $@ --fsiargs -d:MONO fsblog.fsx
fi
