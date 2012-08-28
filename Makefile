
prefix = 
exec_prefix = ${prefix}
bindir = ${exec_prefix}/bin

CC = mipsel-linux-uclibc-gcc
LD = $(CC)
AS = $(CC)
INSTALL = /usr/bin/install -c

CFLAGS = -O3 -march=mips32 -mtune=r4600 -msoft-float -fomit-frame-pointer -ffast-math \
	-falign-functions -falign-loops -falign-labels -falign-jumps -fno-builtin -fno-common \
	-D_GNU_SOURCE=1 -DIS_LITTLE_ENDIAN
#CFLAGS += -fprofile-use
LDFLAGS = $(CFLAGS) -s
ASFLAGS = $(CFLAGS)

TARGETS =  sdlgnuboy

ASM_OBJS =

SYS_DEFS = -DHAVE_CONFIG_H -DIS_LITTLE_ENDIAN  -DIS_LINUX
SYS_OBJS = sys/nix/nix.o $(ASM_OBJS)
SYS_INCS = -I./sys/nix

FB_OBJS =  sys/linux/joy.o sys/oss/oss.o sys/linux/fbdev.o sys/linux/kb.o sys/linux/keymap.o
FB_LIBS =

SVGA_OBJS = sys/svga/svgalib.o sys/pc/keymap.o sys/linux/joy.o sys/oss/oss.o
SVGA_LIBS = -L/opt/dingoo-uclibc-toolchain/usr/lib -lvga

SDL_OBJS = sys/sdl/sdl.o sys/sdl/keymap.o sys/sdl/scaler.o #sys/oss/oss.o
SDL_LIBS =  -lSDL
SDL_CFLAGS = -D_GNU_SOURCE=1

X11_OBJS = sys/x11/xlib.o sys/x11/keymap.o sys/linux/joy.o sys/oss/oss.o
X11_LIBS =  -lX11 -lXext

all: $(TARGETS)

include Rules

fbgnuboy: $(OBJS) $(SYS_OBJS) $(FB_OBJS)
	$(LD) $(LDFLAGS) $(OBJS) $(SYS_OBJS) $(FB_OBJS) -o $@ $(FB_LIBS)

sgnuboy: $(OBJS) $(SYS_OBJS) $(SVGA_OBJS)
	$(LD) $(LDFLAGS) $(OBJS) $(SYS_OBJS) $(SVGA_OBJS) -o $@ $(SVGA_LIBS)

sdlgnuboy: $(OBJS) $(SYS_OBJS) $(SDL_OBJS)
	$(LD) $(LDFLAGS) $(OBJS) $(SYS_OBJS) $(SDL_OBJS) -o $@ $(SDL_LIBS)

sys/sdl/sdl.o: sys/sdl/sdl.c
	$(MYCC) $(SDL_CFLAGS) -c $< -o $@

sys/sdl/keymap.o: sys/sdl/keymap.c
	$(MYCC) $(SDL_CFLAGS) -c $< -o $@

xgnuboy: $(OBJS) $(SYS_OBJS) $(X11_OBJS)
	$(LD) $(LDFLAGS) $(OBJS) $(SYS_OBJS) $(X11_OBJS) -o $@ $(X11_LIBS)

install: all
	$(INSTALL) -d $(bindir)
	$(INSTALL) -m 755 $(TARGETS) $(bindir)

clean:
	rm -f *gnuboy gmon.out *.o sys/*.o sys/*/*.o asm/*/*.o

distclean: clean
	rm -f config.* sys/nix/config.h Makefile




