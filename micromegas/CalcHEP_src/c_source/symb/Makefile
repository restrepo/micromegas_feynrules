
include ../../FlagsForMake

Idir= chep_crt service2  polynom getmem  plot  dynamicME   SLHAplus  ntools num ..

override CFLAGS += -Iinclude $(patsubst %,-I../%/include ,$(Idir)) $(SNUM)

special = s_calchep.c make_VandP.c make-j.c

VPATH = out diagram
OBJ = $(notdir $(subst .c,.o,$(filter-out $(special),$(wildcard *.c diagram/*.c out/*.c))))

bin = ../../bin
lib = ../../lib
sbin= ../../sbin

all: $(bin)/s_calchep $(bin)/make_VandP $(sbin)/make-j

#all:  $(bin)/make_VandP

$(bin)/s_calchep:s_calchep.c $(lib)/symb.a $(lib)/serv.a $(lib)/dynamic_vp.a  $(lib)/dynamic_me.a  $(lib)/libSLHAplus.a $(lib)/dummy.a $(lib)/ntools.a
	$(CC)  $(CFLAGS) -o $@ $^  $(LX11) -lm $(lDL) -lpthread

$(lib)/symb.a:$(lib)/symb.a($(OBJ))
	echo $(OBJ)
	$(RANLIB) $@
	@rm -f $(OBJ)

$(bin)/make_VandP: make_VandP.c $(lib)/symb.a $(lib)/serv.a $(lib)/dynamic_me.a $(lib)/ntools.a
	$(CC) $(CFLAGS) -o $@ $^  $(LX11) -lm  -lpthread

$(sbin)/make-j:make-j.c
	$(CC) $(CFLAGS) -o $@ $^ -lm -lpthread
        