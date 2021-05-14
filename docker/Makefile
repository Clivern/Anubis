help: Makefile
	@echo
	@echo " A list of all available commands:"
	@echo
	@sed -n 's/^##//p' $< | column -t -s ':' |  sed -e 's/^/ /'
	@echo


## login: Login into DO container registry.
.PHONY: login
login:
	@echo ">> ============= Loging into DO Registry  ============= <<"
	doctl registry login


## build: Build docker image locally from dockerfile.
.PHONY: build
build:
	@echo ">> ============= Build docker image  ============= <<"
	docker build -t clivern/kernel:1.0.0 -f Dockerfile.kernel .
	docker tag clivern/kernel:1.0.0 registry.digitalocean.com/clivern/kernel:1.0.0


## push: Push image to DO container registry.
.PHONY: push
push:
	@echo ">> =========== Push docker image to DO Registry  ======== <<"
	docker push registry.digitalocean.com/clivern/kernel:1.0.0


.PHONY: help
