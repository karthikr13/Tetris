#!/bin/sh

BIT_FILE="$1"

if [ -z "${BIT_FILE}" ]; then
	echo "\nUsage python upload.py /Path/To/BitFile.bit\n"	
else
	if [ ${BIT_FILE: -4} != ".bit" ]; then
		echo "\nFile to upload must be a .bit file\n"
	else
		echo "\nUploading: $BIT_FILE\n"
		openocd \
		-c "adapter driver ftdi" \
		-c "ftdi_device_desc \"Digilent USB Device\"" \
		-c "ftdi_vid_pid 0x0403 0x6010" \
		-c "ftdi_channel 0" \
		-c "ftdi_layout_init 0x0088 0x008b" \
		-c "reset_config none" \
		-f cpld/xilinx-xc7.cfg \
		-c "adapter speed 25000" \
		-c "init" \
		-c "xc7_program xc7.tap" \
		-c "pld load 0 \"$BIT_FILE\"" \
		-c "exit"
	fi
fi	