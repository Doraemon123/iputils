#Configuration 配置
#

#CC  自定义CC指定GCC程序
CC=gcc

#内核路径包含文件的目录
LIBC_INCLUDE=/usr/include
#Libraries  库
ADDLIB=

#Linker flags    链接器标志
LDFLAG_STATIC=-Wl,-Bstatic        #Wl选项告诉编译器将后面的参数传递给链接器，对接下来的-l选项使用静态链接
LDFLAG_DYNAMIC=-Wl,-Bdynamic      #对接下来的-l选项使用动态链接
#指定加载库，告诉链接器从哪里寻找库文件
LDFLAG_CAP=-lcap                    #在link的时候包含cap这个库
LDFLAG_GNUTLS=-lgnutls-openssl            
LDFLAG_CRYPTO=-lcrypto
LDFLAG_IDN=-lidn
LDFLAG_RESOLV=-lresolv
LDFLAG_SYSFS=-lsysfs

#
#Options    #变量定义，设置开关
#
#Capability support (with libcap) [yes|static|no]
#功能支持（与libcap的）[是|静态|否]
USE_CAP=yes

#sysfs support (with libsysfs - deprecated) [no|yes|static]
#sysfs的支持（与libsysfs - 不建议使用）[NO | YES|静态]
USE_SYSFS=no

#IDN support (experimental) [no|yes|static]
#IDN 支持（实验）[NO | YES|静态]
USE_IDN=no

#Do not use getifaddrs [no|yes|static]
#不使用getifaddrs[NO | YES|静态]
WITHOUT_IFADDRS=no

#arping default device (e.g. eth0) []
#arping的默认设备（如eth0的）[]
ARPING_DEFAULT_DEVICE=

#GNU TLS library for ping6 [yes|no|static]
#GNU TLS库ping6[是|否|静态]
USE_GNUTLS=yes

#Crypto library for ping6 [shared|static]
#ping6密码库的设置[共享|静态]
USE_CRYPTO=shared

#Resolv library for ping6 [yes|static]
#ping6 RESOLV库的设置[是|静态]
USE_RESOLV=yes

#ping6 source routing (deprecated by RFC5095) [no|yes|RFC3542]
#ping6源路由（由RFC5095不建议使用）[NO | YES| RFC3542]
ENABLE_PING6_RTHDR=no

#rdisc server (-r option) support [no|yes]
#磁盘服务器（-r选项）支持[NO | YES]
ENABLE_RDISC_SERVER=no

# -------------------------------------
# What a pity, all new gccs are buggy and -Werror does not work. Sigh.
# CCOPT=-fno-strict-aliasing -Wstrict-prototypes -Wall -Werror -g
#-Wstrict-prototypes: 如果函数的声明或定义没有指出参数类型，编译器就发出警告
CCOPT=-fno-strict-aliasing -Wstrict-prototypes -Wall -g         #gcc参数 编译选项
CCOPTOPT=-O3                 #-O3 '   turns   on   all   optimizations   specified   优化级别最高                              
GLIBCFIX=-D_GNU_SOURCE       #_GNU_SOURCE 将允许使用全部的 glibc 的功能
DEFINES=
LDLIB=

#动，静态链接库方式的选择
FUNC_LIB = $(if $(filter static,$(1)),$(LDFLAG_STATIC) $(2) $(LDFLAG_DYNAMIC),$(2))
#LDFLAG_STATIC=-Wl,-Bstatic
#LDFLAG_DYNAMIC=-Wl,-Bdynamic

#GNU TLS库ping6[是|否|静态]
#USE_GNUTLS=yes
#USE_GNUTLS: DEF_GNUTLS, LIB_GNUTLS

#Crypto library for ping6 [shared|static]
#ping6密码库的设置[共享|静态]
#USE_CRYPTO=shared
#USE_CRYPTO: LIB_CRYPTO

#GNU TSL库ping6的设置以及ping6密码库的设置
ifneq ($(USE_GNUTLS),no)                            #判断不等
	LIB_CRYPTO = $(call FUNC_LIB,$(USE_GNUTLS),$(LDFLAG_GNUTLS))
	DEF_CRYPTO = -DUSE_GNUTLS
else
	LIB_CRYPTO = $(call FUNC_LIB,$(USE_CRYPTO),$(LDFLAG_CRYPTO))
endif

#Resolv library for ping6 [yes|static]
#ping6 RESOLV库的设置[是|静态]
#USE_RESOLV=yes
#USE_RESOLV: LIB_RESOLV
LIB_RESOLV = $(call FUNC_LIB,$(USE_RESOLV),$(LDFLAG_RESOLV))

#Capability support (with libcap) [yes|static|no]
#功能支持（与libcap的）[是|静态|否]
#USE_CAP=yes
#USE_CAP:  DEF_CAP, LIB_CAP
ifneq ($(USE_CAP),no)                             
	DEF_CAP = -DCAPABILITIES
	LIB_CAP = $(call FUNC_LIB,$(USE_CAP),$(LDFLAG_CAP))
