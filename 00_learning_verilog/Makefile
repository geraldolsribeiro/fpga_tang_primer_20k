REPORTS=$(addprefix output/,$(subst .v,.out,$(wildcard *_tb.v)))

%_tb.vvd: %_tb.v
	iverilog -o $@ $^

output/%_tb.out: %_tb.vvd
	./$< | tee $@

all: $(REPORTS)

