if ![info exists INCLUDE_DIRS] {
	set INCLUDE_DIRS ""
}

eval "set INCLUDE_DIRS {
    /home/sun/sun/esca_samsung/pulpissimo/rtl/includes \
    /home/sun/sun/esca_samsung/pulpissimo/ips/common_cells/include \
    /home/sun/sun/esca_samsung/pulpissimo/ips/cluster_interconnect/rtl/low_latency_interco \
    /home/sun/sun/esca_samsung/pulpissimo/ips/cluster_interconnect/rtl/peripheral_interco \
    /home/sun/sun/esca_samsung/pulpissimo/ips/cluster_interconnect/../../rtl/includes \
    /home/sun/sun/esca_samsung/pulpissimo/ips/adv_dbg_if/rtl \
    /home/sun/sun/esca_samsung/pulpissimo/ips/apb/apb_adv_timer/./rtl \
    /home/sun/sun/esca_samsung/pulpissimo/ips/axi/axi/include \
    /home/sun/sun/esca_samsung/pulpissimo/ips/axi/axi/../../common_cells/include \
    /home/sun/sun/esca_samsung/pulpissimo/ips/timer_unit/rtl \
    /home/sun/sun/esca_samsung/pulpissimo/ips/fpnew/../common_cells/include \
    /home/sun/sun/esca_samsung/pulpissimo/ips/jtag_pulp/../../rtl/includes \
    /home/sun/sun/esca_samsung/pulpissimo/ips/riscv/./rtl/include \
    /home/sun/sun/esca_samsung/pulpissimo/ips/riscv/../../rtl/includes \
    /home/sun/sun/esca_samsung/pulpissimo/ips/riscv/./rtl/include \
    /home/sun/sun/esca_samsung/pulpissimo/ips/ibex/rtl \
    /home/sun/sun/esca_samsung/pulpissimo/ips/ibex/shared/rtl \
    /home/sun/sun/esca_samsung/pulpissimo/ips/udma/udma_core/./rtl \
    /home/sun/sun/esca_samsung/pulpissimo/ips/udma/udma_qspi/rtl \
    /home/sun/sun/esca_samsung/pulpissimo/ips/hwpe-ctrl/rtl \
    /home/sun/sun/esca_samsung/pulpissimo/ips/hwpe-stream/rtl \
    /home/sun/sun/esca_samsung/pulpissimo/ips/hwpe-mac-engine/rtl \
    /home/sun/sun/esca_samsung/pulpissimo/ips/register_interface/include \
    /home/sun/sun/esca_samsung/pulpissimo/ips/register_interface/../axi/axi/include \
    /home/sun/sun/esca_samsung/pulpissimo/ips/register_interface/../common_cells/include \
    /home/sun/sun/esca_samsung/pulpissimo/ips/register_interface/include \
    /home/sun/sun/esca_samsung/pulpissimo/ips/register_interface/../axi/axi/include \
    /home/sun/sun/esca_samsung/pulpissimo/ips/register_interface/../common_cells/include \
    /home/sun/sun/esca_samsung/pulpissimo/ips/pulp_soc/../../rtl/includes \
    /home/sun/sun/esca_samsung/pulpissimo/ips/pulp_soc/rtl/include \
    /home/sun/sun/esca_samsung/pulpissimo/ips/pulp_soc/../axi/axi/include \
    /home/sun/sun/esca_samsung/pulpissimo/ips/pulp_soc/../../rtl/includes \
    /home/sun/sun/esca_samsung/pulpissimo/ips/pulp_soc/. \
    /home/sun/sun/esca_samsung/pulpissimo/ips/pulp_soc/../../rtl/includes \
    /home/sun/sun/esca_samsung/pulpissimo/ips/pulp_soc/. \
    /home/sun/sun/esca_samsung/pulpissimo/ips/pulp_soc/../../rtl/includes \
	${INCLUDE_DIRS} \
}"
