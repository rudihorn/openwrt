#
# Copyright (C) 2006-2014 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

DVB_MENU:=DVB Support

DVBUSB_DIR:=/media/usb

define KernelPackage/mc
  TITLE := DVB Drivers
  URL := http://www.linuxtv.org
  HIDDEN := y
  DEFAULT := y
  KCONFIG := \
  CONFIG_MEDIA_CONTROLLER=y \
	CONFIG_MEDIA_SUPPORT=m \
	CONFIG_VIDEO_KERNEL_VERSION=y
  FILES := $(LINUX_DIR)/drivers/media/mc/mc.ko
  AUTOLOAD := $(call AutoProbe,mc)
  DEPENDS := @PCI_SUPPORT||USB_SUPPORT
endef
define KernelPackage/mc/description
 Kernel DVB driver
endef
$(eval $(call KernelPackage,mc))

define KernelPackage/videodev
  SUBMENU := $(DVB_MENU)
  TITLE := Device registrar for Video4Linux drivers v2
  KCONFIG := \
	CONFIG_VIDEO_DEV=y \
	CONFIG_VIDEO_V4L2=y
  FILES := $(LINUX_DIR)/drivers/media/v4l2-core/videodev.ko
  AUTOLOAD := $(call AutoProbe,videodev)
  DEPENDS := +kmod-i2c-core +kmod-mc
  CONFLICTS := kmod-video-core
endef
$(eval $(call KernelPackage,videodev))

define KernelPackage/rc-core
  SUBMENU := $(DVB_MENU)
  TITLE := Remote Controller support
  KCONFIG := \
	CONFIG_MEDIA_RC_SUPPORT=y \
	CONFIG_RC_CORE
  FILES := $(LINUX_DIR)/drivers/media/rc/rc-core.ko
  AUTOLOAD := $(call AutoProbe,rc-core)
  DEPENDS := +kmod-mc +kmod-input-core
endef

define KernelPackage/rc-core/description
 Enable support for Remote Controllers on Linux. This is
 needed in order to support several video capture adapters,
 standalone IR receivers/transmitters, and RF receivers.

 Enable this option if you have a video capture board even
 if you don't need IR, as otherwise, you may not be able to
 compile the driver for your adapter.
endef
$(eval $(call KernelPackage,rc-core))

define KernelPackage/videobuf2-common
  SUBMENU := $(DVB_MENU)
  TITLE := videobuf2 common lib
  KCONFIG := CONFIG_VIDEOBUF2_CORE
  FILES := $(LINUX_DIR)/drivers/media/common/videobuf2/videobuf2-common.ko
  AUTOLOAD := $(call AutoProbe,videobuf2-common)
  DEPENDS := +kmod-dma-buf +kmod-videodev
  CONFLICTS := kmod-video-videobuf2
endef
$(eval $(call KernelPackage,videobuf2-common))

define KernelPackage/videobuf2-dma-sg
  SUBMENU := $(DVB_MENU)
  TITLE := videobuf2 dma-sg lib
  KCONFIG := CONFIG_VIDEOBUF2_DMA_SG
  FILES := $(LINUX_DIR)/drivers/media/common/videobuf2/videobuf2-dma-sg.ko
  AUTOLOAD := $(call AutoProbe,videobuf2-dma-sg)
  DEPENDS := +kmod-videobuf2-memops
  CONFLICTS := kmod-video-videobuf2
endef
$(eval $(call KernelPackage,videobuf2-dma-sg))


define KernelPackage/videobuf2-dvb
  SUBMENU := $(DVB_MENU)
  TITLE := videobuf2 dvb lib
  KCONFIG := CONFIG_VIDEOBUF2_DVB
  FILES := $(LINUX_DIR)/drivers/media/common/videobuf2/videobuf2-dvb.ko
  AUTOLOAD := $(call AutoProbe,videobuf2-dvb)
  DEPENDS := +kmod-dvb-core
  CONFLICTS := kmod-video-videobuf2
endef
$(eval $(call KernelPackage,videobuf2-dvb))

define KernelPackage/videobuf2-memops
  SUBMENU := $(DVB_MENU)
  TITLE := videobuf2 memops lib
  KCONFIG := CONFIG_VIDEOBUF2_MEMOPS
  FILES := \
	$(LINUX_DIR)/drivers/media/common/videobuf2/videobuf2-memops.ko
  AUTOLOAD := $(call AutoProbe,videobuf2-memops)
  DEPENDS := +kmod-videobuf2-common
  CONFLICTS := kmod-video-videobuf2
