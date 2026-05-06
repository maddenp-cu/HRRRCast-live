check = @$(if $(1),,$(error $(2)= argument required))

all: rocoto.xml
	$(call check,$(cycle),cycle)
	uw rocoto iterate --cycle $(cycle) --database rocoto.db --task forecast --workflow $<

rocoto.yaml: config.yaml
	$(call check,$(cycle),cycle)
	uw config realize -i $< -o $@ --cycle $(cycle) --leadtime 6 --key-path rocoto --total

rocoto.xml: rocoto.yaml
	$(call check,$(cycle),cycle)
	uw rocoto realize -c $< -o $@
