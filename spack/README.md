SPACK procedures
========

first clone spack to a new major version

https://github.com/spack/spack

And put it into a new folder, somethig like what we're expecting the version to be

    git clone -c feature.manyFiles=true https://github.com/spack/spack.git spack_v18

Then checkout the release we want to use into a new branch

    cd spack_v18
    git checkout -b v0.18 origin/releases/v0.18

Then copy in our customizations

    cp ../spack_old/etc/spack/*.yaml etc/spack/

Edit the config.yaml and modules.yaml to give the new paths for install tree's and modules

    s/\/apps\/spack_old\/software/\/apps\/spack_v18\/software/g
    s/\/apps\/spack_old\/modulefiles/\/apps\/spack_v18\/modulefiles/g

create that new spack share in apps

    ssh zfs01
    zfs create storage/apps/spack_v18

Add that new path to .modulespath for lmod on head, and copy to all nodes
Note, this will have to change if we move to lmod modules instead of tcl ones.  for now
though, I can't get them to work with spack.

    echo "/apps/spack_v18/modulefiles/tcl" >> /usr/share/lmod/lmod/init/.modulespath
    cv-cp -g login,nodes,gpu,himem,viz /usr/share/lmod/lmod/init/.modulespath /usr/share/lmod/lmod/init

Edit the head's sourcing script for spack

    vim /root/spack.sh
    s/spack_old/spack_v18/g

Source spack setup script

    source /root/spack.sh

Test install


EXTREMELY IMPORTANT NOTE ABOUT MODULES!!!!!!!!!

Any new pieces of software you want lmod modules created for, you may need to edit $SPACK_ROOT/etc/spack/modules.yaml
and add their name or dependency into that file.  We hide most modules by prepending a '.' to their name, and only
build visible lmod module files for explicitly listed packages in modules.yaml