endef
$(eval $(call KernelPackage,videobuf2-memops))

define KernelPackage/videobuf2-v4l2
  SUBMENU := $(DVB_MENU)
  TITLE := videobuf2 v4l2 lib
  KCONFIG := CONFIG_VIDEOBUF2_V4L2
  FILES := $(LINUX_DIR)/drivers/media/common/videobuf2/videobuf2-v4l2.ko
  AUTOLOAD := $(call AutoProbe,videobuf2-v4l2)
  DEPENDS := +kmod-videobuf2-common
  CONFLICTS := kmod-video-videobuf2
endef
$(eval $(call KernelPackage,videobuf2-v4l2))

define KernelPackage/videobuf2-vmalloc
  SUBMENU := $(DVB_MENU)
  TITLE := videobuf2 vmalloc lib
  KCONFIG := CONFIG_VIDEOBUF2_VMALLOC
  FILES := $(LINUX_DIR)/drivers/media/common/videobuf2/videobuf2-vmalloc.ko
  AUTOLOAD := $(call AutoProbe,videobuf2-vmalloc)
  DEPENDS := +kmod-videobuf2-memops
  CONFLICTS := kmod-video-videobuf2
endef
$(eval $(call KernelPackage,videobuf2-vmalloc))

define KernelPackage/videobuf
  SUBMENU := $(DVB_MENU)
  TITLE := videobuf lib
  KCONFIG := \
	CONFIG_VIDEOBUF_DMA_SG \
	CONFIG_VIDEOBUF_GEN \
	CONFIG_VIDEOBUF_VMALLOC
  FILES := \
	$(LINUX_DIR)/drivers/media/v4l2-core/videobuf-core.ko \
	$(LINUX_DIR)/drivers/media/v4l2-core/videobuf-dma-sg.ko \
	$(LINUX_DIR)/drivers/media/v4l2-core/videobuf-vmalloc.ko
  AUTOLOAD := $(call AutoProbe,videobuf-core videobuf-vmalloc)
  CONFLICTS := kmod-video-videobuf2
endef

define KernelPackage/videobuf/description
 Helper module to manage video4linux buffers.
endef
$(eval $(call KernelPackage,videobuf))


define KernelPackage/tveeprom
  SUBMENU := $(DVB_MENU)
  TITLE := TV card eeprom decoder
  HIDDEN := y
  KCONFIG := CONFIG_VIDEO_TVEEPROM
  FILES := $(LINUX_DIR)/drivers/media/common/tveeprom.ko
  AUTOLOAD := $(call AutoProbe,tveeprom)
  DEPENDS := +kmod-i2c-core
endef

define KernelPackage/tveeprom/description
 Eeprom decoder for tvcard configuration eeproms.
endef
$(eval $(call KernelPackage,tveeprom))


define KernelPackage/dvb-core
  SUBMENU := $(DVB_MENU)
  TITLE := DVB core support
  KCONFIG := \
	CONFIG_DVB_CORE \
	CONFIG_DVB_DEMUX_SECTION_LOSS_LOG=n \
	CONFIG_DVB_DYNAMIC_MINORS=n \
	CONFIG_DVB_MAX_ADAPTERS=16 \
	CONFIG_DVB_NET=y \
	CONFIG_MEDIA_DIGITAL_TV_SUPPORT=y
  FILES := $(LINUX_DIR)/drivers/media/dvb-core/dvb-core.ko
  AUTOLOAD := $(call AutoProbe,dvb-core)
  DEPENDS += +kmod-mc +kmod-videobuf2-vmalloc
endef

define KernelPackage/dvb-core/description
 Kernel modules for DVB support.
endef
$(eval $(call KernelPackage,dvb-core))

define KernelPackage/cx2341x
  SUBMENU := $(DVB_MENU)
  TITLE := cx23415/6/8 driver
  KCONFIG := CONFIG_VIDEO_CX2341X
  FILES := $(LINUX_DIR)/drivers/media/common/cx2341x.ko
  AUTOLOAD := $(call AutoProbe,cx2341x)
  DEPENDS := +kmod-videodev
endef

define KernelPackage/cx2341x/description
 Common routines for Conexant cx23415/6/8 drivers.
endef
$(eval $(call KernelPackage,cx2341x))



