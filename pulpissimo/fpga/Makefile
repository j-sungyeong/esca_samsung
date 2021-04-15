.DEFAULT_GOAL:=help

all: zedboard zcu102 ## Generates the bitstream for all supported boards board.

clean_all: clean_zedboard clean_zcu102 ## Removes synthesis output and bitstreams for all boards.

zedboard: ## Generates the bistream for the ZedBoard
	$(MAKE) -C pulpissimo-zedboard all
	cp pulpissimo-zedboard/pulpissimo-zedboard.runs/impl_1/xilinx_pulpissimo.bit pulpissimo_zedboard.bit
	cp pulpissimo-zedboard/pulpissimo-zedboard.runs/impl_1/xilinx_pulpissimo.bin pulpissimo_zedboard.bin
	@echo "Bitstream generation for ZedBoard finished. The bitstream Configuration Memory File was copied to ./pulpissimo_zedboard.bit and ./pulpissimo_zedboard.bin"

clean_zedboard: ## Removes all bitstreams, *.log files and vivado related files (rm -rf vivado*) for the ZedBoard.
	$(MAKE) -C pulpissimo-zedboard clean
	rm -f pulpissimo_zedboard.bit
	rm -f pulpissimo_zedboard.bin

zcu102: ## Generates the bistream for the zcu102 board
	$(MAKE) -C pulpissimo-zcu102 all
	cp pulpissimo-zcu102/pulpissimo-zcu102.runs/impl_1/xilinx_pulpissimo.bit pulpissimo_zcu102.bit
	cp pulpissimo-zcu102/pulpissimo-zcu102.runs/impl_1/xilinx_pulpissimo.bin pulpissimo_zcu102.bin
	@echo "Bitstream generation for zcu102 board finished. The bitstream Configuration Memory File was copied to ./pulpissimo_zcu102.bit and ./pulpissimo_zcu102.bin"

clean_zcu102: ## Removes all bitstreams, *.log files and vivado related files (rm -rf vivado*) for the zcu102 board.
	$(MAKE) -C pulpissimo-zcu102 clean
	rm -f pulpissimo_zcu102.bit
	rm -f pulpissimo_zcu102.bin


help: ## Show this help message
	@echo "PULPissimo on FPGA"
	@echo ""
	@echo "Call make with one of the supported FPGA boards as arguments to generate the bitstream in the corresponding folder. "
	@echo "E.g. 'make zcu102' to generate the bitstream for the zcu102 board in pulpissimo-zcu102 subdirectory."
	@echo "By default make invokes 'vivado'  to start Xilinx Vivado. This behaviour can be overriden by setting the make variable 'VIVADO'"
	@echo "e.g. make zcu102 VIVADO='vivado-2018.3 vivado' for ETH centos machines."
	@echo ""
	@grep -E '^[a-zA-Z0-9_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'
