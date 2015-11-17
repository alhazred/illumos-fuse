illumos-fuse
==================

*Driver for FUSE on illumos (based on OpenSolaris fuse code)*

build & install
===============

Install prerequisites:
 - GCC

Build FUSE (in both directories):
``` 
# export PATH=$PATH:/opt/gcc-5.1.0/bin:/opt/onbld/bin/i386

# make
# make install
```
IPS Packaging:
 - Use manifests in pkg directories

Build sshfs (assuming you have driver and library installed):
``` 
# cd sshfs-fuse && configure && gmake install
```