define KernelPackage/dvb-usb
  SUBMENU := $(DVB_MENU)
  TITLE := Support for various USB DVB devices
  KCONFIG := \
	CONFIG_DVB_USB \
	CONFIG_MEDIA_DIGITAL_TV_SUPPORT=y \
	CONFIG_MEDIA_USB_SUPPORT=y
  FILES := $(LINUX_DIR)/drivers/media/usb/dvb-usb/dvb-usb.ko
  AUTOLOAD := $(call AutoProbe,dvb-usb)
  DEPENDS := +kmod-dvb-core +kmod-i2c-core +kmod-rc-core +kmod-usb-core
endef

define KernelPackage/dvb-usb/description
 By enabling this you will be able to choose the various supported
 USB1.1 and USB2.0 DVB devices.

 Almost every USB device needs a firmware.

 For a complete list of supported USB devices see the LinuxTV DVB Wiki:
 <http://www.linuxtv.org/wiki/index.php/DVB_USB>
endef
$(eval $(call KernelPackage,dvb-usb))

define AddDepends/dvb-usb
  SUBMENU := $(DVB_MENU)
  DEPENDS += +kmod-dvb-usb $1
endef




define KernelPackage/dvb-usb-v2
  SUBMENU := $(DVB_MENU)
  TITLE := Support for various USB DVB devices v2
  KCONFIG := CONFIG_DVB_USB_V2
  FILES := $(LINUX_DIR)/drivers/media/usb/dvb-usb-v2/dvb_usb_v2.ko
  AUTOLOAD := $(call AutoProbe,dvb_usb_v2)
  DEPENDS := +kmod-dvb-core +kmod-i2c-core +kmod-rc-core +kmod-usb-core
endef

define KernelPackage/dvb-usb-v2/description
 By enabling this you will be able to choose the various supported
 USB1.1 and USB2.0 DVB devices.

 Almost every USB device needs a firmware.

 For a complete list of supported USB devices see the LinuxTV DVB Wiki:
 <http://www.linuxtv.org/wiki/index.php/DVB_USB>
endef
$(eval $(call KernelPackage,dvb-usb-v2))

define AddDepends/dvb-usb-v2
  SUBMENU := $(DVB_MENU)
  DEPENDS += +kmod-dvb-usb-v2 $1
endef

define KernelPackage/dvb-tas2101
  TITLE := Tmax TAS2101
  HIDDEN := y
  $(call DvbFrontend,tas2101,CONFIG_DVB_TAS2101)
  DEPENDS += +kmod-i2c-mux
endef
$(eval $(call KernelPackage,dvb-tas2101))


define KernelPackage/cx231xx-dvb-ci
  SUBMENU:=$(DVB_MENU)
  TITLE:=Support for Conexant Cx23100/101/102
  KCONFIG:=CONFIG_VIDEO_CX231XX CONFIG_VIDEO_CX231XX_DVB
  FILES:= \
	$(LINUX_DIR)/drivers/media/usb/cx231xx/cx231xx.ko \
	$(LINUX_DIR)/drivers/media/usb/cx231xx/cx231xx-dvb.ko
  AUTOLOAD := $(call AutoProbe,cx231xx-dvb-ci)
  DEPENDS := +kmod-cx2341x +kmod-dvb-core +kmod-dvb-tas2101 +kmod-rc-core +kmod-tveeprom +kmod-usb-core +kmod-videobuf +kmod-videobuf2-v4l2
endef

define KernelPackage/cx231xx-dvb-ci/description
 This adds support for DVB cards based on the Conexant cx231xx chips.
endef
$(eval $(call KernelPackage,cx231xx-dvb-ci))



define KernelPackage/dvb-usb-rtl28xxu
  TITLE := Realtek RTL28xxU DVB USB support
  KCONFIG := \
	CONFIG_REGMAP_I2C \
	CONFIG_DVB_USB_RTL28XXU
  FILES := $(LINUX_DIR)/drivers/media/usb/dvb-usb-rtl28xxu.ko
  AUTOLOAD := $(call AutoProbe,56,dvb-usb-rtl28xxu)
  DEPENDS := +kmod-i2c-core +kmod-regmap-i2c
  $(call AddDepends/dvb-usb-v2)
endef

define KernelPackage/dvb-usb-rtl28xxu/description
 Realtek RTL28xxU DVB USB support.
endef
$(eval $(call KernelPackage,dvb-usb-rtl28xxu))