endif

#sysfs support (with libsysfs - deprecated) [no|yes|static]
#sysfs的支持（与libsysfs - 不建议使用）[NO | YES|静态]
#USE_SYSFS=no
#USE_SYSFS: DEF_SYSFS, LIB_SYSFS
ifneq ($(USE_SYSFS),no)
	DEF_SYSFS = -DUSE_SYSFS
	LIB_SYSFS = $(call FUNC_LIB,$(USE_SYSFS),$(LDFLAG_SYSFS))
endif

#IDN support (experimental) [no|yes|static]
#IDN 支持（实验）[NO | YES|静态]
#USE_IDN=no
#USE_IDN: DEF_IDN, LIB_IDN
ifneq ($(USE_IDN),no)
	DEF_IDN = -DUSE_IDN
	LIB_IDN = $(call FUNC_LIB,$(USE_IDN),$(LDFLAG_IDN))
endif

#Do not use getifaddrs [no|yes|static]
#不使用getifaddrs[NO | YES|静态]
#WITHOUT_IFADDRS=no
#WITHOUT_IFADDRS: DEF_WITHOUT_IFADDRS
ifneq ($(WITHOUT_IFADDRS),no)
	DEF_WITHOUT_IFADDRS = -DWITHOUT_IFADDRS
endif

#rdisc server (-r option) support [no|yes]
#磁盘服务器（-r选项）支持[NO | YES]
#ENABLE_RDISC_SERVER=no
#ENABLE_RDISC_SERVER: DEF_ENABLE_RDISC_SERVER
ifneq ($(ENABLE_RDISC_SERVER),no)
	DEF_ENABLE_RDISC_SERVER = -DRDISC_SERVER
endif

#ping6 source routing (deprecated by RFC5095) [no|yes|RFC3542]
#ping6源路由（由RFC5095不建议使用）[NO | YES| RFC3542]
#ENABLE_PING6_RTHDR=no
#ENABLE_PING6_RTHDR: DEF_ENABLE_PING6_RTHDR
ifneq ($(ENABLE_PING6_RTHDR),no)
	DEF_ENABLE_PING6_RTHDR = -DPING6_ENABLE_RTHDR
ifeq ($(ENABLE_PING6_RTHDR),RFC3542)
	DEF_ENABLE_PING6_RTHDR += -DPINR6_ENABLE_RTHDR_RFC3542
endif
endif

#IP设置
# -------------------------------------
IPV4_TARGETS=tracepath ping clockdiff rdisc arping tftpd rarpd       #目标配置，iputils工具
IPV6_TARGETS=tracepath6 traceroute6 ping6
TARGETS=$(IPV4_TARGETS) $(IPV6_TARGETS)

CFLAGS=$(CCOPTOPT) $(CCOPT) $(GLIBCFIX) $(DEFINES)
LDLIBS=$(LDLIB) $(ADDLIB)

#显示节点名称
UNAME_N:=$(shell uname -n)
LASTTAG:=$(shell git describe HEAD | sed -e 's/-.*//')
#按年月日显示当前日期时间
TODAY=$(shell date +%Y/%m/%d)
DATE=$(shell date --date $(TODAY) +%Y%m%d)
TAG:=$(shell date --date=$(TODAY) +s%Y%m%d)


# -------------------------------------
#并不产生目标文件，其命令在每次make 该目标时才执行。
.PHONY: all ninfod clean distclean man html check-kernel modules snapshot
#IPV4_TARGETS=tracepath ping clockdiff rdisc arping tftpd rarpd
#IPV6_TARGETS=tracepath6 traceroute6 ping6
#TARGETS=$(IPV4_TARGETS) $(IPV6_TARGETS)
all: $(TARGETS)
%.s: %.c
	$(COMPILE.c) $< $(DEF_$(patsubst %.o,%,$@)) -S -o $@
%.o: %.c
	$(COMPILE.c) $< $(DEF_$(patsubst %.o,%,$@)) -o $@
$(TARGETS): %: %.o
	$(LINK.o) $^ $(LIB_$@) $(LDLIBS) -o $@
#  
# COMPILE.c=$(CC) $(CFLAGS) $(CPPFLAGS) -c
# $< 依赖目标中的第一个目标名字 
# $@ 表示目标文件
# $^ 所有的依赖目标的集合 
# 在$(patsubst %.o,%,$@ )中，patsubst把目标中的变量符合后缀是.o的全部删除,  DEF_ping
# LINK.o把.o文件链接在一起的命令行,缺省值是$(CC) $(LDFLAGS) $(TARGET_ARCH)
#
#
#以ping为例，翻译为：
# gcc -O3 -fno-strict-aliasing -Wstrict-prototypes -Wall -g -D_GNU_SOURCE    -c ping.c -DCAPABILITIES   -o ping.o
#gcc   ping.o ping_common.o -lcap    -o ping


