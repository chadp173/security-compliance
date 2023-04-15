FROM opensuse:leap

# Install mksusecd
RUN zypper -n install mksusecd wget p7zip tar git

WORKDIR /isos

# retrieve isos from slemaster (temporary only)
RUN wget -q http://slemaster.us.cray.com/distro/sle/15/release/GM/SLE-15-Installer-DVD-x86_64-GM-DVD1.iso

WORKDIR /build

# extract iso ( could mount it, but that requires root )
RUN 7z x /isos/SLE-15-Installer-DVD-x86_64-GM-DVD1.iso -o/build/build_me/

WORKDIR /build
# clone repo and copy over required files ( autoinst.xml at a minimum )
RUN git clone https://kkelling@stash.us.cray.com/scm/mtl/sles.git
WORKDIR /build/sles
RUN git pull
RUN cp /build/sles/sles15/autoinst.xml /build/build_me/

# remove junk dirs from builddir
# this is because we are just extracting the iso, and not mounting it
RUN rm -rf /build/build_me/\[BOOT\]/
RUN rm -rf /build/build_me/*CHECKSUMS*

# create iso
RUN mksusecd --verbose --rebuild-initrd --efi --isolinux --volume "crayauto" --preparer "Cray Inc" --application "Shasta" --sign --boot="console=ttyS0,115200 edd=off" --create "/build/cray-dhcp-SLE-15-Server-DVD-x86_64-GM-DVD1.iso" /build/build_me

