export DEBUG ?= 1
export USE_STATSD ?= 0
CC = gcc
# TODO: -O3, -ffast-math?
CFLAGS = -std=c99 -g -Wall -D_XOPEN_SOURCE=500 -DDEBUG=$(DEBUG) -DUSE_STATSD=$(USE_STATSD)
LDLIBS = -lfec -lm -lrtlsdr
BIN = dumpvdl2
DEPS =	acars.o \
	avlc.o \
	bitstream.o \
	clnp.o \
	crc.o \
	decode.o \
	deinterleave.o \
	esis.o \
	idrp.o \
	output.o \
	rs.o \
	dumpvdl2.o \
	tlv.o \
	x25.o \
	xid.o \
	util.o

ifeq ($(USE_STATSD), 1)
  DEPS += statsd.o
  LDLIBS += -lstatsdclient
endif

.PHONY = all clean

all: $(BIN)

$(BIN): $(DEPS)

clnp.o: dumpvdl2.h clnp.h idrp.h

decode.o: dumpvdl2.h

bitstream.o: dumpvdl2.h

deinterleave.o: dumpvdl2.h

esis.o: dumpvdl2.h esis.h tlv.h

idrp.o: dumpvdl2.h idrp.h tlv.h

rs.o: dumpvdl2.h

dumpvdl2.o: dumpvdl2.h

avlc.o: dumpvdl2.h avlc.h

acars.o: dumpvdl2.h acars.h

output.o: avlc.h acars.h

tlv.o: tlv.h dumpvdl2.h

xid.o: dumpvdl2.h tlv.h

x25.o: dumpvdl2.h clnp.h tlv.h x25.h

clean:
	rm -f *.o $(BIN)
