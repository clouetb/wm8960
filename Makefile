# SPDX-License-Identifier: GPL-2.0
snd-soc-wm8960-objs := wm8960.o
obj-m += snd-soc-wm8960.o
#dtbo-y += wm8960.dtbo

targets += $(dtbo-y)
always  := $(dtbo-y)

all:
	make -C /lib/modules/$(shell uname -r)/build M=$(shell pwd) modules

clean:
	make -C /lib/modules/$(shell uname -r)/build M=$(shell pwd) clean

tagtagtag-ears.dtbo:
	dtc -I dts -O dtb -o wm8960.dtbo wm8960-overlay.dts

install: snd-soc-wm8960.ko wm8960.dtbo
	cp snd-soc-wm8960.ko /lib/modules/$(shell uname -r)/kernel/sound/soc/codecs/
	depmod -a
	cp wm8960.dtbo /boot/overlays/
	sed /boot/armbianEnv.txt -i -e "s/^#dtparam=i2c_arm=on/dtparam=i2c_arm=on/"
	grep -q -E "^dtparam=i2c_arm=on" /boot/armbianEnv.txt || printf "dtparam=i2c_arm=on\n" >> /boot/armbianEnv.txt
	sed /boot/armbianEnv.txt -i -e "s/^#dtoverlay=i2s-mmap/dtoverlay=i2s-mmap/"
	grep -q -E "^dtoverlay=i2s-mmap" /boot/armbianEnv.txt || printf "dtoverlay=i2s-mmap\n" >> /boot/armbianEnv.txt
	sed /boot/armbianEnv.txt -i -e "s/^#dtparam=i2s=on/dtparam=i2s=on/"
	grep -q -E "^dtparam=i2s=on" /boot/armbianEnv.txt || printf "dtparam=i2s=on\n" >> /boot/armbianEnv.txt
	sed /boot/armbianEnv.txt -i -e "s/^#dtoverlay=wm8960/dtoverlay=wm8960/"
	grep -q -E "^dtoverlay=wm8960" /boot/armbianEnv.txt || printf "dtoverlay=wm8960\n" >> /boot/armbianEnv.txt

.PHONY: all clean install
