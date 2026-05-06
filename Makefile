all: rocoto.xml
	uw rocoto iterate --cycle $(cycle) --database rocoto.db --task forecast --workflow $<

rocoto.yaml: config.yaml
	uw config realize -i $< -o $@ --cycle $(cycle) --leadtime 6 --key-path rocoto --total

rocoto.xml: rocoto.yaml
	uw rocoto realize -c $< -o $@