# -------------------------------------

# arping 库的设置
DEF_arping = $(DEF_SYSFS) $(DEF_CAP) $(DEF_IDN) $(DEF_WITHOUT_IFADDRS)
LIB_arping = $(LIB_SYSFS) $(LIB_CAP) $(LIB_IDN)

#如果没有arping默认设备，则调用上面的库加载一个
ifneq ($(ARPING_DEFAULT_DEVICE),)
DEF_arping += -DDEFAULT_DEVICE=\"$(ARPING_DEFAULT_DEVICE)\"
endif

# clockdiff时间比对程序库设置
DEF_clockdiff = $(DEF_CAP)
LIB_clockdiff = $(LIB_CAP)

# ping / ping6
DEF_ping_common = $(DEF_CAP) $(DEF_IDN)
DEF_ping  = $(DEF_CAP) $(DEF_IDN) $(DEF_WITHOUT_IFADDRS)
LIB_ping  = $(LIB_CAP) $(LIB_IDN)
DEF_ping6 = $(DEF_CAP) $(DEF_IDN) $(DEF_WITHOUT_IFADDRS) $(DEF_ENABLE_PING6_RTHDR) $(DEF_CRYPTO)
LIB_ping6 = $(LIB_CAP) $(LIB_IDN) $(LIB_RESOLV) $(LIB_CRYPTO)

ping: ping_common.o
ping6: ping_common.o
ping.o ping_common.o: ping_common.h
ping6.o: ping_common.h in6_flowlabel.h

# rarpd
DEF_rarpd =
LIB_rarpd =

# rdisc
DEF_rdisc = $(DEF_ENABLE_RDISC_SERVER)
LIB_rdisc =

# tracepath
DEF_tracepath = $(DEF_IDN)
LIB_tracepath = $(LIB_IDN)

# tracepath6
DEF_tracepath6 = $(DEF_IDN)
LIB_tracepath6 =

# traceroute6
DEF_traceroute6 = $(DEF_CAP) $(DEF_IDN)
LIB_traceroute6 = $(LIB_CAP) $(LIB_IDN)

# tftpd
DEF_tftpd =
DEF_tftpsubs =
LIB_tftpd =

tftpd: tftpsubs.o
tftpd.o tftpsubs.o: tftp.h

# -------------------------------------
# ninfod
ninfod:
	@set -e; \
		if [ ! -f ninfod/Makefile ]; then \
			cd ninfod; \
			./configure; \
			cd ..; \
		fi; \
		$(MAKE) -C ninfod

# -------------------------------------
#仅为了过去内核的模块/内核检查;过时的内核检查：
#modules / check-kernel are only for ancient kernels; obsolete
check-kernel:
#如果是内核头文件就执行输出的内容
ifeq ($(KERNEL_INCLUDE),)
	@echo "Please, set correct KERNEL_INCLUDE"; false
else
	@set -e; \
	if [ ! -r $(KERNEL_INCLUDE)/linux/autoconf.h ]; then \
		echo "Please, set correct KERNEL_INCLUDE"; false; fi
endif
#内核检查模块
modules: check-kernel
	$(MAKE) KERNEL_INCLUDE=$(KERNEL_INCLUDE) -C Modules

# -------------------------------------
man:
	$(MAKE) -C doc man

html:
	$(MAKE) -C doc html

clean:
	@rm -f *.o $(TARGETS)
	@$(MAKE) -C Modules clean
	@$(MAKE) -C doc clean
	@set -e; \
		if [ -f ninfod/Makefile ]; then \
			$(MAKE) -C ninfod clean; \
		fi

distclean: clean
	@set -e; \
		if [ -f ninfod/Makefile ]; then \
			$(MAKE) -C ninfod distclean; \
		fi

# -------------------------------------
snapshot:
	@if [ x"$(UNAME_N)" != x"pleiades" ]; then echo "Not authorized to advance snapshot"; exit 1; fi
	@echo "[$(TAG)]" > RELNOTES.NEW
	@echo >>RELNOTES.NEW
	@git log --no-merges $(LASTTAG).. | git shortlog >> RELNOTES.NEW
	@echo >> RELNOTES.NEW
	@cat RELNOTES >> RELNOTES.NEW
	@mv RELNOTES.NEW RELNOTES
	@sed -e "s/^%define ssdate .*/%define ssdate $(DATE)/" iputils.spec > iputils.spec.tmp
	@mv iputils.spec.tmp iputils.spec
	@echo "static char SNAPSHOT[] = \"$(TAG)\";" > SNAPSHOT.h
	@$(MAKE) -C doc snapshot
	@$(MAKE) man
	@git commit -a -m "iputils-$(TAG)"
	@git tag -s -m "iputils-$(TAG)" $(TAG)
	@git archive --format=tar --prefix=iputils-$(TAG)/ $(TAG) | bzip2 -9 > ../iputils-$(TAG).tar.bz2

	
