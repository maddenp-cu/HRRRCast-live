datayaml   = $(rundir)/data.yaml
cyclecheck = $(if $(cycle),$(if $(cycleok),,$(error Argument cycle= must match $(cyclere))),$(error Argument cycle= required))
cyclefmt   = $(if $(cycleok),$(shell date -ud $(cycle):00:00Z +$(1)))
cycleok    = $(shell echo $(cycle) | egrep -q $(cyclere) && echo ok)
cyclere    = ^[0-9]{4}-[0-9]{2}-[0-9]{2}T[0-9]{2}$
rocotodb   = $(rundir)/rocoto.db
rocotoxml  = $(rundir)/rocoto.xml
rocotoyaml = $(rundir)/rocoto.yaml
rundir     = $(shell uw config realize -i config.yaml --key-path app.basedir)/$(call cyclefmt,%Y%m%d)/$(call cyclefmt,%H)

all: $(rocotoxml) $(datayaml)
	$(call cyclecheck)
	uw rocoto iterate --cycle $(cycle) --database $(rocotodb) --task ics --workflow $<

$(datayaml): config.yaml
	$(call cyclecheck)
	uw config realize -i $< -o $@ --cycle $(cycle) --leadtime 6 --key-path data --total

$(rocotoyaml): config.yaml
	$(call cyclecheck)
	uw config realize -i $< -o $@ --cycle $(cycle) --leadtime 6 --key-path rocoto --total

$(rocotoxml): $(rocotoyaml)
	$(call cyclecheck)
	uw rocoto realize -c $< -o $@
