cyclecheck = $(if $(cycle),$(if $(cycleok),,$(error Argument cycle= must match $(cyclere))),$(error Argument cycle= required))
cycleok = $(shell echo $(cycle) | egrep -q $(cyclere) && echo ok)
cyclere = ^[0-9]{4}-[0-9]{2}-[0-9]{2}T[0-9]{2}$

all: rocoto.xml
	$(call cyclecheck)
	uw rocoto iterate --cycle $(cycle) --database rocoto.db --task forecast --workflow $<

rocoto.yaml: config.yaml
	$(call cyclecheck)
	uw config realize -i $< -o $@ --cycle $(cycle) --leadtime 6 --key-path rocoto --total

rocoto.xml: rocoto.yaml
	$(call cyclecheck)
	uw rocoto realize -c $< -o $@
